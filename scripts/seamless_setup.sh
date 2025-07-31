#!/bin/bash
# Seamless Homelab Deployment Setup - PRIMARY SETUP SCRIPT
# Complete turnkey deployment with automatic variable handling
# This is the one and only comprehensive setup script for homelab deployment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
LOG_FILE="seamless_deployment.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${CYAN}"
    echo "================================================"
    echo "  🚀 Seamless Homelab Deployment"
    echo "  🔐 Complete Turnkey & Automatic Setup"
    echo "  📋 PRIMARY SETUP SCRIPT - No other setup needed"
    echo "  🔧 INCLUDES SERVER PREPARATION - Stock Ubuntu to Homelab"
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

# Secure password generation
generate_secure_password() {
    local length=${1:-32}
    local complexity=${2:-"full"}
    
    case $complexity in
        "full")
            openssl rand -base64 $((length * 3/4)) | tr -d "=+/" | cut -c1-$length | sed 's/./&\n/g' | shuf | tr -d '\n'
            ;;
        "alphanumeric")
            openssl rand -base64 $((length * 3/4)) | tr -d "=+/" | cut -c1-$length
            ;;
        "numeric")
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
    local password=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-24)
    echo "Db${password}"
}

# Check prerequisites and offer server preparation
check_prerequisites() {
    print_step "1" "Checking prerequisites and server preparation..."
    
    # Check if we're on Ubuntu and if server preparation is needed
    if [[ -f /etc/os-release ]] && grep -q "Ubuntu" /etc/os-release; then
        echo ""
        echo -e "${CYAN}🔍 Server Preparation Check${NC}"
        
        # Check if Docker is installed
        if ! command -v docker &> /dev/null; then
            print_warning "Docker not found - server preparation needed"
            echo ""
            echo -e "${YELLOW}Server Preparation Required:${NC}"
            echo "This appears to be a stock Ubuntu installation that needs server preparation."
            echo "The seamless setup can automatically prepare your server for homelab deployment."
            echo ""
            read -p "Run server preparation automation? [Y/n]: " run_server_prep
            run_server_prep=${run_server_prep:-Y}
            
            if [[ $run_server_prep =~ ^[Yy]$ ]]; then
                print_step "1.1" "Running server preparation automation..."
                
                # Check if running as root
                if [[ $EUID -ne 0 ]]; then
                    print_error "Server preparation requires root access"
                    echo "Please run: sudo $0"
                    exit 1
                fi
                
                # Run server preparation
                if [ -f "scripts/server_preparation.sh" ]; then
                    echo "Executing server preparation script..."
                    ./scripts/server_preparation.sh
                    
                    # After server prep, reload environment
                    source ~/.bashrc 2>/dev/null || true
                    
                    print_success "Server preparation completed"
                    echo ""
                    echo -e "${GREEN}✅ Server is now ready for homelab deployment!${NC}"
                    echo ""
                else
                    print_error "Server preparation script not found"
                    echo "Please ensure scripts/server_preparation.sh exists"
                    exit 1
                fi
            else
                print_warning "Server preparation skipped"
                echo "Please ensure your server has:"
                echo "- Docker installed and running"
                echo "- Ansible installed"
                echo "- SSH keys configured"
                echo "- Static IP configured"
                echo "- Firewall configured"
                echo ""
                read -p "Continue with deployment? [y/N]: " continue_anyway
                if [[ ! $continue_anyway =~ ^[Yy]$ ]]; then
                    exit 1
                fi
            fi
        else
            print_success "Docker found - server appears to be prepared"
        fi
    else
        print_warning "Not running on Ubuntu - server preparation not available"
        echo "Server preparation is currently only available for Ubuntu systems"
    fi
    
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
    if [ -f /proc/sys/kernel/random/entropy_avail ] && [ $(cat /proc/sys/kernel/random/entropy_avail) -lt 1000 ]; then
        print_warning "Low entropy detected. Installing haveged..."
        if command -v apt &> /dev/null; then
            sudo apt install -y haveged
        elif command -v yum &> /dev/null; then
            sudo yum install -y haveged
        fi
    fi
    
    print_success "Prerequisites check completed"
}

# Interactive configuration with comprehensive variable handling
get_configuration() {
    print_step "2" "Gathering comprehensive configuration..."
    
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
    
    # Admin Email
    read -p "Enter admin email address (default: admin@$domain): " admin_email
    admin_email=${admin_email:-admin@$domain}
    
    # Timezone
    read -p "Enter timezone (default: America/New_York): " timezone
    timezone=${timezone:-America/New_York}
    
    # PUID/PGID
    read -p "Enter PUID (default: 1000): " puid
    puid=${puid:-1000}
    read -p "Enter PGID (default: 1000): " pgid
    pgid=${pgid:-1000}
    
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
    
    read -p "Deploy productivity services (Linkwarden, Paperless)? [Y/n]: " productivity_enabled
    productivity_enabled=${productivity_enabled:-Y}
    
    read -p "Deploy automation services (n8n, Node-RED)? [Y/n]: " automation_enabled
    automation_enabled=${automation_enabled:-Y}
    
    # Cloudflare Configuration
    echo ""
    echo -e "${YELLOW}Cloudflare Configuration (Optional but recommended for SSL):${NC}"
    read -p "Enable Cloudflare integration? [Y/n]: " cloudflare_enabled
    cloudflare_enabled=${cloudflare_enabled:-Y}
    
    if [[ $cloudflare_enabled =~ ^[Yy]$ ]]; then
        read -p "Cloudflare Email: " cloudflare_email
        read -sp "Cloudflare API Token: " cloudflare_api_token
        echo
        
        # Offer DNS automation
        echo ""
        echo -e "${CYAN}DNS Automation (Optional):${NC}"
        read -p "Automatically create all DNS records using Cloudflare API? [Y/n]: " dns_automation
        dns_automation=${dns_automation:-Y}
        
        if [[ $dns_automation =~ ^[Yy]$ ]]; then
            echo ""
            echo -e "${GREEN}🎉 DNS Automation Enabled!${NC}"
            echo "The setup will automatically create all required DNS records:"
            echo "• Root domain (@) → $ip_address"
            echo "• 40+ subdomains → $ip_address"
            echo "• Automatic validation after creation"
            echo ""
            echo -e "${YELLOW}Required Cloudflare API Permissions:${NC}"
            echo "• Zone:Zone:Read"
            echo "• Zone:DNS:Edit"
            echo "• Zone:Zone Settings:Edit"
            echo ""
        else
            echo ""
            echo -e "${YELLOW}Manual DNS Setup Required${NC}"
            echo "You'll need to manually create these DNS records:"
            echo "• Root domain (@) → $ip_address"
            echo "• 40+ subdomains → $ip_address"
            echo ""
            echo -e "${CYAN}Quick DNS Setup Commands:${NC}"
            echo "You can run this after setup to create DNS records:"
            echo "python3 scripts/automate_dns_setup.py \\"
            echo "  --domain $domain \\"
            echo "  --server-ip $ip_address \\"
            echo "  --cloudflare-email $cloudflare_email \\"
            echo "  --cloudflare-api-token YOUR_API_TOKEN"
            echo ""
        fi
    fi
    
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
    
    read -p "Configure Telegram notifications? [y/N]: " configure_telegram
    if [[ $configure_telegram =~ ^[Yy]$ ]]; then
        read -p "Telegram Bot Token: " telegram_bot_token
        read -p "Telegram Chat ID: " telegram_chat_id
    fi
    
    # DNS Configuration
    echo ""
    echo -e "${YELLOW}DNS Configuration:${NC}"
    read -p "Primary DNS server (default: 8.8.8.8): " primary_dns
    primary_dns=${primary_dns:-8.8.8.8}
    read -p "Secondary DNS server (default: 8.8.4.4): " secondary_dns
    secondary_dns=${secondary_dns:-8.8.4.4}
    
    # Docker Configuration
    echo ""
    echo -e "${YELLOW}Docker Configuration:${NC}"
    read -p "Docker root directory (default: /opt/docker): " docker_root
    docker_root=${docker_root:-/opt/docker}
    
    # Network Configuration
    echo ""
    echo -e "${YELLOW}Network Configuration:${NC}"
    read -p "Internal subnet (default: 192.168.1.0/24): " internal_subnet
    internal_subnet=${internal_subnet:-192.168.1.0/24}
    
    # Backup Configuration
    echo ""
    echo -e "${YELLOW}Backup Configuration:${NC}"
    read -p "Backup retention days (default: 7): " backup_retention_days
    backup_retention_days=${backup_retention_days:-7}
    read -p "Enable backup compression? [Y/n]: " backup_compression
    backup_compression=${backup_compression:-Y}
    read -p "Enable backup encryption? [Y/n]: " backup_encryption
    backup_encryption=${backup_encryption:-Y}
    
    # Monitoring Configuration
    echo ""
    echo -e "${YELLOW}Monitoring Configuration:${NC}"
    read -p "Monitoring data retention days (default: 30): " monitoring_retention_days
    monitoring_retention_days=${monitoring_retention_days:-30}
    read -p "Enable alerting? [Y/n]: " alerting_enabled
    alerting_enabled=${alerting_enabled:-Y}
    
    # Security Configuration
    echo ""
    echo -e "${YELLOW}Security Configuration:${NC}"
    read -p "Enable enhanced security? [Y/n]: " security_enhanced
    security_enhanced=${security_enhanced:-Y}
    read -p "Enable Fail2ban? [Y/n]: " fail2ban_enabled
    fail2ban_enabled=${fail2ban_enabled:-Y}
    read -p "Enable CrowdSec? [Y/n]: " crowdsec_enabled
    crowdsec_enabled=${crowdsec_enabled:-Y}
    read -p "Enable SSL/TLS? [Y/n]: " ssl_enabled
    ssl_enabled=${ssl_enabled:-Y}
    
    # System Configuration
    echo ""
    echo -e "${YELLOW}System Configuration:${NC}"
    read -p "Enable automatic system updates? [Y/n]: " system_updates_enabled
    system_updates_enabled=${system_updates_enabled:-Y}
    read -p "Log retention days (default: 30): " log_retention_days
    log_retention_days=${log_retention_days:-30}
    
    # Resource Limits
    echo ""
    echo -e "${YELLOW}Resource Limits:${NC}"
    read -p "Default CPU limit (default: 2.0): " default_cpu_limit
    default_cpu_limit=${default_cpu_limit:-2.0}
    read -p "Default memory limit (default: 2g): " default_memory_limit
    default_memory_limit=${default_memory_limit:-2g}
    
    print_success "Configuration gathered"
} 

