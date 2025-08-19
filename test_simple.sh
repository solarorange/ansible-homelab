#!/bin/bash

# Simple test script to verify basic functionality

set -euo pipefail

echo "=== Simple Test Script ==="

# Load .env file
if [ -f ".env" ]; then
    echo "Loading .env file..."
    set -a && source .env && set +a
    echo "TARGET_SSH_USER: $TARGET_SSH_USER"
    echo "TARGET_SSH_PASSWORD: ${TARGET_SSH_PASSWORD:0:3}***"
else
    echo "No .env file found"
    exit 1
fi

# Test SSH connectivity
echo "Testing SSH connectivity..."
if ssh -o ConnectTimeout=10 -o BatchMode=yes -o PasswordAuthentication=no "$TARGET_SSH_USER@192.168.1.19" "echo 'SSH test successful'" 2>/dev/null; then
    echo "✓ SSH connectivity works"
else
    echo "✗ SSH connectivity failed"
fi

# Test Ansible connectivity
echo "Testing Ansible connectivity..."
if ansible all -m ping 2>/dev/null; then
    echo "✓ Ansible connectivity works"
else
    echo "✗ Ansible connectivity failed"
fi

echo "=== Test Complete ==="
