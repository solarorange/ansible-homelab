# Automation Stack Role

This role manages all automation infrastructure for the homelab, including container management, home automation, and scheduling. It provides modular tasks for deployment, validation, monitoring, backup, security, and homepage integration.

## Features
- Container management and automated updates (Watchtower)
- Home automation (Home Assistant, Zigbee2MQTT, Node-RED, n8n)
- Workflow and job scheduling
- Advanced backup and log rotation
- Security hardening and access controls
- Monitoring and alerting integration
- Homepage integration
- Modular sub-roles: `container_management`, `home_automation`, `scheduling`

## Directory Structure
- `defaults/`: Default variables
- `handlers/`: Service handlers
- `tasks/`: Modular tasks (main, backup, monitoring, security, homepage, validate, etc.)
- `templates/`: Jinja2 templates for configs, scripts, homepage, etc.
- `container_management/`, `home_automation/`, `scheduling/`: Sub-roles for extensibility

## Usage
Include this role in your playbook:
```yaml
- hosts: all
  roles:
    - role: automation
```

## Variables
See `defaults/main.yml` for all configurable options. Sensitive variables should be stored in Ansible Vault.

## Integration
- Monitoring: Prometheus, Grafana, logrotate
- Backup: Scheduled, compressed, encrypted
- Security: Hardening, access control, fail2ban, firewall
- Homepage: Service registration and status

## Sub-Roles
- `container_management`: Deploys and manages the `containrrr/watchtower` container for automated Docker image updates.
- `home_automation`: Manages Home Assistant, Zigbee2MQTT, and related integrations.
- `scheduling`: Manages scheduled tasks, systemd timers, and workflow automation (Node-RED, n8n).

## Validation & Health Checks
- Automated validation and health scripts for all automation services

## Author
Auto-generated from existing homelab stack by migration automation.

## Structure
```
roles/automation/
  README.md
  defaults/
    main.yml
  handlers/
    main.yml
  tasks/
    main.yml
    backup.yml
    monitoring.yml
    security.yml
    homepage.yml
    validate.yml
    validate_deployment.yml
    prerequisites.yml
  templates/
    homepage-services.yml.j2
    backup.sh.j2
    healthcheck.sh.j2
    monitoring.yml.j2
    security.yml.j2
    docker-compose.yml.j2
  container_management/
    tasks/
      main.yml
  home_automation/
    tasks/
      main.yml
  scheduling/
    tasks/
      main.yml
```

## Integration
- **Monitoring**: Exposes metrics, logs, and dashboards for all automation services.
- **Backup**: Scheduled and on-demand backups for configs and data.
- **Security**: Integrates with CrowdSec, Fail2ban, and vault for secrets.
- **Homepage**: Adds automation services to the homepage dashboard.

## Validation
- Automated health checks for all services
- Validation tasks for monitoring, backup, and security integration

## Extending
Add new automation services by creating a new sub-role or task file and updating the relevant templates and variables.

---
For detailed configuration, see the documentation in the `docs/` directory and the example playbooks. 

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose files and the pre-change snapshot automatically when a deployment fails.

- Manual rollback (a specific automation component/service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., automation
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

- Full stack version rollback (entire repository):
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```

### Secrets & Health Checks

- Shared secrets automation:
  - Secrets directory per service: `{{ docker_dir }}/<service>/secrets`.
  - Opt-in variables:
    ```yaml
    <role>_manage_secret_files: true
    <role>_secret_files:
      - name: EXAMPLE_SECRET
        from_vault_var: vault_example_secret
    <role>_required_secrets:
      - EXAMPLE_SECRET
    ```
  - Use `KEY_FILE=/run/secrets/KEY` in templates for keys containing `PASSWORD|SECRET|TOKEN|API`. See `docs/SECRETS_CONVENTIONS.md`.

- Route-based health checks:
  - Use `roles/automation/tasks/route_health_check.yml` with `route_health_check_url` like `https://<sub>.<domain>/api/health` and acceptable codes `[200, 302, 401]`.
  - See `docs/POST_DEPLOY_SMOKE_TESTS.md`.