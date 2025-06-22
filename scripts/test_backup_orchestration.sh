#!/bin/bash

# Test Backup Orchestration Script
# Validates the new staggered backup schedule

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Backup Orchestration Test ===${NC}"
echo

# Check if backup orchestration is installed
BACKUP_DIR="/home/$(whoami)/backups"
ORCHESTRATION_DIR="$BACKUP_DIR/orchestration"

if [ ! -d "$ORCHESTRATION_DIR" ]; then
    echo -e "${RED}Backup orchestration not found at $ORCHESTRATION_DIR${NC}"
    echo "Please run the Ansible playbook first:"
    echo "ansible-playbook site.yml --tags backup,orchestration"
    exit 1
fi

echo -e "${GREEN}✓ Backup orchestration found${NC}"
echo

# Display current backup schedule
echo -e "${BLUE}Current Staggered Backup Schedule:${NC}"
echo

echo -e "${YELLOW}1:00 AM - Critical Services:${NC}"
echo "  • Authentik (00:01)"
echo "  • Traefik (05:01)"
echo "  • Vault (10:01)"
echo "  • PostgreSQL (15:01)"
echo "  • MariaDB (20:01)"
echo "  • Redis (25:01)"
echo

echo -e "${YELLOW}2:00 AM - High Priority Services:${NC}"
echo "  • Home Assistant (00:02)"
echo "  • Zigbee2MQTT (05:02)"
echo "  • Mosquitto (10:02)"
echo "  • InfluxDB (15:02)"
echo "  • Telegraf (20:02)"
echo

echo -e "${YELLOW}3:00 AM - Media Core Services:${NC}"
echo "  • Sonarr (00:03)"
echo "  • Radarr (05:03)"
echo "  • Lidarr (10:03)"
echo "  • Readarr (15:03)"
echo "  • Prowlarr (20:03)"
echo "  • Bazarr (25:03)"
echo

echo -e "${YELLOW}4:00 AM - Media Download Services:${NC}"
echo "  • qBittorrent (00:04)"
echo "  • Sabnzbd (05:04)"
echo "  • Tdarr (10:04)"
echo "  • Komga (15:04)"
echo "  • Audiobookshelf (20:04)"
echo

echo -e "${YELLOW}5:00 AM - Media Playback Services:${NC}"
echo "  • Jellyfin (00:05)"
echo "  • Emby (05:05)"
echo "  • Tautulli (10:05)"
echo "  • Overseerr (15:05)"
echo

echo -e "${YELLOW}6:00 AM - File Services:${NC}"
echo "  • Nextcloud (00:06)"
echo "  • Samba (05:06)"
echo "  • Syncthing (10:06)"
echo "  • Paperless-ngx (15:06)"
echo "  • Immich (20:06)"
echo

echo -e "${YELLOW}7:00 AM - Utility Services:${NC}"
echo "  • Portainer (00:07)"
echo "  • Grafana (05:07)"
echo "  • Prometheus (10:07)"
echo "  • Loki (15:07)"
echo "  • Alertmanager (20:07)"
echo "  • Pi-hole (25:07)"
echo

# Check cron jobs
echo -e "${BLUE}Checking Cron Jobs:${NC}"
echo

CRON_JOBS=$(crontab -l 2>/dev/null | grep -i backup || echo "No backup cron jobs found")

if [ "$CRON_JOBS" != "No backup cron jobs found" ]; then
    echo -e "${GREEN}✓ Backup cron jobs found:${NC}"
    echo "$CRON_JOBS" | while read -r job; do
        echo "  $job"
    done
else
    echo -e "${YELLOW}⚠ No backup cron jobs found${NC}"
fi

echo

# Check backup orchestration scripts
echo -e "${BLUE}Checking Backup Orchestration Scripts:${NC}"
echo

SCRIPTS=(
    "backup_orchestrator.sh"
    "dependency_checker.sh"
    "resource_monitor.sh"
    "status_tracker.sh"
    "notifications.sh"
    "cleanup.sh"
    "health_check.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$ORCHESTRATION_DIR/$script" ]; then
        echo -e "  ${GREEN}✓${NC} $script"
    else
        echo -e "  ${RED}✗${NC} $script"
    fi
done

echo

# Check configuration
echo -e "${BLUE}Checking Configuration:${NC}"
echo

if [ -f "$ORCHESTRATION_DIR/config.yml" ]; then
    echo -e "${GREEN}✓ Configuration file found${NC}"
    
    # Display some key settings
    echo "  Resource Limits:"
    echo "    - Max concurrent backups: $(grep -A1 "max_concurrent_backups:" "$ORCHESTRATION_DIR/config.yml" | tail -1 | tr -d ' ')"
    echo "    - Max backup duration: $(grep -A1 "max_backup_duration_minutes:" "$ORCHESTRATION_DIR/config.yml" | tail -1 | tr -d ' ')"
    echo "    - Max backup size: $(grep -A1 "max_backup_size_gb:" "$ORCHESTRATION_DIR/config.yml" | tail -1 | tr -d ' ')"
else
    echo -e "${RED}✗ Configuration file not found${NC}"
fi

echo

# Check directories
echo -e "${BLUE}Checking Directories:${NC}"
echo

DIRS=("logs" "status")

for dir in "${DIRS[@]}"; do
    if [ -d "$ORCHESTRATION_DIR/$dir" ]; then
        echo -e "  ${GREEN}✓${NC} $dir/"
    else
        echo -e "  ${RED}✗${NC} $dir/"
    fi
done

echo

# Test resource monitoring
echo -e "${BLUE}Testing Resource Monitoring:${NC}"
echo

if [ -f "$ORCHESTRATION_DIR/resource_monitor.sh" ]; then
    echo -e "${GREEN}✓ Resource monitor script found${NC}"
    
    # Get current resource usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    echo "  Current Resource Usage:"
    echo "    - CPU: ${CPU_USAGE}%"
    echo "    - Memory: ${MEMORY_USAGE}%"
    echo "    - Disk: ${DISK_USAGE}%"
    
    # Check if resources are within limits
    if [ "$CPU_USAGE" -lt 80 ] && [ "$MEMORY_USAGE" -lt 80 ] && [ "$DISK_USAGE" -lt 90 ]; then
        echo -e "  ${GREEN}✓ Resources are within acceptable limits${NC}"
    else
        echo -e "  ${YELLOW}⚠ Some resources are high${NC}"
    fi
else
    echo -e "${RED}✗ Resource monitor script not found${NC}"
fi

echo

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo

echo -e "${GREEN}Benefits of the new staggered backup schedule:${NC}"
echo "  • Reduced resource contention"
echo "  • Better dependency management"
echo "  • Improved backup reliability"
echo "  • Easier troubleshooting"
echo "  • Better monitoring and alerting"
echo

echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Monitor the first few backup cycles"
echo "  2. Adjust timing if needed"
echo "  3. Set up notifications"
echo "  4. Configure backup verification"
echo

echo -e "${BLUE}To run the backup orchestration manually:${NC}"
echo "  $ORCHESTRATION_DIR/backup_orchestrator.sh"
echo

echo -e "${BLUE}To view backup logs:${NC}"
echo "  tail -f $ORCHESTRATION_DIR/logs/orchestrator.log"
echo

echo -e "${GREEN}Backup orchestration test completed!${NC}" 