#!/bin/bash
# Version Rollback Script for Ansible Homelab
# Comprehensive rollback capabilities with multiple fallback options

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_MANAGER="$SCRIPT_DIR/version_manager.py"
BACKUP_DIR="$PROJECT_ROOT/backups/versions"
LOG_FILE="$PROJECT_ROOT/logs/rollback.log"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

# Create log directory
mkdir -p "$(dirname "$LOG_FILE")"

# Function to check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    if ! command -v python3 &> /dev/null; then
        error "Python 3 is required but not installed"
    fi
    
    if ! command -v git &> /dev/null; then
        error "Git is required but not installed"
    fi
    
    if [[ ! -f "$VERSION_MANAGER" ]]; then
        error "Version manager script not found: $VERSION_MANAGER"
    fi
    
    success "Prerequisites check passed"
}

# Function to get current version info
get_current_version_info() {
    log "Getting current version information..."
    
    if [[ -f "$PROJECT_ROOT/VERSION" ]]; then
        CURRENT_VERSION=$(cat "$PROJECT_ROOT/VERSION")
        log "Current version: $CURRENT_VERSION"
    else
        CURRENT_VERSION="unknown"
        warning "VERSION file not found"
    fi
    
    GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    log "Git commit: $GIT_COMMIT"
    
    echo "$CURRENT_VERSION"
}

# Function to list available rollback options
list_rollback_options() {
    log "Available rollback options:"
    
    echo -e "\n${BLUE}1. Git Tags:${NC}"
    git tag --list | sort -V | tail -10 | while read tag; do
        echo "   • $tag"
    done
    
    echo -e "\n${BLUE}2. Version Backups:${NC}"
    if [[ -d "$BACKUP_DIR" ]]; then
        find "$BACKUP_DIR" -name "backup_metadata.json" -exec sh -c '
            for file do
                version=$(jq -r ".version" "$file" 2>/dev/null)
                timestamp=$(jq -r ".timestamp" "$file" 2>/dev/null)
                path=$(dirname "$file")
                echo "   • v$version - $timestamp - $path"
            done
        ' sh {} + 2>/dev/null | sort -r | head -10
    else
        echo "   No version backups found"
    fi
    
    echo -e "\n${BLUE}3. Recent Git Commits:${NC}"
    git log --oneline -10 | while read commit; do
        echo "   • $commit"
    done
}

# Function to rollback to git tag
rollback_to_git_tag() {
    local tag="$1"
    
    log "Rolling back to git tag: $tag"
    
    # Check if tag exists
    if ! git tag --list | grep -q "^$tag$"; then
        error "Git tag '$tag' not found"
    fi
    
    # Create backup before rollback
    log "Creating backup before rollback..."
    python3 "$VERSION_MANAGER" backup
    
    # Checkout tag
    log "Checking out tag: $tag"
    git checkout "$tag" || error "Failed to checkout tag: $tag"
    
    success "Successfully rolled back to git tag: $tag"
}

# Function to rollback to version backup
rollback_to_version_backup() {
    local backup_path="$1"
    
    log "Rolling back to version backup: $backup_path"
    
    if [[ ! -d "$backup_path" ]]; then
        error "Backup directory not found: $backup_path"
    fi
    
    if [[ ! -f "$backup_path/backup_metadata.json" ]]; then
        error "Invalid backup directory (missing metadata): $backup_path"
    fi
    
    # Create backup before rollback
    log "Creating backup before rollback..."
    python3 "$VERSION_MANAGER" backup
    
    # Restore from backup
    log "Restoring from backup..."
    python3 "$VERSION_MANAGER" restore --backup-path "$backup_path"
    
    success "Successfully rolled back to version backup: $backup_path"
}

# Function to rollback to git commit
rollback_to_git_commit() {
    local commit="$1"
    
    log "Rolling back to git commit: $commit"
    
    # Check if commit exists
    if ! git rev-parse --verify "$commit" &>/dev/null; then
        error "Git commit '$commit' not found"
    fi
    
    # Create backup before rollback
    log "Creating backup before rollback..."
    python3 "$VERSION_MANAGER" backup
    
    # Checkout commit
    log "Checking out commit: $commit"
    git checkout "$commit" || error "Failed to checkout commit: $commit"
    
    success "Successfully rolled back to git commit: $commit"
}

