# Databases Role

This role manages all database infrastructure for the homelab, including relational (PostgreSQL, MariaDB), cache (Redis), and search (Elasticsearch, Kibana) services. It provides modular tasks for deployment, validation, monitoring, backup/restore (with PITR), security, and homepage integration.

## Directory Structure

```
defaults/main.yml         # Default variables for all services
handlers/main.yml         # Handlers for service restarts, notifications
vars/main.yml             # Sensitive or environment-specific variables

tasks/main.yml            # Main entry point, includes all modular tasks
tasks/prerequisites.yml   # Pre-flight checks and setup
tasks/relational.yml      # PostgreSQL & MariaDB deployment/config/backup
tasks/cache.yml           # Redis deployment/config/backup
tasks/search.yml          # Elasticsearch & Kibana deployment/config/backup
tasks/monitoring.yml      # Monitoring integration (Prometheus, Grafana)
tasks/backup.yml          # Backup & PITR scripts, scheduling, restore
tasks/security.yml        # Security hardening, SSL, auth
tasks/homepage.yml        # Homepage integration
tasks/alerts.yml          # Alerting integration
tasks/validate.yml        # Validation tasks (connectivity, config)
tasks/validate_deployment.yml # End-to-end health checks

templates/                # All config, script, and dashboard templates
```

## Variables & Vault Integration

- All tunable variables are in `defaults/main.yml`.
- Sensitive variables (passwords, keys) are referenced in `vars/main.yml` and can be overridden in `group_vars/` or `host_vars/` (vault-encrypted recommended).
- Example:
  ```yaml
  postgresql_admin_password: "{{ vault_postgresql_admin_password | default(lookup('password', '/dev/null length=32 chars=ascii_letters,digits')) }}"
  ```
- To override, create `group_vars/all/vault.yml` (encrypted with `ansible-vault`).

## Usage

1. Include the role in your playbook:
   ```yaml
   - hosts: databases
     roles:
       - databases
   ```
2. Set/override variables as needed in inventory or group_vars.
3. Ensure vault files are available for sensitive data.

## Backup & Restore

- Automated full and PITR backups for PostgreSQL and MariaDB.
- Backup scripts and cron jobs are deployed to each service.
- Restore scripts provided for manual or automated recovery.
- Validation tasks check backup integrity and test restores.

## Validation & Health Checks

- Connectivity checks for all services (e.g., `pg_isready`, `mysqladmin ping`, `redis-cli ping`, HTTP checks for Elasticsearch/Kibana).
- Backup file age and integrity checks.
- Security configuration validation.

## Monitoring Integration

- Prometheus exporters for all services.
- Grafana dashboards provisioned for database metrics.
- Alertmanager rules for backup failures, service downtime, and performance issues.

## Security Hardening

- SSL/TLS enforced for all services.
- Strong, rotated passwords.
- Hardened config files (e.g., `pg_hba.conf`, `my.cnf`, `redis.conf`).
- Authentication enabled and access restricted.
- Optional integration with CrowdSec/Fail2Ban.

## Homepage Integration

- All database services are added to the homepage with icons, categories, and descriptions.
- See `tasks/homepage.yml` for configuration details.

## Extending & Customizing

- Add new services by extending the relevant task files and templates.
- Override any variable in your inventory or group_vars.
- Use vault for all sensitive data.

---

For detailed variable documentation, see `defaults/main.yml`. 