#!/bin/bash
# COMMENT: Production-ready Seamless Homelab Deployment Setup - PRIMARY SETUP SCRIPT
# COMMENT: Complete turnkey deployment with automatic variable handling and security validation
# COMMENT: This is the one and only comprehensive setup script for homelab deployment

# COMMENT: Initialize INTERACTIVE variable with safe default
INTERACTIVE="${INTERACTIVE:-0}"

# COMMENT: Parse command line arguments with proper validation
while [[ $# -gt 0 ]]; do
    case $1 in
        --interactive)
            INTERACTIVE=1
            shift
            ;;
        --non-interactive)
            INTERACTIVE=0
            shift
            ;;
        --validate-only)
            VALIDATE_ONLY=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --help)
            echo "Usage: $0 [--interactive|--non-interactive] [--validate-only] [--dry-run] [--help]"
            echo "  --interactive: Enable interactive mode"
            echo "  --non-interactive: Disable interactive mode (default)"
            echo "  --validate-only: Only validate configuration, don't deploy"
            echo "  --dry-run: Show what would be done without making changes"
            echo "  --help: Show this help message"
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            echo "Usage: $0 [--interactive|--non-interactive] [--validate-only] [--dry-run] [--help]"
            exit 1
            ;;
    esac
done

# COMMENT: Production security settings for deployment reliability
set -euo pipefail  # COMMENT: Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # COMMENT: Secure Internal Field Separator
umask 077          # COMMENT: Restrictive file permissions

# COMMENT: Ensure we are running from the repository root regardless of CWD
# COMMENT: Determine script directory and repo root, then cd into repo root
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)"
cd "${REPO_ROOT}"

# COMMENT: Define script metadata for Ansible integration
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_VERSION="2.1.1"
readonly SCRIPT_DIR_ABS="${SCRIPT_DIR}"
readonly REPO_ROOT_ABS="${REPO_ROOT}"
readonly LOG_FILE="${REPO_ROOT_ABS}/logs/ansible-homelab-deployment.log"
readonly PID_FILE="${REPO_ROOT_ABS}/logs/${SCRIPT_NAME}.pid"
readonly BACKUP_DIR="${REPO_ROOT_ABS}/backups"
readonly CONFIG_DIR="${REPO_ROOT_ABS}/group_vars/all"
readonly VAULT_PASSWORD_FILE="${REPO_ROOT_ABS}/.vault_password"

# COMMENT: Colors for output with proper error handling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# COMMENT: Secure logging with tee for production audit trail
exec 1> >(tee -a "${LOG_FILE}")
exec 2> >(tee -a "${LOG_FILE}" >&2)

# COMMENT: Production logging function with validation and security
log() {
    local level="INFO" message=""
    if [[ $# -eq 1 ]]; then
        message="$1"
    else
        level="$1"; shift; message="$*"
    fi

    # COMMENT: Input validation for security
    if [[ -z "$message" ]]; then
        echo "ERROR: Empty log message" >&2
        return 1
    fi

    # COMMENT: Sanitize level input for security
    case "$level" in 
        DEBUG|INFO|WARN|WARNING|ERROR|CRITICAL) 
            ;;
        *) 
            level="INFO"
            ;;
    esac

    # COMMENT: Rely on the global exec-tee for file logging
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message"
}

# COMMENT: Error handling function with cleanup for production reliability
error_exit() {
    local error_message="$1"
    local exit_code="${2:-1}"
    
    log "ERROR" "$error_message"
    cleanup
    exit "$exit_code"
}

# COMMENT: Cleanup function for resource management
cleanup() {
    log "INFO" "Performing cleanup operations"
    
    # COMMENT: Remove PID file if it exists
    if [[ -f "$PID_FILE" ]]; then
        rm -f "$PID_FILE" || log "WARN" "Could not remove PID file: $PID_FILE"
    fi
    
    # COMMENT: Additional cleanup operations as needed
    # COMMENT: Remove temporary files, kill background processes, etc.
}

# COMMENT: Trap for cleanup on script exit
trap cleanup EXIT INT TERM

# COMMENT: Input validation function for security
validate_input() {
    local target_dir="$1"
    
    # COMMENT: Check if parameter is provided
    if [[ -z "$target_dir" ]]; then
        error_exit "Target directory parameter is required" 2
    fi
    
    # COMMENT: Validate directory path is safe
    case "$target_dir" in
        /|/usr|/usr/*|/etc|/etc/*|/var|/var/log|/var/log/*|/boot|/boot/*)
            error_exit "Refusing to operate on system directory: $target_dir" 2
            ;;
        */../*|../*|*/..)
            error_exit "Directory path contains unsafe traversal: $target_dir" 2
            ;;
    esac
    
    # COMMENT: Check if directory exists and is accessible
    if [[ ! -d "$target_dir" ]]; then
        error_exit "Target directory does not exist: $target_dir" 2
    fi
    
    if [[ ! -w "$target_dir" ]]; then
        error_exit "No write permission for directory: $target_dir" 2
    fi
}

