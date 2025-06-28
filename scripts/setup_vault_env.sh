#!/bin/bash
# Vault Environment Setup Script
# Sets up environment variables for ansible-vault

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Function to generate random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to generate secret key
generate_secret_key() {
    openssl rand -hex 32
}

print_header "Vault Environment Setup"
print_status "This script will help you set up environment variables for ansible-vault."

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

print_header "Setting up environment variables..."

# Create .env file with all vault variables
cat > .env << EOF
# Vault Environment Variables for Ansible Homelab
# Generated on $(date)

# Database Passwords
export VAULT_POSTGRESQL_PASSWORD="$(generate_password)"
export VAULT_MEDIA_DATABASE_PASSWORD="$(generate_password)"
export VAULT_PAPERLESS_DATABASE_PASSWORD="$(generate_password)"
export VAULT_FING_DATABASE_PASSWORD="$(generate_password)"
export VAULT_REDIS_PASSWORD="$(generate_password)"

# Service Authentication
export VAULT_PAPERLESS_ADMIN_PASSWORD="$(generate_password)"
export VAULT_PAPERLESS_SECRET_KEY="$(generate_secret_key)"
export VAULT_FING_ADMIN_PASSWORD="$(generate_password)"
export VAULT_PAPERLESS_ADMIN_TOKEN="$(generate_secret_key)"
export VAULT_FING_API_KEY="$(generate_secret_key)"

# Media Service API Keys
export VAULT_SABNZBD_API_KEY="$(generate_secret_key)"
export VAULT_SONARR_API_KEY="$(generate_secret_key)"
export VAULT_RADARR_API_KEY="$(generate_secret_key)"
export VAULT_LIDARR_API_KEY="$(generate_secret_key)"
export VAULT_READARR_API_KEY="$(generate_secret_key)"
export VAULT_PROWLARR_API_KEY="$(generate_secret_key)"
export VAULT_BAZARR_API_KEY="$(generate_secret_key)"

# Email Configuration
export VAULT_SMTP_USERNAME=""
export VAULT_SMTP_PASSWORD=""

# Notification Services
export VAULT_SLACK_WEBHOOK=""
export VAULT_DISCORD_WEBHOOK=""

# Container Update Service
export VAULT_WATCHTOWER_TOKEN="$(generate_secret_key)"

# Monitoring Passwords
export VAULT_INFLUXDB_ADMIN_PASSWORD="$(generate_password)"
export VAULT_INFLUXDB_TOKEN="$(generate_secret_key)"
export VAULT_GRAFANA_ADMIN_PASSWORD="$(generate_password)"
export VAULT_GRAFANA_SECRET_KEY="$(generate_secret_key)"

# Security Passwords
export VAULT_AUTHENTIK_SECRET_KEY="$(generate_secret_key)"
export VAULT_AUTHENTIK_POSTGRES_PASSWORD="$(generate_password)"
export VAULT_AUTHENTIK_ADMIN_PASSWORD="$(generate_password)"
export VAULT_AUTHENTIK_ADMIN_EMAIL="admin@zorg.media"
export VAULT_CLOUDFLARE_API_TOKEN=""
export VAULT_PIHOLE_ADMIN_PASSWORD="$(generate_password)"
EOF

print_status "Environment file created: .env"

print_header "Next Steps"

print_status "1. Edit the .env file and add your specific values:"
print_status "   - VAULT_SMTP_USERNAME and VAULT_SMTP_PASSWORD"
print_status "   - VAULT_SLACK_WEBHOOK or VAULT_DISCORD_WEBHOOK"
print_status "   - VAULT_CLOUDFLARE_API_TOKEN"
print_status "   - VAULT_AUTHENTIK_ADMIN_EMAIL"

print_status "2. Source the environment variables:"
print_status "   source .env"

print_status "3. Create the vault file:"
print_status "   ansible-vault create group_vars/all/vault.yml"

print_status "4. Run the playbook:"
print_status "   ansible-playbook site.yml --ask-vault-pass"

print_header "Security Notes"

print_warning "Keep the .env file secure and do not commit it to version control"
print_warning "The vault file will be encrypted and can be safely committed"
print_warning "Consider using a password manager to store these credentials"

print_status "Vault environment setup completed successfully!" 