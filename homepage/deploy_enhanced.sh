#!/bin/bash
# =============================================================================
# HOMELAB HOMEPAGE - ENHANCED DEPLOYMENT SCRIPT
# =============================================================================
# This script deploys a comprehensive homepage dashboard for the homelab
# with complete service integration, widgets, and monitoring capabilities.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
BACKUP_DIR="$SCRIPT_DIR/backups"
LOGS_DIR="$SCRIPT_DIR/logs"
DOMAIN="${DOMAIN:-homelab.local}"
HOMEPAGE_PORT="${HOMEPAGE_PORT:-3000}"
TIMEZONE="${TIMEZONE:-$(timedatectl show --property=Timezone --value 2>/dev/null || echo 'UTC')}"

# Create necessary directories
mkdir -p "$CONFIG_DIR" "$BACKUP_DIR" "$LOGS_DIR"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    log "Docker is running"
}

# Function to check if required tools are installed
check_dependencies() {
    local missing_deps=()
    
    for dep in docker docker-compose curl jq yq python3 pip3; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        error "Missing dependencies: ${missing_deps[*]}"
        error "Please install the missing dependencies and try again."
        exit 1
    fi
    
    log "All system dependencies are installed"
}

# Function to install Python dependencies
install_python_deps() {
    log "Installing Python dependencies..."
    
    if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
        if pip3 install -r "$SCRIPT_DIR/requirements.txt" --user; then
            log "Python dependencies installed successfully"
        else
            error "Failed to install Python dependencies"
            exit 1
        fi
    else
        warn "requirements.txt not found, installing core dependencies manually"
        pip3 install --user cryptography requests PyYAML python-dotenv certifi structlog
    fi
}

# Function to validate Python environment
validate_python_env() {
    log "Validating Python environment..."
    
    # Test cryptography import
    if ! python3 -c "import cryptography; print('Cryptography OK')" 2>/dev/null; then
        error "Cryptography library not available"
        exit 1
    fi
    
    # Test requests import
    if ! python3 -c "import requests; print('Requests OK')" 2>/dev/null; then
        error "Requests library not available"
        exit 1
    fi
    
    # Test PyYAML import
    if ! python3 -c "import yaml; print('PyYAML OK')" 2>/dev/null; then
        error "PyYAML library not available"
        exit 1
    fi
    
    log "Python environment validated successfully"
}

# Function to backup existing configuration
backup_config() {
    if [ -f "$CONFIG_DIR/config.yml" ]; then
        local backup_file="$BACKUP_DIR/config_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$backup_file" -C "$CONFIG_DIR" .
        log "Configuration backed up to: $backup_file"
    fi
}