# Execute DNS automation if enabled
execute_dns_automation() {
    if [[ $cloudflare_enabled =~ ^[Yy]$ ]] && [[ $dns_automation =~ ^[Yy]$ ]]; then
        print_step "3.5" "Automating DNS record creation..."
        
        echo ""
        echo -e "${CYAN}🔧 Creating DNS records via Cloudflare API...${NC}"
        
        # Install required Python packages
        if ! python3 -c "import requests" 2>/dev/null; then
            echo "Installing required Python packages..."
            pip3 install requests
        fi
        
        # Execute DNS automation
        if python3 scripts/automate_dns_setup.py \
            --domain "$domain" \
            --server-ip "$ip_address" \
            --cloudflare-email "$cloudflare_email" \
            --cloudflare-api-token "$cloudflare_api_token"; then
            print_success "DNS automation completed successfully"
        else
            print_warning "DNS automation failed - you may need to create records manually"
            echo ""
            echo -e "${YELLOW}Manual DNS Setup Required:${NC}"
            echo "Please create these DNS records in Cloudflare:"
            echo "• @ → $ip_address"
            echo "• traefik → $ip_address"
            echo "• auth → $ip_address"
            echo "• grafana → $ip_address"
            echo "• dash → $ip_address"
            echo "• (and 35+ more subdomains)"
            echo ""
            read -p "Press Enter when DNS records are created..."
        fi
    else
        print_warning "DNS automation skipped - manual setup required"
        echo ""
        echo -e "${YELLOW}Manual DNS Setup Required:${NC}"
        echo "Please create these DNS records in Cloudflare:"
        echo "• @ → $ip_address"
        echo "• traefik → $ip_address"
        echo "• auth → $ip_address"
        echo "• grafana → $ip_address"
        echo "• dash → $ip_address"
        echo "• (and 35+ more subdomains)"
        echo ""
        echo -e "${CYAN}Or run DNS automation later:${NC}"
        echo "python3 scripts/automate_dns_setup.py \\"
        echo "  --domain $domain \\"
        echo "  --server-ip $ip_address \\"
        echo "  --cloudflare-email $cloudflare_email \\"
        echo "  --cloudflare-api-token YOUR_API_TOKEN"
        echo ""
        read -p "Press Enter when DNS records are created..."
    fi
}

