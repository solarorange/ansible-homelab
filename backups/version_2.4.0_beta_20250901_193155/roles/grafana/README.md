# Grafana Role

## Overview
This role provides comprehensive automation for Grafana deployment and configuration in a homelab environment. It includes pre-configured dashboards, data sources, users, alerts, and monitoring setup.

## Features

### Core Functionality
- **Automated Deployment**: Docker-based Grafana deployment with proper configuration
- **Data Source Configuration**: Pre-configured Prometheus, Loki, PostgreSQL, Redis, and custom data sources
- **Dashboard Management**: Import and customize dashboards for all homelab services
- **User Management**: Create users, teams, and configure permissions
- **Alerting System**: Comprehensive alert rules and notification channels
- **Theme Configuration**: Dark theme and custom styling
- **Health Monitoring**: Built-in health checks and monitoring

### Dashboard Categories
1. **System Overview**: CPU, Memory, Disk, Network monitoring
2. **Service Monitoring**: Docker containers, service health, response times
3. **Media Services**: Sonarr/Radarr, Jellyfin, download monitoring
4. **Security Monitoring**: Authentication, firewall, intrusion detection
5. **Network & Infrastructure**: Traefik, SSL certificates, DNS health
6. **Database Monitoring**: PostgreSQL, Redis, MariaDB metrics
7. **Storage Monitoring**: File systems, backups, cloud storage

### Data Sources
- **Prometheus**: Metrics collection and storage
- **Loki**: Log aggregation and querying
- **PostgreSQL**: Database metrics and performance
- **Redis**: Cache metrics and performance
- **Node Exporter**: System metrics
- **Custom Homelab Metrics**: Service-specific metrics

### Alerting Configuration
- High resource usage alerts (CPU, Memory, Disk)
- Service down notifications
- Security event alerts
- Backup failure notifications
- SSL certificate expiration warnings
- Database connection issues

## Configuration

### Variables
```yaml
# Grafana Configuration
grafana_admin_user: admin
grafana_admin_password: "{{ vault_grafana_admin_password }}"
grafana_secret_key: "{{ vault_grafana_secret_key }}"
grafana_domain: grafana.{{ domain }}

# Data Sources
grafana_datasources:
  prometheus:
    enabled: true
    url: http://prometheus:9090
  loki:
    enabled: true
    url: http://loki:3100
  postgresql:
    enabled: true
    url: postgresql://user:pass@postgresql:5432/grafana
  redis:
    enabled: true
    url: redis://redis:6379

# Dashboard Configuration
grafana_dashboards_enabled: true
grafana_dashboard_folders:
  - name: "System Overview"
    description: "System-level monitoring dashboards"
  - name: "Services"
    description: "Service-specific dashboards"
  - name: "Security"
    description: "Security monitoring dashboards"

# Alerting Configuration
grafana_alerting_enabled: true
grafana_notification_channels:
  - name: "Email"
    type: email
    settings:
      addresses: admin@example.com
  - name: "Slack"
    type: slack
    settings:
      url: "{{ vault_slack_webhook_url }}"
```

### Usage
```yaml
# Include in your playbook
- hosts: monitoring
  roles:
    - grafana
```

## Files Structure
```
roles/grafana/
├── defaults/
│   └── main.yml          # Default variables
├── tasks/
│   ├── main.yml          # Main deployment tasks
│   ├── datasources.yml   # Data source configuration
│   ├── dashboards.yml    # Dashboard management
│   ├── users.yml         # User and permission management
│   ├── alerts.yml        # Alert configuration
│   └── monitoring.yml    # Health monitoring
├── templates/
│   ├── docker-compose.yml.j2
│   ├── grafana.ini.j2
│   ├── dashboards/
│   │   ├── system-overview.json.j2
│   │   ├── services.json.j2
│   │   └── security.json.j2
│   └── datasources/
│       ├── prometheus.yml.j2
│       ├── loki.yml.j2
│       └── postgresql.yml.j2
├── handlers/
│   └── main.yml
└── scripts/
    └── setup_grafana.py  # Python configuration script
```

## Dependencies
- Docker and Docker Compose
- Python 3.8+ (for configuration script)
- Ansible 2.9+

## Monitoring Integration
This role integrates with the existing monitoring stack:
- Prometheus for metrics collection
- Loki for log aggregation
- AlertManager for alert routing
- Node Exporter for system metrics

## Security Features
- Secure admin credentials
- TLS/SSL configuration
- Authentication integration
- Role-based access control
- Audit logging

## Maintenance
- Automated backups
- Health monitoring
- Performance optimization
- Plugin management
- Configuration validation 

## Rollback

- Automatic rollback on failed deploys: Deployments use a safe wrapper that restores the last-known-good Compose and pre-change snapshot if a deployment fails. No action required when a task fails; the role reverts automatically.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., grafana
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

- Rollback to a recorded rollback point (run on the target host):
  ```bash
  # List rollback IDs created before deployment
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'

  # Execute rollback to a specific ID
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```

- Full stack version rollback (run from repository root):
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  # or rollback to a saved version backup
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```