# Function to create emergency backup
create_emergency_backup() {
    log "Creating emergency backup..."
    
    local backup_name="emergency_backup_$(date +'%Y%m%d_%H%M%S')"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    mkdir -p "$backup_path"
    
    # Backup critical files
    local critical_files=(
        "main.yml"
        "site.yml"
        "ansible.cfg"
        "requirements.yml"
        "group_vars/all/vars.yml"
        "group_vars/all/vault.yml"
        "inventory.yml"
        "VERSION"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ -f "$PROJECT_ROOT/$file" ]]; then
            mkdir -p "$(dirname "$backup_path/$file")"
            cp "$PROJECT_ROOT/$file" "$backup_path/$file"
            log "Backed up: $file"
        fi
    done
    
    # Create backup metadata
    cat > "$backup_path/backup_metadata.json" << EOF
{
  "version": "emergency",
  "timestamp": "$(date -Iseconds)",
  "git_commit": "$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')",
  "git_version": "$(git describe --tags --always 2>/dev/null || echo 'unknown')",
  "backup_path": "$backup_path",
  "type": "emergency"
}
EOF
    
    success "Emergency backup created: $backup_path"
    echo "$backup_path"
}

# Function to validate rollback
validate_rollback() {
    log "Validating rollback..."
    
    # Check if critical files exist
    local critical_files=(
        "main.yml"
        "site.yml"
        "ansible.cfg"
        "VERSION"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$PROJECT_ROOT/$file" ]]; then
            error "Critical file missing after rollback: $file"
        fi
    done
    
    # Check if version manager works
    if ! python3 "$VERSION_MANAGER" info &>/dev/null; then
        warning "Version manager validation failed"
    fi
    
    success "Rollback validation passed"
}

# Function to show rollback help
show_help() {
    cat << EOF
Version Rollback Script for Ansible Homelab

Usage: $0 [OPTIONS] [TARGET]

Options:
    -h, --help              Show this help message
    -l, --list              List available rollback options
    -b, --backup            Create emergency backup
    -v, --validate          Validate current state
    -f, --force             Force rollback without confirmation

Targets:
    tag:TAG_NAME           Rollback to git tag
    backup:BACKUP_PATH     Rollback to version backup
    commit:COMMIT_HASH     Rollback to git commit

Examples:
    $0 --list                                    # List available rollback options
    $0 --backup                                  # Create emergency backup
    $0 tag:v2.0.0                               # Rollback to git tag v2.0.0
    $0 backup:backups/versions/v2.0.0_20241219_143022  # Rollback to version backup
    $0 commit:06f4db6                           # Rollback to git commit
    $0 --force tag:v1.0.0                       # Force rollback to tag

Rollback Strategy:
1. Git Tags (recommended) - Clean, tagged releases
2. Version Backups - Complete state snapshots
3. Git Commits - Fine-grained history
4. Emergency Backups - Last resort

EOF
}

# Main function
main() {
    local force_rollback=false
    local show_help=false
    local list_options=false
    local create_backup=false
    local validate_state=false
    local rollback_target=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help=true
                shift
                ;;
            -l|--list)
                list_options=true
                shift
                ;;
            -b|--backup)
                create_backup=true
                shift
                ;;
            -v|--validate)
                validate_state=true
                shift
                ;;
            -f|--force)
                force_rollback=true
                shift
                ;;
            tag:*)
                rollback_target="git_tag:${1#tag:}"
                shift
                ;;
            backup:*)
                rollback_target="version_backup:${1#backup:}"
                shift
                ;;
            commit:*)
                rollback_target="git_commit:${1#commit:}"
                shift
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done
    
    # Check prerequisites
    check_prerequisites
    
    # Show help if requested
    if [[ "$show_help" == true ]]; then
        show_help
        exit 0
    fi
    
    # List options if requested
    if [[ "$list_options" == true ]]; then
        list_rollback_options
        exit 0
    fi
    
    # Create backup if requested
    if [[ "$create_backup" == true ]]; then
        create_emergency_backup
        exit 0
    fi
    
    # Validate state if requested
    if [[ "$validate_state" == true ]]; then
        validate_rollback
        exit 0
    fi
    
    # Perform rollback if target specified
    if [[ -n "$rollback_target" ]]; then
        local target_type="${rollback_target%%:*}"
        local target_value="${rollback_target#*:}"
        
        # Confirm rollback unless forced
        if [[ "$force_rollback" != true ]]; then
            echo -e "${YELLOW}Warning: This will rollback your homelab configuration.${NC}"
            echo -e "Target: $target_type -> $target_value"
            read -p "Are you sure you want to continue? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log "Rollback cancelled by user"
                exit 0
            fi
        fi
        
        case "$target_type" in
            git_tag)
                rollback_to_git_tag "$target_value"
                ;;
            version_backup)
                rollback_to_version_backup "$target_value"
                ;;
            git_commit)
                rollback_to_git_commit "$target_value"
                ;;
            *)
                error "Invalid rollback target type: $target_type"
                ;;
        esac
        
        # Validate rollback
        validate_rollback
        
        success "Rollback completed successfully"
        log "Current version: $(get_current_version_info)"
    else
        error "No rollback target specified. Use --help for usage information."
    fi
}

# Run main function
main "$@" 