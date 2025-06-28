#!/bin/bash
# Automated Deployment Script for Ansible Homelab
# This script implements staged deployment with validation

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INVENTORY_FILE="$PROJECT_DIR/inventory.yml"
VAULT_FILE="$PROJECT_DIR/group_vars/all/vault.yml"
LOG_FILE="$PROJECT_DIR/deployment.log"
BACKUP_DIR="$PROJECT_DIR/backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log "${RED}ERROR: $1${NC}"
    exit 1
}

# Success message
success() {
    log "${GREEN}SUCCESS: $1${NC}"
}

# Warning message
warning() {
    log "${YELLOW}WARNING: $1${NC}"
}

# Info message
info() {
    log "${BLUE}INFO: $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    info "Checking prerequisites..."
    
    # Check if we're in the right directory
    if [[ ! -f "$PROJECT_DIR/site.yml" ]]; then
        error_exit "site.yml not found. Please run this script from the project root."
    fi
    
    # Check if inventory exists
    if [[ ! -f "$INVENTORY_FILE" ]]; then
        error_exit "inventory.yml not found. Please configure your inventory first."
    fi
    
    # Check if vault file exists
    if [[ ! -f "$VAULT_FILE" ]]; then
        error_exit "vault.yml not found. Please create your vault file first."
    fi
    
    # Check Ansible installation
    if ! command -v ansible-playbook &> /dev/null; then
        error_exit "ansible-playbook not found. Please install Ansible first."
    fi
    
    # Check Ansible version
    ANSIBLE_VERSION=$(ansible --version | head -n1 | awk '{print $2}')
    if [[ "$ANSIBLE_VERSION" < "2.12" ]]; then
        warning "Ansible version $ANSIBLE_VERSION detected. Version 2.12+ is recommended."
    fi
    
    success "Prerequisites check completed"
}

# Validate configuration
validate_configuration() {
    info "Validating configuration..."
    
    # Test inventory
    if ! ansible-inventory --list -i "$INVENTORY_FILE" &> /dev/null; then
        error_exit "Invalid inventory configuration"
    fi
    
    # Test vault access
    if ! ansible-vault view "$VAULT_FILE" &> /dev/null; then
        error_exit "Cannot access vault file. Check your vault password."
    fi
    
    # Test playbook syntax
    if ! ansible-playbook --syntax-check "$PROJECT_DIR/site.yml" -i "$INVENTORY_FILE" &> /dev/null; then
        error_exit "Playbook syntax check failed"
    fi
    
    success "Configuration validation completed"
}

# Test connectivity
test_connectivity() {
    info "Testing connectivity to target hosts..."
    
    if ! ansible all -m ping -i "$INVENTORY_FILE" --ask-vault-pass &> /dev/null; then
        error_exit "Cannot connect to target hosts. Check your SSH configuration."
    fi
    
    success "Connectivity test completed"
}

# Create backup
create_backup() {
    info "Creating deployment backup..."
    
    mkdir -p "$BACKUP_DIR"
    local backup_file="$BACKUP_DIR/deployment_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    tar -czf "$backup_file" \
        --exclude='*.log' \
        --exclude='backups' \
        --exclude='.git' \
        -C "$PROJECT_DIR" .
    
    success "Backup created: $backup_file"
}

# Deploy stage
deploy_stage() {
    local stage=$1
    local stage_name=$2
    
    info "Deploying Stage $stage: $stage_name"
    
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "stage$stage" \
        --ask-vault-pass \
        --diff \
        --verbose; then
        success "Stage $stage ($stage_name) deployed successfully"
    else
        error_exit "Stage $stage ($stage_name) deployment failed"
    fi
}

# Validate stage
validate_stage() {
    local stage=$1
    local stage_name=$2
    
    info "Validating Stage $stage: $stage_name"
    
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "validation" \
        --ask-vault-pass \
        --limit "stage$stage"; then
        success "Stage $stage ($stage_name) validation completed"
    else
        warning "Stage $stage ($stage_name) validation had issues"
    fi
}

