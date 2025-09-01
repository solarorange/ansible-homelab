# DumbAssets Configuration Guide

This document provides a comprehensive guide for configuring the DumbAssets role through environment variables for seamless setup.

## Overview

The DumbAssets role is designed for zero-configuration deployment with sensible defaults. All configuration variables can be overridden using environment variables, making it perfect for automated deployments and CI/CD pipelines.

## Environment Variables

### Service Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_ENABLED` | `true` | Enable/disable the DumbAssets service |
| `DUMBASSETS_CONTAINER_NAME` | `dumbassets` | Docker container name |
| `DUMBASSETS_IMAGE` | `dumbwareio/dumbassets:latest` | Docker image to use |
| `DUMBASSETS_PORT` | `3004` | Internal container port |
| `DUMBASSETS_RESTART_POLICY` | `unless-stopped` | Docker restart policy |

### Network Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_NETWORK` | `homelab` | Docker network name |
| `DUMBASSETS_EXTERNAL_PORT` | `3004` | External port mapping |

**Note**: The subdomain is automatically configured as `assets.yourdomain.com` based on the `subdomains.dumbassets` entry in `group_vars/all/vars.yml`.

### Directory Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_DOCKER_DIR` | `{{ docker_dir }}/dumbassets` | Docker Compose directory |
| `DUMBASSETS_CONFIG_DIR` | `{{ dumbassets_docker_dir }}/config` | Configuration directory |
| `DUMBASSETS_DATA_DIR` | `{{ docker_data_root }}/dumbassets` | Data storage directory |
| `DUMBASSETS_BACKUP_DIR` | `{{ backup_dir }}/dumbassets` | Backup directory |
| `DUMBASSETS_LOGS_DIR` | `{{ docker_logs_root }}/dumbassets` | Log directory |

### Application Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_SITE_TITLE` | `Asset Tracker` | Site title displayed in the UI |
| `DUMBASSETS_PIN` | `1234` | **IMPORTANT**: PIN for accessing the application |
| `DUMBASSETS_ALLOWED_ORIGINS` | `*` | CORS allowed origins |
| `DUMBASSETS_DEMO_MODE` | `false` | Enable demo mode |
| `DUMBASSETS_NODE_ENV` | `production` | Node.js environment |
| `DUMBASSETS_DEBUG` | `false` | Enable debug mode |

### Currency Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_CURRENCY_CODE` | `USD` | Currency code for asset values |
| `DUMBASSETS_CURRENCY_LOCALE` | `en-US` | Currency locale |

### Notification Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_APPRISE_URL` | `` | Apprise notification URL (optional) |

### Monitoring Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_MONITORING_ENABLED` | `true` | Enable monitoring integration |
| `DUMBASSETS_HEALTH_CHECK_ENABLED` | `true` | Enable health checks |
| `DUMBASSETS_METRICS_ENABLED` | `true` | Enable metrics collection |
| `DUMBASSETS_LOGGING_ENABLED` | `true` | Enable logging integration |

### Security Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_SECURITY_ENABLED` | `true` | Enable security hardening |
| `DUMBASSETS_FIREWALL_ENABLED` | `true` | Enable firewall rules |
| `DUMBASSETS_SSL_ENABLED` | `true` | Enable SSL/TLS |
| `DUMBASSETS_AUTH_ENABLED` | `true` | Enable authentication |

### Backup Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_BACKUP_ENABLED` | `true` | Enable automated backups |
| `DUMBASSETS_BACKUP_RETENTION_DAYS` | `30` | Backup retention period |
| `DUMBASSETS_BACKUP_COMPRESSION` | `true` | Enable backup compression |
| `DUMBASSETS_BACKUP_ENCRYPTION` | `false` | Enable backup encryption |

### Homepage Integration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_HOMEPAGE_GROUP` | `Utilities` | Homepage service group |
| `DUMBASSETS_HOMEPAGE_ICON` | `database` | Homepage service icon |
| `DUMBASSETS_HOMEPAGE_DESCRIPTION` | `Asset tracking and management system` | Service description |

### Alerting Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_ALERTING_ENABLED` | `true` | Enable alerting |
| `DUMBASSETS_ALERTING_CRITICAL` | `true` | Enable critical alerts |
| `DUMBASSETS_ALERTING_WARNING` | `true` | Enable warning alerts |
| `DUMBASSETS_ALERTING_INFO` | `true` | Enable info alerts |

