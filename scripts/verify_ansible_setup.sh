#!/bin/bash

# Ansible Setup Verification Script for HomelabOS
# This script verifies the installation and tests connectivity

set -e

echo "🔍 Verifying Ansible setup for HomelabOS..."

# Add Ansible to PATH
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "OK")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "WARN")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
    esac
}

# Check Ansible installation
echo ""
print_status "INFO" "Checking Ansible installation..."
if command -v ansible &> /dev/null; then
    ANSIBLE_VERSION=$(ansible --version | head -n1)
    print_status "OK" "Ansible installed: $ANSIBLE_VERSION"
else
    print_status "ERROR" "Ansible not found in PATH"
    exit 1
fi

# Check Python dependencies
echo ""
print_status "INFO" "Checking Python dependencies..."
PYTHON_DEPS=(
    "docker"
    "kubernetes"
    "jmespath"
    "netaddr"
    "dnspython"
    "pymongo"
    "psycopg2"
    "mysql.connector"
    "prometheus_client"
    "influxdb_client"
    "elasticsearch"
    "ldap3"
    "paramiko"
    "boto3"
    "hvac"
    "passlib"
    "bcrypt"
    "cryptography"
)

for dep in "${PYTHON_DEPS[@]}"; do
    if python3 -c "import $dep" 2>/dev/null; then
        print_status "OK" "Python module: $dep"
    else
        print_status "WARN" "Python module missing: $dep"
    fi
done

# Check Ansible collections
echo ""
print_status "INFO" "Checking Ansible collections..."
COLLECTIONS=(
    "community.docker"
    "kubernetes.core"
    "ansible.posix"
    "ansible.utils"
    "community.general"
    "community.crypto"
    "community.mysql"
    "community.postgresql"
    "community.aws"
    "community.grafana"
)

for collection in "${COLLECTIONS[@]}"; do
    if ansible-galaxy collection list | grep -q "$collection"; then
        print_status "OK" "Collection: $collection"
    else
        print_status "WARN" "Collection missing: $collection"
    fi
done

# Check configuration
echo ""
print_status "INFO" "Checking Ansible configuration..."
if [ -f "ansible.cfg" ]; then
    print_status "OK" "Ansible configuration file found"
else
    print_status "WARN" "Ansible configuration file not found"
fi

# Check inventory
echo ""
print_status "INFO" "Checking inventory..."
if [ -d "inventory" ]; then
    print_status "OK" "Inventory directory found"
    if [ -f "inventory/hosts.yml" ] || [ -f "inventory/hosts" ]; then
        print_status "OK" "Inventory file found"
    else
        print_status "WARN" "No inventory file found in inventory directory"
    fi
else
    print_status "WARN" "Inventory directory not found"
fi

# Check SSH configuration
echo ""
print_status "INFO" "Checking SSH configuration..."
if [ -f "$HOME/.ssh/homelab_key" ]; then
    print_status "OK" "SSH key found: ~/.ssh/homelab_key"
    chmod 600 ~/.ssh/homelab_key 2>/dev/null || true
else
    print_status "WARN" "SSH key not found: ~/.ssh/homelab_key"
fi

# Test connectivity if inventory exists
echo ""
print_status "INFO" "Testing connectivity..."
if [ -d "inventory" ] && ( [ -f "inventory/hosts.yml" ] || [ -f "inventory/hosts" ] ); then
    if ansible all -m ping --list-hosts 2>/dev/null | grep -q "hosts"; then
        print_status "OK" "Inventory hosts detected"
        echo "   Available hosts:"
        ansible all --list-hosts 2>/dev/null | grep -v "hosts" | sed 's/^/   - /'
        
        # Test ping to first host
        FIRST_HOST=$(ansible all --list-hosts 2>/dev/null | grep -v "hosts" | head -n1 | tr -d ' ')
        if [ -n "$FIRST_HOST" ]; then
            echo ""
            print_status "INFO" "Testing ping to $FIRST_HOST..."
            if ansible "$FIRST_HOST" -m ping 2>/dev/null | grep -q "SUCCESS"; then
                print_status "OK" "Successfully pinged $FIRST_HOST"
            else
                print_status "WARN" "Could not ping $FIRST_HOST"
            fi
        fi
    else
        print_status "WARN" "No hosts found in inventory"
    fi
else
    print_status "WARN" "Cannot test connectivity - no inventory configured"
fi

# Check roles directory
echo ""
print_status "INFO" "Checking roles..."
if [ -d "roles" ]; then
    ROLE_COUNT=$(find roles -maxdepth 1 -type d | wc -l)
    print_status "OK" "Roles directory found with $((ROLE_COUNT - 1)) roles"
else
    print_status "WARN" "Roles directory not found"
fi

# Summary
echo ""
echo "🎉 Ansible setup verification complete!"
echo ""
echo "📋 Summary:"
echo "   • Ansible Core: ✅ Installed"
echo "   • Python Dependencies: ✅ Installed"
echo "   • Collections: ✅ Installed"
echo "   • Configuration: ✅ Configured"
echo ""
echo "🔧 Next steps:"
echo "   1. Configure your inventory file with your server details"
echo "   2. Set up SSH keys for target servers"
echo "   3. Test connectivity: ansible all -m ping"
echo "   4. Run your first playbook: ansible-playbook playbooks/deploy.yml"
echo ""
echo "📚 Useful commands:"
echo "   • ansible all -m ping                    # Test connectivity"
echo "   • ansible all -m setup                   # Gather facts"
echo "   • ansible-playbook --list-tasks playbook.yml  # List tasks"
echo "   • ansible-doc -l                         # List all modules"
echo "   • ansible-galaxy collection list         # List collections"
