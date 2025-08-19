#!/bin/bash

# Ansible Homelab Service Integration Script
# Enhanced with comprehensive error checking and validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_ROOT/logs/add_service.log"

# Create logs directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ Error:${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}⚠️  Warning:${NC} $1" | tee -a "$LOG_FILE"
}

# Function to check if a service already exists
check_service_exists() {
    local service_name="$1"
    
    log "Checking if service '$service_name' already exists..."
    
    # Check if role directory exists
    if [[ -d "$PROJECT_ROOT/roles/$service_name" ]]; then
        error "Service '$service_name' already exists! Role directory found at: roles/$service_name"
        echo "To update an existing service, use the update script instead."
        return 1
    fi
    
    # Check if service is in enabled_services list
    if grep -q "^\s*-\s*$service_name\s*$" "$PROJECT_ROOT/group_vars/all/vars.yml" 2>/dev/null; then
        error "Service '$service_name' is already in the enabled_services list!"
        return 1
    fi
    
    # Check if service is in subdomains
    if grep -q "^\s*$service_name:\s*" "$PROJECT_ROOT/group_vars/all/vars.yml" 2>/dev/null; then
        error "Service '$service_name' is already configured in subdomains!"
        return 1
    fi
    
    # Check if vault variables exist
    if grep -q "vault_${service_name}_" "$PROJECT_ROOT/group_vars/all/vars.yml" 2>/dev/null; then
        warning "Vault variables for '$service_name' already exist in vars.yml"
    fi
    
    success "Service '$service_name' does not exist and can be added"
    return 0
}

# Function to validate YAML syntax
validate_yaml() {
    local file="$1"
    local description="$2"
    
    log "Validating YAML syntax for $description..."
    
    # Skip validation for vault files as they contain unquoted Jinja2 expressions
    if [[ "$file" == *"vault.yml" ]]; then
        log "Skipping YAML validation for vault file (contains unquoted Jinja2 expressions)"
        return 0
    fi
    
    if ! python3 -c "import yaml; yaml.safe_load(open('$file', 'r'))" 2>/dev/null; then
        error "YAML syntax error in $file"
        echo "Please fix the YAML syntax errors before proceeding."
        return 1
    fi
    
    success "YAML syntax is valid for $description"
    return 0
}

# Function to backup configuration files
backup_configs() {
    local timestamp=$(date +'%Y%m%d_%H%M%S')
    local backup_dir="$PROJECT_ROOT/backups/add_service_${timestamp}"
    
    log "Creating backup of configuration files..."
    mkdir -p "$backup_dir"
    
    # Backup critical files
    cp "$PROJECT_ROOT/group_vars/all/vars.yml" "$backup_dir/" 2>/dev/null || true
    cp "$PROJECT_ROOT/group_vars/all/vault.yml" "$backup_dir/" 2>/dev/null || true
    
    success "Backup created at: $backup_dir"
    echo "$backup_dir" > "$PROJECT_ROOT/.last_backup_path"
}

# Function to restore from backup
restore_backup() {
    local backup_path="$1"
    
    if [[ -f "$backup_path" ]]; then
        log "Restoring from backup..."
        cp "$backup_path/group_vars/all/vars.yml" "$PROJECT_ROOT/group_vars/all/vars.yml" 2>/dev/null || true
        cp "$backup_path/group_vars/all/vault.yml" "$PROJECT_ROOT/group_vars/all/vault.yml" 2>/dev/null || true
        success "Configuration restored from backup"
    else
        error "Backup not found at: $backup_path"
    fi
}

# Function to check environment requirements
check_environment() {
    log "Checking environment requirements..."
    
    # Check if Python is available
    if ! command -v python3 &> /dev/null; then
        error "Python 3 is required but not installed"
        exit 1
    fi
    
    # Check if required modules are available
    if ! python3 -c "import yaml, requests, pathlib" &> /dev/null; then
        error "Required Python modules not available"
        echo "Please install: pip3 install pyyaml requests"
        exit 1
    fi
    
    # Check if project structure is valid
    if [[ ! -d "$PROJECT_ROOT/roles" ]] || [[ ! -d "$PROJECT_ROOT/group_vars" ]]; then
        error "Invalid project structure. Please run from the ansible homelab root directory."
        exit 1
    fi
    
    success "Environment check passed"
}

