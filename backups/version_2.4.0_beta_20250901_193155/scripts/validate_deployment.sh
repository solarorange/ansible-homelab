#!/bin/bash
# Post-Deployment Validation Script
# Tests the actual functionality of deployed homelab services

set -euo pipefail

# Load environment variables
source .env

DOMAIN="${HOMELAB_DOMAIN:-zorg.media}"
SERVER_IP="${HOMELAB_IP_ADDRESS:-192.168.1.10}"
SSH_USER="${TARGET_SSH_USER:-rob}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

test_ssh_connection() {
    log "Testing SSH connection to $SSH_USER@$SERVER_IP..."
    if ssh -o ConnectTimeout=10 -o BatchMode=yes "$SSH_USER@$SERVER_IP" "echo 'SSH connection successful'" 2>/dev/null; then
        success "SSH connection working"
        return 0
    else
        error "SSH connection failed"
        return 1
    fi
}

test_docker_services() {
    log "Testing Docker services..."
    
    # Get list of running containers
    containers=$(ssh "$SSH_USER@$SERVER_IP" "docker ps --format '{{.Names}}' 2>/dev/null" || echo "")
    
    if [ -z "$containers" ]; then
        error "No Docker containers running"
        return 1
    fi
    
    success "Found $(echo "$containers" | wc -l) running containers"
    echo "$containers" | while read container; do
        if [ -n "$container" ]; then
            log "  - $container"
        fi
    done
    
    return 0
}

test_traefik() {
    log "Testing Traefik reverse proxy..."
    
    # Test Traefik dashboard
    if curl -s -f "https://traefik.$DOMAIN" >/dev/null 2>&1; then
        success "Traefik dashboard accessible"
    else
        warning "Traefik dashboard not accessible"
    fi
    
    # Test Traefik API
    if curl -s -f "https://traefik.$DOMAIN/api/http/routers" >/dev/null 2>&1; then
        success "Traefik API responding"
    else
        warning "Traefik API not responding"
    fi
}

test_authentication() {
    log "Testing authentication service..."
    
    # Test auth service endpoint
    if curl -s -f "https://auth.$DOMAIN/health" >/dev/null 2>&1; then
        success "Authentication service responding"
    else
        warning "Authentication service not responding"
    fi
}

test_media_services() {
    log "Testing media services..."
    
    local services=("sonarr" "radarr" "jellyfin")
    local failed=0
    
    for service in "${services[@]}"; do
        if curl -s -f "https://$service.$DOMAIN" >/dev/null 2>&1; then
            success "$service accessible"
        else
            warning "$service not accessible"
            failed=$((failed + 1))
        fi
    done
    
    return $failed
}

test_monitoring_services() {
    log "Testing monitoring services..."
    
    # Test Grafana
    if curl -s -f "https://grafana.$DOMAIN" >/dev/null 2>&1; then
        success "Grafana accessible"
    else
        warning "Grafana not accessible"
    fi
    
    # Test Prometheus
    if curl -s -f "https://dash.$DOMAIN" >/dev/null 2>&1; then
        success "Prometheus dashboard accessible"
    else
        warning "Prometheus dashboard not accessible"
    fi
}

test_ssl_certificates() {
    log "Testing SSL certificates..."
    
    local domains=("$DOMAIN" "traefik.$DOMAIN" "auth.$DOMAIN" "sonarr.$DOMAIN" "radarr.$DOMAIN" "jellyfin.$DOMAIN")
    local failed=0
    
    for domain in "${domains[@]}"; do
        if openssl s_client -connect "$domain:443" -servername "$domain" </dev/null 2>/dev/null | grep -q "Verify return code: 0"; then
            success "SSL certificate valid for $domain"
        else
            warning "SSL certificate issue for $domain"
            failed=$((failed + 1))
        fi
    done
    
    return $failed
}

test_backup_functionality() {
    log "Testing backup functionality..."
    
    # Check if backup directories exist
    if ssh "$SSH_USER@$SERVER_IP" "[ -d /var/backups ]" 2>/dev/null; then
        success "Backup directory exists"
    else
        warning "Backup directory missing"
    fi
    
    # Check if backup script exists
    if ssh "$SSH_USER@$SERVER_IP" "[ -f /var/backups/ansible/scripts/backup.sh ]" 2>/dev/null; then
        success "Backup script exists"
    else
        warning "Backup script missing"
    fi
    
    # Check if monitoring script exists
    if ssh "$SSH_USER@$SERVER_IP" "[ -f /var/backups/ansible/scripts/monitor_backups.sh ]" 2>/dev/null; then
        success "Backup monitoring script exists"
    else
        warning "Backup monitoring script missing"
    fi
}

