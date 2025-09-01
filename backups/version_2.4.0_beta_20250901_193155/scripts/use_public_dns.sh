#!/bin/bash
# Use Public DNS for Deployment
# Temporarily configures system to use public DNS servers

set -euo pipefail

PUBLIC_DNS=("8.8.8.8" "1.1.1.1")
BACKUP_FILE="/tmp/resolv.conf.backup"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

backup_current_dns() {
    log "Backing up current DNS configuration..."
    if [ -f "/etc/resolv.conf" ]; then
        sudo cp /etc/resolv.conf "$BACKUP_FILE"
        log "DNS configuration backed up to $BACKUP_FILE"
    fi
}

configure_public_dns() {
    log "Configuring system to use public DNS servers..."
    
    # Create new resolv.conf with public DNS
    sudo tee /etc/resolv.conf > /dev/null << EOF
# Public DNS configuration for homelab deployment
# Generated on $(date)
nameserver 8.8.8.8
nameserver 1.1.1.1
nameserver 208.67.222.222
EOF
    
    log "Public DNS configured"
}

restore_dns() {
    if [ -f "$BACKUP_FILE" ]; then
        log "Restoring original DNS configuration..."
        sudo cp "$BACKUP_FILE" /etc/resolv.conf
        sudo rm "$BACKUP_FILE"
        log "DNS configuration restored"
    fi
}

test_dns() {
    local domain="zorg.media"
    local expected_ip="192.168.1.10"
    
    log "Testing DNS resolution..."
    result=$(dig +short "$domain" | head -1)
    
    if [ "$result" = "$expected_ip" ]; then
        echo "✅ $domain → $result"
        return 0
    else
        echo "❌ $domain → $result (Expected: $expected_ip)"
        return 1
    fi
}

main() {
    log "Starting public DNS configuration"
    
    # Check if running on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log "Detected macOS - using scutil for DNS configuration"
        
        # Backup current DNS
        log "Backing up current DNS configuration..."
        sudo scutil --dns > /tmp/dns_backup.txt 2>/dev/null || true
        
        # Configure public DNS
        log "Configuring public DNS servers..."
        sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 1.1.1.1 208.67.222.222
        sudo networksetup -setdnsservers "USB 10/100/1000 LAN" 8.8.8.8 1.1.1.1 208.67.222.222
        
        log "Public DNS configured for macOS"
    else
        # Linux configuration
        backup_current_dns
        configure_public_dns
    fi
    
    # Test DNS resolution
    echo
    if test_dns; then
        log "✅ DNS is working correctly with public servers!"
        log "Ready for deployment"
        return 0
    else
        log "❌ DNS still not working"
        return 1
    fi
}

# Handle cleanup on script exit
cleanup() {
    if [ "${1:-}" = "restore" ]; then
        restore_dns
    fi
}

trap 'cleanup restore' EXIT

main "$@"
