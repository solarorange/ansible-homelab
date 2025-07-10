#!/bin/bash

# Monitoring Thresholds Setup Script
# Interactive setup for configuring monitoring thresholds

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file
THRESHOLDS_FILE="group_vars/all/monitoring_thresholds.yml"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Homelab Monitoring Thresholds Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to prompt for input with default
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        input=${input:-$default}
    else
        read -p "$prompt: " input
    fi
    
    echo "$input"
}

# Function to update thresholds file
update_threshold() {
    local section="$1"
    local key="$2"
    local value="$3"
    
    if [ -n "$value" ]; then
        # Use yq to update the YAML file
        if command -v yq &> /dev/null; then
            yq eval ".monitoring_thresholds.$section.$key = $value" -i "$THRESHOLDS_FILE"
        else
            # Fallback to sed if yq is not available
            sed -i "s/^      $key:.*/      $key: $value/" "$THRESHOLDS_FILE"
        fi
        echo -e "${GREEN}✓ Updated $section.$key = $value${NC}"
    fi
}

# Function to print error messages
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo -e "${YELLOW}Setting up monitoring thresholds...${NC}"
echo ""

# System Resource Thresholds
echo -e "${BLUE}=== System Resource Thresholds ===${NC}"

# CPU thresholds
cpu_warning=$(prompt_with_default "CPU Warning Threshold (%)" "80" "cpu_warning")
cpu_critical=$(prompt_with_default "CPU Critical Threshold (%)" "90" "cpu_critical")
load_warning=$(prompt_with_default "Load Average Warning" "2.0" "load_warning")
load_critical=$(prompt_with_default "Load Average Critical" "5.0" "load_critical")

update_threshold "system.cpu" "warning" "$cpu_warning"
update_threshold "system.cpu" "critical" "$cpu_critical"
update_threshold "system.cpu.load_average" "warning" "$load_warning"
update_threshold "system.cpu.load_average" "critical" "$load_critical"

# Memory thresholds
memory_warning=$(prompt_with_default "Memory Warning Threshold (%)" "85" "memory_warning")
memory_critical=$(prompt_with_default "Memory Critical Threshold (%)" "95" "memory_critical")
swap_warning=$(prompt_with_default "Swap Warning Threshold (%)" "50" "swap_warning")
swap_critical=$(prompt_with_default "Swap Critical Threshold (%)" "80" "swap_critical")

update_threshold "system.memory" "warning" "$memory_warning"
update_threshold "system.memory" "critical" "$memory_critical"
update_threshold "system.memory.swap" "warning" "$swap_warning"
update_threshold "system.memory.swap" "critical" "$swap_critical"

# Disk thresholds
disk_warning=$(prompt_with_default "Disk Warning Threshold (%)" "80" "disk_warning")
disk_critical=$(prompt_with_default "Disk Critical Threshold (%)" "90" "disk_critical")
inode_warning=$(prompt_with_default "Inode Warning Threshold (%)" "85" "inode_warning")
inode_critical=$(prompt_with_default "Inode Critical Threshold (%)" "95" "inode_critical")

update_threshold "system.disk" "warning" "$disk_warning"
update_threshold "system.disk" "critical" "$disk_critical"
update_threshold "system.disk.inode" "warning" "$inode_warning"
update_threshold "system.disk.inode" "critical" "$inode_critical"

echo ""

# Container Thresholds
echo -e "${BLUE}=== Container Thresholds ===${NC}"

container_cpu_warning=$(prompt_with_default "Container CPU Warning (%)" "70" "container_cpu_warning")
container_cpu_critical=$(prompt_with_default "Container CPU Critical (%)" "85" "container_cpu_critical")
container_memory_warning=$(prompt_with_default "Container Memory Warning (%)" "80" "container_memory_warning")
container_memory_critical=$(prompt_with_default "Container Memory Critical (%)" "90" "container_memory_critical")

update_threshold "containers.cpu" "warning" "$container_cpu_warning"
update_threshold "containers.cpu" "critical" "$container_cpu_critical"
update_threshold "containers.memory" "warning" "$container_memory_warning"
update_threshold "containers.memory" "critical" "$container_memory_critical"

echo ""

# Service-Specific Thresholds
echo -e "${BLUE}=== Service-Specific Thresholds ===${NC}"

# Web services
web_response_warning=$(prompt_with_default "Web Response Time Warning (ms)" "1000" "web_response_warning")
web_response_critical=$(prompt_with_default "Web Response Time Critical (ms)" "3000" "web_response_critical")
web_error_warning=$(prompt_with_default "Web Error Rate Warning (%)" "5" "web_error_warning")
web_error_critical=$(prompt_with_default "Web Error Rate Critical (%)" "10" "web_error_critical")

update_threshold "services.web.response_time" "warning" "$web_response_warning"
update_threshold "services.web.response_time" "critical" "$web_response_critical"
update_threshold "services.web.error_rate" "warning" "$web_error_warning"
update_threshold "services.web.error_rate" "critical" "$web_error_critical"

