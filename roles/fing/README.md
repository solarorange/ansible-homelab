# Fing Network Monitoring Role

A comprehensive Ansible role for deploying Fing network monitoring service in a production homelab environment with full integration to existing infrastructure.

## Overview

Fing is a powerful network device discovery and monitoring tool that provides real-time visibility into your network infrastructure. This role deploys Fing with full integration to your existing monitoring stack, security services, and dashboard.

## Features

### Core Functionality
- **Network Device Discovery**: Automatic discovery of devices on configured network ranges
- **Real-time Monitoring**: Continuous monitoring of device status and connectivity
- **Device Classification**: Automatic identification of device types and manufacturers
- **Network Topology**: Visual representation of network layout and relationships
- **Historical Data**: Tracking of device connectivity and performance over time

### Infrastructure Integration
- **Traefik Integration**: Automatic SSL certificates and reverse proxy configuration
- **Authentik SSO**: Single sign-on integration with your existing authentication system
- **Homepage Dashboard**: Integration with your Homepage dashboard for easy access
- **Monitoring Stack**: Full integration with Prometheus, Grafana, and Loki
- **Security Services**: Integration with CrowdSec and Fail2ban for threat protection

### Security Features
- **Authentication**: Configurable authentication methods (Authentik, Basic, None)
- **Rate Limiting**: Built-in rate limiting to prevent abuse
- **Security Headers**: Comprehensive security headers for web interface
- **CORS Protection**: Configurable CORS policies
- **API Security**: Secure API endpoints with key-based authentication

### Monitoring & Alerting
- **Metrics Collection**: Prometheus metrics for monitoring and alerting
- **Log Aggregation**: Centralized logging with Loki
- **Health Checks**: Comprehensive health monitoring
- **Alerting**: Configurable alerts for device status changes
- **Dashboard**: Pre-configured Grafana dashboards

### Backup & Maintenance
- **Automated Backups**: Scheduled backups with retention policies
- **Data Persistence**: Persistent storage for configuration and data
- **Maintenance Tasks**: Automated maintenance and cleanup
- **Disaster Recovery**: Backup and restore procedures

## Requirements

### System Requirements
- Ubuntu 20.04+ or Debian 11+
- Docker and Docker Compose
- At least 2GB RAM
- 10GB available disk space
- Network access for device discovery

### Dependencies
- Traefik (for reverse proxy)
- Authentik (for SSO)
- Prometheus (for metrics)
- Grafana (for dashboards)
- Loki (for logs)
- CrowdSec (for security)
- Fail2ban (for access control)

## Installation

### 1. Add to Your Playbook

Add Fing to your `enabled_services` list in your group variables:

```yaml
enabled_services:
  - traefik
  - authentik
  - monitoring_infrastructure
  - fing  # Add this line
```

### 2. Configure Variables

Set up Fing-specific variables in your `group_vars/all/vars.yml`:

```yaml
# Fing Configuration
fing_enabled: true
fing_subdomain: "fing"
fing_network_ranges:
  - "192.168.1.0/24"
  - "10.0.0.0/8"
  - "172.16.0.0/12"

# Authentication
fing_auth_method: "authentik"
fing_admin_email: "admin@yourdomain.com"

# Monitoring
fing_monitoring_enabled: true
fing_metrics_enabled: true
fing_alerting_enabled: true

# Security
fing_crowdsec_enabled: true
fing_fail2ban_enabled: true

# Homepage Integration
fing_homepage_enabled: true
fing_homepage_category: "Network"
```

### 3. Run Deployment

```bash
ansible-playbook main.yml --tags fing
```

## Configuration

### Network Discovery

Configure network ranges for device discovery:

```yaml
fing_network_ranges:
  - "192.168.1.0/24"    # Main network
  - "10.0.0.0/8"        # VPN network
  - "172.16.0.0/12"     # Docker network

fing_scan_interval: 300  # 5 minutes
fing_scan_timeout: 60    # 1 minute
fing_max_devices: 1000   # Maximum devices to track
```

### Authentication

Choose your authentication method:

```yaml
# Authentik SSO (Recommended)
fing_auth_method: "authentik"
fing_auth_enabled: true

# Basic Authentication
fing_auth_method: "basic"
fing_admin_email: "admin@yourdomain.com"
fing_admin_password: "secure_password"

# No Authentication (Not recommended for production)
fing_auth_method: "none"
fing_auth_enabled: false
```

### Monitoring Integration

Configure monitoring and alerting:

```yaml
# Metrics Collection
fing_metrics_enabled: true
fing_metrics_port: 9090

# Alerting
fing_alerting_enabled: true
fing_alerting_provider: "alertmanager"
fing_alerting_webhook: "http://alertmanager:9093/api/v1/alerts"

# Notification Channels
fing_email_enabled: true
fing_smtp_host: "smtp.gmail.com"
fing_smtp_port: 587
fing_smtp_username: "your-email@gmail.com"
fing_smtp_password: "your-app-password"

fing_slack_enabled: true
fing_slack_webhook: "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
fing_slack_channel: "#alerts"
```

