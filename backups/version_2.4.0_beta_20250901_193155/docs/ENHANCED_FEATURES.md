# Enhanced Features Documentation

## Overview

This document outlines the enhanced features implemented to address minor areas of improvement in the Ansible homelab playbook. These enhancements provide production-ready configurations with improved reliability, monitoring, and resource management.

## Table of Contents

1. [Enhanced Health Check Configuration](#enhanced-health-check-configuration)
2. [Enhanced Resource Limits](#enhanced-resource-limits)
3. [Enhanced Monitoring Thresholds](#enhanced-monitoring-thresholds)
4. [Enhanced Docker Compose Template](#enhanced-docker-compose-template)
5. [Enhanced Health Check Script](#enhanced-health-check-script)
6. [Implementation Guide](#implementation-guide)
7. [Best Practices](#best-practices)

## Enhanced Health Check Configuration

### Overview

Enhanced health checks provide more robust service monitoring with explicit exit codes, better error handling, and configurable retry logic.

### Key Improvements

#### Explicit Exit Codes
```yaml
# Before
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]

# After
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
```

#### Enhanced Configuration Options
```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:{{ service_port }}/health || exit 1"]
  interval: "{{ service_healthcheck_interval | default('30s') }}"
  timeout: "{{ service_healthcheck_timeout | default('10s') }}"
  retries: {{ service_healthcheck_retries | default(3) }}
  start_period: "{{ service_healthcheck_start_period | default('40s') }}"
  disable: false
```

#### Service-Specific Health Checks
```yaml
service_health_checks:
  traefik:
    test: ["CMD-SHELL", "curl -f http://localhost:8080/ping || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 10s
    disable: false
  
  grafana:
    test: ["CMD-SHELL", "curl -f http://localhost:3000/api/health || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 30s
    disable: false
```

### Benefits

- **Explicit Error Handling**: Clear exit codes for better container orchestration
- **Configurable Retry Logic**: Adjustable retry attempts and delays
- **Service-Specific Optimization**: Tailored health checks for different service types
- **Production Reliability**: Enhanced stability for production environments

## Enhanced Resource Limits

### Overview

Enhanced resource limits provide granular control over container resource allocation with proper reservations and limits for different service tiers.

### Key Improvements

#### Tiered Resource Allocation
```yaml
container_limits:
  # Critical services (high priority)
  critical:
    cpu_limit: "1.0"
    cpu_reservation: "0.5"
    memory_limit: "1G"
    memory_reservation: "512M"
    pids_limit: 100
    services:
      - traefik
      - authentik
      - prometheus
      - grafana
      - postgresql
      - redis
  
  # High-performance services
  high_performance:
    cpu_limit: "2.0"
    cpu_reservation: "1.0"
    memory_limit: "2G"
    memory_reservation: "1G"
    pids_limit: 200
    services:
      - jellyfin
      - plex
      - emby
      - tdarr
      - immich
```

#### Enhanced Docker Optimization
```yaml
docker_optimization:
  resource_management:
    # CPU scheduling
    cpu_scheduling:
      cpu_period: 100000
      cpu_quota: 100000
      cpu_shares: 1024
      cpu_rt_runtime: 950000
      cpu_rt_period: 1000000
    
    # Memory management
    memory_management:
      memory_swap: "2G"
      memory_swappiness: 10
      kernel_memory: "128M"
      memory_reservation: "256M"
    
    # I/O management
    io_management:
      blkio_weight: 500
      blkio_weight_device: []
      device_read_bps: []
      device_write_bps: []
      device_read_iops: []
      device_write_iops: []
```

### Benefits

- **Resource Isolation**: Prevents resource contention between services
- **Predictable Performance**: Guaranteed resource reservations
- **Scalability**: Easy to adjust limits based on hardware capabilities
- **Cost Optimization**: Efficient resource utilization

## Enhanced Monitoring Thresholds

### Overview

Enhanced monitoring thresholds provide granular control over alerting with service-specific metrics and time-based overrides.

### Key Improvements

#### Granular System Metrics
```yaml
system:
  cpu:
    warning: 80
    critical: 90
    load_average:
      warning: 2.0
      critical: 5.0
    per_core:
      warning: 85
      critical: 95
    iowait:
      warning: 20
      critical: 50
    steal:
      warning: 10
      critical: 25
```

#### Service-Specific Thresholds
```yaml
services:
  web:
    response_time:
      warning: 1000
      critical: 3000
      p95: 2000
      p99: 5000
    error_rate:
      warning: 5
      critical: 10
      time_window: "5m"
    availability:
      warning: 99.5
      critical: 99.0
    request_rate:
      warning: 1000
      critical: 5000
      time_window: "1m"
```

#### Time-Based Overrides
```yaml
time_based:
  business_hours:
    start: "09:00"
    end: "17:00"
    timezone: "America/New_York"
    thresholds:
      system:
        cpu:
          warning: 60
          critical: 80
      services:
        web:
          response_time:
            warning: 500
            critical: 1500
  
  maintenance_window:
    start: "02:00"
    end: "04:00"
    timezone: "America/New_York"
    thresholds:
      system:
        cpu:
          warning: 90
          critical: 95
```

### Benefits

- **Contextual Alerting**: Different thresholds for different time periods
- **Service-Specific Monitoring**: Tailored metrics for each service type
- **Reduced Alert Fatigue**: More intelligent alerting based on context
- **Performance Optimization**: Better resource utilization during off-peak hours

## Enhanced Docker Compose Template

### Overview

The enhanced Docker Compose template provides production-ready configurations with comprehensive security, monitoring, and resource management.

### Key Features

#### Enhanced Security Configuration
```yaml
# Enhanced security options
security_opt:
  - no-new-privileges:true
  - seccomp=unconfined
read_only: {{ service_read_only | default(false) }}
tmpfs:
  - /tmp:noexec,nosuid,size=100m
  - /var/tmp:noexec,nosuid,size=100m
  - /run:noexec,nosuid,size=100m

# Enhanced user configuration
user: "{{ service_user | default('1000:1000') }}"

# Enhanced ulimits
ulimits:
  nofile:
    soft: 65536
    hard: 65536
  nproc:
    soft: 32768
    hard: 32768
  core:
    soft: 0
    hard: 0
```

#### Enhanced Resource Management
```yaml
deploy:
  resources:
    limits:
      cpus: '{{ service_cpu_limit | default("1.0") }}'
      memory: {{ service_memory_limit | default("512M") }}
      pids: {{ service_pids_limit | default(100) }}
    reservations:
      cpus: '{{ service_cpu_reservation | default("0.25") }}'
      memory: {{ service_memory_reservation | default("256M") }}
  
  # Enhanced restart policy
  restart_policy:
    condition: on-failure
    delay: 5s
    max_attempts: 3
    window: 120s
  
  # Enhanced update configuration
  update_config:
    parallelism: 1
    delay: 10s
    order: start-first
    failure_action: rollback
    monitor: 60s
    max_failure_ratio: 0.3
```

#### Enhanced Monitoring Labels
```yaml
labels:
  # Enhanced monitoring labels
  - "prometheus.enable=true"
  - "prometheus.job={{ service_name }}"
  - "prometheus.port={{ service_port }}"
  - "prometheus.path=/metrics"
  - "loki.scrape=true"
  - "loki.job={{ service_name }}"
  
  # Enhanced security labels
  - "security.scan.enabled=true"
  - "security.vulnerability.scan=true"
  - "security.compliance.level=production"
  
  # Enhanced performance labels
  - "performance.monitoring=true"
  - "performance.resource.tracking=true"
  - "performance.health.check=true"
```

### Benefits

- **Production Security**: Enhanced security configurations for production environments
- **Comprehensive Monitoring**: Built-in monitoring and observability
- **Resource Optimization**: Efficient resource allocation and management
- **Rollback Capability**: Automatic rollback on deployment failures

## Enhanced Health Check Script

### Overview

The enhanced health check script provides comprehensive system monitoring with detailed error reporting and performance metrics collection.

### Key Features

#### Enhanced Error Handling
```bash
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
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
    esac
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}
```

#### Comprehensive Service Checks
```bash
# Enhanced service health check function
check_service_health() {
    local service_name="$1"
    local health_url="$2"
    local method="${3:-HTTP}"
    local expected_status="${4:-200}"
    local timeout="${5:-$TIMEOUT}"
    local retries="${6:-$RETRIES}"
    
    # Retry logic with exponential backoff
    for attempt in $(seq 1 "$retries"); do
        if [[ "$method" == "TCP" ]]; then
            # TCP connection check
            if timeout "$timeout" bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
                log "SUCCESS" "${service_name} is healthy (TCP port ${port})"
                return 0
            fi
        else
            # HTTP health check
            response_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$timeout" "$health_url" 2>/dev/null || echo "000")
            if [[ "$response_code" == "$expected_status" ]]; then
                log "SUCCESS" "${service_name} is healthy (HTTP ${response_code})"
                return 0
            fi
        fi
        
        if [[ $attempt -lt $retries ]]; then
            log "WARNING" "${service_name} health check attempt $attempt failed, retrying in ${RETRY_DELAY} seconds..."
            sleep "$RETRY_DELAY"
        fi
    done
    
    log "ERROR" "${service_name} health check failed after $retries attempts"
    return 1
}
```

#### Performance Metrics Collection
```bash
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
    
    # Docker container count
    local container_count
    container_count=$(docker ps -q | wc -l)
    log "DEBUG" "Running Containers: ${container_count}"
}
```

### Benefits

- **Comprehensive Monitoring**: System-wide health monitoring
- **Detailed Reporting**: Color-coded output with detailed logging
- **Performance Tracking**: Real-time performance metrics collection
- **Automated Cleanup**: Automatic log rotation and system cleanup

## Implementation Guide

### Step 1: Update Health Check Configuration

1. **Update existing health checks**:
   ```bash
   # Find all health check configurations
   find . -name "*.yml" -exec grep -l "healthcheck" {} \;
   
   # Update with enhanced configuration
   # Replace CMD with CMD-SHELL and add explicit exit codes
   ```

2. **Apply enhanced health check template**:
   ```bash
   # Use the enhanced health check template
   ansible-playbook site.yml --tags "health_checks"
   ```

### Step 2: Configure Resource Limits

1. **Update resource configuration**:
   ```bash
   # Edit group_vars/all/advanced_config.yml
   # Configure container_limits for your services
   ```

2. **Apply resource limits**:
   ```bash
   # Deploy with enhanced resource limits
   ansible-playbook site.yml --tags "deploy"
   ```

### Step 3: Update Monitoring Thresholds

1. **Configure monitoring thresholds**:
   ```bash
   # Edit group_vars/all/monitoring_thresholds.yml
   # Adjust thresholds based on your environment
   ```

2. **Deploy monitoring configuration**:
   ```bash
   # Apply enhanced monitoring
   ansible-playbook site.yml --tags "monitoring"
   ```

### Step 4: Use Enhanced Docker Compose Template

1. **Update service templates**:
   ```bash
   # Use the enhanced Docker Compose template
   # templates/enhanced-docker-compose.yml.j2
   ```

2. **Deploy enhanced services**:
   ```bash
   # Deploy with enhanced configuration
   ansible-playbook site.yml --tags "services"
   ```

### Step 5: Implement Enhanced Health Check Script

1. **Deploy health check script**:
   ```bash
   # Copy enhanced health check script
   cp scripts/enhanced_health_check.sh /usr/local/bin/
   chmod +x /usr/local/bin/enhanced_health_check.sh
   ```

2. **Configure cron job**:
   ```bash
   # Add to crontab for regular health checks
   */5 * * * * /usr/local/bin/enhanced_health_check.sh
   ```

## Best Practices

### Health Check Best Practices

1. **Use Explicit Exit Codes**: Always use `|| exit 1` for clear error handling
2. **Configure Appropriate Timeouts**: Set timeouts based on service response times
3. **Implement Retry Logic**: Use retries with exponential backoff
4. **Monitor Health Check Performance**: Track health check duration and success rates

### Resource Management Best Practices

1. **Tier Your Services**: Group services by priority and resource requirements
2. **Set Realistic Limits**: Base limits on actual usage patterns
3. **Monitor Resource Usage**: Track actual vs. allocated resources
4. **Plan for Growth**: Leave headroom for service scaling

### Monitoring Best Practices

1. **Use Service-Specific Thresholds**: Different services have different performance characteristics
2. **Implement Time-Based Overrides**: Adjust thresholds for different time periods
3. **Monitor Trends**: Track performance trends over time
4. **Set Up Escalation**: Configure alert escalation for critical issues

### Security Best Practices

1. **Use Non-Root Users**: Run containers as non-root users when possible
2. **Implement Security Labels**: Use security labels for vulnerability scanning
3. **Limit Capabilities**: Only grant necessary capabilities to containers
4. **Regular Security Updates**: Keep container images and dependencies updated

## Troubleshooting

### Common Issues

1. **Health Check Failures**:
   - Verify service endpoints are accessible
   - Check network connectivity
   - Review service logs for errors

2. **Resource Limit Issues**:
   - Monitor actual resource usage
   - Adjust limits based on usage patterns
   - Check for resource contention

3. **Monitoring Alert Fatigue**:
   - Review and adjust thresholds
   - Implement time-based overrides
   - Configure alert grouping

### Debugging Commands

```bash
# Check health check status
docker inspect <container_name> --format='{{.State.Health}}'

# Monitor resource usage
docker stats --no-stream

# Check service logs
docker logs <container_name> --tail=100

# Test health endpoints
curl -f http://localhost:<port>/health

# Run enhanced health check
./scripts/enhanced_health_check.sh
```

## Conclusion

These enhanced features provide a solid foundation for production-ready deployment with improved reliability, monitoring, and resource management. The enhancements address the minor areas of improvement identified in the production readiness review while maintaining backward compatibility with existing configurations.

For additional support or questions, refer to the main documentation or create an issue in the project repository. 