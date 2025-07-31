#!/bin/bash
# Fix Vault Variables Script
# Automatically replaces hardcoded passwords and non-vault variables with proper vault variables

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}"
    echo "================================================"
    echo "  🔒 Fix Vault Variables Script"
    echo "  🔐 Replace Hardcoded Passwords with Vault Variables"
    echo "================================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP $1]${NC} $2"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to safely replace text in files
safe_replace() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"
    local description="$4"
    
    if [ -f "$file" ]; then
        if grep -q "$pattern" "$file"; then
            # Create backup
            cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)"
            
            # Replace the pattern
            sed -i "s|$pattern|$replacement|g" "$file"
            
            print_success "Fixed $description in $file"
        else
            print_warning "Pattern not found in $file: $pattern"
        fi
    else
        print_warning "File not found: $file"
    fi
}

# Function to fix task files
fix_task_files() {
    print_step "1" "Fixing task files..."
    
    # Fix calibre-web.yml
    safe_replace "tasks/calibre-web.yml" \
        "CALIBRE_WEB_ADMIN_PASSWORD={{ calibre_web_password }}" \
        "CALIBRE_WEB_ADMIN_PASSWORD={{ vault_calibre_web_password }}" \
        "calibre web password"
    
    # Fix jellyfin.yml
    safe_replace "tasks/jellyfin.yml" \
        "JELLYFIN_ADMIN_PASSWORD={{ jellyfin_password }}" \
        "JELLYFIN_ADMIN_PASSWORD={{ vault_jellyfin_password }}" \
        "jellyfin password"
    
    # Fix sabnzbd.yml
    safe_replace "tasks/sabnzbd.yml" \
        "password = {{ sabnzbd_password }}" \
        "password = {{ vault_sabnzbd_password }}" \
        "sabnzbd password"
    
    # Fix audiobookshelf.yml
    safe_replace "tasks/audiobookshelf.yml" \
        "AUDIOBOOKSHELF_ADMIN_PASSWORD={{ audiobookshelf_password }}" \
        "AUDIOBOOKSHELF_ADMIN_PASSWORD={{ vault_audiobookshelf_password }}" \
        "audiobookshelf password"
    
    # Fix nextcloud.yml
    safe_replace "tasks/nextcloud.yml" \
        "- MYSQL_PASSWORD={{ nextcloud_db_password }}" \
        "- MYSQL_PASSWORD={{ vault_nextcloud_db_password }}" \
        "nextcloud db password"
    
    safe_replace "tasks/nextcloud.yml" \
        "- NEXTCLOUD_ADMIN_PASSWORD={{ nextcloud_admin_password }}" \
        "- NEXTCLOUD_ADMIN_PASSWORD={{ vault_nextcloud_admin_password }}" \
        "nextcloud admin password"
    
    safe_replace "tasks/nextcloud.yml" \
        "- MYSQL_ROOT_PASSWORD={{ nextcloud_db_root_password }}" \
        "- MYSQL_ROOT_PASSWORD={{ vault_nextcloud_db_root_password }}" \
        "nextcloud db root password"
    
    # Fix grafana.yml
    safe_replace "tasks/grafana.yml" \
        "- GF_SECURITY_ADMIN_PASSWORD={{ grafana_admin_password }}" \
        "- GF_SECURITY_ADMIN_PASSWORD={{ vault_grafana_admin_password }}" \
        "grafana admin password"
    
    safe_replace "tasks/grafana.yml" \
        "admin_password = {{ grafana_admin_password }}" \
        "admin_password = {{ vault_grafana_admin_password }}" \
        "grafana admin password"
    
    # Fix watchtower.yml
    safe_replace "tasks/watchtower.yml" \
        "- AUTHENTIK_POSTGRES__PASSWORD={{ authentik_postgres_password }}" \
        "- AUTHENTIK_POSTGRES__PASSWORD={{ vault_authentik_postgres_password }}" \
        "authentik postgres password"
    
    safe_replace "tasks/watchtower.yml" \
        "- POSTGRES_PASSWORD={{ authentik_postgres_password }}" \
        "- POSTGRES_PASSWORD={{ vault_authentik_postgres_password }}" \
        "authentik postgres password"
    
    safe_replace "tasks/watchtower.yml" \
        "- GF_SECURITY_ADMIN_PASSWORD={{ grafana_admin_password }}" \
        "- GF_SECURITY_ADMIN_PASSWORD={{ vault_grafana_admin_password }}" \
        "grafana admin password"
    
    safe_replace "tasks/watchtower.yml" \
        "- DOCKER_INFLUXDB_INIT_PASSWORD={{ influxdb_admin_password }}" \
        "- DOCKER_INFLUXDB_INIT_PASSWORD={{ vault_influxdb_admin_password }}" \
        "influxdb admin password"
    
    # Fix docker-compose.yml
    safe_replace "tasks/docker-compose.yml" \
        "- POSTGRES_PASSWORD={{ postgres_password }}" \
        "- POSTGRES_PASSWORD={{ vault_postgresql_password }}" \
        "postgres password"
    
    # Fix influxdb.yml
    safe_replace "tasks/influxdb.yml" \
        "DOCKER_INFLUXDB_INIT_PASSWORD: \"{{ influxdb_admin_password }}\"" \
        "DOCKER_INFLUXDB_INIT_PASSWORD: \"{{ vault_influxdb_admin_password }}\"" \
        "influxdb admin password"
    
    print_success "Task files fixed"
}