# COMMENT: Secure password generation with validation for production security
generate_secure_password() {
    local length="${1:-32}"
    local complexity="${2:-"full"}"
    
    # COMMENT: Input validation for security
    if [[ ! "${length}" =~ ^[0-9]+$ ]] || [[ "${length}" -lt 8 ]] || [[ "${length}" -gt 128 ]]; then
        log "ERROR" "Invalid password length: ${length}. Must be 8-128 characters."
        return 1
    fi
    
    # COMMENT: Validate complexity parameter
    case "${complexity}" in
        "full"|"alphanumeric"|"numeric"|"alpha")
            ;;
        *)
            log "ERROR" "Invalid complexity: ${complexity}. Must be full, alphanumeric, numeric, or alpha."
            return 1
            ;;
    esac
    
    # COMMENT: Generate secure password based on complexity
    case "${complexity}" in
        "full")
            # COMMENT: Full complexity with special characters
            tr -dc 'A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?' < /dev/urandom | head -c "${length}"
            ;;
        "alphanumeric")
            # COMMENT: Alphanumeric only
            tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "${length}"
            ;;
        "numeric")
            # COMMENT: Numeric only
            tr -dc '0-9' < /dev/urandom | head -c "${length}"
            ;;
        "alpha")
            # COMMENT: Alphabetic only
            tr -dc 'A-Za-z' < /dev/urandom | head -c "${length}"
            ;;
    esac
}

