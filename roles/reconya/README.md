# Reconya Ansible Role

Network reconnaissance and asset discovery tool built with Go and HTMX, integrated into the Ansible homelab stack.

## Overview

Reconya discovers and monitors devices on your network with real-time updates. This role provides a production-ready deployment of Reconya with full integration into the homelab monitoring, security, and backup infrastructure.

### Features

- **IPv4 Network Scanning** - Comprehensive device discovery with nmap integration
- **IPv6 Passive Monitoring** - Detects IPv6 devices through neighbor discovery and interface monitoring
- **Device Identification** - MAC addresses, vendor detection, hostnames, and device types
- **Dual-Stack Support** - Full IPv4 and IPv6 address display and management
- **Real-time Monitoring** - Live device status updates and event logging
- **Web-based Dashboard** - Modern HTMX-powered interface with dark theme
- **Device Fingerprinting** - Automatic OS and device type detection
- **Network Management** - Multi-network support with CIDR configuration

## Prerequisites

- Docker and Docker Compose
- nmap (installed automatically by the role)
- Network access for scanning (requires NET_ADMIN and NET_RAW capabilities)
- SELinux disabled or permissive mode

## Role Structure

```
roles/reconya/
├── defaults/
│   └── main.yml          # Default configuration variables
├── tasks/
│   ├── main.yml          # Main task orchestration
│   ├── validate.yml      # Configuration validation
│   ├── prerequisites.yml # Prerequisites setup
│   ├── deploy.yml        # Service deployment
│   ├── monitoring.yml    # Monitoring integration
│   ├── security.yml      # Security configuration
│   ├── backup.yml        # Backup configuration
│   ├── homepage.yml      # Homepage integration
│   ├── alerts.yml        # Alerting configuration
│   └── validate_deployment.yml # Deployment validation
├── templates/
│   ├── docker-compose.yml.j2 # Docker Compose configuration
│   ├── env.j2              # Environment variables
│   ├── homepage_service.yml.j2 # Homepage service config
│   ├── homepage_widget.yml.j2  # Homepage widget config
│   └── [additional templates...]
├── handlers/
│   └── main.yml          # Service handlers
├── vars/
│   └── main.yml          # Role-specific variables
└── README.md             # This file
```

## Configuration

### Basic Configuration

```yaml
# Enable/disable the service
reconya_enabled: true

# Network configuration
reconya_network_range: "192.168.1.0/24"
reconya_scan_interval: 300  # 5 minutes
reconya_scan_timeout: 60
reconya_max_devices: 1000

# Authentication
reconya_admin_username: "admin"
reconya_admin_password: "{{ vault_reconya_admin_password }}"

# Domain configuration
reconya_subdomain: "reconya"
```

### Network Configuration

Reconya requires special network access for full functionality:

```yaml
# Container network mode (required for network scanning)
reconya_container_network_mode: "host"

# Network capabilities
reconya_network_capabilities:
  - NET_ADMIN
  - NET_RAW

# Network access requirements
reconya_network_access:
  - "/proc/net:/proc/net:ro"
  - "/sys/class/net:/sys/class/net:ro"
  - "/var/run/docker.sock:/var/run/docker.sock:ro"
```

### Monitoring Integration

```yaml
# Prometheus metrics
reconya_prometheus_enabled: true
reconya_prometheus_metrics: true
reconya_prometheus_scrape_interval: 30

# Grafana dashboard
reconya_grafana_enabled: true
reconya_grafana_dashboard: true

# Loki logging
reconya_loki_enabled: true
reconya_loki_logs: true
```

### Security Configuration

```yaml
# Security features
reconya_security_headers: true
reconya_rate_limiting: true
reconya_rate_limit_requests: 100
reconya_rate_limit_window: 60

# CrowdSec integration
reconya_crowdsec_enabled: true

# Fail2ban integration
reconya_fail2ban_enabled: true
reconya_fail2ban_max_retry: 5
reconya_fail2ban_bantime: 3600
```

### Backup Configuration

```yaml
# Backup settings
reconya_backup_enabled: true
reconya_backup_schedule: "0 2 * * *"  # Daily at 2 AM
reconya_backup_retention: 7  # Keep backups for 7 days
reconya_backup_compression: true
reconya_backup_include_database: true
reconya_backup_include_config: true
```

## Integration Points

### Traefik Integration

Reconya is automatically integrated with Traefik for SSL termination and authentication:

- **URL**: `https://reconya.{{ domain }}`
- **SSL**: Automatic certificate management via Cloudflare
- **Authentication**: Integrated with Authentik for SSO
- **Security Headers**: Automatic security header injection

### Homepage Integration

Reconya appears in the Homepage dashboard with:

- **Category**: Network
- **Description**: Network Reconnaissance & Asset Discovery
- **Widget**: Shows device count and status
- **Icon**: Custom Reconya icon

### Monitoring Integration

Full integration with the monitoring stack:

- **Prometheus**: Metrics collection and alerting
- **Grafana**: Custom dashboard for network monitoring
- **Loki**: Centralized log aggregation
- **Alertmanager**: Alert routing and notification

### Security Integration

Comprehensive security integration:

- **CrowdSec**: Real-time threat detection
- **Fail2ban**: Brute force protection
- **Rate Limiting**: API request throttling
- **Security Headers**: HTTP security headers

## Usage

### Deployment

1. **Enable the service** in your inventory:

```yaml
enabled_services:
  - reconya
```

2. **Configure vault variables**:

