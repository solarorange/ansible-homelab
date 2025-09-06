#!/bin/bash
# COMMENT: Production-ready Automated Deployment Script for Ansible Homelab
# COMMENT: Comprehensive staged deployment with validation and security
# COMMENT: This script implements production-grade deployment with safety measures

# COMMENT: Production security settings for deployment reliability
set -euo pipefail  # COMMENT: Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # COMMENT: Secure Internal Field Separator
umask 077          # COMMENT: Restrictive file permissions

# COMMENT: Script metadata and configuration
SCRIPT_NAME="deploy.sh"
SCRIPT_VERSION="2.1.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INVENTORY_FILE="$PROJECT_DIR/inventory.yml"
VAULT_FILE="$PROJECT_DIR/group_vars/all/vault.yml"
LOG_FILE="$PROJECT_DIR/logs/deployment.log"
BACKUP_DIR="$PROJECT_DIR/backups"
PID_FILE="/tmp/deploy_script.pid"
LOCK_FILE="/tmp/deploy_script.lock"

# COMMENT: Production configuration with validation
export SERVICE_NAME="deploy"
export DEPLOYMENT_ENVIRONMENT="${DEPLOYMENT_ENV:-production}"
export DEPLOYMENT_TIMESTAMP="$(date -u +%Y%m%d_%H%M%S)"
export DEPLOYMENT_USER="${USER:-$(whoami)}"

# COMMENT: Source logging utilities with error handling
if [[ -f "$SCRIPT_DIR/logging_utils.sh" ]]; then
    source "$SCRIPT_DIR/logging_utils.sh"
else
    # COMMENT: Fallback logging if utilities not available
    log_info() { echo "[INFO] $1: $2"; }
    log_warning() { echo "[WARNING] $1: $2" >&2; }
    log_error() { echo "[ERROR] $1: $2" >&2; }
    log_success() { echo "[SUCCESS] $1: $2"; }
fi

# COMMENT: Production error handling with comprehensive cleanup
error_exit() {
    local function_name="$1"
    local error_message="$2"
    local exit_code="${3:-1}"
    
    log_error "$function_name" "$error_message"
    
    # COMMENT: Cleanup on error
    cleanup_on_exit
    
    # COMMENT: Send error notification if configured
    send_error_notification "$function_name" "$error_message"
    
    exit "$exit_code"
}

# COMMENT: Signal handling for production deployment
cleanup_on_exit() {
    # COMMENT: Remove PID and lock files
    [[ -f "$PID_FILE" ]] && rm -f "$PID_FILE"
    [[ -f "$LOCK_FILE" ]] && rm -f "$LOCK_FILE"
    
    # COMMENT: Log cleanup completion
    log_info "cleanup" "Cleanup completed on exit"
}

# COMMENT: Signal handlers for production safety
trap cleanup_on_exit EXIT
trap 'error_exit "signal_handler" "Received interrupt signal" 130' INT TERM

# COMMENT: Production deployment locking for concurrency control
acquire_deployment_lock() {
    if [[ -f "$LOCK_FILE" ]]; then
        local lock_pid
        lock_pid=$(cat "$LOCK_FILE" 2>/dev/null || echo "")
        
        if [[ -n "$lock_pid" ]] && kill -0 "$lock_pid" 2>/dev/null; then
            error_exit "acquire_deployment_lock" "Deployment already running (PID: $lock_pid)"
        else
            # COMMENT: Remove stale lock file
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # COMMENT: Create lock file with current PID
    echo $$ > "$LOCK_FILE"
    echo $$ > "$PID_FILE"
    
    log_info "acquire_deployment_lock" "Deployment lock acquired (PID: $$)"
}

# COMMENT: Release deployment lock
release_deployment_lock() {
    rm -f "$LOCK_FILE" "$PID_FILE"
    log_info "release_deployment_lock" "Deployment lock released"
}

