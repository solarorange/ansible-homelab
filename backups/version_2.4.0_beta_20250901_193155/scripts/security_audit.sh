#!/bin/bash
# Comprehensive Security Audit Script
# Checks for hardcoded passwords, insecure generation, and missing vault variables

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
LOG_FILE="security_audit_$(date +%Y%m%d_%H%M%S).log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${CYAN}"
    echo "================================================"
    echo "  🔒 Comprehensive Security Audit"
    echo "  🔐 Check for Hardcoded Passwords & Security Issues"
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

# Function to check for hardcoded passwords
check_hardcoded_passwords() {
    print_step "1" "Checking for hardcoded passwords..."
    
    local issues_found=false
    
    # Check for common hardcoded password patterns
    local patterns=(
        "password.*=.*[a-zA-Z0-9]{8,}"
        "PASSWORD.*=.*[a-zA-Z0-9]{8,}"
        "password.*=.*[a-zA-Z0-9]{8,}"
        "secret.*=.*[a-zA-Z0-9]{8,}"
        "SECRET.*=.*[a-zA-Z0-9]{8,}"
        "key.*=.*[a-zA-Z0-9]{8,}"
        "KEY.*=.*[a-zA-Z0-9]{8,}"
        "token.*=.*[a-zA-Z0-9]{8,}"
        "TOKEN.*=.*[a-zA-Z0-9]{8,}"
    )
    
    for pattern in "${patterns[@]}"; do
        local matches=$(grep -r "$pattern" tasks/ roles/ templates/ --include="*.yml" --include="*.yaml" --include="*.j2" --include="*.sh" --include="*.py" 2>/dev/null | grep -v "vault_" | grep -v "lookup" | grep -v "generate_" || true)
        
        if [ -n "$matches" ]; then
            print_error "Hardcoded password found with pattern: $pattern"
            echo "$matches" | while read -r line; do
                echo "  $line"
            done
            issues_found=true
        fi
    done
    
    if [ "$issues_found" = false ]; then
        print_success "No hardcoded passwords found"
    fi
    
    return 0
}

# Function to check for insecure password generation
check_insecure_password_generation() {
    print_step "2" "Checking for insecure password generation..."
    
    local issues_found=false
    
    # Check for insecure lookup patterns
    local insecure_patterns=(
        "lookup.*password.*chars=ascii_letters,digits"
        "lookup.*password.*length="
        "lookup.*password.*/dev/null"
    )
    
    for pattern in "${insecure_patterns[@]}"; do
        local matches=$(grep -r "$pattern" tasks/ roles/ templates/ --include="*.yml" --include="*.yaml" --include="*.j2" 2>/dev/null || true)
        
        if [ -n "$matches" ]; then
            print_error "Insecure password generation found with pattern: $pattern"
            echo "$matches" | while read -r line; do
                echo "  $line"
            done
            issues_found=true
        fi
    done
    
    if [ "$issues_found" = false ]; then
        print_success "No insecure password generation found"
    fi
    
    return 0
}

# Function to check for non-vault variables
check_non_vault_variables() {
    print_step "3" "Checking for non-vault variables..."
    
    local issues_found=false
    
    # Check for variables that should use vault
    local non_vault_patterns=(
        "{{ grafana_admin_password }}"
        "{{ nextcloud_admin_password }}"
        "{{ nextcloud_db_password }}"
        "{{ nextcloud_db_root_password }}"
        "{{ authentik_postgres_password }}"
        "{{ influxdb_admin_password }}"
        "{{ calibre_web_password }}"
        "{{ jellyfin_password }}"
        "{{ sabnzbd_password }}"
        "{{ audiobookshelf_password }}"
        "{{ postgres_password }}"
        "{{ redis_password }}"
        "{{ mariadb_root_password }}"
        "{{ paperless_admin_password }}"
        "{{ fing_admin_password }}"
        "{{ pihole_admin_password }}"
        "{{ homeassistant_admin_password }}"
        "{{ gitlab_root_password }}"
        "{{ portainer_admin_password }}"
        "{{ vaultwarden_admin_password }}"
        "{{ homepage_admin_password }}"
    )
    
    for pattern in "${non_vault_patterns[@]}"; do
        local matches=$(grep -r "$pattern" tasks/ roles/ templates/ --include="*.yml" --include="*.yaml" --include="*.j2" 2>/dev/null | grep -v "vault_" || true)
        
        if [ -n "$matches" ]; then
            print_error "Non-vault variable found: $pattern"
            echo "$matches" | while read -r line; do
                echo "  $line"
            done
            issues_found=true
        fi
    done
    
    if [ "$issues_found" = false ]; then
        print_success "No non-vault variables found"
    fi
    
    return 0
}

