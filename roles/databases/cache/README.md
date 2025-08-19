# Cache Sub-Role (Redis)

This sub-role manages deployment, configuration, backup/restore, validation, and security for cache databases (Redis) as part of the main databases role.

- Modular tasks: creation, config, backup, validation, homepage integration
- Integrates with monitoring, security, and backup systems
- Variables and templates are inherited from the main role 

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose and pre-change snapshot automatically on failure.

- Manual rollback (Cache component):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=cache
    sudo cp {{ backup_dir }}/${SERVICE}/last_good/docker-compose.yml {{ docker_dir }}/${SERVICE}/docker-compose.yml
    if [ -f {{ backup_dir }}/${SERVICE}/last_good/.env ]; then sudo cp {{ backup_dir }}/${SERVICE}/last_good/.env {{ docker_dir }}/${SERVICE}/.env; fi
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```
  - Option B — restore pre-change snapshot
    ```bash
    SERVICE=cache
    ls -1 {{ backup_dir }}/${SERVICE}/prechange_*.tar.gz
    sudo tar -xzf {{ backup_dir }}/${SERVICE}/prechange_<TIMESTAMP>.tar.gz -C /
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```