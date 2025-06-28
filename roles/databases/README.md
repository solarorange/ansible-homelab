# Ansible Role: Databases

This role deploys and manages the database stack for the homelab, including relational, cache, and search databases. It is designed to be modular, secure, and resilient, with integrated monitoring, backup, and validation.

## Role Structure

The role is organized into the following components:

-   **`defaults/main.yml`**: Contains all default variables for the database stack. Passwords and secrets should be managed via Ansible Vault.
-   **`tasks/`**: The main entry point is `main.yml`, which includes other task files based on enabled services.
    -   `main.yml`: Orchestrates the entire role.
    -   `validate.yml`: Performs pre-flight checks and configuration validation.
    -   `prerequisites.yml`: Installs necessary packages and dependencies.
    -   `relational.yml`: Deploys and configures relational databases (PostgreSQL, MariaDB).
    -   `cache.yml`: Deploys and configures cache databases (Redis).
    -   `search.yml`: Deploys and configures search databases (Elasticsearch, Kibana).
    -   `monitoring.yml`: Integrates with the monitoring stack (Prometheus, Grafana, Telegraf, Loki).
    -   `security.yml`: Applies security hardening, firewall rules, and encryption.
    -   `backup.yml`: Configures automated backups with point-in-time recovery.
    -   `homepage.yml`: Integrates with the homepage dashboard.
    -   `alerts.yml`: Configures alerting rules.
    -   `validate_deployment.yml`: Performs post-deployment health checks and validation.
-   **`templates/`**: Contains Jinja2 templates for configuration files, scripts, and dashboards.
    -   `postgresql.conf.j2`: PostgreSQL configuration.
    -   `mariadb.conf.j2`: MariaDB configuration.
    -   `redis.conf.j2`: Redis configuration.
    -   `elasticsearch.yml.j2`: Elasticsearch configuration.
    -   `kibana.yml.j2`: Kibana configuration.
    -   `backup.sh.j2`: Backup script for each database.
    -   `restore.sh.j2`: Restore script for each database.
    -   `grafana-dashboard.json.j2`: Grafana dashboard for database monitoring.
-   **`handlers/`**: Contains handlers for restarting services.
-   **`vars/`**: Contains variables for the role.

## Requirements

-   Ansible 2.9 or higher.
-   Docker and Docker Compose installed on the target host.
-   Ansible Vault configured for secret management.
-   A running monitoring stack (Prometheus, Grafana, Loki).

## Usage

To use this role, include it in your playbook and configure the variables in `group_vars` or `host_vars`.

```yaml
- hosts: database_servers
  roles:
    - role: databases
```

### Variable Reference

A comprehensive list of variables can be found in `defaults/main.yml`. Key variables to configure include:

-   `databases_enabled`: Enable or disable the entire database stack.
-   `postgresql_enabled`, `mariadb_enabled`, `redis_enabled`, `elasticsearch_enabled`, `kibana_enabled`: Enable or disable individual database services.
-   `databases_backup_enabled`: Enable or disable automated backups.
-   `databases_monitoring_enabled`: Enable or disable monitoring integration.
-   `databases_security_enabled`: Enable or disable security features.
-   `databases_homepage_enabled`: Enable or disable homepage integration.

### Backup and Restore

This role configures automated backups with retention policies. To perform a manual backup or restore, you can use the generated scripts in the respective container's script directory (e.g., `{{ docker_dir }}/postgresql/scripts/`).

**Backup:**
```bash
/path/to/scripts/backup.sh
```

**Restore:**
To restore from a specific backup file:
```bash
/path/to/scripts/restore.sh /path/to/backup/file
```

### Monitoring

The role integrates with Prometheus for metrics collection and Grafana for visualization. A pre-configured Grafana dashboard is included. Logs are forwarded to Loki via Promtail.

### Security

Security is managed through several layers:

-   **Ansible Vault**: All secrets are encrypted.
-   **SSL/TLS**: Communication is encrypted.
-   **Firewall**: Network access is restricted.
-   **CrowdSec/Fail2ban**: Intrusion detection and prevention.

## Local Development and Testing

For local testing, you can use Molecule.

```bash
molecule test
``` 