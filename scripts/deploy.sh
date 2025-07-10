#!/bin/bash
# Automated Deployment Script for Ansible Homelab
# This script implements staged deployment with validation

set -euo pipefail

export SERVICE_NAME="deploy"
source "$(dirname "$0")/logging_utils.sh"

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

# Error handling
error_exit() {
    log_error "$1" "$2"
    exit 1
}

# Check prerequisites
check_prerequisites() {
    log_info "check_prerequisites" "Checking prerequisites..."
    
    # Check if we're in the right directory
    if [[ ! -f "$PROJECT_DIR/site.yml" ]]; then
        error_exit "check_prerequisites" "site.yml not found. Please run this script from the project root."
    fi
    
    # Check if inventory exists
    if [[ ! -f "$INVENTORY_FILE" ]]; then
        error_exit "check_prerequisites" "inventory.yml not found. Please configure your inventory first."
    fi
    
    # Check if vault file exists
    if [[ ! -f "$VAULT_FILE" ]]; then
        error_exit "check_prerequisites" "vault.yml not found. Please create your vault file first."
    fi
    
    # Check Ansible installation
    if ! command -v ansible-playbook &> /dev/null; then
        error_exit "check_prerequisites" "ansible-playbook not found. Please install Ansible first."
    fi
    
    # Check Ansible version
    ANSIBLE_VERSION=$(ansible --version | head -n1 | awk '{print $2}')
    if [[ "$ANSIBLE_VERSION" < "2.12" ]]; then
        log_warning "check_prerequisites" "Ansible version $ANSIBLE_VERSION detected. Version 2.12+ is recommended."
    fi
    
    log_success "check_prerequisites" "Prerequisites check completed"
}

# Validate configuration
validate_configuration() {
    log_info "validate_configuration" "Validating configuration..."
    
    # Test inventory
    if ! ansible-inventory --list -i "$INVENTORY_FILE" &> /dev/null; then
        error_exit "validate_configuration" "Invalid inventory configuration"
    fi
    
    # Test vault access
    if ! ansible-vault view "$VAULT_FILE" &> /dev/null; then
        error_exit "validate_configuration" "Cannot access vault file. Check your vault password."
    fi
    
    # Test playbook syntax
    if ! ansible-playbook --syntax-check "$PROJECT_DIR/site.yml" -i "$INVENTORY_FILE" &> /dev/null; then
        error_exit "validate_configuration" "Playbook syntax check failed"
    fi
    
    log_success "validate_configuration" "Configuration validation completed"
}

# Test connectivity
test_connectivity() {
    log_info "test_connectivity" "Testing connectivity to target hosts..."
    
    if ! ansible all -m ping -i "$INVENTORY_FILE" --ask-vault-pass &> /dev/null; then
        error_exit "test_connectivity" "Cannot connect to target hosts. Check your SSH configuration."
    fi
    
    log_success "test_connectivity" "Connectivity test completed"
}

# Create backup
create_backup() {
    log_info "create_backup" "Creating deployment backup..."
    
    mkdir -p "$BACKUP_DIR"
    local backup_file="$BACKUP_DIR/deployment_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    tar -czf "$backup_file" \
        --exclude='*.log' \
        --exclude='backups' \
        --exclude='.git' \
        -C "$PROJECT_DIR" .
    
    log_success "create_backup" "Backup created: $backup_file"
}

# Deploy stage
deploy_stage() {
    local stage=$1
    local stage_name=$2
    log_info "deploy_stage" "Deploying Stage $stage: $stage_name"
    
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "stage$stage" \
        --ask-vault-pass \
        --diff \
        --verbose; then
        log_success "deploy_stage" "Stage $stage ($stage_name) deployed successfully"
    else
        error_exit "deploy_stage" "Stage $stage ($stage_name) deployment failed"
    fi
}

# Validate stage
validate_stage() {
    local stage=$1
    local stage_name=$2
    
    log_info "validate_stage" "Validating Stage $stage: $stage_name"
    
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "validation" \
        --ask-vault-pass \
        --limit "stage$stage"; then
        log_success "validate_stage" "Stage $stage ($stage_name) validation completed"
    else
        log_warning "validate_stage" "Stage $stage ($stage_name) validation had issues"
    fi
}

# Full deployment
full_deployment() {
    log_info "full_deployment" "Starting full deployment..."
    
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
    
    log_success "full_deployment" "Full deployment completed successfully!"
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
            error_exit "main" "Invalid stage number: $stage. Use 1-4."
            ;;
    esac
}

# Individual role deployment
role_deployment() {
    local role=$1
    
    log_info "role_deployment" "Deploying role: $role"
    
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "$role" \
        --ask-vault-pass \
        --diff \
        --verbose; then
        log_success "role_deployment" "Role $role deployed successfully"
    else
        error_exit "role_deployment" "Role $role deployment failed"
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
    log_info "main" "Deployment started at $(date)"
    
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
                error_exit "main" "Stage number required"
            fi
            if [[ "$skip_validation_flag" != true ]]; then
                validate_configuration
                test_connectivity
            fi
            stage_deployment "$1"
            ;;
        role)
            if [[ $# -eq 0 ]]; then
                error_exit "main" "Role name required"
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
            log_success "main" "Configuration validation completed successfully"
            ;;
        test)
            test_connectivity
            log_success "main" "Connectivity test completed successfully"
            ;;
        *)
            error_exit "main" "Unknown command: $command"
            ;;
    esac
    
    log_info "main" "Deployment script completed"
}

# Run main function with all arguments
main "$@" 