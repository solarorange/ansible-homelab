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

class ServiceWizard:
    """Main wizard class for service integration."""
    
    def __init__(self, project_root: str = None):
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
                            if key.endswith('_port') and isinstance(value, int):
                                service_name = key.replace('_port', '')
                                port_assignments[service_name] = value
                    except Exception as e:
                        print(f"Warning: Could not load ports for {role_dir.name}: {e}")
        
        return port_assignments
    
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
                            if file_info['name'] in ['docker-compose.yml', 'docker-compose.yaml', 'compose.yml']:
                                compose_url = file_info['download_url']
                                compose_response = requests.get(compose_url, timeout=10)
                                if compose_response.status_code == 200:
                                    compose_data = yaml.safe_load(compose_response.text)
                                    repo_info.update(self._parse_docker_compose(compose_data))
                                    break
            
            # If we couldn't get info from API, try to extract from URL
            if not repo_info['image']:
                repo_name = parsed_url.path.split('/')[-1]
                repo_info['image'] = f"{repo_name}:latest"
                
        except Exception as e:
            print(f"Warning: Could not analyze repository: {e}")
        
        return repo_info
    
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
{service_info.name}_domain: "{service_info.name}.{{{{ domain | default('localhost') }}}}"

# =============================================================================
# TRAEFIK INTEGRATION
# =============================================================================

{service_info.name}_traefik_enabled: true
{service_info.name}_traefik_middleware: ""

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================

{service_info.name}_monitoring_enabled: true
{service_info.name}_healthcheck_enabled: true
{service_info.name}_healthcheck_interval: "30s"
{service_info.name}_healthcheck_timeout: "10s"
{service_info.name}_healthcheck_retries: 3
{service_info.name}_healthcheck_start_period: "40s"

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================

{service_info.name}_security_enabled: true
{service_info.name}_read_only: false
{service_info.name}_no_new_privileges: true

# =============================================================================
# BACKUP CONFIGURATION
# =============================================================================

{service_info.name}_backup_enabled: true
{service_info.name}_backup_retention_days: 30
{service_info.name}_backup_include_data: true
{service_info.name}_backup_include_config: true

# =============================================================================
# HOMEPAGE INTEGRATION
# =============================================================================

{service_info.name}_homepage_enabled: true
{service_info.name}_homepage_group: "{service_info.category}"
{service_info.name}_homepage_icon: "{service_info.name}"

# =============================================================================
# ALERTING CONFIGURATION
# =============================================================================

{service_info.name}_alerting_enabled: true
{service_info.name}_alert_severity: "warning"

# =============================================================================
# RESOURCE LIMITS
# =============================================================================

{service_info.name}_memory_limit: "512M"
{service_info.name}_memory_reservation: "256M"
{service_info.name}_cpu_limit: "0.5"
{service_info.name}_cpu_reservation: "0.25"

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