test_system_resources() {
    log "Testing system resources..."
    
    # Get system info
    local disk_usage=$(ssh "$SSH_USER@$SERVER_IP" "df / | awk 'NR==2 {print \$5}' | sed 's/%//'" 2>/dev/null || echo "0")
    local memory_usage=$(ssh "$SSH_USER@$SERVER_IP" "free | grep Mem | awk '{printf \"%.1f\", \$3/\$2 * 100.0}'" 2>/dev/null || echo "0")
    local load_avg=$(ssh "$SSH_USER@$SERVER_IP" "uptime | awk -F'load average:' '{print \$2}' | awk '{print \$1}' | sed 's/,//'" 2>/dev/null || echo "0")
    
    log "System resources:"
    log "  - Disk usage: ${disk_usage}%"
    log "  - Memory usage: ${memory_usage}%"
    log "  - Load average: ${load_avg}"
    
    # Check for resource issues
    if [ "${disk_usage:-0}" -gt 85 ]; then
        warning "High disk usage: ${disk_usage}%"
    else
        success "Disk usage acceptable"
    fi
    
    if [ "${memory_usage%.*}" -gt 85 ]; then
        warning "High memory usage: ${memory_usage}%"
    else
        success "Memory usage acceptable"
    fi
}

test_service_integration() {
    log "Testing service integration..."
    
    # Test if services can communicate
    local integration_tests=0
    local total_tests=0
    
    # Test Traefik routing
    total_tests=$((total_tests + 1))
    if curl -s -f "https://$DOMAIN" >/dev/null 2>&1; then
        success "Main domain routing working"
        integration_tests=$((integration_tests + 1))
    else
        warning "Main domain routing failed"
    fi
    
    # Test subdomain routing
    total_tests=$((total_tests + 1))
    if curl -s -f "https://traefik.$DOMAIN" >/dev/null 2>&1; then
        success "Subdomain routing working"
        integration_tests=$((integration_tests + 1))
    else
        warning "Subdomain routing failed"
    fi
    
    log "Integration tests: $integration_tests/$total_tests passed"
    return $((total_tests - integration_tests))
}

generate_validation_report() {
    log "Generating validation report..."
    
    local report_file="/tmp/homelab_validation_$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$report_file" << EOF
Homelab Deployment Validation Report
Generated: $(date)
Domain: $DOMAIN
Server: $SERVER_IP

=== VALIDATION RESULTS ===

SSH Connection: $(test_ssh_connection && echo "PASS" || echo "FAIL")
Docker Services: $(test_docker_services && echo "PASS" || echo "FAIL")
Traefik: $(test_traefik && echo "PASS" || echo "FAIL")
Authentication: $(test_authentication && echo "PASS" || echo "FAIL")
Media Services: $(test_media_services && echo "PASS" || echo "FAIL")
Monitoring: $(test_monitoring_services && echo "PASS" || echo "FAIL")
SSL Certificates: $(test_ssl_certificates && echo "PASS" || echo "FAIL")
Backup System: $(test_backup_functionality && echo "PASS" || echo "FAIL")
System Resources: $(test_system_resources && echo "PASS" || echo "FAIL")
Service Integration: $(test_service_integration && echo "PASS" || echo "FAIL")

=== RECOMMENDATIONS ===
$(generate_recommendations)

EOF
    
    success "Validation report saved to: $report_file"
    cat "$report_file"
}

generate_recommendations() {
    echo "Based on validation results:"
    echo "1. Review any FAILED tests above"
    echo "2. Check service logs for errors"
    echo "3. Verify DNS resolution for all subdomains"
    echo "4. Test user workflows manually"
    echo "5. Monitor system resources during usage"
}

main() {
    log "Starting comprehensive homelab deployment validation"
    log "Domain: $DOMAIN"
    log "Server: $SERVER_IP"
    log "SSH User: $SSH_USER"
    echo
    
    # Run all validation tests
    test_ssh_connection
    test_docker_services
    test_traefik
    test_authentication
    test_media_services
    test_monitoring_services
    test_ssl_certificates
    test_backup_functionality
    test_system_resources
    test_service_integration
    
    echo
    generate_validation_report
    
    log "Validation complete!"
}

main "$@" 