# Database services
db_connections_warning=$(prompt_with_default "Database Connections Warning" "80" "db_connections_warning")
db_connections_critical=$(prompt_with_default "Database Connections Critical" "90" "db_connections_critical")
db_query_warning=$(prompt_with_default "Database Query Time Warning (ms)" "1000" "db_query_warning")
db_query_critical=$(prompt_with_default "Database Query Time Critical (ms)" "5000" "db_query_critical")

update_threshold "services.database.connection_pool" "warning" "$db_connections_warning"
update_threshold "services.database.connection_pool" "critical" "$db_connections_critical"
update_threshold "services.database.query_time" "warning" "$db_query_warning"
update_threshold "services.database.query_time" "critical" "$db_query_critical"

echo ""

# Media Service Thresholds
echo -e "${BLUE}=== Media Service Thresholds ===${NC}"

media_streams_warning=$(prompt_with_default "Active Streams Warning" "5" "media_streams_warning")
media_streams_critical=$(prompt_with_default "Active Streams Critical" "10" "media_streams_critical")
media_transcoding_warning=$(prompt_with_default "Transcoding Sessions Warning" "2" "media_transcoding_warning")
media_transcoding_critical=$(prompt_with_default "Transcoding Sessions Critical" "5" "media_transcoding_critical")

update_threshold "services.media.stream_count" "warning" "$media_streams_warning"
update_threshold "services.media.stream_count" "critical" "$media_streams_critical"
update_threshold "services.media.transcoding_queue" "warning" "$media_transcoding_warning"
update_threshold "services.media.transcoding_queue" "critical" "$media_transcoding_critical"

echo ""

# Download Service Thresholds
echo -e "${BLUE}=== Download Service Thresholds ===${NC}"

download_queue_warning=$(prompt_with_default "Download Queue Warning" "50" "download_queue_warning")
download_queue_critical=$(prompt_with_default "Download Queue Critical" "100" "download_queue_critical")
download_speed_warning=$(prompt_with_default "Download Speed Warning (MB/s)" "10" "download_speed_warning")
download_speed_critical=$(prompt_with_default "Download Speed Critical (MB/s)" "5" "download_speed_critical")

update_threshold "services.download.queue_size" "warning" "$download_queue_warning"
update_threshold "services.download.queue_size" "critical" "$download_queue_critical"
update_threshold "services.download.download_speed" "warning" "$download_speed_warning"
update_threshold "services.download.download_speed" "critical" "$download_speed_critical"

echo ""

# Security Thresholds
echo -e "${BLUE}=== Security Thresholds ===${NC}"

failed_logins_warning=$(prompt_with_default "Failed Logins Warning (per 5min)" "10" "failed_logins_warning")
failed_logins_critical=$(prompt_with_default "Failed Logins Critical (per 5min)" "50" "failed_logins_critical")
blocked_ips_warning=$(prompt_with_default "Blocked IPs Warning (per hour)" "5" "blocked_ips_warning")
blocked_ips_critical=$(prompt_with_default "Blocked IPs Critical (per hour)" "20" "blocked_ips_critical")

update_threshold "services.security.failed_logins" "warning" "$failed_logins_warning"
update_threshold "services.security.failed_logins" "critical" "$failed_logins_critical"
update_threshold "services.security.blocked_ips" "warning" "$blocked_ips_warning"
update_threshold "services.security.blocked_ips" "critical" "$blocked_ips_critical"

echo ""

# Network Thresholds
echo -e "${BLUE}=== Network Thresholds ===${NC}"

network_latency_warning=$(prompt_with_default "Network Latency Warning (ms)" "100" "network_latency_warning")
network_latency_critical=$(prompt_with_default "Network Latency Critical (ms)" "500" "network_latency_critical")
network_errors_warning=$(prompt_with_default "Network Errors Warning" "10" "network_errors_warning")
network_errors_critical=$(prompt_with_default "Network Errors Critical" "50" "network_errors_critical")

update_threshold "system.network.latency" "warning" "$network_latency_warning"
update_threshold "system.network.latency" "critical" "$network_latency_critical"
update_threshold "system.network.errors" "warning" "$network_errors_warning"
update_threshold "system.network.errors" "critical" "$network_errors_critical"

echo ""

# Backup Thresholds
echo -e "${BLUE}=== Backup Thresholds ===${NC}"

backup_age_warning=$(prompt_with_default "Backup Age Warning (hours)" "24" "backup_age_warning")
backup_age_critical=$(prompt_with_default "Backup Age Critical (hours)" "48" "backup_age_critical")
backup_duration_warning=$(prompt_with_default "Backup Duration Warning (seconds)" "3600" "backup_duration_warning")
backup_duration_critical=$(prompt_with_default "Backup Duration Critical (seconds)" "7200" "backup_duration_critical")

update_threshold "backup.status.backup_age" "warning" "$backup_age_warning"
update_threshold "backup.status.backup_age" "critical" "$backup_age_critical"
update_threshold "backup.performance.backup_duration" "warning" "$backup_duration_warning"
update_threshold "backup.performance.backup_duration" "critical" "$backup_duration_critical"

echo ""

# SSL/TLS Thresholds
echo -e "${BLUE}=== SSL/TLS Thresholds ===${NC}"