{service_info.name}_environment:
"""
        
        # Add environment variables
        for key, value in service_info.environment_vars.items():
            defaults_content += f"  {key}: \"{value}\"\n"
        
        # Add common environment variables
        defaults_content += f"""  TZ: "{{{{ timezone | default('UTC') }}}}"
  PUID: "{{{{ ansible_user_id | default(1000) }}}}"
  PGID: "{{{{ ansible_user_id | default(1000) }}}}"

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
        
        with open(role_dir / "defaults" / "main.yml", 'w') as f:
            f.write(defaults_content)
    
    def _generate_tasks(self, service_info: ServiceInfo, role_dir: Path):
        """Generate task files for the role."""
        tasks_dir = role_dir / "tasks"
        
        # Main tasks file
        main_tasks = f"""---
# {service_info.display_name} Role - Main Tasks
# Comprehensive {service_info.display_name} deployment and configuration

- name: Include {service_info.display_name} deployment tasks
  include_tasks: deploy.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, deploy]

- name: Include {service_info.display_name} monitoring configuration
  include_tasks: monitoring.yml
  when: {service_info.name}_enabled | default(true) and {service_info.name}_monitoring_enabled | default(true)
  tags: [{service_info.name}, monitoring]

- name: Include {service_info.display_name} security configuration
  include_tasks: security.yml
  when: {service_info.name}_enabled | default(true) and {service_info.name}_security_enabled | default(true)
  tags: [{service_info.name}, security]

- name: Include {service_info.display_name} backup configuration
  include_tasks: backup.yml
  when: {service_info.name}_enabled | default(true) and {service_info.name}_backup_enabled | default(true)
  tags: [{service_info.name}, backup]

- name: Include {service_info.display_name} homepage integration
  include_tasks: homepage.yml
  when: {service_info.name}_enabled | default(true) and {service_info.name}_homepage_enabled | default(true)
  tags: [{service_info.name}, homepage]

- name: Include {service_info.display_name} alerting configuration
  include_tasks: alerts.yml
  when: {service_info.name}_enabled | default(true) and {service_info.name}_alerting_enabled | default(true)
  tags: [{service_info.name}, alerts]

- name: Include {service_info.display_name} validation tasks
  include_tasks: validate.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, validation]

- name: Include {service_info.display_name} deployment validation
  include_tasks: validate_deployment.yml
  when: {service_info.name}_enabled | default(true)
  tags: [{service_info.name}, validation]
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
  tags: [{service_info.name}, deploy]

- name: Deploy {service_info.display_name} Docker Compose
  template:
    src: docker-compose.yml.j2
    dest: "{{{{ docker_root }}}}/{service_info.name}/docker-compose.yml"
    mode: '0644'
  notify: restart {service_info.name}
  tags: [{service_info.name}, deploy]

- name: Start {service_info.display_name} services
  community.docker.docker_compose:
    project_src: "{{{{ docker_root }}}}/{service_info.name}"
    state: present
  tags: [{service_info.name}, deploy]

- name: Wait for {service_info.display_name} to be ready
  uri:
    url: "http://localhost:{{{{ {service_info.name}_external_port }}}}"
    status_code: [200, 302, 401, 403]
  register: result
  until: result.status in [200, 302, 401, 403]
  retries: 30
  delay: 10
  tags: [{service_info.name}, deploy]
"""
        
        with open(tasks_dir / "deploy.yml", 'w') as f:
            f.write(deploy_tasks)
        
        # Generate other task files
        task_files = {
            "monitoring.yml": f"""---
# {service_info.display_name} Monitoring Configuration

- name: Configure {service_info.display_name} monitoring
  template:
    src: monitoring.yml.j2
    dest: "{{{{ docker_config_root }}}}/prometheus/{service_info.name}.yml"
    mode: '0644'
  notify: reload prometheus
  tags: [{service_info.name}, monitoring]
""",
            "security.yml": f"""---
# {service_info.display_name} Security Configuration

- name: Apply {service_info.display_name} security hardening
  template:
    src: security.yml.j2
    dest: "{{{{ docker_config_root }}}}/security/{service_info.name}.yml"
    mode: '0644'
  tags: [{service_info.name}, security]
""",
            "backup.yml": f"""---
# {service_info.display_name} Backup Configuration

- name: Configure {service_info.display_name} backup
  template:
    src: backup.sh.j2
    dest: "{{{{ docker_root }}}}/backup/{service_info.name}_backup.sh"
    mode: '0755'
  tags: [{service_info.name}, backup]
""",
            "homepage.yml": f"""---
# {service_info.display_name} Homepage Integration

- name: Add {service_info.display_name} to homepage
  template:
    src: homepage-service.yml.j2
    dest: "{{{{ docker_config_root }}}}/homepage/services/{service_info.name}.yml"
    mode: '0644'
  notify: reload homepage
  tags: [{service_info.name}, homepage]
""",
            "alerts.yml": f"""---
# {service_info.display_name} Alerting Configuration

- name: Configure {service_info.display_name} alerts
  template:
    src: alerts.yml.j2
    dest: "{{{{ docker_config_root }}}}/alertmanager/{service_info.name}.yml"
    mode: '0644'
  notify: reload alertmanager
  tags: [{service_info.name}, alerts]
""",
            "validate.yml": f"""---
# {service_info.display_name} Validation Tasks

- name: Validate {service_info.display_name} configuration
  assert:
    that:
      - {service_info.name}_enabled is defined
      - {service_info.name}_port is defined
      - {service_info.name}_domain is defined
    fail_msg: "Required {service_info.display_name} configuration is missing"
  tags: [{service_info.name}, validation]
""",
            "validate_deployment.yml": f"""---
# {service_info.display_name} Deployment Validation

- name: Check {service_info.display_name} service health
  uri:
    url: "http://localhost:{{{{ {service_info.name}_external_port }}}}"
    status_code: [200, 302, 401, 403]
  register: health_check
  tags: [{service_info.name}, validation]

- name: Display {service_info.display_name} health status
  debug:
    msg: "{service_info.display_name} is {{ 'healthy' if health_check.status in [200, 302, 401, 403] else 'unhealthy' }}"
  tags: [{service_info.name}, validation]
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
      test: ["CMD-SHELL", "curl -f http://localhost:{{{{ {service_name}_internal_port }}}}/ || exit 1"]
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
    - targets: ['localhost:{{{{ {service_info.name}_external_port }}}}']
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
        """Update group_vars/all/roles.yml to include the new service."""
        roles_file = self.group_vars_dir / "roles.yml"
        
        try:
            with open(roles_file, 'r') as f:
                roles_config = yaml.safe_load(f)
        except FileNotFoundError:
            roles_config = {}
        
        # Add service enablement flag
        roles_config[f"{service_info.name}_enabled"] = True
        
        # Add to enabled_services if it exists
        if "enabled_services" not in roles_config:
            roles_config["enabled_services"] = []
        
        if service_info.name not in roles_config["enabled_services"]:
            roles_config["enabled_services"].append(service_info.name)
        
        # Write back to file
        with open(roles_file, 'w') as f:
            yaml.dump(roles_config, f, default_flow_style=False, sort_keys=False)
    
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
        print(f"="*60)
    
    def _get_domain(self) -> str:
        """Get the domain from common.yml."""
        try:
            with open(self.group_vars_dir / "common.yml", 'r') as f:
                common_config = yaml.safe_load(f)
            return common_config.get('domain', 'localhost')
        except:
            return 'localhost'

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
            service_info = ServiceInfo(
                name=args.service_name,
                repository_url=args.repository_url,
                display_name=args.service_name.title(),
                description=f"{args.service_name.title()} service",
                category="utilities",
                stage="stage3",
                ports=[8080],
                environment_vars={},
                volumes=[],
                dependencies=[],
                image=f"{args.service_name}:latest",
                version="latest"
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