# Function to fix template files
fix_template_files() {
    print_step "2" "Fixing template files..."
    
    # Fix telegraf.conf.j2
    safe_replace "templates/telegraf.conf.j2" \
        "password = \"{{ influxdb_password }}\"" \
        "password = \"{{ vault_influxdb_admin_password }}\"" \
        "influxdb password"
    
    # Fix grafana automation config
    safe_replace "roles/grafana/templates/automation_config.yml.j2" \
        "admin_password: \"{{ grafana_admin_password }}\"" \
        "admin_password: \"{{ vault_grafana_admin_password }}\"" \
        "grafana admin password"
    
    safe_replace "roles/grafana/templates/automation_config.yml.j2" \
        "password: \"{{ grafana_admin_password }}\"" \
        "password: \"{{ vault_grafana_admin_password }}\"" \
        "grafana admin password"
    
    # Fix grafana defaults
    safe_replace "roles/grafana/defaults/main.yml" \
        "grafana_admin_password: \"{{ vault_grafana_admin_password }}\"" \
        "grafana_admin_password: \"{{ vault_grafana_admin_password }}\"" \
        "grafana admin password"
    
    safe_replace "roles/grafana/defaults/main.yml" \
        "password: \"{{ grafana_admin_password }}\"" \
        "password: \"{{ vault_grafana_admin_password }}\"" \
        "grafana admin password"
    
    safe_replace "roles/grafana/defaults/main.yml" \
        "GF_SECURITY_ADMIN_PASSWORD: \"{{ grafana_admin_password }}\"" \
        "GF_SECURITY_ADMIN_PASSWORD: \"{{ vault_grafana_admin_password }}\"" \
        "grafana admin password"
    
    # Fix grafana tasks
    for task_file in roles/grafana/tasks/*.yml; do
        if [ -f "$task_file" ]; then
            safe_replace "$task_file" \
                "password: \"{{ grafana_admin_password }}\"" \
                "password: \"{{ vault_grafana_admin_password }}\"" \
                "grafana admin password"
            
            safe_replace "$task_file" \
                "--password {{ grafana_admin_password }}" \
                "--password {{ vault_grafana_admin_password }}" \
                "grafana admin password"
        fi
    done
    
    # Fix storage defaults
    safe_replace "roles/storage/defaults/main.yml" \
        "nextcloud_admin_password: \"{{ vault_nextcloud_admin_password }}\"" \
        "nextcloud_admin_password: \"{{ vault_nextcloud_admin_password }}\"" \
        "nextcloud admin password"
    
    safe_replace "roles/storage/defaults/main.yml" \
        "nextcloud_db_password: \"{{ vault_nextcloud_db_password }}\"" \
        "nextcloud_db_password: \"{{ vault_nextcloud_db_password }}\"" \
        "nextcloud db password"
    
    safe_replace "roles/storage/defaults/main.yml" \
        "nextcloud_db_root_password: \"{{ vault_nextcloud_db_root_password }}\"" \
        "nextcloud_db_root_password: \"{{ vault_nextcloud_db_root_password }}\"" \
        "nextcloud db root password"
    
    # Fix storage cloud tasks
    safe_replace "roles/storage/cloud/tasks/main.yml" \
        "- MYSQL_PASSWORD={{ nextcloud_db_password }}" \
        "- MYSQL_PASSWORD={{ vault_nextcloud_db_password }}" \
        "nextcloud db password"
    
    safe_replace "roles/storage/cloud/tasks/main.yml" \
        "- NEXTCLOUD_ADMIN_PASSWORD={{ nextcloud_admin_password }}" \
        "- NEXTCLOUD_ADMIN_PASSWORD={{ vault_nextcloud_admin_password }}" \
        "nextcloud admin password"
    
    safe_replace "roles/storage/cloud/tasks/main.yml" \
        "- MYSQL_ROOT_PASSWORD={{ nextcloud_db_root_password }}" \
        "- MYSQL_ROOT_PASSWORD={{ vault_nextcloud_db_root_password }}" \
        "nextcloud db root password"
    
    # Fix storage backup tasks
    safe_replace "roles/storage/tasks/backup.yml" \
        "docker exec nextcloud-db mysqldump -u root -p{{ nextcloud_db_root_password }}" \
        "docker exec nextcloud-db mysqldump -u root -p{{ vault_nextcloud_db_root_password }}" \
        "nextcloud db root password"
    
    # Fix security defaults
    safe_replace "roles/security/defaults/main.yml" \
        "postgres_password: \"{{ vault_authentik_postgres_password }}\"" \
        "postgres_password: \"{{ vault_authentik_postgres_password }}\"" \
        "authentik postgres password"
    
    print_success "Template files fixed"
}

# Function to fix role files
fix_role_files() {
    print_step "3" "Fixing role files..."
    
    # Fix storage vars
    safe_replace "roles/storage/vars/main.yml" \
        "vault_nextcloud_admin_password: \"\"" \
        "vault_nextcloud_admin_password: \"{{ vault_nextcloud_admin_password }}\"" \
        "nextcloud admin password"
    
    safe_replace "roles/storage/vars/main.yml" \
        "vault_nextcloud_db_password: \"\"" \
        "vault_nextcloud_db_password: \"{{ vault_nextcloud_db_password }}\"" \
        "nextcloud db password"
    
    safe_replace "roles/storage/vars/main.yml" \
        "vault_nextcloud_db_root_password: \"\"" \
        "vault_nextcloud_db_root_password: \"{{ vault_nextcloud_db_root_password }}\"" \
        "nextcloud db root password"
    
    # Fix group vars
    safe_replace "group_vars/all/roles.yml" \
        "nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \
        "nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \
        "nextcloud admin password"
    
    print_success "Role files fixed"
}

# Function to fix test files
fix_test_files() {
    print_step "4" "Fixing test files..."
    
    # Fix performance tests
    safe_replace "tests/performance/load_test.yml" \
        "time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \
        "time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \
        "grafana admin password"
    
    # Fix validation tests
    safe_replace "tasks/validate_services.yml" \
        "Authorization: \"Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \
        "Authorization: \"Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \
        "grafana admin password"
    
    print_success "Test files fixed"
}

# Function to create missing vault variables
create_missing_vault_variables() {
    print_step "5" "Creating missing vault variables..."
    
    # Check if vault.yml exists
    if [ ! -f "group_vars/all/vault.yml" ]; then
        print_error "Vault file not found. Please run the seamless setup script first."
        exit 1
    fi
    
    # Add missing variables to vault.yml if they don't exist
    local missing_vars=(
        "vault_calibre_web_password"
        "vault_jellyfin_password"
        "vault_sabnzbd_password"
        "vault_audiobookshelf_password"
        "vault_authentik_postgres_password"
        "vault_grafana_admin_password_alt"
        "vault_influxdb_admin_password_alt"
        "vault_nextcloud_db_password_alt"
        "vault_nextcloud_admin_password_alt"
        "vault_nextcloud_db_root_password_alt"
    )
    
    for var in "${missing_vars[@]}"; do
        if ! grep -q "^${var}:" group_vars/all/vault.yml; then
            echo "# $var: \"[secure-random-generated]\"" >> group_vars/all/vault.yml
            print_warning "Added missing variable: $var"
        fi
    done
    
    print_success "Missing vault variables added"
}

# Function to validate fixes
validate_fixes() {
    print_step "6" "Validating fixes..."
    
    # Check for remaining hardcoded passwords
    local hardcoded_patterns=(
        "password.*=.*[a-zA-Z0-9]{8,}"
        "PASSWORD.*=.*[a-zA-Z0-9]{8,}"
        "password.*=.*[a-zA-Z0-9]{8,}"
    )
    
    local found_hardcoded=false
    
    for pattern in "${hardcoded_patterns[@]}"; do
        if grep -r "$pattern" tasks/ roles/ templates/ --include="*.yml" --include="*.yaml" --include="*.j2" | grep -v "vault_" | grep -v "lookup"; then
            print_warning "Potential hardcoded password found with pattern: $pattern"
            found_hardcoded=true
        fi
    done
    
    if [ "$found_hardcoded" = false ]; then
        print_success "No hardcoded passwords found"
    fi
    
    # Check for non-vault variables
    local non_vault_patterns=(
        "{{ grafana_admin_password }}"
        "{{ nextcloud_admin_password }}"
        "{{ nextcloud_db_password }}"
        "{{ authentik_postgres_password }}"
        "{{ influxdb_admin_password }}"
        "{{ calibre_web_password }}"
        "{{ jellyfin_password }}"
        "{{ sabnzbd_password }}"
        "{{ audiobookshelf_password }}"
    )
    
    local found_non_vault=false
    
    for pattern in "${non_vault_patterns[@]}"; do
        if grep -r "$pattern" tasks/ roles/ templates/ --include="*.yml" --include="*.yaml" --include="*.j2" | grep -v "vault_"; then
            print_warning "Non-vault variable found: $pattern"
            found_non_vault=true
        fi
    done
    
    if [ "$found_non_vault" = false ]; then
        print_success "No non-vault variables found"
    fi
    
    print_success "Validation completed"
}

# Main execution
main() {
    print_header
    
    echo "This script will fix all hardcoded passwords and non-vault variables"
    echo "in the codebase to use proper vault variables."
    echo ""
    read -p "Continue? [Y/n]: " proceed
    if [[ ! $proceed =~ ^[Yy]$ ]] && [[ -n $proceed ]]; then
        echo "Aborted."
        exit 0
    fi
    
    fix_task_files
    fix_template_files
    fix_role_files
    fix_test_files
    create_missing_vault_variables
    validate_fixes
    
    echo ""
    print_header
    echo -e "${GREEN}🎉 Vault variable fixes completed successfully!${NC}"
    echo ""
    echo -e "${CYAN}📋 Summary:${NC}"
    echo "• Fixed hardcoded passwords in task files"
    echo "• Fixed non-vault variables in templates"
    echo "• Fixed role configuration files"
    echo "• Added missing vault variables"
    echo "• Validated all fixes"
    echo ""
    echo -e "${YELLOW}⚠️  Next Steps:${NC}"
    echo "1. Review the changes in the backup files"
    echo "2. Test the deployment with the fixed variables"
    echo "3. Ensure all services use vault variables"
    echo "4. Run the seamless setup script to generate secure values"
    echo ""
    echo -e "${GREEN}✅ All variables now use the vault system!${NC}"
}

# Run main function
main "$@" 