# Function to create enhanced configuration files
create_config_files() {
    log "Creating enhanced configuration files..."
    
    # Create main config.yml
    cat > "$CONFIG_DIR/config.yml" << EOF
title: Homelab Dashboard
description: Enhanced Homelab Infrastructure Dashboard
theme: dark
layout: default
language: en
units: metric
timezone: ${TIMEZONE}
background: https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop
favicon: https://raw.githubusercontent.com/gethomepage/homepage/main/public/favicon.ico
icons: https://raw.githubusercontent.com/gethomepage/homepage/main/public/icons

# Custom CSS for enhanced styling
css: |
  :root {
    --primary-color: #3b82f6;
    --secondary-color: #8b5cf6;
    --success-color: #10b981;
    --warning-color: #f59e0b;
    --danger-color: #ef4444;
    --info-color: #06b6d4;
  }
  
  .service-group {
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s ease-in-out;
  }
  
  .service-group:hover {
    transform: translateY(-2px);
  }
  
  .infrastructure-stack {
    background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  }
  
  .monitoring-stack {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  }
  
  .security-stack {
    background: linear-gradient(135deg, #ef4444 0%, #ee5a24 100%);
  }
  
  .database-stack {
    background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
  }
  
  .media-stack {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  }
  
  .automation-stack {
    background: linear-gradient(135deg, #8b5cf6 0%, #ec4899 100%);
  }
  
  .backup-stack {
    background: linear-gradient(135deg, #6b7280 0%, #9ca3af 100%);
  }
  
  .utilities-stack {
    background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
  }
  
  .external-stack {
    background: linear-gradient(135deg, #6b7280 0%, #9ca3af 100%);
  }
  
  .widget-card {
    backdrop-filter: blur(10px);
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
  }
  
  .status-indicator {
    border-radius: 50%;
    width: 12px;
    height: 12px;
    display: inline-block;
    margin-right: 8px;
  }
  
  .status-online { background-color: var(--success-color); }
  .status-offline { background-color: var(--danger-color); }
  .status-warning { background-color: var(--warning-color); }

# Comprehensive widget configuration
widgets:
  # System monitoring widgets
  - resources
  - system
  - docker
  - kubernetes
  
  # Search and utility widgets
  - search
  - weather
  - calendar
  
  # Infrastructure monitoring
  - traefik
  - authentik
  - portainer
  - watchtower
  
  # Monitoring stack
  - grafana
  - prometheus
  - influxdb
  - loki
  - alertmanager
  - uptime_kuma
  - dashdot
  
  # Security stack
  - crowdsec
  - fail2ban
  - pihole
  - ufw
  - wireguard
  
  # Database stack
  - postgresql
  - mariadb
  - redis
  - elasticsearch
  - kibana
  
  # Media stack
  - jellyfin
  - sonarr
  - radarr
  - lidarr
  - readarr
  - prowlarr
  - bazarr
  - tautulli
  - overseerr
  - sabnzbd
  - qbittorrent
  - immich
  
  # Storage and file services
  - nextcloud
  - vaultwarden
  - gitlab
  - harbor
  - minio
  - paperless
  - bookstack
  - filebrowser
  
  # Automation and development
  - homeassistant
  - zigbee2mqtt
  - nodered
  - n8n
  - code_server
  
  # Backup and recovery
  - kopia
  - duplicati
  - restic
  
  # Utilities and tools
  - tdarr
  - unmanic
  - requestrr
  - pulsarr
  
  # External services
  - github

# Weather configuration
weather:
  label: Weather
  latitude: \${WEATHER_LAT:-40.7128}
  longitude: \${WEATHER_LON:--74.0060}
  units: \${WEATHER_UNITS:-metric}
  provider: \${WEATHER_PROVIDER:-openweathermap}
  apiKey: \${OPENWEATHER_API_KEY:-}

# Search configuration
search:
  provider: duckduckgo
  target: _blank
  query: "{{query}}"

# System monitoring configuration
system:
  label: System Status
  url: http://system-monitor:3001
  cpu: true
  memory: true
  disk: true
  network: true
  temperature: true

# Docker monitoring configuration
docker:
  label: Docker Containers
  url: http://portainer:9000
  apiKey: \${PORTAINER_API_KEY:-}

# Kubernetes monitoring configuration
kubernetes:
  label: Kubernetes Cluster
  url: http://kubernetes:8080
  token: \${KUBERNETES_TOKEN:-}

# Resource monitoring configuration
resources:
  label: System Resources
  cpu: true
  memory: true
  disk: true
  network: true
  temperature: true

# Calendar configuration
calendar:
  label: Calendar
  provider: google
  clientId: \${GOOGLE_CLIENT_ID:-}
  clientSecret: \${GOOGLE_CLIENT_SECRET:-}
  refreshToken: \${GOOGLE_REFRESH_TOKEN:-}
EOF

    log "Created main configuration file"
}

# Function to create Docker Compose file
create_docker_compose() {
    log "Creating Docker Compose configuration..."
    
    cat > "$SCRIPT_DIR/docker-compose.yml" << EOF
version: '3.8'

services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    container_name: homepage
    restart: unless-stopped
    ports:
      - "\${HOMEPAGE_PORT:-3000}:3000"
    volumes:
      - ./config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=\${TIMEZONE:-UTC}
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.homepage.rule=Host(\`homepage.\${DOMAIN:-homelab.local}\`)"
      - "traefik.http.routers.homepage.entrypoints=websecure"
      - "traefik.http.routers.homepage.tls.certresolver=letsencrypt"
      - "traefik.http.services.homepage.loadbalancer.server.port=3000"
      - "traefik.docker.network=traefik"
      - "homepage.group=Management & Control"
      - "homepage.icon=homepage.png"
      - "homepage.description=Dashboard & Service Discovery"

  # Weather API service for enhanced weather widget
  weather-api:
    image: ghcr.io/benphelps/homepage-weather:latest
    container_name: homepage-weather
    restart: unless-stopped
    environment:
      - OPENWEATHER_API_KEY=\${OPENWEATHER_API_KEY:-}
      - WEATHER_LAT=\${WEATHER_LAT:-40.7128}
      - WEATHER_LON=\${WEATHER_LON:--74.0060}
      - WEATHER_UNITS=\${WEATHER_UNITS:-metric}
    networks:
      - traefik

  # System monitoring for enhanced system widget
  system-monitor:
    image: ghcr.io/benphelps/homepage-system:latest
    container_name: homepage-system
    restart: unless-stopped
    volumes:
      - /:/host:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - HOST_PROC=/host/proc
      - HOST_SYS=/host/sys
      - HOST_ETC=/host/etc
    networks:
      - traefik

networks:
  traefik:
    external: true
EOF

    log "Created Docker Compose configuration"
}

# Function to create health monitoring script
create_health_monitor() {
    log "Creating health monitoring script..."
    
    cat > "$SCRIPT_DIR/scripts/health_monitor.py" << 'EOF'
#!/usr/bin/env python3
"""
Health Monitor for Homelab Services
===================================

This script monitors the health of all homelab services and reports
status to the homepage dashboard.
"""

import requests
import json
import time
import logging
from datetime import datetime
from typing import Dict, List, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class HealthMonitor:
    def __init__(self, config_file: str = "config/services.yml"):
        self.config_file = config_file
        self.services = self.load_services()
        self.status_file = "config/health_status.json"
    
    def load_services(self) -> Dict:
        """Load service configurations"""
        try:
            import yaml
            with open(self.config_file, 'r') as f:
                return yaml.safe_load(f)
        except Exception as e:
            logger.error(f"Failed to load services: {e}")
            return {}
    
    def check_service_health(self, service_name: str, service_config: Dict) -> Dict:
        """Check health of a single service"""
        try:
            url = service_config.get('health', {}).get('url')
            if not url:
                return {
                    'name': service_name,
                    'status': 'unknown',
                    'error': 'No health check URL configured'
                }
            
            response = requests.get(url, timeout=10)
            
            if response.status_code == 200:
                return {
                    'name': service_name,
                    'status': 'online',
                    'response_time': response.elapsed.total_seconds(),
                    'timestamp': datetime.now().isoformat()
                }
            else:
                return {
                    'name': service_name,
                    'status': 'offline',
                    'error': f'HTTP {response.status_code}',
                    'timestamp': datetime.now().isoformat()
                }
                
        except requests.exceptions.RequestException as e:
            return {
                'name': service_name,
                'status': 'offline',
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }
    
    def check_all_services(self) -> Dict:
        """Check health of all services"""
        results = {}
        
        for group in self.services:
            group_name = group.get('group', 'Unknown')
            items = group.get('items', [])
            
            for item in items:
                for service_name, service_config in item.items():
                    results[service_name] = self.check_service_health(service_name, service_config)
        
        return results
    
    def save_status(self, status: Dict):
        """Save health status to file"""
        try:
            with open(self.status_file, 'w') as f:
                json.dump(status, f, indent=2)
        except Exception as e:
            logger.error(f"Failed to save status: {e}")
    
    def run_monitoring(self, interval: int = 60):
        """Run continuous monitoring"""
        logger.info(f"Starting health monitoring (interval: {interval}s)")
        
        while True:
            try:
                status = self.check_all_services()
                self.save_status(status)
                
                # Log summary
                online = sum(1 for s in status.values() if s['status'] == 'online')
                total = len(status)
                logger.info(f"Health check complete: {online}/{total} services online")
                
                time.sleep(interval)
                
            except KeyboardInterrupt:
                logger.info("Monitoring stopped by user")
                break
            except Exception as e:
                logger.error(f"Monitoring error: {e}")
                time.sleep(interval)

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Health Monitor for Homelab Services")
    parser.add_argument("--config", default="config/services.yml", help="Services configuration file")
    parser.add_argument("--interval", type=int, default=60, help="Check interval in seconds")
    parser.add_argument("--once", action="store_true", help="Run once and exit")
    
    args = parser.parse_args()
    
    monitor = HealthMonitor(args.config)
    
    if args.once:
        status = monitor.check_all_services()
        monitor.save_status(status)
        print(json.dumps(status, indent=2))
    else:
        monitor.run_monitoring(args.interval)
EOF

    chmod +x "$SCRIPT_DIR/scripts/health_monitor.py"
    log "Created health monitoring script"
}

# Function to create backup manager script
create_backup_manager() {
    log "Creating backup manager script..."
    
    cat > "$SCRIPT_DIR/scripts/backup_manager.py" << 'EOF'
#!/usr/bin/env python3
"""
Backup Manager for Homelab Homepage
===================================

This script manages backups of homepage configuration and data.
"""

import os
import shutil
import tarfile
import json
import yaml
from datetime import datetime
from pathlib import Path
from typing import List, Dict

class BackupManager:
    def __init__(self, config_dir: str = "config", backup_dir: str = "backups"):
        self.config_dir = Path(config_dir)
        self.backup_dir = Path(backup_dir)
        self.backup_dir.mkdir(exist_ok=True)
    
    def create_backup(self, name: str = None) -> str:
        """Create a backup of the configuration"""
        if name is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            name = f"homepage_backup_{timestamp}"
        
        backup_file = self.backup_dir / f"{name}.tar.gz"
        
        with tarfile.open(backup_file, "w:gz") as tar:
            tar.add(self.config_dir, arcname="config")
        
        # Create backup metadata
        metadata = {
            "name": name,
            "created": datetime.now().isoformat(),
            "files": list(self.config_dir.rglob("*"))
        }
        
        metadata_file = self.backup_dir / f"{name}_metadata.json"
        with open(metadata_file, 'w') as f:
            json.dump(metadata, f, indent=2)
        
        return str(backup_file)
    
    def restore_backup(self, backup_file: str) -> bool:
        """Restore from a backup"""
        backup_path = Path(backup_file)
        
        if not backup_path.exists():
            print(f"Backup file not found: {backup_file}")
            return False
        
        # Create backup of current config before restoring
        self.create_backup("pre_restore_backup")
        
        # Extract backup
        with tarfile.open(backup_path, "r:gz") as tar:
            tar.extractall(self.config_dir.parent)
        
        return True
    
    def list_backups(self) -> List[Dict]:
        """List all available backups"""
        backups = []
        
        for backup_file in self.backup_dir.glob("*.tar.gz"):
            metadata_file = backup_file.with_suffix("_metadata.json")
            
            if metadata_file.exists():
                with open(metadata_file, 'r') as f:
                    metadata = json.load(f)
                backups.append(metadata)
            else:
                backups.append({
                    "name": backup_file.stem,
                    "created": "Unknown",
                    "file": str(backup_file)
                })
        
        return sorted(backups, key=lambda x: x.get("created", ""), reverse=True)
    
    def cleanup_old_backups(self, keep_days: int = 30):
        """Remove backups older than specified days"""
        cutoff = datetime.now().timestamp() - (keep_days * 24 * 60 * 60)
        
        for backup_file in self.backup_dir.glob("*.tar.gz"):
            if backup_file.stat().st_mtime < cutoff:
                backup_file.unlink()
                
                # Remove metadata file if it exists
                metadata_file = backup_file.with_suffix("_metadata.json")
                if metadata_file.exists():
                    metadata_file.unlink()
                
                print(f"Removed old backup: {backup_file}")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Backup Manager for Homelab Homepage")
    parser.add_argument("--config-dir", default="config", help="Configuration directory")
    parser.add_argument("--backup-dir", default="backups", help="Backup directory")
    
    subparsers = parser.add_subparsers(dest="command", help="Available commands")
    
    # Create backup
    create_parser = subparsers.add_parser("create", help="Create a backup")
    create_parser.add_argument("--name", help="Backup name")
    
    # Restore backup
    restore_parser = subparsers.add_parser("restore", help="Restore from backup")
    restore_parser.add_argument("file", help="Backup file path")
    
    # List backups
    subparsers.add_parser("list", help="List all backups")
    
    # Cleanup
    cleanup_parser = subparsers.add_parser("cleanup", help="Clean up old backups")
    cleanup_parser.add_argument("--days", type=int, default=30, help="Keep backups for N days")
    
    args = parser.parse_args()
    
    manager = BackupManager(args.config_dir, args.backup_dir)
    
    if args.command == "create":
        backup_file = manager.create_backup(args.name)
        print(f"Backup created: {backup_file}")
    
    elif args.command == "restore":
        if manager.restore_backup(args.file):
            print("Backup restored successfully")
        else:
            print("Failed to restore backup")
    
    elif args.command == "list":
        backups = manager.list_backups()
        for backup in backups:
            print(f"{backup['name']} - {backup.get('created', 'Unknown')}")
    
    elif args.command == "cleanup":
        manager.cleanup_old_backups(args.days)
        print("Cleanup completed")
    
    else:
        parser.print_help()
EOF

    chmod +x "$SCRIPT_DIR/scripts/backup_manager.py"
    log "Created backup manager script"
}

# Function to create systemd service
create_systemd_service() {
    log "Creating systemd service..."
    
    cat > "$SCRIPT_DIR/scripts/homepage-health-monitor.service" << EOF
[Unit]
Description=Homepage Health Monitor
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$SCRIPT_DIR
ExecStart=/usr/bin/python3 $SCRIPT_DIR/scripts/health_monitor.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    log "Created systemd service file"
}

# Function to deploy the homepage
deploy_homepage() {
    log "Deploying Homepage..."
    
    # Stop existing containers
    if docker-compose -f "$SCRIPT_DIR/docker-compose.yml" ps -q | grep -q .; then
        log "Stopping existing containers..."
        docker-compose -f "$SCRIPT_DIR/docker-compose.yml" down
    fi
    
    # Pull latest images
    log "Pulling latest images..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" pull
    
    # Start services
    log "Starting services..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
    
    # Wait for services to be ready
    log "Waiting for services to be ready..."
    sleep 10
    
    # Check service status
    if docker-compose -f "$SCRIPT_DIR/docker-compose.yml" ps | grep -q "Up"; then
        log "Homepage deployed successfully!"
        log "Access your dashboard at: http://localhost:$HOMEPAGE_PORT"
        log "Or at: https://homepage.$DOMAIN"
    else
        error "Failed to deploy homepage"
        exit 1
    fi
}

# Function to install systemd service
install_systemd_service() {
    log "Installing systemd service..."
    
    sudo cp "$SCRIPT_DIR/scripts/homepage-health-monitor.service" /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable homepage-health-monitor.service
    sudo systemctl start homepage-health-monitor.service
    
    log "Systemd service installed and started"
}

# Function to show deployment status
show_status() {
    log "Checking deployment status..."
    
    echo -e "\n${CYAN}=== HOMEPAGE DEPLOYMENT STATUS ===${NC}"
    
    # Check if containers are running
    if docker-compose -f "$SCRIPT_DIR/docker-compose.yml" ps -q | grep -q .; then
        echo -e "${GREEN}✅ Containers are running${NC}"
        docker-compose -f "$SCRIPT_DIR/docker-compose.yml" ps
    else
        echo -e "${RED}❌ No containers running${NC}"
    fi
    
    # Check if homepage is accessible
    if curl -s "http://localhost:$HOMEPAGE_PORT" >/dev/null; then
        echo -e "${GREEN}✅ Homepage is accessible at http://localhost:$HOMEPAGE_PORT${NC}"
    else
        echo -e "${RED}❌ Homepage is not accessible${NC}"
    fi
    
    # Check systemd service
    if systemctl is-active --quiet homepage-health-monitor.service; then
        echo -e "${GREEN}✅ Health monitor service is running${NC}"
    else
        echo -e "${YELLOW}⚠️  Health monitor service is not running${NC}"
    fi
    
    echo -e "\n${CYAN}=== CONFIGURATION FILES ===${NC}"
    ls -la "$CONFIG_DIR/"
    
    echo -e "\n${CYAN}=== LOGS ===${NC}"
    ls -la "$LOGS_DIR/" 2>/dev/null || echo "No logs directory found"
}

# Function to show help
show_help() {
    cat << EOF
${CYAN}HOMELAB HOMEPAGE - ENHANCED DEPLOYMENT SCRIPT${NC}

${GREEN}Usage:${NC}
  $0 [COMMAND]

${GREEN}Commands:${NC}
  deploy          Deploy the complete homepage with all services
  backup          Create a backup of current configuration
  restore <file>  Restore configuration from backup
  status          Show deployment status
  logs            Show container logs
  stop            Stop all services
  start           Start all services
  restart         Restart all services
  update          Update to latest version
  help            Show this help message

${GREEN}Environment Variables:${NC}
  DOMAIN          Domain name for services (default: homelab.local)
  HOMEPAGE_PORT   Port for homepage (default: 3000)

${GREEN}Examples:${NC}
  $0 deploy
  DOMAIN=myhomelab.com $0 deploy
  $0 status
  $0 logs

${GREEN}Configuration:${NC}
  Configuration files are stored in: $CONFIG_DIR
  Backups are stored in: $BACKUP_DIR
  Logs are stored in: $LOGS_DIR
EOF
}

# Function to show logs
show_logs() {
    log "Showing container logs..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" logs -f
}

# Function to stop services
stop_services() {
    log "Stopping services..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" down
    log "Services stopped"
}

# Function to start services
start_services() {
    log "Starting services..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
    log "Services started"
}

# Function to restart services
restart_services() {
    log "Restarting services..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" restart
    log "Services restarted"
}

# Function to update services
update_services() {
    log "Updating services..."
    
    # Pull latest images
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" pull
    
    # Restart services
    docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up -d
    
    log "Services updated"
}

# Main execution
main() {
    local command="${1:-help}"
    
    case "$command" in
        "deploy")
            check_docker
            check_dependencies
            install_python_deps
            validate_python_env
            backup_config
            create_config_files
            create_docker_compose
            create_health_monitor
            create_backup_manager
            create_systemd_service
            deploy_homepage
            install_systemd_service
            show_status
            ;;
        "backup")
            "$SCRIPT_DIR/scripts/backup_manager.py" create
            ;;
        "restore")
            if [ -z "${2:-}" ]; then
                error "Please specify backup file"
                exit 1
            fi
            "$SCRIPT_DIR/scripts/backup_manager.py" restore "$2"
            ;;
        "status")
            show_status
            ;;
        "logs")
            show_logs
            ;;
        "stop")
            stop_services
            ;;
        "start")
            start_services
            ;;
        "restart")
            restart_services
            ;;
        "update")
            update_services
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Run main function with all arguments
main "$@" 