ssl_warning_days=$(prompt_with_default "SSL Certificate Warning (days before expiry)" "30" "ssl_warning_days")
ssl_critical_days=$(prompt_with_default "SSL Certificate Critical (days before expiry)" "7" "ssl_critical_days")

update_threshold "ssl.expiration" "warning" "$ssl_warning_days"
update_threshold "ssl.expiration" "critical" "$ssl_critical_days"

echo ""

# Alert Timing Configuration
echo -e "${BLUE}=== Alert Timing Configuration ===${NC}"

evaluation_interval=$(prompt_with_default "Evaluation Interval" "30s" "evaluation_interval")
group_wait=$(prompt_with_default "Group Wait" "30s" "group_wait")
group_interval=$(prompt_with_default "Group Interval" "5m" "group_interval")
repeat_interval=$(prompt_with_default "Repeat Interval" "4h" "repeat_interval")

update_threshold "alert_timing" "evaluation_interval" "\"$evaluation_interval\""
update_threshold "alert_timing" "group_wait" "\"$group_wait\""
update_threshold "alert_timing" "group_interval" "\"$group_interval\""
update_threshold "alert_timing" "repeat_interval" "\"$repeat_interval\""

echo ""

# Environment Selection
echo -e "${BLUE}=== Environment Configuration ===${NC}"
echo "Select your environment to apply appropriate threshold overrides:"
echo "1. Production (stricter thresholds)"
echo "2. Development (more lenient thresholds)"
echo "3. Custom (manual configuration)"

env_choice=$(prompt_with_default "Environment choice (1-3)" "1" "env_choice")

case $env_choice in
    1)
        echo -e "${YELLOW}Applying production thresholds...${NC}"
        # Production thresholds are already set as defaults
        ;;
    2)
        echo -e "${YELLOW}Applying development thresholds...${NC}"
        update_threshold "overrides.development.system.cpu" "warning" "90"
        update_threshold "overrides.development.system.cpu" "critical" "95"
        update_threshold "overrides.development.system.memory" "warning" "90"
        update_threshold "overrides.development.system.memory" "critical" "95"
        ;;
    3)
        echo -e "${YELLOW}Using custom thresholds...${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice, using production defaults${NC}"
        ;;
esac

echo ""

# High Priority Services
echo -e "${BLUE}=== High Priority Services ===${NC}"
echo "These services will have stricter monitoring:"
echo "  - Traefik (reverse proxy)"
echo "  - Authentik (authentication)"
echo "  - Prometheus (monitoring)"
echo "  - Grafana (dashboards)"

high_priority=$(prompt_with_default "Enable high priority service monitoring? (y/n)" "y" "high_priority")

if [[ $high_priority =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}✓ High priority service monitoring enabled${NC}"
else
    echo -e "${YELLOW}High priority service monitoring disabled${NC}"
fi

echo ""

# Threshold Validation
echo -e "${BLUE}=== Threshold Validation ===${NC}"
echo "Validating configured thresholds..."

# Check for logical inconsistencies
if [ "$cpu_warning" -ge "$cpu_critical" ]; then
    echo -e "${RED}⚠️  Warning: CPU warning threshold ($cpu_warning%) >= critical threshold ($cpu_critical%)${NC}"
fi

if [ "$memory_warning" -ge "$memory_critical" ]; then
    echo -e "${RED}⚠️  Warning: Memory warning threshold ($memory_warning%) >= critical threshold ($memory_critical%)${NC}"
fi

if [ "$disk_warning" -ge "$disk_critical" ]; then
    echo -e "${RED}⚠️  Warning: Disk warning threshold ($disk_warning%) >= critical threshold ($disk_critical%)${NC}"
fi

echo -e "${GREEN}✓ Threshold validation complete${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Monitoring Thresholds Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Configuration Summary:${NC}"
echo "  System CPU: ${YELLOW}${cpu_warning}%${NC} / ${RED}${cpu_critical}%${NC}"
echo "  System Memory: ${YELLOW}${memory_warning}%${NC} / ${RED}${memory_critical}%${NC}"
echo "  System Disk: ${YELLOW}${disk_warning}%${NC} / ${RED}${disk_critical}%${NC}"
echo "  Container CPU: ${YELLOW}${container_cpu_warning}%${NC} / ${RED}${container_cpu_critical}%${NC}"
echo "  Web Response: ${YELLOW}${web_response_warning}ms${NC} / ${RED}${web_response_critical}ms${NC}"
echo "  Database Connections: ${YELLOW}${db_connections_warning}%${NC} / ${RED}${db_connections_critical}%${NC}"
echo "  Failed Logins: ${YELLOW}${failed_logins_warning}${NC} / ${RED}${failed_logins_critical}${NC}"
echo "  SSL Warning: ${YELLOW}${ssl_warning_days} days${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review the configuration in $THRESHOLDS_FILE"
echo "2. Deploy with: ansible-playbook -i inventory.yml site.yml --ask-vault-pass"
echo "3. Monitor alerts in Grafana: https://grafana.{{ domain }}"
echo "" 