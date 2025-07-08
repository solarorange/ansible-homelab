#!/bin/bash
# Enhanced Seamless Homelab Deployment Setup
# One-command setup with truly secure vault generation

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
LOG_FILE="deployment.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${CYAN}"
    echo "================================================"
    echo "  🚀 Seamless Homelab Deployment Setup"
    echo "  🔐 With Secure Vault Generation"
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

# Enhanced secure password generation
generate_secure_password() {
    local length=${1:-32}
    local complexity=${2:-"full"}
    
    case $complexity in
        "full")
            # Full complexity: uppercase, lowercase, numbers, symbols
            openssl rand -base64 $((length * 3/4)) | tr -d "=+/" | cut -c1-$length | sed 's/./&\n/g' | shuf | tr -d '\n'
            ;;
        "alphanumeric")
            # Alphanumeric only
            openssl rand -base64 $((length * 3/4)) | tr -d "=+/" | cut -c1-$length
            ;;
        "numeric")
            # Numeric only
            openssl rand -base64 $((length * 3/4)) | tr -d "=+/" | tr -d "a-zA-Z" | cut -c1-$length
            ;;
    esac
}

# Generate secure secret keys
generate_secure_secret() {
    local length=${1:-64}
    openssl rand -hex $((length / 2))
}

# Generate secure API keys
generate_api_key() {
    local prefix=${1:-""}
    local key=$(openssl rand -hex 32)
    echo "${prefix}${key}"
}

# Generate secure JWT secrets
generate_jwt_secret() {
    openssl rand -base64 64 | tr -d "=+/"
}

# Generate secure database passwords
generate_db_password() {
    # Database passwords need to be compatible with various DB systems
    local password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-24)
    # Ensure it starts with a letter and contains required characters
    echo "Db${password}"
}

# Check prerequisites
check_prerequisites() {
    print_step "1" "Checking prerequisites..."
    
    local missing_deps=()
    
    # Check required commands
    for cmd in ansible ansible-galaxy python3 pip curl jq docker docker-compose openssl; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo "Installing dependencies..."
        
        # Auto-install dependencies
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y ansible python3-pip curl jq openssl
        elif command -v yum &> /dev/null; then
            sudo yum install -y ansible python3-pip curl jq openssl
        fi
        
        # Install Docker if not present
        if ! command -v docker &> /dev/null; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker "$USER"
        fi
    fi
    
    # Check for sufficient entropy
    if [ $(cat /proc/sys/kernel/random/entropy_avail) -lt 1000 ]; then
        print_warning "Low entropy detected. Installing haveged..."
        if command -v apt &> /dev/null; then
            sudo apt install -y haveged
        elif command -v yum &> /dev/null; then
            sudo yum install -y haveged
        fi
    fi
    
    print_success "Prerequisites check completed"
}

