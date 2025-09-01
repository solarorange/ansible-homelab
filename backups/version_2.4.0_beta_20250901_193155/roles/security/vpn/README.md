# VPN Sub-Role

This sub-role manages VPN infrastructure for the security stack, including WireGuard and remote access. It provides modular tasks for deployment, validation, monitoring, backup, security hardening, and homepage integration.

## Features
- Deploy and configure WireGuard or other VPN solutions
- Secure remote access
- Vault integration for sensitive credentials
- Monitoring and alerting integration
- Automated backup and restore
- Security hardening and compliance
- Homepage integration

## Directory Structure
- defaults/main.yml         # Default variables
- vars/main.yml             # Sensitive variables
- handlers/main.yml         # Handlers for service restarts
- tasks/main.yml            # Main entry point
- tasks/deploy.yml          # Deployment tasks
- tasks/validate.yml        # Validation tasks
- tasks/validate_deployment.yml # Health checks
- tasks/monitoring.yml      # Monitoring integration
- tasks/backup.yml          # Backup & restore
- tasks/security.yml        # Security hardening
- tasks/homepage.yml        # Homepage integration
- tasks/alerts.yml          # Alerting integration
- templates/                # Service and homepage templates 

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose and pre-change snapshot automatically on failure.

- Manual rollback (VPN component):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=vpn
    sudo cp {{ backup_dir }}/${SERVICE}/last_good/docker-compose.yml {{ docker_dir }}/${SERVICE}/docker-compose.yml
    if [ -f {{ backup_dir }}/${SERVICE}/last_good/.env ]; then sudo cp {{ backup_dir }}/${SERVICE}/last_good/.env {{ docker_dir }}/${SERVICE}/.env; fi
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```
  - Option B — restore pre-change snapshot
    ```bash
    SERVICE=vpn
    ls -1 {{ backup_dir }}/${SERVICE}/prechange_*.tar.gz
    sudo tar -xzf {{ backup_dir }}/${SERVICE}/prechange_<TIMESTAMP>.tar.gz -C /
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```

- Rollback to a recorded rollback point (target host):
  ```bash
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```