#!/usr/bin/env python3
"""
Automated Port Conflict Resolver for Ansible Homelab
====================================================

This script automatically detects and resolves port conflicts across the entire
homelab infrastructure by updating service configurations and port management files.

Features:
- Comprehensive port conflict detection
- Automatic conflict resolution with intelligent port assignment
- Updates both individual service configs and centralized port management
- Maintains service categorization and port ranges
- Generates detailed reports of changes made
- Integration with service wizard for new services

Usage:
    python3 port_conflict_resolver.py [--fix] [--report] [--dry-run]
"""

import yaml
import argparse
import sys
import os
from pathlib import Path
from typing import Dict, List, Tuple, Set, Optional
import subprocess
import json
from dataclasses import dataclass
import re

@dataclass
class PortConflict:
    """Represents a port conflict between services."""
    port: int
    services: List[str]
    primary_service: str
    conflicting_services: List[str]
    resolution: Optional[str] = None
    new_port: Optional[int] = None

@dataclass
class PortAssignment:
    """Represents a port assignment for a service."""
    service: str
    current_port: int
    category: str
    priority: int  # Higher priority services keep their ports
    new_port: Optional[int] = None

class PortConflictResolver:
    def __init__(self, homelab_root: str = "."):
        self.homelab_root = Path(homelab_root)
        self.port_management_file = self.homelab_root / "group_vars" / "all" / "port_management.yml"
        self.vault_file = self.homelab_root / "group_vars" / "all" / "vault.yml"
        self.roles_dir = self.homelab_root / "roles"
        self.conflicts = []
        self.assignments = []
        self.changes_made = []
        
        # Service priority levels (higher = more important)
        self.service_priorities = {
            'homepage': 100,  # Primary dashboard
            'portainer': 95,  # Container management
            'authentik': 90,  # Authentication
            'grafana': 85,    # Monitoring
            'prometheus': 80, # Monitoring
            'vault': 75,      # Secrets management
            'traefik': 70,    # Reverse proxy
            'nginx_proxy_manager': 65, # Reverse proxy
            'pihole': 60,     # DNS
            'jellyfin': 55,   # Media
            'sonarr': 50,     # Media
            'radarr': 50,     # Media
            'nextcloud': 45,  # Storage
            'vaultwarden': 40, # Password manager
            'immich': 35,     # Photos
            'paperless': 30,  # Document management
            'bookstack': 25,  # Documentation
            'linkwarden': 20, # Bookmarks
            'romm': 15,       # ROM management
            'pezzo': 10,      # AI prompts
            'fing': 5,        # Network discovery
            'fail2ban': 5,    # Security
            'crowdsec': 5,    # Security
            'calibre': 5,     # Books
            'qbittorrent': 5, # Downloads
            'sabnzbd': 5,     # Downloads
            'unmanic': 5,     # Media processing
            'duplicati': 5,   # Backup
            'komga': 5,       # Comics
            'reconya': 5,     # Network monitoring
            'dumbassets': 5,  # Asset management
            'guacamole': 5,   # Remote access
            'utilities': 5,   # Utilities
            'automation': 5,  # Automation
            'logging': 5,     # Logging
            'media': 5,       # Media
            'security': 5,    # Security
            'storage': 5,     # Storage
        }
        
        # Port ranges by category
        self.port_ranges = {
            'infrastructure': (1000, 1999),
            'monitoring': (2000, 2999),
            'web_applications': (3000, 3999),
            'media': (4000, 4999),
            'development': (5000, 5999),
            'storage': (6000, 6999),
            'security': (7000, 7999),
            'database': (8000, 8999),
            'specialized': (9000, 9999),
        }
        
        # Reserved ports that should not be used
        self.reserved_ports = {
            22, 25, 53, 80, 443, 143, 993, 110, 995, 587, 465, 1433, 1521
        }

    def load_port_management(self) -> Dict:
        """Load the centralized port management configuration."""
        try:
            with open(self.port_management_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            print(f"❌ Port management file not found: {self.port_management_file}")
            sys.exit(1)
        except yaml.YAMLError as e:
            print(f"❌ Error parsing port management file: {e}")
            sys.exit(1)

    def scan_service_configs(self) -> Dict[str, int]:
        """Scan all service configurations for port assignments."""
        service_ports = {}
        
        # Scan roles directory for port configurations
        if self.roles_dir.exists():
            for role_dir in self.roles_dir.iterdir():
                if role_dir.is_dir():
                    defaults_file = role_dir / "defaults" / "main.yml"
                    if defaults_file.exists():
                        try:
                            with open(defaults_file, 'r') as f:
                                config = yaml.safe_load(f)
                                if config:
                                    self._extract_ports_from_config(config, role_dir.name, service_ports)
                        except yaml.YAMLError:
                            continue
        
        # Scan group_vars for port configurations
        group_vars_dir = self.homelab_root / "group_vars" / "all"
        if group_vars_dir.exists():
            for yml_file in group_vars_dir.glob("*.yml"):
                try:
                    with open(yml_file, 'r') as f:
                        config = yaml.safe_load(f)
                        if config:
                            self._extract_ports_from_config(config, yml_file.stem, service_ports)
                except yaml.YAMLError:
                    continue
        
        return service_ports

    def _extract_ports_from_config(self, config: Dict, source: str, service_ports: Dict[str, int]):
        """Extract port assignments from a configuration dictionary."""
        def extract_ports(obj, prefix=""):
            if isinstance(obj, dict):
                for key, value in obj.items():
                    current_prefix = f"{prefix}.{key}" if prefix else key
                    if isinstance(value, (int, str)) and any(port_key in key.lower() for port_key in ['port', 'ports']):
                        try:
                            port = int(value)
                            if 1000 <= port <= 65535:  # Valid port range
                                service_ports[f"{source}.{current_prefix}"] = port
                        except (ValueError, TypeError):
                            pass
                    elif isinstance(value, (dict, list)):
                        extract_ports(value, current_prefix)
            elif isinstance(obj, list):
                for i, item in enumerate(obj):
                    extract_ports(item, f"{prefix}[{i}]")
        
        extract_ports(config)

    def detect_conflicts(self, service_ports: Dict[str, int]) -> List[PortConflict]:
        """Detect port conflicts between services."""
        port_usage = {}
        conflicts = []
        
        for service, port in service_ports.items():
            if port in port_usage:
                # Find the primary service (highest priority)
                existing_service = port_usage[port]
                primary_service = self._get_primary_service([existing_service, service])
                conflicting_services = [s for s in [existing_service, service] if s != primary_service]
                
                conflicts.append(PortConflict(
                    port=port,
                    services=[existing_service, service],
                    primary_service=primary_service,
                    conflicting_services=conflicting_services
                ))
            else:
                port_usage[port] = service
        
        return conflicts

    def _get_primary_service(self, services: List[str]) -> str:
        """Determine the primary service based on priority."""
        max_priority = -1
        primary_service = services[0]
        
        for service in services:
            # Extract service name from full path
            service_name = service.split('.')[-1] if '.' in service else service
            priority = self.service_priorities.get(service_name, 0)
            
            if priority > max_priority:
                max_priority = priority
                primary_service = service
        
        return primary_service

    def resolve_conflicts(self, conflicts: List[PortConflict], dry_run: bool = False) -> List[Dict]:
        """Automatically resolve port conflicts."""
        resolutions = []
        
        for conflict in conflicts:
            print(f"🔧 Resolving conflict on port {conflict.port}")
            print(f"   Primary service: {conflict.primary_service}")
            print(f"   Conflicting services: {', '.join(conflict.conflicting_services)}")
            
            # Assign new ports to conflicting services
            for conflicting_service in conflict.conflicting_services:
                new_port = self._find_available_port(conflicting_service)
                conflict.new_port = new_port
                
                resolution = {
                    'service': conflicting_service,
                    'old_port': conflict.port,
                    'new_port': new_port,
                    'reason': f"Conflict with {conflict.primary_service}"
                }
                
                if not dry_run:
                    self._update_service_port(conflicting_service, new_port)
                    self.changes_made.append(resolution)
                
                resolutions.append(resolution)
                print(f"   ✓ {conflicting_service}: {conflict.port} → {new_port}")
        
        return resolutions

    def _find_available_port(self, service: str) -> int:
        """Find an available port for a service."""
        used_ports = set()
        
        # Get all currently used ports
        service_ports = self.scan_service_configs()
        for port in service_ports.values():
            used_ports.add(port)
        
        # Add reserved ports
        used_ports.update(self.reserved_ports)
        
        # Determine service category and port range
        service_name = service.split('.')[-1] if '.' in service else service
        category = self._categorize_service(service_name)
        start_port, end_port = self.port_ranges.get(category, (10000, 65535))
        
        # Find available port in appropriate range
        for port in range(start_port, end_port):
            if port not in used_ports:
                return port
        
        # Fallback to high port range
        fallback_port = 10000
        while fallback_port in used_ports:
            fallback_port += 1
        
        return fallback_port

    def _categorize_service(self, service_name: str) -> str:
        """Categorize a service for port range assignment."""
        service_lower = service_name.lower()
        
        if any(word in service_lower for word in ['grafana', 'prometheus', 'alertmanager', 'loki', 'tempo']):
            return 'monitoring'
        elif any(word in service_lower for word in ['homepage', 'pezzo', 'immich', 'linkwarden', 'paperless', 'bookstack']):
            return 'web_applications'
        elif any(word in service_lower for word in ['jellyfin', 'sonarr', 'radarr', 'lidarr', 'bazarr', 'overseerr']):
            return 'media'
        elif any(word in service_lower for word in ['nextcloud', 'vaultwarden', 'minio', 'kopia', 'duplicati']):
            return 'storage'
        elif any(word in service_lower for word in ['authentik', 'pihole', 'wireguard', 'fail2ban', 'crowdsec']):
            return 'security'
        elif any(word in service_lower for word in ['postgresql', 'mysql', 'redis', 'mongodb', 'elasticsearch']):
            return 'database'
        elif any(word in service_lower for word in ['portainer', 'traefik', 'nginx', 'watchtower']):
            return 'infrastructure'
        elif any(word in service_lower for word in ['n8n', 'nodered', 'homeassistant', 'code_server']):
            return 'development'
        else:
            return 'specialized'

    def _update_service_port(self, service_path: str, new_port: int):
        """Update a service's port configuration."""
        # Parse service path to find the actual file
        parts = service_path.split('.')
        
        if len(parts) >= 2 and parts[0] in ['roles', 'group_vars']:
            if parts[0] == 'roles':
                # Update role defaults
                role_name = parts[1]
                defaults_file = self.roles_dir / role_name / "defaults" / "main.yml"
                if defaults_file.exists():
                    self._update_port_in_file(defaults_file, parts[-1], new_port)
            
            elif parts[0] == 'group_vars':
                # Update group_vars file
                file_name = parts[1]
                group_vars_file = self.homelab_root / "group_vars" / "all" / f"{file_name}.yml"
                if group_vars_file.exists():
                    self._update_port_in_file(group_vars_file, parts[-1], new_port)

    def _update_port_in_file(self, file_path: Path, port_key: str, new_port: int):
        """Update a port value in a YAML file."""
        try:
            with open(file_path, 'r') as f:
                content = yaml.safe_load(f)
            
            if content:
                # Find and update the port
                self._update_nested_dict(content, port_key, new_port)
                
                with open(file_path, 'w') as f:
                    yaml.dump(content, f, default_flow_style=False, indent=2)
                
                print(f"   ✓ Updated {file_path}")
        
        except Exception as e:
            print(f"   ⚠️  Could not update {file_path}: {e}")

    def _update_nested_dict(self, data: Dict, key: str, value: int):
        """Recursively update a nested dictionary."""
        for k, v in data.items():
            if k == key and isinstance(v, (int, str)):
                data[k] = value
                return True
            elif isinstance(v, dict):
                if self._update_nested_dict(v, key, value):
                    return True
            elif isinstance(v, list):
                for item in v:
                    if isinstance(item, dict):
                        if self._update_nested_dict(item, key, value):
                            return True
        return False

    def update_port_management(self, resolutions: List[Dict]):
        """Update the centralized port management file."""
        try:
            port_mgmt = self.load_port_management()
            
            # Update port assignments in the management file
            for resolution in resolutions:
                service_name = resolution['service'].split('.')[-1]
                new_port = resolution['new_port']
                
                # Update in appropriate section
                for section in ['infrastructure_ports', 'monitoring_ports', 'web_application_ports', 
                              'media_ports', 'development_ports', 'storage_ports', 'security_ports', 
                              'database_ports', 'specialized_ports']:
                    if section in port_mgmt and service_name in port_mgmt[section]:
                        port_mgmt[section][service_name] = new_port
                        break
            
            # Write updated file
            with open(self.port_management_file, 'w') as f:
                yaml.dump(port_mgmt, f, default_flow_style=False, indent=2)
            
            print(f"✓ Updated port management file: {self.port_management_file}")
        
        except Exception as e:
            print(f"⚠️  Could not update port management file: {e}")

    def update_vault_config(self, resolutions: List[Dict]):
        """Update the vault.yml service discovery configuration."""
        try:
            with open(self.vault_file, 'r') as f:
                vault_config = yaml.safe_load(f)
            
            if vault_config and 'vault_npm_discovery_services' in vault_config:
                for service in vault_config['vault_npm_discovery_services']:
                    service_name = service.get('name', '').lower()
                    
                    # Find matching resolution
                    for resolution in resolutions:
                        if service_name in resolution['service'].lower():
                            service['port'] = resolution['new_port']
                            print(f"✓ Updated vault config: {service_name} → {resolution['new_port']}")
                            break
            
            # Write updated file
            with open(self.vault_file, 'w') as f:
                yaml.dump(vault_config, f, default_flow_style=False, indent=2)
            
            print(f"✓ Updated vault configuration: {self.vault_file}")
        
        except Exception as e:
            print(f"⚠️  Could not update vault configuration: {e}")

    def generate_report(self, conflicts: List[PortConflict], resolutions: List[Dict]) -> str:
        """Generate a comprehensive report of port conflict resolution."""
        report = []
        report.append("=" * 80)
        report.append("PORT CONFLICT RESOLUTION REPORT")
        report.append("=" * 80)
        report.append("")
        
        report.append(f"📊 SUMMARY:")
        report.append(f"   • Conflicts detected: {len(conflicts)}")
        report.append(f"   • Resolutions applied: {len(resolutions)}")
        report.append(f"   • Services updated: {len(set(r['service'] for r in resolutions))}")
        report.append("")
        
        if conflicts:
            report.append("❌ CONFLICTS RESOLVED:")
            for conflict in conflicts:
                report.append(f"   • Port {conflict.port}: {', '.join(conflict.services)}")
                report.append(f"     → Primary: {conflict.primary_service}")
                report.append(f"     → Resolved: {', '.join(conflict.conflicting_services)}")
            report.append("")
        
        if resolutions:
            report.append("🔧 PORT CHANGES:")
            for resolution in resolutions:
                report.append(f"   • {resolution['service']}: {resolution['old_port']} → {resolution['new_port']}")
            report.append("")
        
        report.append("📋 FILES UPDATED:")
        for change in self.changes_made:
            report.append(f"   • {change['service']}: {change['old_port']} → {change['new_port']}")
        
        return "\n".join(report)

    def run(self, fix: bool = False, report: bool = False, dry_run: bool = False):
        """Run the port conflict resolution process."""
        print("🔍 Scanning homelab for port conflicts...")
        
        # Load configurations
        port_mgmt = self.load_port_management()
        service_ports = self.scan_service_configs()
        
        # Detect conflicts
        conflicts = self.detect_conflicts(service_ports)
        
        if not conflicts:
            print("✅ No port conflicts detected!")
            return
        
        print(f"❌ Found {len(conflicts)} port conflicts:")
        for conflict in conflicts:
            print(f"   • Port {conflict.port}: {', '.join(conflict.services)}")
        
        if fix:
            print("\n🔧 Resolving conflicts...")
            resolutions = self.resolve_conflicts(conflicts, dry_run)
            
            if not dry_run and resolutions:
                # Update centralized configurations
                self.update_port_management(resolutions)
                self.update_vault_config(resolutions)
                
                print(f"\n✅ Resolved {len(resolutions)} port conflicts!")
            elif dry_run:
                print(f"\n🔍 Dry run: Would resolve {len(resolutions)} port conflicts")
        
        if report:
            resolutions = self.resolve_conflicts(conflicts, dry_run=True)  # Get resolutions for report
            report_content = self.generate_report(conflicts, resolutions)
            print("\n" + report_content)
            
            # Save report
            report_file = self.homelab_root / "logs" / "port_conflict_resolution_report.txt"
            report_file.parent.mkdir(exist_ok=True)
            with open(report_file, 'w') as f:
                f.write(report_content)
            print(f"\n📄 Report saved to: {report_file}")

def main():
    parser = argparse.ArgumentParser(description="Automated Port Conflict Resolver")
    parser.add_argument("--fix", action="store_true", help="Automatically fix port conflicts")
    parser.add_argument("--report", action="store_true", help="Generate detailed report")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be changed without making changes")
    
    args = parser.parse_args()
    
    resolver = PortConflictResolver()
    resolver.run(fix=args.fix, report=args.report, dry_run=args.dry_run)

if __name__ == "__main__":
    main() 