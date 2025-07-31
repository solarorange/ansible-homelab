#!/usr/bin/env python3
"""
Ansible Homelab Service Integration Wizard
Automates the process of adding new services to the homelab stack.
"""

import os
import sys
import re
import yaml
import json
import requests
import argparse
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass
from urllib.parse import urlparse
import subprocess
import shutil

@dataclass
class ServiceInfo:
    """Service information collected from user input and repository analysis."""
    name: str
    repository_url: str
    display_name: str
    description: str
    category: str
    stage: str
    ports: List[int]
    environment_vars: Dict[str, str]
    volumes: List[str]
    dependencies: List[str]
    image: str
    version: str
    
    # Enhanced authentication configuration
    auth_enabled: bool = True
    auth_method: str = "authentik"  # Options: authentik, basic, none
    admin_email: str = ""
    admin_password: str = ""
    secret_key: str = ""
    
    # Enhanced database configuration
    database_enabled: bool = True
    database_type: str = "sqlite"  # Options: sqlite, postgresql
    database_host: str = ""
    database_port: int = 5432
    database_name: str = ""
    database_user: str = ""
    database_password: str = ""
    
    # Enhanced API configuration
    api_enabled: bool = True
    api_version: str = "v1"
    api_key: str = ""
    api_rate_limit: int = 100
    api_rate_limit_window: int = 3600
    
    # Enhanced security configuration
    security_headers: bool = True
    rate_limiting: bool = True
    rate_limit_requests: int = 100
    rate_limit_window: int = 60
    cors_enabled: bool = False
    crowdsec_enabled: bool = True
    fail2ban_enabled: bool = True
    security_enabled: bool = True
    
    # Enhanced monitoring configuration
    metrics_enabled: bool = True
    metrics_port: int = 9090
    monitoring_enabled: bool = True
    
    # Enhanced notification configuration
    notifications_enabled: bool = True
    email_enabled: bool = False
    email_host: str = ""
    email_port: int = 587
    email_username: str = ""
    email_password: str = ""
    email_from: str = ""
    discord_enabled: bool = False
    discord_webhook: str = ""
    slack_enabled: bool = False
    slack_webhook: str = ""
    
    # Enhanced performance configuration
    cache_enabled: bool = True
    cache_size: str = "256M"
    cache_ttl: int = 3600
    compression_enabled: bool = True
    compression_level: int = 6
    
    # Enhanced logging configuration
    log_level: str = "info"
    log_format: str = "json"
    log_retention: int = 30
    
    # Enhanced backup configuration
    backup_schedule: str = "0 2 * * *"  # Daily at 2 AM
    
    # Enhanced homepage configuration
    homepage_title: str = ""
    homepage_description: str = ""
    
    # Enhanced alerting configuration
    alert_channels: Optional[List[str]] = None
    
    def __post_init__(self):
        """Initialize default values after object creation."""
        if self.alert_channels is None:
            self.alert_channels = ["email", "discord", "slack"]
        
        if not self.homepage_title:
            self.homepage_title = self.display_name
        
        if not self.homepage_description:
            self.homepage_description = f"{self.display_name} - {self.description}"
        
        if not self.database_name:
            self.database_name = self.name
        
        if not self.database_user:
            self.database_user = self.name

