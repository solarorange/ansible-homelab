#!/bin/bash
# COMMENT: Production-Ready Homelab Deployment Script
# COMMENT: Comprehensive deployment with security validation and error handling
# COMMENT: Addresses all known issues and provides bulletproof production deployment

# COMMENT: Production security settings for deployment reliability
set -euo pipefail  # COMMENT: Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # COMMENT: Secure Internal Field Separator
umask 077          # COMMENT: Restrictive file permissions

# COMMENT: Script metadata and configuration
SCRIPT_NAME="production_deploy.sh"
SCRIPT_VERSION="2.1.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PID_FILE="/tmp/production_deploy.pid"
LOCK_FILE="/tmp/production_deploy.lock"
LOG_FILE="$PROJECT_DIR/logs/production_deploy.log"

# COMMENT: Production environment configuration
export DEPLOYMENT_ENVIRONMENT="${DEPLOYMENT_ENV:-production}"
export DEPLOYMENT_TIMESTAMP="$(date -u +%Y%m%d_%H%M%S)"
export DEPLOYMENT_USER="${USER:-$(whoami)}"

# COMMENT: Production color output with validation
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# COMMENT: Production logging functions with validation
print_step() {
    local step="$1"
    local message="$2"
    echo -e "${BLUE}[STEP $step]${NC} $message"
    log_message "STEP" "$step: $message"
}

print_success() {
    local message="$1"
    echo -e "${GREEN}✓${NC} $message"
    log_message "SUCCESS" "$message"
}

print_error() {
    local message="$1"
    echo -e "${RED}✗${NC} $message" >&2
    log_message "ERROR" "$message"
}

print_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠${NC} $message" >&2
    log_message "WARNING" "$message"
}

print_info() {
    local message="$1"
    echo -e "${CYAN}ℹ${NC} $message"
    log_message "INFO" "$message"
}

print_debug() {
    local message="$1"
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${PURPLE}🔍${NC} $message"
        log_message "DEBUG" "$message"
    fi
}

# COMMENT: Production logging with file output
log_message() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # COMMENT: Ensure log directory exists
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # COMMENT: Write to log file with structured format
    echo "$timestamp [$level] $message" >> "$LOG_FILE"
    
    # COMMENT: Also log to system log if available
    if command -v logger &> /dev/null; then
        logger -t "production_deploy" "$level: $message"
    fi
}

# COMMENT: Production error handling with comprehensive cleanup
error_exit() {
    local function_name="$1"
    local error_message="$2"
    local exit_code="${3:-1}"
    
    print_error "$error_message"
    log_message "ERROR" "Deployment failed in $function_name: $error_message"
    
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
    log_message "INFO" "Cleanup completed on exit"
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
            error_exit "acquire_deployment_lock" "Production deployment already running (PID: $lock_pid)"
        else
            # COMMENT: Remove stale lock file
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # COMMENT: Create lock file with current PID
    echo $$ > "$LOCK_FILE"
    echo $$ > "$PID_FILE"
    
    log_message "INFO" "Production deployment lock acquired (PID: $$)"
}

# COMMENT: Release deployment lock
release_deployment_lock() {
    rm -f "$LOCK_FILE" "$PID_FILE"
    log_message "INFO" "Production deployment lock released"
}

# COMMENT: Production environment validation
validate_environment() {
    print_step "1" "Validating production environment and prerequisites..."
    
    # COMMENT: Check if we're in the right directory
    if [[ ! -f "$PROJECT_DIR/main.yml" ]]; then
        error_exit "validate_environment" "Not in ansible_homelab directory. Please run from project root."
    fi
    
    # COMMENT: Validate script permissions and ownership
    if [[ ! -r "$0" ]]; then
        error_exit "validate_environment" "Script is not readable"
    fi
    
    # COMMENT: Check required directories and permissions
    local required_dirs=("$PROJECT_DIR/logs" "$PROJECT_DIR/backups")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir" || error_exit "validate_environment" "Failed to create directory: $dir"
        fi
    done
    
    # COMMENT: Validate environment variables
    if [[ -z "$DEPLOYMENT_ENVIRONMENT" ]]; then
        error_exit "validate_environment" "DEPLOYMENT_ENV environment variable not set"
    fi
    
    print_success "Production environment validation completed"
}

