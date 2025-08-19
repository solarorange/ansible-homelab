# Media Stack Role

A comprehensive Ansible role for deploying and managing a complete media stack in a homelab environment. This role provides a modular approach to deploying downloaders, ARR services, and media players with full integration to monitoring, security, backup, and homepage systems.

## Overview

The Media Stack role deploys a complete media management ecosystem including:

### Downloaders
- **SABnzbd** - Usenet downloader
- **qBittorrent** - Torrent client

### ARR Services
- **Prowlarr** - Indexer management
- **Sonarr** - TV show management
- **Radarr** - Movie management
- **Lidarr** - Music management
- **Readarr** - Book management
- **Bazarr** - Subtitle management
- **Pulsarr** - ARR service status dashboard

### Media Players
- **Jellyfin** - Media server
- **Immich** - Photo management (with PostgreSQL and Redis)

## Features

- **Modular Design**: Separate deployment of downloaders, ARR services, and players
- **Comprehensive Monitoring**: Integration with Prometheus, Grafana, Loki, and Telegraf
- **Security Hardening**: Fail2ban, CrowdSec, SSL/TLS, and access control
- **Automated Backup**: Configurable backup schedules with verification and recovery
- **Homepage Integration**: Automatic service discovery and dashboard integration
- **Alerting**: Multi-channel notifications (email, Slack, Discord, webhooks)
- **Health Checks**: Automated health monitoring and recovery
- **Resource Management**: CPU and memory limits with performance optimization

## Requirements

### System Requirements
- Minimum 4 CPU cores
- 8GB RAM (16GB recommended)
- 500GB+ storage space
- Docker and Docker Compose
- Ansible 2.9+

### Dependencies
- Docker role
- Traefik role
- Monitoring infrastructure role
- Backup infrastructure (optional)
- Homepage role (optional)

## Role Variables

### Main Configuration
```yaml
# Enable/disable media stack
media_enabled: true

# Component enablement
media_downloaders_enabled: true
media_arr_services_enabled: true
media_players_enabled: true

# Network configuration
media_network_name: "media"
media_network_external: true
```

### Service Configuration
```yaml
# Downloader configuration
media_downloaders:
  sabnzbd:
    enabled: true
    image: "linuxserver/sabnzbd:latest"
    port: 8080
    subdomain: "sabnzbd"
    volumes:
      - "{{ docker_dir }}/sabnzbd/config:/config"
      - "{{ data_dir }}/downloads/usenet:/downloads"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/api?mode=version"]
      interval: "30s"
      timeout: "10s"
      retries: 3
    resources:
      limits:
        cpus: '1'
        memory: 1G
      reservations:
        cpus: '0.25'
        memory: 512M

  qbittorrent:
    enabled: true
    image: "linuxserver/qbittorrent:latest"
    port: 8081
    subdomain: "qbittorrent"
    # ... similar configuration
```

### Monitoring Configuration
```yaml
# Monitoring integration
media_monitoring_enabled: true
media_metrics_enabled: true
media_health_check_enabled: true
media_health_check_interval: 30

# Grafana integration
media_grafana_enabled: true
media_grafana_dashboard: true
media_grafana_datasource: "prometheus"

# Prometheus integration
media_prometheus_enabled: true
media_prometheus_metrics: true
media_prometheus_scrape_interval: 30

# Loki integration
media_loki_enabled: true
media_loki_logs: true
```

### Security Configuration
```yaml
# Security features
media_security_headers: true
media_rate_limiting: true
media_rate_limit_requests: 100
media_rate_limit_window: 60
media_cors_enabled: false
media_allow_anonymous_access: false

# CrowdSec integration
media_crowdsec_enabled: true
media_crowdsec_collections:
  - "crowdsecurity/nginx"
  - "crowdsecurity/http-cve"

# Fail2ban integration
media_fail2ban_enabled: true
media_fail2ban_jail: "media-stack"
media_fail2ban_max_retry: 5
media_fail2ban_bantime: 3600
```

### Backup Configuration
```yaml
# Backup settings
media_backup_enabled: true
media_backup_schedule: "0 2 * * *"  # Daily at 2 AM
media_backup_retention: 7  # Keep backups for 7 days
media_backup_compression: true
media_backup_include_media: true
media_backup_include_database: true
media_backup_include_config: true
```