### Resource Limits

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_CPU_SHARES` | `1024` | CPU shares allocation |
| `DUMBASSETS_MEMORY_LIMIT` | `512M` | Memory limit |
| `DUMBASSETS_MEMORY_SWAP` | `1G` | Memory swap limit |
| `DUMBASSETS_MEMORY_RESERVATION` | `256M` | Memory reservation |
| `DUMBASSETS_CPUS` | `1` | CPU cores allocation |

### Timezone Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_TIMEZONE` | `America/New_York` | Container timezone |

### Validation Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_VALIDATION_ENABLED` | `true` | Enable deployment validation |
| `DUMBASSETS_VALIDATION_TIMEOUT` | `300` | Validation timeout (seconds) |
| `DUMBASSETS_VALIDATION_RETRIES` | `3` | Validation retry attempts |

## Quick Start Examples

### Minimal Configuration (Zero Config)

```bash
# No environment variables needed - uses all defaults
ansible-playbook site.yml --tags dumbassets
```

### Custom PIN Only

```bash
export DUMBASSETS_PIN="5678"
ansible-playbook site.yml --tags dumbassets
```

### Custom Configuration

```bash
export DUMBASSETS_PIN="secure123"
export DUMBASSETS_SITE_TITLE="My Asset Tracker"
export DUMBASSETS_CURRENCY_CODE="EUR"
export DUMBASSETS_CURRENCY_LOCALE="de-DE"
export DUMBASSETS_TIMEZONE="Europe/Berlin"
export DUMBASSETS_APPRISE_URL="discord://webhook_url"
ansible-playbook site.yml --tags dumbassets
```

### Production Configuration

```bash
export DUMBASSETS_PIN="$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-8)"
export DUMBASSETS_SITE_TITLE="Corporate Asset Management"
export DUMBASSETS_CURRENCY_CODE="USD"
export DUMBASSETS_BACKUP_ENCRYPTION="true"
export DUMBASSETS_DEBUG="false"
export DUMBASSETS_DEMO_MODE="false"
export DUMBASSETS_APPRISE_URL="slack://webhook_url"
ansible-playbook site.yml --tags dumbassets
```

## Security Considerations

### PIN Configuration

- **Default PIN**: `1234` (change immediately after deployment)
- **Minimum Length**: 4 characters
- **Recommendation**: Use a strong, unique PIN
- **Generation**: `openssl rand -base64 32 | tr -d "=+/" | cut -c1-8`

### Network Security

- Service is exposed via Traefik with SSL/TLS
- Firewall rules are automatically configured
- Container runs with security hardening
- Read-only filesystem enabled

### Data Protection

- All data is stored in Docker volumes
- Automated backups with configurable retention
- Optional backup encryption
- Secure file permissions

## Integration Points

### Automatic Integrations

The role automatically integrates with:

- **Traefik**: SSL/TLS termination and routing
- **Prometheus**: Metrics collection and monitoring
- **Grafana**: Dashboard and visualization
- **Loki**: Centralized logging
- **Alertmanager**: Alert routing and notifications
- **Homepage**: Dashboard integration
- **Fail2Ban**: Intrusion prevention
- **UFW**: Firewall management

### Manual Configuration

No manual configuration is required. All integrations are handled automatically based on the global homelab configuration.

## Troubleshooting

### Common Issues

1. **Port Conflicts**: Change `DUMBASSETS_PORT` or `DUMBASSETS_EXTERNAL_PORT`
2. **Permission Issues**: Ensure Docker directories are accessible
3. **Network Issues**: Verify Traefik is running and configured
4. **PIN Issues**: Ensure PIN is at least 4 characters long

### Validation

The role includes comprehensive validation:

- Pre-deployment configuration checks
- Port availability verification
- Directory permission validation
- Post-deployment health checks
- Integration verification

### Logs

- Application logs: `{{ dumbassets_logs_dir }}`
- Docker logs: `docker logs dumbassets`
- Ansible logs: Check Ansible output for detailed information

## Migration and Updates

### Updating Configuration

1. Set new environment variables
2. Run the playbook: `ansible-playbook site.yml --tags dumbassets`
3. Configuration changes are applied automatically

### Backup Before Changes

```bash
# Manual backup
docker exec dumbassets /app/scripts/backup.sh

# Or use the role's backup system
ansible-playbook site.yml --tags dumbassets,backup
```

## Support

For issues or questions:

1. Check the logs: `docker logs dumbassets`
2. Verify configuration: `docker exec dumbassets cat /app/config/config.json`
3. Test connectivity: `curl -f http://localhost:3004/health`
4. Review this documentation for configuration options

## Best Practices

1. **Always change the default PIN** after deployment
2. **Use environment variables** for configuration
3. **Enable backups** for data protection
4. **Monitor the service** through the provided integrations
5. **Regular updates** using the role's update mechanisms
6. **Test in staging** before production deployment 