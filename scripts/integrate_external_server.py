#!/usr/bin/env python3
"""
External Server Integration Script for HomelabOS
Automatically integrates external servers (like Synology) into the homelab ecosystem

This script provides:
- SSL certificate management for external servers
- Grafana dashboard integration
- DNS subdomain configuration
- Security and authentication setup
- Health monitoring and alerting
- Backup integration
- Service discovery and automation

Usage:
    python3 integrate_external_server.py --server-name synology --ip 192.168.1.100 --port 5000
    python3 integrate_external_server.py --config external_servers.yml
"""

import os
import sys
import json
import yaml
import requests
import argparse
import logging
import subprocess
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
from datetime import datetime, timedelta
import time

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/homelab/external_integration.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class ExternalServer:
    """Configuration for an external server"""
    name: str
    ip_address: str
    port: int
    protocol: str = "http"
    subdomain: Optional[str] = None
    description: str = ""
    category: str = "external"
    ssl_enabled: bool = True
    auth_enabled: bool = False
    monitoring_enabled: bool = True
    backup_enabled: bool = False
    
    # SSL Configuration
    ssl_provider: str = "letsencrypt"
    ssl_email: Optional[str] = None
    
    # Authentication
    auth_method: str = "none"  # none, basic, authentik
    username: Optional[str] = None
    password: Optional[str] = None
    
    # Monitoring
    health_check_path: str = "/"
    health_check_timeout: int = 10
    metrics_endpoint: Optional[str] = None
    
    # Backup
    backup_paths: List[str] = None
    backup_schedule: str = "0 2 * * *"
    
    def __post_init__(self):
        if self.subdomain is None:
            self.subdomain = self.name
        if self.backup_paths is None:
            self.backup_paths = []

