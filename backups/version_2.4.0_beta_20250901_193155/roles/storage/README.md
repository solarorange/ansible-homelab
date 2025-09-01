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

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose and pre-change snapshot automatically if a deployment fails.

- Manual rollback (storage component or sub-role):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., storage, filesystems, sync, cloud
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
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```

- Full stack version rollback (entire repository):
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```