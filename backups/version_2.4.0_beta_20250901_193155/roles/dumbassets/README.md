# DumbAssets Role

This role deploys and manages DumbAssets, a simple asset tracking system for keeping track of physical assets, their components, warranties, and routine maintenance. It provides modular tasks for deployment, validation, monitoring, backup, security, and homepage integration.

## Features

- **Asset Tracking**: Track assets with detailed information (model, serial, warranty, etc.)
- **Component Management**: Add components and sub-components with hierarchical organization
- **Media Support**: Upload and store photos and receipts
- **Search Functionality**: Search by name, model, serial, or description
- **Warranty Management**: Warranty expiration notifications with configurable alerts
- **Maintenance Tracking**: Maintenance event notifications and scheduling
- **Tagging System**: Flexible tagging system for better organization
- **Notification Integration**: Built-in Apprise integration for Discord/ntfy/Telegram/etc
- **Theme Support**: Light/Dark mode with theme persistence
- **Security**: PIN authentication with brute force protection
- **Docker Support**: Containerized deployment for easy management

## Directory Structure

```
roles/dumbassets/
├── defaults/
│   └── main.yml                    # Comprehensive configuration defaults
├── handlers/
│   └── main.yml                    # Service restart and reload handlers
├── tasks/
│   ├── main.yml                    # Main orchestration tasks
│   ├── validate.yml                # Pre-deployment validation
│   ├── prerequisites.yml           # Setup and prerequisites
│   ├── deploy.yml                  # Service deployment
│   ├── monitoring.yml              # Configure monitoring integration
│   ├── security.yml                # Configure security hardening
│   ├── backup.yml                  # Configure backup procedures
│   ├── homepage.yml                # Configure homepage integration
│   ├── alerts.yml                  # Configure alerting and notifications
│   └── validate_deployment.yml     # Post-deployment validation
├── templates/
│   ├── docker-compose.yml.j2       # Docker Compose configuration
│   ├── env.j2                      # Environment variables
│   ├── traefik.yml.j2              # Traefik reverse proxy configuration
│   ├── homepage-service.yml.j2     # Homepage service configuration
│   ├── backup.sh.j2                # Backup script
│   ├── healthcheck.sh.j2           # Health check script
│   └── manage.sh.j2                # Management script
└── README.md                       # This file
```

## Usage

### Zero-Configuration Deployment

The DumbAssets role is designed for seamless setup with sensible defaults. No configuration is required for basic deployment:

```bash
# Deploy with all defaults (zero configuration required)
ansible-playbook site.yml --tags dumbassets
```

### Custom Configuration

All configuration variables can be overridden using environment variables:

```bash
# Custom PIN only
export DUMBASSETS_PIN="5678"
ansible-playbook site.yml --tags dumbassets

# Full custom configuration
export DUMBASSETS_PIN="secure123"
export DUMBASSETS_SITE_TITLE="My Asset Tracker"
export DUMBASSETS_CURRENCY_CODE="EUR"
export DUMBASSETS_TIMEZONE="Europe/Berlin"
ansible-playbook site.yml --tags dumbassets
```

### Standard Playbook Integration

Include this role in your playbook:

```yaml
- hosts: all
  roles:
    - role: dumbassets
```

**Note**: See [CONFIGURATION.md](CONFIGURATION.md) for complete environment variable reference and examples.

## Variables

**Note**: All variables support environment variable overrides for seamless configuration. See [CONFIGURATION.md](CONFIGURATION.md) for complete details.

### Service Configuration

| Variable | Default | Environment Variable | Description |
|----------|---------|---------------------|-------------|
| `dumbassets_enabled` | `true` | `DUMBASSETS_ENABLED` | Enable/disable the DumbAssets service |
| `dumbassets_container_name` | `dumbassets` | `DUMBASSETS_CONTAINER_NAME` | Docker container name |
| `dumbassets_image` | `dumbwareio/dumbassets:latest` | `DUMBASSETS_IMAGE` | Docker image to use |
| `dumbassets_port` | `3004` | `DUMBASSETS_PORT` | Internal port for the service |
| `dumbassets_external_port` | `3004` | `DUMBASSETS_EXTERNAL_PORT` | External port mapping |

