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

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose and pre-change snapshot automatically if a deployment fails.

- Manual rollback (this role):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., logging
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

- Secrets directory: `{{ docker_dir }}/logging/secrets`.
- If any components require secrets, enable file-based secrets:
  ```yaml
  logging_manage_secret_files: true
  logging_secret_files:
    - name: LOKI_S3_SECRET_KEY
      from_vault_var: vault_loki_s3_secret_key
  logging_required_secrets:
    - LOKI_S3_SECRET_KEY
  ```
  Compose templates must map secret-like env keys to `KEY_FILE=/run/secrets/KEY`. See `docs/SECRETS_CONVENTIONS.md`.

- Post-deploy route health check (if exposed via Traefik):
  ```yaml
  - ansible.builtin.include_tasks: ../../automation/tasks/route_health_check.yml
    vars:
      route_health_check_url: "https://{{ loki_subdomain }}.{{ domain }}/ready"
      route_health_check_status_codes: [200]
  ```
  See `docs/POST_DEPLOY_SMOKE_TESTS.md`.