# Generate secure vault variables with comprehensive coverage
generate_secure_vault() {
    print_step "3" "Generating comprehensive secure vault variables..."
    
    log "Generating secure passwords and keys for all services"
    
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
    local ersatztv_api_key=$(generate_api_key "ersatztv_")
    local tautulli_api_key=$(generate_api_key "tautulli_")
    local overseerr_api_key=$(generate_api_key "overseerr_")
    local jellyfin_api_key=$(generate_api_key "jellyfin_")
    local emby_api_key=$(generate_api_key "emby_")
    
    # Generate service passwords
    local paperless_admin_password=$(generate_secure_password 32 "full")
    local fing_admin_password=$(generate_secure_password 32 "full")
    local pihole_admin_password=$(generate_secure_password 32 "full")
    local homeassistant_admin_password=$(generate_secure_password 32 "full")
    local nextcloud_admin_password=$(generate_secure_password 32 "full")
    local gitlab_root_password=$(generate_secure_password 32 "full")
    local portainer_admin_password=$(generate_secure_password 32 "full")
    local vaultwarden_admin_password=$(generate_secure_password 32 "full")
    local homepage_admin_password=$(generate_secure_password 32 "full")
    
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
    local linkwarden_postgres_password=$(generate_db_password)
    local linkwarden_nextauth_secret=$(generate_secure_secret 64)
    local n8n_postgres_password=$(generate_db_password)
    local pezzo_postgres_password=$(generate_db_password)
    local pezzo_redis_password=$(generate_secure_password 32 "alphanumeric")
    local pezzo_clickhouse_password=$(generate_secure_password 32 "alphanumeric")
    
    # Generate tokens and keys
    local influxdb_token=$(generate_secure_secret 64)
    local paperless_admin_token=$(generate_secure_secret 64)
    local fing_api_key=$(generate_secure_secret 64)
    local syncthing_apikey=$(generate_secure_secret 64)
    local watchtower_token=$(generate_secure_secret 64)
    local traefik_basic_auth_hash=$(echo -n "admin:$(generate_secure_password 16)" | openssl base64)
    local reconya_admin_password=$(generate_secure_password 32 "full")
    local reconya_jwt_secret=$(generate_secure_secret 64)
    local n8n_encryption_key=$(generate_secure_secret 64)
    local n8n_admin_password=$(generate_secure_password 32 "full")
    
    # Generate Lidarr specific credentials
    local lidarr_username="admin"
    local lidarr_password=$(generate_secure_password 32 "full")
    local lidarr_anonymous_id=$(generate_secure_secret 32)
    local qbittorrent_password=$(generate_secure_password 32 "alphanumeric")
    
    # Generate Homepage API keys (ALL missing ones)
    local homepage_api_key=$(generate_secure_secret 64)
    local traefik_api_key=$(generate_secure_secret 64)
    local authentik_api_key=$(generate_secure_secret 64)
    local portainer_api_key=$(generate_secure_secret 64)
    local grafana_api_key=$(generate_secure_secret 64)
    local readarr_api_key=$(generate_secure_secret 64)
    local paperless_api_key=$(generate_secure_secret 64)
    local bookstack_api_key=$(generate_secure_secret 64)
    local immich_api_key=$(generate_secure_secret 64)
    local filebrowser_api_key=$(generate_secure_secret 64)
    local minio_api_key=$(generate_secure_secret 64)
    local kopia_api_key=$(generate_secure_secret 64)
    local duplicati_api_key=$(generate_secure_secret 64)
    local uptimekuma_api_key=$(generate_secure_secret 64)
    local gitlab_api_key=$(generate_secure_secret 64)
    local harbor_api_key=$(generate_secure_secret 64)
    local guacamole_api_key=$(generate_secure_secret 64)
    local homeassistant_api_key=$(generate_secure_secret 64)
    local crowdsec_api_key=$(generate_secure_secret 64)
    local fail2ban_api_key=$(generate_secure_secret 64)
    
    # Generate additional service credentials
    local wireguard_password=$(generate_secure_password 32 "alphanumeric")
    local codeserver_password=$(generate_secure_password 32 "full")
    local vault_root_token=$(generate_secure_secret 64)
    local vault_unseal_key=$(generate_secure_secret 64)
    local openweather_api_key=$(generate_secure_secret 32)
    local kubernetes_token=$(generate_secure_secret 64)
    local google_client_secret=$(generate_secure_secret 64)
    local google_refresh_token=$(generate_secure_secret 64)
    local minio_access_key=$(generate_secure_secret 32)
    local minio_secret_key=$(generate_secure_secret 64)
    
    # Generate Vaultwarden specific credentials
    local vaultwarden_admin_token=$(generate_secure_secret 64)
    local vaultwarden_postgres_password=$(generate_db_password)
    local vaultwarden_smtp_host="${smtp_server:-}"
    local vaultwarden_smtp_port="${smtp_port:-587}"
    local vaultwarden_smtp_ssl="true"
    local vaultwarden_smtp_username="${smtp_username:-}"
    local vaultwarden_smtp_password="${smtp_password:-}"
    
    # Generate Media service additional credentials
    local qbittorrent_username="admin"
    local lastfm_username=""
    local lidarr_username="admin"
    local lidarr_anonymous_id=$(generate_secure_secret 32)
    local lidarr_password=$(generate_secure_password 32 "full")
    local plex_username="admin"
    local plex_password=$(generate_secure_password 32 "full")
    local jellyfin_username="admin"
    local jellyfin_password=$(generate_secure_password 32 "full")
    local immich_smtp_username="${smtp_username:-}"
    local plex_token=$(generate_secure_secret 64)
    local webhook_token=$(generate_secure_secret 64)
    local traefik_pilot_token=$(generate_secure_secret 64)
    local immich_mapbox_key=$(generate_secure_secret 64)
    local pagerduty_integration_key=$(generate_secure_secret 64)
    local pagerduty_routing_key=$(generate_secure_secret 64)
    local grafana_admin_user="admin"
    local influxdb_admin_user="admin"
    local influxdb_username="admin"
    local media_jwt_secret=$(generate_secure_secret 64)
    local redis_secret_key=$(generate_secure_secret 64)
    local postgresql_user="homelab"
    local calibreweb_secret_key=$(generate_secure_secret 64)
    local elasticsearch_password=$(generate_secure_password 32 "alphanumeric")
    local elasticsearch_secret_key=$(generate_secure_secret 64)
    local kibana_password=$(generate_secure_password 32 "alphanumeric")
    local vaultwarden_backup_frequency="7"
    local vaultwarden_backup_days="7"
    local vaultwarden_backup_days_attachments="7"
    local vaultwarden_backup_days_send="7"
    local vaultwarden_backup_days_org_keys="7"
    local vaultwarden_backup_days_users="7"
    local vaultwarden_backup_days_ciphers="7"
    local vaultwarden_backup_days_folders="7"
    local vaultwarden_backup_days_sends="7"
    local vaultwarden_backup_days_attachments_delete="7"
    local vaultwarden_backup_days_send_delete="7"
    local vaultwarden_backup_days_org_keys_delete="7"
    local vaultwarden_backup_days_users_delete="7"
    local vaultwarden_backup_days_ciphers_delete="7"
    local vaultwarden_backup_days_folders_delete="7"
    local vaultwarden_backup_days_sends_delete="7"
    local vaultwarden_backup_days_attachments_delete_attempts="7"
    local vaultwarden_backup_days_send_delete_attempts="7"
    local vaultwarden_backup_days_org_keys_delete_attempts="7"
    local vaultwarden_backup_days_users_delete_attempts="7"
    local vaultwarden_backup_days_ciphers_delete_attempts="7"
    local vaultwarden_backup_days_folders_delete_attempts="7"
    local vaultwarden_backup_days_sends_delete_attempts="7"
    
    # Generate missing variables found in roles
    local loki_auth_token=$(generate_secure_secret 64)
    local ersatztv_database_password=$(generate_db_password)
    local grafana_db_password=$(generate_db_password)
    local grafana_viewer_password=$(generate_secure_password 16 "alphanumeric")
    local grafana_editor_password=$(generate_secure_password 16 "alphanumeric")
    local grafana_oauth_secret=$(generate_secure_secret 64)
    local homepage_oauth_secret=$(generate_secure_secret 64)
    local homepage_api_secret=$(generate_secure_secret 64)
    local authentik_bootstrap_token=$(generate_secure_secret 64)
    local fail2ban_secret_key=$(generate_secure_secret 64)
    local postgresql_admin_password=$(generate_db_password)
    local elasticsearch_elastic_password=$(generate_secure_password 32 "alphanumeric")
    local backup_smtp_password="${smtp_password:-}"
    local pihole_database_password=$(generate_db_password)
    local ssl_cert_key=$(generate_secure_secret 64)
    local ssl_private_key=$(generate_secure_secret 64)
    local jwt_secret=$(generate_secure_secret 64)
    local encryption_key=$(generate_secure_secret 64)
    local authentik_redis_password=$(generate_secure_password 32 "alphanumeric")
    local samba_password=$(generate_secure_password 32 "alphanumeric")
    local pihole_web_password=$(generate_secure_password 32 "alphanumeric")
    local admin_password=$(generate_secure_password 32 "full")
    local db_password=$(generate_db_password)
    local paperless_ngx_admin_password=$(generate_secure_password 32 "full")
    local homepage_user_password=$(generate_secure_password 32 "full")
    local homepage_secret_key=$(generate_secure_secret 64)
    local google_client_secret=$(generate_secure_secret 64)
    
    # Generate Immich additional credentials
    local immich_admin_password=$(generate_secure_password 32 "full")
    local immich_oauth_client_secret=$(generate_secure_secret 64)
    local immich_smtp_password="${smtp_password:-}"
    local immich_push_token=$(generate_secure_secret 64)
    local immich_push_app_secret=$(generate_secure_secret 64)
    local immich_telegram_bot_token="${telegram_bot_token:-}"
    
    # Generate additional service passwords that were missing
    local calibre_web_password=$(generate_secure_password 32 "full")
    local jellyfin_password=$(generate_secure_password 32 "full")
    local sabnzbd_password=$(generate_secure_password 32 "alphanumeric")
    local audiobookshelf_password=$(generate_secure_password 32 "full")
    local authentik_postgres_password=$(generate_db_password)
    local grafana_admin_password_alt=$(generate_secure_password 32 "full")
    local influxdb_admin_password_alt=$(generate_secure_password 32 "alphanumeric")
    local nextcloud_db_password_alt=$(generate_db_password)
    local nextcloud_admin_password_alt=$(generate_secure_password 32 "full")
    local nextcloud_db_root_password_alt=$(generate_db_password)
    
    # Create vault.yml with all secure credentials
    cat > group_vars/all/vault.yml << EOF
---
# Vault Variables - SECURE CREDENTIALS
# Generated on $(date) with cryptographically secure random values
# DO NOT MODIFY MANUALLY - Regenerate if needed

# Database Passwords (Cryptographically Secure)
    vault_postgresql_password="$postgresql_password"
    vault_media_database_password="$media_database_password"
    vault_paperless_database_password="$paperless_database_password"
    vault_fing_database_password="$fing_database_password"
    vault_redis_password="$redis_password"
    vault_mariadb_root_password="$mariadb_root_password"

# InfluxDB Passwords
    vault_influxdb_admin_password="$influxdb_admin_password"
vault_influxdb_token: "$influxdb_token"

# Service Authentication (Secure)
    vault_paperless_admin_password="$paperless_admin_password"
vault_paperless_secret_key: "$paperless_secret_key"
    vault_fing_admin_password="$fing_admin_password"
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
vault_ersatztv_api_key: "$ersatztv_api_key"
vault_tautulli_api_key: "$tautulli_api_key"
vault_overseerr_api_key: "$overseerr_api_key"
vault_jellyfin_api_key: "$jellyfin_api_key"
vault_emby_api_key: "$emby_api_key"

# Lidarr Additional Configuration
vault_lidarr_username: "$lidarr_username"
vault_lidarr_password: "$lidarr_password"
vault_lidarr_anonymous_id: "$lidarr_anonymous_id"
vault_qbittorrent_password: "$qbittorrent_password"

# Home Automation Passwords
vault_homeassistant_admin_password: "$homeassistant_admin_password"
vault_mosquitto_admin_password: "$mosquitto_admin_password"
vault_zigbee2mqtt_mqtt_password: "$zigbee2mqtt_mqtt_password"

# File Service Passwords
vault_nextcloud_admin_password: "$nextcloud_admin_password"
vault_nextcloud_db_password: "$nextcloud_db_password"
vault_nextcloud_db_root_password: "$nextcloud_db_root_password"
vault_syncthing_gui_password: "$syncthing_gui_password"
vault_syncthing_apikey: "$syncthing_apikey"

# Backup Encryption (256-bit key)
vault_backup_encryption_key: "$backup_encryption_key"

# Grafana Configuration (Secure)
vault_grafana_admin_password: "$grafana_admin_password"
vault_grafana_secret_key: "$grafana_secret_key"

# Authentik Configuration (Secure)
vault_authentik_secret_key: "$authentik_secret_key"
vault_authentik_postgres_password: "$authentik_postgres_password"
vault_authentik_admin_email: "$admin_email"
vault_authentik_admin_password: "$authentik_admin_password"
vault_authentik_redis_password: "$authentik_redis_password"

# Traefik Configuration
vault_traefik_basic_auth_hash: "$traefik_basic_auth_hash"

# Immich Configuration (Secure)
vault_immich_db_password: "$immich_db_password"
vault_immich_redis_password: "$immich_redis_password"
vault_immich_jwt_secret: "$immich_jwt_secret"
vault_immich_postgres_password: "$immich_postgres_password"

# Linkwarden Configuration (Secure)
vault_linkwarden_postgres_password: "$linkwarden_postgres_password"
vault_linkwarden_nextauth_secret: "$linkwarden_nextauth_secret"

# Email Configuration (User Provided)
vault_smtp_username: "${smtp_username:-}"
vault_smtp_password: "${smtp_password:-}"

# Notification Services (User Provided)
vault_slack_webhook: "${slack_webhook:-}"
vault_discord_webhook: "${discord_webhook:-}"
vault_telegram_bot_token: "${telegram_bot_token:-}"
vault_telegram_chat_id: "${telegram_chat_id:-}"

# Container Update Service
vault_watchtower_token: "$watchtower_token"

# Security Services
vault_pihole_admin_password: "$pihole_admin_password"

# Reconya Configuration (Secure)
vault_reconya_admin_password: "$reconya_admin_password"
vault_reconya_jwt_secret: "$reconya_jwt_secret"

# n8n Configuration (Secure)
vault_n8n_admin_password: "$n8n_admin_password"
vault_n8n_encryption_key: "$n8n_encryption_key"
vault_n8n_postgres_password: "$n8n_postgres_password"

# Pezzo Configuration (Secure)
vault_pezzo_postgres_password: "$pezzo_postgres_password"
vault_pezzo_redis_password: "$pezzo_redis_password"
vault_pezzo_clickhouse_password: "$pezzo_clickhouse_password"

# Homepage API Keys (ALL missing ones)
vault_homepage_api_key: "$homepage_api_key"
vault_traefik_api_key: "$traefik_api_key"
vault_authentik_api_key: "$authentik_api_key"
vault_portainer_api_key: "$portainer_api_key"
vault_grafana_api_key: "$grafana_api_key"
vault_readarr_api_key: "$readarr_api_key"
vault_paperless_api_key: "$paperless_api_key"
vault_bookstack_api_key: "$bookstack_api_key"
vault_immich_api_key: "$immich_api_key"
vault_filebrowser_api_key: "$filebrowser_api_key"
vault_minio_api_key: "$minio_api_key"
vault_kopia_api_key: "$kopia_api_key"
vault_duplicati_api_key: "$duplicati_api_key"
vault_uptimekuma_api_key: "$uptimekuma_api_key"
vault_gitlab_api_key: "$gitlab_api_key"
vault_harbor_api_key: "$harbor_api_key"
vault_guacamole_api_key: "$guacamole_api_key"
vault_homeassistant_api_key: "$homeassistant_api_key"
vault_crowdsec_api_key: "$crowdsec_api_key"
vault_fail2ban_api_key: "$fail2ban_api_key"

# Development Services
vault_gitlab_root_password: "$gitlab_root_password"
vault_portainer_admin_password: "$portainer_admin_password"
vault_vaultwarden_admin_password: "$vaultwarden_admin_password"
vault_homepage_admin_password: "$homepage_admin_password"

# Additional Service Credentials
vault_wireguard_password: "$wireguard_password"
vault_codeserver_password: "$codeserver_password"
vault_vault_root_token: "$vault_root_token"
vault_vault_unseal_key: "$vault_unseal_key"

# External Service API Keys
vault_openweather_api_key: "$openweather_api_key"
vault_kubernetes_token: "$kubernetes_token"
vault_google_client_secret: "$google_client_secret"
vault_google_refresh_token: "$google_refresh_token"

# MinIO Configuration
vault_minio_access_key: "$minio_access_key"
vault_minio_secret_key: "$minio_secret_key"

# Vaultwarden Configuration
vault_vaultwarden_admin_token: "$vaultwarden_admin_token"
vault_vaultwarden_postgres_password: "$vaultwarden_postgres_password"
vault_vaultwarden_smtp_host: "$vaultwarden_smtp_host"
vault_vaultwarden_smtp_port: "$vaultwarden_smtp_port"
vault_vaulten_smtp_ssl: "$vaultwarden_smtp_ssl"
vault_vaultwarden_smtp_username: "$vaultwarden_smtp_username"
vault_vaultwarden_smtp_password: "$vaultwarden_smtp_password"

# Vaultwarden Backup Configuration
vault_vaultwarden_backup_frequency: "$vaultwarden_backup_frequency"
vault_vaultwarden_backup_days: "$vaultwarden_backup_days"
vault_vaultwarden_backup_days_attachments: "$vaultwarden_backup_days_attachments"
vault_vaultwarden_backup_days_send: "$vaultwarden_backup_days_send"
vault_vaultwarden_backup_days_org_keys: "$vaultwarden_backup_days_org_keys"
vault_vaultwarden_backup_days_users: "$vaultwarden_backup_days_users"
vault_vaultwarden_backup_days_ciphers: "$vaultwarden_backup_days_ciphers"
vault_vaultwarden_backup_days_folders: "$vaultwarden_backup_days_folders"
vault_vaultwarden_backup_days_sends: "$vaultwarden_backup_days_sends"
vault_vaultwarden_backup_days_attachments_delete: "$vaultwarden_backup_days_attachments_delete"
vault_vaultwarden_backup_days_send_delete: "$vaultwarden_backup_days_send_delete"
vault_vaultwarden_backup_days_org_keys_delete: "$vaultwarden_backup_days_org_keys_delete"
vault_vaultwarden_backup_days_users_delete: "$vaultwarden_backup_days_users_delete"
vault_vaultwarden_backup_days_ciphers_delete: "$vaultwarden_backup_days_ciphers_delete"
vault_vaultwarden_backup_days_folders_delete: "$vaultwarden_backup_days_folders_delete"
vault_vaultwarden_backup_days_sends_delete: "$vaultwarden_backup_days_sends_delete"
vault_vaultwarden_backup_days_attachments_delete_attempts: "$vaultwarden_backup_days_attachments_delete_attempts"
vault_vaultwarden_backup_days_send_delete_attempts: "$vaultwarden_backup_days_send_delete_attempts"
vault_vaultwarden_backup_days_org_keys_delete_attempts: "$vaultwarden_backup_days_org_keys_delete_attempts"
vault_vaultwarden_backup_days_users_delete_attempts: "$vaultwarden_backup_days_users_delete_attempts"
vault_vaultwarden_backup_days_ciphers_delete_attempts: "$vaultwarden_backup_days_ciphers_delete_attempts"
vault_vaultwarden_backup_days_folders_delete_attempts: "$vaultwarden_backup_days_folders_delete_attempts"
vault_vaultwarden_backup_days_sends_delete_attempts: "$vaultwarden_backup_days_sends_delete_attempts"

# Media Service Additional Configuration
vault_qbittorrent_username: "$qbittorrent_username"
vault_lastfm_username: "$lastfm_username"
vault_lidarr_username: "$lidarr_username"
vault_lidarr_anonymous_id: "$lidarr_anonymous_id"
vault_lidarr_password: "$lidarr_password"
vault_plex_username: "$plex_username"
vault_plex_password: "$plex_password"
vault_jellyfin_username: "$jellyfin_username"
vault_jellyfin_password: "$jellyfin_password"
vault_immich_smtp_username: "$immich_smtp_username"
vault_plex_token: "$plex_token"
vault_webhook_token: "$webhook_token"
vault_traefik_pilot_token: "$traefik_pilot_token"
vault_immich_mapbox_key: "$immich_mapbox_key"
vault_pagerduty_integration_key: "$pagerduty_integration_key"
vault_pagerduty_routing_key: "$pagerduty_routing_key"
vault_grafana_admin_user: "$grafana_admin_user"
vault_influxdb_admin_user: "$influxdb_admin_user"
vault_influxdb_username: "$influxdb_username"
vault_media_jwt_secret: "$media_jwt_secret"
vault_redis_secret_key: "$redis_secret_key"
vault_postgresql_user: "$postgresql_user"
vault_calibreweb_secret_key: "$calibreweb_secret_key"
vault_elasticsearch_password: "$elasticsearch_password"
vault_elasticsearch_secret_key: "$elasticsearch_secret_key"
vault_kibana_password: "$kibana_password"

# Logging Configuration
vault_loki_auth_token: "$loki_auth_token"

# ErsatzTV Configuration
vault_ersatztv_database_password: "$ersatztv_database_password"

# Grafana Additional Configuration
vault_grafana_db_password: "$grafana_db_password"
vault_grafana_viewer_password: "$grafana_viewer_password"
vault_grafana_editor_password: "$grafana_editor_password"
vault_grafana_oauth_secret: "$grafana_oauth_secret"

# Homepage Additional Configuration
vault_homepage_oauth_secret: "$homepage_oauth_secret"
vault_homepage_api_secret: "$homepage_api_secret"

# Authentik Additional Configuration
vault_authentik_bootstrap_token: "$authentik_bootstrap_token"

# Security Additional Configuration
vault_fail2ban_secret_key: "$fail2ban_secret_key"

# Database Additional Configuration
vault_postgresql_admin_password: "$postgresql_admin_password"
vault_elasticsearch_elastic_password: "$elasticsearch_elastic_password"

# Backup Configuration
vault_backup_smtp_password: "$backup_smtp_password"

# Immich Additional Configuration
vault_immich_admin_password: "$immich_admin_password"
vault_immich_oauth_client_secret: "$immich_oauth_client_secret"
vault_immich_smtp_password: "$immich_smtp_password"
vault_immich_push_token: "$immich_push_token"
vault_immich_push_app_secret: "$immich_push_app_secret"
vault_immich_telegram_bot_token: "$immich_telegram_bot_token"

# Cloudflare (Optional)
vault_cloudflare_api_token: "${cloudflare_api_token:-}"

# Pi-hole Configuration
vault_pihole_database_password: "$pihole_database_password"

# SSL Configuration
vault_ssl_cert_key: "$ssl_cert_key"
vault_ssl_private_key: "$ssl_private_key"

# JWT and Encryption
vault_jwt_secret: "$jwt_secret"
vault_encryption_key: "$encryption_key"

# Additional Service Passwords
vault_samba_password: "$samba_password"
vault_pihole_web_password: "$pihole_web_password"
vault_admin_password: "$admin_password"
vault_db_password: "$db_password"
vault_paperless_ngx_admin_password: "$paperless_ngx_admin_password"
vault_homepage_user_password: "$homepage_user_password"
vault_homepage_secret_key: "$homepage_secret_key"
vault_google_client_secret: "$google_client_secret"

# Additional Service Passwords (Previously Missing)
vault_calibre_web_password: "$calibre_web_password"
vault_jellyfin_password: "$jellyfin_password"
vault_sabnzbd_password: "$sabnzbd_password"
vault_audiobookshelf_password: "$audiobookshelf_password"
vault_authentik_postgres_password: "$authentik_postgres_password"
vault_grafana_admin_password_alt: "$grafana_admin_password_alt"
vault_influxdb_admin_password_alt: "$influxdb_admin_password_alt"
vault_nextcloud_db_password_alt: "$nextcloud_db_password_alt"
vault_nextcloud_admin_password_alt: "$nextcloud_admin_password_alt"
vault_nextcloud_db_root_password_alt: "$nextcloud_db_root_password_alt"

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
- Authentik Admin: $admin_email / $authentik_admin_password
- Grafana Admin: admin / $grafana_admin_password
- Traefik Basic Auth: admin / (see traefik config)
- Portainer Admin: admin / $portainer_admin_password
- GitLab Root: root / $gitlab_root_password
- Vaultwarden Admin: admin / $vaultwarden_admin_password
- Homepage Admin: admin / $homepage_admin_password

DATABASE PASSWORDS:
- PostgreSQL: $postgresql_password
- Redis: $redis_password
- Media DB: $media_database_password
- Paperless DB: $paperless_database_password
- n8n DB: $n8n_postgres_password
- Pezzo DB: $pezzo_postgres_password

API KEYS:
- Sonarr: $sonarr_api_key
- Radarr: $radarr_api_key
- Lidarr: $lidarr_api_key
- Readarr: $readarr_api_key
- Prowlarr: $prowlarr_api_key
- Bazarr: $bazarr_api_key
- Sabnzbd: $sabnzbd_api_key
- ErsatzTV: $ersatztv_api_key
- Tautulli: $tautulli_api_key
- Overseerr: $overseerr_api_key
- Jellyfin: $jellyfin_api_key
- Emby: $emby_api_key

LIDARR CONFIGURATION:
- Username: $lidarr_username
- Password: $lidarr_password
- Anonymous ID: $lidarr_anonymous_id
- qBittorrent Password: $qbittorrent_password

RECONYA:
- Admin Password: $reconya_admin_password
- JWT Secret: $reconya_jwt_secret

N8N:
- Admin Password: $n8n_admin_password
- Encryption Key: $n8n_encryption_key
- PostgreSQL Password: $n8n_postgres_password

LINKWARDEN:
- PostgreSQL Password: $linkwarden_postgres_password
- NextAuth Secret: $linkwarden_nextauth_secret

PEZZO:
- PostgreSQL Password: $pezzo_postgres_password
- Redis Password: $pezzo_redis_password
- ClickHouse Password: $pezzo_clickhouse_password

HOMEPAGE API KEYS:
- Homepage: $homepage_api_key
- Traefik: $traefik_api_key
- Authentik: $authentik_api_key
- Portainer: $portainer_api_key
- Grafana: $grafana_api_key
- Readarr: $readarr_api_key
- Paperless: $paperless_api_key
- Bookstack: $bookstack_api_key
- Immich: $immich_api_key
- Filebrowser: $filebrowser_api_key
- MinIO: $minio_api_key
- Kopia: $kopia_api_key
- Duplicati: $duplicati_api_key
- UptimeKuma: $uptimekuma_api_key
- GitLab: $gitlab_api_key
- Harbor: $harbor_api_key
- Guacamole: $guacamole_api_key
- Home Assistant: $homeassistant_api_key
- CrowdSec: $crowdsec_api_key
- Fail2ban: $fail2ban_api_key

SECRET KEYS:
- Authentik Secret: $authentik_secret_key
- Grafana Secret: $grafana_secret_key
- Paperless Secret: $paperless_secret_key
- Immich JWT: $immich_jwt_secret
- n8n Encryption: $n8n_encryption_key

EXTERNAL SERVICE KEYS:
- OpenWeather API: $openweather_api_key
- Kubernetes Token: $kubernetes_token
- Google Client Secret: $google_client_secret
- Google Refresh Token: $google_refresh_token
- MinIO Access Key: $minio_access_key
- MinIO Secret Key: $minio_secret_key

ADDITIONAL SERVICE CREDENTIALS:
- Loki Auth Token: $loki_auth_token
- ErsatzTV DB Password: $ersatztv_database_password
- Lidarr Username: $lidarr_username
- Lidarr Anonymous ID: $lidarr_anonymous_id
- Lidarr Password: $lidarr_password
- Plex Username: $plex_username
- Plex Password: $plex_password
- Jellyfin Username: $jellyfin_username
- Jellyfin Password: $jellyfin_password
- Immich SMTP Username: $immich_smtp_username
- Plex Token: $plex_token
- Webhook Token: $webhook_token
- Traefik Pilot Token: $traefik_pilot_token
- Immich Mapbox Key: $immich_mapbox_key
- PagerDuty Integration Key: $pagerduty_integration_key
- PagerDuty Routing Key: $pagerduty_routing_key
- Grafana Admin User: $grafana_admin_user
- InfluxDB Admin User: $influxdb_admin_user
- InfluxDB Username: $influxdb_username
- Media JWT Secret: $media_jwt_secret
- Redis Secret Key: $redis_secret_key
- PostgreSQL User: $postgresql_user
- CalibreWeb Secret Key: $calibreweb_secret_key
- Elasticsearch Password: $elasticsearch_password
- Elasticsearch Secret Key: $elasticsearch_secret_key
- Kibana Password: $kibana_password

ADDITIONAL SERVICE PASSWORDS (Previously Missing):
- Calibre Web Password: $calibre_web_password
- Jellyfin Password: $jellyfin_password
- Sabnzbd Password: $sabnzbd_password
- Audiobookshelf Password: $audiobookshelf_password
- Authentik PostgreSQL Password: $authentik_postgres_password
- Grafana Admin Password Alt: $grafana_admin_password_alt
- InfluxDB Admin Password Alt: $influxdb_admin_password_alt
- Nextcloud DB Password Alt: $nextcloud_db_password_alt
- Nextcloud Admin Password Alt: $nextcloud_admin_password_alt
- Nextcloud DB Root Password Alt: $nextcloud_db_root_password_alt

BACKUP ENCRYPTION:
- Backup Key: $backup_encryption_key

===============================================
EOF

    # Encrypt the credentials backup
    openssl enc -aes-256-cbc -salt -in credentials_backup.txt -out credentials_backup.enc
    
    # Get the full path of the credentials backup file
    credentials_backup_path=$(realpath credentials_backup.enc)
    
    print_success "Comprehensive secure vault variables generated"
    echo ""
    echo -e "${CYAN}🔐 CREDENTIALS BACKUP - YOUR HOMELAB KEYS${NC}"
    echo -e "${YELLOW}File Location:${NC} $credentials_backup_path"
    echo -e "${YELLOW}File Size:${NC} $(du -h credentials_backup.enc | cut -f1)"
    echo ""
    echo -e "${RED}⚠️  CRITICAL: This file contains ALL passwords and secrets for your homelab!${NC}"
    echo ""
    echo -e "${CYAN}📋 IMMEDIATE BACKUP REQUIREMENTS:${NC}"
    echo "1. ${GREEN}Copy to secure location:${NC} External drive, cloud storage, or password manager"
    echo "2. ${GREEN}Store multiple copies:${NC} At least 2-3 secure locations"
    echo "3. ${GREEN}Test decryption:${NC} Verify you can decrypt the file"
    echo "4. ${GREEN}Document location:${NC} Note where you stored the backup"
    echo ""
    echo -e "${CYAN}🔒 RECOMMENDED STORAGE OPTIONS:${NC}"
    echo "• Encrypted external drive"
    echo "• Password manager (1Password, Bitwarden, etc.)"
    echo "• Cloud storage with encryption (Google Drive, Dropbox)"
    echo "• Physical safe or secure location"
    echo ""
    echo -e "${CYAN}🚨 SECURITY WARNINGS:${NC}"
    echo "• Never commit this file to version control"
    echo "• Never share this file via email or messaging"
    echo "• Keep this file separate from your homelab server"
    echo "• Consider this file as valuable as your house keys"
    echo ""
    echo -e "${GREEN}✅ This file is your ONLY backup of homelab credentials!${NC}"
    echo ""
    echo -e "${CYAN}🧪 TEST DECRYPTION (Optional):${NC}"
    echo "To verify your backup is working, you can test decryption:"
    echo "openssl enc -d -aes-256-cbc -in $credentials_backup_path -out test_decrypt.txt"
    echo "cat test_decrypt.txt"
    echo "rm test_decrypt.txt  # Clean up test file"
    echo ""
}

