#!/bin/bash
# DNS Verification Script
# Tests all homelab domains from multiple DNS servers

set -euo pipefail

DOMAIN="zorg.media"
SERVER_IP="192.168.1.10"
DNS_SERVERS=("8.8.8.8" "1.1.1.1" "208.67.222.222" "192.168.1.35" "192.168.1.10")

# List of all subdomains to test
SUBDOMAINS=(
    "zorg.media"
    "traefik.zorg.media"
    "auth.zorg.media"
    "grafana.zorg.media"
    "dash.zorg.media"
    "sonarr.zorg.media"
    "radarr.zorg.media"
    "jellyfin.zorg.media"
    "vault.zorg.media"
    "cloud.zorg.media"
)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

test_domain() {
    local domain=$1
    local dns_server=$2
    
    result=$(nslookup "$domain" "$dns_server" 2>/dev/null | grep "Address:" | tail -1 | awk '{print $2}')
    
    if [ "$result" = "$SERVER_IP" ]; then
        echo "✅ $domain → $result (via $dns_server)"
        return 0
    else
        echo "❌ $domain → $result (via $dns_server) - Expected: $SERVER_IP"
        return 1
    fi
}

test_all_domains() {
    local dns_server=$1
    local failed=0
    
    log "Testing all domains via $dns_server..."
    
    for subdomain in "${SUBDOMAINS[@]}"; do
        if ! test_domain "$subdomain" "$dns_server"; then
            failed=$((failed + 1))
        fi
    done
    
    return $failed
}

main() {
    log "Starting comprehensive DNS verification"
    log "Domain: $DOMAIN"
    log "Expected IP: $SERVER_IP"
    log "Testing ${#SUBDOMAINS[@]} subdomains via ${#DNS_SERVERS[@]} DNS servers"
    echo
    
    total_failed=0
    
    for dns_server in "${DNS_SERVERS[@]}"; do
        echo "=== Testing via $dns_server ==="
        if test_all_domains "$dns_server"; then
            log "✅ All domains resolved correctly via $dns_server"
        else
            log "❌ Some domains failed via $dns_server"
            total_failed=$((total_failed + 1))
        fi
        echo
    done
    
    echo "=== DNS Verification Summary ==="
    if [ $total_failed -eq 0 ]; then
        log "🎉 ALL DNS SERVERS ARE WORKING CORRECTLY!"
        log "DNS is rock solid and ready for production deployment"
        exit 0
    else
        log "⚠️  Some DNS servers have issues"
        log "Recommendation: Use public DNS servers (8.8.8.8, 1.1.1.1) for deployment"
        exit 1
    fi
}

main "$@"