### Security Configuration

Configure security features:

```yaml
# Rate Limiting
fing_rate_limiting: true
fing_rate_limit_requests: 100
fing_rate_limit_window: 60

# Security Headers
fing_security_headers: true
fing_cors_enabled: false

# API Security
fing_api_enabled: true
fing_api_rate_limit: 1000
fing_api_rate_limit_window: 3600
```

## Usage

### Accessing Fing

1. **Web Interface**: https://fing.yourdomain.com
2. **Homepage Dashboard**: Available in the Network category
3. **API Endpoint**: https://fing.yourdomain.com/api/v1
4. **Metrics**: https://fing.yourdomain.com/metrics

### Initial Setup

1. **Login**: Use your Authentik credentials or admin account
2. **Configure Networks**: Add your network ranges for discovery
3. **Set Scan Intervals**: Configure how often to scan for devices
4. **Enable Alerts**: Set up alerting for device status changes
5. **Customize Dashboards**: Configure monitoring dashboards

### API Usage

The Fing API provides programmatic access to network data:

```bash
# Get all devices
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://fing.yourdomain.com/api/v1/devices

# Get device details
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://fing.yourdomain.com/api/v1/devices/{device_id}

# Start network scan
curl -X POST -H "Authorization: Bearer YOUR_API_KEY" \
  https://fing.yourdomain.com/api/v1/scan/start
```

### Monitoring Dashboards

Access pre-configured dashboards:

1. **Grafana**: https://grafana.yourdomain.com/d/fing
2. **Prometheus**: https://prometheus.yourdomain.com/targets
3. **Loki**: https://loki.yourdomain.com (for logs)

## Maintenance

### Backup

Backups are automatically scheduled and can be managed:

```bash
# Manual backup
{{ docker_dir }}/fing/backup.sh

# Restore from backup
{{ docker_dir }}/fing/restore.sh /path/to/backup.tar.gz

# Verify backup
{{ docker_dir }}/fing/backup-verify.sh
```

### Logs

Access logs for troubleshooting:

```bash
# Container logs
docker logs {{ fing_container_name }}

# Application logs
tail -f {{ docker_dir }}/fing/logs/fing.log

# System logs
journalctl -u fing -f
```

### Health Checks

Monitor service health:

```bash
# Service status
docker ps {{ fing_container_name }}

# Health endpoint
curl http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}

# Metrics endpoint
curl http://localhost:{{ fing_metrics_port }}/metrics
```

## Troubleshooting

### Common Issues

1. **Container won't start**
   - Check Docker logs: `docker logs {{ fing_container_name }}`
   - Verify port availability
   - Check resource limits

2. **Network discovery not working**
   - Verify network ranges configuration
   - Check container network mode
   - Ensure proper permissions

3. **Authentication issues**
   - Verify Authentik configuration
   - Check API keys
   - Review authentication logs

4. **Monitoring integration problems**
   - Check Prometheus targets
   - Verify Grafana datasources
   - Review Loki configuration

### Debug Mode

Enable debug mode for detailed logging:

```yaml
fing_debug_enabled: true
fing_log_level: "debug"
```

### Support

For additional support:

1. Check the logs: `{{ docker_dir }}/fing/logs/`
2. Review configuration: `{{ docker_dir }}/fing/config/`
3. Test connectivity: `{{ docker_dir }}/fing/health_check.sh`
4. Monitor resources: `{{ docker_dir }}/fing/performance.sh`

## Security Considerations

### Network Access
- Fing requires network access for device discovery
- Configure firewall rules appropriately
- Use network segmentation for security

### Authentication
- Always use strong authentication
- Regularly rotate API keys
- Monitor access logs

### Data Protection
- Encrypt sensitive data at rest
- Use secure communication protocols
- Regular security updates

### Monitoring
- Monitor for suspicious activity
- Set up security alerts
- Regular security audits

## Performance Tuning

### Resource Limits
```yaml
fing_memory_limit: "1g"
fing_cpu_limit: "1.0"
fing_storage_limit: "20g"
```

### Scan Optimization
```yaml
fing_scan_interval: 600    # 10 minutes for large networks
fing_scan_timeout: 120     # 2 minutes timeout
fing_max_devices: 2000     # Increase for large networks
```

### Caching
```yaml
fing_cache_enabled: true
fing_cache_size: "512m"
fing_cache_ttl: 7200       # 2 hours
```

## Integration Examples

### Grafana Dashboard
Import the provided Grafana dashboard for comprehensive monitoring.

### Alertmanager Rules
Configure alerting rules for device status changes and network issues.

### Homepage Widget
The Homepage integration provides quick access and status monitoring.

### API Integration
Use the REST API for custom integrations and automation.

## Contributing

To contribute to this role:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This role is licensed under the MIT License. See LICENSE file for details.

## Support

For support and questions:

1. Check the documentation
2. Review the troubleshooting section
3. Check the logs and configuration
4. Open an issue on GitHub

---

**Note**: This role is designed for production use in a homelab environment. Always test in a staging environment first and ensure proper security measures are in place. 