class ServiceWizard:
    """Main wizard class for service integration."""
    
    def __init__(self, project_root: Optional[str] = None):
        self.project_root = Path(project_root) if project_root else Path.cwd()
        self.roles_dir = self.project_root / "roles"
        self.templates_dir = self.project_root / "templates"
        self.group_vars_dir = self.project_root / "group_vars" / "all"
        self.site_yml = self.project_root / "site.yml"
        
        # Validate project structure
        self._validate_project_structure()
        
        # Load existing configuration
        self.existing_services = self._load_existing_services()
        self.port_assignments = self._load_port_assignments()
        
    def _validate_project_structure(self):
        """Validate that we're in a valid Ansible homelab project."""
        required_dirs = [self.roles_dir, self.group_vars_dir]
        required_files = [self.site_yml]
        
        for dir_path in required_dirs:
            if not dir_path.exists():
                raise FileNotFoundError(f"Required directory not found: {dir_path}")
        
        for file_path in required_files:
            if not file_path.exists():
                raise FileNotFoundError(f"Required file not found: {file_path}")
    
    def _load_existing_services(self) -> List[str]:
        """Load list of existing services from group_vars."""
        try:
            with open(self.group_vars_dir / "roles.yml", 'r') as f:
                roles_config = yaml.safe_load(f)
            
            services = []
            for key, value in roles_config.items():
                if key.endswith('_enabled') and value:
                    service_name = key.replace('_enabled', '')
                    services.append(service_name)
            
            return services
        except Exception as e:
            print(f"Warning: Could not load existing services: {e}")
            return []
    
    def _load_port_assignments(self) -> Dict[str, int]:
        """Load existing port assignments from roles."""
        port_assignments = {}
        
        for role_dir in self.roles_dir.iterdir():
            if role_dir.is_dir():
                defaults_file = role_dir / "defaults" / "main.yml"
                if defaults_file.exists():
                    try:
                        with open(defaults_file, 'r') as f:
                            defaults = yaml.safe_load(f)
                        
                        # Look for port variables
                        for key, value in defaults.items():
                            if key.endswith('_port') and isinstance(value, (int, str)):
                                service_name = key.replace('_port', '')
                                try:
                                    port_assignments[service_name] = int(value)
                                except ValueError:
                                    pass
                    except Exception as e:
                        print(f"Warning: Could not load ports for {role_dir.name}: {e}")
        
        return port_assignments
    
    def _find_available_port(self, preferred_port: Optional[int] = None) -> int:
        """Find an available port, starting from preferred_port or default ranges."""
        used_ports = set(self.port_assignments.values())
        
        # Define port ranges for different service types
        port_ranges = [
            (3000, 3100),  # Web services
            (8080, 8100),  # Alternative web services
            (9000, 9100),  # Management interfaces
            (5000, 5100),  # API services
        ]
        
        # If preferred port is provided, check if it's available
        if preferred_port and preferred_port not in used_ports:
            return preferred_port
        
        # Search through port ranges for available ports
        for start_port, end_port in port_ranges:
            for port in range(start_port, end_port):
                if port not in used_ports:
                    return port
        
        # Fallback to a high port if all ranges are exhausted
        fallback_port = 10000
        while fallback_port in used_ports:
            fallback_port += 1
        
        return fallback_port
    
    def _check_port_conflicts(self, ports: List[int]) -> Tuple[List[str], List[str]]:
        """Check for port conflicts and suggest alternatives."""
        conflicts = []
        suggestions = []
        
        for port in ports:
            if port in self.port_assignments.values():
                conflicting_service = [k for k, v in self.port_assignments.items() if v == port][0]
                conflicts.append(f"Port {port} is already used by {conflicting_service}")
                
                # Find an available port
                available_port = self._find_available_port()
                suggestions.append(f"Use port {available_port} instead")
        
        return conflicts, suggestions
    
    def collect_service_info(self) -> ServiceInfo:
        """Collect service information from user input."""
        print("\n" + "="*60)
        print("ANSIBLE HOMELAB SERVICE INTEGRATION WIZARD")
        print("="*60)
        
        # Basic service information
        print("\n📋 SERVICE INFORMATION")
        print("-" * 40)
        
        service_name = input("Service Name (lowercase, no spaces): ").strip().lower()
        if not service_name:
            raise ValueError("Service name is required")
        
        # Show examples of good service names
        print(f"  ✓ Examples: jellyfin, postgres, homepage, portainer")
        print(f"  ✓ Your service will be accessible at: {service_name}.yourdomain.com")
        
        repository_url = input("Repository URL: ").strip()
        if not repository_url:
            raise ValueError("Repository URL is required")
        
        # Show examples of repository URLs
        print(f"  ✓ Examples: https://github.com/jellyfin/jellyfin")
        print(f"  ✓ Examples: https://github.com/docker-library/postgres")
        
        display_name = input("Display Name (for homepage): ").strip() or service_name.title()
        description = input("Description: ").strip() or f"{display_name} service"
        
        # Category selection with detailed examples
        print("\n📂 SERVICE CATEGORY")
        print("-" * 40)
        print("Select the category that best describes your service:")
        
        categories = ["media", "automation", "utilities", "security", "databases", "storage", "monitoring"]
        category_examples = {
            "media": "Media streaming and management (Plex, Jellyfin, Sonarr, Radarr, Tautulli)",
            "automation": "Automation and orchestration (Home Assistant, Node-RED, n8n, Portainer)",
            "utilities": "Utility and helper services (Homepage, Grafana, Uptime Kuma, Portainer)",
            "security": "Security and authentication (Authentik, Fail2ban, CrowdSec, WireGuard)",
            "databases": "Database services (PostgreSQL, Redis, MariaDB, Elasticsearch)",
            "storage": "Storage and file management (Nextcloud, Syncthing, Samba, rclone)",
            "monitoring": "Monitoring and observability (Prometheus, Grafana, Loki, Alertmanager)"
        }
        
        for i, cat in enumerate(categories, 1):
            print(f"  {i}. {cat}")
            print(f"     {category_examples[cat]}")
            print()
        
        while True:
            try:
                cat_choice = int(input(f"Select category (1-{len(categories)}): "))
                if 1 <= cat_choice <= len(categories):
                    category = categories[cat_choice - 1]
                    print(f"  ✓ Selected: {category} - {category_examples[category]}")
                    break
                else:
                    print("Invalid choice. Please try again.")
            except ValueError:
                print("Please enter a number.")
        
        # Stage selection with detailed explanations
        print("\n🚀 DEPLOYMENT STAGE")
        print("-" * 40)
        print("Select when this service should be deployed:")
        
        stages = ["stage1", "stage2", "stage3", "stage3.5"]
        stage_descriptions = {
            "stage1": "Infrastructure (security, core services) - Deploys FIRST",
            "stage2": "Core Services (databases, storage, logging) - Depends on infrastructure",
            "stage3": "Applications (media, automation, utilities) - Depends on core services",
            "stage3.5": "Dashboard and Management (homepage) - Depends on applications"
        }
        stage_examples = {
            "stage1": "Traefik, Authentik, Pi-hole, WireGuard, Fail2ban",
            "stage2": "PostgreSQL, Redis, MariaDB, Elasticsearch, Loki, Prometheus",
            "stage3": "Plex, Jellyfin, Sonarr, Home Assistant, Portainer, Grafana",
            "stage3.5": "Homepage, Uptime Kuma, monitoring dashboards"
        }
        
        for stage in stages:
            print(f"  {stage}: {stage_descriptions[stage]}")
            print(f"     Examples: {stage_examples[stage]}")
            print()
        
        stage_input = input("Select stage (default: stage3): ").strip() or "stage3"
        
        # Handle both stage names and numbers
        if stage_input in stages:
            stage = stage_input
        elif stage_input in ["1", "2", "3", "3.5"]:
            stage_map = {"1": "stage1", "2": "stage2", "3": "stage3", "3.5": "stage3.5"}
            stage = stage_map[stage_input]
        else:
            print(f"  ⚠️  Invalid stage '{stage_input}', using default: stage3")
            stage = "stage3"
        
        print(f"  ✓ Selected: {stage} - {stage_descriptions[stage]}")
        
        print(f"\n🔍 ANALYZING REPOSITORY")
        print("-" * 40)
        print(f"Analyzing: {repository_url}")
        print("  ✓ Extracting Docker configuration...")
        print("  ✓ Detecting ports and environment variables...")
        print("  ✓ Identifying dependencies...")
        
        # Analyze repository for additional information
        print(f"\nAnalyzing repository: {repository_url}")
        repo_info = self._analyze_repository(repository_url)
        
        # Check for port conflicts and suggest alternatives
        if repo_info.get('ports'):
            conflicts, suggestions = self._check_port_conflicts(repo_info['ports'])
            
            if conflicts:
                print(f"\n⚠️  PORT CONFLICTS DETECTED")
                print("-" * 40)
                for conflict in conflicts:
                    print(f"  • {conflict}")
                
                print(f"\n🔧 PORT REMEDIATION")
                print("-" * 40)
                for i, suggestion in enumerate(suggestions, 1):
                    print(f"  {i}. {suggestion}")
                
                # Automatically resolve conflicts
                resolved_ports = []
                for i, port in enumerate(repo_info['ports']):
                    if port in [v for v in self.port_assignments.values()]:
                        # Use suggested port
                        available_port = self._find_available_port()
                        resolved_ports.append(available_port)
                        print(f"  ✓ Resolved: Port {port} → {available_port}")
                    else:
                        resolved_ports.append(port)
                
                repo_info['ports'] = resolved_ports
                print(f"  ✓ All port conflicts automatically resolved")
        
        return ServiceInfo(
            name=service_name,
            repository_url=repository_url,
            display_name=display_name,
            description=description,
            category=category,
            stage=stage,
            ports=repo_info.get('ports', []),
            environment_vars=repo_info.get('environment_vars', {}),
            volumes=repo_info.get('volumes', []),
            dependencies=repo_info.get('dependencies', []),
            image=repo_info.get('image', f"{service_name}:latest"),
            version=repo_info.get('version', 'latest')
        )
        
        # Enhanced configuration collection
        print(f"\n🔧 {display_name} Enhanced Configuration")
        print("="*50)
        
        # Get domain for configuration
        domain = self._get_domain()
        
        # Authentication configuration
        print(f"\n🔐 Authentication Configuration:")
        auth_enabled = input(f"Enable authentication for {display_name}? (y/n) [y]: ").lower() != 'n'
        if auth_enabled:
            auth_method = input(f"Authentication method (authentik/basic/none) [authentik]: ") or "authentik"
            admin_email = input(f"Admin email for {display_name} [{{ admin_email | default("admin@" + domain) }} ") or f"{{ admin_email | default("admin@" + domain) }}"
        else:
            auth_method = "none"
            admin_email = ""
        
        # Database configuration
        print(f"\n🗄️ Database Configuration:")
        database_enabled = input(f"Enable database for {display_name}? (y/n) [y]: ").lower() != 'n'
        if database_enabled:
            database_type = input(f"Database type (sqlite/postgresql) [sqlite]: ") or "sqlite"
            database_host = ""
            database_port = 5432
            database_name = service_name
            database_user = service_name
            
            if database_type == "postgresql":
                database_host = input(f"Database host [{{ ansible_default_ipv4.address }}]: ") or "{{ ansible_default_ipv4.address }}"
                database_port = int(input(f"Database port [5432]: ") or "5432")
                database_name = input(f"Database name [{service_name}]: ") or service_name
                database_user = input(f"Database user [{service_name}]: ") or service_name
        else:
            database_type = "sqlite"
            database_host = ""
            database_port = 5432
            database_name = service_name
            database_user = service_name
        
        # API configuration
        print(f"\n🔌 API Configuration:")
        api_enabled = input(f"Enable API for {display_name}? (y/n) [y]: ").lower() != 'n'
        if api_enabled:
            api_version = input(f"API version [v1]: ") or "v1"
            api_rate_limit = int(input(f"API rate limit (requests per window) [100]: ") or "100")
            api_rate_limit_window = int(input(f"API rate limit window (seconds) [3600]: ") or "3600")
        else:
            api_version = "v1"
            api_rate_limit = 100
            api_rate_limit_window = 3600
        
        # Security configuration
        print(f"\n🛡️ Security Configuration:")
        security_headers = input(f"Enable security headers for {display_name}? (y/n) [y]: ").lower() != 'n'
        rate_limiting = input(f"Enable rate limiting for {display_name}? (y/n) [y]: ").lower() != 'n'
        cors_enabled = input(f"Enable CORS for {display_name}? (y/n) [n]: ").lower() == 'y'
        crowdsec_enabled = input(f"Enable CrowdSec for {display_name}? (y/n) [y]: ").lower() != 'n'
        fail2ban_enabled = input(f"Enable Fail2ban for {display_name}? (y/n) [y]: ").lower() != 'n'
        
        rate_limit_requests = 100
        rate_limit_window = 60
        if rate_limiting:
            rate_limit_requests = int(input(f"Rate limit requests [100]: ") or "100")
            rate_limit_window = int(input(f"Rate limit window (seconds) [60]: ") or "60")
        
        # Monitoring configuration
        print(f"\n📊 Monitoring Configuration:")
        monitoring_enabled = input(f"Enable monitoring for {display_name}? (y/n) [y]: ").lower() != 'n'
        metrics_enabled = input(f"Enable metrics for {display_name}? (y/n) [y]: ").lower() != 'n'
        metrics_port = 9090
        if metrics_enabled:
            metrics_port = int(input(f"Metrics port [9090]: ") or "9090")
        
        # Notification configuration
        print(f"\n🔔 Notification Configuration:")
        notifications_enabled = input(f"Enable notifications for {display_name}? (y/n) [y]: ").lower() != 'n'
        email_enabled = False
        discord_enabled = False
        slack_enabled = False
        email_host = ""
        email_port = 587
        email_username = ""
        email_from = f"{service_name}@{domain}"
        
        if notifications_enabled:
            email_enabled = input(f"Enable email notifications? (y/n) [n]: ").lower() == 'y'
            discord_enabled = input(f"Enable Discord notifications? (y/n) [n]: ").lower() == 'y'
            slack_enabled = input(f"Enable Slack notifications? (y/n) [n]: ").lower() == 'y'
            
            if email_enabled:
                email_host = input(f"SMTP host: ") or ""
                email_port = int(input(f"SMTP port [587]: ") or "587")
                email_username = input(f"SMTP username: ") or ""
        
        # Performance configuration
        print(f"\n⚡ Performance Configuration:")
        cache_enabled = input(f"Enable caching for {display_name}? (y/n) [y]: ").lower() != 'n'
        compression_enabled = input(f"Enable compression for {display_name}? (y/n) [y]: ").lower() != 'n'
        
        cache_size = "256M"
        cache_ttl = 3600
        compression_level = 6
        
        if cache_enabled:
            cache_size = input(f"Cache size [256M]: ") or "256M"
            cache_ttl = int(input(f"Cache TTL (seconds) [3600]: ") or "3600")
        
        if compression_enabled:
            compression_level = int(input(f"Compression level (1-9) [6]: ") or "6")
        
        # Logging configuration
        print(f"\n📝 Logging Configuration:")
        log_level = input(f"Log level (debug/info/warn/error) [info]: ") or "info"
        log_format = input(f"Log format (json/text) [json]: ") or "json"
        log_retention = int(input(f"Log retention (days) [30]: ") or "30")
        
        # Backup configuration
        print(f"\n💾 Backup Configuration:")
        backup_schedule = input(f"Backup schedule (cron format) [0 2 * * *]: ") or "0 2 * * *"
        
        # Homepage configuration
        print(f"\n🏠 Homepage Configuration:")
        homepage_title = input(f"Homepage title [{display_name}]: ") or display_name
        homepage_description = input(f"Homepage description [{description}]: ") or description
        
        # Alerting configuration
        print(f"\n🚨 Alerting Configuration:")
        alert_channels_input = input(f"Alert channels (comma-separated: email,discord,slack) [email,discord,slack]: ") or "email,discord,slack"
        alert_channels = [channel.strip() for channel in alert_channels_input.split(",")]
        
        # Create enhanced ServiceInfo object
        service_info = ServiceInfo(
            name=service_name,
            repository_url=repository_url,
            display_name=display_name,
            description=description,
            category=category,
            stage=stage,
            ports=repo_info.get('ports', []),
            environment_vars=repo_info.get('environment_vars', {}),
            volumes=repo_info.get('volumes', []),
            dependencies=repo_info.get('dependencies', []),
            image=repo_info.get('image', f"{service_name}:latest"),
            version=repo_info.get('version', 'latest'),
            # Enhanced authentication configuration
            auth_enabled=auth_enabled,
            auth_method=auth_method,
            admin_email=admin_email,
            # Enhanced database configuration
            database_enabled=database_enabled,
            database_type=database_type,
            database_host=database_host,
            database_port=database_port,
            database_name=database_name,
            database_user=database_user,
            # Enhanced API configuration
            api_enabled=api_enabled,
            api_version=api_version,
            api_rate_limit=api_rate_limit,
            api_rate_limit_window=api_rate_limit_window,
            # Enhanced security configuration
            security_headers=security_headers,
            rate_limiting=rate_limiting,
            rate_limit_requests=rate_limit_requests,
            rate_limit_window=rate_limit_window,
            cors_enabled=cors_enabled,
            crowdsec_enabled=crowdsec_enabled,
            fail2ban_enabled=fail2ban_enabled,
            # Enhanced monitoring configuration
            monitoring_enabled=monitoring_enabled,
            metrics_enabled=metrics_enabled,
            metrics_port=metrics_port,
            # Enhanced notification configuration
            notifications_enabled=notifications_enabled,
            email_enabled=email_enabled,
            email_host=email_host,
            email_port=email_port,
            email_username=email_username,
            email_from=email_from,
            discord_enabled=discord_enabled,
            slack_enabled=slack_enabled,
            # Enhanced performance configuration
            cache_enabled=cache_enabled,
            cache_size=cache_size,
            cache_ttl=cache_ttl,
            compression_enabled=compression_enabled,
            compression_level=compression_level,
            # Enhanced logging configuration
            log_level=log_level,
            log_format=log_format,
            log_retention=log_retention,
            # Enhanced backup configuration
            backup_schedule=backup_schedule,
            # Enhanced homepage configuration
            homepage_title=homepage_title,
            homepage_description=homepage_description,
            # Enhanced alerting configuration
            alert_channels=alert_channels
        )
        
        return service_info
    
    def _analyze_repository(self, repository_url: str) -> Dict:
        """Analyze repository to extract configuration information."""
        repo_info = {
            'ports': [],
            'environment_vars': {},
            'volumes': [],
            'dependencies': [],
            'image': '',
            'version': 'latest'
        }
        
        try:
            # Parse repository URL
            parsed_url = urlparse(repository_url)
            if 'github.com' in parsed_url.netloc:
                # Try to get repository info from GitHub API
                repo_path = parsed_url.path.strip('/')
                api_url = f"https://api.github.com/repos/{repo_path}"
                
                response = requests.get(api_url, timeout=10)
                if response.status_code == 200:
                    repo_data = response.json()
                    repo_info['description'] = repo_data.get('description', '')
                    
                    # Try to find docker-compose.yml or similar files
                    files_url = f"https://api.github.com/repos/{repo_path}/contents"
                    files_response = requests.get(files_url, timeout=10)
                    if files_response.status_code == 200:
                        files = files_response.json()
                        for file_info in files:
                            if file_info['name'] in ['docker-compose.yml', 'docker-compose.yaml', 'compose.yml', 'docker-compose.override.yml']:
                                compose_url = file_info['download_url']
                                compose_response = requests.get(compose_url, timeout=10)
                                if compose_response.status_code == 200:
                                    compose_data = yaml.safe_load(compose_response.text)
                                    repo_info.update(self._parse_docker_compose(compose_data))
                                    break
                        
                        # Also check for Dockerfile or other config files
                        for file_info in files:
                            if file_info['name'] in ['Dockerfile', 'docker-compose.yml', 'docker-compose.yaml']:
                                file_url = file_info['download_url']
                                file_response = requests.get(file_url, timeout=10)
                                if file_response.status_code == 200:
                                    if file_info['name'] == 'Dockerfile':
                                        self._parse_dockerfile(file_response.text, repo_info)
                                    elif file_info['name'] in ['docker-compose.yml', 'docker-compose.yaml']:
                                        compose_data = yaml.safe_load(file_response.text)
                                        repo_info.update(self._parse_docker_compose(compose_data))
            
            # Service-specific configurations
            if 'rommapp' in repository_url:
                repo_info.update({
                    'image': 'ghcr.io/rommapp/romm:latest',
                    'version': 'latest',
                    'ports': [3000],  # RomM default port
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}',
                        'PUID': '{{ ansible_user_id | default(1000) }}',
                        'PGID': '{{ ansible_user_id | default(1000) }}'
                    },
                    'volumes': [
                        '{{ docker_data_root }}/romm:/data',
                        '{{ docker_config_root }}/romm:/config',
                        '{{ docker_logs_root }}/romm:/logs'
                    ],
                    'dependencies': []
                })
            elif 'jellyfin' in repository_url:
                repo_info.update({
                    'image': 'jellyfin/jellyfin:latest',
                    'version': 'latest',
                    'ports': [8096],
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}',
                        'PUID': '{{ ansible_user_id | default(1000) }}',
                        'PGID': '{{ ansible_user_id | default(1000) }}'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/jellyfin:/config',
                        '{{ docker_data_root }}/media:/media',
                        '{{ docker_logs_root }}/jellyfin:/logs'
                    ],
                    'dependencies': []
                })
            elif 'plex' in repository_url:
                repo_info.update({
                    'image': 'plexinc/pms-docker:latest',
                    'version': 'latest',
                    'ports': [32400],
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}',
                        'PUID': '{{ ansible_user_id | default(1000) }}',
                        'PGID': '{{ ansible_user_id | default(1000) }}'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/plex:/config',
                        '{{ docker_data_root }}/media:/media',
                        '{{ docker_logs_root }}/plex:/logs'
                    ],
                    'dependencies': []
                })
            elif 'sonarr' in repository_url:
                repo_info.update({
                    'image': 'linuxserver/sonarr:latest',
                    'version': 'latest',
                    'ports': [8989],
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}',
                        'PUID': '{{ ansible_user_id | default(1000) }}',
                        'PGID': '{{ ansible_user_id | default(1000) }}'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/sonarr:/config',
                        '{{ docker_data_root }}/media:/media',
                        '{{ docker_logs_root }}/sonarr:/logs'
                    ],
                    'dependencies': []
                })
            elif 'radarr' in repository_url:
                repo_info.update({
                    'image': 'linuxserver/radarr:latest',
                    'version': 'latest',
                    'ports': [7878],
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}',
                        'PUID': '{{ ansible_user_id | default(1000) }}',
                        'PGID': '{{ ansible_user_id | default(1000) }}'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/radarr:/config',
                        '{{ docker_data_root }}/media:/media',
                        '{{ docker_logs_root }}/radarr:/logs'
                    ],
                    'dependencies': []
                })
            elif 'homepage' in repository_url:
                repo_info.update({
                    'image': 'ghcr.io/benphelps/homepage:latest',
                    'version': 'latest',
                    'ports': [3000],
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}',
                        'PUID': '{{ ansible_user_id | default(1000) }}',
                        'PGID': '{{ ansible_user_id | default(1000) }}'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/homepage:/app/config',
                        '{{ docker_data_root }}/homepage:/app/data',
                        '{{ docker_logs_root }}/homepage:/app/logs'
                    ],
                    'dependencies': []
                })
            elif 'portainer' in repository_url:
                repo_info.update({
                    'image': 'portainer/portainer-ce:latest',
                    'version': 'latest',
                    'ports': [9000],
                    'environment_vars': {
                        'TZ': '{{ timezone | default("UTC") }}'
                    },
                    'volumes': [
                        '/var/run/docker.sock:/var/run/docker.sock',
                        '{{ docker_config_root }}/portainer:/data'
                    ],
                    'dependencies': []
                })
            elif 'grafana' in repository_url:
                repo_info.update({
                    'image': 'grafana/grafana:latest',
                    'version': 'latest',
                    'ports': [3000],
                    'environment_vars': {
                        'GF_SECURITY_ADMIN_PASSWORD': '{{ vault_grafana_admin_password | default("admin") }}',
                        'GF_USERS_ALLOW_SIGN_UP': 'false'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/grafana:/etc/grafana',
                        '{{ docker_data_root }}/grafana:/var/lib/grafana',
                        '{{ docker_logs_root }}/grafana:/var/log/grafana'
                    ],
                    'dependencies': []
                })
            elif 'prometheus' in repository_url:
                repo_info.update({
                    'image': 'prom/prometheus:latest',
                    'version': 'latest',
                    'ports': [9090],
                    'environment_vars': {},
                    'volumes': [
                        '{{ docker_config_root }}/prometheus:/etc/prometheus',
                        '{{ docker_data_root }}/prometheus:/prometheus',
                        '{{ docker_logs_root }}/prometheus:/var/log/prometheus'
                    ],
                    'dependencies': []
                })
            elif 'authentik' in repository_url:
                repo_info.update({
                    'image': 'ghcr.io/goauthentik/server:latest',
                    'version': 'latest',
                    'ports': [9000],
                    'environment_vars': {
                        'AUTHENTIK_SECRET_KEY': '{{ vault_authentik_secret_key | default("") }}',
                        'AUTHENTIK_POSTGRESQL__HOST': '{{ postgresql_host | default("postgresql") }}',
                        'AUTHENTIK_POSTGRESQL__USER': '{{ postgresql_user | default("authentik") }}',
                        'AUTHENTIK_POSTGRESQL__PASSWORD': '{{ vault_authentik_postgres_password | default("") }}',
                        'AUTHENTIK_POSTGRESQL__NAME': '{{ postgresql_database | default("authentik") }}',
                        'AUTHENTIK_REDIS__HOST': '{{ redis_host | default("redis") }}',
                        'AUTHENTIK_REDIS__PASSWORD': '{{ vault_redis_password | default("") }}'
                    },
                    'volumes': [
                        '{{ docker_config_root }}/authentik:/media',
                        '{{ docker_data_root }}/authentik:/media/backups',
                        '{{ docker_logs_root }}/authentik:/var/log/authentik'
                    ],
                    'dependencies': ['postgresql', 'redis']
                })
            else:
                # If we couldn't get info from API, try to extract from URL
                if not repo_info['image']:
                    repo_name = parsed_url.path.split('/')[-1]
                    repo_info['image'] = f"{repo_name}:latest"
                
        except Exception as e:
            print(f"Warning: Could not analyze repository: {e}")
        
        return repo_info
    
    def _parse_dockerfile(self, dockerfile_content: str, repo_info: Dict):
        """Parse Dockerfile to extract image information."""
        lines = dockerfile_content.split('\n')
        for line in lines:
            line = line.strip()
            if line.startswith('FROM '):
                image = line[5:].strip()
                if ':' in image:
                    repo_info['image'] = image
                    repo_info['version'] = image.split(':')[-1]
                else:
                    repo_info['image'] = image
                break
    
    def _parse_docker_compose(self, compose_data: Dict) -> Dict:
        """Parse Docker Compose data to extract configuration."""
        info = {
            'ports': [],
            'environment_vars': {},
            'volumes': [],
            'dependencies': [],
            'image': '',
            'version': 'latest'
        }
        
        if 'services' in compose_data:
            for service_name, service_config in compose_data['services'].items():
                # Extract image
                if 'image' in service_config:
                    info['image'] = service_config['image']
                    if ':' in info['image']:
                        info['version'] = info['image'].split(':')[-1]
                
                # Extract ports
                if 'ports' in service_config:
                    for port_mapping in service_config['ports']:
                        if isinstance(port_mapping, str):
                            # Format: "8080:80" or "8080"
                            port_parts = port_mapping.split(':')
                            if len(port_parts) >= 1:
                                try:
                                    port = int(port_parts[0])
                                    info['ports'].append(port)
                                except ValueError:
                                    pass
                
                # Extract environment variables
                if 'environment' in service_config:
                    for env_var in service_config['environment']:
                        if isinstance(env_var, str) and '=' in env_var:
                            key, value = env_var.split('=', 1)
                            info['environment_vars'][key] = value
                
                # Extract volumes
                if 'volumes' in service_config:
                    for volume in service_config['volumes']:
                        if isinstance(volume, str) and ':' in volume:
                            # Format: "/host/path:/container/path"
                            host_path = volume.split(':')[0]
                            if host_path.startswith('./') or host_path.startswith('/'):
                                info['volumes'].append(volume)
                
                # Extract dependencies
                if 'depends_on' in service_config:
                    info['dependencies'].extend(service_config['depends_on'])
        
        return info
    
    def generate_role_structure(self, service_info: ServiceInfo):
        """Generate the complete role structure for the new service."""
        role_dir = self.roles_dir / service_info.name
        
        print(f"\nGenerating role structure for {service_info.name}...")
        
        # Create role directory structure
        directories = [
            role_dir,
            role_dir / "tasks",
            role_dir / "templates",
            role_dir / "defaults",
            role_dir / "vars",
            role_dir / "handlers",
        ]
        
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
        
        # Generate all role files
        self._generate_defaults(service_info, role_dir)
        self._generate_tasks(service_info, role_dir)
        self._generate_templates(service_info, role_dir)
        self._generate_handlers(service_info, role_dir)
        self._generate_readme(service_info, role_dir)
        
        print(f"✓ Role structure created: {role_dir}")
    
    def _generate_defaults(self, service_info: ServiceInfo, role_dir: Path):
        """Generate defaults/main.yml for the role."""
        defaults_content = f"""---
# {service_info.display_name} Role Default Variables
# Enhanced for seamless automatic deployment

# =============================================================================
# CORE CONFIGURATION
# =============================================================================

# Service enablement
{service_info.name}_enabled: true

# Container configuration
{service_info.name}_image: "{service_info.image}"
{service_info.name}_version: "{service_info.version}"
{service_info.name}_container_name: "{service_info.name}"
{service_info.name}_restart_policy: "unless-stopped"

# Port configuration
{service_info.name}_port: {service_info.ports[0] if service_info.ports else 8080}
{service_info.name}_external_port: "{service_info.ports[0] if service_info.ports else 8080}"
{service_info.name}_internal_port: "{service_info.ports[0] if service_info.ports else 8080}"

# Domain configuration
{service_info.name}_domain: "{service_info.name}.{{{{ domain | default('{{ ansible_default_ipv4.address }}') }}}}"
{service_info.name}_subdomain: "{service_info.name}"

# =============================================================================
# AUTHENTICATION CONFIGURATION
# =============================================================================

{service_info.name}_auth_enabled: {str(service_info.auth_enabled).lower()}
{service_info.name}_auth_method: "{service_info.auth_method}"
{service_info.name}_admin_email: "{{{{ admin_email | default('{{ admin_email | default("admin@" + domain) }} + domain) }}}}"
{service_info.name}_admin_password: "{{ vault_service_password }}"') }}}}"
{service_info.name}_secret_key: "{{{{ vault_{service_info.name}_secret_key | default('') }}}}"

# =============================================================================
# DATABASE CONFIGURATION
# =============================================================================

{service_info.name}_database_enabled: {str(service_info.database_enabled).lower()}
{service_info.name}_database_type: "{service_info.database_type}"
{service_info.name}_database_host: "{{{{ postgresql_host | default('{{ ansible_default_ipv4.address }}') }}}}"
{service_info.name}_database_port: {service_info.database_port}
{service_info.name}_database_name: "{service_info.database_name}"
{service_info.name}_database_user: "{{ vault_service_user }}"
{service_info.name}_database_password: "{{ vault_service_password }}"') }}}}"

# =============================================================================
# TRAEFIK INTEGRATION
# =============================================================================

{service_info.name}_traefik_enabled: true
{service_info.name}_traefik_middleware: ""
{service_info.name}_traefik_network: "homelab"
{service_info.name}_traefik_ssl_enabled: true

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================

{service_info.name}_monitoring_enabled: {str(service_info.monitoring_enabled).lower()}
{service_info.name}_healthcheck_enabled: true
{service_info.name}_healthcheck_interval: "30s"
{service_info.name}_healthcheck_timeout: "10s"
{service_info.name}_healthcheck_retries: 3
{service_info.name}_healthcheck_start_period: "40s"
{service_info.name}_metrics_enabled: {str(service_info.metrics_enabled).lower()}
{service_info.name}_metrics_port: {service_info.metrics_port}

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================

{service_info.name}_security_enabled: {str(service_info.security_enabled).lower()}
{service_info.name}_read_only: false
{service_info.name}_no_new_privileges: true
{service_info.name}_security_headers: {str(service_info.security_headers).lower()}
{service_info.name}_rate_limiting: {str(service_info.rate_limiting).lower()}
{service_info.name}_rate_limit_requests: {service_info.rate_limit_requests}
{service_info.name}_rate_limit_window: {service_info.rate_limit_window}
{service_info.name}_cors_enabled: {str(service_info.cors_enabled).lower()}
{service_info.name}_crowdsec_enabled: {str(service_info.crowdsec_enabled).lower()}
{service_info.name}_fail2ban_enabled: {str(service_info.fail2ban_enabled).lower()}

# =============================================================================
# BACKUP CONFIGURATION
# =============================================================================

{service_info.name}_backup_enabled: true
{service_info.name}_backup_retention_days: 30
{service_info.name}_backup_include_data: true
{service_info.name}_backup_include_config: true
{service_info.name}_backup_schedule: "{service_info.backup_schedule}"

# =============================================================================
# HOMEPAGE INTEGRATION
# =============================================================================

{service_info.name}_homepage_enabled: true
{service_info.name}_homepage_group: "{service_info.category}"
{service_info.name}_homepage_icon: "{service_info.name}"
{service_info.name}_homepage_title: "{service_info.homepage_title}"
{service_info.name}_homepage_description: "{service_info.homepage_description}"

# =============================================================================
# ALERTING CONFIGURATION
# =============================================================================

{service_info.name}_alerting_enabled: true
{service_info.name}_alert_severity: "warning"
{service_info.name}_alert_channels: {service_info.alert_channels}

# =============================================================================
# RESOURCE LIMITS
# =============================================================================

{service_info.name}_memory_limit: "512M"
{service_info.name}_memory_reservation: "256M"
{service_info.name}_cpu_limit: "0.5"
{service_info.name}_cpu_reservation: "0.25"
{service_info.name}_storage_limit: "10G"

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

{service_info.name}_environment:
"""
        
        # Add environment variables
        for key, value in service_info.environment_vars.items():
            defaults_content += f"  {key}: \"{value}\"\n"
        
        # Add comprehensive environment variables
        defaults_content += f"""  TZ: "{{{{ timezone | default('UTC') }}}}"
  PUID: "{{{{ ansible_user_id | default(1000) }}}}"
  PGID: "{{{{ ansible_user_id | default(1000) }}}}"
  {service_info.name.upper()}_DOMAIN: "{{{{ {service_info.name}_domain }}}}"
  {service_info.name.upper()}_SECRET_KEY: "{{{{ vault_{service_info.name}_secret_key | default('') }}}}"
  {service_info.name.upper()}_ADMIN_EMAIL: "{{{{ {service_info.name}_admin_email }}}}"
  {service_info.name.upper()}_ADMIN_password: "{{ vault_service_password }}"') }}}}"
  {service_info.name.upper()}_DATABASE_TYPE: "{{{{ {service_info.name}_database_type }}}}"
"""
        
        # Add database environment variables if database is enabled
        if service_info.database_enabled and service_info.database_type == "postgresql":
            defaults_content += f"""  {service_info.name.upper()}_DATABASE_HOST: "{{{{ {service_info.name}_database_host }}}}"
  {service_info.name.upper()}_DATABASE_PORT: "{{{{ {service_info.name}_database_port }}}}"
  {service_info.name.upper()}_DATABASE_NAME: "{{{{ {service_info.name}_database_name }}}}"
  {service_info.name.upper()}_DATABASE_user: "{{ vault_service_user }}"
  {service_info.name.upper()}_DATABASE_password: "{{ vault_service_password }}"') }}}}"
"""
        
        # Add API environment variables
        defaults_content += f"""  {service_info.name.upper()}_AUTH_ENABLED: "{{{{ {service_info.name}_auth_enabled | lower }}}}"
  {service_info.name.upper()}_AUTH_METHOD: "{{{{ {service_info.name}_auth_method }}}}"
  {service_info.name.upper()}_MONITORING_ENABLED: "{{{{ {service_info.name}_monitoring_enabled | lower }}}}"
  {service_info.name.upper()}_METRICS_ENABLED: "{{{{ {service_info.name}_metrics_enabled | lower }}}}"
  {service_info.name.upper()}_SECURITY_HEADERS: "{{{{ {service_info.name}_security_headers | lower }}}}"
  {service_info.name.upper()}_RATE_LIMITING: "{{{{ {service_info.name}_rate_limiting | lower }}}}"
  {service_info.name.upper()}_RATE_LIMIT_REQUESTS: "{{{{ {service_info.name}_rate_limit_requests }}}}"
  {service_info.name.upper()}_RATE_LIMIT_WINDOW: "{{{{ {service_info.name}_rate_limit_window }}}}"
  {service_info.name.upper()}_CORS_ENABLED: "{{{{ {service_info.name}_cors_enabled | lower }}}}"

# =============================================================================
# VOLUME CONFIGURATION
# =============================================================================

{service_info.name}_volumes:
"""
        
        # Add volumes
        for volume in service_info.volumes:
            defaults_content += f"  - {volume}\n"
        
        # Add common volumes
        defaults_content += f"""  - "{{{{ docker_data_root }}}}/{service_info.name}:/data"
  - "{{{{ docker_config_root }}}}/{service_info.name}:/config"
  - "{{{{ docker_logs_root }}}}/{service_info.name}:/logs"
  - "{{{{ docker_backup_root }}}}/{service_info.name}:/backups"

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

{service_info.name}_networks:
  - homelab
  - default

# =============================================================================
# DEPENDENCIES
# =============================================================================

{service_info.name}_dependencies:
"""
        
        for dependency in service_info.dependencies:
            defaults_content += f"  - {dependency}\n"
        
        # Add comprehensive configuration sections
        defaults_content += f"""
# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

{service_info.name}_log_level: "{service_info.log_level}"
{service_info.name}_log_format: "{service_info.log_format}"
{service_info.name}_log_retention: {service_info.log_retention}

# =============================================================================
# PERFORMANCE CONFIGURATION
# =============================================================================

{service_info.name}_cache_enabled: {str(service_info.cache_enabled).lower()}
{service_info.name}_cache_size: "{service_info.cache_size}"
{service_info.name}_cache_ttl: {service_info.cache_ttl}
{service_info.name}_compression_enabled: {str(service_info.compression_enabled).lower()}
{service_info.name}_compression_level: {service_info.compression_level}

# =============================================================================
# API CONFIGURATION
# =============================================================================

{service_info.name}_api_enabled: {str(service_info.api_enabled).lower()}
{service_info.name}_api_version: "{service_info.api_version}"
{service_info.name}_api_key: "{{{{ vault_{service_info.name}_api_key | default('') }}}}"
{service_info.name}_api_rate_limit: {service_info.api_rate_limit}
{service_info.name}_api_rate_limit_window: {service_info.api_rate_limit_window}

# =============================================================================
# NOTIFICATION CONFIGURATION
# =============================================================================

{service_info.name}_notifications_enabled: {str(service_info.notifications_enabled).lower()}
{service_info.name}_email_enabled: {str(service_info.email_enabled).lower()}
{service_info.name}_email_host: "{{{{ smtp_host | default('') }}}}"
{service_info.name}_email_port: {service_info.email_port}
{service_info.name}_email_username: "{{{{ vault_smtp_username | default('') }}}}"
{service_info.name}_email_password: "{{ vault_service_password }}"') }}}}"
{service_info.name}_email_from: "{service_info.name}@{{{{ domain }}}}"
{service_info.name}_discord_enabled: {str(service_info.discord_enabled).lower()}
{service_info.name}_discord_webhook: "{{{{ vault_discord_webhook | default('') }}}}"
{service_info.name}_slack_enabled: {str(service_info.slack_enabled).lower()}
{service_info.name}_slack_webhook: "{{{{ vault_slack_webhook | default('') }}}}"
"""
        
        with open(role_dir / "defaults" / "main.yml", 'w') as f:
            f.write(defaults_content)
    
    def _generate_tasks(self, service_info: ServiceInfo, role_dir: Path):
        """Generate task files for the role."""
        tasks_dir = role_dir / "tasks"
        
        # Main tasks file
        main_tasks = f"""---
# {service_info.display_name} Role Tasks

- name: Include deployment tasks
  include_tasks: deploy.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, deploy]

- name: Include validation tasks
  include_tasks: validate.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, validate]

- name: Include monitoring tasks
  include_tasks: monitoring.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, monitoring]

- name: Include backup tasks
  include_tasks: backup.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, backup]

- name: Include security tasks
  include_tasks: security.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, security]

- name: Include homepage integration tasks
  include_tasks: homepage.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, homepage]
"""
        
        with open(tasks_dir / "main.yml", 'w') as f:
            f.write(main_tasks)
        
        # Deploy tasks
        deploy_tasks = f"""---
# {service_info.display_name} Deployment Tasks

- name: Create {service_info.display_name} directories
  file:
    path: "{{{{ item }}}}"
    state: directory
    mode: '0755'
    owner: "{{{{ ansible_user }}}}"
    group: "{{{{ ansible_user }}}}"
  loop:
    - "{{{{ docker_data_root }}}}/{service_info.name}"
    - "{{{{ docker_config_root }}}}/{service_info.name}"
    - "{{{{ docker_logs_root }}}}/{service_info.name}"
    - "{{{{ docker_backup_root }}}}/{service_info.name}"
  tags: [{service_info.name}, deploy]

- name: Generate {service_info.display_name} environment file
  template:
    src: env.j2
    dest: "{{{{ docker_config_root }}}}/{service_info.name}/.env"
    mode: '0644'
    owner: "{{{{ ansible_user }}}}"
    group: "{{{{ ansible_user }}}}"
  notify: restart {service_info.name}
  tags: [{service_info.name}, deploy]

- name: Deploy {service_info.display_name} Docker Compose
  template:
    src: docker-compose.yml.j2
    dest: "{{{{ docker_root }}}}/{service_info.name}/docker-compose.yml"
    mode: '0644'
    owner: "{{{{ ansible_user }}}}"
    group: "{{{{ ansible_user }}}}"
  notify: restart {service_info.name}
  tags: [{service_info.name}, deploy]

- name: Start {service_info.display_name} container
  docker_compose:
    project_src: "{{{{ docker_root }}}}/{service_info.name}"
    state: present
    restarted: yes
  tags: [{service_info.name}, deploy]

- name: Wait for {service_info.display_name} to be ready
  uri:
    url: "http://{{ ansible_default_ipv4.address }}:{{{{ {service_info.name}_external_port }}}}"
    status_code: 200
  register: result
  until: result.status == 200
  retries: 30
  delay: 10
  tags: [{service_info.name}, deploy]

- name: Setup {service_info.display_name} authentication
  include_tasks: auth_setup.yml
  when: {service_info.name}_auth_enabled | default(true)
  tags: [{service_info.name}, deploy, auth]

- name: Setup {service_info.display_name} database
  include_tasks: database_setup.yml
  when: {service_info.name}_database_enabled | default(true)
  tags: [{service_info.name}, deploy, database]

- name: Setup {service_info.display_name} API
  include_tasks: api_setup.yml
  when: {service_info.name}_api_enabled | default(true)
  tags: [{service_info.name}, deploy, api]
"""
        
        with open(tasks_dir / "deploy.yml", 'w') as f:
            f.write(deploy_tasks)
        
        # Authentication setup tasks
        auth_tasks = f"""---
# {service_info.display_name} Authentication Setup

- name: Check if {service_info.display_name} admin user exists
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/users"
    method: GET
    headers:
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
  register: admin_check
  ignore_errors: yes
  tags: [{service_info.name}, auth]

- name: Create {service_info.display_name} admin user
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/users"
    method: POST
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      email: "{{{{ {service_info.name}_admin_email }}}}"
      password: "{{ vault_service_password }}"') }}}}"
      role: "admin"
  when: admin_check.status is not defined or admin_check.status != 200
  tags: [{service_info.name}, auth]

- name: Configure {service_info.display_name} authentication method
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/auth/config"
    method: PUT
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      method: "{{{{ {service_info.name}_auth_method }}}}"
      enabled: "{{{{ {service_info.name}_auth_enabled | lower }}}}"
  tags: [{service_info.name}, auth]
"""
        
        with open(tasks_dir / "auth_setup.yml", 'w') as f:
            f.write(auth_tasks)
        
        # Database setup tasks
        database_tasks = f"""---
# {service_info.display_name} Database Setup

- name: Check {service_info.display_name} database connection
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/health/database"
    method: GET
  register: db_check
  ignore_errors: yes
  tags: [{service_info.name}, database]

- name: Initialize {service_info.display_name} database
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/database/init"
    method: POST
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      database_type: "{{{{ {service_info.name}_database_type }}}}"
      {{% if {service_info.name}_database_type == "postgresql" %}}
      host: "{{{{ {service_info.name}_database_host }}}}"
      port: "{{{{ {service_info.name}_database_port }}}}"
      name: "{{{{ {service_info.name}_database_name }}}}"
      user: "{{ vault_service_user }}"
      password: "{{ vault_service_password }}"') }}}}"
      {{% endif %}}
  when: db_check.status is not defined or db_check.status != 200
  tags: [{service_info.name}, database]

- name: Run {service_info.display_name} database migrations
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/database/migrate"
    method: POST
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
  tags: [{service_info.name}, database]
"""
        
        with open(tasks_dir / "database_setup.yml", 'w') as f:
            f.write(database_tasks)
        
        # API setup tasks
        api_tasks = f"""---
# {service_info.display_name} API Setup

- name: Generate {service_info.display_name} API key
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/keys"
    method: POST
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      name: "ansible-generated"
      permissions: ["read", "write", "admin"]
  register: api_key_result
  tags: [{service_info.name}, api]

- name: Store {service_info.display_name} API key in vault
  set_fact:
    vault_{service_info.name}_api_key: "{{{{ api_key_result.json.key }}}}"
  tags: [{service_info.name}, api]

- name: Configure {service_info.display_name} API rate limiting
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/config/api"
    method: PUT
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      rate_limit_requests: "{{{{ {service_info.name}_api_rate_limit }}}}"
      rate_limit_window: "{{{{ {service_info.name}_api_rate_limit_window }}}}"
  tags: [{service_info.name}, api]
"""
        
        with open(tasks_dir / "api_setup.yml", 'w') as f:
            f.write(api_tasks)
        
        # Other task files
        task_files = {
            "validate.yml": f"""---
# {service_info.display_name} Validation Tasks

- name: Validate {service_info.display_name} configuration
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/health"
    method: GET
  register: health_check
  tags: [{service_info.name}, validate]

- name: Check {service_info.display_name} service status
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/status"
    method: GET
  register: status_check
  tags: [{service_info.name}, validate]

- name: Validate {service_info.display_name} authentication
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/auth/status"
    method: GET
  register: auth_check
  tags: [{service_info.name}, validate]
""",
            "monitoring.yml": f"""---
# {service_info.display_name} Monitoring Tasks

- name: Configure {service_info.display_name} monitoring
  template:
    src: monitoring.yml.j2
    dest: "{{{{ prometheus_config_dir }}}}/{service_info.name}.yml"
    mode: '0644'
  notify: reload prometheus
  tags: [{service_info.name}, monitoring]

- name: Setup {service_info.display_name} metrics collection
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/monitoring"
    method: PUT
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      enabled: "{{{{ {service_info.name}_metrics_enabled | lower }}}}"
      port: "{{{{ {service_info.name}_metrics_port }}}}"
  tags: [{service_info.name}, monitoring]
""",
            "backup.yml": f"""---
# {service_info.display_name} Backup Tasks

- name: Create {service_info.display_name} backup script
  template:
    src: backup.sh.j2
    dest: "{{{{ backup_scripts_dir }}}}/{service_info.name}_backup.sh"
    mode: '0755'
  tags: [{service_info.name}, backup]

- name: Setup {service_info.display_name} backup cron job
  cron:
    name: "{service_info.display_name} backup"
    job: "{{{{ backup_scripts_dir }}}}/{service_info.name}_backup.sh"
    hour: "2"
    minute: "0"
    user: "{{ vault_service_user }}"
  when: {service_info.name}_backup_enabled | default(true)
  tags: [{service_info.name}, backup]
""",
            "security.yml": f"""---
# {service_info.display_name} Security Tasks

- name: Configure {service_info.display_name} security headers
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/security/headers"
    method: PUT
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      enabled: "{{{{ {service_info.name}_security_headers | lower }}}}"
  tags: [{service_info.name}, security]

- name: Configure {service_info.display_name} rate limiting
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/security/rate-limit"
    method: PUT
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      enabled: "{{{{ {service_info.name}_rate_limiting | lower }}}}"
      requests: "{{{{ {service_info.name}_rate_limit_requests }}}}"
      window: "{{{{ {service_info.name}_rate_limit_window }}}}"
  tags: [{service_info.name}, security]

- name: Configure {service_info.display_name} CORS
  uri:
    url: "https://{{{{ {service_info.name}_domain }}}}/api/admin/security/cors"
    method: PUT
    headers:
      Content-Type: "application/json"
      Authorization: "Bearer {{{{ vault_{service_info.name}_api_key | default('') }}}}"
    body_format: json
    body:
      enabled: "{{{{ {service_info.name}_cors_enabled | lower }}}}"
  tags: [{service_info.name}, security]
""",
            "homepage.yml": f"""---
# {service_info.display_name} Homepage Integration Tasks

- name: Add {service_info.display_name} to homepage services
  template:
    src: homepage-service.yml.j2
    dest: "{{{{ homepage_config_dir }}}}/services/{service_info.name}.yml"
    mode: '0644'
  when: {service_info.name}_homepage_enabled | default(true)
  tags: [{service_info.name}, homepage]

- name: Reload homepage configuration
  uri:
    url: "http://{{ ansible_default_ipv4.address }}:{{{{ homepage_port | default(3000) }}}}/api/reload"
    method: POST
  when: {service_info.name}_homepage_enabled | default(true)
  tags: [{service_info.name}, homepage]
"""
        }
        
        for filename, content in task_files.items():
            with open(tasks_dir / filename, 'w') as f:
                f.write(content)
    
    def _generate_templates(self, service_info: ServiceInfo, role_dir: Path):
        """Generate template files for the role."""
        templates_dir = role_dir / "templates"
        
        # Docker Compose template - using string formatting to avoid f-string issues
        docker_compose = """version: '3.8'

services:
  {service_name}:
    image: {{{{ {service_name}_image }}}}
    container_name: {{{{ {service_name}_container_name }}}}
    restart: {{{{ {service_name}_restart_policy }}}}
    
    # Environment variables
    environment:
      {{% for key, value in {service_name}_environment.items() %}}
      - {{{{ key }}}}={{{{ value }}}}
      {{% endfor %}}
    
    # Volumes
    volumes:
      {{% for volume in {service_name}_volumes %}}
      - {{{{ volume }}}}
      {{% endfor %}}
    
    # Ports
    ports:
      - "{{{{ {service_name}_external_port }}}}:{{{{ {service_name}_internal_port }}}}"
    
    # Networks
    networks:
      {{% for network in {service_name}_networks %}}
      - {{{{ network }}}}
      {{% endfor %}}
    
    # Labels for Traefik
    {{% if {service_name}_traefik_enabled | default(true) %}}
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=homelab"
      - "traefik.http.routers.{service_name}.rule=Host(`{{{{ {service_name}_domain }}}}`)"
      - "traefik.http.routers.{service_name}.entrypoints=https"
      - "traefik.http.routers.{service_name}.tls=true"
      - "traefik.http.routers.{service_name}.tls.certresolver=cloudflare"
      - "traefik.http.services.{service_name}.loadbalancer.server.port={{{{ {service_name}_internal_port }}}}"
      {{% if {service_name}_traefik_middleware is defined %}}
      - "traefik.http.routers.{service_name}.middlewares={{{{ {service_name}_traefik_middleware }}}}"
      {{% endif %}}
    {{% endif %}}
    
    # Health check
    {{% if {service_name}_healthcheck_enabled | default(true) %}}
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://{{ ansible_default_ipv4.address }}:{{{{ {service_name}_internal_port }}}}/ || exit 1"]
      interval: {{{{ {service_name}_healthcheck_interval }}}}
      timeout: {{{{ {service_name}_healthcheck_timeout }}}}
      retries: {{{{ {service_name}_healthcheck_retries }}}}
      start_period: {{{{ {service_name}_healthcheck_start_period }}}}
    {{% endif %}}
    
    # Security options
    {{% if {service_name}_security_enabled | default(true) %}}
    security_opt:
      - no-new-privileges:{{{{ {service_name}_no_new_privileges | default(true) }}}}
    {{% endif %}}
    
    # Read-only root filesystem
    read_only: {{{{ {service_name}_read_only | default(false) }}}}
    tmpfs:
      - /tmp
    
    # Resource limits
    deploy:
      resources:
        limits:
          memory: {{{{ {service_name}_memory_limit }}}}
          cpus: '{{{{ {service_name}_cpu_limit }}}}'
        reservations:
          memory: {{{{ {service_name}_memory_reservation }}}}
          cpus: '{{{{ {service_name}_cpu_reservation }}}}'
    
    # Dependencies
    {{% if {service_name}_dependencies is defined %}}
    depends_on:
      {{% for dependency in {service_name}_dependencies %}}
      {{{{ dependency }}}}:
        condition: service_healthy
      {{% endfor %}}
    {{% endif %}}
    
    # Logging
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

networks:
  homelab:
    external: true
  default:
    driver: bridge
""".format(service_name=service_info.name)
        
        with open(templates_dir / "docker-compose.yml.j2", 'w') as f:
            f.write(docker_compose)
        
        # Generate other templates
        template_files = {
            "monitoring.yml.j2": f"""---
# {service_info.display_name} Monitoring Configuration
# Prometheus scrape configuration

- job_name: '{service_info.name}'
  static_configs:
    - targets: ['{{ ansible_default_ipv4.address }}:{{{{ {service_info.name}_external_port }}}}']
  metrics_path: /metrics
  scrape_interval: 30s
""",
            "security.yml.j2": f"""---
# {service_info.display_name} Security Configuration
# Security hardening rules

{service_info.name}_security_rules:
  - rule: "deny access to sensitive endpoints"
    path: "/admin"
    method: "POST"
    action: "deny"
""",
            "backup.sh.j2": f"""#!/bin/bash
# {service_info.display_name} Backup Script

BACKUP_DIR="{{{{ backup_dir }}}}/{service_info.name}"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

# Backup data directory
if [ -d "{{{{ docker_data_root }}}}/{service_info.name}" ]; then
    tar -czf "$BACKUP_DIR/data_$DATE.tar.gz" -C "{{{{ docker_data_root }}}}" {service_info.name}
fi

# Backup config directory
if [ -d "{{{{ docker_config_root }}}}/{service_info.name}" ]; then
    tar -czf "$BACKUP_DIR/config_$DATE.tar.gz" -C "{{{{ docker_config_root }}}}" {service_info.name}
fi

# Cleanup old backups
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +{{{{ {service_info.name}_backup_retention_days | default(30) }}}} -delete
""",
            "homepage-service.yml.j2": f"""---
# {service_info.display_name} Homepage Service Configuration

- name: {service_info.display_name}
  description: {service_info.description}
  icon: {{{{ {service_info.name}_homepage_icon | default('{service_info.name}') }}}}
  group: {{{{ {service_info.name}_homepage_group | default('{service_info.category}') }}}}
  url: https://{{{{ {service_info.name}_domain }}}}
  widget:
    type: {service_info.name}
    url: https://{{{{ {service_info.name}_domain }}}}
    key: status
""",
            "alerts.yml.j2": f"""---
# {service_info.display_name} Alerting Rules

groups:
  - name: {service_info.display_name}
    rules:
      - alert: {service_info.display_name}Down
        expr: up{{job="{service_info.name}"}} == 0
        for: 1m
        labels:
          severity: {{{{ {service_info.name}_alert_severity | default('warning') }}}}
        annotations:
          summary: "{service_info.display_name} is down"
          description: "{service_info.display_name} has been down for more than 1 minute"
""",
            "env.j2": f"""# {service_info.display_name} Environment Configuration
# Generated by Ansible - Do not edit manually

# =============================================================================
# BASIC CONFIGURATION
# =============================================================================

# Service Configuration
{service_info.name.upper()}_ENABLED={{{{ {service_info.name}_enabled | lower }}}}
{service_info.name.upper()}_VERSION={{{{ {service_info.name}_version }}}}
{service_info.name.upper()}_PORT={{{{ {service_info.name}_port }}}}

# Domain Configuration
{service_info.name.upper()}_DOMAIN={{{{ {service_info.name}_domain }}}}
{service_info.name.upper()}_SUBDOMAIN={{{{ {service_info.name}_subdomain }}}}

# =============================================================================
# AUTHENTICATION CONFIGURATION
# =============================================================================

{service_info.name.upper()}_AUTH_ENABLED={{{{ {service_info.name}_auth_enabled | lower }}}}
{service_info.name.upper()}_AUTH_METHOD={{{{ {service_info.name}_auth_method }}}}
{service_info.name.upper()}_ADMIN_EMAIL={{{{ {service_info.name}_admin_email }}}}
{service_info.name.upper()}_ADMIN_PASSWORD={{{{ vault_{service_info.name}_admin_password | default('') }}}}
{service_info.name.upper()}_SECRET_KEY={{{{ vault_{service_info.name}_secret_key | default('') }}}}

# =============================================================================
# DATABASE CONFIGURATION
# =============================================================================

{service_info.name.upper()}_DATABASE_ENABLED={{{{ {service_info.name}_database_enabled | lower }}}}
{service_info.name.upper()}_DATABASE_TYPE={{{{ {service_info.name}_database_type }}}}
{{% if {service_info.name}_database_type == "postgresql" %}}
{service_info.name.upper()}_DATABASE_HOST={{{{ {service_info.name}_database_host }}}}
{service_info.name.upper()}_DATABASE_PORT={{{{ {service_info.name}_database_port }}}}
{service_info.name.upper()}_DATABASE_NAME={{{{ {service_info.name}_database_name }}}}
{service_info.name.upper()}_DATABASE_USER={{{{ {service_info.name}_database_user }}}}
{service_info.name.upper()}_DATABASE_PASSWORD={{{{ vault_{service_info.name}_database_password | default('') }}}}
{{% endif %}}

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================

{service_info.name.upper()}_SECURITY_HEADERS={{{{ {service_info.name}_security_headers | lower }}}}
{service_info.name.upper()}_RATE_LIMITING={{{{ {service_info.name}_rate_limiting | lower }}}}
{service_info.name.upper()}_RATE_LIMIT_REQUESTS={{{{ {service_info.name}_rate_limit_requests }}}}
{service_info.name.upper()}_RATE_LIMIT_WINDOW={{{{ {service_info.name}_rate_limit_window }}}}
{service_info.name.upper()}_CORS_ENABLED={{{{ {service_info.name}_cors_enabled | lower }}}}
{service_info.name.upper()}_CROUDSEC_ENABLED={{{{ {service_info.name}_crowdsec_enabled | lower }}}}
{service_info.name.upper()}_FAIL2BAN_ENABLED={{{{ {service_info.name}_fail2ban_enabled | lower }}}}

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================

{service_info.name.upper()}_MONITORING_ENABLED={{{{ {service_info.name}_monitoring_enabled | lower }}}}
{service_info.name.upper()}_METRICS_ENABLED={{{{ {service_info.name}_metrics_enabled | lower }}}}
{service_info.name.upper()}_METRICS_PORT={{{{ {service_info.name}_metrics_port }}}}
{service_info.name.upper()}_HEALTH_CHECK_ENABLED={{{{ {service_info.name}_healthcheck_enabled | lower }}}}
{service_info.name.upper()}_HEALTH_CHECK_INTERVAL={{{{ {service_info.name}_healthcheck_interval }}}}
{service_info.name.upper()}_HEALTH_CHECK_TIMEOUT={{{{ {service_info.name}_healthcheck_timeout }}}}
{service_info.name.upper()}_HEALTH_CHECK_RETRIES={{{{ {service_info.name}_healthcheck_retries }}}}
{service_info.name.upper()}_HEALTH_CHECK_START_PERIOD={{{{ {service_info.name}_healthcheck_start_period }}}}

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

{service_info.name.upper()}_LOG_LEVEL={{{{ {service_info.name}_log_level }}}}
{service_info.name.upper()}_LOG_FORMAT={{{{ {service_info.name}_log_format }}}}
{service_info.name.upper()}_LOG_RETENTION={{{{ {service_info.name}_log_retention }}}}

# =============================================================================
# PERFORMANCE CONFIGURATION
# =============================================================================

{service_info.name.upper()}_CACHE_ENABLED={{{{ {service_info.name}_cache_enabled | lower }}}}
{service_info.name.upper()}_CACHE_SIZE={{{{ {service_info.name}_cache_size }}}}
{service_info.name.upper()}_CACHE_TTL={{{{ {service_info.name}_cache_ttl }}}}
{service_info.name.upper()}_COMPRESSION_ENABLED={{{{ {service_info.name}_compression_enabled | lower }}}}
{service_info.name.upper()}_COMPRESSION_LEVEL={{{{ {service_info.name}_compression_level }}}}

# =============================================================================
# API CONFIGURATION
# =============================================================================

{service_info.name.upper()}_API_ENABLED={{{{ {service_info.name}_api_enabled | lower }}}}
{service_info.name.upper()}_API_VERSION={{{{ {service_info.name}_api_version }}}}
{service_info.name.upper()}_API_KEY={{{{ vault_{service_info.name}_api_key | default('') }}}}
{service_info.name.upper()}_API_RATE_LIMIT={{{{ {service_info.name}_api_rate_limit }}}}
{service_info.name.upper()}_API_RATE_LIMIT_WINDOW={{{{ {service_info.name}_api_rate_limit_window }}}}

# =============================================================================
# NOTIFICATION CONFIGURATION
# =============================================================================

{service_info.name.upper()}_NOTIFICATIONS_ENABLED={{{{ {service_info.name}_notifications_enabled | lower }}}}

# Email Configuration
{service_info.name.upper()}_EMAIL_ENABLED={{{{ {service_info.name}_email_enabled | lower }}}}
{service_info.name.upper()}_EMAIL_HOST={{{{ {service_info.name}_email_host }}}}
{service_info.name.upper()}_EMAIL_PORT={{{{ {service_info.name}_email_port }}}}
{service_info.name.upper()}_EMAIL_USERNAME={{{{ {service_info.name}_email_username }}}}
{service_info.name.upper()}_EMAIL_PASSWORD={{{{ {service_info.name}_email_password }}}}
{service_info.name.upper()}_EMAIL_FROM={{{{ {service_info.name}_email_from }}}}

# Discord Configuration
{service_info.name.upper()}_DISCORD_ENABLED={{{{ {service_info.name}_discord_enabled | lower }}}}
{service_info.name.upper()}_DISCORD_WEBHOOK={{{{ {service_info.name}_discord_webhook }}}}

# Slack Configuration
{service_info.name.upper()}_SLACK_ENABLED={{{{ {service_info.name}_slack_enabled | lower }}}}
{service_info.name.upper()}_SLACK_WEBHOOK={{{{ {service_info.name}_slack_webhook }}}}

# =============================================================================
# TRAEFIK CONFIGURATION
# =============================================================================

{service_info.name.upper()}_TRAEFIK_ENABLED={{{{ {service_info.name}_traefik_enabled | lower }}}}
{service_info.name.upper()}_TRAEFIK_NETWORK={{{{ {service_info.name}_traefik_network }}}}
{service_info.name.upper()}_TRAEFIK_SSL_ENABLED={{{{ {service_info.name}_traefik_ssl_enabled | lower }}}}

# =============================================================================
# BACKUP CONFIGURATION
# =============================================================================

{service_info.name.upper()}_BACKUP_ENABLED={{{{ {service_info.name}_backup_enabled | lower }}}}
{service_info.name.upper()}_BACKUP_RETENTION_DAYS={{{{ {service_info.name}_backup_retention_days }}}}
{service_info.name.upper()}_BACKUP_INCLUDE_DATA={{{{ {service_info.name}_backup_include_data | lower }}}}
{service_info.name.upper()}_BACKUP_INCLUDE_CONFIG={{{{ {service_info.name}_backup_include_config | lower }}}}
{service_info.name.upper()}_BACKUP_SCHEDULE={{{{ {service_info.name}_backup_schedule }}}}

# =============================================================================
# HOMEPAGE INTEGRATION
# =============================================================================

{service_info.name.upper()}_HOMEPAGE_ENABLED={{{{ {service_info.name}_homepage_enabled | lower }}}}
{service_info.name.upper()}_HOMEPAGE_GROUP={{{{ {service_info.name}_homepage_group }}}}
{service_info.name.upper()}_HOMEPAGE_ICON={{{{ {service_info.name}_homepage_icon }}}}
{service_info.name.upper()}_HOMEPAGE_TITLE={{{{ {service_info.name}_homepage_title }}}}
{service_info.name.upper()}_HOMEPAGE_DESCRIPTION={{{{ {service_info.name}_homepage_description }}}}

# =============================================================================
# ALERTING CONFIGURATION
# =============================================================================

{service_info.name.upper()}_ALERTING_ENABLED={{{{ {service_info.name}_alerting_enabled | lower }}}}
{service_info.name.upper()}_ALERT_SEVERITY={{{{ {service_info.name}_alert_severity }}}}
{service_info.name.upper()}_ALERT_CHANNELS={{{{ {service_info.name}_alert_channels | join(',') }}}}

# =============================================================================
# RESOURCE LIMITS
# =============================================================================

{service_info.name.upper()}_MEMORY_LIMIT={{{{ {service_info.name}_memory_limit }}}}
{service_info.name.upper()}_MEMORY_RESERVATION={{{{ {service_info.name}_memory_reservation }}}}
{service_info.name.upper()}_CPU_LIMIT={{{{ {service_info.name}_cpu_limit }}}}
{service_info.name.upper()}_CPU_RESERVATION={{{{ {service_info.name}_cpu_reservation }}}}
{service_info.name.upper()}_STORAGE_LIMIT={{{{ {service_info.name}_storage_limit }}}}

# =============================================================================
# SYSTEM CONFIGURATION
# =============================================================================

TZ={{{{ timezone }}}}
PUID={{{{ ansible_user_id | default(1000) }}}}
PGID={{{{ ansible_user_id | default(1000) }}}}
"""
        }
        
        for filename, content in template_files.items():
            with open(templates_dir / filename, 'w') as f:
                f.write(content)
    
    def _generate_handlers(self, service_info: ServiceInfo, role_dir: Path):
        """Generate handlers for the role."""
        handlers_content = f"""---
# {service_info.display_name} Handlers

- name: restart {service_info.name}
  community.docker.docker_compose:
    project_src: "{{{{ docker_root }}}}/{service_info.name}"
    state: present
  listen: "restart {service_info.name}"

- name: reload {service_info.name}
  community.docker.docker_compose:
    project_src: "{{{{ docker_root }}}}/{service_info.name}"
    state: present
  listen: "reload {service_info.name}"
"""
        
        with open(role_dir / "handlers" / "main.yml", 'w') as f:
            f.write(handlers_content)
    
    def _generate_readme(self, service_info: ServiceInfo, role_dir: Path):
        """Generate README.md for the role."""
        readme_content = f"""# {service_info.display_name} Role

This role deploys and manages {service_info.display_name} for the homelab environment. It provides modular tasks for deployment, validation, monitoring, backup, security, and homepage integration.

## Features
- Deploy and configure {service_info.display_name}
- Traefik integration with SSL/TLS
- Monitoring and alerting integration
- Automated backup and restore
- Security hardening and compliance
- Homepage integration
- Health checks and validation

## Directory Structure
- `defaults/`: Default variables
- `handlers/`: Service handlers
- `tasks/`: Modular tasks (main, deploy, monitoring, security, backup, homepage, alerts, validate, etc.)
- `templates/`: Jinja2 templates for configs, scripts, homepage, etc.

## Usage
Include this role in your playbook:
```yaml
- hosts: all
  roles:
    - role: {service_info.name}
```

## Variables
See `defaults/main.yml` for all configurable options. Sensitive variables should be stored in Ansible Vault.

## Integration
- Monitoring: Prometheus, Grafana, logrotate
- Backup: Scheduled, compressed, encrypted
- Security: Hardening, access control, fail2ban, firewall
- Homepage: Service registration and status

## Validation & Health Checks
- Automated validation and health scripts for {service_info.display_name}

## Author
Generated by Ansible Homelab Service Integration Wizard

## Configuration
- **Port**: {service_info.ports[0] if service_info.ports else 'Default'}
- **Domain**: {service_info.name}.{{{{ domain }}}}
- **Category**: {service_info.category}
- **Stage**: {service_info.stage}

## Dependencies
{chr(10).join([f'- {dep}' for dep in service_info.dependencies]) if service_info.dependencies else '- None'}

## Environment Variables
{chr(10).join([f'- {key}: {value}' for key, value in service_info.environment_vars.items()]) if service_info.environment_vars else '- Default configuration'}

## Volumes
{chr(10).join([f'- {volume}' for volume in service_info.volumes]) if service_info.volumes else '- Default volumes'}
"""
        
        with open(role_dir / "README.md", 'w') as f:
            f.write(readme_content)
    
    def update_main_configuration(self, service_info: ServiceInfo):
        """Update main configuration files to include the new service."""
        print(f"\nUpdating main configuration for {service_info.name}...")
        
        # Update group_vars/all/roles.yml
        self._update_roles_config(service_info)
        
        # Update site.yml
        self._update_site_yml(service_info)
        
        print("✓ Main configuration updated")
    
    def _update_roles_config(self, service_info: ServiceInfo):
        """Update roles.yml configuration."""
        roles_file = self.group_vars_dir / "roles.yml"
        
        # Load existing configuration
        if roles_file.exists():
            with open(roles_file, 'r') as f:
                roles_config = yaml.safe_load(f) or {}
        else:
            roles_config = {}
        
        # Add service configuration
        roles_config[f"{service_info.name}_enabled"] = True
        
        # Update subdomains configuration
        subdomains_file = self.group_vars_dir / "vars.yml"
        if subdomains_file.exists():
            with open(subdomains_file, 'r') as f:
                vars_config = yaml.safe_load(f) or {}
        else:
            vars_config = {}
        
        # Add service to subdomains
        if 'subdomains' not in vars_config:
            vars_config['subdomains'] = {}
        
        vars_config['subdomains'][service_info.name] = service_info.name
        
        # Save updated vars configuration
        with open(subdomains_file, 'w') as f:
            yaml.dump(vars_config, f, default_flow_style=False, sort_keys=False)
        
        # Save updated roles configuration
        with open(roles_file, 'w') as f:
            yaml.dump(roles_config, f, default_flow_style=False, sort_keys=False)
        
        print(f"   ✓ Updated roles configuration")
        print(f"   ✓ Added {service_info.name} to subdomains")
        
        # Generate vault variables for the service
        self._generate_vault_variables(service_info)
    
    def _update_site_yml(self, service_info: ServiceInfo):
        """Update site.yml to include the new role in the correct stage."""
        try:
            with open(self.site_yml, 'r') as f:
                site_content = f.read()
        except FileNotFoundError:
            print("Warning: site.yml not found, skipping update")
            return
        
        # Find the roles section and add the new role
        role_entry = f"""    - name: {service_info.name}
      tags: [{service_info.name}, {service_info.category}, {service_info.stage}]
      when: {service_info.name}_enabled | default(true)
      
"""
        
        # Insert the role in the appropriate stage
        stage_marker = f"# {service_info.stage.upper()}"
        if stage_marker in site_content:
            # Insert after the stage marker
            lines = site_content.split('\n')
            for i, line in enumerate(lines):
                if stage_marker in line:
                    # Find the end of this stage (next stage marker or end of roles)
                    insert_pos = i + 1
                    while insert_pos < len(lines) and not lines[insert_pos].strip().startswith('# Stage'):
                        insert_pos += 1
                    
                    # Insert the role
                    lines.insert(insert_pos, role_entry.rstrip())
                    break
            
            site_content = '\n'.join(lines)
        else:
            # Add to the end of roles section
            roles_end = site_content.find('  # Post-deployment validation')
            if roles_end != -1:
                site_content = site_content[:roles_end] + role_entry + site_content[roles_end:]
        
        # Write back to file
        with open(self.site_yml, 'w') as f:
            f.write(site_content)
    
    def validate_integration(self, service_info: ServiceInfo):
        """Validate the integration and check for conflicts."""
        print(f"\nValidating integration for {service_info.name}...")
        
        # Check for port conflicts
        if service_info.ports:
            for port in service_info.ports:
                if port in self.port_assignments.values():
                    conflicting_service = [k for k, v in self.port_assignments.items() if v == port][0]
                    print(f"⚠️  Warning: Port {port} is already used by {conflicting_service}")
        
        # Check for name conflicts
        if service_info.name in self.existing_services:
            print(f"⚠️  Warning: Service name '{service_info.name}' already exists")
        
        # Validate role structure
        role_dir = self.roles_dir / service_info.name
        required_files = [
            "defaults/main.yml",
            "tasks/main.yml",
            "tasks/deploy.yml",
            "templates/docker-compose.yml.j2",
            "handlers/main.yml",
            "README.md"
        ]
        
        missing_files = []
        for file_path in required_files:
            if not (role_dir / file_path).exists():
                missing_files.append(file_path)
        
        if missing_files:
            print(f"❌ Error: Missing required files: {', '.join(missing_files)}")
            return False
        
        print("✓ Integration validation passed")
        return True
    
    def run(self):
        """Run the complete service integration wizard."""
        try:
            # Collect service information
            service_info = self.collect_service_info()
            
            # Generate role structure
            self.generate_role_structure(service_info)
            
            # Update main configuration
            self.update_main_configuration(service_info)
            
            # Validate integration
            if not self.validate_integration(service_info):
                print("\n❌ Integration validation failed. Please review the issues above.")
                return False
            
            # Display summary
            self._display_summary(service_info)
            
            print(f"\n🎉 Successfully integrated {service_info.display_name} into your homelab stack!")
            print(f"\n📋 Next Steps:")
            print(f"1. 📝 Review the generated configuration:")
            print(f"   • nano roles/{service_info.name}/defaults/main.yml")
            print(f"   • nano roles/{service_info.name}/templates/docker-compose.yml.j2")
            
            print(f"\n2. ⚙️  Customize settings (if needed):")
            print(f"   • nano group_vars/all/roles.yml")
            print(f"   • nano site.yml")
            
            print(f"\n3. 🚀 Deploy the service:")
            print(f"   • ansible-playbook site.yml --tags {service_info.name} --check")
            print(f"   • ansible-playbook site.yml --tags {service_info.name}")
            
            print(f"\n4. 🌐 Access your service:")
            print(f"   • URL: https://{service_info.name}.{self._get_domain()}")
            print(f"   • Homepage: Check your homepage dashboard")
            print(f"   • Monitoring: Check Grafana dashboards")
            
            print(f"\n💡 Tips:")
            print(f"   • Use --check flag first to validate without deploying")
            print(f"   • Check logs: docker logs {service_info.name}")
            print(f"   • Monitor health: docker ps | grep {service_info.name}")
            
            return True
            
        except KeyboardInterrupt:
            print("\n\n❌ Operation cancelled by user")
            return False
        except Exception as e:
            print(f"\n❌ Error: {e}")
            return False
    
    def _display_summary(self, service_info: ServiceInfo):
        """Display a summary of the integration."""
        print(f"\n" + "="*60)
        print(f"🎉 INTEGRATION SUMMARY")
        print(f"="*60)
        print(f"📋 Service Information:")
        print(f"   • Name: {service_info.name}")
        print(f"   • Display Name: {service_info.display_name}")
        print(f"   • Description: {service_info.description}")
        print(f"   • Category: {service_info.category}")
        print(f"   • Stage: {service_info.stage}")
        
        print(f"\n🌐 Access Information:")
        print(f"   • Port: {service_info.ports[0] if service_info.ports else 'Default (8080)'}")
        print(f"   • Domain: {service_info.name}.{self._get_domain()}")
        print(f"   • URL: https://{service_info.name}.{self._get_domain()}")
        
        print(f"\n📦 Container Information:")
        print(f"   • Image: {service_info.image}")
        print(f"   • Version: {service_info.version}")
        print(f"   • Repository: {service_info.repository_url}")
        
        if service_info.dependencies:
            print(f"\n🔗 Dependencies:")
            for dep in service_info.dependencies:
                print(f"   • {dep}")
        
        print(f"\n📁 Generated Files:")
        print(f"   • Role: roles/{service_info.name}/")
        print(f"   • Tasks: roles/{service_info.name}/tasks/")
        print(f"   • Templates: roles/{service_info.name}/templates/")
        print(f"   • Variables: roles/{service_info.name}/defaults/main.yml")
        print("="*60)
    
    def _get_domain(self) -> str:
        """Get the domain from common.yml."""
        try:
            with open(self.group_vars_dir / "common.yml", 'r') as f:
                common_config = yaml.safe_load(f)
            return common_config.get('domain', '{{ ansible_default_ipv4.address }}')
        except:
            return '{{ ansible_default_ipv4.address }}'
    
    def _generate_vault_variables(self, service_info: ServiceInfo):
        """Generate vault variables for the service."""
        vault_template_file = self.group_vars_dir / "vault.yml.template"
        vault_file = self.group_vars_dir / "vault.yml"
        
        # Load existing vault configuration
        if vault_file.exists():
            with open(vault_file, 'r') as f:
                vault_config = yaml.safe_load(f) or {}
        else:
            vault_config = {}
        
        # Add service-specific vault variables
        vault_config[f"vault_{service_info.name}_admin_password"] = f"your_secure_{service_info.name}_admin_password"
        vault_config[f"vault_{service_info.name}_secret_key"] = f"your_secure_{service_info.name}_secret_key"
        vault_config[f"vault_{service_info.name}_api_key"] = f"your_secure_{service_info.name}_api_key"
        
        # Add database password if database is enabled
        if service_info.database_enabled and service_info.database_type == "postgresql":
            vault_config[f"vault_{service_info.name}_database_password"] = f"your_secure_{service_info.name}_database_password"
        
        # Save updated vault configuration
        with open(vault_file, 'w') as f:
            yaml.dump(vault_config, f, default_flow_style=False, sort_keys=False)
        
        print(f"   ✓ Generated vault variables for {service_info.name}")
        
        # Update vault template
        if vault_template_file.exists():
            with open(vault_template_file, 'r') as f:
                template_content = f.read()
        else:
            template_content = "# Vault Variables Template\n# Copy this file to vault.yml and fill in your values\n# Then encrypt it with: ansible-vault encrypt vault.yml\n\n"
        
        # Add service variables to template
        template_content += f"\n# {service_info.display_name} Configuration\n"
        template_content += f"vault_{service_info.name}_admin_password: \"your_secure_{service_info.name}_admin_password\"\n"
        template_content += f"vault_{service_info.name}_secret_key: \"your_secure_{service_info.name}_secret_key\"\n"
        template_content += f"vault_{service_info.name}_api_key: \"your_secure_{service_info.name}_api_key\"\n"
        
        if service_info.database_enabled and service_info.database_type == "postgresql":
            template_content += f"vault_{service_info.name}_database_password: \"your_secure_{service_info.name}_database_password\"\n"
        
        # Save updated template
        with open(vault_template_file, 'w') as f:
            f.write(template_content)
        
        print(f"   ✓ Updated vault template for {service_info.name}")