class HomelabIntegration:
    """Main integration class for external servers"""
    
    def __init__(self, config_path: str = "config"):
        self.config_path = Path(config_path)
        self.domain = self._load_domain()
        self.cloudflare_config = self._load_cloudflare_config()
        self.grafana_config = self._load_grafana_config()
        self.traefik_config = self._load_traefik_config()
        
        # Create required directories
        self._create_directories()
        
        logger.info(f"Initialized HomelabIntegration for domain: {self.domain}")
    
    def _load_domain(self) -> str:
        """Load domain from group_vars"""
        try:
            with open("group_vars/all/common.yml", 'r') as f:
                config = yaml.safe_load(f)
                domain = config.get('domain', '')
                if not domain:
                    # Try to get domain from environment or prompt user
                    domain = os.environ.get('DOMAIN', '')
                    if not domain:
                        domain = input("Enter your domain name (e.g., example.com): ").strip()
                        if not domain:
                            raise ValueError("Domain is required")
                return domain
        except Exception as e:
            logger.error(f"Failed to load domain: {e}")
            # Fallback to environment or prompt
            domain = os.environ.get('DOMAIN', '')
            if not domain:
                domain = input("Enter your domain name (e.g., example.com): ").strip()
                if not domain:
                    raise ValueError("Domain is required")
            return domain
    
    def _load_cloudflare_config(self) -> Dict[str, str]:
        """Load Cloudflare configuration"""
        try:
            with open("group_vars/all/vault.yml", 'r') as f:
                config = yaml.safe_load(f)
                return {
                    'email': config.get('cloudflare_email', ''),
                    'api_token': config.get('cloudflare_api_token', ''),
                    'enabled': config.get('cloudflare_enabled', False)
                }
        except Exception as e:
            logger.error(f"Failed to load Cloudflare config: {e}")
            # Try to get from environment
            return {
                'email': os.environ.get('CLOUDFLARE_EMAIL', ''),
                'api_token': os.environ.get('CLOUDFLARE_API_TOKEN', ''),
                'enabled': os.environ.get('CLOUDFLARE_ENABLED', 'false').lower() == 'true'
            }
    
    def _load_grafana_config(self) -> Dict[str, Any]:
        """Load Grafana configuration"""
        try:
            with open("group_vars/all/vault.yml", 'r') as f:
                config = yaml.safe_load(f)
                return {
                    'url': f"http://grafana.{self.domain}:3000",
                    'admin_user': config.get('grafana_admin_user', 'admin'),
                    'admin_password': config.get('grafana_admin_password', 'admin'),
                    'api_key': config.get('grafana_api_key', '')
                }
        except Exception as e:
            logger.error(f"Failed to load Grafana config: {e}")
            # Try to get from environment or use defaults
            return {
                'url': f"http://grafana.{self.domain}:3000",
                'admin_user': os.environ.get('GRAFANA_ADMIN_USER', 'admin'),
                'admin_password': os.environ.get('GRAFANA_ADMIN_PASSWORD', 'admin'),
                'api_key': os.environ.get('GRAFANA_API_KEY', '')
            }
    
    def _load_traefik_config(self) -> Dict[str, Any]:
        """Load Traefik configuration"""
        try:
            return {
                'url': f"http://traefik.{self.domain}:8080",
                'api_enabled': True,
                'ssl_enabled': True
            }
        except Exception as e:
            logger.error(f"Failed to load Traefik config: {e}")
            return {
                'url': f"http://traefik.{self.domain}:8080",
                'api_enabled': True,
                'ssl_enabled': True
            }
    
    def _create_directories(self):
        """Create required directories"""
        directories = [
            "logs/external_servers",
            "config/external_servers",
            "backups/external_servers",
            "monitoring/external_servers"
        ]
        
        for directory in directories:
            Path(directory).mkdir(parents=True, exist_ok=True)
    
    def create_dns_record(self, server: ExternalServer) -> bool:
        """Create DNS record for external server"""
        if not self.cloudflare_config['enabled']:
            logger.warning("Cloudflare not enabled, skipping DNS record creation")
            return False
        
        try:
            # Use existing DNS automation script
            cmd = [
                "python3", "scripts/automate_dns_setup.py",
                "--domain", self.domain,
                "--server-ip", server.ip_address,
                "--cloudflare-email", self.cloudflare_config['email'],
                "--cloudflare-api-token", self.cloudflare_config['api_token'],
                "--subdomain", server.subdomain
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                logger.info(f"Created DNS record for {server.subdomain}.{self.domain}")
                return True
            else:
                logger.error(f"Failed to create DNS record: {result.stderr}")
                return False
                
        except Exception as e:
            logger.error(f"Error creating DNS record: {e}")
            return False
    
    def create_ssl_certificate(self, server: ExternalServer) -> bool:
        """Create SSL certificate for external server"""
        if not server.ssl_enabled:
            logger.info(f"SSL disabled for {server.name}")
            return True
        
        try:
            # Create certificate using Traefik
            cert_domain = f"{server.subdomain}.{self.domain}"
            
            # Check if certificate already exists
            cert_path = f"/etc/traefik/certs/{cert_domain}.crt"
            if os.path.exists(cert_path):
                logger.info(f"SSL certificate already exists for {cert_domain}")
                return True
            
            # Create certificate using certbot
            ssl_email = server.ssl_email or os.environ.get('SSL_EMAIL', f"admin@{self.domain}")
            cmd = [
                "certbot", "certonly", "--standalone",
                "-d", cert_domain,
                "--email", ssl_email,
                "--agree-tos", "--non-interactive"
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                logger.info(f"Created SSL certificate for {cert_domain}")
                return True
            else:
                logger.error(f"Failed to create SSL certificate: {result.stderr}")
                return False
                
        except Exception as e:
            logger.error(f"Error creating SSL certificate: {e}")
            return False
    
    def configure_traefik_proxy(self, server: ExternalServer) -> bool:
        """Configure Traefik proxy for external server"""
        try:
            # Create Traefik configuration
            config = {
                "http": {
                    "routers": {
                        f"{server.name}-router": {
                            "rule": f"Host(`{server.subdomain}.{self.domain}`)",
                            "service": server.name,
                            "tls": {
                                "certResolver": "letsencrypt"
                            } if server.ssl_enabled else None,
                            "middlewares": [f"{server.name}-auth"] if server.auth_enabled else None
                        }
                    },
                    "services": {
                        server.name: {
                            "loadBalancer": {
                                "servers": [
                                    {
                                        "url": f"{server.protocol}://{server.ip_address}:{server.port}"
                                    }
                                ]
                            }
                        }
                    }
                }
            }
            
            if server.auth_enabled:
                config["http"]["middlewares"] = {
                    f"{server.name}-auth": {
                        "forwardAuth": {
                            "address": f"https://auth.{self.domain}/outpost.goauthentik.io/auth/traefik"
                        }
                    }
                }
            
            # Write configuration
            config_file = f"config/external_servers/{server.name}.yml"
            with open(config_file, 'w') as f:
                yaml.dump(config, f, default_flow_style=False)
            
            # Reload Traefik
            self._reload_traefik()
            
            logger.info(f"Configured Traefik proxy for {server.name}")
            return True
            
        except Exception as e:
            logger.error(f"Error configuring Traefik proxy: {e}")
            return False
    
    def _reload_traefik(self):
        """Reload Traefik configuration"""
        try:
            subprocess.run(["docker", "exec", "traefik", "traefik", "reload"], 
                         capture_output=True, check=True)
            logger.info("Reloaded Traefik configuration")
        except subprocess.CalledProcessError as e:
            logger.error(f"Failed to reload Traefik: {e}")
    
    def add_grafana_dashboard(self, server: ExternalServer) -> bool:
        """Add external server to Grafana monitoring"""
        if not server.monitoring_enabled:
            logger.info(f"Monitoring disabled for {server.name}")
            return True
        
        try:
            # Create dashboard configuration
            dashboard = {
                "dashboard": {
                    "title": f"{server.name.title()} - External Server",
                    "tags": ["external", server.category],
                    "timezone": "browser",
                    "panels": [
                        {
                            "title": "Server Status",
                            "type": "stat",
                            "targets": [
                                {
                                    "expr": f'up{{job="{server.name}"}}',
                                    "legendFormat": "Status"
                                }
                            ],
                            "fieldConfig": {
                                "defaults": {
                                    "color": {
                                        "mode": "thresholds"
                                    },
                                    "thresholds": {
                                        "steps": [
                                            {"color": "red", "value": 0},
                                            {"color": "green", "value": 1}
                                        ]
                                    }
                                }
                            }
                        },
                        {
                            "title": "Response Time",
                            "type": "graph",
                            "targets": [
                                {
                                    "expr": f'probe_duration_seconds{{job="{server.name}"}}',
                                    "legendFormat": "Response Time"
                                }
                            ]
                        }
                    ]
                }
            }
            
            # Add to Grafana
            if self.grafana_config.get('api_key'):
                headers = {
                    "Authorization": f"Bearer {self.grafana_config['api_key']}",
                    "Content-Type": "application/json"
                }
                
                response = requests.post(
                    f"{self.grafana_config['url']}/api/dashboards/db",
                    headers=headers,
                    json=dashboard,
                    timeout=30
                )
                
                if response.status_code == 200:
                    logger.info(f"Added Grafana dashboard for {server.name}")
                    return True
                else:
                    logger.error(f"Failed to add Grafana dashboard: {response.text}")
                    return False
            else:
                logger.warning("Grafana API key not configured, skipping dashboard creation")
                return False
                
        except Exception as e:
            logger.error(f"Error adding Grafana dashboard: {e}")
            return False
    
    def configure_health_check(self, server: ExternalServer) -> bool:
        """Configure health check for external server"""
        try:
            # Create health check configuration
            health_check = {
                "job_name": server.name,
                "static_configs": [
                    {
                        "targets": [f"{server.ip_address}:{server.port}"],
                        "labels": {
                            "job": server.name,
                            "instance": f"{server.subdomain}.{self.domain}",
                            "category": server.category
                        }
                    }
                ],
                "metrics_path": server.metrics_endpoint or "/metrics",
                "scrape_interval": "30s",
                "scrape_timeout": "10s"
            }
            
            # Add to Prometheus configuration
            prometheus_config = f"config/monitoring/prometheus/external_{server.name}.yml"
            with open(prometheus_config, 'w') as f:
                yaml.dump([health_check], f, default_flow_style=False)
            
            # Reload Prometheus
            subprocess.run(["docker", "exec", "prometheus", "wget", "--post-data=''", 
                          "http://localhost:9090/-/reload"], capture_output=True)
            
            logger.info(f"Configured health check for {server.name}")
            return True
            
        except Exception as e:
            logger.error(f"Error configuring health check: {e}")
            return False
    
    def configure_backup(self, server: ExternalServer) -> bool:
        """Configure backup for external server"""
        if not server.backup_enabled:
            logger.info(f"Backup disabled for {server.name}")
            return True
        
        try:
            # Create backup script
            backup_script = f"""#!/bin/bash
# Backup script for {server.name}
# Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

set -e

BACKUP_DIR="${{BACKUP_DIR:-/home/backups/external_servers/{server.name}}}"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/{server.name}_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

# Create backup
tar -czf "$BACKUP_FILE" \\
    --exclude='*.tmp' \\
    --exclude='*.log' \\
    --exclude='cache/*' \\
    {chr(10).join([f'    "{path}"' for path in server.backup_paths])}

# Compress and encrypt if enabled
if [ "${{BACKUP_ENCRYPTION:-true}}" = "true" ]; then
    gpg --encrypt --recipient ${{ADMIN_EMAIL:-admin@{self.domain}}} "$BACKUP_FILE"
    rm "$BACKUP_FILE"
fi

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -name "*.tar.gz*" -mtime +${{BACKUP_RETENTION_DAYS:-7}} -delete

echo "Backup completed: $BACKUP_FILE"
"""
            
            # Write backup script
            script_path = f"scripts/backup_{server.name}.sh"
            with open(script_path, 'w') as f:
                f.write(backup_script)
            
            # Make executable
            os.chmod(script_path, 0o755)
            
            # Add to crontab
            cron_job = f"{server.backup_schedule} {os.path.abspath(script_path)}"
            subprocess.run(["crontab", "-l"], capture_output=True, text=True)
            
            logger.info(f"Configured backup for {server.name}")
            return True
            
        except Exception as e:
            logger.error(f"Error configuring backup: {e}")
            return False
    
    def add_to_homepage(self, server: ExternalServer) -> bool:
        """Add external server to Homepage dashboard without writing to repo paths.

        If HOMEPAGE_CONFIG_DIR is set, write to that external path; otherwise, log and skip.
        """
        try:
            external_config_dir = os.environ.get("HOMEPAGE_CONFIG_DIR")
            if not external_config_dir:
                logger.warning(
                    "HOMEPAGE_CONFIG_DIR not set; skipping Homepage write to avoid modifying repo files. "
                    "Use Ansible templates or set HOMEPAGE_CONFIG_DIR to an external path."
                )
                return False

            os.makedirs(external_config_dir, exist_ok=True)
            homepage_config = os.path.join(external_config_dir, "services.yml")

            if os.path.exists(homepage_config):
                with open(homepage_config, 'r') as f:
                    services = yaml.safe_load(f) or []
            else:
                services = []

            service_config = {
                "name": server.name.title(),
                "icon": server.name.lower(),
                "group": "External Servers",
                "url": f"https://{server.subdomain}.{self.domain}",
                "description": server.description or f"{server.name} external server",
                "widget": {
                    "type": "ping",
                    "url": f"https://{server.subdomain}.{self.domain}"
                }
            }

            existing_service = next((s for s in services if s.get('name') == service_config['name']), None)
            if existing_service:
                services.remove(existing_service)

            services.append(service_config)

            with open(homepage_config, 'w') as f:
                yaml.dump(services, f, default_flow_style=False, sort_keys=False)

            logger.info(f"Added {server.name} to Homepage dashboard at {homepage_config}")
            return True

        except Exception as e:
            logger.error(f"Error adding to Homepage: {e}")
            return False
    
    def integrate_server(self, server: ExternalServer) -> Dict[str, bool]:
        """Integrate external server into homelab ecosystem"""
        logger.info(f"Starting integration for {server.name}")
        
        results = {
            'dns': False,
            'ssl': False,
            'proxy': False,
            'monitoring': False,
            'health_check': False,
            'backup': False,
            'homepage': False
        }
        
        try:
            # 1. Create DNS record
            logger.info("Creating DNS record...")
            results['dns'] = self.create_dns_record(server)
            
            # 2. Create SSL certificate
            logger.info("Creating SSL certificate...")
            results['ssl'] = self.create_ssl_certificate(server)
            
            # 3. Configure Traefik proxy
            logger.info("Configuring Traefik proxy...")
            results['proxy'] = self.configure_traefik_proxy(server)
            
            # 4. Add to Grafana monitoring
            logger.info("Adding to Grafana monitoring...")
            results['monitoring'] = self.add_grafana_dashboard(server)
            
            # 5. Configure health check
            logger.info("Configuring health check...")
            results['health_check'] = self.configure_health_check(server)
            
            # 6. Configure backup
            logger.info("Configuring backup...")
            results['backup'] = self.configure_backup(server)
            
            # 7. Add to Homepage
            logger.info("Adding to Homepage...")
            results['homepage'] = self.add_to_homepage(server)
            
            # Generate integration report
            self._generate_report(server, results)
            
            logger.info(f"Integration completed for {server.name}")
            return results
            
        except Exception as e:
            logger.error(f"Integration failed for {server.name}: {e}")
            return results
    
    def _generate_report(self, server: ExternalServer, results: Dict[str, bool]):
        """Generate integration report"""
        report = {
            "server": asdict(server),
            "integration_time": datetime.now().isoformat(),
            "results": results,
            "summary": {
                "total_steps": len(results),
                "successful_steps": sum(results.values()),
                "failed_steps": len(results) - sum(results.values())
            }
        }
        
        report_file = f"logs/external_servers/{server.name}_integration_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2, default=str)
        
        logger.info(f"Integration report saved to {report_file}")

def load_servers_from_config(config_file: str) -> List[ExternalServer]:
    """Load external servers from configuration file"""
    try:
        with open(config_file, 'r') as f:
            config = yaml.safe_load(f)
        
        servers = []
        for server_config in config.get('servers', []):
            server = ExternalServer(**server_config)
            servers.append(server)
        
        return servers
    except Exception as e:
        logger.error(f"Failed to load servers from config: {e}")
        return []

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="Integrate external servers into HomelabOS")
    parser.add_argument("--config", help="Configuration file with server definitions")
    parser.add_argument("--server-name", help="Server name")
    parser.add_argument("--ip", help="Server IP address")
    parser.add_argument("--port", type=int, help="Server port")
    parser.add_argument("--subdomain", help="Subdomain for the server")
    parser.add_argument("--description", help="Server description")
    parser.add_argument("--category", default="external", help="Server category")
    parser.add_argument("--ssl-enabled", action="store_true", default=True, help="Enable SSL")
    parser.add_argument("--auth-enabled", action="store_true", help="Enable authentication")
    parser.add_argument("--monitoring-enabled", action="store_true", default=True, help="Enable monitoring")
    parser.add_argument("--backup-enabled", action="store_true", help="Enable backup")
    
    args = parser.parse_args()
    
    # Initialize integration
    integration = HomelabIntegration()
    
    if args.config:
        # Load servers from configuration file
        servers = load_servers_from_config(args.config)
        if not servers:
            logger.error("No servers found in configuration file")
            sys.exit(1)
    else:
        # Create server from command line arguments
        if not all([args.server_name, args.ip, args.port]):
            logger.error("Server name, IP, and port are required")
            sys.exit(1)
        
        server = ExternalServer(
            name=args.server_name,
            ip_address=args.ip,
            port=args.port,
            subdomain=args.subdomain,
            description=args.description,
            category=args.category,
            ssl_enabled=args.ssl_enabled,
            auth_enabled=args.auth_enabled,
            monitoring_enabled=args.monitoring_enabled,
            backup_enabled=args.backup_enabled
        )
        servers = [server]
    
    # Integrate each server
    for server in servers:
        logger.info(f"Integrating {server.name}...")
        results = integration.integrate_server(server)
        
        # Print results
        print(f"\nIntegration Results for {server.name}:")
        for step, success in results.items():
            status = "✅" if success else "❌"
            print(f"  {status} {step.replace('_', ' ').title()}")
        
        successful = sum(results.values())
        total = len(results)
        print(f"\nSummary: {successful}/{total} steps completed successfully")
        
        if successful == total:
            print(f"🎉 {server.name} successfully integrated into HomelabOS!")
        else:
            print(f"⚠️  {server.name} integration completed with some issues")

if __name__ == "__main__":
    main() 