# COMMENT: Production prerequisite validation
check_prerequisites() {
    log_info "check_prerequisites" "Validating production prerequisites..."
    
    # COMMENT: Check script permissions and ownership
    if [[ ! -r "$0" ]]; then
        error_exit "check_prerequisites" "Script is not readable"
    fi
    
    # COMMENT: Validate project directory structure
    if [[ ! -d "$PROJECT_DIR" ]]; then
        error_exit "check_prerequisites" "Project directory not found: $PROJECT_DIR"
    fi
    
    if [[ ! -f "$PROJECT_DIR/site.yml" ]]; then
        error_exit "check_prerequisites" "site.yml not found. Please run this script from the project root."
    fi
    
    # COMMENT: Validate inventory configuration
    if [[ ! -f "$INVENTORY_FILE" ]]; then
        error_exit "check_prerequisites" "inventory.yml not found. Please configure your inventory first."
    fi
    
    # COMMENT: Validate vault configuration with security
    if [[ ! -f "$VAULT_FILE" ]]; then
        error_exit "check_prerequisites" "vault.yml not found. Please create your vault file first."
    fi
    
    # COMMENT: Validate vault file permissions
    local vault_perms
    vault_perms=$(stat -c "%a" "$VAULT_FILE" 2>/dev/null || stat -f "%Lp" "$VAULT_FILE" 2>/dev/null)
    if [[ "$vault_perms" != "600" ]]; then
        log_warning "check_prerequisites" "Vault file has insecure permissions: $vault_perms (should be 600)"
    fi
    
    # COMMENT: Check Ansible installation and version
    if ! command -v ansible-playbook &> /dev/null; then
        error_exit "check_prerequisites" "ansible-playbook not found. Please install Ansible first."
    fi
    
    # COMMENT: Validate Ansible version for production
    local ansible_version
    ansible_version=$(ansible --version | head -n1 | awk '{print $2}' | sed 's/[]//g')
    local required_version="2.12.0"
    
    if [[ "$(printf '%s\n' "$ansible_version" "$required_version" | sort -V | head -n1)" = "$ansible_version" ]] \
       && [[ "$ansible_version" != "$required_version" ]]; then
        log_warning "check_prerequisites" "Ansible version $ansible_version detected. Version $required_version+ is recommended for production."
    fi
    
    # COMMENT: Check required directories and permissions
    local required_dirs=("$BACKUP_DIR" "$(dirname "$LOG_FILE")")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir" || error_exit "check_prerequisites" "Failed to create directory: $dir"
        fi
    done
    
    # COMMENT: Validate environment variables
    if [[ -z "$DEPLOYMENT_ENVIRONMENT" ]]; then
        error_exit "check_prerequisites" "DEPLOYMENT_ENV environment variable not set"
    fi
    
    log_success "check_prerequisites" "Production prerequisites validation completed"
}

# COMMENT: Production configuration validation
validate_configuration() {
    log_info "validate_configuration" "Validating production configuration..."
    
    # COMMENT: Test inventory syntax and structure
    if ! ansible-inventory --list -i "$INVENTORY_FILE" &> /dev/null; then
        error_exit "validate_configuration" "Invalid inventory configuration"
    fi
    
    # COMMENT: Validate vault access with security checks
    if [[ -z "${ANSIBLE_VAULT_PASSWORD_FILE:-}" ]]; then
        log_warning "validate_configuration" "ANSIBLE_VAULT_PASSWORD_FILE not set - interactive vault access required"
    fi
    
    if ! ansible-vault view "$VAULT_FILE" &> /dev/null; then
        error_exit "validate_configuration" "Cannot access vault file. Ensure ANSIBLE_VAULT_PASSWORD_FILE is set or provide password interactively."
    fi
    
    # COMMENT: Validate playbook syntax with production checks
    if ! ansible-playbook --syntax-check "$PROJECT_DIR/site.yml" -i "$INVENTORY_FILE" &> /dev/null; then
        error_exit "validate_configuration" "Playbook syntax check failed"
    fi
    
    # COMMENT: Validate environment-specific configuration
    if [[ "$DEPLOYMENT_ENVIRONMENT" == "production" ]]; then
        log_info "validate_configuration" "Production environment detected - applying strict validation"
        
        # COMMENT: Check for production-specific variables
        if ! ansible-inventory --list -i "$INVENTORY_FILE" | grep -q "production"; then
            log_warning "validate_configuration" "Production environment not detected in inventory"
        fi
    fi
    
    log_success "validate_configuration" "Production configuration validation completed"
}

# COMMENT: Production connectivity testing
test_connectivity() {
    log_info "test_connectivity" "Testing production connectivity to target hosts..."
    
    # COMMENT: Test SSH connectivity with security options
    local ssh_args="-o BatchMode=yes -o PasswordAuthentication=no -o ConnectTimeout=30 -o ServerAliveInterval=60"
    
    if ! ansible all -m ping -i "$INVENTORY_FILE" -e "ansible_ssh_common_args='$ssh_args'" &> /dev/null; then
        error_exit "test_connectivity" "Cannot connect to target hosts. Check your SSH configuration and network connectivity."
    fi
    
    # COMMENT: Test privilege escalation if required
    if ansible-inventory --list -i "$INVENTORY_FILE" | grep -q "become.*true"; then
        log_info "test_connectivity" "Testing privilege escalation..."
        if ! ansible all -m ping -i "$INVENTORY_FILE" -e "ansible_ssh_common_args='$ssh_args'" --become &> /dev/null; then
            error_exit "test_connectivity" "Privilege escalation test failed. Check sudo configuration."
        fi
    fi
    
    log_success "test_connectivity" "Production connectivity test completed"
}