# Function to check for missing vault variables
check_missing_vault_variables() {
    print_step "4" "Checking for missing vault variables..."
    
    local issues_found=false
    
    # Check if vault.yml exists
    if [ ! -f "group_vars/all/vault.yml" ]; then
        print_error "Vault file not found: group_vars/all/vault.yml"
        issues_found=true
        return 1
    fi
    
    # List of required vault variables
    local required_vars=(
        "vault_postgresql_password"
        "vault_media_database_password"
        "vault_paperless_database_password"
        "vault_fing_database_password"
        "vault_redis_password"
        "vault_mariadb_root_password"
        "vault_influxdb_admin_password"
        "vault_influxdb_token"
        "vault_paperless_admin_password"
        "vault_paperless_secret_key"
        "vault_fing_admin_password"
        "vault_paperless_admin_token"
        "vault_fing_api_key"
        "vault_sabnzbd_api_key"
        "vault_sonarr_api_key"
        "vault_radarr_api_key"
        "vault_lidarr_api_key"
        "vault_readarr_api_key"
        "vault_prowlarr_api_key"
        "vault_bazarr_api_key"
        "vault_ersatztv_api_key"
        "vault_tautulli_api_key"
        "vault_overseerr_api_key"
        "vault_jellyfin_api_key"
        "vault_emby_api_key"
        "vault_lidarr_username"
        "vault_lidarr_password"
        "vault_lidarr_anonymous_id"
        "vault_qbittorrent_password"
        "vault_homeassistant_admin_password"
        "vault_mosquitto_admin_password"
        "vault_zigbee2mqtt_mqtt_password"
        "vault_nextcloud_admin_password"
        "vault_nextcloud_db_password"
        "vault_nextcloud_db_root_password"
        "vault_syncthing_gui_password"
        "vault_syncthing_apikey"
        "vault_backup_encryption_key"
        "vault_grafana_admin_password"
        "vault_grafana_secret_key"
        "vault_authentik_secret_key"
        "vault_authentik_postgres_password"
        "vault_authentik_admin_email"
        "vault_authentik_admin_password"
        "vault_authentik_redis_password"
        "vault_traefik_basic_auth_hash"
        "vault_immich_db_password"
        "vault_immich_redis_password"
        "vault_immich_jwt_secret"
        "vault_immich_postgres_password"
        "vault_linkwarden_postgres_password"
        "vault_linkwarden_nextauth_secret"
        "vault_smtp_username"
        "vault_smtp_password"
        "vault_slack_webhook"
        "vault_discord_webhook"
        "vault_telegram_bot_token"
        "vault_telegram_chat_id"
        "vault_watchtower_token"
        "vault_pihole_admin_password"
        "vault_reconya_admin_password"
        "vault_reconya_jwt_secret"
        "vault_n8n_admin_password"
        "vault_n8n_encryption_key"
        "vault_n8n_postgres_password"
        "vault_pezzo_postgres_password"
        "vault_pezzo_redis_password"
        "vault_pezzo_clickhouse_password"
        "vault_homepage_api_key"
        "vault_traefik_api_key"
        "vault_authentik_api_key"
        "vault_portainer_api_key"
        "vault_grafana_api_key"
        "vault_readarr_api_key"
        "vault_paperless_api_key"
        "vault_bookstack_api_key"
        "vault_immich_api_key"
        "vault_filebrowser_api_key"
        "vault_minio_api_key"
        "vault_kopia_api_key"
        "vault_duplicati_api_key"
        "vault_uptimekuma_api_key"
        "vault_gitlab_api_key"
        "vault_harbor_api_key"
        "vault_guacamole_api_key"
        "vault_homeassistant_api_key"
        "vault_crowdsec_api_key"
        "vault_fail2ban_api_key"
        "vault_gitlab_root_password"
        "vault_portainer_admin_password"
        "vault_vaultwarden_admin_password"
        "vault_homepage_admin_password"
        "vault_wireguard_password"
        "vault_codeserver_password"
        "vault_vault_root_token"
        "vault_vault_unseal_key"
        "vault_openweather_api_key"
        "vault_kubernetes_token"
        "vault_google_client_secret"
        "vault_google_refresh_token"
        "vault_minio_access_key"
        "vault_minio_secret_key"
        "vault_vaultwarden_admin_token"
        "vault_vaultwarden_postgres_password"
        "vault_vaultwarden_smtp_host"
        "vault_vaultwarden_smtp_port"
        "vault_vaulten_smtp_ssl"
        "vault_vaultwarden_smtp_username"
        "vault_vaultwarden_smtp_password"
        "vault_qbittorrent_username"
        "vault_lastfm_username"
        "vault_lidarr_username"
        "vault_lidarr_anonymous_id"
        "vault_lidarr_password"
        "vault_plex_username"
        "vault_plex_password"
        "vault_jellyfin_username"
        "vault_jellyfin_password"
        "vault_immich_smtp_username"
        "vault_plex_token"
        "vault_webhook_token"
        "vault_traefik_pilot_token"
        "vault_immich_mapbox_key"
        "vault_pagerduty_integration_key"
        "vault_pagerduty_routing_key"
        "vault_grafana_admin_user"
        "vault_influxdb_admin_user"
        "vault_influxdb_username"
        "vault_media_jwt_secret"
        "vault_redis_secret_key"
        "vault_postgresql_user"
        "vault_calibreweb_secret_key"
        "vault_elasticsearch_password"
        "vault_elasticsearch_secret_key"
        "vault_kibana_password"
        "vault_loki_auth_token"
        "vault_ersatztv_database_password"
        "vault_grafana_db_password"
        "vault_grafana_viewer_password"
        "vault_grafana_editor_password"
        "vault_grafana_oauth_secret"
        "vault_homepage_oauth_secret"
        "vault_homepage_api_secret"
        "vault_authentik_bootstrap_token"
        "vault_fail2ban_secret_key"
        "vault_postgresql_admin_password"
        "vault_elasticsearch_elastic_password"
        "vault_backup_smtp_password"
        "vault_immich_admin_password"
        "vault_immich_oauth_client_secret"
        "vault_immich_smtp_password"
        "vault_immich_push_token"
        "vault_immich_push_app_secret"
        "vault_immich_telegram_bot_token"
        "vault_cloudflare_api_token"
        "vault_pihole_database_password"
        "vault_ssl_cert_key"
        "vault_ssl_private_key"
        "vault_jwt_secret"
        "vault_encryption_key"
        "vault_samba_password"
        "vault_pihole_web_password"
        "vault_admin_password"
        "vault_db_password"
        "vault_paperless_ngx_admin_password"
        "vault_homepage_user_password"
        "vault_homepage_secret_key"
        "vault_google_client_secret"
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
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}:" group_vars/all/vault.yml; then
            print_error "Missing vault variable: $var"
            issues_found=true
        fi
    done
    
    if [ "$issues_found" = false ]; then
        print_success "All required vault variables are present"
    fi
    
    return 0
}

