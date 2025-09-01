# Enhanced Logging Infrastructure - Production Ready

## Overview

This document describes the production-ready enhanced logging infrastructure for the Ansible homelab project. The system provides comprehensive, structured logging for all services with enterprise-grade features including centralized log aggregation, advanced dashboards, log-based alerting, and performance optimization.

## Architecture

### Components

1. **Loki** - Log aggregation and storage
2. **Promtail** - Log collection and forwarding
3. **Grafana** - Visualization and dashboards
4. **Alertmanager** - Alert routing and notification
5. **Prometheus** - Metrics collection and alerting

### Data Flow

```
Services → Promtail → Loki → Grafana
                ↓
            Alertmanager → Notifications
```

## Production Fixes Applied

### 1. Port Conflict Resolution
- **Issue**: Service-specific configs had conflicting port 9080
- **Fix**: Removed server sections from service configs, centralized in main Promtail
- **Impact**: Eliminates port conflicts and ensures single Promtail instance

### 2. Job Name Uniqueness
- **Issue**: Duplicate job names across service configs
- **Fix**: Added service prefixes (e.g., `media_sonarr`, `security_authentik`)
- **Impact**: Prevents job name conflicts and enables proper log routing

### 3. Structured Logging Pipeline
- **Issue**: Missing structured log parsing
- **Fix**: Added pipeline stages for JSON parsing, timestamp extraction, and label assignment
- **Impact**: Enables advanced log filtering and analysis

### 4. Performance Optimization
- **Issue**: No batch processing or rate limiting
- **Fix**: Added batch configuration, rate limiting, and performance tuning
- **Impact**: Improves throughput and reduces resource usage

### 5. Error Handling
- **Issue**: Missing error handling for missing log files
- **Fix**: Added proper regex patterns and fallback handling
- **Impact**: Prevents Promtail crashes and improves reliability

## Service Coverage

### Media Services
- **ARR Suite**: Sonarr, Radarr, Lidarr, Readarr, Bazarr, Prowlarr
- **Downloaders**: SABnzbd, qBittorrent, Transmission
- **Media Players**: Jellyfin, Emby, Plex
- **Processing**: Tdarr, HandBrake
- **Management**: Overseerr, Tautulli
- **Photos**: Immich
- **Utilities**: Pulsarr

### Security Services
- **Authentication**: Authentik, Vault
- **Network Security**: Pi-hole, AdGuard Home
- **Intrusion Detection**: Fail2ban, CrowdSec
- **Firewall**: UFW, iptables
- **VPN**: WireGuard, OpenVPN
- **Audit**: Auditd
- **Monitoring**: Fing

### Database Services
- **Relational**: PostgreSQL, MySQL/MariaDB
- **Cache**: Redis, Memcached
- **Search**: Elasticsearch, Solr
- **Time Series**: InfluxDB, Prometheus
- **Document**: MongoDB
- **Management**: phpMyAdmin, Adminer

### Monitoring Services
- **Metrics**: Prometheus, Node Exporter, cAdvisor, Telegraf
- **Visualization**: Grafana
- **Logging**: Loki, Promtail
- **Alerting**: Alertmanager
- **Discovery**: Consul
- **Utilities**: Uptime Kuma, Netdata

### Storage Services
- **File Systems**: Samba, NFS
- **Cloud Storage**: Nextcloud, Syncthing
- **Backup**: Restic, Duplicati
- **Monitoring**: Performance monitoring
- **Utilities**: Rsync

## Configuration Structure

### Main Promtail Configuration
```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

clients:
  - url: http://loki:3100/loki/api/v1/push
    batchwait: 1s
    batchsize: 1048576
    rate_limit: 1000

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
```

### Service-Specific Configurations
Each service category has its own configuration file:
- `media.yml.j2` - Media services logging
- `security.yml.j2` - Security services logging
- `databases.yml.j2` - Database services logging
- `monitoring.yml.j2` - Monitoring services logging
- `storage.yml.j2` - Storage services logging

### Pipeline Stages
Each service includes structured logging pipeline:
```yaml
pipeline_stages:
  - match:
      selector: '{job="service_name"}'
      stages:
        - json:
            expressions:
              timestamp: time
              level: level
              message: message
        - timestamp:
            source: timestamp
            format: RFC3339Nano
        - labels:
            level:
            service:
            component:
            category:
```

## Grafana Dashboards

### System Overview Dashboard
- Log ingestion rate
- Recent logs by service
- Error and warning rates
- Log volume by component
- Host-based filtering

### Media Services Dashboard
- ARR services performance
- Download progress monitoring
- Media processing status
- Player activity tracking
- Error rate analysis

