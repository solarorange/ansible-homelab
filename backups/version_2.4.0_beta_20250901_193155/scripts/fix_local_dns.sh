#!/bin/bash
# Fix Local DNS Configuration
# Ensures local DNS servers can resolve zorg.media domain

set -euo pipefail

DOMAIN="zorg.media"
SERVER_IP="192.168.1.10"
LOCAL_DNS="192.168.1.35"
PUBLIC_DNS=("8.8.8.8" "1.1.1.1")

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

test_dns_resolution() {
    local dns_server=$1
    local domain=$2
    
    result=$(dig +short @$dns_server $domain 2>/dev/null | head -1)
    if [ "$result" = "$SERVER_IP" ]; then
        echo "✅ $domain → $result (via $dns_server)"
        return 0
    else
        echo "❌ $domain → $result (via $dns_server) - Expected: $SERVER_IP"
        return 1
    fi
}

fix_dns_configuration() {
    log "Attempting to fix local DNS configuration..."
    
    # Try to configure dnsmasq if it exists
    if ssh rob@$SERVER_IP "sudo systemctl status dnsmasq >/dev/null 2>&1"; then
        log "Found dnsmasq, configuring forwarders..."
        ssh rob@$SERVER_IP "sudo tee -a /etc/dnsmasq.conf << EOF
# Forward zorg.media to public DNS
server=/zorg.media/8.8.8.8
server=/zorg.media/1.1.1.1
EOF"
        ssh rob@$SERVER_IP "sudo systemctl restart dnsmasq"
        log "dnsmasq restarted"
        return 0
    fi
    
    # Try to configure systemd-resolved
    if ssh rob@$SERVER_IP "sudo systemctl status systemd-resolved >/dev/null 2>&1"; then
        log "Found systemd-resolved, configuring DNS servers..."
        ssh rob@$SERVER_IP "sudo tee /etc/systemd/resolved.conf << EOF
[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=208.67.222.222
EOF"
        ssh rob@$SERVER_IP "sudo systemctl restart systemd-resolved"
        log "systemd-resolved restarted"
        return 0
    fi
    
    log "No standard DNS service found, cannot auto-configure"
    return 1
}

main() {
    log "Starting DNS configuration fix"
    log "Domain: $DOMAIN"
    log "Expected IP: $SERVER_IP"
    log "Local DNS: $LOCAL_DNS"
    
    echo
    log "Testing current DNS resolution..."
    
    # Test public DNS first
    echo "=== Public DNS Servers ==="
    for dns in "${PUBLIC_DNS[@]}"; do
        test_dns_resolution "$dns" "$DOMAIN"
    done
    
    echo
    echo "=== Local DNS Server ==="
    if test_dns_resolution "$LOCAL_DNS" "$DOMAIN"; then
        log "✅ Local DNS is working correctly!"
        return 0
    else
        log "❌ Local DNS needs configuration"
        
        echo
        log "Attempting to fix local DNS configuration..."
        if fix_dns_configuration; then
            log "Waiting for DNS changes to take effect..."
            sleep 10
            
            echo
            log "Testing local DNS after fix..."
            if test_dns_resolution "$LOCAL_DNS" "$DOMAIN"; then
                log "✅ Local DNS fixed successfully!"
                return 0
            else
                log "❌ Local DNS fix failed"
                log "Recommendation: Use public DNS servers for deployment"
                return 1
            fi
        else
            log "❌ Could not configure local DNS"
            log "Recommendation: Use public DNS servers for deployment"
            return 1
        fi
    fi
}

main "$@"
