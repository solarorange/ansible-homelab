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