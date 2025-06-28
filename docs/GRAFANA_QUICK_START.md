# Grafana Automation - Quick Start Guide

## Overview

This quick start guide will help you deploy and configure Grafana using the comprehensive automation system for your homelab environment.

## Prerequisites

- Ansible 2.9+
- Docker and Docker Compose
- Python 3.8+ (for configuration script)
- Access to monitoring hosts

## Quick Deployment

### 1. Basic Deployment

Add the Grafana role to your playbook:

```yaml
# playbook.yml
- hosts: monitoring
  roles:
    - grafana
```

### 2. Run the Playbook

```bash
# Run the playbook
ansible-playbook -i inventory playbook.yml --tags grafana

# Run with verbose output
ansible-playbook -i inventory playbook.yml --tags grafana -vvv
```

### 3. Verify Deployment

```bash
# Check container status
docker ps | grep grafana

# Test API health
curl -f http://localhost:3000/api/health

# Access Grafana web interface
open http://localhost:3000
```

## Configuration

### Basic Configuration

Set these variables in your inventory or group_vars:

```yaml
# group_vars/monitoring.yml
grafana_admin_password: "your_secure_password"
grafana_domain: "grafana.yourdomain.com"

# Data sources
grafana_datasources:
  prometheus:
    enabled: true
    url: "http://prometheus:9090"
  loki:
    enabled: true
    url: "http://loki:3100"
```

### Advanced Configuration

For more advanced setups:

```yaml
# Advanced configuration
grafana_database_type: "postgres"
grafana_database_host: "postgresql"
grafana_database_name: "grafana"
grafana_database_user: "grafana"
grafana_database_password: "{{ vault_grafana_db_password }}"

# Custom dashboards
grafana_dashboard_categories:
  system_overview:
    enabled: true
    folder: "System Overview"
  security:
    enabled: true
    folder: "Security"
  media:
    enabled: true
    folder: "Media Services"

# Alerting
grafana_notification_channels:
  email:
    enabled: true
    settings:
      addresses: "admin@yourdomain.com"
  slack:
    enabled: true
    settings:
      url: "{{ vault_slack_webhook_url }}"
```

## Dashboard Categories

The automation creates these dashboard categories:

1. **System Overview** - CPU, Memory, Disk, Network monitoring
2. **Services** - Docker containers, service health
3. **Security** - Authentication, firewall, intrusion detection
4. **Media** - Sonarr/Radarr, Jellyfin monitoring
5. **Network** - Traefik, SSL certificates, DNS health
6. **Databases** - PostgreSQL, Redis, MariaDB metrics
7. **Storage** - File systems, backups, cloud storage

## Data Sources

Pre-configured data sources:

- **Prometheus** - Metrics collection (default)
- **Loki** - Log aggregation
- **PostgreSQL** - Database metrics
- **Redis** - Cache metrics
- **Node Exporter** - System metrics

## Alerting

### Default Alert Rules

- High CPU usage (>90% for 5 minutes)
- High Memory usage (>90% for 5 minutes)
- High Disk usage (>90% for 5 minutes)
- Service down (not responding for 2 minutes)
- SSL certificate expiry (<30 days)

### Notification Channels

- Email notifications
- Slack webhook
- Discord webhook
- Custom webhook

## Access Information

### Web Interface
- URL: `https://grafana.yourdomain.com`
- Default credentials: `admin` / `your_password`

### API Access
- API URL: `https://grafana.yourdomain.com/api`
- Health check: `https://grafana.yourdomain.com/api/health`

## Monitoring

### Health Checks
```bash
# Check container health
docker exec grafana grafana-cli --config /etc/grafana/grafana.ini admin reset-admin-password

# Check API health
curl -f http://localhost:3000/api/health

# Check data sources
curl -u admin:password http://localhost:3000/api/datasources
```

### Logs
```bash
# View container logs
docker logs grafana

# View application logs
tail -f /path/to/grafana/logs/grafana.log
```

## Backup and Recovery

### Automated Backups
- Daily backups at 2 AM
- 30-day retention
- Compressed backup files

### Manual Backup
```bash
# Create backup
/path/to/grafana/scripts/backup.sh

# Restore backup
/path/to/grafana/scripts/restore.sh /path/to/backup.tar.gz
```

## Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check container status
docker ps -a | grep grafana

# Check logs
docker logs grafana

# Restart container
docker restart grafana
```

#### API Not Responding
```bash
# Test API health
curl -f http://localhost:3000/api/health

# Check authentication
curl -u admin:password http://localhost:3000/api/user
```

#### Dashboard Issues
```bash
# Check dashboard provisioning
curl -u admin:password http://localhost:3000/api/search

# Check folder structure
curl -u admin:password http://localhost:3000/api/folders
```

### Debug Mode

Enable debug logging:

```yaml
grafana_logging_level: "debug"
grafana_logging_mode: "console"
```

## Python Script Usage

### Manual Configuration
```bash
# Configure data sources
python3 setup_grafana.py \
  --url http://localhost:3000 \
  --username admin \
  --password your_password \
  --config-dir config \
  datasources

# Configure dashboards
python3 setup_grafana.py \
  --url http://localhost:3000 \
  --username admin \
  --password your_password \
  --config-dir config \
  dashboards

# Configure users
python3 setup_grafana.py \
  --url http://localhost:3000 \
  --username admin \
  --password your_password \
  --config-dir config \
  users
```

### Full Setup
```bash
# Complete setup
python3 setup_grafana.py \
  --url http://localhost:3000 \
  --username admin \
  --password your_password \
  --config-dir config
```

## Integration

### With Existing Monitoring Stack
The Grafana automation integrates with:
- Prometheus for metrics
- Loki for logs
- AlertManager for alerts
- Node Exporter for system metrics

### With Security Stack
- Traefik for reverse proxy
- Authentik for authentication
- SSL/TLS certificates
- Firewall rules

## Next Steps

1. **Customize Dashboards**: Modify dashboard templates for your specific needs
2. **Add Custom Data Sources**: Configure additional data sources
3. **Set Up Alerting**: Configure notification channels and alert rules
4. **Monitor Performance**: Set up performance monitoring
5. **Regular Maintenance**: Schedule regular backups and updates

## Support

For additional help:
- Check the main documentation: `docs/GRAFANA_AUTOMATION.md`
- Review the role documentation: `roles/grafana/README.md`
- Check the troubleshooting section in the main documentation

## Quick Commands Reference

```bash
# Deploy Grafana
ansible-playbook -i inventory playbook.yml --tags grafana

# Update configuration
ansible-playbook -i inventory playbook.yml --tags grafana,config

# Restart Grafana
ansible-playbook -i inventory playbook.yml --tags grafana,restart

# Validate deployment
ansible-playbook -i inventory playbook.yml --tags grafana,validation

# Check health
curl -f http://localhost:3000/api/health

# Access web interface
open http://localhost:3000
``` 