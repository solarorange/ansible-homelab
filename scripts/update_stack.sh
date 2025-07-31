#!/bin/bash

# Enhanced Stack Update Management Script
# Provides manual update capabilities and status checking for the Ansible homelab stack

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="${PROJECT_ROOT}/logs"
CONFIG_DIR="${PROJECT_ROOT}/group_vars/all"
DOCKER_DIR="${PROJECT_ROOT}/docker"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
LOG_FILE="${LOG_DIR}/stack_updates.log"
mkdir -p "$LOG_DIR"

# Functions
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')] INFO:${NC} $1" | tee -a "$LOG_FILE"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        error "Docker is not running or not accessible"
        exit 1
    fi
    
    # Check if Ansible is available
    if ! command -v ansible-playbook >/dev/null 2>&1; then
        error "Ansible is not installed or not in PATH"
        exit 1
    fi
    
    # Check if we're in the right directory
    if [[ ! -f "${PROJECT_ROOT}/main.yml" ]]; then
        error "Not in the correct project directory. Please run from the ansible_homelab root."
        exit 1
    fi
    
    log "Prerequisites check passed"
}

# Get current stack status
get_stack_status() {
    log "Getting current stack status..."
    
    echo -e "\n${BLUE}=== DOCKER CONTAINERS STATUS ===${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}" | head -1
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}" | grep -v "NAMES"
    
    echo -e "\n${BLUE}=== WATCHTOWER STATUS ===${NC}"
    if docker ps --format "{{.Names}}" | grep -q "watchtower\|container-updater"; then
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" | grep -E "(watchtower|container-updater)"
    else
        warn "Watchtower container not found"
    fi
    
    echo -e "\n${BLUE}=== SYSTEMD TIMERS STATUS ===${NC}"
    systemctl list-timers --no-pager | grep -E "(homelab|maintenance|update)" || warn "No homelab timers found"
    
    echo -e "\n${BLUE}=== RECENT UPDATE LOGS ===${NC}"
    if [[ -f "$LOG_FILE" ]]; then
        tail -10 "$LOG_FILE"
    else
        info "No update logs found"
    fi
}

# Check for available updates
check_updates() {
    log "Checking for available updates..."
    
    echo -e "\n${BLUE}=== DOCKER IMAGE UPDATES ===${NC}"
    
    # Get all running containers and their images
    docker ps --format "{{.Image}}" | sort -u | while read -r image; do
        if [[ -n "$image" ]]; then
            echo "Checking $image..."
            docker pull "$image" >/dev/null 2>&1 || warn "Failed to check $image"
        fi
    done
    
    echo -e "\n${BLUE}=== ANSIBLE PLAYBOOK UPDATES ===${NC}"
    if [[ -d "${PROJECT_ROOT}/.git" ]]; then
        cd "$PROJECT_ROOT"
        git fetch
        LOCAL_COMMIT=$(git rev-parse HEAD)
        REMOTE_COMMIT=$(git rev-parse origin/main)
        
        if [[ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]]; then
            warn "Ansible playbook updates available"
            echo "Local:  $LOCAL_COMMIT"
            echo "Remote: $REMOTE_COMMIT"
        else
            log "Ansible playbook is up to date"
        fi
    else
        warn "Not a git repository - cannot check for playbook updates"
    fi
    
    echo -e "\n${BLUE}=== SYSTEM PACKAGE UPDATES ===${NC}"
    if command -v apt >/dev/null 2>&1; then
        apt update >/dev/null 2>&1
        UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "WARNING" | wc -l)
        if [[ $UPDATES -gt 0 ]]; then
            warn "$UPDATES system package updates available"
        else
            log "System packages are up to date"
        fi
    elif command -v dnf >/dev/null 2>&1; then
        UPDATES=$(dnf check-update --quiet | wc -l)
        if [[ $UPDATES -gt 0 ]]; then
            warn "$UPDATES system package updates available"
        else
            log "System packages are up to date"
        fi
    fi
}

# Manual Docker image updates
update_docker_images() {
    log "Starting manual Docker image updates..."
    
    # Create backup before updates
    backup_before_update
    
    # Update all running containers
    docker ps --format "{{.Names}}" | while read -r container; do
        if [[ -n "$container" ]]; then
            log "Updating container: $container"
            
            # Get the image name
            image=$(docker inspect --format='{{.Config.Image}}' "$container")
            
            # Pull the latest image
            if docker pull "$image"; then
                log "Successfully pulled latest image for $container"
                
                # Restart the container to use the new image
                if docker restart "$container"; then
                    log "Successfully restarted $container"
                else
                    error "Failed to restart $container"
                fi
            else
                error "Failed to pull latest image for $container"
            fi
        fi
    done
    
    # Clean up old images
    log "Cleaning up old Docker images..."
    docker image prune -f
    
    log "Docker image updates completed"
}