### Network Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_network` | `homelab` | Docker network name |
| `dumbassets_subdomain` | `assets` | Subdomain for the service |

### Application Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_site_title` | `Asset Tracker` | Site title shown in browser |
| `dumbassets_pin` | `1234` | PIN protection (4+ digits) |
| `dumbassets_allowed_origins` | `*` | Origins allowed to visit |
| `dumbassets_demo_mode` | `false` | Enable read-only demo mode |
| `dumbassets_currency_code` | `USD` | ISO 4217 currency code |
| `dumbassets_currency_locale` | `en-US` | Locale for currency formatting |

### Directory Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_docker_dir` | `{{ docker_dir }}/dumbassets` | Docker compose directory |
| `dumbassets_data_dir` | `{{ docker_data_root }}/dumbassets` | Data storage directory |
| `dumbassets_backup_dir` | `{{ backup_dir }}/dumbassets` | Backup storage directory |
| `dumbassets_logs_dir` | `{{ docker_logs_root }}/dumbassets` | Log storage directory |

### Monitoring Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_monitoring_enabled` | `true` | Enable monitoring integration |
| `dumbassets_health_check_enabled` | `true` | Enable health checks |
| `dumbassets_metrics_enabled` | `true` | Enable metrics collection |

### Security Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_security_enabled` | `true` | Enable security hardening |
| `dumbassets_firewall_enabled` | `true` | Enable firewall rules |
| `dumbassets_ssl_enabled` | `true` | Enable SSL/TLS |

### Backup Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_backup_enabled` | `true` | Enable automated backups |
| `dumbassets_backup_retention_days` | `30` | Backup retention period |
| `dumbassets_backup_compression` | `true` | Enable backup compression |

### Homepage Integration

| Variable | Default | Description |
|----------|---------|-------------|
| `dumbassets_homepage_enabled` | `true` | Enable homepage integration |
| `dumbassets_homepage_group` | `Utilities` | Homepage service group |
| `dumbassets_homepage_icon` | `database` | Homepage service icon |

## Integration

### Monitoring
- **Prometheus**: Exposes metrics for monitoring
- **Grafana**: Provides dashboards for visualization
- **Loki**: Centralized logging
- **Alertmanager**: Alerting and notifications

### Security
- **Traefik**: Reverse proxy with SSL termination
- **Fail2Ban**: Intrusion detection and prevention
- **Container Security**: Read-only filesystem, no-new-privileges
- **Firewall**: UFW rules for network security

### Backup
- **Automated Backups**: Daily backups with retention
- **Compression**: Gzip compression for storage efficiency
- **Verification**: Backup integrity checks
- **Restore**: Automated restore procedures

### Homepage
- **Service Registration**: Adds to homepage dashboard
- **Status Monitoring**: Real-time service status
- **Quick Access**: Direct links to service interface

## Management

### Manual Management

Use the management script for manual operations:

```bash
# Start the service
{{ dumbassets_docker_dir }}/scripts/manage.sh start

# Stop the service
{{ dumbassets_docker_dir }}/scripts/manage.sh stop

# Restart the service
{{ dumbassets_docker_dir }}/scripts/manage.sh restart

# Check status
{{ dumbassets_docker_dir }}/scripts/manage.sh status

# View logs
{{ dumbassets_docker_dir }}/scripts/manage.sh logs

# Create backup
{{ dumbassets_docker_dir }}/scripts/manage.sh backup

# Update service
{{ dumbassets_docker_dir }}/scripts/manage.sh update

# Run health check
{{ dumbassets_docker_dir }}/scripts/manage.sh health
```

