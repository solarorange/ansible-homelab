#!/bin/bash

# Enhanced Health Check Script
# Production-ready health monitoring with comprehensive error handling and retry logic

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/health_check.log"
CONFIG_FILE="${SCRIPT_DIR}/health_config.json"
TIMEOUT="${TIMEOUT:-30}"
RETRIES="${RETRIES:-3}"
RETRY_DELAY="${RETRY_DELAY:-5}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Enhanced logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        "DEBUG")
            echo -e "${BLUE}[DEBUG]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        *)
            echo -e "${CYAN}[$level]${NC} $message"
            ;;
    esac
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Enhanced error handling
error_exit() {
    log "ERROR" "$1"
    exit 1
}

# Function to check if running as root (if required)
check_root() {
    if [[ $EUID -ne 0 ]] && [[ "$1" == "require_root" ]]; then
        error_exit "This script must be run as root"
    fi
}

# Enhanced service health check function
check_service_health() {
    local service_name="$1"
    local health_url="$2"
    local method="${3:-HTTP}"
    local expected_status="${4:-200}"
    local timeout="${5:-$TIMEOUT}"
    local retries="${6:-$RETRIES}"
    
    log "INFO" "Checking health of ${service_name}..."
    
    if [[ "$method" == "TCP" ]]; then
        # Enhanced TCP connection check
        local host=$(echo "$health_url" | cut -d: -f1)
        local port=$(echo "$health_url" | cut -d: -f2)
        
        for attempt in $(seq 1 "$retries"); do
            if timeout "$timeout" bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
                log "SUCCESS" "${service_name} is healthy (TCP port ${port})"
                return 0
            else
                if [[ $attempt -lt $retries ]]; then
                    log "WARNING" "${service_name} health check attempt $attempt failed, retrying in ${RETRY_DELAY} seconds..."
                    sleep "$RETRY_DELAY"
                else
                    log "ERROR" "${service_name} is unhealthy (TCP port ${port})"
                    return 1
                fi
            fi
        done
    else
        # Enhanced HTTP health check
        for attempt in $(seq 1 "$retries"); do
            local response_code
            local response_time
            
            response_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$timeout" "$health_url" 2>/dev/null || echo "000")
            response_time=$(curl -s -o /dev/null -w "%{time_total}" --max-time "$timeout" "$health_url" 2>/dev/null || echo "0")
            
            if [[ "$response_code" == "$expected_status" ]]; then
                log "SUCCESS" "${service_name} is healthy (HTTP ${response_code}, ${response_time}s)"
                return 0
            else
                if [[ $attempt -lt $retries ]]; then
                    log "WARNING" "${service_name} health check attempt $attempt failed (HTTP ${response_code}), retrying in ${RETRY_DELAY} seconds..."
                    sleep "$RETRY_DELAY"
                else
                    log "ERROR" "${service_name} is unhealthy (HTTP ${response_code})"
                    return 1
                fi
            fi
        done
    fi
}

# Enhanced Docker container status check
check_container_status() {
    local service_name="$1"
    local container_name="$2"
    
    log "INFO" "Checking container status for ${service_name}..."
    
    # Check if container exists and is running
    if ! docker ps --format "table {{.Names}}" | grep -q "^${container_name}$"; then
        log "ERROR" "${service_name} container (${container_name}) is not running"
        return 1
    fi
    
    # Check container health status
    local health_status
    health_status=$(docker inspect "$container_name" --format='{{.State.Health.Status}}' 2>/dev/null || echo "none")
    
    case "$health_status" in
        "healthy")
            log "SUCCESS" "${service_name} container is healthy"
            return 0
            ;;
        "unhealthy")
            log "ERROR" "${service_name} container is unhealthy"
            return 1
            ;;
        "starting")
            log "WARNING" "${service_name} container is still starting"
            return 0
            ;;
        "none")
            log "WARNING" "${service_name} container has no health check configured"
            return 0
            ;;
        *)
            log "ERROR" "${service_name} container has unknown health status: ${health_status}"
            return 1
            ;;
    esac
}

