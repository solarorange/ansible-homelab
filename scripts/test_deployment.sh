#!/bin/bash

# Comprehensive Deployment Testing Script
# Tests all aspects of the Ansible Homelab deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN=$(grep HOMELAB_DOMAIN .env | cut -d'=' -f2)
ADMIN_EMAIL=$(grep ADMIN_EMAIL .env | cut -d'=' -f2)
TEST_TIMEOUT=30
RETRY_COUNT=3
RETRY_DELAY=10

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Ansible Homelab Deployment Testing${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to run tests
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "Testing $test_name... "
    
    if eval "$test_command" >/dev/null 2>&1; then
        if [ "$expected_result" = "success" ]; then
            echo -e "${GREEN}PASS${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            return 0
        else
            echo -e "${RED}FAIL${NC}"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            return 1
        fi
    else
        if [ "$expected_result" = "failure" ]; then
            echo -e "${GREEN}PASS${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            return 0
        else
            echo -e "${RED}FAIL${NC}"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            return 1
        fi
    fi
}

# Function to test HTTP endpoints
test_http_endpoint() {
    local service_name="$1"
    local url="$2"
    local expected_status="$3"
    
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout $TEST_TIMEOUT "$url" 2>/dev/null || echo "000")
    
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL (Status: $status_code)${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Function to test SSL certificates
test_ssl_certificate() {
    local domain="$1"
    
    local cert_valid=$(echo | openssl s_client -connect "${domain}:443" -servername "$domain" 2>/dev/null | openssl x509 -noout -checkend 0 >/dev/null 2>&1 && echo "valid" || echo "invalid")
    
    if [ "$cert_valid" = "valid" ]; then
        echo -e "${GREEN}PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

#==============================================================================
# INFRASTRUCTURE TESTS
#==============================================================================

echo -e "${YELLOW}Infrastructure Tests${NC}"
echo "========================"

# Test Docker installation
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Docker installation... "
if docker --version >/dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test Docker daemon
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Docker daemon... "
if docker info >/dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test network connectivity
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing internet connectivity... "
if curl -s --connect-timeout 10 https://www.google.com >/dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test DNS resolution
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing DNS resolution... "
if nslookup "$DOMAIN" >/dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test system resources
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing available disk space... "
AVAILABLE_GB=$(df -BG /opt/docker 2>/dev/null | tail -1 | awk '{print $4}' | sed 's/G//' || echo "0")
if [ "$AVAILABLE_GB" -ge 20 ]; then
    echo -e "${GREEN}PASS (${AVAILABLE_GB}GB available)${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL (${AVAILABLE_GB}GB available)${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""

#==============================================================================
# SECURITY TESTS
#==============================================================================

echo -e "${YELLOW}Security Tests${NC}"
echo "================"

# Test Traefik accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Traefik accessibility... "
test_http_endpoint "Traefik" "https://traefik.$DOMAIN" "200"

# Test Authentik accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Authentik accessibility... "
test_http_endpoint "Authentik" "https://auth.$DOMAIN" "200"

# Test Pi-hole accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Pi-hole accessibility... "
test_http_endpoint "Pi-hole" "https://dns.$DOMAIN" "200"

# Test SSL certificate for main domain
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing SSL certificate validity... "
test_ssl_certificate "$DOMAIN"

# Test SSL certificate for subdomains
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing SSL certificate for subdomains... "
test_ssl_certificate "traefik.$DOMAIN"

# Test firewall status
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing firewall status... "
if sudo ufw status | grep -q "Status: active"; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test fail2ban status
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing fail2ban status... "
if sudo fail2ban-client status >/dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""

#==============================================================================
# DATABASE TESTS
#==============================================================================

echo -e "${YELLOW}Database Tests${NC}"
echo "================"

# Test PostgreSQL connectivity
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing PostgreSQL connectivity... "
if timeout 10 bash -c "</dev/tcp/{{ ansible_default_ipv4.address }}/5432" 2>/dev/null; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test Redis connectivity
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Redis connectivity... "
if timeout 10 bash -c "</dev/tcp/{{ ansible_default_ipv4.address }}/6379" 2>/dev/null; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test MariaDB connectivity
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing MariaDB connectivity... "
if timeout 10 bash -c "</dev/tcp/{{ ansible_default_ipv4.address }}/3306" 2>/dev/null; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""

#==============================================================================
# MONITORING TESTS
#==============================================================================

echo -e "${YELLOW}Monitoring Tests${NC}"
echo "=================="

# Test Prometheus accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Prometheus accessibility... "
test_http_endpoint "Prometheus" "http://{{ ansible_default_ipv4.address }}:9090/-/healthy" "200"

# Test Grafana accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Grafana accessibility... "
test_http_endpoint "Grafana" "http://{{ ansible_default_ipv4.address }}:3000/api/health" "200"

# Test Loki accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Loki accessibility... "
test_http_endpoint "Loki" "http://{{ ansible_default_ipv4.address }}:3100/ready" "200"

# Test AlertManager accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing AlertManager accessibility... "
test_http_endpoint "AlertManager" "http://{{ ansible_default_ipv4.address }}:9093/-/healthy" "200"

echo ""

#==============================================================================
# MEDIA SERVICES TESTS
#==============================================================================

echo -e "${YELLOW}Media Services Tests${NC}"
echo "========================"

# Test Plex accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Plex accessibility... "
test_http_endpoint "Plex" "https://plex.$DOMAIN" "200"

# Test Jellyfin accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Jellyfin accessibility... "
test_http_endpoint "Jellyfin" "https://jellyfin.$DOMAIN" "200"

# Test Sonarr accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Sonarr accessibility... "
test_http_endpoint "Sonarr" "https://sonarr.$DOMAIN" "200"

# Test Radarr accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Radarr accessibility... "
test_http_endpoint "Radarr" "https://radarr.$DOMAIN" "200"

echo ""

#==============================================================================
# UTILITY SERVICES TESTS
#==============================================================================

echo -e "${YELLOW}Utility Services Tests${NC}"
echo "=========================="

# Test Portainer accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Portainer accessibility... "
test_http_endpoint "Portainer" "https://portainer.$DOMAIN" "200"

# Test Homepage accessibility
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing Homepage accessibility... "
test_http_endpoint "Homepage" "https://dash.$DOMAIN" "200"

# Test container health
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing container health... "
UNHEALTHY_CONTAINERS=$(docker ps --format "table {{.Names}}\t{{.Status}}" | grep -c "unhealthy\|restarting" || echo "0")
if [ "$UNHEALTHY_CONTAINERS" -eq 0 ]; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL ($UNHEALTHY_CONTAINERS unhealthy containers)${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""

#==============================================================================
# PERFORMANCE TESTS
#==============================================================================

echo -e "${YELLOW}Performance Tests${NC}"
echo "====================="

# Test system load
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing system load... "
LOAD_AVERAGE=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
LOAD_VALUE=$(echo "$LOAD_AVERAGE" | awk -F'.' '{print $1}')
if [ "$LOAD_VALUE" -lt 10 ]; then
    echo -e "${GREEN}PASS (Load: $LOAD_AVERAGE)${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL (Load: $LOAD_AVERAGE)${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test memory usage
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing memory usage... "
MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
if [ "$MEMORY_USAGE" -lt 90 ]; then
    echo -e "${GREEN}PASS (${MEMORY_USAGE}% used)${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL (${MEMORY_USAGE}% used)${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test disk usage
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing disk usage... "
DISK_USAGE=$(df /opt/docker | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 85 ]; then
    echo -e "${GREEN}PASS (${DISK_USAGE}% used)${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL (${DISK_USAGE}% used)${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""

#==============================================================================
# BACKUP TESTS
#==============================================================================

echo -e "${YELLOW}Backup Tests${NC}"
echo "=============="

# Test backup directory
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing backup directory... "
if [ -d "/opt/backups" ]; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test backup script
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo -n "Testing backup script... "
if [ -f "/opt/backups/backup.sh" ] && [ -x "/opt/backups/backup.sh" ]; then
    echo -e "${GREEN}PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

echo ""

#==============================================================================
# FINAL RESULTS
#==============================================================================

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Test Results Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Total Tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

# Calculate success rate
if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((TESTS_PASSED * 100 / TOTAL_TESTS))
    echo "Success Rate: $SUCCESS_RATE%"
    echo ""

    if [ $SUCCESS_RATE -ge 95 ]; then
        echo -e "${GREEN}✅ Deployment is healthy!${NC}"
        exit 0
    elif [ $SUCCESS_RATE -ge 80 ]; then
        echo -e "${YELLOW}⚠️  Deployment has minor issues${NC}"
        exit 1
    else
        echo -e "${RED}❌ Deployment has significant issues${NC}"
        exit 2
    fi
else
    echo -e "${RED}❌ No tests were executed${NC}"
    exit 3
fi 