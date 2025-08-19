#!/bin/bash
# Production-Ready Homelab Deployment Script
# Addresses all known issues and provides bulletproof deployment

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}[STEP $1]${NC} $2"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Step 1: Validate Environment
print_step "1" "Validating environment and prerequisites..."

# Check if we're in the right directory
if [[ ! -f "main.yml" ]]; then
    print_error "Not in ansible_homelab directory. Please run from project root."
    exit 1
fi

# Load .env if it exists
if [[ -f ".env" ]]; then
    print_success "Loading .env file..."
    set -a && source .env && set +a
else
    print_warning "No .env file found. Will prompt for all values."
fi

# Step 2: Validate Required Variables
print_step "2" "Validating required configuration..."

# Check critical variables
if [[ -z "${HOMELAB_IP_ADDRESS:-}" ]]; then
    print_error "HOMELAB_IP_ADDRESS not set in .env"
    exit 1
fi

if [[ -z "${TARGET_SSH_USER:-}" ]]; then
    print_error "TARGET_SSH_USER not set in .env"
    exit 1
fi

if [[ -z "${HOMELAB_DOMAIN:-}" ]]; then
    print_error "HOMELAB_DOMAIN not set in .env"
    exit 1
fi

print_success "Configuration validated"

# Step 3: Test SSH Connectivity
print_step "3" "Testing SSH connectivity..."

# Test basic SSH connection
if ! ssh -o ConnectTimeout=10 -o BatchMode=yes -o PasswordAuthentication=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "echo 'SSH test successful'" 2>/dev/null; then
    print_warning "SSH key authentication failed"
    
    # Try password-based SSH if password is provided
    if [[ -n "${TARGET_SSH_PASSWORD:-}" ]]; then
        print_success "Attempting password-based SSH key installation..."
        
        if command -v sshpass >/dev/null 2>&1; then
            # Install SSH key using password
            sshpass -p "$TARGET_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" 'mkdir -p ~/.ssh && chmod 700 ~/.ssh' || true
            sshpass -p "$TARGET_SSH_PASSWORD" scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS:/tmp/id_rsa.pub" || true
            sshpass -p "$TARGET_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" 'cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub' || true
            
            # Test again
            if ssh -o ConnectTimeout=10 -o BatchMode=yes -o PasswordAuthentication=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "echo 'SSH key installed successfully'" 2>/dev/null; then
                print_success "SSH key installed and working"
            else
                print_error "SSH key installation failed"
                exit 1
            fi
        else
            print_error "sshpass not available. Please install it or run ssh-copy-id manually."
            exit 1
        fi
    else
        print_error "No SSH password provided and key authentication failed"
        exit 1
    fi
else
    print_success "SSH connectivity verified"
fi

# Step 4: Create Clean Inventory
print_step "4" "Creating clean inventory file..."

cat > inventory.yml << EOF
---
all:
  hosts:
    homelab-server:
      ansible_host: $HOMELAB_IP_ADDRESS
      ansible_user: $TARGET_SSH_USER
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
      ansible_python_interpreter: /usr/bin/python3
      ansible_ssh_common_args: "-o BatchMode=yes -o PasswordAuthentication=no"
EOF

print_success "Inventory file created"

# Step 5: Create Ansible Configuration
print_step "5" "Creating Ansible configuration..."

cat > ansible.cfg << EOF
[defaults]
inventory = inventory.yml
host_key_checking = False
timeout = 30
gathering = smart

[privilege_escalation]
become = True
become_method = sudo
become_ask_pass = False
become_user = root
EOF

print_success "Ansible configuration created"

# Step 6: Create Vault Password File
print_step "6" "Creating vault password file..."

# Generate a secure vault password
VAULT_PASSWORD=$(openssl rand -base64 32)
echo "$VAULT_PASSWORD" > .vault_password
chmod 600 .vault_password
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password

print_success "Vault password file created"

# Step 7: Test Ansible Connectivity
print_step "7" "Testing Ansible connectivity..."

if ansible all -m ping; then
    print_success "Ansible connectivity verified"
else
    print_error "Ansible connectivity test failed"
    exit 1
fi

# Step 8: Run Seamless Setup
print_step "8" "Running seamless setup..."

# Set environment variables for non-interactive mode
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

# Run the seamless setup script
./scripts/seamless_setup.sh --non-interactive

print_success "Production deployment completed successfully!"
