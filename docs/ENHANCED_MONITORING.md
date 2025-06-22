# Enhanced Monitoring Infrastructure

## Overview

This document describes the enhanced monitoring infrastructure that replaces Uptime Kuma with a more comprehensive Prometheus + Blackbox Exporter + Alertmanager solution.

## Architecture

### Components

1. **Prometheus** - Time-series database and alerting engine
2. **Blackbox Exporter** - External service monitoring with SSL certificate validation
3. **Alertmanager** - Alert routing and notification management
4. **Grafana** - Visualization and dashboards
5. **Node Exporter** - System metrics collection
6. **cAdvisor** - Container metrics collection
7. **Telegraf** - Additional metrics collection
8. **Loki** - Log aggregation
9. **Promtail** - Log collection

### Monitoring Capabilities

#### External Service Monitoring
- **HTTP/HTTPS endpoint monitoring** with response time tracking
- **SSL certificate validation** with expiry monitoring (48h warning, 7-day notice)
- **DNS resolution monitoring**
- **Network connectivity monitoring** (ICMP ping)
- **TCP connection monitoring**

#### Internal Service Monitoring
- **Container health monitoring**
- **Service availability tracking**
- **Resource usage monitoring** (CPU, memory, disk)
- **Network performance monitoring**

#### Alerting
- **Multi-channel notifications** (Email, Telegram, Webhooks)
- **Service-specific alert routing**
- **Alert inhibition and silencing**
- **Escalation policies**

## Configuration

### Blackbox Exporter

The Blackbox Exporter is configured with multiple probe types:

```yaml
modules:
  http_2xx:          # HTTP monitoring
  https_2xx:         # HTTPS with SSL validation
  http_post_2xx:     # API monitoring
  tcp_connect:       # TCP connectivity
  tcp_tls:           # TCP with TLS
  dns_udp_53:        # DNS resolution
  icmp:              # Network ping
```

### Prometheus Scrape Configs

#### External Services
- `external_services_http` - General HTTP monitoring
- `external_services_https` - HTTPS with SSL certificate validation
- `dns_monitoring` - DNS resolution checks
- `network_ping` - Network connectivity

#### Internal Services
- `internal_services` - Core monitoring infrastructure
- `media_services` - Media stack monitoring
- `security_services` - Security services monitoring
- `infrastructure_services` - Infrastructure services

### Alert Rules

#### SSL Certificate Alerts
```yaml
- alert: SSLCertExpiringSoon
  expr: probe_ssl_earliest_cert_expiry - time() < 86400 * 2  # 48 hours
  for: 1m
  labels:
    severity: critical
    service: 'ssl'

- alert: SSLCertExpiringWarning
  expr: probe_ssl_earliest_cert_expiry - time() < 86400 * 7  # 7 days
  for: 1m
  labels:
    severity: warning
    service: 'ssl'
```

#### Service Availability Alerts
```yaml
- alert: ServiceDown
  expr: probe_success == 0
  for: 1m
  labels:
    severity: critical
    service: 'availability'

- alert: ServiceHighLatency
  expr: probe_duration_seconds > 2
  for: 5m
  labels:
    severity: warning
    service: 'availability'
```

## Dashboards

### SSL Certificate Monitoring
- Certificate expiry countdown
- SSL validation status
- Certificate details per service

### Service Availability
- Service status overview
- Response time trends
- Uptime statistics

### Network Monitoring
- DNS resolution status
- Network connectivity
- Ping response times

## Management

### Blackbox Exporter Management
```bash
# Test a service
./manage.sh test https://grafana.domain.com

# Check SSL certificate
./manage.sh cert https://traefik.domain.com

# Test DNS resolution
./manage.sh dns domain.com

# Test network connectivity
./manage.sh ping 8.8.8.8
```

### Alertmanager Management
```bash
# View current alerts
./manage.sh alerts

# View silences
./manage.sh silences

# Test notifications
./manage.sh test

# Reload configuration
./manage.sh reload
```

### Prometheus Management
```bash
# Check targets
curl http://localhost:9090/api/v1/targets

# Check rules
curl http://localhost:9090/api/v1/rules

# Query metrics
curl "http://localhost:9090/api/v1/query?query=probe_success"
```

## Benefits Over Uptime Kuma

### Enhanced Capabilities
1. **SSL Certificate Monitoring** - Automatic expiry tracking with 48h critical alerts
2. **Rich Metrics** - Detailed performance metrics, not just up/down
3. **Advanced Alerting** - Sophisticated routing and notification management
4. **Log Integration** - Correlation with Loki logs
5. **Custom Dashboards** - Flexible Grafana dashboards
6. **Scalability** - Can handle hundreds of services efficiently

### Monitoring Depth
- **Uptime Kuma**: Basic up/down monitoring with simple notifications
- **Enhanced Stack**: Comprehensive monitoring with:
  - Response time tracking
  - SSL certificate validation
  - DNS resolution monitoring
  - Network connectivity checks
  - Resource usage monitoring
  - Log correlation
  - Custom alerting rules

### Alert Management
- **Uptime Kuma**: Basic email/webhook notifications
- **Enhanced Stack**: 
  - Multi-channel notifications (Email, Telegram, Webhooks)
  - Service-specific alert routing
  - Alert inhibition and silencing
  - Escalation policies
  - Rich HTML email templates

## Migration from Uptime Kuma

### Steps Completed
1. ✅ Removed Uptime Kuma from enabled services
2. ✅ Enhanced Blackbox Exporter configuration
3. ✅ Updated Prometheus scrape configs
4. ✅ Created comprehensive alert rules
5. ✅ Enhanced Alertmanager configuration
6. ✅ Created Grafana dashboards
7. ✅ Updated homepage configuration

### Next Steps
1. Deploy the enhanced monitoring stack
2. Configure notification channels (email, Telegram)
3. Customize dashboards as needed
4. Set up alert silences for maintenance windows
5. Monitor and tune alert thresholds

## Access URLs

- **Grafana**: https://grafana.{{ domain }}
- **Prometheus**: https://prometheus.{{ domain }}
- **Alertmanager**: https://alertmanager.{{ domain }}
- **Blackbox Exporter**: https://blackbox.{{ domain }}

## Troubleshooting

### Common Issues

#### SSL Certificate Alerts
- Check certificate expiry dates
- Verify certificate chain
- Ensure proper DNS resolution

#### Service Down Alerts
- Check service health endpoints
- Verify network connectivity
- Review service logs

#### High Latency Alerts
- Check network performance
- Review service resource usage
- Monitor database performance

### Health Checks
```bash
# Check Blackbox Exporter
curl http://localhost:9115/-/healthy

# Check Prometheus
curl http://localhost:9090/-/healthy

# Check Alertmanager
curl http://localhost:9093/-/healthy

# Check Grafana
curl http://localhost:3000/api/health
```

## Maintenance

### Regular Tasks
1. **Weekly**: Review alert thresholds and adjust as needed
2. **Monthly**: Update SSL certificate monitoring targets
3. **Quarterly**: Review and optimize dashboard queries
4. **Annually**: Audit monitoring coverage and add new services

### Backup
- Prometheus data: `/prometheus`
- Alertmanager data: `/alertmanager`
- Grafana dashboards: `/grafana/provisioning/dashboards`
- Configuration files: Version controlled in Ansible

This enhanced monitoring infrastructure provides enterprise-grade monitoring capabilities that far exceed what Uptime Kuma could offer, with comprehensive SSL certificate monitoring, advanced alerting, and rich visualization options. 