# Update Ansible playbook
update_playbook() {
    log "Updating Ansible playbook..."
    
    if [[ ! -d "${PROJECT_ROOT}/.git" ]]; then
        error "Not a git repository - cannot update playbook"
        return 1
    fi
    
    cd "$PROJECT_ROOT"
    
    # Stash any local changes
    if ! git diff --quiet; then
        warn "Local changes detected, stashing them..."
        git stash
    fi
    
    # Pull latest changes
    if git pull origin main; then
        log "Successfully updated Ansible playbook"
        
        # Apply stashed changes if any
        if git stash list | grep -q "stash@{0}"; then
            warn "Reapplying stashed changes..."
            git stash pop
        fi
    else
        error "Failed to update Ansible playbook"
        return 1
    fi
}

# Update system packages
update_system_packages() {
    log "Updating system packages..."
    
    if command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu
        apt update
        apt upgrade -y
        apt autoremove -y
        apt autoclean
    elif command -v dnf >/dev/null 2>&1; then
        # RedHat/CentOS/Fedora
        dnf update -y
        dnf autoremove -y
    else
        error "Unsupported package manager"
        return 1
    fi
    
    log "System package updates completed"
}

# Backup before updates
backup_before_update() {
    log "Creating backup before updates..."
    
    BACKUP_DIR="${PROJECT_ROOT}/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup Docker volumes
    docker ps --format "{{.Names}}" | while read -r container; do
        if [[ -n "$container" ]]; then
            log "Backing up $container..."
            docker commit "$container" "backup_${container}_$(date +%Y%m%d_%H%M%S)" || warn "Failed to backup $container"
        fi
    done
    
    # Backup configuration files
    if [[ -d "$CONFIG_DIR" ]]; then
        cp -r "$CONFIG_DIR" "$BACKUP_DIR/" || warn "Failed to backup configuration"
    fi
    
    log "Backup completed: $BACKUP_DIR"
}

# Force Watchtower update
force_watchtower_update() {
    log "Forcing Watchtower update..."
    
    # Find Watchtower container
    WATCHTOWER_CONTAINER=$(docker ps --format "{{.Names}}" | grep -E "(watchtower|container-updater)" | head -1)
    
    if [[ -n "$WATCHTOWER_CONTAINER" ]]; then
        log "Found Watchtower container: $WATCHTOWER_CONTAINER"
        
        # Trigger manual update
        if docker exec "$WATCHTOWER_CONTAINER" /app/entrypoint.sh --run-once; then
            log "Watchtower manual update triggered successfully"
        else
            error "Failed to trigger Watchtower manual update"
        fi
    else
        error "Watchtower container not found"
        return 1
    fi
}

# Run Ansible playbook update
run_ansible_update() {
    log "Running Ansible playbook update..."
    
    cd "$PROJECT_ROOT"
    
    # Run the main playbook with update tags
    if ansible-playbook main.yml --tags update; then
        log "Ansible playbook update completed successfully"
    else
        error "Ansible playbook update failed"
        return 1
    fi
}

# Show help
show_help() {
    echo -e "${GREEN}Enhanced Stack Update Management Script${NC}"
    echo
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  status      Show current stack status (default)"
    echo "  check       Check for available updates"
    echo "  docker      Update Docker images manually"
    echo "  playbook    Update Ansible playbook from git"
    echo "  system      Update system packages"
    echo "  watchtower  Force Watchtower manual update"
    echo "  ansible     Run Ansible playbook update"
    echo "  all         Run all updates (docker + playbook + system)"
    echo "  help        Show this help message"
    echo
    echo "Examples:"
    echo "  $0                    # Show status"
    echo "  $0 check              # Check for updates"
    echo "  $0 docker             # Update Docker images"
    echo "  $0 all                # Run all updates"
    echo
    echo "Note: This script works with your existing automation:"
    echo "  - Watchtower runs daily at 4 AM"
    echo "  - Maintenance script runs daily at 3 AM"
    echo "  - Service-specific schedules are configured"
}

# Main script logic
main() {
    case "${1:-status}" in
        "status")
            check_prerequisites
            get_stack_status
            ;;
        "check")
            check_prerequisites
            check_updates
            ;;
        "docker")
            check_prerequisites
            update_docker_images
            ;;
        "playbook")
            check_prerequisites
            update_playbook
            ;;
        "system")
            check_prerequisites
            update_system_packages
            ;;
        "watchtower")
            check_prerequisites
            force_watchtower_update
            ;;
        "ansible")
            check_prerequisites
            run_ansible_update
            ;;
        "all")
            check_prerequisites
            log "Running all updates..."
            update_docker_images
            update_playbook
            update_system_packages
            log "All updates completed"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            error "Unknown command: $1. Use '$0 help' for usage information."
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 