#!/bin/bash

# Ansible Plugin Installation Script for HomelabOS
# This script installs all necessary Ansible plugins and collections

set -e

echo "🚀 Installing Ansible plugins and collections for HomelabOS..."

# Add Ansible to PATH
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# Create necessary directories
mkdir -p ~/.ansible/collections
mkdir -p ~/.ansible/plugins
mkdir -p ~/.ansible/cache

# Install Python dependencies for Ansible plugins
echo "📦 Installing Python dependencies..."
pip3 install --user \
    docker \
    kubernetes \
    openshift \
    jmespath \
    netaddr \
    dnspython \
    pymongo \
    psycopg2-binary \
    mysql-connector-python \
    prometheus-client \
    influxdb-client \
    elasticsearch \
    requests-kerberos \
    ldap3 \
    paramiko \
    boto3 \
    hvac \
    passlib \
    bcrypt \
    cryptography

# Install Ansible collections from requirements file
echo "🔧 Installing Ansible collections..."
if [ -f "collections/requirements.yml" ]; then
    ansible-galaxy collection install -r collections/requirements.yml
else
    echo "⚠️  collections/requirements.yml not found, installing core collections..."
    ansible-galaxy collection install community.docker
    ansible-galaxy collection install kubernetes.core
    ansible-galaxy collection install ansible.posix
    ansible-galaxy collection install ansible.utils
    ansible-galaxy collection install community.general
    ansible-galaxy collection install community.crypto
    ansible-galaxy collection install community.mysql
    ansible-galaxy collection install community.postgresql
fi

# Install additional useful collections
echo "📚 Installing additional collections..."
ansible-galaxy collection install community.aws
ansible-galaxy collection install community.grafana
ansible-galaxy collection install community.prometheus
ansible-galaxy collection install nginxinc.nginx_core

# Verify installation
echo "✅ Verifying installation..."
ansible --version
ansible-galaxy collection list

echo "🎉 Ansible plugins and collections installation complete!"
echo ""
echo "📋 Installed components:"
echo "   • Core Ansible modules"
echo "   • Docker management"
echo "   • Kubernetes management"
echo "   • Database management (MySQL, PostgreSQL, MongoDB)"
echo "   • Monitoring (Prometheus, Grafana, InfluxDB)"
echo "   • Security (LDAP, Kerberos, Crypto)"
echo "   • Network management"
echo "   • AWS integration"
echo "   • File and package management"
echo ""
echo "🔧 Next steps:"
echo "   1. Configure your inventory file"
echo "   2. Set up SSH keys for target servers"
echo "   3. Test connectivity with: ansible all -m ping"
echo "   4. Run your first playbook!"