### Homepage Integration
```yaml
# Homepage integration
media_homepage_enabled: true
media_homepage_category: "Media"
media_homepage_description: "Media Management & Streaming"
media_homepage_icon: "media.png"
media_homepage_widget_enabled: true
```

### Alerting Configuration
```yaml
# Alerting settings
media_alerting_enabled: true
media_alerting_provider: "alertmanager"
media_alerting_webhook: "http://alertmanager:9093/api/v1/alerts"

# Notification channels
media_notifications_enabled: true
media_notification_channels:
  - "email"
  - "webhook"
  - "slack"
  - "discord"

# Email configuration
media_email_enabled: false
media_smtp_host: "{{ smtp_host | default('localhost') }}"
media_smtp_port: "{{ smtp_port | default(587) }}"
media_smtp_username: "{{ smtp_username | default('') }}"
media_smtp_password: "{{ smtp_password | default('') }}"
media_smtp_encryption: "{{ smtp_encryption | default('tls') }}"
```

## Usage

### Basic Usage
```yaml
# In your playbook
- hosts: media_servers
  roles:
    - media
```

### Advanced Usage
```yaml
# In your playbook with custom configuration
- hosts: media_servers
  vars:
    media_enabled: true
    media_downloaders_enabled: true
    media_arr_services_enabled: true
    media_players_enabled: true
    
    # Custom service configuration
    media_downloaders:
      sabnzbd:
        enabled: true
        port: 8080
      qbittorrent:
        enabled: false  # Disable qBittorrent
    
    # Custom monitoring
    media_monitoring_enabled: true
    media_grafana_enabled: true
    
    # Custom backup
    media_backup_enabled: true
    media_backup_schedule: "0 3 * * *"  # 3 AM instead of 2 AM
    
  roles:
    - media
```

### Tagged Execution
```bash
# Deploy only downloaders
ansible-playbook site.yml --tags "media,downloaders"

# Deploy only ARR services
ansible-playbook site.yml --tags "media,arr_services"

# Deploy only media players
ansible-playbook site.yml --tags "media,players"

# Configure only monitoring
ansible-playbook site.yml --tags "media,monitoring"

# Configure only security
ansible-playbook site.yml --tags "media,security"

# Configure only backup
ansible-playbook site.yml --tags "media,backup"

# Configure only homepage integration
ansible-playbook site.yml --tags "media,homepage"

# Configure only alerting
ansible-playbook site.yml --tags "media,alerts"

# Run validation only
ansible-playbook site.yml --tags "media,validation"
```

## Directory Structure

```
roles/media/
├── defaults/
│   └── main.yml              # Default variables
├── handlers/
│   └── main.yml              # Handlers for restarting services
├── tasks/
│   ├── main.yml              # Main task orchestration
│   ├── validate.yml          # Pre-deployment validation
│   ├── prerequisites.yml     # Setup and prerequisites
│   ├── downloaders.yml       # Deploy downloaders
│   ├── arr_services.yml      # Deploy ARR services
│   ├── players.yml           # Deploy media players
│   ├── monitoring.yml        # Configure monitoring
│   ├── security.yml          # Configure security
│   ├── backup.yml            # Configure backup
│   ├── homepage.yml          # Configure homepage integration
│   ├── alerts.yml            # Configure alerting
│   └── validate_deployment.yml # Post-deployment validation
├── templates/                # Jinja2 templates
└── README.md                 # This file
```

## Services and Ports

| Service | Port | Subdomain | Description |
|---------|------|-----------|-------------|
| SABnzbd | 8080 | sabnzbd | Usenet downloader |
| qBittorrent | 8081 | qbittorrent | Torrent client |
| Prowlarr | 9696 | prowlarr | Indexer management |
| Sonarr | 8989 | sonarr | TV show management |
| Radarr | 7878 | radarr | Movie management |
| Lidarr | 8686 | lidarr | Music management |
| Readarr | 8787 | readarr | Book management |
| Bazarr | 6767 | bazarr | Subtitle management |
| Pulsarr | 8088 | pulsarr | ARR service dashboard |
| Jellyfin | 8096 | jellyfin | Media server |
| Immich Server | 3001 | immich | Photo management API |
| Immich Web | 3000 | immich | Photo management UI |
| Immich ML | 3003 | - | Machine learning service |

## Monitoring Integration

The role automatically configures:

### Prometheus Metrics
- Service health metrics
- Resource usage metrics
- Download statistics
- Media library statistics

### Grafana Dashboards
- Media stack overview dashboard
- Service-specific dashboards
- Performance metrics
- Resource utilization

### Loki Log Aggregation
- Centralized log collection
- Structured logging
- Log retention policies
- Search and filtering

### Telegraf Integration
- System metrics collection
- Docker container metrics
- Network statistics
- Custom media metrics

## Security Features

### Access Control
- Authentik integration
- Rate limiting
- Security headers
- CORS configuration

### Intrusion Detection
- Fail2ban integration
- CrowdSec integration
- Automated blocking
- Security monitoring

### SSL/TLS
- Automatic certificate management
- Secure communication
- Certificate validation
- Security compliance

## Backup and Recovery

### Automated Backup
- Daily scheduled backups
- Configurable retention
- Compression and encryption
- Verification and testing

### Backup Components
- Service configurations
- Media metadata
- Database backups
- Log archives

### Recovery Procedures
- Automated recovery scripts
- Disaster recovery plans
- Backup validation
- Rollback procedures

## Maintenance

### Health Checks
- Automated health monitoring
- Service status checks
- Resource monitoring
- Performance metrics

### Maintenance Tasks
- Log rotation
- Database optimization
- Cache cleanup
- Security updates

### Update Management
- Automated updates
- Rollback capabilities
- Version control
- Change tracking

## Troubleshooting

### Common Issues

1. **Service won't start**
   - Check Docker network configuration
   - Verify port availability
   - Check resource limits
   - Review service logs

2. **Monitoring not working**
   - Verify Prometheus connectivity
   - Check service endpoints
   - Review firewall rules
   - Validate configuration

3. **Backup failures**
   - Check disk space
   - Verify backup permissions
   - Review backup logs
   - Test backup procedures

4. **Security alerts**
   - Review security logs
   - Check fail2ban status
   - Verify CrowdSec configuration
   - Monitor access patterns

### Debug Commands

```bash
# Check service status
docker-compose -f {{ docker_dir }}/media/docker-compose.yml ps

# View service logs
docker-compose -f {{ docker_dir }}/media/docker-compose.yml logs [service]

# Check health status
{{ config_dir }}/media-health.sh

# Verify backup status
{{ config_dir }}/media-backup-verify.sh

# Check monitoring status
{{ config_dir }}/media-monitor.sh

# Review security status
{{ config_dir }}/media-security-audit.sh
```

### Log Locations

- **Service logs**: `{{ logs_dir }}/media/`
- **Docker logs**: `docker logs [container_name]`
- **System logs**: `/var/log/syslog`
- **Security logs**: `/var/log/fail2ban.log`
- **Backup logs**: `{{ logs_dir }}/media/backup/`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This role is licensed under the MIT License. See LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review troubleshooting guides
- Consult the community forums

## Changelog

### Version 1.0.0
- Initial release
- Complete media stack deployment
- Monitoring integration
- Security hardening
- Backup automation
- Homepage integration
- Alerting system 

## Rollback

- Automatic rollback on failed deploys: The compose deploy wrapper restores last-known-good Compose and the pre-change snapshot automatically on failure.

- Manual rollback (this service or sub-component):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., media, or a specific subdir like jellyfin, sonarr, etc.
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

- Full stack version rollback:
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```

### Secrets & Health Checks

- Secrets directory: each sub-service uses `{{ docker_dir }}/<service>/secrets`.
- Enable file-based secrets per component:
  ```yaml
  media_manage_secret_files: true
  media_required_secrets:
    - <SERVICE_SPECIFIC_KEYS>
  ```
  Follow component roles (e.g., `sonarr`, `radarr`, `jellyfin`) for their `*_secret_files` and required keys. Templates map secret-like env keys to `KEY_FILE=/run/secrets/KEY`. See `docs/SECRETS_CONVENTIONS.md`.

- Post-deploy route health check examples:
  ```yaml
  - ansible.builtin.include_tasks: ../../automation/tasks/route_health_check.yml
    vars:
      route_health_check_url: "https://{{ sonarr_subdomain }}.{{ domain }}/"
      route_health_check_status_codes: [200, 302, 401]
  ```
  See `docs/POST_DEPLOY_SMOKE_TESTS.md`.