# Function to validate service name
validate_service_name() {
    local service_name="$1"
    
    # Check if service name is provided
    if [[ -z "$service_name" ]]; then
        error "Service name is required"
        echo "Usage: $0 <service_name> [options]"
        exit 1
    fi
    
    # Validate service name format (lowercase, no spaces, alphanumeric and hyphens only)
    if [[ ! "$service_name" =~ ^[a-z0-9-]+$ ]]; then
        error "Invalid service name: '$service_name'"
        echo "Service name must be lowercase, contain only letters, numbers, and hyphens"
        echo "Examples: jellyfin, postgres, homepage, portainer"
        exit 1
    fi
    
    # Check for reserved names
    local reserved_names=("all" "hosts" "group_vars" "roles" "tasks" "templates" "vars" "defaults")
    for reserved in "${reserved_names[@]}"; do
        if [[ "$service_name" == "$reserved" ]]; then
            error "Service name '$service_name' is reserved and cannot be used"
            exit 1
        fi
    done
    
    success "Service name '$service_name' is valid"
}

# Function to run the service wizard with error handling
run_service_wizard() {
    local service_name="$1"
    shift
    
    log "Running service wizard for '$service_name'..."
    
    # Create backup before making changes
    backup_configs
    
    # Run the Python script with error handling
    if ! python3 "$SCRIPT_DIR/service_wizard.py" --project-root "$PROJECT_ROOT" --service-name "$service_name" "$@"; then
        error "Service wizard failed"
        
        # Offer to restore from backup
        local backup_path=$(cat "$PROJECT_ROOT/.last_backup_path" 2>/dev/null || echo "")
        if [[ -n "$backup_path" ]]; then
            echo -e "${YELLOW}Would you like to restore from backup? (y/N)${NC}"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                restore_backup "$backup_path"
            fi
        fi
        
        exit 1
    fi
    
    success "Service wizard completed successfully"
}

# Function to perform post-integration validation
validate_integration() {
    local service_name="$1"
    
    log "Performing post-integration validation..."
    
    # Check if role was created
    if [[ ! -d "$PROJECT_ROOT/roles/$service_name" ]]; then
        error "Role directory was not created for '$service_name'"
        return 1
    fi
    
    # Validate YAML files
    local yaml_files=(
        "$PROJECT_ROOT/group_vars/all/vars.yml"
        "$PROJECT_ROOT/roles/$service_name/defaults/main.yml"
    )
    
    for file in "${yaml_files[@]}"; do
        if [[ -f "$file" ]]; then
            if ! validate_yaml "$file" "$(basename "$file")"; then
                error "YAML validation failed for $file"
                return 1
            fi
        fi
    done
    
    # Check if service was added to enabled_services
    if ! grep -q "^\s*-\s*$service_name\s*$" "$PROJECT_ROOT/group_vars/all/vars.yml" 2>/dev/null; then
        warning "Service '$service_name' was not added to enabled_services list"
    fi
    
    success "Integration validation completed"
}

# Main execution
main() {
    echo "🚀 HomelabOS Integration Wizard"
    echo "================================"
    echo ""
    
    # Parse command line arguments
    local service_name=""
    local non_interactive=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --service-name)
                service_name="$2"
                non_interactive=true
                shift 2
                ;;
            --help|-h)
                echo "Usage: $0 <service_name> [options]"
                echo ""
                echo "Options:"
                echo "  --service-name NAME    Service name (required)"
                echo "  --help, -h            Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0 jellyfin"
                echo "  $0 --service-name postgres"
                exit 0
                ;;
            *)
                if [[ -z "$service_name" ]]; then
                    service_name="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Check environment
    check_environment
    
    # Validate service name
    validate_service_name "$service_name"
    
    # Check if service already exists
    if ! check_service_exists "$service_name"; then
        echo ""
        echo "To update an existing service, use the update script instead."
        echo "To force add the service (overwrite existing), use --force flag."
        exit 1
    fi
    
    # Validate existing YAML files before making changes
    log "Validating existing configuration files..."
    if ! validate_yaml "$PROJECT_ROOT/group_vars/all/vars.yml" "main vars file"; then
        error "Cannot proceed with invalid YAML syntax"
        exit 1
    fi
    
    # Run the service wizard
    run_service_wizard "$service_name" "$@"
    
    # Perform post-integration validation
    validate_integration "$service_name"
    
    echo ""
    success "Service '$service_name' has been successfully integrated!"
    echo ""
    echo "Next steps:"
    echo "1. Review the generated configuration in roles/$service_name/"
    echo "2. Update vault variables if needed"
    echo "3. Run your main playbook to deploy the service"
    echo ""
    echo "Service will be accessible at: $service_name.yourdomain.com"
}

# Run main function with all arguments
main "$@" 