# Function to check for encrypted vault file
check_vault_encryption() {
    print_step "5" "Checking vault file encryption..."
    
    if [ -f "group_vars/all/vault.yml" ]; then
        # Check if file is encrypted by looking for ANSIBLE_VAULT header
        if head -1 group_vars/all/vault.yml | grep -q "^\$ANSIBLE_VAULT"; then
            print_success "Vault file is properly encrypted"
        else
            print_error "Vault file is not encrypted! Run: ansible-vault encrypt group_vars/all/vault.yml"
        fi
    else
        print_error "Vault file not found: group_vars/all/vault.yml"
    fi
    
    return 0
}

# Function to check for secure password generation in seamless setup
check_seamless_setup_security() {
    print_step "6" "Checking seamless setup security..."
    
    local issues_found=false
    
    if [ -f "scripts/seamless_setup.sh" ]; then
        # Check for secure password generation functions
        if ! grep -q "generate_secure_password" scripts/seamless_setup.sh; then
            print_error "Missing generate_secure_password function in seamless setup"
            issues_found=true
        fi
        
        if ! grep -q "generate_secure_secret" scripts/seamless_setup.sh; then
            print_error "Missing generate_secure_secret function in seamless setup"
            issues_found=true
        fi
        
        if ! grep -q "generate_api_key" scripts/seamless_setup.sh; then
            print_error "Missing generate_api_key function in seamless setup"
            issues_found=true
        fi
        
        if ! grep -q "generate_jwt_secret" scripts/seamless_setup.sh; then
            print_error "Missing generate_jwt_secret function in seamless setup"
            issues_found=true
        fi
        
        if ! grep -q "generate_db_password" scripts/seamless_setup.sh; then
            print_error "Missing generate_db_password function in seamless setup"
            issues_found=true
        fi
        
        # Check for OpenSSL usage
        if ! grep -q "openssl rand" scripts/seamless_setup.sh; then
            print_error "Missing OpenSSL random generation in seamless setup"
            issues_found=true
        fi
        
        if [ "$issues_found" = false ]; then
            print_success "Seamless setup uses secure password generation"
        fi
    else
        print_error "Seamless setup script not found: scripts/seamless_setup.sh"
    fi
    
    return 0
}