# Enhanced system resource check
check_system_resources() {
    log "INFO" "Checking system resources..."
    
    # Check disk usage
    local disk_usage
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [[ $disk_usage -gt 90 ]]; then
        log "ERROR" "Disk usage is critical: ${disk_usage}%"
        return 1
    elif [[ $disk_usage -gt 80 ]]; then
        log "WARNING" "Disk usage is high: ${disk_usage}%"
    else
        log "SUCCESS" "Disk usage is normal: ${disk_usage}%"
    fi
    
    # Check memory usage
    local memory_usage
    memory_usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    if [[ $memory_usage -gt 90 ]]; then
        log "ERROR" "Memory usage is critical: ${memory_usage}%"
        return 1
    elif [[ $memory_usage -gt 80 ]]; then
        log "WARNING" "Memory usage is high: ${memory_usage}%"
    else
        log "SUCCESS" "Memory usage is normal: ${memory_usage}%"
    fi
    
    # Check CPU load
    local load_average
    load_average=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    local cpu_cores
    cpu_cores=$(nproc)
    local load_per_core
    load_per_core=$(echo "scale=2; $load_average / $cpu_cores" | bc)
    
    if (( $(echo "$load_per_core > 2.0" | bc -l) )); then
        log "ERROR" "CPU load is critical: ${load_average} (${load_per_core} per core)"
        return 1
    elif (( $(echo "$load_per_core > 1.0" | bc -l) )); then
        log "WARNING" "CPU load is high: ${load_average} (${load_per_core} per core)"
    else
        log "SUCCESS" "CPU load is normal: ${load_average} (${load_per_core} per core)"
    fi
    
    return 0
}

# Enhanced network connectivity check
check_network_connectivity() {
    log "INFO" "Checking network connectivity..."
    
    # Check internet connectivity
    if ! ping -c 3 8.8.8.8 >/dev/null 2>&1; then
        log "ERROR" "Internet connectivity failed"
        return 1
    else
        log "SUCCESS" "Internet connectivity is working"
    fi
    
    # Check DNS resolution
    if ! nslookup google.com >/dev/null 2>&1; then
        log "ERROR" "DNS resolution failed"
        return 1
    else
        log "SUCCESS" "DNS resolution is working"
    fi
    
    # Check local network connectivity
    if ! ping -c 3 192.168.1.1 >/dev/null 2>&1; then
        log "WARNING" "Local network connectivity may be impaired"
    else
        log "SUCCESS" "Local network connectivity is working"
    fi
    
    return 0
}

# Enhanced Docker daemon check
check_docker_daemon() {
    log "INFO" "Checking Docker daemon..."
    
    if ! docker info >/dev/null 2>&1; then
        log "ERROR" "Docker daemon is not responding"
        return 1
    else
        log "SUCCESS" "Docker daemon is healthy"
    fi
    
    # Check Docker disk space
    local docker_disk_usage
    docker_disk_usage=$(docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}" | grep "Images" | awk '{print $3}' | sed 's/[^0-9.]//g')
    
    if [[ -n "$docker_disk_usage" ]] && (( $(echo "$docker_disk_usage > 10" | bc -l) )); then
        log "WARNING" "Docker disk usage is high: ${docker_disk_usage}GB"
    else
        log "SUCCESS" "Docker disk usage is normal: ${docker_disk_usage}GB"
    fi
    
    return 0
}