def main():
    """Main entry point for the service wizard."""
    parser = argparse.ArgumentParser(description='Ansible Homelab Service Integration Wizard')
    parser.add_argument('--project-root', help='Path to the Ansible homelab project root')
    parser.add_argument('--service-name', help='Service name (skip interactive mode)')
    parser.add_argument('--repository-url', help='Repository URL (skip interactive mode)')
    
    args = parser.parse_args()
    
    try:
        wizard = ServiceWizard(args.project_root)
        
        if args.service_name and args.repository_url:
            # Non-interactive mode
            print(f"\n🔍 ANALYZING REPOSITORY")
            print("-" * 40)
            print(f"Analyzing: {args.repository_url}")
            print("  ✓ Extracting Docker configuration...")
            print("  ✓ Detecting ports and environment variables...")
            print("  ✓ Identifying dependencies...")
            
            # Analyze repository for service-specific information
            repo_info = wizard._analyze_repository(args.repository_url)
            
            # Check for port conflicts and resolve them
            if repo_info.get('ports'):
                conflicts, suggestions = wizard._check_port_conflicts(repo_info['ports'])
                
                if conflicts:
                    print(f"\n⚠️  PORT CONFLICTS DETECTED")
                    print("-" * 40)
                    for conflict in conflicts:
                        print(f"  • {conflict}")
                    
                    print(f"\n🔧 PORT REMEDIATION")
                    print("-" * 40)
                    for i, suggestion in enumerate(suggestions, 1):
                        print(f"  {i}. {suggestion}")
                    
                    # Automatically resolve conflicts
                    resolved_ports = []
                    for i, port in enumerate(repo_info['ports']):
                        if port in [v for v in wizard.port_assignments.values()]:
                            # Use suggested port
                            available_port = wizard._find_available_port()
                            resolved_ports.append(available_port)
                            print(f"  ✓ Resolved: Port {port} → {available_port}")
                        else:
                            resolved_ports.append(port)
                    
                    repo_info['ports'] = resolved_ports
                    print(f"  ✓ All port conflicts automatically resolved")
            
            service_info = ServiceInfo(
                name=args.service_name,
                repository_url=args.repository_url,
                display_name=args.service_name.title(),
                description=f"{args.service_name.title()} service",
                category="utilities",
                stage="stage3",
                ports=repo_info.get('ports', [8080]),
                environment_vars=repo_info.get('environment_vars', {}),
                volumes=repo_info.get('volumes', []),
                dependencies=repo_info.get('dependencies', []),
                image=repo_info.get('image', f"{args.service_name}:latest"),
                version=repo_info.get('version', 'latest')
            )
            
            wizard.generate_role_structure(service_info)
            wizard.update_main_configuration(service_info)
            wizard.validate_integration(service_info)
            wizard._display_summary(service_info)
        else:
            # Interactive mode
            wizard.run()
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 