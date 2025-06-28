#!/bin/bash

# Cleanup Obsolete Tasks Script
# This script identifies and removes task files that have been migrated to roles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TASKS_DIR="tasks"
BACKUP_DIR="tasks_backup_$(date +%Y%m%d_%H%M%S)"
DRY_RUN=${1:-false}

# List of obsolete task files (migrated to roles)
OBSOLETE_TASKS=(
    # Infrastructure tasks
    "docker.yml"
    "traefik.yml"
    "authentik.yml"
    "nginx.yml"
    "security.yml"
    "network.yml"
    "essential.yml"
    
    # Database tasks
    "mariadb.yml"
    "postgresql.yml"
    "redis.yml"
    "elasticsearch.yml"
    "kibana.yml"
    
    # Storage tasks
    "samba.yml"
    "syncthing.yml"
    "nextcloud.yml"
    "storage.yml"
    
    # Media tasks
    "media_stack.yml"
    "plex.yml"
    "sonarr.yml"
    "radarr.yml"
    "prowlarr.yml"
    "bazarr.yml"
    "lidarr.yml"
    "readarr.yml"
    "qbittorrent.yml"
    "sabnzbd.yml"
    "jellyfin.yml"
    "emby.yml"
    "tautulli.yml"
    "overseerr.yml"
    "komga.yml"
    "audiobookshelf.yml"
    "calibre-web.yml"
    "immich.yml"
    "tdarr.yml"
    
    # Monitoring tasks
    "prometheus.yml"
    "grafana.yml"
    "loki.yml"
    "promtail.yml"
    "alertmanager.yml"
    "telegraf.yml"
    "influxdb.yml"
    "blackbox_exporter.yml"
    "monitoring_infrastructure.yml"
    "monitoring_enhancements.yml"
    
    # Automation tasks
    "portainer.yml"
    "watchtower.yml"
    "mosquitto.yml"
    
    # Utility tasks
    "homepage.yml"
    "docker-compose.yml"
    
    # Individual service tasks that are now part of roles
    "setup.yml"
    "vault.yml"
    "proxmox.yml"
)

# Tasks to retain (post-deployment operations)
RETAINED_TASKS=(
    "pre_tasks.yml"
    "validate.yml"
    "service_orchestration.yml"
    "monitor_performance.yml"
    "backup_orchestration.yml"
    "update_backup_schedules.yml"
    "cleanup.yml"
    "backup.yml"
    "backup_retention.yml"
    "verify_backups.yml"
    "backup_databases.yml"
    "service_management.yml"
    "rollback.yml"
    "validate/"
)

echo -e "${BLUE}=== Ansible Homelab Task Cleanup Script ===${NC}"
echo -e "${BLUE}This script will identify and remove obsolete task files${NC}"
echo

# Check if we're in the right directory
if [[ ! -d "$TASKS_DIR" ]]; then
    echo -e "${RED}Error: $TASKS_DIR directory not found${NC}"
    echo "Please run this script from the ansible_homelab root directory"
    exit 1
fi

# Create backup directory
if [[ "$DRY_RUN" != "true" ]]; then
    echo -e "${YELLOW}Creating backup directory: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
fi

# Function to check if file exists
file_exists() {
    local file="$1"
    [[ -f "$TASKS_DIR/$file" ]]
}

# Function to backup and remove file
remove_file() {
    local file="$1"
    local filepath="$TASKS_DIR/$file"
    
    if file_exists "$file"; then
        echo -e "${GREEN}✓ Found: $file${NC}"
        
        if [[ "$DRY_RUN" != "true" ]]; then
            # Backup file
            cp "$filepath" "$BACKUP_DIR/"
            echo -e "${YELLOW}  → Backed up to: $BACKUP_DIR/$file${NC}"
            
            # Remove file
            rm "$filepath"
            echo -e "${RED}  → Removed: $file${NC}"
        else
            echo -e "${YELLOW}  → Would remove: $file (DRY RUN)${NC}"
        fi
    else
        echo -e "${BLUE}  - Not found: $file${NC}"
    fi
}

# Function to check retained files
check_retained() {
    local file="$1"
    if file_exists "$file"; then
        echo -e "${GREEN}✓ Retained: $file${NC}"
    fi
}

echo -e "${BLUE}=== Processing Obsolete Tasks ===${NC}"
echo

# Process obsolete tasks
for task in "${OBSOLETE_TASKS[@]}"; do
    remove_file "$task"
done

echo
echo -e "${BLUE}=== Checking Retained Tasks ===${NC}"
echo

# Check retained tasks
for task in "${RETAINED_TASKS[@]}"; do
    check_retained "$task"
done

echo
echo -e "${BLUE}=== Summary ===${NC}"

# Count files in backup directory
if [[ "$DRY_RUN" != "true" ]] && [[ -d "$BACKUP_DIR" ]]; then
    BACKUP_COUNT=$(find "$BACKUP_DIR" -type f | wc -l)
    echo -e "${GREEN}Files backed up: $BACKUP_COUNT${NC}"
    echo -e "${YELLOW}Backup location: $BACKUP_DIR${NC}"
fi

# Count remaining task files
REMAINING_COUNT=$(find "$TASKS_DIR" -name "*.yml" -type f | wc -l)
echo -e "${BLUE}Remaining task files: $REMAINING_COUNT${NC}"

echo
echo -e "${GREEN}=== Cleanup Complete ===${NC}"

if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}This was a dry run. No files were actually removed.${NC}"
    echo -e "${YELLOW}Run without arguments to perform actual cleanup.${NC}"
else
    echo -e "${GREEN}Obsolete task files have been backed up and removed.${NC}"
    echo -e "${YELLOW}If you need to restore any files, check: $BACKUP_DIR${NC}"
fi

echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Verify that all roles are working correctly"
echo "2. Test the new role-based playbook: ansible-playbook site.yml --check"
echo "3. Update any custom configurations to use the new role structure"
echo "4. Remove the backup directory when you're confident everything works" 