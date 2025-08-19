# n8n Role

This Ansible role deploys and configures n8n, a powerful workflow automation platform that allows you to connect different services and automate tasks through a visual interface.

## Features

- **Workflow Automation**: Create complex workflows with a visual drag-and-drop interface
- **Service Integration**: Connect to hundreds of services via REST APIs, webhooks, and more
- **Database Storage**: PostgreSQL backend for reliable data persistence
- **Security**: Integrated with Authentik for authentication and access control
- **Monitoring**: Full integration with Prometheus, Grafana, and Loki
- **Backup**: Automated backup and recovery system
- **Homepage Integration**: Seamless integration with Homepage dashboard
- **Alerting**: Comprehensive alerting and notification system

## Requirements

- Docker and Docker Compose
- PostgreSQL (included in deployment)
- Traefik for reverse proxy and SSL termination
- Authentik for authentication (optional)
- Monitoring stack (Prometheus, Grafana, Loki)

## Role Variables

### Service Configuration

```yaml
# Enable/disable n8n
n8n_enabled: true

# n8n version
n8n_version: "latest"

# Network configuration
n8n_network_name: "n8n"
n8n_network_external: true

# Port configuration
n8n_port: 5678

# Domain configuration
n8n_subdomain: "n8n"
```

### Database Configuration

```yaml
# Database settings
n8n_database_type: "postgresql"
n8n_database_host: "n8n-postgres"
n8n_database_port: 5432
n8n_database_name: "n8n"
n8n_database_user: "postgres"
n8n_database_password: "{{ vault_n8n_postgres_password }}"
```

### Authentication Configuration

```yaml
# Authentication method (authentik, basic, none)
n8n_auth_method: "authentik"

# Admin email
n8n_admin_email: "{{ admin_email }}"

# Basic auth credentials (when auth_method is basic)
n8n_basic_auth_user: "admin"
n8n_basic_auth_password: "{{ vault_n8n_admin_password }}"
```

### Resource Limits

```yaml
# Memory and CPU limits
n8n_memory_limit: "4g"
n8n_cpu_limit: "2.0"
n8n_storage_limit: "100g"
```

### Monitoring Configuration

```yaml
# Monitoring integration
n8n_monitoring_enabled: true
n8n_prometheus_enabled: true
n8n_grafana_enabled: true
n8n_loki_enabled: true
n8n_telegraf_enabled: true

# Health check settings
n8n_health_check_enabled: true
n8n_health_check_interval: 30
```

### Backup Configuration

```yaml
# Backup settings
n8n_backup_enabled: true
n8n_backup_schedule: "0 3 * * *"  # Daily at 3 AM
n8n_backup_retention: 7  # Keep backups for 7 days
n8n_backup_compression: true
n8n_backup_dir: "{{ backup_dir }}/n8n"
```

### Security Configuration

```yaml
# Security features
n8n_security_headers: true
n8n_rate_limiting: true
n8n_rate_limit_requests: 100
n8n_rate_limit_window: 60
n8n_cors_enabled: false

# Security services
n8n_crowdsec_enabled: true
n8n_fail2ban_enabled: true
```

### Homepage Integration

```yaml
# Homepage integration
n8n_homepage_enabled: true
n8n_homepage_category: "Automation"
n8n_homepage_description: "Workflow Automation & Integration Platform"
n8n_homepage_icon: "n8n.png"
n8n_homepage_widget_enabled: true
```

### Alerting Configuration

```yaml
# Alerting settings
n8n_alerting_enabled: true
n8n_alerting_provider: "alertmanager"

# Notification channels
n8n_email_notifications: true
n8n_slack_notifications: true
n8n_discord_notifications: true
n8n_telegram_notifications: true
```

## Dependencies

This role depends on the following services:

- `docker`: Container runtime
- `traefik`: Reverse proxy and SSL termination
- `monitoring_infrastructure`: Prometheus, Grafana, Loki stack
- `authentik`: Authentication service (optional)

## Example Playbook

```yaml
---
- hosts: homelab
  roles:
    - n8n
  vars:
    n8n_enabled: true
    n8n_subdomain: "workflows"
    n8n_auth_method: "authentik"
    n8n_monitoring_enabled: true
    n8n_backup_enabled: true
    n8n_homepage_enabled: true
```

## Usage

### Basic Deployment

```bash
# Deploy n8n with default settings
ansible-playbook site.yml --tags n8n

# Deploy with custom variables
ansible-playbook site.yml --tags n8n -e "n8n_subdomain=workflows"
```

### Configuration Management

```bash
# Update n8n configuration
ansible-playbook site.yml --tags "n8n,deploy"

# Restart n8n services
ansible-playbook site.yml --tags "n8n" --extra-vars "restart_n8n=true"

# Backup n8n data
ansible-playbook site.yml --tags "n8n,backup"
```

### Monitoring and Maintenance

```bash
# Check n8n health
ansible-playbook site.yml --tags "n8n,validation"

# View n8n logs
docker logs n8n-app

# Access n8n web interface
# https://n8n.yourdomain.com
```

## Access Information