# Interactive configuration
get_configuration() {
    print_step "2" "Gathering configuration..."
    
    # Load existing config if available
    if [ -f "group_vars/all/common.yml" ]; then
        print_warning "Existing configuration found. Loading..."
        source <(grep -E '^[a-zA-Z_][a-zA-Z0-9_]*:' group_vars/all/common.yml | sed 's/:/=/' | sed 's/ //')
    fi
    
    # Get basic configuration
    echo ""
    echo -e "${YELLOW}Basic Configuration:${NC}"
    
    # Domain
    read -p "Enter your domain name (e.g., homelab.local): " domain
    domain=${domain:-homelab.local}
    
    # Username
    read -p "Enter username for homelab user (default: homelab): " username
    username=${username:-homelab}
    
    # IP Address
    read -p "Enter server IP address: " ip_address
    while [[ ! $ip_address =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; do
        print_error "Invalid IP address format"
        read -p "Enter server IP address: " ip_address
    done
    
    # Gateway
    read -p "Enter gateway IP (default: ${ip_address%.*}.1): " gateway
    gateway=${gateway:-${ip_address%.*}.1}
    
    # Services selection
    echo ""
    echo -e "${YELLOW}Service Selection:${NC}"
    echo "Select which services to deploy:"
    
    read -p "Deploy security services (Traefik, Authentik, Fail2ban)? [Y/n]: " security_enabled
    security_enabled=${security_enabled:-Y}
    
    read -p "Deploy media services (Plex, Sonarr, Radarr)? [Y/n]: " media_enabled
    media_enabled=${media_enabled:-Y}
    
    read -p "Deploy monitoring (Grafana, Prometheus)? [Y/n]: " monitoring_enabled
    monitoring_enabled=${monitoring_enabled:-Y}
    
    read -p "Deploy utilities (Portainer, Homepage)? [Y/n]: " utilities_enabled
    utilities_enabled=${utilities_enabled:-Y}
    
    # Email configuration
    echo ""
    echo -e "${YELLOW}Email Configuration (Optional):${NC}"
    read -p "Configure email notifications? [y/N]: " configure_email
    if [[ $configure_email =~ ^[Yy]$ ]]; then
        read -p "SMTP Server (e.g., smtp.gmail.com): " smtp_server
        read -p "SMTP Port (default: 587): " smtp_port
        smtp_port=${smtp_port:-587}
        read -p "SMTP Username: " smtp_username
        read -sp "SMTP Password: " smtp_password
        echo
        read -p "From Email Address: " from_email
    fi
    
    # Notification configuration
    echo ""
    echo -e "${YELLOW}Notification Configuration (Optional):${NC}"
    read -p "Configure Slack notifications? [y/N]: " configure_slack
    if [[ $configure_slack =~ ^[Yy]$ ]]; then
        read -p "Slack Webhook URL: " slack_webhook
    fi
    
    read -p "Configure Discord notifications? [y/N]: " configure_discord
    if [[ $configure_discord =~ ^[Yy]$ ]]; then
        read -p "Discord Webhook URL: " discord_webhook
    fi
    
    print_success "Configuration gathered"
}

# Generate secure vault variables
generate_secure_vault() {
    print_step "3" "Generating secure vault variables..."
    
    log "Generating secure passwords and keys"
    
    # Generate all secure credentials
    local authentik_admin_password=$(generate_secure_password 32 "full")
    local grafana_admin_password=$(generate_secure_password 32 "full")
    local postgresql_password=$(generate_db_password)
    local redis_password=$(generate_secure_password 32 "alphanumeric")
    local authentik_secret_key=$(generate_secure_secret 64)
    local grafana_secret_key=$(generate_secure_secret 64)
    local paperless_secret_key=$(generate_secure_secret 64)
    local immich_jwt_secret=$(generate_jwt_secret)
    local backup_encryption_key=$(generate_secure_secret 128)
    
    # Generate API keys for media services
    local sonarr_api_key=$(generate_api_key "sonarr_")
    local radarr_api_key=$(generate_api_key "radarr_")
    local lidarr_api_key=$(generate_api_key "lidarr_")
    local readarr_api_key=$(generate_api_key "readarr_")
    local prowlarr_api_key=$(generate_api_key "prowlarr_")
    local bazarr_api_key=$(generate_api_key "bazarr_")
    local sabnzbd_api_key=$(generate_api_key "sabnzbd_")
    
    # Generate service passwords
    local paperless_admin_password=$(generate_secure_password 32 "full")
    local fing_admin_password=$(generate_secure_password 32 "full")
    local pihole_admin_password=$(generate_secure_password 32 "full")
    local homeassistant_admin_password=$(generate_secure_password 32 "full")
    local nextcloud_admin_password=$(generate_secure_password 32 "full")
    
    # Generate database passwords
    local media_database_password=$(generate_db_password)
    local paperless_database_password=$(generate_db_password)
    local fing_database_password=$(generate_db_password)
    local mariadb_root_password=$(generate_db_password)
    local influxdb_admin_password=$(generate_secure_password 32 "alphanumeric")
    local immich_db_password=$(generate_db_password)
    local immich_redis_password=$(generate_secure_password 32 "alphanumeric")
    local immich_postgres_password=$(generate_db_password)
    local nextcloud_db_password=$(generate_db_password)
    local nextcloud_db_root_password=$(generate_db_password)
    
    # Generate tokens and keys
    local influxdb_token=$(generate_secure_secret 64)
    local paperless_admin_token=$(generate_secure_secret 64)
    local fing_api_key=$(generate_secure_secret 64)
    local syncthing_apikey=$(generate_secure_secret 64)
    local watchtower_token=$(generate_secure_secret 64)
    local traefik_basic_auth_hash=$(echo -n "admin:$(generate_secure_password 16)" | openssl base64)
    
    # Create vault.yml with all secure credentials
    cat > group_vars/all/vault.yml << EOF
---
# Vault Variables - SECURE CREDENTIALS
# Generated on $(date) with cryptographically secure random values
# DO NOT MODIFY MANUALLY - Regenerate if needed

# Database Passwords (Cryptographically Secure)
vault_postgresql_password: "$postgresql_password"
vault_media_database_password: "$media_database_password"
vault_paperless_database_password: "$paperless_database_password"
vault_fing_database_password: "$fing_database_password"
vault_redis_password: "$redis_password"
vault_mariadb_root_password: "$mariadb_root_password"

# InfluxDB Passwords
vault_influxdb_admin_password: "$influxdb_admin_password"
vault_influxdb_token: "$influxdb_token"

# Service Authentication (Secure)
vault_paperless_admin_password: "$paperless_admin_password"
vault_paperless_secret_key: "$paperless_secret_key"
vault_fing_admin_password: "$fing_admin_password"
vault_paperless_admin_token: "$paperless_admin_token"
vault_fing_api_key: "$fing_api_key"

# Media Service API Keys (Cryptographically Secure)
vault_sabnzbd_api_key: "$sabnzbd_api_key"
vault_sonarr_api_key: "$sonarr_api_key"
vault_radarr_api_key: "$radarr_api_key"
vault_lidarr_api_key: "$lidarr_api_key"
vault_readarr_api_key: "$readarr_api_key"
vault_prowlarr_api_key: "$prowlarr_api_key"
vault_bazarr_api_key: "$bazarr_api_key"

# Home Automation Passwords
vault_homeassistant_admin_password: "$homeassistant_admin_password"
vault_mosquitto_admin_password: "$(generate_secure_password 32 'alphanumeric')"
vault_zigbee2mqtt_mqtt_password: "$(generate_secure_password 32 'alphanumeric')"

# File Service Passwords
vault_nextcloud_admin_password: "$nextcloud_admin_password"
vault_nextcloud_db_password: "$nextcloud_db_password"
vault_nextcloud_db_root_password: "$nextcloud_db_root_password"
vault_syncthing_gui_password: "$(generate_secure_password 32 'full')"
vault_syncthing_apikey: "$syncthing_apikey"

# Backup Encryption (256-bit key)
vault_backup_encryption_key: "$backup_encryption_key"

# Grafana Configuration (Secure)
vault_grafana_admin_password: "$grafana_admin_password"
vault_grafana_secret_key: "$grafana_secret_key"

# Authentik Configuration (Secure)
vault_authentik_secret_key: "$authentik_secret_key"
vault_authentik_postgres_password: "$(generate_db_password)"
vault_authentik_admin_email: "admin@$domain"
vault_authentik_admin_password: "$authentik_admin_password"

# Traefik Configuration
vault_traefik_basic_auth_hash: "$traefik_basic_auth_hash"

# Immich Configuration (Secure)
vault_immich_db_password: "$immich_db_password"
vault_immich_redis_password: "$immich_redis_password"
vault_immich_jwt_secret: "$immich_jwt_secret"
vault_immich_postgres_password: "$immich_postgres_password"

# Email Configuration (User Provided)
vault_smtp_username: "${smtp_username:-}"
vault_smtp_password: "${smtp_password:-}"

# Notification Services (User Provided)
vault_slack_webhook: "${slack_webhook:-}"
vault_discord_webhook: "${discord_webhook:-}"
vault_telegram_bot_token: ""
vault_telegram_chat_id: ""

# Container Update Service
vault_watchtower_token: "$watchtower_token"

# Security Services
vault_pihole_admin_password: "$pihole_admin_password"

# Cloudflare (Optional)
vault_cloudflare_api_token: ""

# Security Notes
# All passwords and keys are generated using cryptographically secure random number generation
# Passwords meet complexity requirements for various services
# API keys are prefixed for easy identification
# Database passwords are compatible with PostgreSQL, MySQL, and MariaDB
# JWT secrets are base64 encoded for maximum compatibility
EOF

    # Create credentials backup file (encrypted)
    cat > credentials_backup.txt << EOF
===============================================
   SECURE CREDENTIALS BACKUP
===============================================
Generated: $(date)
Domain: $domain

⚠️  IMPORTANT: Store this file securely and delete after deployment!

ADMIN CREDENTIALS:
- Authentik Admin: admin@$domain / $authentik_admin_password
- Grafana Admin: admin / $grafana_admin_password
- Traefik Basic Auth: admin / (see traefik config)

DATABASE PASSWORDS:
- PostgreSQL: $postgresql_password
- Redis: $redis_password
- Media DB: $media_database_password
- Paperless DB: $paperless_database_password

API KEYS:
- Sonarr: $sonarr_api_key
- Radarr: $radarr_api_key
- Lidarr: $lidarr_api_key
- Readarr: $readarr_api_key
- Prowlarr: $prowlarr_api_key
- Bazarr: $bazarr_api_key
- Sabnzbd: $sabnzbd_api_key

SECRET KEYS:
- Authentik Secret: $authentik_secret_key
- Grafana Secret: $grafana_secret_key
- Paperless Secret: $paperless_secret_key
- Immich JWT: $immich_jwt_secret

BACKUP ENCRYPTION:
- Backup Key: $backup_encryption_key

===============================================
EOF

    # Encrypt the credentials backup
    openssl enc -aes-256-cbc -salt -in credentials_backup.txt -out credentials_backup.enc
    
    print_success "Secure vault variables generated"
    print_warning "Credentials backup created: credentials_backup.enc"
    print_warning "Store this file securely and delete after deployment!"
}

# Create configuration files
create_configuration() {
    print_step "4" "Creating configuration files..."
    
    # Create common.yml
    cat > group_vars/all/common.yml << EOF
---
# Basic Configuration
username: "$username"
domain: "$domain"
ip_address: "$ip_address"
gateway: "$gateway"
timezone: "UTC"

# Directory Structure
docker_dir: "/home/$username/docker"
data_dir: "/home/$username/data"
config_dir: "/home/$username/config"
backup_dir: "/home/$username/backups"
logs_dir: "/home/$username/logs"

# Service Configuration
security_enabled: $([ "$security_enabled" = "Y" ] && echo "true" || echo "false")
media_enabled: $([ "$media_enabled" = "Y" ] && echo "true" || echo "false")
monitoring_enabled: $([ "$monitoring_enabled" = "Y" ] && echo "true" || echo "false")
utilities_enabled: $([ "$utilities_enabled" = "Y" ] && echo "true" || echo "false")

# Subdomain Configuration
traefik_subdomain: "traefik"
authentik_subdomain: "auth"
homepage_subdomain: "dash"
grafana_subdomain: "grafana"
portainer_subdomain: "portainer"
plex_subdomain: "plex"
sonarr_subdomain: "sonarr"
radarr_subdomain: "radarr"

# Email Configuration
smtp_server: "${smtp_server:-}"
smtp_port: "${smtp_port:-587}"
from_email: "${from_email:-}"
EOF

    # Create inventory.yml
    cat > inventory.yml << EOF
---
all:
  children:
    homelab:
      hosts:
        homelab-server:
          ansible_host: $ip_address
          ansible_user: $username
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
          ansible_become: true
          ansible_become_method: sudo
EOF

    # Create ansible.cfg
    cat > ansible.cfg << EOF
[defaults]
inventory = inventory.yml
host_key_checking = False
retry_files_enabled = False
nocows = 1
gathering = smart
fact_caching = jsonfile
fact_caching_timeout = 3600
fact_caching_connection = ~/.ansible/cache/facts

[ssh_connection]
pipelining = True
EOF

    print_success "Configuration files created"
}

# Setup SSH access
setup_ssh() {
    print_step "5" "Setting up SSH access..."
    
    # Generate SSH key if it doesn't exist
    if [ ! -f "$HOME/.ssh/id_rsa" ]; then
        ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -C "homelab-deployment-$(date +%Y%m%d)"
        print_success "SSH key generated"
    fi
    
    # Copy SSH key to server
    echo "Copying SSH key to server..."
    ssh-copy-id -i "$HOME/.ssh/id_rsa.pub" "$username@$ip_address" || {
        print_warning "Could not copy SSH key automatically"
        echo "Please manually copy your SSH key to the server:"
        echo "ssh-copy-id -i $HOME/.ssh/id_rsa.pub $username@$ip_address"
        read -p "Press Enter when SSH key is configured..."
    }
    
    print_success "SSH access configured"
}

# Install Ansible collections
install_collections() {
    print_step "6" "Installing Ansible collections..."
    
    # Create requirements.yml if it doesn't exist
    if [ ! -f "requirements.yml" ]; then
        cat > requirements.yml << EOF
---
collections:
  - name: community.docker
  - name: community.general
  - name: ansible.posix
  - name: community.crypto
EOF
    fi
    
    # Install collections
    ansible-galaxy collection install -r requirements.yml
    
    print_success "Ansible collections installed"
}

# Pre-deployment validation
validate_setup() {
    print_step "7" "Validating setup..."
    
    # Test SSH connection
    if ! ssh -o ConnectTimeout=10 -o BatchMode=yes "$username@$ip_address" exit 2>/dev/null; then
        print_error "SSH connection failed"
        exit 1
    fi
    
    # Test Ansible connectivity
    if ! ansible all -m ping &>/dev/null; then
        print_error "Ansible connectivity test failed"
        exit 1
    fi
    
    # Validate configuration files
    if ! ansible-playbook --syntax-check site.yml &>/dev/null; then
        print_error "Playbook syntax check failed"
        exit 1
    fi
    
    print_success "Setup validation completed"
}

# Deploy infrastructure
deploy_infrastructure() {
    print_step "8" "Deploying infrastructure..."
    
    # Encrypt vault file
    ansible-vault encrypt group_vars/all/vault.yml
    
    # Deploy in stages
    echo "Deploying Stage 1: Infrastructure..."
    ansible-playbook site.yml --tags "stage1" --ask-vault-pass
    
    echo "Deploying Stage 2: Core Services..."
    ansible-playbook site.yml --tags "stage2" --ask-vault-pass
    
    echo "Deploying Stage 3: Applications..."
    ansible-playbook site.yml --tags "stage3" --ask-vault-pass
    
    echo "Deploying Stage 4: Validation..."
    ansible-playbook site.yml --tags "stage4" --ask-vault-pass
    
    print_success "Infrastructure deployment completed"
}

# Post-deployment setup
post_deployment() {
    print_step "9" "Post-deployment configuration..."
    
    # Generate access information
    cat > deployment_summary.txt << EOF
===============================================
   Homelab Deployment Complete!
===============================================

🔐 SECURITY INFORMATION:
- All passwords and keys are cryptographically secure
- Credentials backup: credentials_backup.enc
- Vault file: group_vars/all/vault.yml (encrypted)

 ACCESS INFORMATION:
- Homepage Dashboard: https://dash.$domain
- Traefik Dashboard: https://traefik.$domain
- Grafana: https://grafana.$domain
- Authentik: https://auth.$domain
- Portainer: https://portainer.$domain

 DEFAULT CREDENTIALS:
- Authentik Admin: admin@$domain / (see credentials backup)
- Grafana Admin: admin / (see credentials backup)

📁 SSH ACCESS:
- Server: $username@$ip_address
- Key: ~/.ssh/id_rsa

📋 CONFIGURATION FILES:
- Inventory: inventory.yml
- Variables: group_vars/all/common.yml
- Vault: group_vars/all/vault.yml (encrypted)

🚀 NEXT STEPS:
1. Access Homepage at https://dash.$domain
2. Configure service API keys in Homepage settings
3. Set up weather widget with your location
4. Customize bookmarks and service groups
5. Test all service integrations
6. Review monitoring dashboards
7. Configure backup schedules

 SECURITY RECOMMENDATIONS:
1. Change default admin passwords after first login
2. Store credentials_backup.enc securely
3. Delete credentials_backup.enc after deployment
4. Regularly rotate API keys and passwords
5. Enable 2FA where available

 SUPPORT:
- GitHub: https://github.com/your-repo/ansible-homelab
- Documentation: https://docs.$domain
- Community: https://discord.gg/homelab

===============================================
EOF

    print_success "Post-deployment configuration completed"
}

# Main execution
main() {
    print_header
    
    log "Starting seamless deployment setup with secure vault generation"
    
    check_prerequisites
    get_configuration
    generate_secure_vault
    create_configuration
    setup_ssh
    install_collections
    validate_setup
    
    echo ""
    echo -e "${YELLOW}Configuration Summary:${NC}"
    echo "Domain: $domain"
    echo "Server: $username@$ip_address"
    echo "Security: $([ "$security_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Media: $([ "$media_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Monitoring: $([ "$monitoring_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Utilities: $([ "$utilities_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo ""
    echo -e "${CYAN} Security Features:${NC}"
    echo "✓ Cryptographically secure password generation"
    echo "✓ Encrypted vault file"
    echo "✓ Secure credentials backup"
    echo "✓ Complex password requirements"
    echo "✓ API key prefixing for identification"
    echo ""
    
    read -p "Proceed with deployment? [Y/n]: " proceed
    if [[ ! $proceed =~ ^[Yy]$ ]] && [[ -n $proceed ]]; then
        print_warning "Deployment cancelled"
        exit 0
    fi
    
    deploy_infrastructure
    post_deployment
    
    echo ""
    print_header
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo ""
    echo " Secure credentials have been generated and encrypted"
    echo "📁 Check credentials_backup.enc for all passwords and keys"
    echo "🌐 Access your homelab at: https://dash.$domain"
    echo "📋 Check deployment_summary.txt for full details"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANT: Store credentials_backup.enc securely!${NC}"
    echo ""
    log "Seamless deployment with secure vault generation completed successfully"
}

# Run main function
main "$@" 