# Performance Tuning Guide

## Table of Contents

1. [Overview](#overview)
2. [Performance Monitoring](#performance-monitoring)
3. [System Optimization](#system-optimization)
4. [Resource Management](#resource-management)
5. [Database Optimization](#database-optimization)
6. [Network Optimization](#network-optimization)
7. [Application Optimization](#application-optimization)
8. [Container Optimization](#container-optimization)
9. [Storage Optimization](#storage-optimization)
10. [Best Practices](#best-practices)

## Overview

This guide provides comprehensive performance tuning procedures for the Ansible homelab infrastructure. It covers system optimization, resource management, and performance monitoring to ensure optimal performance and resource utilization.

## Performance Monitoring

### Performance Metrics

```yaml
# performance/metrics.yml
performance_metrics:
  system_metrics:
    cpu:
      - name: "cpu_usage_percent"
        description: "CPU utilization percentage"
        threshold:
          warning: 70
          critical: 90
      
      - name: "cpu_load_average"
        description: "System load average"
        threshold:
          warning: 2.0
          critical: 5.0
      
      - name: "cpu_iowait"
        description: "CPU I/O wait time"
        threshold:
          warning: 10
          critical: 25
    
    memory:
      - name: "memory_usage_percent"
        description: "Memory utilization percentage"
        threshold:
          warning: 80
          critical: 95
      
      - name: "swap_usage_percent"
        description: "Swap utilization percentage"
        threshold:
          warning: 20
          critical: 50
      
      - name: "memory_available"
        description: "Available memory in bytes"
        threshold:
          warning: "1GB"
          critical: "512MB"
    
    disk:
      - name: "disk_usage_percent"
        description: "Disk utilization percentage"
        threshold:
          warning: 80
          critical: 95
      
      - name: "disk_io_utilization"
        description: "Disk I/O utilization"
        threshold:
          warning: 70
          critical: 90
      
      - name: "disk_latency"
        description: "Disk I/O latency"
        threshold:
          warning: "10ms"
          critical: "50ms"
    
    network:
      - name: "network_bandwidth_usage"
        description: "Network bandwidth utilization"
        threshold:
          warning: 80
          critical: 95
      
      - name: "network_packet_loss"
        description: "Network packet loss percentage"
        threshold:
          warning: 1
          critical: 5
      
      - name: "network_latency"
        description: "Network latency"
        threshold:
          warning: "100ms"
          critical: "500ms"
```

### Performance Baselines

```yaml
# performance/baselines.yml
performance_baselines:
  system_baselines:
    cpu:
      normal_usage: "30-50%"
      peak_usage: "70-80%"
      idle_usage: "5-15%"
    
    memory:
      normal_usage: "60-75%"
      peak_usage: "85-90%"
      available: "2-4GB"
    
    disk:
      normal_usage: "50-70%"
      peak_usage: "80-85%"
      io_utilization: "20-40%"
    
    network:
      normal_bandwidth: "10-30%"
      peak_bandwidth: "60-80%"
      normal_latency: "5-20ms"
  
  application_baselines:
    web_services:
      response_time: "100-500ms"
      throughput: "100-1000 req/s"
      error_rate: "< 1%"
    
    database_services:
      query_time: "10-100ms"
      connections: "10-50"
      cache_hit_ratio: "> 90%"
    
    media_services:
      transcoding_speed: "1-5x realtime"
      streaming_quality: "1080p"
      concurrent_streams: "5-10"
```

## System Optimization

### Kernel Optimization

```yaml
# performance/kernel_optimization.yml
kernel_optimization:
  sysctl_parameters:
    # CPU and scheduler
    - name: "kernel.sched_autogroup_enabled"
      value: "1"
      description: "Enable automatic process grouping"
    
    - name: "kernel.sched_min_granularity_ns"
      value: "10000000"
      description: "Minimum scheduling granularity"
    
    - name: "kernel.sched_wakeup_granularity_ns"
      value: "15000000"
      description: "Wake-up scheduling granularity"
    
    # Memory management
    - name: "vm.swappiness"
      value: "10"
      description: "Reduce swap usage"
    
    - name: "vm.dirty_ratio"
      value: "15"
      description: "Dirty page ratio"
    
    - name: "vm.dirty_background_ratio"
      value: "5"
      description: "Background dirty page ratio"
    
    # File system
    - name: "fs.file-max"
      value: "65536"
      description: "Maximum number of open files"
    
    - name: "fs.inotify.max_user_watches"
      value: "524288"
      description: "Maximum inotify watches"
    
    # Network
    - name: "net.core.rmem_max"
      value: "16777216"
      description: "Maximum receive buffer size"
    
    - name: "net.core.wmem_max"
      value: "16777216"
      description: "Maximum send buffer size"
    
    - name: "net.ipv4.tcp_rmem"
      value: "4096 87380 16777216"
      description: "TCP receive buffer sizes"
    
    - name: "net.ipv4.tcp_wmem"
      value: "4096 65536 16777216"
      description: "TCP send buffer sizes"
```

### I/O Scheduler Optimization

```yaml
# performance/io_scheduler.yml
io_scheduler_optimization:
  scheduler_selection:
    ssd:
      scheduler: "none"
      description: "No scheduler for SSDs"
      advantages:
        - "lower_latency"
        - "better_performance"
        - "less_overhead"
    
    hdd:
      scheduler: "deadline"
      description: "Deadline scheduler for HDDs"
      advantages:
        - "predictable_latency"
        - "fair_queuing"
        - "request_merging"
  
  scheduler_parameters:
    deadline:
      - name: "read_expire"
        value: "500"
        description: "Read request expiration time (ms)"
      
      - name: "write_expire"
        value: "5000"
        description: "Write request expiration time (ms)"
      
      - name: "fifo_batch"
        value: "16"
        description: "Batch size for FIFO requests"
```

## Resource Management

### CPU Management

```yaml
# performance/cpu_management.yml
cpu_management:
  cpu_governor:
    - name: "performance"
      description: "Maximum performance mode"
      use_case: "high_performance_workloads"
      power_consumption: "high"
    
    - name: "powersave"
      description: "Power saving mode"
      use_case: "idle_systems"
      power_consumption: "low"
    
    - name: "ondemand"
      description: "Dynamic frequency scaling"
      use_case: "variable_workloads"
      power_consumption: "medium"
  
  cpu_affinity:
    - name: "critical_services"
      cpu_cores: "0,1"
      services:
        - "database"
        - "monitoring"
    
    - name: "media_services"
      cpu_cores: "2,3"
      services:
        - "plex"
        - "jellyfin"
    
    - name: "background_services"
      cpu_cores: "4-7"
      services:
        - "backup"
        - "maintenance"
```

### Memory Management

```yaml
# performance/memory_management.yml
memory_management:
  memory_allocation:
    - name: "critical_services"
      memory_limit: "2GB"
      services:
        - "database"
        - "monitoring"
    
    - name: "media_services"
      memory_limit: "4GB"
      services:
        - "plex"
        - "jellyfin"
    
    - name: "background_services"
      memory_limit: "1GB"
      services:
        - "backup"
        - "utilities"
  
  swap_optimization:
    - name: "swap_location"
      location: "ssd"
      description: "Place swap on SSD for better performance"
    
    - name: "swap_size"
      size: "8GB"
      description: "Swap size based on memory usage"
    
    - name: "swap_priority"
      priority: "10"
      description: "High priority for swap on SSD"
```

## Database Optimization

### PostgreSQL Optimization

```yaml
# performance/database/postgresql.yml
postgresql_optimization:
  memory_settings:
    - name: "shared_buffers"
      value: "25% of RAM"
      description: "Shared memory buffers"
    
    - name: "effective_cache_size"
      value: "75% of RAM"
      description: "Effective cache size"
    
    - name: "work_mem"
      value: "4MB"
      description: "Memory for query operations"
    
    - name: "maintenance_work_mem"
      value: "256MB"
      description: "Memory for maintenance operations"
  
  connection_settings:
    - name: "max_connections"
      value: "100"
      description: "Maximum number of connections"
    
    - name: "max_worker_processes"
      value: "8"
      description: "Maximum worker processes"
    
    - name: "max_parallel_workers"
      value: "8"
      description: "Maximum parallel workers"
  
  query_optimization:
    - name: "random_page_cost"
      value: "1.1"
      description: "Cost of random page access"
    
    - name: "effective_io_concurrency"
      value: "200"
      description: "Concurrent I/O operations"
    
    - name: "checkpoint_completion_target"
      value: "0.9"
      description: "Checkpoint completion target"
```

### MariaDB/MySQL Optimization

```yaml
# performance/database/mariadb.yml
mariadb_optimization:
  memory_settings:
    - name: "innodb_buffer_pool_size"
      value: "70% of RAM"
      description: "InnoDB buffer pool size"
    
    - name: "innodb_log_file_size"
      value: "256M"
      description: "InnoDB log file size"
    
    - name: "query_cache_size"
      value: "128M"
      description: "Query cache size"
    
    - name: "tmp_table_size"
      value: "64M"
      description: "Temporary table size"
  
  connection_settings:
    - name: "max_connections"
      value: "150"
      description: "Maximum connections"
    
    - name: "thread_cache_size"
      value: "16"
      description: "Thread cache size"
    
    - name: "table_open_cache"
      value: "2000"
      description: "Table open cache"
  
  performance_settings:
    - name: "innodb_flush_log_at_trx_commit"
      value: "2"
      description: "InnoDB flush log setting"
    
    - name: "innodb_flush_method"
      value: "O_DIRECT"
      description: "InnoDB flush method"
    
    - name: "innodb_file_per_table"
      value: "ON"
      description: "InnoDB file per table"
```

## Network Optimization

### Network Configuration

```yaml
# performance/network/optimization.yml
network_optimization:
  tcp_optimization:
    - name: "tcp_congestion_control"
      value: "bbr"
      description: "TCP congestion control algorithm"
    
    - name: "tcp_window_scaling"
      value: "enabled"
      description: "Enable TCP window scaling"
    
    - name: "tcp_timestamps"
      value: "enabled"
      description: "Enable TCP timestamps"
  
  buffer_optimization:
    - name: "rmem_default"
      value: "262144"
      description: "Default receive buffer size"
    
    - name: "rmem_max"
      value: "16777216"
      description: "Maximum receive buffer size"
    
    - name: "wmem_default"
      value: "262144"
      description: "Default send buffer size"
    
    - name: "wmem_max"
      value: "16777216"
      description: "Maximum send buffer size"
  
  queue_optimization:
    - name: "netdev_max_backlog"
      value: "5000"
      description: "Network device backlog"
    
    - name: "somaxconn"
      value: "65535"
      description: "Maximum socket connections"
```

### Network QoS

```yaml
# performance/network/qos.yml
network_qos:
  traffic_classes:
    - name: "critical"
      priority: "1"
      bandwidth: "20%"
      services:
        - "database"
        - "monitoring"
    
    - name: "important"
      priority: "2"
      bandwidth: "40%"
      services:
        - "web_services"
        - "authentication"
    
    - name: "normal"
      priority: "3"
      bandwidth: "30%"
      services:
        - "media_services"
        - "file_sharing"
    
    - name: "background"
      priority: "4"
      bandwidth: "10%"
      services:
        - "backup"
        - "maintenance"
```

## Application Optimization

### Web Server Optimization

```yaml
# performance/application/web_server.yml
web_server_optimization:
  nginx_optimization:
    worker_processes:
      value: "auto"
      description: "Number of worker processes"
    
    worker_connections:
      value: "1024"
      description: "Connections per worker"
    
    keepalive_timeout:
      value: "65"
      description: "Keep-alive timeout"
    
    client_max_body_size:
      value: "100M"
      description: "Maximum client body size"
  
  caching:
    - name: "static_content"
      location: "/static/"
      cache_time: "1d"
      description: "Cache static content"
    
    - name: "api_responses"
      location: "/api/"
      cache_time: "5m"
      description: "Cache API responses"
    
    - name: "media_content"
      location: "/media/"
      cache_time: "1h"
      description: "Cache media content"
```

### Application Performance

```yaml
# performance/application/optimization.yml
application_optimization:
  connection_pooling:
    - name: "database_connections"
      min_connections: "5"
      max_connections: "20"
      description: "Database connection pool"
    
    - name: "redis_connections"
      min_connections: "2"
      max_connections: "10"
      description: "Redis connection pool"
  
  caching_strategy:
    - name: "application_cache"
      type: "redis"
      ttl: "3600"
      description: "Application-level caching"
    
    - name: "session_cache"
      type: "redis"
      ttl: "1800"
      description: "Session caching"
    
    - name: "query_cache"
      type: "database"
      ttl: "300"
      description: "Database query caching"
```

## Container Optimization

### Docker Optimization

```yaml
# performance/container/docker.yml
docker_optimization:
  daemon_configuration:
    - name: "storage_driver"
      value: "overlay2"
      description: "Storage driver for containers"
    
    - name: "log_driver"
      value: "json-file"
      description: "Log driver for containers"
    
    - name: "log_max_size"
      value: "10m"
      description: "Maximum log file size"
    
    - name: "log_max_files"
      value: "3"
      description: "Maximum number of log files"
  
  resource_limits:
    - name: "cpu_limit"
      value: "2.0"
      description: "CPU limit per container"
    
    - name: "memory_limit"
      value: "2g"
      description: "Memory limit per container"
    
    - name: "disk_io_limit"
      value: "100MB/s"
      description: "Disk I/O limit per container"
  
  networking:
    - name: "network_mode"
      value: "bridge"
      description: "Default network mode"
    
    - name: "dns_servers"
      value: ["8.8.8.8", "8.8.4.4"]
      description: "DNS servers for containers"
```

### Container Orchestration

```yaml
# performance/container/orchestration.yml
container_orchestration:
  resource_allocation:
    - name: "critical_services"
      cpu_request: "0.5"
      cpu_limit: "1.0"
      memory_request: "512Mi"
      memory_limit: "1Gi"
      services:
        - "database"
        - "monitoring"
    
    - name: "media_services"
      cpu_request: "1.0"
      cpu_limit: "2.0"
      memory_request: "1Gi"
      memory_limit: "2Gi"
      services:
        - "plex"
        - "jellyfin"
    
    - name: "background_services"
      cpu_request: "0.1"
      cpu_limit: "0.5"
      memory_request: "128Mi"
      memory_limit: "256Mi"
      services:
        - "backup"
        - "utilities"
  
  scaling_policies:
    - name: "cpu_based_scaling"
      metric: "cpu_usage"
      threshold: "70%"
      min_replicas: "1"
      max_replicas: "5"
    
    - name: "memory_based_scaling"
      metric: "memory_usage"
      threshold: "80%"
      min_replicas: "1"
      max_replicas: "3"
```

## Storage Optimization

### File System Optimization

```yaml
# performance/storage/filesystem.yml
filesystem_optimization:
  mount_options:
    - name: "noatime"
      description: "Disable access time updates"
      performance_impact: "high"
    
    - name: "nodiratime"
      description: "Disable directory access time updates"
      performance_impact: "medium"
    
    - name: "relatime"
      description: "Relative access time updates"
      performance_impact: "medium"
    
    - name: "data=writeback"
      description: "Writeback data mode"
      performance_impact: "high"
  
  disk_scheduling:
    - name: "read_ahead"
      value: "2048"
      description: "Read-ahead buffer size"
    
    - name: "queue_depth"
      value: "128"
      description: "I/O queue depth"
    
    - name: "nr_requests"
      value: "128"
      description: "Number of requests per queue"
```

### RAID Optimization

```yaml
# performance/storage/raid.yml
raid_optimization:
  raid_levels:
    - name: "raid0"
      description: "Striping for performance"
      use_case: "temporary_data"
      performance: "high"
      redundancy: "none"
    
    - name: "raid1"
      description: "Mirroring for redundancy"
      use_case: "critical_data"
      performance: "medium"
      redundancy: "high"
    
    - name: "raid5"
      description: "Parity for redundancy"
      use_case: "general_storage"
      performance: "medium"
      redundancy: "medium"
    
    - name: "raid10"
      description: "Striped mirrors"
      use_case: "high_performance"
      performance: "high"
      redundancy: "high"
  
  stripe_size:
    - name: "small_files"
      size: "64KB"
      description: "Small file optimization"
    
    - name: "large_files"
      size: "256KB"
      description: "Large file optimization"
    
    - name: "database"
      size: "128KB"
      description: "Database optimization"
```

## Best Practices

### Performance Best Practices

1. **Monitoring and Measurement**
   - Establish performance baselines
   - Monitor key metrics continuously
   - Set appropriate thresholds
   - Regular performance reviews

2. **Resource Management**
   - Right-size resources
   - Implement resource limits
   - Monitor resource usage
   - Optimize resource allocation

3. **Caching Strategy**
   - Implement multiple cache layers
   - Use appropriate cache sizes
   - Monitor cache hit ratios
   - Regular cache optimization

4. **I/O Optimization**
   - Use appropriate I/O schedulers
   - Optimize file system settings
   - Implement RAID for performance
   - Monitor I/O patterns

### Optimization Best Practices

1. **System Level**
   - Kernel parameter tuning
   - I/O scheduler selection
   - Memory management
   - CPU governor selection

2. **Application Level**
   - Connection pooling
   - Query optimization
   - Caching implementation
   - Resource limits

3. **Network Level**
   - TCP optimization
   - Buffer tuning
   - QoS implementation
   - Bandwidth management

4. **Storage Level**
   - File system optimization
   - RAID configuration
   - I/O scheduling
   - Cache utilization

### Maintenance Best Practices

1. **Regular Maintenance**
   - Performance monitoring
   - Resource cleanup
   - Cache optimization
   - Log rotation

2. **Capacity Planning**
   - Growth projections
   - Resource planning
   - Performance forecasting
   - Scaling strategies

3. **Documentation**
   - Configuration documentation
   - Performance baselines
   - Optimization procedures
   - Troubleshooting guides

## Conclusion

Comprehensive performance tuning is essential for maintaining optimal system performance and resource utilization. This guide provides detailed procedures for implementing and maintaining effective performance optimization strategies.

Key takeaways:
- Establish performance baselines
- Implement comprehensive monitoring
- Optimize system resources
- Regular performance reviews
- Continuous improvement
- Proper documentation

For additional information, refer to:
- [Production Deployment Guide](PRODUCTION_DEPLOYMENT_GUIDE.md)
- [Monitoring and Alerting Guide](MONITORING_AND_ALERTING.md)
- [Security Compliance Guide](SECURITY_COMPLIANCE.md)
- [Environment Management Guide](ENVIRONMENT_MANAGEMENT.md) 