After deployment, n8n will be available at:

- **Web Interface**: `https://n8n.yourdomain.com`
- **Local Access**: `http://localhost:5678`
- **Health Check**: `http://localhost:5678/healthz`
- **Metrics**: `http://localhost:5678/metrics`

## Authentication

### Authentik Integration

When using Authentik authentication:

1. Configure Authentik application for n8n
2. Set up OAuth2 provider in Authentik
3. Configure n8n to use Authentik as authentication provider
4. Users will be redirected to Authentik for login

### Basic Authentication

When using basic authentication:

1. Set `n8n_auth_method: "basic"`
2. Configure admin credentials in vault variables
3. Users will be prompted for username/password

## Workflow Management

### Creating Workflows

1. Access n8n web interface
2. Click "Create new workflow"
3. Use the visual editor to design workflows
4. Connect nodes to create automation flows
5. Test and activate workflows

### Common Use Cases

- **Data Synchronization**: Sync data between different services
- **Notification Systems**: Send alerts based on events
- **File Processing**: Automate file operations and transformations
- **API Integration**: Connect multiple APIs and services
- **Scheduled Tasks**: Run workflows on specific schedules

## Monitoring and Observability

### Metrics

n8n exposes metrics at `/metrics` endpoint for Prometheus scraping:

- Workflow execution counts
- Node execution times
- Error rates
- Resource usage

### Logs

Logs are collected by Loki and can be viewed in Grafana:

- Application logs
- Workflow execution logs
- Error logs
- Access logs

### Dashboards

Grafana dashboards provide:

- Workflow performance metrics
- System health monitoring
- Error tracking
- Resource utilization

## Backup and Recovery

### Automated Backups

Backups are automatically created:

- **Schedule**: Daily at 3 AM (configurable)
- **Retention**: 7 days (configurable)
- **Compression**: Enabled by default
- **Location**: `{{ backup_dir }}/n8n`

### Manual Backup

```bash
# Create manual backup
docker exec n8n-app n8n export:workflow --all

# Backup database
docker exec n8n-postgres pg_dump -U postgres n8n > backup.sql
```

### Recovery

```bash
# Restore from backup
docker exec -i n8n-postgres psql -U postgres n8n < backup.sql

# Import workflows
docker exec n8n-app n8n import:workflow --input=workflows.json
```

## Security Considerations

### Network Security

- n8n is exposed through Traefik with SSL termination
- Rate limiting is enabled by default
- Security headers are configured
- CORS is disabled by default

### Access Control

- Authentication is required for all access
- Integration with Authentik provides SSO capabilities
- Role-based access control through Authentik
- API access is restricted to authenticated users

### Data Protection

- All sensitive data is encrypted at rest
- Database passwords are stored in Ansible vault
- Backup encryption is enabled
- Logs are rotated and secured

## Troubleshooting

### Common Issues

1. **Service Not Starting**
   - Check Docker logs: `docker logs n8n-app`
   - Verify database connectivity
   - Check resource limits

2. **Authentication Issues**
   - Verify Authentik configuration
   - Check OAuth2 settings
   - Validate user permissions

3. **Workflow Failures**
   - Check node configurations
   - Verify API credentials
   - Review error logs

4. **Performance Issues**
   - Monitor resource usage
   - Check database performance
   - Review workflow complexity

### Debug Commands

```bash
# Check container status
docker ps | grep n8n

# View application logs
docker logs n8n-app --tail 100

# Check database connectivity
docker exec n8n-postgres pg_isready -U postgres

# Test health endpoint
curl http://localhost:5678/healthz

# Check metrics
curl http://localhost:5678/metrics
```

## Integration Examples

### Home Assistant Integration

```javascript
// n8n workflow to control Home Assistant
{
  "nodes": [
    {
      "type": "homeAssistant",
      "operation": "callService",
      "service": "light.turn_on",
      "entityId": "light.living_room"
    }
  ]
}
```

### Slack Notifications

```javascript
// n8n workflow for Slack notifications
{
  "nodes": [
    {
      "type": "slack",
      "operation": "postMessage",
      "channel": "#alerts",
      "text": "Workflow completed successfully"
    }
  ]
}
```

### Database Operations

```javascript
// n8n workflow for database operations
{
  "nodes": [
    {
      "type": "postgres",
      "operation": "executeQuery",
      "query": "SELECT * FROM users WHERE status = 'active'"
    }
  ]
}
```

## Contributing

To contribute to this role:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This role is licensed under the MIT License. See LICENSE file for details.

## Support

For support and questions:

- Check the [n8n documentation](https://docs.n8n.io/)
- Review the [Ansible documentation](https://docs.ansible.com/)
- Open an issue in the repository
- Join the community discussions

## Changelog

### Version 1.0.0
- Initial release
- Full n8n deployment with PostgreSQL
- Monitoring and alerting integration
- Homepage integration
- Backup and recovery system
- Security hardening
- Comprehensive documentation 

## Rollback

- Automatic rollback on failed deploys: The compose deploy wrapper restores last-known-good Compose and the pre-change snapshot automatically if deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., n8n
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