### Docker Compose

Direct Docker Compose operations:

```bash
cd {{ dumbassets_docker_dir }}

# Start service
docker-compose up -d

# Stop service
docker-compose down

# View logs
docker-compose logs -f

# Update image
docker-compose pull && docker-compose up -d
```

## Access

- **Local Access**: http://localhost:{{ dumbassets_port }}
- **External Access**: https://{{ dumbassets_subdomain }}.{{ domain }}
- **Default PIN**: {{ dumbassets_pin }}

## Dependencies

- **Traefik**: Required for reverse proxy and SSL
- **Docker**: Required for containerization
- **Monitoring Stack**: Optional for metrics and alerting

## Security Considerations

1. **PIN Protection**: Change the default PIN immediately after deployment
2. **Network Access**: Configure firewall rules appropriately
3. **SSL/TLS**: Always use HTTPS in production
4. **Backup Security**: Ensure backups are stored securely
5. **Container Security**: Container runs with minimal privileges

## Troubleshooting

### Common Issues

1. **Service won't start**: Check Docker logs and container health
2. **Cannot access web interface**: Verify Traefik configuration and network
3. **Backup failures**: Check disk space and permissions
4. **High memory usage**: Monitor resource limits and optimize

### Logs

- **Application Logs**: `docker logs {{ dumbassets_container_name }}`
- **System Logs**: `journalctl -u docker`
- **Backup Logs**: `{{ dumbassets_backup_dir }}/logs/`

### Health Checks

Run the health check script to diagnose issues:

```bash
{{ dumbassets_docker_dir }}/scripts/healthcheck.sh
```

## Contributing

This role follows the established patterns in the homelab stack. When contributing:

1. Follow the existing task structure
2. Use consistent variable naming
3. Include proper validation and error handling
4. Update documentation for any changes
5. Test thoroughly before submitting

## License

This role is part of the Ansible Homelab Stack and follows the same licensing terms.

## Author

Auto-generated for the DumbAssets service integration into the homelab stack. 

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores the last-known-good Compose and pre-change snapshot automatically if a deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., dumbassets
    sudo cp {{ backup_dir }}/${SERVICE}/last_good/docker-compose.yml {{ docker_dir }}/${SERVICE}/docker-compose.yml
    if [ -f {{ backup_dir }}/${SERVICE}/last_good/.env ]; then sudo cp {{ backup_dir }}/${SERVICE}/last_good/.env {{ docker_dir }}/${SERVICE}/.env; fi
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```
  - Option B — restore pre-change snapshot
    ```bash
    SERVICE=<service>
    ls -1 {{ backup_dir }}/${SERVICE}/prechange_*.tar.gz
    sudo tar -xzf {{ backup_dir }}/${SERVICE}/prechange_<TIMESTAMP>.tar.gz -C /
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```

- Rollback to a recorded rollback point (target host):
  ```bash
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```

- Full stack version rollback:
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```

### Secrets & Health Checks

- Secrets directory: `{{ dumbassets_docker_dir }}/secrets`.
- If using secrets, enable file-based secrets:
  ```yaml
  dumbassets_manage_secret_files: true
  dumbassets_secret_files:
    - name: DUMBASSETS_API_TOKEN
      from_vault_var: vault_dumbassets_api_token
  dumbassets_required_secrets:
    - DUMBASSETS_API_TOKEN
  ```
  Compose templates must map secret-like env keys to `KEY_FILE=/run/secrets/KEY` and mount the file. See `docs/SECRETS_CONVENTIONS.md`.

- Post-deploy route health check:
  ```yaml
  - ansible.builtin.include_tasks: ../../automation/tasks/route_health_check.yml
    vars:
      route_health_check_url: "https://{{ dumbassets_subdomain }}.{{ domain }}/"
      route_health_check_status_codes: [200, 302]
  ```
  See `docs/POST_DEPLOY_SMOKE_TESTS.md`.