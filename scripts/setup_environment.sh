#!/bin/bash

# 🚀 Ansible Homelab - Interactive Setup Script
# This script will configure your environment for deployment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to validate input
validate_domain() {
    if [[ $1 =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

validate_ip() {
    if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a ip_parts <<< "$1"
        for part in "${ip_parts[@]}"; do
            if [[ $part -lt 0 || $part -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Function to generate secure passwords
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root. Consider using a non-root user with sudo privileges."
    fi
    
    # Check for required commands
    local missing_commands=()
    
    for cmd in curl wget git python3 docker; do
        if ! command -v $cmd &> /dev/null; then
            missing_commands+=($cmd)
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        print_error "Missing required commands: ${missing_commands[*]}"
        print_status "Please install the missing packages and run this script again."
        exit 1
    fi
    
    print_status "All prerequisites are satisfied!"
}

# Function to get user input with validation
get_user_input() {
    local prompt="$1"
    local validation_func="$2"
    local default_value="$3"
    local input
    
    while true; do
        if [[ -n "$default_value" ]]; then
            read -p "$prompt [$default_value]: " input
            input=${input:-$default_value}
        else
            read -p "$prompt: " input
        fi
        
        if [[ -n "$input" ]]; then
            if [[ -n "$validation_func" ]]; then
                if $validation_func "$input"; then
                    echo "$input"
                    return 0
                else
                    print_error "Invalid input. Please try again."
                fi
            else
                echo "$input"
                return 0
            fi
        else
            print_error "Input cannot be empty. Please try again."
        fi
    done
}

# Function to configure basic settings
configure_basic_settings() {
    print_header "Basic Configuration"
    
    # Get domain name
    DOMAIN=$(get_user_input "Enter your domain name (e.g., example.com)" "validate_domain")
    
    # Get server IP
    SERVER_IP=$(get_user_input "Enter your server IP address" "validate_ip")
    
    # Get timezone
    TIMEZONE=$(get_user_input "Enter your timezone (e.g., America/New_York)" "" "$(timedatectl show --property=Timezone --value)")
    
    # Get username
    USERNAME=$(get_user_input "Enter the username for the homelab user" "" "$(whoami)")
    
    print_status "Basic configuration completed!"
}

# Function to configure network settings
configure_network_settings() {
    print_header "Network Configuration"
    
    # Get gateway IP
    GATEWAY_IP=$(get_user_input "Enter your gateway IP address" "validate_ip" "192.168.1.1")
    
    # Get DNS servers
    DNS_SERVERS=$(get_user_input "Enter DNS servers (comma-separated)" "" "1.1.1.1,8.8.8.8")
    
    # Get internal subnet
    INTERNAL_SUBNET=$(get_user_input "Enter internal subnet (e.g., 192.168.1.0/24)" "" "192.168.1.0/24")
    
    print_status "Network configuration completed!"
}

# Function to configure Cloudflare settings
configure_cloudflare() {
    print_header "Cloudflare Configuration"
    
    echo "Cloudflare is recommended for DNS management and SSL certificates."
    read -p "Do you want to configure Cloudflare? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        CLOUDFLARE_EMAIL=$(get_user_input "Enter your Cloudflare email address" "")
        
        print_warning "You'll need to create a Cloudflare API token with these permissions:"
        echo "  - Zone:Zone:Read"
        echo "  - Zone:DNS:Edit"
        echo "  - Zone:Zone Settings:Edit"
        echo "  - Zone:Zone Settings:Edit"
        
        CLOUDFLARE_API_TOKEN=$(get_user_input "Enter your Cloudflare API token" "")
        
        print_status "Cloudflare configuration completed!"
    else
        CLOUDFLARE_EMAIL=""
        CLOUDFLARE_API_TOKEN=""
        print_warning "Cloudflare not configured. SSL certificates may not work properly."
    fi
}

# Function to configure optional services
configure_optional_services() {
    print_header "Optional Services Configuration"
    
    # SMTP Configuration
    echo "SMTP configuration is optional but recommended for notifications."
    read -p "Do you want to configure SMTP? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        SMTP_HOST=$(get_user_input "Enter SMTP server (e.g., smtp.gmail.com)" "")
        SMTP_PORT=$(get_user_input "Enter SMTP port" "" "587")
        SMTP_USERNAME=$(get_user_input "Enter SMTP username" "")
        SMTP_PASSWORD=$(get_user_input "Enter SMTP password" "")
        SMTP_FROM_ADDRESS=$(get_user_input "Enter from email address" "")
    else
        SMTP_HOST=""
        SMTP_PORT=""
        SMTP_USERNAME=""
        SMTP_PASSWORD=""
        SMTP_FROM_ADDRESS=""
    fi
    
    # Traefik Pilot Token
    echo "Traefik Pilot token is optional for enhanced monitoring."
    read -p "Do you have a Traefik Pilot token? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        TRAEFIK_PILOT_TOKEN=$(get_user_input "Enter your Traefik Pilot token" "")
    else
        TRAEFIK_PILOT_TOKEN=""
    fi
    
    print_status "Optional services configuration completed!"
}

# Function to generate passwords
generate_passwords() {
    print_header "Generating Secure Passwords"
    
    # Generate passwords for all services
    POSTGRESQL_PASSWORD=$(generate_password)
    REDIS_PASSWORD=$(generate_password)
    GRAFANA_ADMIN_PASSWORD=$(generate_password)
    AUTHENTIK_ADMIN_PASSWORD=$(generate_password)
    AUTHENTIK_SECRET_KEY=$(generate_password)
    GRAFANA_SECRET_KEY=$(generate_password)
    
    # Generate OAuth secrets for Authentik integration
    GRAFANA_OAUTH_SECRET=$(generate_password)
    SONARR_OAUTH_SECRET=$(generate_password)
    RADARR_OAUTH_SECRET=$(generate_password)
    JELLYFIN_OAUTH_SECRET=$(generate_password)
    OVERSEERR_OAUTH_SECRET=$(generate_password)
    PORTAINER_OAUTH_SECRET=$(generate_password)
    HOMEPAGE_OAUTH_SECRET=$(generate_password)
    PROWLARR_OAUTH_SECRET=$(generate_password)
    BAZARR_OAUTH_SECRET=$(generate_password)
    TAUTULLI_OAUTH_SECRET=$(generate_password)
    
    print_status "All passwords and OAuth secrets generated successfully!"
}

# Function to create directories
create_directories() {
    print_header "Creating Directory Structure"
    
    # Create main directories
    local dirs=(
        "/opt/docker"
        "/opt/data"
        "/opt/config"
        "/opt/backup"
        "/opt/logs"
        "/opt/scripts"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            sudo mkdir -p "$dir"
            print_status "Created directory: $dir"
        else
            print_status "Directory already exists: $dir"
        fi
    done
    
    # Set permissions
    sudo chown -R $USERNAME:$USERNAME /opt/docker /opt/data /opt/config /opt/backup /opt/logs /opt/scripts
    sudo chmod -R 755 /opt/docker /opt/data /opt/config /opt/backup /opt/logs /opt/scripts
    
    print_status "Directory structure created successfully!"
}

# Function to create .env file
create_env_file() {
    print_header "Creating Environment File"
    
    cat > .env << EOF
# Ansible Homelab Environment Configuration
# Generated on $(date)

# Basic Configuration
DOMAIN=$DOMAIN
SERVER_IP=$SERVER_IP
TIMEZONE=$TIMEZONE
USERNAME=$USERNAME

# Network Configuration
GATEWAY_IP=$GATEWAY_IP
DNS_SERVERS=$DNS_SERVERS
INTERNAL_SUBNET=$INTERNAL_SUBNET

# Cloudflare Configuration
CLOUDFLARE_EMAIL=$CLOUDFLARE_EMAIL
CLOUDFLARE_API_TOKEN=$CLOUDFLARE_API_TOKEN

# SMTP Configuration
SMTP_HOST=$SMTP_HOST
SMTP_PORT=$SMTP_PORT
SMTP_USERNAME=$SMTP_USERNAME
SMTP_PASSWORD=$SMTP_PASSWORD
SMTP_FROM_ADDRESS=$SMTP_FROM_ADDRESS

# Traefik Configuration
TRAEFIK_PILOT_TOKEN=$TRAEFIK_PILOT_TOKEN

# Generated Passwords
POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
REDIS_PASSWORD=$REDIS_PASSWORD
GRAFANA_ADMIN_PASSWORD=$GRAFANA_ADMIN_PASSWORD
AUTHENTIK_ADMIN_PASSWORD=$AUTHENTIK_ADMIN_PASSWORD
AUTHENTIK_SECRET_KEY=$AUTHENTIK_SECRET_KEY
GRAFANA_SECRET_KEY=$GRAFANA_SECRET_KEY

# OAuth Secrets for Authentik Integration
GRAFANA_OAUTH_SECRET=$GRAFANA_OAUTH_SECRET
SONARR_OAUTH_SECRET=$SONARR_OAUTH_SECRET
RADARR_OAUTH_SECRET=$RADARR_OAUTH_SECRET
JELLYFIN_OAUTH_SECRET=$JELLYFIN_OAUTH_SECRET
OVERSEERR_OAUTH_SECRET=$OVERSEERR_OAUTH_SECRET
PORTAINER_OAUTH_SECRET=$PORTAINER_OAUTH_SECRET
HOMEPAGE_OAUTH_SECRET=$HOMEPAGE_OAUTH_SECRET
PROWLARR_OAUTH_SECRET=$PROWLARR_OAUTH_SECRET
BAZARR_OAUTH_SECRET=$BAZARR_OAUTH_SECRET
TAUTULLI_OAUTH_SECRET=$TAUTULLI_OAUTH_SECRET

# Directory Configuration
DOCKER_DIR=/opt/docker
DATA_DIR=/opt/data
CONFIG_DIR=/opt/config
BACKUP_DIR=/opt/backup
LOGS_DIR=/opt/logs
SCRIPTS_DIR=/opt/scripts

# Feature Toggles
MONITORING_ENABLED=true
MEDIA_ENABLED=true
SECURITY_ENHANCED=true
BACKUP_ENABLED=true
AUTOMATION_ENABLED=true

# Resource Limits
MAX_MEMORY=8G
MAX_CPU=4
EOF
    
    print_status "Environment file created: .env"
}

# Function to create vault template
create_vault_template() {
    print_header "Creating Vault Template"
    
    cat > group_vars/all/vault_template.yml << EOF
# Ansible Vault Configuration Template
# Copy this to group_vars/all/vault.yml and encrypt with ansible-vault

# Database Passwords
vault_postgresql_password: "{{ lookup('env', 'POSTGRESQL_PASSWORD') }}"
vault_redis_password: "{{ lookup('env', 'REDIS_PASSWORD') }}"

# Service Admin Passwords
vault_grafana_admin_password: "{{ lookup('env', 'GRAFANA_ADMIN_PASSWORD') }}"
vault_authentik_admin_password: "{{ lookup('env', 'AUTHENTIK_ADMIN_PASSWORD') }}"

# Service Secret Keys
vault_authentik_secret_key: "{{ lookup('env', 'AUTHENTIK_SECRET_KEY') }}"
vault_grafana_secret_key: "{{ lookup('env', 'GRAFANA_SECRET_KEY') }}"

# Cloudflare Configuration
vault_cloudflare_api_token: "{{ lookup('env', 'CLOUDFLARE_API_TOKEN') }}"
vault_cloudflare_email: "{{ lookup('env', 'CLOUDFLARE_EMAIL') }}"

# Optional: Traefik Pilot Token
vault_traefik_pilot_token: "{{ lookup('env', 'TRAEFIK_PILOT_TOKEN', default='') }}"

# Optional: SMTP Configuration
vault_smtp_username: "{{ lookup('env', 'SMTP_USERNAME', default='') }}"
vault_smtp_password: "{{ lookup('env', 'SMTP_PASSWORD', default='') }}"
vault_smtp_host: "{{ lookup('env', 'SMTP_HOST', default='') }}"
vault_smtp_port: "{{ lookup('env', 'SMTP_PORT', default='587') }}"
vault_smtp_from_address: "{{ lookup('env', 'SMTP_FROM_ADDRESS', default='') }}"
EOF
    
    print_status "Vault template created: group_vars/all/vault_template.yml"
}

# Function to create deployment script
create_deployment_script() {
    print_header "Creating Deployment Script"
    
    cat > deploy.sh << 'EOF'
#!/bin/bash

# Ansible Homelab Deployment Script
# This script will deploy your homelab infrastructure

set -e

# Colors for output
RED='\033[0;31m'
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

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Check if .env file exists
if [[ ! -f .env ]]; then
    print_error ".env file not found. Please run setup_environment.sh first."
    exit 1
fi

# Source environment variables
source .env

# Check if vault file exists
if [[ ! -f group_vars/all/vault.yml ]]; then
    print_error "Vault file not found. Please create it using:"
    echo "  cp group_vars/all/vault_template.yml group_vars/all/vault.yml"
    echo "  ansible-vault encrypt group_vars/all/vault.yml"
    exit 1
fi

print_header "Starting Homelab Deployment"

# Pre-flight checks
print_status "Running pre-flight checks..."
ansible-playbook site.yml --check --ask-vault-pass

# Deploy infrastructure
print_status "Deploying infrastructure..."
ansible-playbook site.yml --ask-vault-pass

# Run validation
print_status "Running validation tests..."
ansible-playbook tasks/validate_services.yml --ask-vault-pass

print_header "Deployment Complete!"
echo "Your homelab is now ready!"
echo ""
echo "Access your services:"
echo "  - Authentik: https://auth.$DOMAIN"
echo "  - Grafana: https://grafana.$DOMAIN"
echo "  - Sonarr: https://sonarr.$DOMAIN"
echo "  - Radarr: https://radarr.$DOMAIN"
echo "  - Jellyfin: https://jellyfin.$DOMAIN"
echo ""
echo "Check the Quick Start Guide for next steps."
EOF
    
    chmod +x deploy.sh
    print_status "Deployment script created: deploy.sh"
}

# Function to display summary
display_summary() {
    print_header "Setup Complete!"
    
    echo "Your Ansible Homelab environment has been configured successfully!"
    echo ""
    echo "Configuration Summary:"
    echo "  - Domain: $DOMAIN"
    echo "  - Server IP: $SERVER_IP"
    echo "  - Username: $USERNAME"
    echo "  - Timezone: $TIMEZONE"
    echo ""
    echo "Next Steps:"
    echo "  1. Configure DNS records for your domain"
    echo "  2. Create the vault file:"
    echo "     cp group_vars/all/vault_template.yml group_vars/all/vault.yml"
    echo "     ansible-vault encrypt group_vars/all/vault.yml"
    echo "  3. Run the deployment:"
    echo "     ./deploy.sh"
    echo ""
    echo "For detailed instructions, see QUICK_START_GUIDE.md"
}

# Main execution
main() {
    print_header "Ansible Homelab Setup"
    echo "This script will configure your environment for deployment."
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Get user input
    configure_basic_settings
    configure_network_settings
    configure_cloudflare
    configure_optional_services
    
    # Generate passwords
    generate_passwords
    
    # Create directories
    create_directories
    
    # Create configuration files
    create_env_file
    create_vault_template
    create_deployment_script
    
    # Display summary
    display_summary
}

# Run main function
main "$@" 