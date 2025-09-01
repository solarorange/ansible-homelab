# Vaultwarden Role

This Ansible role deploys and configures [Vaultwarden](https://github.com/dani-garcia/vaultwarden), a self-hosted password manager compatible with Bitwarden clients, in a production-ready homelab environment.

## Overview

Vaultwarden is an open-source password manager that provides:

- Secure password and secret storage
- Web, desktop, and mobile client support (Bitwarden-compatible)
- User authentication and organization support
- API for integration with other services
- Encrypted vaults and attachments
- WebSocket support for live updates

## Features

### Core Functionality
- **Docker-based deployment** (SQLite or PostgreSQL backend)
- **Traefik integration** for reverse proxy and SSL termination
- **Authentik integration** for authentication
- **Monitoring integration** with Prometheus, Grafana, and Loki
- **Automated backups** with retention policies
- **Comprehensive health monitoring**
- **Security hardening** with CrowdSec and Fail2ban
- **Automatic configuration** of all required variables and secrets

### Integration Points
- **Homepage integration** for dashboard access
- **Alerting system** with AlertManager
- **Log aggregation** with Loki
- **Metrics collection** with Prometheus
- **Grafana dashboards** for monitoring

### Automatic Configuration
The role automatically generates and configures:
- **Admin Token**: Secure 32-character token for admin access
- **PostgreSQL Password**: Secure 32-character password (if using PostgreSQL)
- **Homepage API Key**: Secure 24-character key for Homepage integration
- **Domain Configuration**: Automatic domain and subdomain setup
- **Database URL**: Automatic database connection string generation
- **SMTP Configuration**: Optional email configuration with sensible defaults
- **Security Settings**: Automatic security headers, rate limiting, and CORS configuration

## Requirements

### System Requirements
- Docker and Docker Compose
- Minimum 2GB RAM
- Minimum 10GB storage
- Network access for container images

### Ansible Requirements
- Ansible 2.12+
- `community.docker` collection
- `ansible.builtin` modules

### Dependencies
- Traefik (for reverse proxy)
- Authentik (for authentication)
- Monitoring stack (optional)
- Backup system (optional)

## Role Variables

### Service Configuration
```yaml
vaultwarden_enabled: true
vaultwarden_version: "latest"
vaultwarden_port: 80
vaultwarden_subdomain: "vault"
```

### Database Configuration
```yaml
vaultwarden_database_type: "sqlite"  # or "postgresql"
vaultwarden_database_host: "vaultwarden-postgres"
vaultwarden_database_port: 5432
vaultwarden_database_name: "vaultwarden"
vaultwarden_database_user: "postgres"
# vaultwarden_database_password: auto-generated if not provided
```

### Authentication
```yaml
vaultwarden_auth_method: "authentik"
vaultwarden_admin_email: "{{ admin_email }}"
# vaultwarden_admin_token: auto-generated if not provided
```

### SMTP Configuration (Optional)
```yaml
vaultwarden_smtp_host: ""  # Leave empty to disable SMTP
vaultwarden_smtp_from: "vaultwarden@yourdomain.com"
vaultwarden_smtp_port: "587"
vaultwarden_smtp_ssl: "true"
vaultwarden_smtp_username: ""
vaultwarden_smtp_password: ""
```

### Monitoring
```yaml
vaultwarden_monitoring_enabled: true
vaultwarden_prometheus_enabled: true
vaultwarden_grafana_enabled: true
vaultwarden_loki_enabled: true
```

### Backup
```yaml
vaultwarden_backup_enabled: true
vaultwarden_backup_schedule: "0 2 * * *"
vaultwarden_backup_retention_days: 7
```

## Installation

### 1. Add to Inventory
Add `vaultwarden` to the `enabled_services` list in your inventory:

```yaml
enabled_services:
  - vaultwarden
```

### 2. Configure Variables (Optional)
Most variables are automatically configured. You can override defaults in `group_vars/all/common.yml` or host/group vars as needed.

### 3. Include Role in Playbook
The role is automatically included if `vaultwarden` is in `enabled_services`.

## Usage

- Access Vaultwarden at: `https://vault.<yourdomain>`
- Admin interface: Use the auto-generated admin token (saved to `{{ vaultwarden_config_dir }}/secrets/admin_token.txt`)
- WebSocket: Exposed on port 3012 for live updates

## Automatic Configuration Details

### Generated Secrets
The role automatically generates and stores the following secrets:
- **Admin Token**: `{{ vaultwarden_config_dir }}/secrets/admin_token.txt`
- **PostgreSQL Password**: `{{ vaultwarden_config_dir }}/secrets/postgres_password.txt` (if using PostgreSQL)
- **Homepage API Key**: `{{ vaultwarden_config_dir }}/secrets/homepage_api_key.txt`

### Configuration Summary
A complete configuration summary is saved to:
- `{{ vaultwarden_config_dir }}/config_summary.txt`

### Manual Override
You can manually set any of these variables in your vault or group_vars:
```yaml
vault_vaultwarden_admin_token: "your-custom-admin-token"
vault_vaultwarden_postgres_password: "your-custom-password"
vault_homepage_api_keys:
  vaultwarden: "your-custom-api-key"
```

## Backup & Restore
- Backups are stored in `{{ vaultwarden_backup_dir }}`
- Use the provided management script for manual backup/restore
- Generated secrets are included in backups

## Security
- SSL/TLS via Traefik
- Security headers, rate limiting, and CORS configurable
- CrowdSec and Fail2ban integration
- All secrets are stored with 600 permissions

### Container Hardening Notes
- The compose template applies `security_opt: [no-new-privileges:true]` and `cap_drop: [ALL]`.
- `read_only` is disabled due to persistent database and runtime needs; tmpfs is used for `/tmp`.

## Monitoring
- Prometheus metrics endpoint: `/metrics`
- Grafana dashboards and Loki log aggregation

## Homepage Integration
- Vaultwarden appears in the Homelab Homepage dashboard with icon, health, and quick links
- API key is automatically generated and configured

## License

This role is provided under the MIT License. Vaultwarden is licensed under GPL-3.0. 

## Rollback

- Automatic rollback on failed deploys: Deployments use a safe wrapper that restores the last-known-good Compose and pre-change snapshot if a deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., vaultwarden
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