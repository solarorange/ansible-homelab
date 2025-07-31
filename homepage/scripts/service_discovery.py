#!/usr/bin/env python3
"""
Dynamic Service Discovery for Homepage Dashboard

This script automatically discovers running services in the homelab and updates
the homepage configuration accordingly. It scans Docker containers, network
services, and configuration files to build a comprehensive service list.
"""

import sys
import os
import json
import yaml
import docker
import requests
import subprocess
from pathlib import Path
from typing import Dict, List, Optional, Any
import logging
from datetime import datetime
from logging_config import setup_logging, get_logger, log_function_call, log_execution_time, LogContext

# Setup centralized logging
LOG_DIR = os.environ.get('HOMEPAGE_LOG_DIR', './logs')
setup_logging(log_dir=LOG_DIR, log_level="INFO", json_output=True)
logger = get_logger("service_discovery")

class ServiceDiscovery:
    """Main service discovery class"""
    
    def __init__(self, config_dir: str = "/app/config"):
        self.config_dir = Path(config_dir)
        self.services_file = self.config_dir / "services.yml"
        self.docker_client = None
        self.discovered_services = {}
        
        # Service definitions with their expected configurations
        self.service_definitions = {
            # Infrastructure & Management
            'traefik': {
                'port': 8080,
                'health_path': '/ping',
                'widget_type': 'traefik',
                'group': 'Infrastructure & Management',
                'className': 'infrastructure-stack'
            },
            'authentik': {
                'port': 9000,
                'health_path': '/api/v3/core/health/',
                'widget_type': 'authentik',
                'group': 'Infrastructure & Management',
                'className': 'infrastructure-stack'
            },
            'portainer': {
                'port': 9000,
                'health_path': '/api/status',
                'widget_type': 'portainer',
                'group': 'Infrastructure & Management',
                'className': 'infrastructure-stack'
            },
            'watchtower': {
                'port': 8080,
                'health_path': '/v1/update',
                'widget_type': 'watchtower',
                'group': 'Infrastructure & Management',
                'className': 'infrastructure-stack'
            },
            
            # Monitoring & Observability
            'grafana': {
                'port': 3000,
                'health_path': '/api/health',
                'widget_type': 'grafana',
                'group': 'Monitoring & Observability',
                'className': 'monitoring-stack'
            },
            'prometheus': {
                'port': 9090,
                'health_path': '/-/healthy',
                'widget_type': 'prometheus',
                'group': 'Monitoring & Observability',
                'className': 'monitoring-stack'
            },
            'alertmanager': {
                'port': 9093,
                'health_path': '/-/healthy',
                'widget_type': 'alertmanager',
                'group': 'Monitoring & Observability',
                'className': 'monitoring-stack'
            },
            'loki': {
                'port': 3100,
                'health_path': '/ready',
                'widget_type': 'loki',
                'group': 'Monitoring & Observability',
                'className': 'monitoring-stack'
            },
            'uptime-kuma': {
                'port': 3001,
                'health_path': '/api/status',
                'widget_type': 'uptime_kuma',
                'group': 'Monitoring & Observability',
                'className': 'monitoring-stack'
            },
            'dashdot': {
                'port': 3001,
                'health_path': '/api/health',
                'widget_type': 'dashdot',
                'group': 'Monitoring & Observability',
                'className': 'monitoring-stack'
            },
            
            # Security & Network
            'crowdsec': {
                'port': 8080,
                'health_path': '/v1/decisions',
                'widget_type': 'crowdsec',
                'group': 'Security & Network',
                'className': 'security-stack'
            },
            'fail2ban': {
                'port': 8080,
                'health_path': '/status',
                'widget_type': 'fail2ban',
                'group': 'Security & Network',
                'className': 'security-stack'
            },
            'pihole': {
                'port': 80,
                'health_path': '/admin/api.php?status',
                'widget_type': 'pihole',
                'group': 'Security & Network',
                'className': 'security-stack'
            },
            'ufw': {
                'port': 8080,
                'health_path': '/status',
                'widget_type': 'ufw',
                'group': 'Security & Network',
                'className': 'security-stack'
            },
            'wireguard': {
                'port': 51820,
                'health_path': '/health',
                'widget_type': 'wireguard',
                'group': 'Security & Network',
                'className': 'security-stack'
            },
            
            # Databases & Storage
            'postgresql': {
                'port': 5432,
                'health_path': '/health',
                'widget_type': 'postgresql',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'mariadb': {
                'port': 3306,
                'health_path': '/health',
                'widget_type': 'mariadb',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'redis': {
                'port': 6379,
                'health_path': '/health',
                'widget_type': 'redis',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'elasticsearch': {
                'port': 9200,
                'health_path': '/_cluster/health',
                'widget_type': 'elasticsearch',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'kibana': {
                'port': 5601,
                'health_path': '/api/status',
                'widget_type': 'kibana',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'nextcloud': {
                'port': 8080,
                'health_path': '/status.php',
                'widget_type': 'nextcloud',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'vaultwarden': {
                'port': 80,
                'health_path': '/alive',
                'widget_type': 'vaultwarden',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            'paperless': {
                'port': 8000,
                'health_path': '/api/health',
                'widget_type': 'paperless',
                'group': 'Databases & Storage',
                'className': 'database-stack'
            },
            
            # Media Stack
            'jellyfin': {
                'port': 8096,
                'health_path': '/health',
                'widget_type': 'jellyfin',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'sonarr': {
                'port': 8989,
                'health_path': '/health',
                'widget_type': 'sonarr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'radarr': {
                'port': 7878,
                'health_path': '/health',
                'widget_type': 'radarr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'lidarr': {
                'port': 8686,
                'health_path': '/health',
                'widget_type': 'lidarr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'readarr': {
                'port': 8787,
                'health_path': '/health',
                'widget_type': 'readarr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'prowlarr': {
                'port': 9696,
                'health_path': '/health',
                'widget_type': 'prowlarr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'bazarr': {
                'port': 6767,
                'health_path': '/health',
                'widget_type': 'bazarr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'overseerr': {
                'port': 5055,
                'health_path': '/health',
                'widget_type': 'overseerr',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'tautulli': {
                'port': 8181,
                'health_path': '/status',
                'widget_type': 'tautulli',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'sabnzbd': {
                'port': 8080,
                'health_path': '/api?mode=version',
                'widget_type': 'sabnzbd',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'qbittorrent': {
                'port': 8080,
                'health_path': '/api/v2/app/version',
                'widget_type': 'qbittorrent',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            'immich': {
                'port': 3001,
                'health_path': '/api/health',
                'widget_type': 'immich',
                'group': 'Media Stack',
                'className': 'media-stack'
            },
            
            # Automation & Development
            'homeassistant': {
                'port': 8123,
                'health_path': '/api/',
                'widget_type': 'homeassistant',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            'nodered': {
                'port': 1880,
                'health_path': '/health',
                'widget_type': 'nodered',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            'n8n': {
                'port': 5678,
                'health_path': '/health',
                'widget_type': 'n8n',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            'zigbee2mqtt': {
                'port': 8080,
                'health_path': '/api/health',
                'widget_type': 'zigbee2mqtt',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            'code-server': {
                'port': 8080,
                'health_path': '/health',
                'widget_type': 'code_server',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            'gitlab': {
                'port': 80,
                'health_path': '/-/health',
                'widget_type': 'gitlab',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            'harbor': {
                'port': 80,
                'health_path': '/api/v2.0/health',
                'widget_type': 'harbor',
                'group': 'Automation & Development',
                'className': 'automation-stack'
            },
            
            # Backup & Recovery
            'kopia': {
                'port': 51515,
                'health_path': '/health',
                'widget_type': 'kopia',
                'group': 'Backup & Recovery',
                'className': 'backup-stack'
            },
            'duplicati': {
                'port': 8200,
                'health_path': '/health',
                'widget_type': 'duplicati',
                'group': 'Backup & Recovery',
                'className': 'backup-stack'
            },
            'restic': {
                'port': 8000,
                'health_path': '/health',
                'widget_type': 'restic',
                'group': 'Backup & Recovery',
                'className': 'backup-stack'
            },
            
            # Utilities & Tools
            'tdarr': {
                'port': 8265,
                'health_path': '/api/v2/status',
                'widget_type': 'tdarr',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            },
            'unmanic': {
                'port': 8888,
                'health_path': '/api/v2/status',
                'widget_type': 'unmanic',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            },
            'requestrr': {
                'port': 4545,
                'health_path': '/health',
                'widget_type': 'requestrr',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            },
            'pulsarr': {
                'port': 8080,
                'health_path': '/health',
                'widget_type': 'pulsarr',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            },
            'minio': {
                'port': 9000,
                'health_path': '/minio/health/live',
                'widget_type': 'minio',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            },
            'filebrowser': {
                'port': 80,
                'health_path': '/health',
                'widget_type': 'filebrowser',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            },
            'bookstack': {
                'port': 80,
                'health_path': '/health',
                'widget_type': 'bookstack',
                'group': 'Utilities & Tools',
                'className': 'utilities-stack'
            }
        }
        
        with LogContext(logger, {"service": "service_discovery", "action": "init"}):
            logger.info("ServiceDiscovery initialized")
        
        try:
            self.docker_client = docker.from_env()
        except Exception as e:
            logger.warning(f"Could not initialize Docker client: {e}")
    
    @log_function_call
    @log_execution_time
    def discover_docker_services(self) -> Dict[str, Any]:
        """Discover services running in Docker containers"""
        if not self.docker_client:
            return {}
        
        services = {}
        
        try:
            containers = self.docker_client.containers.list()
            
            for container in containers:
                container_name = container.name.lower()
                
                # Check if this container matches any known service
                for service_name, service_config in self.service_definitions.items():
                    if service_name in container_name:
                        logger.info(f"Found Docker service: {service_name}")
                        
                        # Get container IP
                        container_ip = container.attrs['NetworkSettings']['IPAddress']
                        if not container_ip:
                            # Try to get IP from networks
                            networks = container.attrs['NetworkSettings']['Networks']
                            if networks:
                                # Get the first non-default network IP
                                for network_name, network_info in networks.items():
                                    if network_name != 'bridge' and network_info.get('IPAddress'):
                                        container_ip = network_info['IPAddress']
                                        break
                                # Fallback to first available IP
                                if not container_ip:
                                    container_ip = list(networks.values())[0]['IPAddress']
                        
                        if container_ip:
                            services[service_name] = {
                                'name': service_name,
                                'type': 'docker',
                                'ip': container_ip,
                                'port': service_config['port'],
                                'health_path': service_config['health_path'],
                                'widget_type': service_config['widget_type'],
                                'group': service_config['group'],
                                'className': service_config['className'],
                                'container_id': container.id,
                                'status': container.status
                            }
        
        except Exception as e:
            logger.error(f"Error discovering Docker services: {e}")
        
        return services
    
    @log_function_call
    @log_execution_time
    def discover_network_services(self) -> Dict[str, Any]:
        """Discover services by scanning network ports"""
        services = {}
        
        # Common ports to scan
        common_ports = {
            80: ['http'],
            443: ['https'],
            3000: ['grafana', 'homepage'],
            3001: ['uptime-kuma', 'dashdot', 'immich'],
            8080: ['traefik', 'portainer', 'watchtower', 'crowdsec', 'fail2ban', 'ufw', 'nextcloud', 'sabnzbd', 'qbittorrent', 'zigbee2mqtt', 'code-server', 'pulsarr'],
            9000: ['authentik', 'portainer'],
            9090: ['prometheus'],
            9093: ['alertmanager'],
            3100: ['loki'],
            5432: ['postgresql'],
            3306: ['mariadb'],
            6379: ['redis'],
            9200: ['elasticsearch'],
            5601: ['kibana'],
            8096: ['jellyfin'],
            8989: ['sonarr'],
            7878: ['radarr'],
            8686: ['lidarr'],
            8787: ['readarr'],
            9696: ['prowlarr'],
            6767: ['bazarr'],
            5055: ['overseerr'],
            8181: ['tautulli'],
            8123: ['homeassistant'],
            1880: ['nodered'],
            5678: ['n8n'],
            51515: ['kopia'],
            8200: ['duplicati'],
            8000: ['paperless', 'restic'],
            8265: ['tdarr'],
            8888: ['unmanic'],
            4545: ['requestrr']
        }
        
        try:
            # Scan {{ ansible_default_ipv4.address }} for services
            for port, possible_services in common_ports.items():
                try:
                    response = requests.get(f"http://{{ ansible_default_ipv4.address }}:{port}", timeout=2)
                    if response.status_code == 200:
                        # Try to identify the service
                        for service_name in possible_services:
                            if service_name in self.service_definitions:
                                logger.info(f"Found network service: {service_name} on port {port}")
                                service_config = self.service_definitions[service_name]
                                
                                services[service_name] = {
                                    'name': service_name,
                                    'type': 'network',
                                    'ip': '{{ ansible_default_ipv4.address }}',
                                    'port': port,
                                    'health_path': service_config['health_path'],
                                    'widget_type': service_config['widget_type'],
                                    'group': service_config['group'],
                                    'className': service_config['className'],
                                    'status': 'running'
                                }
                                break
                except requests.exceptions.RequestException:
                    continue
        
        except Exception as e:
            logger.error(f"Error discovering network services: {e}")
        
        return services
    
    @log_function_call
    @log_execution_time
    def check_service_health(self, service: Dict[str, Any]) -> bool:
        """Check if a service is healthy"""
        try:
            url = f"http://{service['ip']}:{service['port']}{service['health_path']}"
            response = requests.get(url, timeout=5, verify=False)  # Allow self-signed certs
            return response.status_code == 200
        except requests.exceptions.SSLError:
            # Try HTTP if HTTPS fails
            try:
                url = f"http://{service['ip']}:{service['port']}{service['health_path']}"
                response = requests.get(url, timeout=5)
                return response.status_code == 200
            except Exception as e:
                logger.debug(f"HTTP health check failed for {service['name']}: {e}")
                return False
        except Exception as e:
            logger.debug(f"Health check failed for {service['name']}: {e}")
            return False
    
    def generate_service_config(self, services: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Generate homepage service configuration"""
        # Group services by their group
        grouped_services = {}
        
        for service_name, service_data in services.items():
            group = service_data['group']
            if group not in grouped_services:
                grouped_services[group] = []
            
            # Create service entry
            service_entry = {
                service_data['name'].title(): {
                    'icon': f"{service_data['name']}.png",
                    'href': f"https://{service_data['name']}.{{{{ domain }}}}",
                    'description': self.get_service_description(service_data['name']),
                    'widget': {
                        'type': service_data['widget_type'],
                        'url': f"http://{service_data['ip']}:{service_data['port']}",
                        'key': f"your_{service_data['name']}_api_key"
                    },
                    'health': {
                        'url': f"http://{service_data['ip']}:{service_data['port']}{service_data['health_path']}",
                        'interval': 30
                    },
                    'auth': {
                        'type': 'api_key' if service_data['widget_type'] != 'none' else 'none'
                    }
                }
            }
            
            grouped_services[group].append(service_entry)
        
        # Convert to homepage format
        homepage_config = []
        
        for group_name, group_services in grouped_services.items():
            group_config = {
                'group': group_name,
                'icon': self.get_group_icon(group_name),
                'className': self.get_group_class_name(group_name),
                'items': group_services
            }
            homepage_config.append(group_config)
        
        return homepage_config
    
    def get_service_description(self, service_name: str) -> str:
        """Get service description"""
        descriptions = {
            'traefik': 'Reverse Proxy & Load Balancer',
            'authentik': 'Identity & Access Management',
            'portainer': 'Container Management & Orchestration',
            'watchtower': 'Automated Container Updates',
            'grafana': 'Metrics Dashboard & Visualization',
            'prometheus': 'Metrics Collection & Storage',
            'alertmanager': 'Alert Management & Routing',
            'loki': 'Log Aggregation & Query',
            'uptime-kuma': 'Uptime Monitoring',
            'dashdot': 'System Dashboard',
            'crowdsec': 'Intrusion Detection & Prevention',
            'fail2ban': 'Intrusion Prevention System',
            'pihole': 'DNS Ad-blocking & Filtering',
            'ufw': 'Uncomplicated Firewall Status',
            'wireguard': 'VPN Server',
            'postgresql': 'Primary Database',
            'mariadb': 'Alternative Database',
            'redis': 'Cache & Session Store',
            'elasticsearch': 'Search Engine',
            'kibana': 'Elasticsearch UI',
            'nextcloud': 'File Storage & Collaboration',
            'vaultwarden': 'Password Manager',
            'paperless': 'Document Management',
            'jellyfin': 'Media Server & Streaming',
            'sonarr': 'TV Show Management & Automation',
            'radarr': 'Movie Management & Automation',
            'lidarr': 'Music Management & Automation',
            'readarr': 'Book Management & Automation',
            'prowlarr': 'Indexer Management',
            'bazarr': 'Subtitle Management',
            'overseerr': 'Media Requests & Discovery',
            'tautulli': 'Media Statistics & Analytics',
            'sabnzbd': 'Usenet Downloader',
            'qbittorrent': 'Torrent Client',
            'immich': 'Photo Management',
            'homeassistant': 'Home Automation Platform',
            'nodered': 'Flow-based Programming',
            'n8n': 'Workflow Automation',
            'zigbee2mqtt': 'Zigbee Bridge',
            'code-server': 'Web-based VS Code',
            'gitlab': 'Git Repository Management',
            'harbor': 'Container Registry',
            'kopia': 'Fast & Secure Backup',
            'duplicati': 'Encrypted Backup Solution',
            'restic': 'Fast, Secure Backup',
            'tdarr': 'Distributed Media Transcoding',
            'unmanic': 'Media Library Optimizer',
            'requestrr': 'Discord Bot for Media Requests',
            'pulsarr': 'ARR Service Status Dashboard',
            'minio': 'Object Storage',
            'filebrowser': 'Web File Manager',
            'bookstack': 'Wiki & Documentation'
        }
        
        return descriptions.get(service_name, f'{service_name.title()} Service')
    
    def get_group_icon(self, group_name: str) -> str:
        """Get group icon"""
        icons = {
            'Infrastructure & Management': 'settings.png',
            'Monitoring & Observability': 'chart.png',
            'Security & Network': 'shield.png',
            'Databases & Storage': 'database.png',
            'Media Stack': 'tv.png',
            'Automation & Development': 'automation.png',
            'Backup & Recovery': 'backup.png',
            'Utilities & Tools': 'tools.png',
            'External Resources': 'external.png'
        }
        
        return icons.get(group_name, 'default.png')
    
    def get_group_class_name(self, group_name: str) -> str:
        """Get group CSS class name"""
        class_names = {
            'Infrastructure & Management': 'infrastructure-stack',
            'Monitoring & Observability': 'monitoring-stack',
            'Security & Network': 'security-stack',
            'Databases & Storage': 'database-stack',
            'Media Stack': 'media-stack',
            'Automation & Development': 'automation-stack',
            'Backup & Recovery': 'backup-stack',
            'Utilities & Tools': 'utilities-stack',
            'External Resources': 'external-stack'
        }
        
        return class_names.get(group_name, 'default-stack')
    
    def update_services_config(self, services: Dict[str, Any]) -> None:
        """Update the services.yml configuration file"""
        try:
            # Generate new configuration
            new_config = self.generate_service_config(services)
            
            # Create backup of current config
            if self.services_file.exists():
                backup_file = self.services_file.with_suffix('.yml.backup')
                self.services_file.rename(backup_file)
                logger.info(f"Created backup: {backup_file}")
            
            # Write new configuration
            with open(self.services_file, 'w') as f:
                yaml.dump(new_config, f, default_flow_style=False, sort_keys=False)
            
            logger.info(f"Updated services configuration: {self.services_file}")
            
        except Exception as e:
            logger.error(f"Error updating services configuration: {e}")
    
    @log_function_call
    @log_execution_time
    def run_discovery(self) -> None:
        """Run the complete service discovery process"""
        with LogContext(logger, {"service": "service_discovery", "action": "run_discovery"}):
            logger.info("Starting service discovery...")
        
        # Discover services
        docker_services = self.discover_docker_services()
        network_services = self.discover_network_services()
        
        # Merge services (Docker services take precedence)
        all_services = {**network_services, **docker_services}
        
        with LogContext(logger, {"service": "service_discovery", "action": "run_discovery"}):
            logger.info(f"Discovered {len(all_services)} services")
        
        # Check health of discovered services
        healthy_services = {}
        for service_name, service_data in all_services.items():
            if self.check_service_health(service_data):
                healthy_services[service_name] = service_data
                with LogContext(logger, {"service": "service_discovery", "action": "run_discovery", "service_name": service_name}):
                    logger.info(f"Service {service_name} is healthy")
            else:
                with LogContext(logger, {"service": "service_discovery", "action": "run_discovery", "service_name": service_name}):
                    logger.warning(f"Service {service_name} is not responding")
        
        # Update configuration
        if healthy_services:
            self.update_services_config(healthy_services)
        else:
            with LogContext(logger, {"service": "service_discovery", "action": "run_discovery"}):
                logger.warning("No healthy services found")
        
        with LogContext(logger, {"service": "service_discovery", "action": "run_discovery"}):
            logger.info("Service discovery completed")

def main():
    """Main entry point"""
    discovery = ServiceDiscovery()
    try:
        discovery.run_discovery()
        # Check if any healthy services were discovered (by checking if services.yml was updated and is not empty)
        services_file = discovery.services_file
        if not services_file.exists():
            logger.error("No services configuration file generated. Exiting with error.")
            sys.exit(1)
        with open(services_file, 'r') as f:
            config = yaml.safe_load(f)
            if not config or not any(group.get('items') for group in config):
                logger.error("No healthy services discovered. Exiting with error.")
                sys.exit(1)
    except Exception as e:
        logger.error(f"Critical error in service discovery: {e}", exc_info=True)
        sys.exit(1)

if __name__ == "__main__":
    main() 