# Update Homepage configuration files with generated API keys
update_homepage_config() {
    print_step "4.5" "Updating Homepage configuration with generated API keys..."
    
    # Create Homepage config directory if it doesn't exist
    mkdir -p homepage/config
    
    # Update homepage/vars/main.yml with generated API keys
    cat > roles/homepage/vars/main.yml << EOF
---
# Homepage Service API Keys
# Automatically generated by seamless setup
homepage_service_api_keys:
  traefik: "{{ vault_traefik_api_key }}"
  authentik: "{{ vault_authentik_api_key }}"
  portainer: "{{ vault_portainer_api_key }}"
  grafana: "{{ vault_grafana_api_key }}"
  sonarr: "{{ vault_sonarr_api_key }}"
  radarr: "{{ vault_radarr_api_key }}"
  lidarr: "{{ vault_lidarr_api_key }}"
  readarr: "{{ vault_readarr_api_key }}"
  prowlarr: "{{ vault_prowlarr_api_key }}"
  bazarr: "{{ vault_bazarr_api_key }}"
  tautulli: "{{ vault_tautulli_api_key }}"
  overseerr: "{{ vault_overseerr_api_key }}"
  jellyfin: "{{ vault_jellyfin_api_key }}"
  nextcloud: "{{ vault_nextcloud_api_key }}"
  paperless: "{{ vault_paperless_api_key }}"
  bookstack: "{{ vault_bookstack_api_key }}"
  immich: "{{ vault_immich_api_key }}"
  filebrowser: "{{ vault_filebrowser_api_key }}"
  minio: "{{ vault_minio_api_key }}"
  kopia: "{{ vault_kopia_api_key }}"
  duplicati: "{{ vault_duplicati_api_key }}"
  uptimekuma: "{{ vault_uptimekuma_api_key }}"
  gitlab: "{{ vault_gitlab_api_key }}"
  harbor: "{{ vault_harbor_api_key }}"
  guacamole: "{{ vault_guacamole_api_key }}"
  homeassistant: "{{ vault_homeassistant_api_key }}"
  crowdsec: "{{ vault_crowdsec_api_key }}"
  fail2ban: "{{ vault_fail2ban_api_key }}"
EOF

    # Update homepage/config/config.yml with generated API keys
    cat > homepage/config/config.yml << EOF
# Homepage Configuration
# Automatically generated by seamless setup

title: "Homelab Dashboard"
description: "Homelab Infrastructure Dashboard"
theme: "dark"
color: "slate"
language: "en"
units: "metric"
timezone: "$timezone"

# Header
headerStyle: "clean"
layout: "default"
sidebarIcon: "tabler:home"
sidebarTitle: "Homelab"
sidebarAnimation: true

# Weather Widget
weather:
  label: "Weather"
  latitude: 40.7128
  longitude: -74.0060
  unit: "f"
  provider: "openweathermap"
  apiKey: "$openweather_api_key"

# Docker Widget
docker:
  label: "Docker"
  url: "http://portainer.$domain"
  apiKey: "$portainer_api_key"

# Kubernetes Widget
kubernetes:
  label: "Kubernetes"
  url: "http://kubernetes.$domain"
  token: "$kubernetes_token"

# Google Drive Widget
google:
  label: "Google Drive"
  clientId: "your_google_client_id"
  clientSecret: "$google_client_secret"
  refreshToken: "$google_refresh_token"

# Traefik Widget
traefik:
  label: "Traefik"
  url: "http://traefik.$domain"
  apiKey: "$traefik_api_key"

# Authentik Widget
authentik:
  label: "Authentik"
  url: "http://auth.$domain"
  apiKey: "$authentik_api_key"

# Grafana Widget
grafana:
  label: "Grafana"
  url: "http://grafana.$domain"
  apiKey: "$grafana_api_key"

# MinIO Widget
minio:
  label: "MinIO"
  url: "http://s3.$domain"
  accessKey: "$minio_access_key"
  secretKey: "$minio_secret_key"
EOF

    # Update homepage/config/settings.yml with generated API keys
    cat > homepage/config/settings.yml << EOF
# Homepage Settings
# Automatically generated by seamless setup

# Weather Settings
weather:
  label: "Weather"
  latitude: 40.7128
  longitude: -74.0060
  unit: "f"
  provider: "openweathermap"
  apiKey: "$openweather_api_key"

# Email Settings
email:
  label: "Email"
  provider: "gmail"
  username: "$admin_email"
  password: "$smtp_password"

# Telegram Settings
telegram:
  label: "Telegram"
  botToken: "$telegram_bot_token"
  chatId: "$telegram_chat_id"

# Discord Settings
discord:
  label: "Discord"
  webhook: "$discord_webhook"

# Slack Settings
slack:
  label: "Slack"
  webhook: "$slack_webhook"

# Traefik Settings
traefik:
  label: "Traefik"
  url: "http://traefik.$domain"
  apiKey: "$traefik_api_key"

# Authentik Settings
authentik:
  label: "Authentik"
  url: "http://auth.$domain"
  apiKey: "$authentik_api_key"

# Grafana Settings
grafana:
  label: "Grafana"
  url: "http://grafana.$domain"
  apiKey: "$grafana_api_key"

# MinIO Settings
minio:
  label: "MinIO"
  url: "http://s3.$domain"
  accessKey: "$minio_access_key"
  secretKey: "$minio_secret_key"
EOF

    # Update homepage/config/widgets.yml with generated API keys
    cat > homepage/config/widgets.yml << EOF
# Homepage Widgets
# Automatically generated by seamless setup

# Google Drive Widget
google:
  label: "Google Drive"
  clientId: "your_google_client_id"
  clientSecret: "$google_client_secret"
  refreshToken: "$google_refresh_token"

# Weather Widget
weather:
  label: "Weather"
  latitude: 40.7128
  longitude: -74.0060
  unit: "f"
  provider: "openweathermap"
  apiKey: "$openweather_api_key"

# Docker Widget
docker:
  label: "Docker"
  url: "http://portainer.$domain"
  apiKey: "$portainer_api_key"

# Kubernetes Widget
kubernetes:
  label: "Kubernetes"
  url: "http://kubernetes.$domain"
  token: "$kubernetes_token"

# Traefik Widget
traefik:
  label: "Traefik"
  url: "http://traefik.$domain"
  apiKey: "$traefik_api_key"

# Authentik Widget
authentik:
  label: "Authentik"
  url: "http://auth.$domain"
  apiKey: "$authentik_api_key"

# Grafana Widget
grafana:
  label: "Grafana"
  url: "http://grafana.$domain"
  apiKey: "$grafana_api_key"

# MinIO Widget
minio:
  label: "MinIO"
  url: "http://s3.$domain"
  accessKey: "$minio_access_key"
  secretKey: "$minio_secret_key"
EOF

    # Update homepage/config/docker.yml with generated API keys
    cat > homepage/config/docker.yml << EOF
# Homepage Docker Configuration
# Automatically generated by seamless setup

version: "3.8"

services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    container_name: homepage
    ports:
      - "3000:3000"
    volumes:
      - ./config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - PUID=$puid
      - PGID=$pgid
      - TZ=$timezone
      - OPENWEATHER_API_KEY=$openweather_api_key
    restart: unless-stopped
    networks:
      - homelab
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.homepage.rule=Host(\`dash.$domain\`)"
      - "traefik.http.routers.homepage.entrypoints=websecure"
      - "traefik.http.routers.homepage.tls.certresolver=cloudflare"
      - "traefik.http.services.homepage.loadbalancer.server.port=3000"

networks:
  homelab:
    external: true
EOF

    print_success "Homepage configuration files updated with generated API keys"
}

# Create comprehensive configuration files
create_configuration() {
    print_step "4" "Creating comprehensive configuration files..."
    
    # Create common.yml with all variables
    cat > group_vars/all/common.yml << EOF
---
# Homelab Configuration Variables
# Comprehensive setup with all variables automatically configured

# Basic Configuration
username: "$username"
domain: "$domain"
ip_address: "$ip_address"
gateway: "$gateway"
timezone: "$timezone"
puid: "$puid"
pgid: "$pgid"

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
productivity_enabled: $([ "$productivity_enabled" = "Y" ] && echo "true" || echo "false")
automation_enabled: $([ "$automation_enabled" = "Y" ] && echo "true" || echo "false")

# Cloudflare Configuration
cloudflare_enabled: $([ "$cloudflare_enabled" = "Y" ] && echo "true" || echo "false")
cloudflare_email: "${cloudflare_email:-}"
cloudflare_api_token: "${cloudflare_api_token:-}"

# Email Configuration
admin_email: "$admin_email"
smtp_server: "${smtp_server:-}"
smtp_port: "${smtp_port:-587}"
smtp_username: "${smtp_username:-}"
smtp_password: "{{ vault_service_password }}"
from_email: "${from_email:-}"

# Notification Configuration
slack_webhook: "${slack_webhook:-}"
discord_webhook: "${discord_webhook:-}"
telegram_bot_token: "${telegram_bot_token:-}"
telegram_chat_id: "${telegram_chat_id:-}"

# DNS Configuration
primary_dns: "$primary_dns"
secondary_dns: "$secondary_dns"

# Docker Configuration
docker_user: "$username"

# Network Configuration
internal_subnet: "$internal_subnet"

# Backup Configuration
backup_retention_days: ${backup_retention_days:-7}
backup_compression: $([ "$backup_compression" = "Y" ] && echo "true" || echo "false")
backup_encryption: $([ "$backup_encryption" = "Y" ] && echo "true" || echo "false")

# Monitoring Configuration
monitoring_retention_days: ${monitoring_retention_days:-30}
alerting_enabled: $([ "$alerting_enabled" = "Y" ] && echo "true" || echo "false")

# Security Configuration
security_enhanced: $([ "$security_enhanced" = "Y" ] && echo "true" || echo "false")
fail2ban_enabled: $([ "$fail2ban_enabled" = "Y" ] && echo "true" || echo "false")
crowdsec_enabled: $([ "$crowdsec_enabled" = "Y" ] && echo "true" || echo "false")
ssl_enabled: $([ "$ssl_enabled" = "Y" ] && echo "true" || echo "false")

# System Configuration
system_updates_enabled: $([ "$system_updates_enabled" = "Y" ] && echo "true" || echo "false")
log_retention_days: ${log_retention_days:-30}

# Resource Limits
default_cpu_limit: "${default_cpu_limit:-2.0}"
default_memory_limit: "${default_memory_limit:-2g}"

# Subdomain Configuration
subdomains:
  traefik: "traefik"
  authentik: "auth"
  portainer: "portainer"
  grafana: "grafana"
  prometheus: "prometheus"
  loki: "loki"
  promtail: "logs"
  alertmanager: "alerts"
  sonarr: "sonarr"
  radarr: "radarr"
  prowlarr: "prowlarr"
  bazarr: "bazarr"
  overseerr: "overseerr"
  jellyfin: "jellyfin"
  tautulli: "tautulli"
  gitlab: "git"
  harbor: "registry"
  code: "code"
  nextcloud: "cloud"
  minio: "s3"
  paperless: "docs"
  immich: "photos"
  homeassistant: "hass"
  nodered: "flows"
  n8n: "n8n"
  vault: "vault"
  vaultwarden: "passwords"
  wireguard: "vpn"
  pihole: "dns"
  nginx_proxy_manager: "proxy"
  dash: "dash"
  files: "files"
  watchtower: "updates"
  dumbassets: "assets"
  linkwarden: "bookmarks"
  reconya: "reconya"
  ersatztv: "tv"
  pezzo: "pezzo"

# Docker networks
docker_networks:
  - name: homelab
    driver: bridge
    ipam_config:
      - subnet: "$internal_subnet"
        gateway: "$gateway"
  - name: monitoring
    driver: bridge
    internal: true
    ipam_config:
      - subnet: "$internal_subnet"
        gateway: "$gateway"
  - name: media
    driver: bridge
    ipam_config:
      - subnet: "$internal_subnet"
        gateway: "$gateway"

# Media directories structure
media_directories:
  - "/home/$username/data/media"
  - "/home/$username/data/media/movies"
  - "/home/$username/data/media/tv"
  - "/home/$username/data/media/anime"
  - "/home/$username/data/media/music"
  - "/home/$username/data/media/books"
  - "/home/$username/data/media/audiobooks"
  - "/home/$username/data/media/podcasts"
  - "/home/$username/data/torrents"
  - "/home/$username/data/torrents/movies"
  - "/home/$username/data/torrents/tv"
  - "/home/$username/data/torrents/anime"
  - "/home/$username/data/usenet"
  - "/home/$username/data/usenet/incomplete"
  - "/home/$username/data/usenet/complete"

# Service enablement list
enabled_services:
  # Core infrastructure (always enabled)
  - traefik
  - authentik
  - portainer
  
  # Monitoring stack
  - grafana
  - prometheus
  - influxdb
  - telegraf
  - loki
  - promtail
  - alertmanager
  - blackbox_exporter
  
  # Media services
  - sonarr
  - radarr
  - prowlarr
  - bazarr
  - overseerr
  - jellyfin
  - tautulli
  - komga
  - audiobookshelf
  - ersatztv
  
  # File services
  - nextcloud
  - samba
  - syncthing
  
  # Development tools
  - gitlab
  - harbor
  - code_server
  
  # AI and Development
  - pezzo
  
  # Storage and files
  - minio
  - paperless
  - bookstack
  - immich
  - filebrowser
  
  # Automation and smart home
  - homeassistant
  - mosquitto
  - zigbee2mqtt
  - nodered
  - n8n
  
  # Security services
  - vault
  - crowdsec
  - fail2ban
  - wireguard
  
  # Network services
  - pihole
  - nginx_proxy_manager
  
  # Backup solutions
  - kopia
  - duplicati
  
  # Utilities
  - watchtower
  - dashdot
  - guacamole
  - heimdall
  - homarr
  - requestrr
  - unmanic
  - vaultwarden
  - linkwarden
  - reconya

# Feature toggles
media_enabled: $([ "$media_enabled" = "Y" ] && echo "true" || echo "false")
automation_enabled: $([ "$automation_enabled" = "Y" ] && echo "true" || echo "false")
backup_enabled: true
development_enabled: $([ "$productivity_enabled" = "Y" ] && echo "true" || echo "false")
security_enhanced: $([ "$security_enhanced" = "Y" ] && echo "true" || echo "false")

# Deployment options
verify_deployment: true
reboot_after_deployment: true
ssl_enabled: $([ "$ssl_enabled" = "Y" ] && echo "true" || echo "false")
monitoring_external: true

# Traefik configuration
traefik_pilot_token: ""
traefik_log_level: "INFO"
traefik_access_logs: true
traefik_network: "homelab"
traefik_ssl_resolver: "cloudflare"

# Monitoring configuration
prometheus_config_dir: "/home/$username/docker/prometheus"
alertmanager_config_dir: "/home/$username/docker/alertmanager"
grafana_config_dir: "/home/$username/docker/grafana"
grafana_dashboards_dir: "/home/$username/docker/grafana/provisioning/dashboards"

# Security configuration
crowdsec_config_dir: "/home/$username/docker/crowdsec"
fail2ban_config_dir: "/home/$username/docker/fail2ban"

# Ansible configuration
ansible_backup_dir: "/home/$username/backups/ansible"

# Homepage configuration
homepage_config_dir: "/home/$username/docker/homepage"

# Loki configuration
loki_config_dir: "/home/$username/docker/loki"

# Traefik configuration directory
traefik_config_dir: "/home/$username/docker/traefik"
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

    # Create .env file for environment variables
    cat > .env << EOF
# Homelab Environment Variables
# Generated on $(date)

# Basic Configuration
HOMELAB_DOMAIN=$domain
HOMELAB_TIMEZONE=$timezone
HOMELAB_USERNAME=$username
HOMELAB_PUID=$puid
HOMELAB_PGID=$pgid
HOMELAB_IP_ADDRESS=$ip_address

# Network Configuration
HOMELAB_SUBNET=$internal_subnet
HOMELAB_GATEWAY=$gateway
UPSTREAM_DNS_1=$primary_dns
UPSTREAM_DNS_2=$secondary_dns

# Docker Configuration
DOCKER_ROOT=$docker_root
TRAEFIK_NETWORK=homelab

# Cloudflare Configuration
CLOUDFLARE_ENABLED=$([ "$cloudflare_enabled" = "Y" ] && echo "true" || echo "false")
CLOUDFLARE_EMAIL=${cloudflare_email:-}
CLOUDFLARE_API_TOKEN=${cloudflare_api_token:-}

# Email Configuration
ADMIN_EMAIL=$admin_email
MONITORING_EMAIL=${admin_email}
SMTP_HOST=${smtp_server:-}
SMTP_PORT=${smtp_port:-587}
SMTP_USERNAME=${smtp_username:-}
SMTP_PASSWORD=${smtp_password:-}
FROM_EMAIL=${from_email:-}

# Notification Configuration
SLACK_WEBHOOK=${slack_webhook:-}
DISCORD_WEBHOOK=${discord_webhook:-}
TELEGRAM_BOT_TOKEN=${telegram_bot_token:-}
TELEGRAM_CHAT_ID=${telegram_chat_id:-}

# Backup Configuration
BACKUP_RETENTION_DAYS=${backup_retention_days:-7}
BACKUP_COMPRESSION=$([ "$backup_compression" = "Y" ] && echo "true" || echo "false")
BACKUP_ENCRYPTION=$([ "$backup_encryption" = "Y" ] && echo "true" || echo "false")

# Monitoring Configuration
MONITORING_RETENTION_DAYS=${monitoring_retention_days:-30}
ALERTING_ENABLED=$([ "$alerting_enabled" = "Y" ] && echo "true" || echo "false")

# Security Configuration
SECURITY_ENHANCED=$([ "$security_enhanced" = "Y" ] && echo "true" || echo "false")
FAIL2BAN_ENABLED=$([ "$fail2ban_enabled" = "Y" ] && echo "true" || echo "false")
CROWDSEC_ENABLED=$([ "$crowdsec_enabled" = "Y" ] && echo "true" || echo "false")
SSL_ENABLED=$([ "$ssl_enabled" = "Y" ] && echo "true" || echo "false")

# System Configuration
SYSTEM_UPDATES_ENABLED=$([ "$system_updates_enabled" = "Y" ] && echo "true" || echo "false")
LOG_RETENTION_DAYS=${log_retention_days:-30}

# Resource Limits
CPU_SHARES=1024
MEMORY_LIMIT=${default_memory_limit:-2g}
MEMORY_SWAP=4G
MEMORY_RESERVATION=1G
CPU_LIMIT=${default_cpu_limit:-2.0}

# Feature Toggles
MONITORING_ENABLED=$([ "$monitoring_enabled" = "Y" ] && echo "true" || echo "false")
MEDIA_ENABLED=$([ "$media_enabled" = "Y" ] && echo "true" || echo "false")
SECURITY_ENABLED=$([ "$security_enabled" = "Y" ] && echo "true" || echo "false")
AUTOMATION_ENABLED=$([ "$automation_enabled" = "Y" ] && echo "true" || echo "false")
UTILITIES_ENABLED=$([ "$utilities_enabled" = "Y" ] && echo "true" || echo "false")
PRODUCTIVITY_ENABLED=$([ "$productivity_enabled" = "Y" ] && echo "true" || echo "false")

# Ansible Environment
ANSIBLE_ENVIRONMENT=production
EOF

    print_success "Comprehensive configuration files created"
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
    if ! ansible-playbook --syntax-check main.yml &>/dev/null; then
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
    ansible-playbook main.yml --tags "foundation" --ask-vault-pass
    
    echo "Deploying Stage 2: Core Services..."
    ansible-playbook main.yml --tags "infrastructure" --ask-vault-pass
    
    echo "Deploying Stage 3: Applications..."
    ansible-playbook main.yml --tags "media,development,storage" --ask-vault-pass
    
    echo "Deploying Stage 4: Enhanced Nginx Proxy Manager..."
    ansible-playbook main.yml --tags "nginx_proxy_manager" --ask-vault-pass
    
    echo "Deploying Stage 5: Validation..."
    ansible-playbook main.yml --tags "validation" --ask-vault-pass
    
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

🚀 DEPLOYMENT INFORMATION:
- Server Preparation: ${run_server_prep:-"Not required"}
- DNS Automation: ${dns_automation:-"Not configured"}
- Security Hardening: Applied
- All services deployed and configured

🔐 SECURITY INFORMATION:
- All passwords and keys are cryptographically secure
- Credentials backup: credentials_backup.enc
- Vault file: group_vars/all/vault.yml (encrypted)

🌐 ACCESS INFORMATION:
- Homepage Dashboard: https://dash.$domain
- Traefik Dashboard: https://traefik.$domain
- Nginx Proxy Manager: http://$ip_address:81
- Grafana: https://grafana.$domain
- Authentik: https://auth.$domain
- Portainer: https://portainer.$domain

📊 MONITORING:
- Prometheus: https://prometheus.$domain
- Alertmanager: https://alerts.$domain
- Loki: https://loki.$domain

🎬 MEDIA SERVICES:
- Sonarr: https://sonarr.$domain
- Radarr: https://radarr.$domain
- Jellyfin: https://jellyfin.$domain
- Overseerr: https://overseerr.$domain

🔧 DEVELOPMENT:
- GitLab: https://git.$domain
- Harbor: https://registry.$domain
- Code Server: https://code.$domain

📁 STORAGE:
- Nextcloud: https://cloud.$domain
- MinIO: https://s3.$domain
- Paperless: https://docs.$domain

🤖 AUTOMATION:
- n8n: https://n8n.$domain
- Node-RED: https://flows.$domain
- Home Assistant: https://hass.$domain

🔒 SECURITY:
- Vault: https://vault.$domain
- Vaultwarden: https://passwords.$domain
- Pi-hole: https://dns.$domain

📋 PRODUCTIVITY:
- Linkwarden: https://bookmarks.$domain
- Reconya: https://reconya.$domain
- ErsatzTV: https://tv.$domain
- Pezzo: https://pezzo.$domain

 DEFAULT CREDENTIALS:
- Authentik Admin: $admin_email / (see credentials backup)
- Grafana Admin: admin / (see credentials backup)
- Portainer Admin: admin / (see credentials backup)
- Homepage Admin: admin / (see credentials backup)
- Nginx Proxy Manager: $admin_email / (see credentials backup)

📁 SSH ACCESS:
- Server: $username@$ip_address
- Key: ~/.ssh/id_rsa

📋 CONFIGURATION FILES:
- Inventory: inventory.yml
- Variables: group_vars/all/common.yml
- Vault: group_vars/all/vault.yml (encrypted)
- Environment: .env

🚀 ENHANCED NGINX PROXY MANAGER FEATURES:
- Service Discovery: Automatic detection of running services
- SSL Automation: Automatic certificate provisioning and renewal
- Security Headers: Configurable security headers via vault
- Rate Limiting: Built-in rate limiting protection
- WAF Rules: Web Application Firewall protection
- API Integration: Full API-driven automation
- Health Monitoring: Comprehensive health checks
- Backup Automation: Encrypted backup scheduling

🚀 NEXT STEPS:
1. Access Homepage at https://dash.$domain
2. Access Nginx Proxy Manager at http://$ip_address:81
3. Configure service API keys in Homepage settings
4. Set up weather widget with your location
5. Customize bookmarks and service groups
6. Test all service integrations
7. Review monitoring dashboards
8. Configure backup schedules
9. Configure Reconya network scanning settings
10. Configure ErsatzTV channels and media sources
11. Set up Pezzo AI prompt management
12. Review NPM service discovery and SSL certificates

🔐 CREDENTIALS BACKUP - YOUR HOMELAB KEYS:
- File: $credentials_backup_path
- Size: $(du -h credentials_backup.enc | cut -f1)
- Status: Encrypted with AES-256-CBC

 SECURITY RECOMMENDATIONS:
1. IMMEDIATELY backup credentials_backup.enc to secure location
2. Store multiple copies (external drive, cloud, password manager)
3. Test decryption to verify backup integrity
4. Change default admin passwords after first login
5. Regularly rotate API keys and passwords
6. Enable 2FA where available
7. Keep credentials backup separate from homelab server

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
    
    log "Starting seamless deployment setup with comprehensive variable handling"
    
    # Check prerequisites and run server preparation if needed
    check_prerequisites
    
    # If server preparation was run, we need to switch to the homelab user
    if [[ -n "$run_server_prep" ]] && [[ $run_server_prep =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${CYAN}🔄 Switching to homelab user for deployment...${NC}"
        echo "Server preparation completed. Now switching to homelab user for deployment."
        echo ""
        
        # Get the homelab username from the server prep
        HOMELAB_USER=${HOMELAB_USER:-homelab}
        
        # Switch to homelab user and continue deployment
        if [[ "$SUDO_USER" != "$HOMELAB_USER" ]]; then
            echo "Switching to user: $HOMELAB_USER"
            echo "Please run the deployment as the homelab user: sudo -u $HOMELAB_USER $0"
            echo ""
            echo "Or continue as current user (not recommended):"
            read -p "Continue as current user? [y/N]: " continue_current
            if [[ ! $continue_current =~ ^[Yy]$ ]]; then
                exit 0
            fi
        fi
    fi
    
    get_configuration
    execute_dns_automation
    generate_secure_vault
    create_configuration
    update_homepage_config
    setup_ssh
    install_collections
    validate_setup
    
    echo ""
    echo -e "${YELLOW}Configuration Summary:${NC}"
    echo "Domain: $domain"
    echo "Server: $username@$ip_address"
    echo "Admin Email: $admin_email"
    echo "Security: $([ "$security_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Media: $([ "$media_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Monitoring: $([ "$monitoring_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Utilities: $([ "$utilities_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Productivity: $([ "$productivity_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo "Automation: $([ "$automation_enabled" = "Y" ] && echo "Enabled" || echo "Disabled")"
    echo ""
    echo -e "${CYAN} Security Features:${NC}"
    echo "✓ Cryptographically secure password generation"
    echo "✓ Encrypted vault file"
    echo "✓ Secure credentials backup"
    echo "✓ Complex password requirements"
    echo "✓ API key prefixing for identification"
    echo "✓ Comprehensive variable coverage"
    echo "✓ Automatic configuration generation"
    echo "✓ Integrated server preparation (NEW)"
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
    echo -e "${GREEN}🎉 Seamless deployment completed successfully!${NC}"
    echo ""
    echo "🔐 CREDENTIALS BACKUP - YOUR HOMELAB KEYS"
    echo "📁 File: $credentials_backup_path"
    echo "📊 Size: $(du -h credentials_backup.enc | cut -f1)"
    echo "🔒 Status: Encrypted with AES-256-CBC"
    echo ""
    echo "🌐 Access your homelab at: https://dash.$domain"
    echo "📋 Check deployment_summary.txt for full details"
    echo ""
    echo -e "${RED}🚨 CRITICAL: Backup credentials_backup.enc immediately!${NC}"
    echo -e "${YELLOW}This file contains ALL passwords and secrets for your homelab!${NC}"
    echo ""
    log "Seamless deployment with comprehensive variable handling completed successfully"
}

# Run main function
main "$@" 