#!/bin/bash
# Test script for seamless setup - minimal configuration

set -euo pipefail

echo "🧪 Testing Seamless Setup Configuration"

# Check if we're in the right directory
if [[ ! -f "main.yml" ]]; then
    echo "❌ Not in ansible_homelab directory"
    exit 1
fi

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo "❌ .env file not found. Please create it from env.template"
    exit 1
fi

# Load environment
set -a && source .env && set +a

echo "✅ Environment loaded"
echo "   IP: $HOMELAB_IP_ADDRESS"
echo "   User: $TARGET_SSH_USER"
echo "   Domain: $HOMELAB_DOMAIN"

# Test SSH connectivity
echo "🔑 Testing SSH connectivity..."
if ssh -o ConnectTimeout=10 -o BatchMode=yes -o PasswordAuthentication=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "echo 'SSH working'" 2>/dev/null; then
    echo "✅ SSH connectivity verified"
else
    echo "⚠️  SSH key authentication failed"
    if [[ -n "${TARGET_SSH_PASSWORD:-}" ]]; then
        echo "🔄 Attempting password-based SSH key installation..."
        if command -v sshpass >/dev/null 2>&1; then
            sshpass -p "$TARGET_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" 'mkdir -p ~/.ssh && chmod 700 ~/.ssh' || true
            sshpass -p "$TARGET_SSH_PASSWORD" scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS:/tmp/id_rsa.pub" || true
            sshpass -p "$TARGET_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" 'cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub' || true
            
            if ssh -o ConnectTimeout=10 -o BatchMode=yes -o PasswordAuthentication=no "$TARGET_SSH_USER@$HOMELAB_IP_ADDRESS" "echo 'SSH key installed'" 2>/dev/null; then
                echo "✅ SSH key installed successfully"
            else
                echo "❌ SSH key installation failed"
                exit 1
            fi
        else
            echo "❌ sshpass not available"
            exit 1
        fi
    else
        echo "❌ No SSH password provided"
        exit 1
    fi
fi

# Test seamless setup
echo "🚀 Testing seamless setup..."
export INTERACTIVE=0
./scripts/seamless_setup.sh --non-interactive

echo "✅ Seamless setup test completed successfully!"
