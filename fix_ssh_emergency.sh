#!/bin/bash

# Emergency SSH Access Fix Script
# This script fixes SSH access issues caused by firewall configuration

echo "Emergency SSH Access Fix"
echo "========================"

# Check if we can reach the server
echo "Testing connectivity to 192.168.1.10..."
if ping -c 1 192.168.1.10 >/dev/null 2>&1; then
    echo "✓ Server is reachable"
else
    echo "✗ Cannot reach server - this may be a network issue"
    exit 1
fi

# Try to connect and fix firewall
echo "Attempting to fix SSH access..."

# Method 1: Try direct SSH with different options
echo "Method 1: Testing SSH connection..."
ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null rob@192.168.1.10 "echo 'SSH test successful'" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ SSH is working!"
    echo "Running firewall fix..."
    ssh -o ConnectTimeout=10 rob@192.168.1.10 << 'EOF'
        echo "Fixing firewall rules..."
        sudo ufw --force reset
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow 22/tcp comment "SSH access"
        sudo ufw allow 80/tcp comment "HTTP"
        sudo ufw allow 443/tcp comment "HTTPS"
        sudo ufw --force enable
        echo "Firewall rules fixed"
EOF
    echo "✓ SSH access restored!"
else
    echo "✗ SSH connection failed"
    echo "This may require physical access to the server to fix"
fi