### Security Services Dashboard
- Authentication events
- Security incidents
- Network traffic analysis
- VPN connection status
- Audit log monitoring

## Alerting Rules

### Log-Based Alerts
- High error rates (>5% for 5 minutes)
- Service unavailability
- Security incidents
- Performance degradation
- Backup failures

### Alert Configuration
```yaml
groups:
  - name: log_alerts
    rules:
      - alert: HighErrorRate
        expr: rate({level="error"}[5m]) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
```

## Performance Optimization

### Batch Processing
- Batch size: 1MB
- Batch wait: 1 second
- Rate limit: 1000 logs/second

### Resource Limits
- Memory limits per service
- CPU allocation
- Disk I/O optimization
- Network bandwidth management

### Retention Strategy
- Hot storage: 7 days
- Warm storage: 30 days
- Cold storage: 90 days
- Archive: 1 year

## Deployment

### Prerequisites
- Docker and Docker Compose
- Ansible 2.9+
- 4GB+ RAM
- 50GB+ storage

### Installation
```bash
# Deploy enhanced logging
ansible-playbook -i inventory.yml main.yml --tags logging,enhanced

# Verify deployment
ansible-playbook -i inventory.yml main.yml --tags logging,enhanced,verification
```

### Configuration Files
- Main Promtail: `{{ docker_dir }}/monitoring/promtail/config/promtail.yml`
- Service Configs: `{{ docker_dir }}/monitoring/logging/service-configs/`
- Dashboards: `{{ docker_dir }}/monitoring/grafana/provisioning/dashboards/`
- Alert Rules: `{{ docker_dir }}/monitoring/prometheus/rules/`

## Management Tools

### Log Analysis Script
```bash
# Analyze logs by service
./scripts/log-analysis.sh --service sonarr --time 1h

# Search for errors
./scripts/log-analysis.sh --level error --time 24h

# Performance analysis
./scripts/log-analysis.sh --performance --time 7d
```

### Health Check Script
```bash
# Check overall health
./scripts/healthcheck.sh

# Check specific service
./scripts/healthcheck.sh --service grafana
```

### Performance Monitoring
```bash
# Monitor log volume
./scripts/log-performance.sh

# Check resource usage
./scripts/log-performance.sh --resources
```

## Troubleshooting

### Common Issues

1. **Promtail Not Starting**
   - Check port conflicts
   - Verify configuration syntax
   - Check file permissions

2. **Logs Not Appearing**
   - Verify log file paths
   - Check Promtail job configuration
   - Verify Loki connectivity

3. **High Resource Usage**
   - Adjust batch settings
   - Review log volume
   - Optimize pipeline stages

### Debug Commands
```bash
# Check Promtail config
docker exec promtail promtail --config.file=/etc/promtail/config.yml --check-config

# Test Loki connectivity
curl http://loki:3100/ready

# View Promtail logs
docker logs promtail

# Check log collection
docker exec promtail wc -l /var/lib/docker/containers/*/*-json.log
```

## Monitoring and Maintenance

### Daily Tasks
- Review error rates
- Check log volume trends
- Verify alert delivery
- Monitor resource usage

### Weekly Tasks
- Review retention policies
- Update dashboard queries
- Analyze performance metrics
- Backup configurations

### Monthly Tasks
- Review alert thresholds
- Update service configurations
- Performance optimization
- Security audit

## Security Considerations

### Access Control
- Grafana authentication required
- API key management
- Role-based access control
- Audit logging enabled

### Data Protection
- Log encryption in transit
- Secure storage configuration
- Regular security updates
- Vulnerability scanning

### Compliance
- GDPR compliance for log data
- Data retention policies
- Audit trail maintenance
- Privacy protection measures

## Future Enhancements

### Planned Features
- Machine learning anomaly detection
- Advanced correlation analysis
- Custom alert rules builder
- Integration with external SIEM
- Real-time log streaming
- Advanced visualization options

### Scalability Improvements
- Multi-node Loki cluster
- Horizontal Promtail scaling
- Load balancing configuration
- Distributed storage backend

## Support and Documentation

### Resources
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Promtail Configuration](https://grafana.com/docs/loki/latest/clients/promtail/)
- [Grafana Dashboards](https://grafana.com/docs/grafana/latest/dashboards/)
- [Alertmanager Configuration](https://prometheus.io/docs/alerting/latest/alertmanager/)

### Community Support
- GitHub Issues
- Discord Community
- Stack Overflow
- Reddit r/homelab

## Conclusion

The enhanced logging infrastructure provides a production-ready solution for comprehensive log management in the homelab environment. With proper configuration, monitoring, and maintenance, this system will provide valuable insights into service performance, security events, and operational health.

For questions or support, please refer to the troubleshooting section or community resources listed above. 