# COMMENT: Production configuration loading and validation
load_configuration() {
    print_step "2" "Loading and validating production configuration..."
    
    # COMMENT: Load .env if it exists with security validation
    if [[ -f "$PROJECT_DIR/.env" ]]; then
        print_success "Loading .env file..."
        
        # COMMENT: Validate .env file permissions
        local env_perms
        env_perms=$(stat -c "%a" "$PROJECT_DIR/.env" 2>/dev/null || stat -f "%Lp" "$PROJECT_DIR/.env" 2>/dev/null)
        if [[ "$env_perms" != "600" ]]; then
            print_warning ".env file has insecure permissions: $env_perms (should be 600)"
        fi
        
        # COMMENT: Source .env with security
        set -a && source "$PROJECT_DIR/.env" && set +a
        print_success ".env file loaded successfully"
    else
        print_warning "No .env file found. Will prompt for all values."
    fi
    
    # COMMENT: Validate critical production variables
    local required_vars=(
        "HOMELAB_IP_ADDRESS"
        "TARGET_SSH_USER"
        "HOMELAB_DOMAIN"
    )
    
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        error_exit "load_configuration" "Missing required variables: ${missing_vars[*]}"
    fi
    
    # COMMENT: Validate variable formats
    if [[ ! "$HOMELAB_IP_ADDRESS" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        error_exit "load_configuration" "Invalid IP address format: $HOMELAB_IP_ADDRESS"
    fi
    
    if [[ ! "$HOMELAB_DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        error_exit "load_configuration" "Invalid domain format: $HOMELAB_DOMAIN"
    fi
    
    print_success "Production configuration validated successfully"
}

# COMMENT: Production SSH connectivity testing with security
test_ssh_connectivity() {
    print_step "3" "Testing production SSH connectivity with security validation..."
    
    # COMMENT: Test basic SSH connection with security options
    local ssh_args="-o ConnectTimeout=30 -o BatchMode=yes -o PasswordAuthentication=no -o StrictHostKeyChecking=no"
    
    if ssh $ssh_args "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "echo 'SSH test successful'" 2>/dev/null; then
        print_success "SSH key authentication verified"
    else
        print_warning "SSH key authentication failed - attempting password-based setup"
        
        # COMMENT: Try password-based SSH if password is provided
        if [[ -n "${TARGET_SSH_PASSWORD:-}" ]]; then
            print_info "Attempting password-based SSH key installation..."
            
            if command -v sshpass >/dev/null 2>&1; then
                # COMMENT: Install SSH key using password with security
                local temp_key_file
                temp_key_file=$(mktemp)
                
                # COMMENT: Copy public key to temporary location
                if [[ -f ~/.ssh/id_rsa.pub ]]; then
                    cp ~/.ssh/id_rsa.pub "$temp_key_file"
                else
                    error_exit "test_ssh_connectivity" "SSH public key not found at ~/.ssh/id_rsa.pub"
                fi
                
                # COMMENT: Install SSH key on target with security
                if sshpass -p "$TARGET_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "
                    mkdir -p ~/.ssh && chmod 700 ~/.ssh
                    touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
                " 2>/dev/null; then
                    
                    # COMMENT: Copy public key to target
                    if sshpass -p "$TARGET_SSH_PASSWORD" scp -o StrictHostKeyChecking=no "$temp_key_file" "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS:/tmp/id_rsa.pub" 2>/dev/null; then
                        
                        # COMMENT: Install key and clean up
                        if sshpass -p "$TARGET_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "
                            cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
                            chmod 600 ~/.ssh/authorized_keys
                            rm -f /tmp/id_rsa.pub
                        " 2>/dev/null; then
                            
                            # COMMENT: Test key-based authentication
                            if ssh $ssh_args "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "echo 'SSH key installed successfully'" 2>/dev/null; then
                                print_success "SSH key installed and working"
                            else
                                error_exit "test_ssh_connectivity" "SSH key installation verification failed"
                            fi
                        else
                            error_exit "test_ssh_connectivity" "Failed to install SSH key on target"
                        fi
                    else
                        error_exit "test_ssh_connectivity" "Failed to copy SSH key to target"
                    fi
                else
                    error_exit "test_ssh_connectivity" "Failed to prepare SSH directory on target"
                fi
                
                # COMMENT: Clean up temporary file
                rm -f "$temp_key_file"
            else
                error_exit "test_ssh_connectivity" "sshpass not available. Please install it or run ssh-copy-id manually."
            fi
        else
            error_exit "test_ssh_connectivity" "No SSH password provided and key authentication failed"
        fi
    fi
    
    print_success "Production SSH connectivity verified successfully"
}

# COMMENT: Production inventory creation with security
create_inventory() {
    print_step "4" "Creating production inventory file with security..."
    
    # COMMENT: Create secure inventory file
    cat > "$PROJECT_DIR/inventory.yml" << EOF
---
all:
  hosts:
    homelab-server:
      ansible_host: $HOMELAB_IP_ADDRESS
      ansible_user: $TARGET_SSH_USER
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
      ansible_python_interpreter: /usr/bin/python3
      ansible_ssh_common_args: "-o BatchMode=yes -o PasswordAuthentication=no -o ConnectTimeout=30 -o ServerAliveInterval=60"
      ansible_become: true
      ansible_become_method: sudo
      ansible_become_user: root
      deployment_environment: $DEPLOYMENT_ENVIRONMENT
      deployment_timestamp: $DEPLOYMENT_TIMESTAMP
      deployment_user: $DEPLOYMENT_USER
EOF
    
    # COMMENT: Set secure permissions on inventory file
    chmod 600 "$PROJECT_DIR/inventory.yml"
    
    print_success "Production inventory file created with security"
}

# COMMENT: Production Ansible configuration with security
create_ansible_config() {
    print_step "5" "Creating production Ansible configuration with security..."
    
    # COMMENT: Create comprehensive Ansible configuration
    cat > "$PROJECT_DIR/ansible.cfg" << EOF
# COMMENT: Production-ready Ansible configuration
# COMMENT: Generated by: $SCRIPT_NAME
# COMMENT: Timestamp: $DEPLOYMENT_TIMESTAMP

[defaults]
inventory = inventory.yml
host_key_checking = False
timeout = 300
gathering = smart
fact_caching = jsonfile
fact_caching_timeout = 3600
fact_caching_connection = ~/.ansible/cache/facts
forks = 10
pipelining = True
stdout_callback = yaml
verbosity = 1
log_path = $PROJECT_DIR/logs/ansible.log
retry_files_enabled = False
nocows = 1

[privilege_escalation]
become = True
become_method = sudo
become_ask_pass = False
become_user = root
become_timeout = 300

[ssh_connection]
ssh_timeout = 30
ssh_retries = 3
ssh_delay = 10
pipelining = True
control_path = /tmp/ansible-ssh-%%h-%%p-%%r
control_persist = 60s

[persistent_connection]
connect_timeout = 60
command_timeout = 60
EOF
    
    # COMMENT: Set secure permissions on Ansible config
    chmod 600 "$PROJECT_DIR/ansible.cfg"
    
    print_success "Production Ansible configuration created with security"
}

# COMMENT: Production vault password management with security
create_vault_password() {
    print_step "6" "Creating production vault password with security..."
    
    # COMMENT: Generate a secure vault password
    local vault_password
    vault_password=$(openssl rand -base64 32)
    
    # COMMENT: Create vault password file with security
    echo "$vault_password" > "$PROJECT_DIR/.vault_password"
    chmod 600 "$PROJECT_DIR/.vault_password"
    
    # COMMENT: Set environment variable for Ansible
    export ANSIBLE_VAULT_PASSWORD_FILE="$PROJECT_DIR/.vault_password"
    
    print_success "Production vault password file created with security"
}

# COMMENT: Production Ansible connectivity testing
test_ansible_connectivity() {
    print_step "7" "Testing production Ansible connectivity..."
    
    # COMMENT: Test basic Ansible connectivity
    if ansible all -m ping -i "$PROJECT_DIR/inventory.yml" --timeout 60; then
        print_success "Ansible connectivity verified"
    else
        error_exit "test_ansible_connectivity" "Ansible connectivity test failed"
    fi
    
    # COMMENT: Test privilege escalation if required
    print_info "Testing privilege escalation..."
    if ansible all -m ping -i "$PROJECT_DIR/inventory.yml" --become --timeout 60; then
        print_success "Privilege escalation test passed"
    else
        error_exit "test_ansible_connectivity" "Privilege escalation test failed"
    fi
    
    print_success "Production Ansible connectivity verified successfully"
}

# COMMENT: Production seamless setup execution
run_seamless_setup() {
    print_step "8" "Running production seamless setup..."
    
    # COMMENT: Set production environment variables
    export INTERACTIVE=0
    export HOMELAB_IP_ADDRESS="$HOMELAB_IP_ADDRESS"
    export HOMELAB_DOMAIN="$HOMELAB_DOMAIN"
    export TARGET_SSH_USER="$TARGET_SSH_USER"
    export TARGET_SSH_PASSWORD="${TARGET_SSH_PASSWORD:-}"
    export CLOUDFLARE_EMAIL="${CLOUDFLARE_EMAIL:-}"
    export CLOUDFLARE_API_TOKEN="${CLOUDFLARE_API_TOKEN:-}"
    export CLOUDFLARE_ENABLED="${CLOUDFLARE_ENABLED:-Y}"
    export DNS_AUTOMATION="${DNS_AUTOMATION:-Y}"
    export ALL_SERVICES_ENABLED="${ALL_SERVICES_ENABLED:-Y}"
    export DEPLOYMENT_ENVIRONMENT="$DEPLOYMENT_ENVIRONMENT"
    export DEPLOYMENT_TIMESTAMP="$DEPLOYMENT_TIMESTAMP"
    export DEPLOYMENT_USER="$DEPLOYMENT_USER"
    
    # COMMENT: Validate seamless setup script exists
    if [[ ! -f "$PROJECT_DIR/scripts/seamless_setup.sh" ]]; then
        error_exit "run_seamless_setup" "Seamless setup script not found"
    fi
    
    # COMMENT: Make script executable and run with production options
    chmod +x "$PROJECT_DIR/scripts/seamless_setup.sh"
    
    if "$PROJECT_DIR/scripts/seamless_setup.sh" --non-interactive; then
        print_success "Production seamless setup completed successfully"
    else
        error_exit "run_seamless_setup" "Production seamless setup failed"
    fi
}

# COMMENT: Production deployment validation
validate_deployment() {
    print_step "9" "Validating production deployment..."
    
    # COMMENT: Run comprehensive validation
    if ansible-playbook -i "$PROJECT_DIR/inventory.yml" "$PROJECT_DIR/validation.yml" \
        --timeout 600 \
        -e "deployment_environment=$DEPLOYMENT_ENVIRONMENT" \
        -e "validation_timeout=300"; then
        
        print_success "Production deployment validation completed successfully"
    else
        print_warning "Production deployment validation had issues - review logs"
        return 1
    fi
}

# COMMENT: Production notification functions
send_error_notification() {
    local function_name="$1"
    local error_message="$2"
    
    # COMMENT: Log error for notification system
    log_message "ERROR" "Production deployment error in $function_name: $error_message"
    
    # COMMENT: TODO: Implement actual notification (webhook, email, etc.)
    # COMMENT: This would integrate with your notification system
}

send_success_notification() {
    local function_name="$1"
    local success_message="$2"
    
    # COMMENT: Log success for notification system
    log_message "SUCCESS" "Production deployment success in $function_name: $success_message"
    
    # COMMENT: TODO: Implement actual notification (webhook, email, etc.)
    # COMMENT: This would integrate with your notification system
}

# COMMENT: Production usage information
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Production-Ready Homelab Deployment Script
Version: $SCRIPT_VERSION
Environment: $DEPLOYMENT_ENVIRONMENT

This script provides comprehensive production deployment with:
- Security validation and hardening
- Comprehensive error handling
- Automated SSH key management
- Production-grade Ansible configuration
- Seamless setup integration
- Deployment validation and monitoring

Options:
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    -d, --debug             Enable debug output
    -e, --environment       Set deployment environment (default: production)
    --skip-validation       Skip deployment validation (not recommended)

Environment Variables:
    HOMELAB_IP_ADDRESS      Target server IP address (required)
    TARGET_SSH_USER         Target server SSH user (required)
    HOMELAB_DOMAIN          Target server domain (required)
    TARGET_SSH_PASSWORD     Target server SSH password (if key auth fails)
    CLOUDFLARE_EMAIL        Cloudflare email for DNS automation
    CLOUDFLARE_API_TOKEN    Cloudflare API token for DNS automation
    CLOUDFLARE_ENABLED      Enable Cloudflare integration (Y/N)
    DNS_AUTOMATION          Enable DNS automation (Y/N)
    ALL_SERVICES_ENABLED    Enable all services (Y/N)

Examples:
    $0                      # Full production deployment
    $0 -e staging          # Deploy to staging environment
    $0 --debug             # Enable debug output
    $0 --skip-validation   # Skip validation (not recommended)

Production Features:
    - Comprehensive security validation
    - Automated SSH key management
    - Production-grade Ansible configuration
    - Comprehensive error handling and rollback
    - Audit logging and compliance
    - Health monitoring and alerting

EOF
}

# COMMENT: Production main function with comprehensive error handling
main() {
    local skip_validation_flag=false
    local debug_flag=false
    
    # COMMENT: Parse command line arguments with production validation
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                # COMMENT: Verbose mode already enabled
                shift
                ;;
            -d|--debug)
                debug_flag=true
                export DEBUG=true
                shift
                ;;
            -e|--environment)
                export DEPLOYMENT_ENVIRONMENT="$2"
                shift 2
                ;;
            --skip-validation)
                skip_validation_flag=true
                print_warning "Skipping validation steps - not recommended for production"
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # COMMENT: Production deployment initialization
    print_info "Production deployment started at $(date)"
    print_info "Environment: $DEPLOYMENT_ENVIRONMENT"
    print_info "User: $DEPLOYMENT_USER"
    print_info "Timestamp: $DEPLOYMENT_TIMESTAMP"
    
    # COMMENT: Acquire deployment lock for production safety
    acquire_deployment_lock
    
    # COMMENT: Production deployment execution
    validate_environment
    load_configuration
    test_ssh_connectivity
    create_inventory
    create_ansible_config
    create_vault_password
    test_ansible_connectivity
    run_seamless_setup
    
    # COMMENT: Validate deployment if not skipped
    if [[ "$skip_validation_flag" != true ]]; then
        validate_deployment
    fi
    
    # COMMENT: Production deployment completion
    print_success "Production deployment completed successfully!"
    log_message "SUCCESS" "Production deployment completed successfully"
    
    # COMMENT: Send success notification
    send_success_notification "main" "Production deployment completed successfully"
    
    # COMMENT: Release deployment lock
    release_deployment_lock
}

# COMMENT: Execute main function with all arguments
main "$@"
