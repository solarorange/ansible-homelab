#!/bin/bash
# Deployment Resource Monitor
# Cross-platform system resource monitoring during homelab deployment

set -euo pipefail

LOG_FILE="/tmp/deployment_monitor.log"
INTERVAL=30  # Check every 30 seconds

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "freebsd"
    else
        echo "unknown"
    fi
}

get_cpu_usage() {
    local os=$(detect_os)
    
    case $os in
        "macos")
            # macOS CPU usage
            cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//' 2>/dev/null || echo "0")
            ;;
        "linux")
            # Linux CPU usage
            cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 2>/dev/null || echo "0")
            ;;
        "freebsd")
            # FreeBSD CPU usage
            cpu_usage=$(top -b | grep "CPU:" | awk '{print $2}' | sed 's/%//' 2>/dev/null || echo "0")
            ;;
        *)
            cpu_usage="0"
            ;;
    esac
    
    echo "$cpu_usage"
}

get_memory_usage() {
    local os=$(detect_os)
    
    case $os in
        "macos")
            # macOS memory usage
            total_mem=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
            if [ "$total_mem" -gt 0 ]; then
                active_mem=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//' 2>/dev/null || echo "0")
                mem_usage=$(echo "scale=1; $active_mem * 4096 * 100 / $total_mem" | bc -l 2>/dev/null || echo "0")
            else
                mem_usage="0"
            fi
            ;;
        "linux")
            # Linux memory usage
            mem_usage=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}' 2>/dev/null || echo "0")
            ;;
        "freebsd")
            # FreeBSD memory usage
            mem_usage=$(top -b | grep "Mem:" | awk '{print $3}' | sed 's/%//' 2>/dev/null || echo "0")
            ;;
        *)
            mem_usage="0"
            ;;
    esac
    
    echo "$mem_usage"
}

get_disk_usage() {
    # Cross-platform disk usage
    disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//' 2>/dev/null || echo "0")
    echo "$disk_usage"
}

get_load_average() {
    # Cross-platform load average
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//' 2>/dev/null || echo "0")
    echo "$load_avg"
}

get_docker_containers() {
    # Docker containers count (if Docker is available)
    if command -v docker >/dev/null 2>&1; then
        docker_containers=$(docker ps --format "table {{.Names}}" 2>/dev/null | wc -l)
        docker_containers=$((docker_containers - 1))  # Subtract header
    else
        docker_containers="0"
    fi
    echo "$docker_containers"
}

get_network_connections() {
    local os=$(detect_os)
    
    case $os in
        "macos")
            # macOS network connections
            net_connections=$(netstat -an | grep ESTABLISHED | wc -l 2>/dev/null || echo "0")
            ;;
        "linux")
            # Linux network connections
            net_connections=$(ss -tuln | wc -l 2>/dev/null || echo "0")
            ;;
        "freebsd")
            # FreeBSD network connections
            net_connections=$(netstat -an | grep ESTABLISHED | wc -l 2>/dev/null || echo "0")
            ;;
        *)
            net_connections="0"
            ;;
    esac
    
    echo "$net_connections"
}

check_port_conflicts() {
    local os=$(detect_os)
    
    case $os in
        "macos")
            # macOS port checking
            netstat -an | grep LISTEN | awk '{print $4}' | cut -d'.' -f2 | sort -n | uniq -d > /tmp/port_conflicts.txt 2>/dev/null || true
            ;;
        "linux")
            # Linux port checking
            ss -tuln | grep LISTEN | awk '{print $4}' | cut -d':' -f2 | sort -n | uniq -d > /tmp/port_conflicts.txt 2>/dev/null || true
            ;;
        "freebsd")
            # FreeBSD port checking
            netstat -an | grep LISTEN | awk '{print $4}' | cut -d'.' -f2 | sort -n | uniq -d > /tmp/port_conflicts.txt 2>/dev/null || true
            ;;
        *)
            touch /tmp/port_conflicts.txt
            ;;
    esac
}

check_resources() {
    # Get all resource metrics
    cpu_usage=$(get_cpu_usage)
    mem_usage=$(get_memory_usage)
    disk_usage=$(get_disk_usage)
    load_avg=$(get_load_average)
    docker_containers=$(get_docker_containers)
    net_connections=$(get_network_connections)
    
    log "RESOURCES: CPU: ${cpu_usage}% | MEM: ${mem_usage}% | DISK: ${disk_usage}% | LOAD: ${load_avg} | DOCKER: ${docker_containers} | CONNECTIONS: ${net_connections}"
    
    # Alert if resources are high (using bc for floating point math)
    if command -v bc >/dev/null 2>&1; then
        if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || echo "0") )); then
            log "WARNING: High CPU usage: ${cpu_usage}%"
        fi
        
        if (( $(echo "$mem_usage > 85" | bc -l 2>/dev/null || echo "0") )); then
            log "WARNING: High memory usage: ${mem_usage}%"
        fi
        
        if (( $(echo "$load_avg > 2" | bc -l 2>/dev/null || echo "0") )); then
            log "WARNING: High load average: ${load_avg}"
        fi
    else
        # Fallback without bc
        if [ "${cpu_usage%.*}" -gt 80 ] 2>/dev/null; then
            log "WARNING: High CPU usage: ${cpu_usage}%"
        fi
        
        if [ "${mem_usage%.*}" -gt 85 ] 2>/dev/null; then
            log "WARNING: High memory usage: ${mem_usage}%"
        fi
        
        if [ "${load_avg%.*}" -gt 2 ] 2>/dev/null; then
            log "WARNING: High load average: ${load_avg}"
        fi
    fi
    
    if [ "$disk_usage" -gt 85 ] 2>/dev/null; then
        log "WARNING: High disk usage: ${disk_usage}%"
    fi
}

check_ports() {
    # Check for port conflicts
    log "Checking port usage..."
    check_port_conflicts
    
    if [ -s /tmp/port_conflicts.txt ]; then
        log "WARNING: Port conflicts detected:"
        cat /tmp/port_conflicts.txt | while read port; do
            log "  Port $port has multiple listeners"
        done
    else
        log "No port conflicts detected"
    fi
}

main() {
    local os=$(detect_os)
    log "Starting deployment resource monitor"
    log "OS detected: $os"
    log "Monitoring interval: ${INTERVAL} seconds"
    
    while true; do
        check_resources
        check_ports
        log "---"
        sleep $INTERVAL
    done
}

# Run in background
main &
MONITOR_PID=$!

echo "Deployment monitor started (PID: $MONITOR_PID)"
echo "Log file: $LOG_FILE"
echo "To stop monitoring: kill $MONITOR_PID"
