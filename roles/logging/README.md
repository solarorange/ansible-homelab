# Logging Stack Ansible Role

A comprehensive Ansible role for deploying and managing centralized logging infrastructure in a production homelab environment.

## Overview

This role provides a complete logging solution including:
- **Loki**: Log aggregation and querying
- **Promtail**: Log collection and shipping
- **Log Rotation**: Automated log management
- **Docker Logging**: Container log integration
- **Monitoring**: Integration with Prometheus and Grafana
- **Alerting**: Log-based alerting rules

## Features

- ✅ Centralized log aggregation with Loki
- ✅ Automated log collection with Promtail
- ✅ Log rotation and retention policies
- ✅ Docker container log integration
- ✅ Monitoring and alerting integration
- ✅ Security hardening and access control
- ✅ Homepage integration for easy access
- ✅ Comprehensive validation and health checks

## Requirements

- Ansible 2.12+
- Docker and Docker Compose
- `community.docker` Ansible collection

## Role Variables

Variables are defined in `defaults/main.yml`. All sensitive values should be stored in Ansible Vault.

### Main Switches
```yaml
logging_enabled: true
loki_enabled: true
promtail_enabled: true
logrotate_enabled: true
```

### Service Configuration Examples
```yaml
# Loki Configuration
loki_enabled: true
loki_version: "2.9.0"
loki_retention_period: "744h"  # 31 days

# Promtail Configuration
promtail_enabled: true
promtail_scrape_interval: "15s"
promtail_targets:
  - name: "system_logs"
    path: "/var/log/*.log"
    labels:
      job: "system"

# Log Rotation
logrotate_enabled: true
logrotate_rotate: 7
logrotate_size: "100M"
```

## Usage

1. Include the role in your playbook:
   ```yaml
   - hosts: all
     roles:
       - logging
   ```

2. Configure variables in your inventory or group_vars:
   ```yaml
   # group_vars/all/logging.yml
   loki_enabled: true
   promtail_enabled: true
   logrotate_enabled: true
   ```

3. Ensure vault variables are defined for sensitive data.

## Directory Structure

```
roles/logging/
├── defaults/
│   └── main.yml          # Default variables
├── handlers/
│   └── main.yml          # Event handlers
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── promtail.yml.j2   # Promtail configuration
│   ├── logrotate.conf.j2 # Log rotation config
│   ├── daemon.json.j2    # Docker logging config
│   ├── healthcheck.sh.j2 # Health check script
│   ├── manage.sh.j2      # Management script
│   ├── dashboard.json.j2 # Grafana dashboard
│   └── monitoring.yml.j2 # Monitoring rules
├── vars/
│   └── main.yml          # Vault variables
└── README.md             # This file
```

## Integration

### Monitoring
- **Prometheus**: Metrics collection for Loki and Promtail
- **Grafana**: Log visualization and dashboards
- **Alerting**: Log-based alerting rules

### Security
- **Access Control**: User-based access to logs
- **Encryption**: Log data encryption at rest
- **Network Isolation**: Secure log transport

### Backup
- **Automated Backups**: Daily log backups
- **Retention Policies**: Configurable retention periods
- **Compression**: Log compression for storage efficiency

## Health Checks

The role includes comprehensive health checks:
- Loki service availability
- Promtail log collection status
- Log rotation execution
- Docker logging driver status

## Alerting Rules

Pre-configured alerting rules include:
- **LoggingServiceDown**: Loki service unavailable
- **HighLogVolume**: Excessive log volume detected
- **LogRotationFailed**: Log rotation failures

## Customization

### Adding Custom Log Sources
```yaml
promtail_targets:
  - name: "custom_app"
    path: "/var/log/custom-app/*.log"
    labels:
      job: "custom_app"
      app: "my_application"
```

### Custom Log Retention
```yaml
loki_retention_period: "168h"  # 7 days
logrotate_rotate: 14          # Keep 14 rotated files
```

## Troubleshooting

### Common Issues
1. **Loki not starting**: Check resource limits and port availability
2. **Promtail not collecting logs**: Verify file permissions and paths
3. **High disk usage**: Adjust retention policies and compression

### Debug Commands
```bash
# Check Loki status
docker exec loki wget -qO- http://localhost:3100/ready

# Check Promtail status
docker exec promtail wget -qO- http://localhost:9080/ready

# View recent logs
docker logs loki --tail 100
docker logs promtail --tail 100
```

## Performance Tuning

### Resource Optimization
- Adjust `loki_retention_period` based on storage capacity
- Configure `promtail_batch_size` for optimal throughput
- Set appropriate `logrotate_size` limits

### Scaling Considerations
- For high-volume environments, consider Loki clustering
- Use multiple Promtail instances for distributed log collection
- Implement log aggregation at the application level

---

For detailed variable documentation, see `defaults/main.yml`. 