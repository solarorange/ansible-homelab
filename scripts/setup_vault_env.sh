#!/bin/bash
# Enhanced Vault Environment Setup Script
# Sets up environment variables for ansible-vault with comprehensive security

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_section() {
    echo -e "${PURPLE}--- $1 ---${NC}"
}

# Function to generate random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to generate secret key
generate_secret_key() {
    openssl rand -hex 32
}

# Function to generate API key with prefix
generate_api_key() {
    local prefix="$1"
    echo "${prefix}_$(openssl rand -hex 32)"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to validate email format
validate_email() {
    local email="$1"
    if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

print_header "Enhanced Vault Environment Setup"
print_status "This script will automatically set up all environment variables for ansible-vault."
print_status "It will generate secure passwords and provide seamless setup."

# Check prerequisites
print_section "Checking Prerequisites"

if ! command_exists openssl; then
    print_error "OpenSSL is required but not installed. Please install OpenSSL first."
    exit 1
fi

if ! command_exists ansible-vault; then
    print_warning "ansible-vault not found. Please ensure Ansible is installed."
fi

# Check if .env file exists
if [ -f ".env" ]; then
    print_warning "Environment file .env already exists."
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Setup cancelled."
        exit 0
    fi
fi

# Interactive configuration
print_section "Interactive Configuration"

# Get admin email
read -p "Enter admin email address (default: {{ admin_email | default("admin@" + domain) }} " admin_email
admin_email=${admin_email:-{{ admin_email | default("admin@" + domain) }}

if ! validate_email "$admin_email"; then
    print_error "Invalid email format: $admin_email"
    exit 1
fi

# Get domain
read -p "Enter your domain (default: zorg.media): " domain
domain=${domain:-zorg.media}

# Get SMTP configuration (optional)
print_status "SMTP Configuration (optional - press Enter to skip)"
read -p "SMTP Host: " smtp_host
read -p "SMTP Port (default: 587): " smtp_port
smtp_port=${smtp_port:-587}
read -p "SMTP Username: " smtp_username
read -s -p "SMTP password: "{{ vault_vault_password }}"Cloudflare Configuration (optional - press Enter to skip)"
read -p "Cloudflare Email: " cloudflare_email
read -s -p "Cloudflare API Token: " cloudflare_token
echo

# Get notification webhooks (optional)
print_status "Notification Webhooks (optional - press Enter to skip)"
read -p "Slack Webhook URL: " slack_webhook
read -p "Discord Webhook URL: " discord_webhook

# Get external tokens (optional)
print_status "External Service Tokens (optional - press Enter to skip)"
read -s -p "Telegram Bot Token: " telegram_token
echo
read -s -p "Traefik Pilot Token: " traefik_token
echo

print_header "Generating Secure Passwords and Keys"

# Create .env file with all vault variables
cat > .env << EOF
# Enhanced Vault Environment Variables for Ansible Homelab
# Generated on $(date)
# Admin Email: ${admin_email}
# Domain: ${domain}

#==============================================================================
# DATABASE PASSWORDS
#==============================================================================

# Database Passwords
export VAULT_POSTGRESQL_password: "{{ vault_vault_password }}"
export VAULT_MEDIA_DATABASE_password: "{{ vault_vault_password }}"
export VAULT_PAPERLESS_DATABASE_password: "{{ vault_vault_password }}"
export VAULT_FING_DATABASE_password: "{{ vault_vault_password }}"
export VAULT_ROMM_DATABASE_password: "{{ vault_vault_password }}"
export VAULT_REDIS_password: "{{ vault_vault_password }}"
export VAULT_MARIADB_ROOT_password: "{{ vault_vault_password }}"
export VAULT_INFLUXDB_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_IMMICH_DB_password: "{{ vault_vault_password }}"
export VAULT_IMMICH_POSTGRES_password: "{{ vault_vault_password }}"
export VAULT_NEXTCLOUD_DB_password: "{{ vault_vault_password }}"
export VAULT_NEXTCLOUD_DB_ROOT_password: "{{ vault_vault_password }}"
export VAULT_LINKWARDEN_POSTGRES_password: "{{ vault_vault_password }}"
export VAULT_N8N_POSTGRES_password: "{{ vault_vault_password }}"
export VAULT_PEZZO_POSTGRES_password: "{{ vault_vault_password }}"
export VAULT_AUTHENTIK_POSTGRES_password: "{{ vault_vault_password }}"
export VAULT_VAULTWARDEN_POSTGRES_password: "{{ vault_vault_password }}"

# Service Admin Passwords
export VAULT_AUTHENTIK_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_GRAFANA_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_PAPERLESS_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_FING_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_ROMM_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_HOMEASSISTANT_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_MOSQUITTO_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_NEXTCLOUD_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_SYNCTHING_GUI_password: "{{ vault_vault_password }}"
export VAULT_PIHOLE_ADMIN_password: "{{ vault_vault_password }}"
export VAULT_MARIADB_ROOT_password: "{{ vault_vault_password }}"
export VAULT_PROXMOX_password: "{{ vault_vault_password }}"

# Media Service Passwords
export VAULT_JELLYFIN_password: "{{ vault_vault_password }}"
export VAULT_CALIBRE_WEB_password: "{{ vault_vault_password }}"
export VAULT_AUDIOBOOKSHELF_password: "{{ vault_vault_password }}"
export VAULT_SABNZBD_password: "{{ vault_vault_password }}"
export VAULT_TDARR_password: "{{ vault_vault_password }}"
export VAULT_QBITTORRENT_password: "{{ vault_vault_password }}"

# Infrastructure Passwords
export VAULT_INFLUXDB_TOKEN="$(generate_secret_key)"
export VAULT_TRANSIT_TOKEN="$(generate_secret_key)"

# Notification Tokens
export VAULT_IMMICH_PUSH_TOKEN="${telegram_token:-}"
export VAULT_IMMICH_TELEGRAM_BOT_TOKEN="${telegram_token:-}"
export VAULT_TELEGRAM_BOT_TOKEN="${telegram_token:-}"

#==============================================================================
# SERVICE SECRET KEYS
#==============================================================================

# Core Service Secret Keys
export VAULT_AUTHENTIK_SECRET_KEY="$(generate_secret_key)"
export VAULT_GRAFANA_SECRET_KEY="$(generate_secret_key)"
export VAULT_PAPERLESS_SECRET_KEY="$(generate_secret_key)"

# Service-Specific Secret Keys
export VAULT_MEDIA_JWT_SECRET="$(generate_secret_key)"
export VAULT_IMMICH_JWT_SECRET="$(generate_secret_key)"
export VAULT_LINKWARDEN_NEXTAUTH_SECRET="$(generate_secret_key)"
export VAULT_RECONYA_JWT_SECRET="$(generate_secret_key)"
export VAULT_CALIBREWEB_SECRET_KEY="$(generate_secret_key)"
export VAULT_ROMM_SECRET_KEY="$(generate_secret_key)"

# OAuth and API Secrets
export VAULT_IMMICH_OAUTH_CLIENT_SECRET="$(generate_secret_key)"
export VAULT_IMMICH_PUSH_APP_SECRET="$(generate_secret_key)"
export VAULT_VAULTWARDEN_ADMIN_TOKEN="$(generate_secret_key)"
export VAULT_ROMM_API_KEY="$(generate_secret_key)"

#==============================================================================
# API KEYS
#==============================================================================

# Media Service API Keys
export VAULT_SABNZBD_API_KEY="$(generate_api_key 'sabnzbd')"
export VAULT_SONARR_API_KEY="$(generate_api_key 'sonarr')"
export VAULT_RADARR_API_KEY="$(generate_api_key 'radarr')"
export VAULT_LIDARR_API_KEY="$(generate_api_key 'lidarr')"
export VAULT_READARR_API_KEY="$(generate_api_key 'readarr')"
export VAULT_PROWLARR_API_KEY="$(generate_api_key 'prowlarr')"
export VAULT_BAZARR_API_KEY="$(generate_api_key 'bazarr')"
export VAULT_TAUTULLI_API_KEY="$(generate_secret_key)"

# Service-Specific API Keys
export VAULT_FING_API_KEY="$(generate_secret_key)"
export VAULT_VAULTWARDEN_HOMEPAGE_API_KEY="$(generate_secret_key)"
export VAULT_WATCHTOWER_TOKEN="$(generate_secret_key)"

#==============================================================================
# TOKENS AND ACCESS KEYS
#==============================================================================

# Infrastructure Tokens
export VAULT_INFLUXDB_TOKEN="$(generate_secret_key)"
export VAULT_TRANSIT_TOKEN="$(generate_secret_key)"

# Notification Tokens
export VAULT_IMMICH_PUSH_TOKEN="${telegram_token:-}"
export VAULT_IMMICH_TELEGRAM_BOT_TOKEN="${telegram_token:-}"
export VAULT_TELEGRAM_BOT_TOKEN="${telegram_token:-}"

#==============================================================================
# OAUTH CLIENT SECRETS
#==============================================================================

# OAuth Client Secrets for Authentik Integration
export VAULT_GRAFANA_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_SONARR_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_RADARR_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_JELLYFIN_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_OVERSEERR_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_PORTAINER_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_HOMEPAGE_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_PROWLARR_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_BAZARR_OAUTH_SECRET="$(generate_secret_key)"
export VAULT_TAUTULLI_OAUTH_SECRET="$(generate_secret_key)"

#==============================================================================
# EXTERNAL SERVICE CREDENTIALS
#==============================================================================

# Cloudflare Configuration
export VAULT_CLOUDFLARE_API_TOKEN="${cloudflare_token:-}"
export VAULT_CLOUDFLARE_EMAIL="${cloudflare_email:-}"

# SMTP Configuration
export VAULT_SMTP_USERNAME="${smtp_username:-}"
export VAULT_SMTP_password: "{{ vault_vault_password }}"
export VAULT_SMTP_HOST="${smtp_host:-}"
export VAULT_SMTP_PORT="${smtp_port:-587}"
export VAULT_SMTP_FROM_ADDRESS="${admin_email}"

# Service-Specific SMTP
export VAULT_IMMICH_SMTP_password: "{{ vault_vault_password }}"
export VAULT_VAULTWARDEN_SMTP_password: "{{ vault_vault_password }}"
export VAULT_FING_SMTP_password: "{{ vault_vault_password }}"

# LDAP Configuration
export VAULT_AUTHENTIK_LDAP_password: "{{ vault_vault_password }}"

# MQTT Configuration
export VAULT_ZIGBEE2MQTT_MQTT_password: "{{ vault_vault_password }}"

#==============================================================================
# NOTIFICATION WEBHOOKS
#==============================================================================

# Notification Services
export VAULT_SLACK_WEBHOOK="${slack_webhook:-}"
export VAULT_DISCORD_WEBHOOK="${discord_webhook:-}"

#==============================================================================
# OPTIONAL TOKENS
#==============================================================================

# Optional: Traefik Pilot Token
export VAULT_TRAEFIK_PILOT_TOKEN="${traefik_token:-}"

#==============================================================================
# BACKUP ENCRYPTION
#==============================================================================

# Backup encryption key
export VAULT_BACKUP_ENCRYPTION_KEY="$(generate_secret_key)"

#==============================================================================
# CONFIGURATION VARIABLES
#==============================================================================

# Admin Configuration
export VAULT_AUTHENTIK_ADMIN_EMAIL="${admin_email}"
export VAULT_AUTHENTIK_ADMIN_USERNAME="admin"

# Domain Configuration
export VAULT_DOMAIN="${domain}"
export VAULT_CLOUDFLARE_DOMAIN="${domain}"

# Security Configuration
export VAULT_SECURITY_LEVEL="production"
export VAULT_ENCRYPTION_ALGORITHM="AES-256-GCM"
EOF

print_status "Environment file created: .env"

# Create vault file from template
print_section "Creating Vault File"

if [ -f "group_vars/all/vault_template.yml" ]; then
    cp group_vars/all/vault_template.yml group_vars/all/vault.yml
    print_status "Vault template copied to group_vars/all/vault.yml"
else
    print_warning "Vault template not found. Please create group_vars/all/vault.yml manually."
fi

# Create .gitignore entries
print_section "Setting up Git Security"

if [ -f ".gitignore" ]; then
    # Check if entries already exist
    if ! grep -q "\.env" .gitignore; then
        echo "" >> .gitignore
        echo "# Vault Security" >> .gitignore
        echo ".env" >> .gitignore
        echo "*.key" >> .gitignore
        echo "*.pem" >> .gitignore
        echo "secrets/" >> .gitignore
        print_status "Added security entries to .gitignore"
    fi
else
    cat > .gitignore << EOF
# Vault Security
.env
*.key
*.pem
secrets/

# Ansible
*.retry
*.pyc
__pycache__/
.ansible/

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
EOF
    print_status "Created .gitignore with security entries"
fi

# Create setup completion script
print_section "Creating Setup Completion Script"

cat > scripts/complete_vault_setup.sh << 'EOF'
#!/bin/bash
# Vault Setup Completion Script

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_header "Completing Vault Setup"

# Source environment variables
if [ -f ".env" ]; then
    source .env
    print_status "Environment variables loaded"
else
    print_warning ".env file not found. Please run setup_vault_env.sh first."
    exit 1
fi

# Create vault file if it doesn't exist
if [ ! -f "group_vars/all/vault.yml" ]; then
    print_status "Creating vault file..."
    ansible-vault create group_vars/all/vault.yml
else
    print_status "Vault file already exists"
fi

# Test vault configuration
print_status "Testing vault configuration..."
if ansible-vault view group_vars/all/vault.yml > /dev/null 2>&1; then
    print_status "Vault file is properly encrypted"
else
    print_warning "Vault file may not be properly encrypted"
fi

print_header "Setup Complete!"

print_status "Your vault environment is now ready."
print_status "You can now run: ansible-playbook site.yml --ask-vault-pass"
print_status "Or set ANSIBLE_VAULT_PASSWORD_FILE for automated deployment."

print_warning "Remember to:"
print_warning "1. Keep your .env file secure"
print_warning "2. Never commit .env to version control"
print_warning "3. Store your vault password securely"
print_warning "4. Regularly rotate your secrets"
EOF

chmod +x scripts/complete_vault_setup.sh
print_status "Created setup completion script: scripts/complete_vault_setup.sh"

print_header "Next Steps"

print_status "1. Review and edit the .env file if needed:"
print_status "   nano .env"

print_status "2. Source the environment variables:"
print_status "   source .env"

print_status "3. Complete the vault setup:"
print_status "   ./scripts/complete_vault_setup.sh"

print_status "4. Run the playbook:"
print_status "   ansible-playbook site.yml --ask-vault-pass"

print_header "Security Notes"

print_warning "🔒 SECURITY CRITICAL:"
print_warning "   - The .env file contains ALL your secrets"
print_warning "   - Keep it secure and NEVER commit to version control"
print_warning "   - Consider using a password manager for backup"
print_warning "   - Regularly rotate your secrets using secret_rotation.yml"

print_status "✅ SECURITY FEATURES:"
print_status "   - All passwords are automatically generated"
print_status "   - Secrets are properly vaulted"
print_status "   - Git security is configured"
print_status "   - Environment variables are isolated"

print_status "🔄 AUTOMATION:"
print_status "   - Seamless setup with minimal user input"
print_status "   - Automatic password generation"
print_status "   - Template-based configuration"
print_status "   - Setup completion script provided"

print_header "Vault Environment Setup Completed Successfully!"

print_status "Your homelab is now ready for secure deployment!"
print_status "All passwords are generated and secured in the vault." 