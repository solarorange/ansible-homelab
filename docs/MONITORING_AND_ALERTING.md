# Monitoring and Alerting Guide

## Table of Contents

1. [Overview](#overview)
2. [Monitoring Stack Architecture](#monitoring-stack-architecture)
3. [Prometheus Configuration](#prometheus-configuration)
4. [Grafana Dashboards](#grafana-dashboards)
5. [Loki Log Aggregation](#loki-log-aggregation)
6. [AlertManager Setup](#alertmanager-setup)
7. [Service Monitoring](#service-monitoring)
8. [Infrastructure Monitoring](#infrastructure-monitoring)
9. [Performance Monitoring](#performance-monitoring)
10. [Security Monitoring](#security-monitoring)
11. [Alerting Rules](#alerting-rules)
12. [Dashboard Management](#dashboard-management)
13. [Best Practices](#best-practices)

## Overview

This guide covers the comprehensive monitoring and alerting setup for the Ansible homelab infrastructure. The monitoring stack includes Prometheus for metrics collection, Grafana for visualization, Loki for log aggregation, and AlertManager for alert routing.

## Monitoring Stack Architecture

### Stack Components

```yaml
# Monitoring stack architecture
monitoring_stack:
  metrics_collection:
    - prometheus:
        port: 9090
        retention_days: 90
        storage: local
    
    - node_exporter:
        port: 9100
        collectors: all
    
    - cadvisor:
        port: 8080
        container_metrics: true
  
  visualization:
    - grafana:
        port: 3000
        dashboards: auto
        plugins: enabled
  
  log_aggregation:
    - loki:
        port: 3100
        retention_days: 30
    
    - promtail:
        config: /etc/promtail/config.yml
  
  alerting:
    - alertmanager:
        port: 9093
        receivers:
          - email
          - slack
          - pagerduty
```

### Network Architecture

```yaml
# Monitoring network configuration
monitoring_network:
  internal_ports:
    - 9090: prometheus
    - 3000: grafana
    - 3100: loki
    - 9093: alertmanager
    - 9100: node_exporter
    - 8080: cadvisor
  
  external_access:
    - 3000: grafana_dashboard
    - 9090: prometheus_api
  
  security:
    - authentication: required
    - ssl: enabled
    - firewall: configured
```

## Prometheus Configuration

### Prometheus Configuration File

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    environment: "{{ environment }}"
    datacenter: "{{ datacenter }}"

rule_files:
  - "alerting_rules.yml"
  - "recording_rules.yml"

scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
    scrape_interval: 30s

  # Docker containers
  - job_name: 'docker'
    static_configs:
      - targets: ['localhost:8080']
    metrics_path: /metrics
    scrape_interval: 30s

  # Ansible services
  - job_name: 'ansible-services'
    static_configs:
      - targets:
        - 'localhost:32400'  # Plex
        - 'localhost:8096'   # Jellyfin
        - 'localhost:8989'   # Sonarr
        - 'localhost:7878'   # Radarr
        - 'localhost:8080'   # Portainer
    scrape_interval: 60s
    metrics_path: /metrics

  # Database services
  - job_name: 'databases'
    static_configs:
      - targets:
        - 'localhost:5432'   # PostgreSQL
        - 'localhost:3306'   # MariaDB
        - 'localhost:6379'   # Redis
    scrape_interval: 30s

  # Monitoring stack
  - job_name: 'monitoring'
    static_configs:
      - targets:
        - 'localhost:3000'   # Grafana
        - 'localhost:3100'   # Loki
        - 'localhost:9093'   # AlertManager
    scrape_interval: 30s

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - localhost:9093
```

### Service Discovery

```yaml
# Service discovery configuration
service_discovery:
  docker:
    enabled: true
    cadvisor_endpoint: "http://localhost:8080"
    container_labels:
      - "monitoring.enabled=true"
  
  kubernetes:
    enabled: false
    api_server: "https://kubernetes.default.svc"
  
  consul:
    enabled: false
    server: "localhost:8500"
```

## Grafana Dashboards

### Dashboard Configuration

```yaml
# grafana/dashboards.yml
dashboards:
  - name: "Homelab Overview"
    description: "Main dashboard for homelab services"
    panels:
      - title: "System Overview"
        type: "stat"
        targets:
          - expr: "node_cpu_seconds_total{mode!='idle'}"
            legend: "CPU Usage"
      
      - title: "Memory Usage"
        type: "stat"
        targets:
          - expr: "node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes"
            legend: "Memory Used"
      
      - title: "Disk Usage"
        type: "stat"
        targets:
          - expr: "node_filesystem_size_bytes - node_filesystem_avail_bytes"
            legend: "Disk Used"
      
      - title: "Network Traffic"
        type: "graph"
        targets:
          - expr: "rate(node_network_receive_bytes_total[5m])"
            legend: "Network Receive"
          - expr: "rate(node_network_transmit_bytes_total[5m])"
            legend: "Network Transmit"
  
  - name: "Service Health"
    description: "Service status and health monitoring"
    panels:
      - title: "Service Status"
        type: "stat"
        targets:
          - expr: "up"
            legend: "Service Status"
      
      - title: "Response Time"
        type: "graph"
        targets:
          - expr: "http_request_duration_seconds"
            legend: "Response Time"
      
      - title: "Error Rate"
        type: "graph"
        targets:
          - expr: "rate(http_requests_total{status=~'5..'}[5m])"
            legend: "5xx Errors"
  
  - name: "Container Metrics"
    description: "Docker container monitoring"
    panels:
      - title: "Container CPU Usage"
        type: "graph"
        targets:
          - expr: "rate(container_cpu_usage_seconds_total[5m])"
            legend: "CPU Usage"
      
      - title: "Container Memory Usage"
        type: "graph"
        targets:
          - expr: "container_memory_usage_bytes"
            legend: "Memory Usage"
      
      - title: "Container Network I/O"
        type: "graph"
        targets:
          - expr: "rate(container_network_receive_bytes_total[5m])"
            legend: "Network Receive"
          - expr: "rate(container_network_transmit_bytes_total[5m])"
            legend: "Network Transmit"
```

### Dashboard Templates

```yaml
# grafana/dashboard_templates.yml
dashboard_templates:
  - name: "Service Template"
    description: "Template for service-specific dashboards"
    variables:
      - name: "service_name"
        type: "query"
        query: "label_values(up, service)"
      
      - name: "instance"
        type: "query"
        query: "label_values(up{service=\"$service_name\"}, instance)"
    
    panels:
      - title: "$service_name Status"
        type: "stat"
        targets:
          - expr: "up{service=\"$service_name\", instance=\"$instance\"}"
      
      - title: "$service_name Response Time"
        type: "graph"
        targets:
          - expr: "http_request_duration_seconds{service=\"$service_name\", instance=\"$instance\"}"
      
      - title: "$service_name Error Rate"
        type: "graph"
        targets:
          - expr: "rate(http_requests_total{service=\"$service_name\", instance=\"$instance\", status=~'5..'}[5m])"
```

## Loki Log Aggregation

### Loki Configuration

```yaml
# loki/config.yml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2020-05-15
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /tmp/loki/boltdb-shipper-active
    cache_location: /tmp/loki/boltdb-shipper-cache
    cache_ttl: 24h
    shared_store: filesystem
  filesystem:
    directory: /tmp/loki/chunks

compactor:
  working_directory: /tmp/loki/boltdb-shipper-compactor
  shared_store: filesystem

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: false
  retention_period: 0s
```

### Promtail Configuration

```yaml
# promtail/config.yml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log

  - job_name: containers
    static_configs:
      - targets:
          - localhost
        labels:
          job: containerlogs
          __path__: /var/lib/docker/containers/*/*log

  - job_name: ansible
    static_configs:
      - targets:
          - localhost
        labels:
          job: ansible
          __path__: /var/log/ansible/*.log

  - job_name: services
    static_configs:
      - targets:
          - localhost
        labels:
          job: services
          __path__: /opt/homelab/logs/*.log
```

## AlertManager Setup

### AlertManager Configuration

```yaml
# alertmanager/config.yml
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty-critical'
      continue: true
    - match:
        severity: warning
      receiver: 'slack-warning'

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'

  - name: 'slack-warning'
    slack_configs:
      - channel: '#alerts'
        title: '{{ template "slack.title" . }}'
        text: '{{ template "slack.text" . }}'
        send_resolved: true

  - name: 'pagerduty-critical'
    pagerduty_configs:
      - routing_key: YOUR_PAGERDUTY_KEY
        description: '{{ template "pagerduty.description" . }}'
        severity: '{{ if eq .CommonLabels.severity "critical" }}critical{{ else }}warning{{ end }}'

templates:
  - '/etc/alertmanager/template/*.tmpl'

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
```

### Alert Templates

```yaml
# alertmanager/templates/slack.tmpl
{{ define "slack.title" }}
[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .CommonLabels.alertname }}
{{ end }}

{{ define "slack.text" }}
{{ range .Alerts }}
*Alert:* {{ .Annotations.summary }}
*Description:* {{ .Annotations.description }}
*Severity:* {{ .Labels.severity }}
*Instance:* {{ .Labels.instance }}
*Started:* {{ .StartsAt | since }}
{{ if .EndsAt }}*Ended:* {{ .EndsAt | since }}{{ end }}
{{ end }}
{{ end }}
```

## Service Monitoring

### Service Health Checks

```yaml
# monitoring/service_health.yml
service_health_checks:
  - name: "plex"
    url: "http://localhost:32400/web/index.html"
    expected_status: 200
    timeout: 30
    interval: 60
    
  - name: "jellyfin"
    url: "http://localhost:8096/health"
    expected_status: 200
    timeout: 30
    interval: 60
    
  - name: "sonarr"
    url: "http://localhost:8989/health"
    expected_status: 200
    timeout: 30
    interval: 60
    
  - name: "radarr"
    url: "http://localhost:7878/health"
    expected_status: 200
    timeout: 30
    interval: 60
    
  - name: "portainer"
    url: "http://localhost:9000/api/status"
    expected_status: 200
    timeout: 30
    interval: 60
    
  - name: "grafana"
    url: "http://localhost:3000/api/health"
    expected_status: 200
    timeout: 30
    interval: 60
    
  - name: "prometheus"
    url: "http://localhost:9090/-/healthy"
    expected_status: 200
    timeout: 30
    interval: 60
```

### Database Monitoring

```yaml
# monitoring/database_monitoring.yml
database_monitoring:
  postgresql:
    enabled: true
    connection_string: "postgresql://user:pass@localhost:5432/homelab"
    metrics:
      - active_connections
      - slow_queries
      - cache_hit_ratio
      - replication_lag
    
  mariadb:
    enabled: true
    connection_string: "mysql://user:pass@localhost:3306/homelab"
    metrics:
      - active_connections
      - slow_queries
      - cache_hit_ratio
      - replication_status
    
  redis:
    enabled: true
    connection_string: "redis://localhost:6379"
    metrics:
      - connected_clients
      - used_memory
      - hit_rate
      - keyspace_hits
```

## Infrastructure Monitoring

### System Metrics

```yaml
# monitoring/system_metrics.yml
system_metrics:
  cpu:
    - usage_percent
    - load_average
    - temperature
    - frequency
    
  memory:
    - usage_percent
    - available_bytes
    - swap_usage
    - page_faults
    
  disk:
    - usage_percent
    - io_operations
    - io_time
    - queue_length
    
  network:
    - bytes_sent
    - bytes_received
    - packets_sent
    - packets_received
    - errors
    - drops
```

### Container Metrics

```yaml
# monitoring/container_metrics.yml
container_metrics:
  - name: "cpu_usage"
    query: "rate(container_cpu_usage_seconds_total[5m])"
    description: "Container CPU usage"
    
  - name: "memory_usage"
    query: "container_memory_usage_bytes"
    description: "Container memory usage"
    
  - name: "network_io"
    query: "rate(container_network_receive_bytes_total[5m])"
    description: "Container network I/O"
    
  - name: "disk_io"
    query: "rate(container_fs_reads_bytes_total[5m])"
    description: "Container disk I/O"
```

## Performance Monitoring

### Performance Metrics

```yaml
# monitoring/performance_metrics.yml
performance_metrics:
  response_time:
    - name: "http_request_duration_seconds"
      description: "HTTP request duration"
      thresholds:
        warning: 1.0
        critical: 5.0
    
  throughput:
    - name: "http_requests_total"
      description: "HTTP requests per second"
      thresholds:
        warning: 100
        critical: 500
    
  error_rate:
    - name: "http_requests_total{status=~'5..'}"
      description: "HTTP 5xx error rate"
      thresholds:
        warning: 0.01
        critical: 0.05
    
  resource_utilization:
    - name: "node_cpu_seconds_total"
      description: "CPU utilization"
      thresholds:
        warning: 0.8
        critical: 0.95
    
    - name: "node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes"
      description: "Memory utilization"
      thresholds:
        warning: 0.85
        critical: 0.95
```

## Security Monitoring

### Security Metrics

```yaml
# monitoring/security_metrics.yml
security_metrics:
  authentication:
    - name: "failed_login_attempts"
      description: "Failed login attempts"
      thresholds:
        warning: 10
        critical: 50
    
    - name: "successful_logins"
      description: "Successful logins"
      thresholds:
        warning: 100
        critical: 500
    
  network_security:
    - name: "firewall_blocked_connections"
      description: "Firewall blocked connections"
      thresholds:
        warning: 100
        critical: 1000
    
    - name: "suspicious_connections"
      description: "Suspicious network connections"
      thresholds:
        warning: 5
        critical: 20
    
  system_security:
    - name: "system_updates_available"
      description: "Available system updates"
      thresholds:
        warning: 5
        critical: 20
    
    - name: "vulnerability_scan_results"
      description: "Security vulnerabilities"
      thresholds:
        warning: 1
        critical: 5
```

## Alerting Rules

### Alert Rules Configuration

```yaml
# alerting/rules.yml
groups:
  - name: homelab_alerts
    rules:
      # System alerts
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for more than 5 minutes"
      
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is above 85% for more than 5 minutes"
      
      - alert: HighDiskUsage
        expr: (node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100 > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High disk usage on {{ $labels.instance }}"
          description: "Disk usage is above 90% for more than 5 minutes"
      
      # Service alerts
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.job }} is down on {{ $labels.instance }}"
          description: "Service has been down for more than 1 minute"
      
      - alert: HighResponseTime
        expr: http_request_duration_seconds > 5
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High response time for {{ $labels.job }}"
          description: "Response time is above 5 seconds for more than 2 minutes"
      
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate for {{ $labels.job }}"
          description: "Error rate is above 5% for more than 2 minutes"
      
      # Container alerts
      - alert: ContainerRestarting
        expr: increase(container_start_time_seconds[15m]) > 0
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "Container {{ $labels.name }} is restarting frequently"
          description: "Container has restarted in the last 15 minutes"
      
      - alert: ContainerHighMemory
        expr: container_memory_usage_bytes / container_spec_memory_limit_bytes * 100 > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Container {{ $labels.name }} using high memory"
          description: "Container memory usage is above 90%"
      
      # Database alerts
      - alert: DatabaseConnectionHigh
        expr: pg_stat_database_numbackends > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High database connections on {{ $labels.instance }}"
          description: "Database has more than 80 active connections"
      
      - alert: DatabaseSlowQueries
        expr: rate(pg_stat_activity_max_tx_duration[5m]) > 30
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "Slow database queries on {{ $labels.instance }}"
          description: "Database has queries running longer than 30 seconds"
```

## Dashboard Management

### Dashboard Provisioning

```yaml
# grafana/provisioning/dashboards/dashboard.yml
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /etc/grafana/provisioning/dashboards
```

### Dashboard Organization

```yaml
# dashboard_organization.yml
dashboard_organization:
  folders:
    - name: "Infrastructure"
      dashboards:
        - "System Overview"
        - "Network Monitoring"
        - "Storage Monitoring"
    
    - name: "Services"
      dashboards:
        - "Service Health"
        - "Media Services"
        - "Database Services"
    
    - name: "Security"
      dashboards:
        - "Security Overview"
        - "Authentication Logs"
        - "Network Security"
    
    - name: "Performance"
      dashboards:
        - "Performance Overview"
        - "Response Times"
        - "Resource Utilization"
```

## Best Practices

### Monitoring Best Practices

1. **Metric Collection**
   - Collect relevant metrics only
   - Use appropriate scrape intervals
   - Implement metric cardinality limits
   - Monitor metric collection itself

2. **Alerting**
   - Set appropriate thresholds
   - Use meaningful alert names
   - Include relevant context in alerts
   - Avoid alert fatigue

3. **Dashboard Design**
   - Keep dashboards focused
   - Use consistent naming
   - Include time ranges
   - Add documentation

4. **Performance**
   - Optimize queries
   - Use recording rules
   - Implement proper retention
   - Monitor storage usage

### Alerting Best Practices

1. **Alert Design**
   - Clear and actionable alerts
   - Appropriate severity levels
   - Meaningful descriptions
   - Include troubleshooting steps

2. **Alert Routing**
   - Route to appropriate teams
   - Use escalation policies
   - Implement alert grouping
   - Avoid duplicate alerts

3. **Alert Management**
   - Regular alert reviews
   - Update thresholds as needed
   - Document alert procedures
   - Test alert delivery

### Log Management Best Practices

1. **Log Collection**
   - Collect structured logs
   - Use appropriate log levels
   - Implement log rotation
   - Monitor log volume

2. **Log Analysis**
   - Use log aggregation
   - Implement log parsing
   - Create log dashboards
   - Set up log alerts

3. **Log Retention**
   - Define retention policies
   - Implement log compression
   - Monitor storage usage
   - Regular log cleanup

## Conclusion

Comprehensive monitoring and alerting is crucial for maintaining a reliable and secure infrastructure. This guide provides detailed procedures for setting up and managing monitoring and alerting for your Ansible homelab infrastructure.

Key takeaways:
- Implement comprehensive monitoring
- Set up appropriate alerting
- Design effective dashboards
- Follow monitoring best practices
- Regular maintenance and updates
- Continuous improvement

For additional information, refer to:
- [Production Deployment Guide](PRODUCTION_DEPLOYMENT_GUIDE.md)
- [Environment Management Guide](ENVIRONMENT_MANAGEMENT.md)
- [CI/CD Integration Guide](CI_CD_INTEGRATION.md)
- [Security Compliance Guide](SECURITY_COMPLIANCE.md) 