# Function to check for credentials backup
check_credentials_backup() {
    print_step "7" "Checking credentials backup..."
    
    local backup_files=(
        "credentials_backup.enc"
        "credentials_backup.txt"
    )
    
    local found_backup=false
    
    for backup_file in "${backup_files[@]}"; do
        if [ -f "$backup_file" ]; then
            print_success "Credentials backup found: $backup_file"
            found_backup=true
            
            # Check if encrypted backup exists
            if [ "$backup_file" = "credentials_backup.enc" ]; then
                print_success "Encrypted credentials backup exists"
            fi
        fi
    done
    
    if [ "$found_backup" = false ]; then
        print_warning "No credentials backup found. Run the seamless setup script to generate one."
    fi
    
    return 0
}

# Function to generate security report
generate_security_report() {
    print_step "8" "Generating security report..."
    
    local report_file="security_audit_report_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << EOF
# Security Audit Report
Generated: $(date)

## Executive Summary
This report contains the results of a comprehensive security audit of the Ansible homelab deployment.

## Audit Results

### 1. Hardcoded Passwords
$(check_hardcoded_passwords 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

### 2. Insecure Password Generation
$(check_insecure_password_generation 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

### 3. Non-Vault Variables
$(check_non_vault_variables 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

### 4. Missing Vault Variables
$(check_missing_vault_variables 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

### 5. Vault File Encryption
$(check_vault_encryption 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

### 6. Seamless Setup Security
$(check_seamless_setup_security 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

### 7. Credentials Backup
$(check_credentials_backup 2>&1 | grep -E "(✓|✗|⚠)" || echo "Status: Unknown")

## Recommendations

1. **Immediate Actions Required:**
   - Fix any hardcoded passwords found
   - Replace insecure password generation
   - Add missing vault variables
   - Encrypt vault file if not already encrypted

2. **Security Best Practices:**
   - Always use vault variables for sensitive data
   - Use cryptographically secure password generation
   - Keep credentials backup in secure location
   - Regularly rotate passwords and secrets

3. **Monitoring:**
   - Run this audit script regularly
   - Monitor for new security issues
   - Keep dependencies updated

## Files Checked
- tasks/*.yml
- roles/*/tasks/*.yml
- roles/*/defaults/*.yml
- roles/*/vars/*.yml
- templates/*.j2
- scripts/*.sh
- group_vars/all/*.yml

## Log File
Full audit log: $LOG_FILE

EOF

    print_success "Security report generated: $report_file"
    return 0
}

# Main execution
main() {
    print_header
    
    log "Starting comprehensive security audit"
    
    check_hardcoded_passwords
    check_insecure_password_generation
    check_non_vault_variables
    check_missing_vault_variables
    check_vault_encryption
    check_seamless_setup_security
    check_credentials_backup
    generate_security_report
    
    echo ""
    print_header
    echo -e "${GREEN}🎉 Security audit completed!${NC}"
    echo ""
    echo -e "${CYAN}📋 Summary:${NC}"
    echo "• Checked for hardcoded passwords"
    echo "• Checked for insecure password generation"
    echo "• Checked for non-vault variables"
    echo "• Checked for missing vault variables"
    echo "• Checked vault file encryption"
    echo "• Checked seamless setup security"
    echo "• Checked credentials backup"
    echo "• Generated security report"
    echo ""
    echo -e "${YELLOW}📄 Files Generated:${NC}"
    echo "• Audit Log: $LOG_FILE"
    echo "• Security Report: security_audit_report_*.md"
    echo ""
    echo -e "${GREEN}✅ Security audit completed successfully!${NC}"
    
    log "Security audit completed successfully"
}

# Run main function
main "$@" 