# Enhanced service-specific health checks
check_specific_services() {
    log "INFO" "Checking specific services..."
    
    # Define service health checks
    declare -A service_checks=(
        ["traefik"]="http://localhost:8080/api/health"
        ["authentik"]="http://localhost:9000/if/user/"
        ["grafana"]="http://localhost:3000/api/health"
        ["prometheus"]="http://localhost:9090/-/healthy"
        ["influxdb"]="http://localhost:8086/health"
        ["loki"]="http://localhost:3100/ready"
        ["alertmanager"]="http://localhost:9093/-/healthy"
        ["postgresql"]="localhost:5432"
        ["redis"]="localhost:6379"
        ["sonarr"]="http://localhost:8989/health"
        ["radarr"]="http://localhost:7878/health"
        ["jellyfin"]="http://localhost:8096/health"
        ["nextcloud"]="http://localhost:8080/status.php"
        ["paperless"]="http://localhost:8010/health"
        ["fing"]="http://localhost:8080/health"
    )
    
    local failed_services=()
    
    for service in "${!service_checks[@]}"; do
        local health_url="${service_checks[$service]}"
        local method="HTTP"
        
        # Determine check method
        if [[ "$health_url" == *":"* && "$health_url" != *"http"* ]]; then
            method="TCP"
        fi
        
        if ! check_service_health "$service" "$health_url" "$method"; then
            failed_services+=("$service")
        fi
    done
    
    if [[ ${#failed_services[@]} -gt 0 ]]; then
        log "ERROR" "The following services failed health checks: ${failed_services[*]}"
        return 1
    else
        log "SUCCESS" "All specific services are healthy"
        return 0
    fi
}

# Enhanced performance metrics collection
collect_performance_metrics() {
    log "INFO" "Collecting performance metrics..."
    
    # CPU usage
    local cpu_usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
    log "DEBUG" "CPU Usage: ${cpu_usage}%"
    
    # Memory usage
    local memory_usage
    memory_usage=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}')
    log "DEBUG" "Memory Usage: ${memory_usage}%"
    
    # Disk I/O
    local disk_io
    disk_io=$(iostat -x 1 1 | grep -A 1 "Device" | tail -1 | awk '{print $6}')
    log "DEBUG" "Disk I/O: ${disk_io}%"
    
    # Network I/O
    local network_io
    network_io=$(cat /proc/net/dev | grep eth0 | awk '{print $2+$10}')
    log "DEBUG" "Network I/O: ${network_io} bytes"
    
    # Docker container count
    local container_count
    container_count=$(docker ps -q | wc -l)
    log "DEBUG" "Running Containers: ${container_count}"
}

# Enhanced main health check function
main_health_check() {
    log "INFO" "Starting enhanced health monitoring..."
    
    local overall_status=0
    
    # Check system resources
    if ! check_system_resources; then
        overall_status=1
    fi
    
    # Check network connectivity
    if ! check_network_connectivity; then
        overall_status=1
    fi
    
    # Check Docker daemon
    if ! check_docker_daemon; then
        overall_status=1
    fi
    
    # Check specific services
    if ! check_specific_services; then
        overall_status=1
    fi
    
    # Collect performance metrics
    collect_performance_metrics
    
    # Final status report
    if [[ $overall_status -eq 0 ]]; then
        log "SUCCESS" "All health checks passed successfully"
        echo "HEALTH_CHECK_STATUS=SUCCESS" >> "$LOG_FILE"
    else
        log "ERROR" "Some health checks failed"
        echo "HEALTH_CHECK_STATUS=FAILED" >> "$LOG_FILE"
    fi
    
    return $overall_status
}

# Enhanced cleanup function
cleanup() {
    log "INFO" "Performing cleanup..."
    
    # Rotate log file if it's too large
    local log_size
    log_size=$(du -h "$LOG_FILE" 2>/dev/null | cut -f1 || echo "0")
    
    if [[ "$log_size" > "10M" ]]; then
        mv "$LOG_FILE" "${LOG_FILE}.old"
        log "INFO" "Log file rotated"
    fi
    
    # Clean up old log files (keep last 7 days)
    find "$SCRIPT_DIR" -name "*.old" -mtime +7 -delete 2>/dev/null || true
    
    # Clean up Docker system
    docker system prune -f >/dev/null 2>&1 || true
    
    log "INFO" "Cleanup completed"
}

# Enhanced signal handling
trap cleanup EXIT
trap 'log "ERROR" "Health check interrupted"; exit 1' INT TERM

# Main execution
main() {
    # Check if log directory exists
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # Check if running as root (optional)
    check_root "${1:-}"
    
    # Run main health check
    main_health_check
    
    # Exit with appropriate status
    exit $?
}

# Run main function with all arguments
main "$@" 