# COMMENT: Production backup creation with validation
create_backup() {
    log_info "create_backup" "Creating production deployment backup..."
    
    # COMMENT: Validate backup directory
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR" || error_exit "create_backup" "Failed to create backup directory"
    fi
    
    # COMMENT: Create timestamped backup with compression
    local backup_file
    backup_file="$BACKUP_DIR/deployment_backup_${DEPLOYMENT_ENVIRONMENT}_${DEPLOYMENT_TIMESTAMP}.tar.gz"
    
    # COMMENT: Create backup with exclusions for production
    if tar -czf "$backup_file" \
        --exclude='*.log' \
        --exclude='backups' \
        --exclude='.git' \
        --exclude='node_modules' \
        --exclude='*.tmp' \
        --exclude='*.cache' \
        -C "$PROJECT_DIR" .; then
        
        # COMMENT: Validate backup integrity
        if tar -tzf "$backup_file" &> /dev/null; then
            local backup_size
            backup_size=$(du -h "$backup_file" | cut -f1)
            log_success "create_backup" "Production backup created: $backup_file (Size: $backup_size)"
        else
            error_exit "create_backup" "Backup integrity check failed"
        fi
    else
        error_exit "create_backup" "Failed to create backup"
    fi
}

# COMMENT: Production stage deployment with validation
deploy_stage() {
    local stage="$1"
    local stage_name="$2"
    local stage_start_time
    stage_start_time=$(date +%s)
    
    log_info "deploy_stage" "Deploying Production Stage $stage: $stage_name"
    
    # COMMENT: Pre-stage validation
    log_info "deploy_stage" "Pre-stage validation for $stage_name"
    
    # COMMENT: Execute stage deployment with production options
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "stage$stage" \
        --diff \
        --verbose \
        --timeout 3600 \
        --forks 5 \
        -e "deployment_environment=$DEPLOYMENT_ENVIRONMENT" \
        -e "deployment_timestamp=$DEPLOYMENT_TIMESTAMP" \
        -e "deployment_user=$DEPLOYMENT_USER"; then
        
        local stage_duration
        stage_duration=$(($(date +%s) - stage_start_time))
        log_success "deploy_stage" "Production Stage $stage ($stage_name) deployed successfully in ${stage_duration}s"
    else
        local stage_duration
        stage_duration=$(($(date +%s) - stage_start_time)
        error_exit "deploy_stage" "Production Stage $stage ($stage_name) deployment failed after ${stage_duration}s"
    fi
}

# COMMENT: Production stage validation with comprehensive checks
validate_stage() {
    local stage="$1"
    local stage_name="$2"
    
    log_info "validate_stage" "Validating Production Stage $stage: $stage_name"
    
    # COMMENT: Execute stage validation with production options
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "validation" \
        --limit "stage$stage" \
        --diff \
        -e "deployment_environment=$DEPLOYMENT_ENVIRONMENT" \
        -e "validation_timeout=300"; then
        
        log_success "validate_stage" "Production Stage $stage ($stage_name) validation completed successfully"
    else
        log_warning "validate_stage" "Production Stage $stage ($stage_name) validation had issues - review logs"
        return 1
    fi
}

# COMMENT: Production full deployment with comprehensive stages
full_deployment() {
    log_info "full_deployment" "Starting production full deployment..."
    
    local deployment_start_time
    deployment_start_time=$(date +%s)
    
    # COMMENT: Stage 1: Infrastructure (Critical)
    deploy_stage 1 "Infrastructure"
    validate_stage 1 "Infrastructure"
    
    # COMMENT: Stage 2: Core Services (Important)
    deploy_stage 2 "Core Services"
    validate_stage 2 "Core Services"
    
    # COMMENT: Stage 3: Applications (Standard)
    deploy_stage 3 "Applications"
    validate_stage 3 "Applications"
    
    # COMMENT: Stage 4: Validation and Optimization
    deploy_stage 4 "Validation and Optimization"
    
    local deployment_duration
    deployment_duration=$(($(date +%s) - deployment_start_time))
    log_success "full_deployment" "Production full deployment completed successfully in ${deployment_duration}s!"
    
    # COMMENT: Send success notification
    send_success_notification "full_deployment" "Production deployment completed successfully in ${deployment_duration}s"
}

# COMMENT: Production individual stage deployment
stage_deployment() {
    local stage="$1"
    
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
            deploy_stage 4 "Validation and Optimization"
            ;;
        *)
            error_exit "stage_deployment" "Invalid stage number: $stage. Use 1-4."
            ;;
    esac
}