# Full deployment
full_deployment() {
    info "Starting full deployment..."
    
    # Stage 1: Infrastructure
    deploy_stage 1 "Infrastructure"
    validate_stage 1 "Infrastructure"
    
    # Stage 2: Core Services
    deploy_stage 2 "Core Services"
    validate_stage 2 "Core Services"
    
    # Stage 3: Applications
    deploy_stage 3 "Applications"
    validate_stage 3 "Applications"
    
    # Stage 4: Validation
    deploy_stage 4 "Validation"
    
    success "Full deployment completed successfully!"
}

# Individual stage deployment
stage_deployment() {
    local stage=$1
    
    case $stage in
        1)
            deploy_stage 1 "Infrastructure"
            validate_stage 1 "Infrastructure"
            ;;
        2)
            deploy_stage 2 "Core Services"
            validate_stage 2 "Core Services"
            ;;
        3)
            deploy_stage 3 "Applications"
            validate_stage 3 "Applications"
            ;;
        4)
            deploy_stage 4 "Validation"
            ;;
        *)
            error_exit "Invalid stage number: $stage. Use 1-4."
            ;;
    esac
}

# Individual role deployment
role_deployment() {
    local role=$1
    
    info "Deploying role: $role"
    
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "$role" \
        --ask-vault-pass \
        --diff \
        --verbose; then
        success "Role $role deployed successfully"
    else
        error_exit "Role $role deployment failed"
    fi
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [COMMAND]

Commands:
    full                    Deploy all stages (default)
    stage <number>          Deploy specific stage (1-4)
    role <name>             Deploy specific role
    validate                Validate configuration only
    test                    Test connectivity only

Options:
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    -b, --backup            Create backup before deployment
    -s, --skip-validation   Skip validation steps

Examples:
    $0                      # Full deployment
    $0 stage 1              # Deploy infrastructure only
    $0 role security        # Deploy security role only
    $0 validate             # Validate configuration only

Stages:
    1 - Infrastructure (Security, Docker, Traefik)
    2 - Core Services (Databases, Storage, Logging)
    3 - Applications (Media, Paperless, Fing, Utilities)
    4 - Validation (Health checks, monitoring, optimization)

Roles:
    security, databases, storage, logging, media, paperless, fing, utilities, automation

EOF
}

# Main function
main() {
    local command="full"
    local create_backup_flag=false
    local skip_validation_flag=false
    local verbose_flag=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                verbose_flag=true
                shift
                ;;
            -b|--backup)
                create_backup_flag=true
                shift
                ;;
            -s|--skip-validation)
                skip_validation_flag=true
                shift
                ;;
            full|stage|role|validate|test)
                command="$1"
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    
    # Initialize logging
    echo "Deployment started at $(date)" > "$LOG_FILE"
    info "Starting deployment script"
    
    # Check prerequisites
    check_prerequisites
    
    # Create backup if requested
    if [[ "$create_backup_flag" == true ]]; then
        create_backup
    fi
    
    # Execute command
    case $command in
        full)
            if [[ "$skip_validation_flag" != true ]]; then
                validate_configuration
                test_connectivity
            fi
            full_deployment
            ;;
        stage)
            if [[ $# -eq 0 ]]; then
                error_exit "Stage number required"
            fi
            if [[ "$skip_validation_flag" != true ]]; then
                validate_configuration
                test_connectivity
            fi
            stage_deployment "$1"
            ;;
        role)
            if [[ $# -eq 0 ]]; then
                error_exit "Role name required"
            fi
            if [[ "$skip_validation_flag" != true ]]; then
                validate_configuration
                test_connectivity
            fi
            role_deployment "$1"
            ;;
        validate)
            validate_configuration
            test_connectivity
            success "Configuration validation completed successfully"
            ;;
        test)
            test_connectivity
            success "Connectivity test completed successfully"
            ;;
        *)
            error_exit "Unknown command: $command"
            ;;
    esac
    
    info "Deployment script completed"
    echo "Deployment completed at $(date)" >> "$LOG_FILE"
}

# Run main function with all arguments
main "$@" 