```yaml
# In group_vars/all/vault.yml
vault_reconya_admin_password: "your_secure_password"
vault_reconya_jwt_secret: "your_jwt_secret"
```

3. **Run the playbook**:

```bash
ansible-playbook site.yml --tags reconya
```

### Access

- **Web Interface**: `https://reconya.{{ domain }}`
- **Default Credentials**: `admin` / `{{ vault_reconya_admin_password }}`
- **API Endpoint**: `https://reconya.{{ domain }}/api/`

### API Usage

Reconya provides a REST API for integration:

```bash
# Get all devices
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://reconya.{{ domain }}/api/devices

# Get device count
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://reconya.{{ domain }}/api/devices/count

# Health check
curl https://reconya.{{ domain }}/api/health
```

### Monitoring

Monitor Reconya through:

- **Grafana Dashboard**: Network device monitoring
- **Prometheus Metrics**: Service health and performance
- **Loki Logs**: Application logs and events
- **Alertmanager**: Service alerts and notifications

## Troubleshooting

### Common Issues

1. **Network Scanning Not Working**
   - Ensure SELinux is disabled or permissive
   - Verify nmap is installed and has proper permissions
   - Check container has NET_ADMIN and NET_RAW capabilities

2. **Container Won't Start**
   - Verify network range is valid CIDR notation
   - Check environment variables are properly set
   - Ensure required directories exist and have correct permissions

3. **Authentication Issues**
   - Verify vault variables are properly encrypted
   - Check Authentik integration is configured
   - Ensure admin credentials are set

### Logs

View logs using:

```bash
# Container logs
docker logs reconya-backend

# Application logs
tail -f {{ logs_dir }}/reconya/application.log

# Health check logs
tail -f {{ logs_dir }}/reconya/health/health.log
```

### Health Checks

Monitor service health:

```bash
# Check container status
docker ps | grep reconya

# Test health endpoint
curl http://localhost:3008/api/health

# Check service metrics
curl http://localhost:3008/metrics
```

## Security Considerations

### Network Access

Reconya requires extensive network access for scanning:

- **Host Network Mode**: Required for full network visibility
- **Privileged Capabilities**: NET_ADMIN and NET_RAW for scanning
- **System Access**: Access to /proc/net and /sys/class/net

### Container Hardening Notes
- The container sets `security_opt: [no-new-privileges:true]` and `cap_drop: [ALL]` by default.
- Reconya performs active network scanning and runs in `network_mode: host` with additional capabilities (`NET_ADMIN`, `NET_RAW`). It may need to run as root; therefore the Compose template does not force a non-root `user` and `read_only` may be disabled for required paths.

### Authentication

- **Default Credentials**: Change admin password after deployment
- **JWT Secrets**: Use cryptographically secure secrets
- **API Access**: Implement proper API authentication

### Data Protection

- **Database Encryption**: SQLite database should be encrypted
- **Backup Encryption**: Backup files are encrypted
- **Log Security**: Sensitive data is not logged

## Performance Tuning

### Resource Limits

```yaml
# Adjust based on network size and scanning frequency
reconya_memory_limit: "2g"
reconya_cpu_limit: "2.0"
reconya_storage_limit: "10g"
```

### Scanning Optimization

```yaml
# Adjust scan intervals based on network stability
reconya_scan_interval: 300  # 5 minutes
reconya_scan_timeout: 60
reconya_max_devices: 1000
```

## Backup and Recovery

### Automated Backups

- **Schedule**: Daily at 2 AM
- **Retention**: 7 days by default
- **Compression**: Enabled for space efficiency
- **Verification**: Automatic backup integrity checks

### Manual Backup

```bash
# Create manual backup
{{ reconya_config_dir }}/backup/backup.sh

# Restore from backup
{{ reconya_config_dir }}/backup/restore.sh /path/to/backup.tar.gz
```

## Contributing

When contributing to this role:

1. Follow the established patterns in the codebase
2. Ensure all tasks have proper tags
3. Include comprehensive validation
4. Update documentation for any new features
5. Test thoroughly before submitting

## License

This role is part of the Ansible Homelab project and follows the same licensing terms.

## Support

For support and questions:

- **GitHub Issues**: Report bugs and feature requests
- **Documentation**: Check the main project documentation
- **Community**: Join the homelab community discussions 

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores the last-known-good Compose and pre-change snapshot automatically if a deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., reconya
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

- Secrets directory: `{{ docker_dir }}/reconya/secrets`.
- Enable file-based secrets by setting:
  ```yaml
  reconya_manage_secret_files: true
  reconya_secret_files:
    - name: RECONYA_ADMIN_PASSWORD
      from_vault_var: vault_reconya_admin_password
    - name: RECONYA_JWT_SECRET
      from_vault_var: vault_reconya_jwt_secret
  reconya_required_secrets:
    - RECONYA_ADMIN_PASSWORD
    - RECONYA_JWT_SECRET
  ```
  Compose templates map secret-like env keys to `KEY_FILE=/run/secrets/KEY` and mount files from the secrets directory. See `docs/SECRETS_CONVENTIONS.md`.

- Post-deploy route health check (ingress default):
  ```yaml
  - ansible.builtin.include_tasks: ../../automation/tasks/route_health_check.yml
    vars:
      route_health_check_url: "https://{{ reconya_subdomain }}.{{ domain }}/api/health"
      route_health_check_status_codes: [200, 302, 401]
  ```
  See `docs/POST_DEPLOY_SMOKE_TESTS.md`.