# Storage Stack Role

This role manages all storage infrastructure for the homelab, including filesystems, network shares, sync, and cloud storage. It provides modular tasks for deployment, validation, monitoring, backup, security, and homepage integration.

## Features
- Filesystem provisioning and optimization
- Samba network shares
- Syncthing and cloud sync
- Nextcloud deployment
- Advanced backup with deduplication
- Security hardening and encryption
- Monitoring and alerting integration
- Homepage integration
- Modular sub-roles: `filesystems`, `sync`, `cloud`

## Directory Structure
- `defaults/`: Default variables
- `handlers/`: Service handlers
- `tasks/`: Modular tasks (main, deploy, backup, monitoring, etc.)
- `templates/`: Jinja2 templates for configs, scripts, homepage, etc.
- `filesystems/`, `sync/`, `cloud/`: Sub-roles for extensibility

## Usage
Include this role in your playbook:
```yaml
- hosts: all
  roles:
    - role: storage
```

## Variables
See `defaults/main.yml` for all configurable options. Sensitive variables should be stored in Ansible Vault.

## Integration
- Monitoring: Prometheus, Grafana, logrotate
- Backup: Scheduled, deduplicated, encrypted
- Security: Hardening, access control, encryption
- Homepage: Service registration and status

## Sub-Roles
- `filesystems`: Local storage and filesystems
- `sync`: File synchronization (Syncthing, etc.)
- `cloud`: Cloud storage integration (Nextcloud, rclone, etc.)

## Validation & Health Checks
- Automated validation and health scripts for all storage services

## Author
Auto-generated from existing homelab stack by migration automation. 