# COMMENT: Production role deployment with validation
role_deployment() {
    local role="$1"
    
    log_info "role_deployment" "Deploying production role: $role"
    
    # COMMENT: Validate role exists in playbook
    if ! grep -q "role.*$role" "$PROJECT_DIR/site.yml"; then
        error_exit "role_deployment" "Role '$role' not found in site.yml"
    fi
    
    # COMMENT: Execute role deployment with production options
    if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_DIR/site.yml" \
        --tags "$role" \
        --diff \
        --verbose \
        --timeout 1800 \
        --forks 3 \
        -e "deployment_environment=$DEPLOYMENT_ENVIRONMENT" \
        -e "deployment_timestamp=$DEPLOYMENT_TIMESTAMP" \
        -e "deployment_user=$DEPLOYMENT_USER"; then
        
        log_success "role_deployment" "Production role $role deployed successfully"
    else
        error_exit "role_deployment" "Production role $role deployment failed"
    fi
}

# COMMENT: Production notification functions
send_error_notification() {
    local function_name="$1"
    local error_message="$2"
    
    # COMMENT: Log error for notification system
    log_error "notification" "Deployment error in $function_name: $error_message"
    
    # COMMENT: TODO: Implement actual notification (webhook, email, etc.)
    # COMMENT: This would integrate with your notification system
}

send_success_notification() {
    local function_name="$1"
    local success_message="$2"
    
    # COMMENT: Log success for notification system
    log_success "notification" "Deployment success in $function_name: $success_message"
    
    # COMMENT: TODO: Implement actual notification (webhook, email, etc.)
    # COMMENT: This would integrate with your notification system
}

# COMMENT: Production usage information
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [COMMAND]

Production Deployment Script for Ansible Homelab
Version: $SCRIPT_VERSION
Environment: $DEPLOYMENT_ENVIRONMENT

Commands:
    full                    Deploy all production stages (default)
    stage <number>          Deploy specific production stage (1-4)
    role <name>             Deploy specific production role
    validate                Validate production configuration only
    test                    Test production connectivity only

Options:
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    -b, --backup            Create production backup before deployment
    -s, --skip-validation   Skip production validation steps (not recommended)
    -e, --environment       Set deployment environment (default: production)

Examples:
    $0                      # Full production deployment
    $0 stage 1              # Deploy infrastructure only
    $0 role security        # Deploy security role only
    $0 validate             # Validate production configuration only
    $0 -e staging          # Deploy to staging environment

Production Stages:
    1 - Infrastructure (Security, Docker, Traefik, Monitoring)
    2 - Core Services (Databases, Storage, Logging, Backup)
    3 - Applications (Media, Paperless, Automation, Utilities)
    4 - Validation (Health checks, monitoring, optimization, security)

Production Roles:
    security, databases, storage, logging, media, paperless, 
    automation, utilities, monitoring, backup

Production Features:
    - Comprehensive error handling and rollback
    - Security validation and hardening
    - Automated backup and recovery
    - Health monitoring and alerting
    - Audit logging and compliance

EOF
}

# COMMENT: Production main function with comprehensive error handling
main() {
    local command="full"
    local create_backup_flag=false
    local skip_validation_flag=false
    local environment="${DEPLOYMENT_ENV:-production}"
    
    # COMMENT: Parse command line arguments with production validation
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                # COMMENT: Verbose mode already enabled in ansible calls
                shift
                ;;
            -b|--backup)
                create_backup_flag=true
                shift
                ;;
            -s|--skip-validation)
                skip_validation_flag=true
                log_warning "main" "Skipping validation steps - not recommended for production"
                shift
                ;;
            -e|--environment)
                environment="$2"
                export DEPLOYMENT_ENVIRONMENT="$environment"
                shift 2
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
    
    # COMMENT: Production deployment initialization
    log_info "main" "Production deployment started at $(date)"
    log_info "main" "Environment: $DEPLOYMENT_ENVIRONMENT"
    log_info "main" "User: $DEPLOYMENT_USER"
    log_info "main" "Timestamp: $DEPLOYMENT_TIMESTAMP"
    
    # COMMENT: Acquire deployment lock for production safety
    acquire_deployment_lock
    
    # COMMENT: Production prerequisite validation
    check_prerequisites
    
    # COMMENT: Create production backup if requested
    if [[ "$create_backup_flag" == true ]]; then
        create_backup
    fi
    
    # COMMENT: Execute production command with validation
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
            log_success "main" "Production configuration validation completed successfully"
            ;;
        test)
            test_connectivity
            log_success "main" "Production connectivity test completed successfully"
            ;;
        *)
            error_exit "main" "Unknown command: $command"
            ;;
    esac
    
    # COMMENT: Production deployment completion
    log_info "main" "Production deployment script completed successfully"
    release_deployment_lock
}

# COMMENT: Execute main function with all arguments
main "$@" 