# COMMENT: Validate deployment prerequisites for production readiness
validate_prerequisites() {
    log "INFO" "Validating deployment prerequisites"
    
    # COMMENT: Check if running as root or with sudo (skip for validation mode)
    if [[ "${VALIDATE_ONLY:-0}" -eq 0 ]] && [[ $EUID -ne 0 ]] && ! groups | grep -q sudo; then
        error_exit "This script must be run as root or with sudo privileges"
    fi
    
    # COMMENT: Check if required commands are available
    local required_commands=("ansible" "ansible-playbook" "git")
    if [[ "${VALIDATE_ONLY:-0}" -eq 0 ]]; then
        required_commands+=("docker" "docker-compose")
    fi
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            error_exit "Required command not found: $cmd"
        fi
    done
    
    # COMMENT: Check if Ansible version is compatible
    local ansible_version
    ansible_version=$(ansible --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    if [[ -z "$ansible_version" ]]; then
        error_exit "Could not determine Ansible version"
    fi
    # COMMENT: Simple version check - Ansible 2.9+ or 3.0+ or 4.0+ etc.
    local major_version=$(echo "$ansible_version" | cut -d. -f1)
    local minor_version=$(echo "$ansible_version" | cut -d. -f2)
    if [[ "$major_version" -lt 2 ]] || [[ "$major_version" -eq 2 && "$minor_version" -lt 9 ]]; then
        error_exit "Ansible 2.9+ is required. Current version: $ansible_version"
    fi
    
    # COMMENT: Check if repository is properly initialized
    if [[ ! -d ".git" ]]; then
        error_exit "Not a git repository. Please clone the repository properly."
    fi
    
    # COMMENT: Check if vault password file exists
    if [[ ! -f "$VAULT_PASSWORD_FILE" ]]; then
        error_exit "Vault password file not found: $VAULT_PASSWORD_FILE"
    fi
    
    # COMMENT: Check if configuration directory exists
    if [[ ! -d "$CONFIG_DIR" ]]; then
        error_exit "Configuration directory not found: $CONFIG_DIR"
    fi
    
    log "INFO" "Prerequisites validation completed successfully"
}

# COMMENT: Validate configuration files for production deployment
validate_configuration() {
    log "INFO" "Validating configuration files"
    
    # COMMENT: Check if main configuration files exist
    local config_files=("common.yml" "vars.yml" "roles.yml")
    for config_file in "${config_files[@]}"; do
        if [[ ! -f "${CONFIG_DIR}/${config_file}" ]]; then
            log "WARN" "Configuration file not found: ${CONFIG_DIR}/${config_file}"
        fi
    done
    
    # COMMENT: Validate YAML syntax
    if command -v yamllint >/dev/null 2>&1; then
        log "INFO" "Validating YAML syntax with yamllint"
        if ! yamllint -c "${REPO_ROOT_ABS}/.yamllint.yaml" .; then
            log "WARN" "YAML validation found issues"
        fi
    else
        log "INFO" "yamllint not available, skipping YAML validation"
    fi
    
    # COMMENT: Validate Ansible syntax
    log "INFO" "Validating Ansible playbook syntax"
    if ! ansible-playbook --syntax-check main.yml >/dev/null 2>&1; then
        error_exit "Ansible playbook syntax validation failed"
    fi
    
    log "INFO" "Configuration validation completed successfully"
}

# COMMENT: Setup environment variables for production deployment
setup_environment() {
    log "INFO" "Setting up deployment environment"
    
    # COMMENT: Create required directories
    local directories=("$BACKUP_DIR" "${REPO_ROOT_ABS}/logs" "${REPO_ROOT_ABS}/tmp")
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        chmod 755 "$dir"
    done
    
    # COMMENT: Set environment variables
    export ANSIBLE_CONFIG="${REPO_ROOT_ABS}/ansible.cfg"
    export ANSIBLE_VAULT_PASSWORD_FILE="$VAULT_PASSWORD_FILE"
    export ANSIBLE_HOST_KEY_CHECKING=False
    export ANSIBLE_RETRY_FILES_ENABLED=False
    
    # COMMENT: Create log file with proper permissions
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
    
    log "INFO" "Environment setup completed successfully"
}

# COMMENT: Create deployment backup for production safety
create_backup() {
    log "INFO" "Creating deployment backup"
    
    local backup_timestamp
    backup_timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="${BACKUP_DIR}/deployment_${backup_timestamp}"
    
    mkdir -p "$backup_path"
    
    # COMMENT: Backup configuration files
    if [[ -d "$CONFIG_DIR" ]]; then
        cp -r "$CONFIG_DIR" "$backup_path/"
    fi
    
    # COMMENT: Backup playbooks
    if [[ -f "main.yml" ]]; then
        cp main.yml "$backup_path/"
    fi
    
    # COMMENT: Backup inventory
    if [[ -f "inventory.ini" ]]; then
        cp inventory.ini "$backup_path/"
    fi
    
    log "INFO" "Backup created: $backup_path"
}

# COMMENT: Execute deployment with proper error handling
execute_deployment() {
    log "INFO" "Starting deployment execution"
    
    # COMMENT: Check if dry run is requested
    if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
        log "INFO" "DRY RUN MODE: Would execute the following commands:"
        log "INFO" "  ansible-playbook -i inventory.ini main.yml --tags all"
        return 0
    fi
    
    # COMMENT: Execute main deployment playbook
    log "INFO" "Executing main deployment playbook"
    if ! ansible-playbook -i inventory.ini main.yml --tags all; then
        error_exit "Deployment playbook execution failed"
    fi
    
    log "INFO" "Deployment execution completed successfully"
}

# COMMENT: Validate deployment success for production reliability
validate_deployment() {
    log "INFO" "Validating deployment success"
    
    # COMMENT: Check if critical services are running
    local critical_services=("docker" "traefik" "nginx")
    for service in "${critical_services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            log "INFO" "Service $service is running"
        else
            log "WARN" "Service $service is not running"
        fi
    done
    
    # COMMENT: Check if required ports are listening
    local required_ports=(80 443 8080)
    for port in "${required_ports[@]}"; do
        if netstat -tlnp | grep -q ":$port "; then
            log "INFO" "Port $port is listening"
        else
            log "WARN" "Port $port is not listening"
        fi
    done
    
    log "INFO" "Deployment validation completed"
}

# COMMENT: Main execution function with comprehensive error handling
main() {
    local start_time
    start_time=$(date +%s)
    
    log "INFO" "Starting production homelab deployment"
    log "INFO" "Script version: $SCRIPT_VERSION"
    log "INFO" "Repository root: $REPO_ROOT_ABS"
    log "INFO" "Interactive mode: $INTERACTIVE"
    log "INFO" "Validate only: ${VALIDATE_ONLY:-0}"
    log "INFO" "Dry run: ${DRY_RUN:-0}"
    
    # COMMENT: Check if script is already running
    if [[ -f "$PID_FILE" ]]; then
        error_exit "Script is already running (PID file exists: $PID_FILE)"
    fi
    echo $$ > "$PID_FILE"
    
    # COMMENT: Execute deployment steps with proper error handling
    # COMMENT: Validate prerequisites
    if ! validate_prerequisites; then
        error_exit "Prerequisites validation failed"
    fi
    
    # COMMENT: Setup environment
    if ! setup_environment; then
        error_exit "Environment setup failed"
    fi
    
    # COMMENT: Validate configuration
    if ! validate_configuration; then
        error_exit "Configuration validation failed"
    fi
    
    # COMMENT: Create backup
    if ! create_backup; then
        error_exit "Backup creation failed"
    fi
    
    # COMMENT: Check if validation only is requested
    if [[ "${VALIDATE_ONLY:-0}" -eq 1 ]]; then
        log "INFO" "Validation only mode - deployment skipped"
        return 0
    fi
    
    # COMMENT: Execute deployment
    if ! execute_deployment; then
        error_exit "Deployment execution failed"
    fi
    
    # COMMENT: Validate deployment
    if ! validate_deployment; then
        error_exit "Deployment validation failed"
    fi
    
    # COMMENT: Calculate execution time
    local end_time
    end_time=$(date +%s)
    local execution_time=$((end_time - start_time))
    
    log "INFO" "Production homelab deployment completed successfully"
    log "INFO" "Total execution time: ${execution_time} seconds"
}

# COMMENT: Execute main function with all provided arguments
main "$@"
