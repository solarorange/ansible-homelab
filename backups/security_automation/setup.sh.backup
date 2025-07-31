#!/bin/bash

# Enhanced setup script for Ansible Watchtower
# This script automates initial configuration and setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[-]${NC} $1"
}

# Function to validate IP address
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a ip_parts <<< "$ip"
        for part in "${ip_parts[@]}"; do
            if [ "$part" -gt 255 ] || [ "$part" -lt 0 ]; then
                return 1
            fi
        done
        return 0
    fi
    return 1
}

# Function to validate domain name
validate_domain() {
    local domain=$1
    if [[ $domain =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
        return 0
    fi
    return 1
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run as root"
    exit 1
fi

# Check for required commands
for cmd in ansible ansible-galaxy python3 pip curl jq; do
    if ! command -v $cmd &> /dev/null; then
        print_error "$cmd is not installed"
        exit 1
    fi
done

# Create necessary directories
print_status "Creating necessary directories"
mkdir -p group_vars/all
mkdir -p inventory
mkdir -p tasks
mkdir -p handlers
mkdir -p templates
mkdir -p scripts
mkdir -p .ansible/cache/facts

# Install required collections and roles
print_status "Installing required collections and roles"
ansible-galaxy collection install -r requirements.yml
ansible-galaxy role install -r requirements.yml

# Interactive configuration
print_status "Starting interactive configuration"

# Proxmox Configuration
read -p "Enter Proxmox hostname or IP: " proxmox_host
while ! validate_ip "$proxmox_host" && ! validate_domain "$proxmox_host"; do
    print_warning "Invalid hostname or IP"
    read -p "Enter Proxmox hostname or IP: " proxmox_host
done

read -p "Enter Proxmox user (default: root@pam): " proxmox_user
proxmox_user=${proxmox_user:-root@pam}

read -sp "Enter Proxmox password: " proxmox_password
echo

# Network Configuration
domain_name="zorg.media"
network_subnet=${network_subnet:-192.168.40.0/24}
gateway_ip=${gateway_ip:-192.168.40.1}

# Create Proxmox vault file
print_status "Creating Proxmox vault file"
cat > group_vars/all/proxmox_vault.yml << EOF
---
# Proxmox API Configuration
proxmox_host: "$proxmox_host"
proxmox_user: "$proxmox_user"
proxmox_password: "$proxmox_password"
proxmox_validate_certs: true
EOF

# Encrypt vault file
ansible-vault encrypt group_vars/all/proxmox_vault.yml
print_status "Proxmox vault file created and encrypted"

# Create network variables file
print_status "Creating network variables file"
cat > group_vars/all/network.yml << EOF
---
# Network Configuration
network:
  domain: "$domain_name"
  subnet: "$network_subnet"
  gateway: "$gateway_ip"
  dns_servers:
    - "8.8.8.8"
    - "8.8.4.4"
EOF

# Create inventory file
print_status "Creating inventory file"
cat > inventory/hosts.yml << EOF
---
all:
  children:
    proxmox:
      hosts:
        proxmox:
          ansible_host: "$proxmox_host"
          proxmox_host: "$proxmox_host"
          proxmox_user: "$proxmox_user"
          deploy_proxmox_vm: true
EOF

# Create ansible.cfg
print_status "Creating ansible.cfg"
cat > ansible.cfg << EOF
[defaults]
inventory = inventory/hosts.yml
remote_user = root
private_key_file = ~/.ssh/watchtower_key
host_key_checking = False
retry_files_enabled = False
nocows = 1
gathering = smart
fact_caching = jsonfile
fact_caching_timeout = 3600
fact_caching_connection = ~/.ansible/cache/facts
fact_caching_prefix = ansible_facts_

[ssh_connection]
pipelining = True
EOF

# Generate SSH key if it doesn't exist
if [ ! -f "$HOME/.ssh/watchtower_key" ]; then
    print_status "Generating SSH key for Watchtower"
    ssh-keygen -t ed25519 -f "$HOME/.ssh/watchtower_key" -N ""
    print_status "SSH key generated"
fi

# Create validation script
print_status "Creating validation script"
cat > scripts/validate.sh << 'EOF'
#!/bin/bash

# Validation script for Ansible Watchtower
# This script validates the configuration before deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[-]${NC} $1"
}

# Check required files
required_files=(
    "inventory/hosts.yml"
    "group_vars/all/proxmox_vault.yml"
    "group_vars/all/network.yml"
    "ansible.cfg"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        print_error "Missing required file: $file"
        exit 1
    fi
done

# Validate Proxmox connection
print_status "Validating Proxmox connection"
if ! ansible-playbook main.yml --tags setup --check &> /dev/null; then
    print_error "Failed to connect to Proxmox"
    exit 1
fi

# Validate network configuration
print_status "Validating network configuration"
if ! ansible-playbook main.yml --tags network --check &> /dev/null; then
    print_error "Network configuration validation failed"
    exit 1
fi

print_status "All validations passed successfully"
EOF

chmod +x scripts/validate.sh

print_status "Setup completed successfully"
print_status "Next steps:"
echo "1. Review the generated configuration files"
echo "2. Run the validation script: ./scripts/validate.sh"
echo "3. If validation passes, run the playbook: ansible-playbook main.yml" 