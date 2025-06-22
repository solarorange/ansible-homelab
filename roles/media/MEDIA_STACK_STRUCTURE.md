# Media Stack Role Structure

This document outlines the complete structure of the Media Stack role, which has been migrated from the monolithic `tasks/media_stack.yml` file to a modular, production-ready Ansible role.

## Role Overview

The Media Stack role provides a comprehensive solution for deploying and managing a complete media management ecosystem in a homelab environment. It follows the same patterns as the existing `roles/paperless_ngx/` role and integrates seamlessly with the monitoring, security, backup, and homepage infrastructure.

## Directory Structure

```
roles/media/
├── defaults/
│   └── main.yml                    # Comprehensive configuration defaults
├── handlers/
│   └── main.yml                    # Service restart and reload handlers
├── tasks/
│   ├── main.yml                    # Main orchestration tasks
│   ├── validate.yml                # Pre-deployment validation
│   ├── prerequisites.yml           # Setup and prerequisites
│   ├── downloaders.yml             # Deploy downloaders (SABnzbd, qBittorrent)
│   ├── arr_services.yml            # Deploy ARR services (Sonarr, Radarr, etc.)
│   ├── players.yml                 # Deploy media players (Jellyfin, Immich)
│   ├── monitoring.yml              # Configure monitoring integration
│   ├── security.yml                # Configure security hardening
│   ├── backup.yml                  # Configure backup procedures
│   ├── homepage.yml                # Configure homepage integration
│   ├── alerts.yml                  # Configure alerting and notifications
│   └── validate_deployment.yml     # Post-deployment validation
├── downloaders/                    # Sub-role for downloaders
│   └── tasks/
│       └── main.yml                # Downloader-specific tasks
├── arr_services/                   # Sub-role for ARR services
│   └── tasks/
│       └── main.yml                # ARR service-specific tasks
├── players/                        # Sub-role for media players
│   └── tasks/
│       └── main.yml                # Player-specific tasks
├── templates/                      # Jinja2 templates (to be created)
├── README.md                       # Comprehensive documentation
└── MEDIA_STACK_STRUCTURE.md        # This file
```

## Services Deployed

### Downloaders
- **SABnzbd** (Port 8080) - Usenet downloader
- **qBittorrent** (Port 8081) - Torrent client

### ARR Services
- **Prowlarr** (Port 9696) - Indexer management
- **Sonarr** (Port 8989) - TV show management
- **Radarr** (Port 7878) - Movie management
- **Lidarr** (Port 8686) - Music management
- **Readarr** (Port 8787) - Book management
- **Bazarr** (Port 6767) - Subtitle management
- **Pulsarr** (Port 8088) - ARR service status dashboard

### Media Players
- **Jellyfin** (Port 8096) - Media server
- **Immich** (Ports 3000-3003) - Photo management with PostgreSQL and Redis

## Key Features

### Modular Design
- Separate deployment of downloaders, ARR services, and players
- Individual service enablement/disablement
- Granular configuration control
- Tagged execution for selective deployment

### Comprehensive Monitoring
- Prometheus metrics collection
- Grafana dashboard integration
- Loki log aggregation
- Telegraf system metrics
- Health check automation

### Security Hardening
- Fail2ban integration
- CrowdSec protection
- SSL/TLS configuration
- Rate limiting
- Security headers
- Access control

### Automated Backup
- Daily scheduled backups
- Configurable retention policies
- Compression and encryption
- Verification and recovery procedures
- Disaster recovery planning

### Homepage Integration
- Automatic service discovery
- Custom widgets and bookmarks
- Service status monitoring
- Quick access links

### Alerting System
- Multi-channel notifications (email, Slack, Discord, webhooks)
- Prometheus alerting rules
- AlertManager integration
- Custom alert thresholds

## Configuration Variables

The role uses a comprehensive set of variables defined in `defaults/main.yml`:

### Main Configuration
```yaml
media_enabled: true
media_downloaders_enabled: true
media_arr_services_enabled: true
media_players_enabled: true
```

### Service Configuration
```yaml
media_downloaders:
  sabnzbd:
    enabled: true
    image: "linuxserver/sabnzbd:latest"
    port: 8080
    subdomain: "sabnzbd"
    # ... detailed configuration

media_arr_services:
  sonarr:
    enabled: true
    image: "linuxserver/sonarr:latest"
    port: 8989
    subdomain: "sonarr"
    # ... detailed configuration

media_players:
  jellyfin:
    enabled: true
    image: "jellyfin/jellyfin:latest"
    port: 8096
    subdomain: "jellyfin"
    # ... detailed configuration
```

### Integration Configuration
```yaml
# Monitoring
media_monitoring_enabled: true
media_grafana_enabled: true
media_prometheus_enabled: true
media_loki_enabled: true

# Security
media_security_headers: true
media_rate_limiting: true
media_crowdsec_enabled: true
media_fail2ban_enabled: true

# Backup
media_backup_enabled: true
media_backup_schedule: "0 2 * * *"
media_backup_retention: 7

# Homepage
media_homepage_enabled: true
media_homepage_category: "Media"

# Alerting
media_alerting_enabled: true
media_notifications_enabled: true
```

## Usage Examples

### Basic Deployment
```yaml
# In your playbook
- hosts: media_servers
  roles:
    - media
```

### Selective Deployment
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
```

### Custom Configuration
```yaml
# In your playbook with custom settings
- hosts: media_servers
  vars:
    media_enabled: true
    media_downloaders:
      sabnzbd:
        enabled: true
        port: 8080
      qbittorrent:
        enabled: false  # Disable qBittorrent
    
    media_backup_schedule: "0 3 * * *"  # 3 AM instead of 2 AM
    media_monitoring_enabled: true
    
  roles:
    - media
```

## Migration from tasks/media_stack.yml

### What's Changed
1. **Modular Structure**: Split into logical components (downloaders, ARR services, players)
2. **Enhanced Configuration**: Comprehensive variable system with sensible defaults
3. **Better Integration**: Seamless integration with existing monitoring, security, and backup infrastructure
4. **Improved Validation**: Pre and post-deployment validation with detailed error reporting
5. **Tagged Execution**: Selective deployment and configuration options
6. **Production Ready**: Error handling, recovery procedures, and comprehensive logging

### Migration Steps
1. **Backup Current Configuration**
   ```bash
   cp tasks/media_stack.yml tasks/media_stack.yml.backup
   ```

2. **Update Playbook**
   ```yaml
   # Replace the include_tasks call with role inclusion
   - hosts: media_servers
     roles:
       - media
   ```

3. **Configure Variables**
   ```yaml
   # Add any custom configuration to group_vars or host_vars
   media_downloaders:
     sabnzbd:
       enabled: true
     qbittorrent:
       enabled: true
   ```

4. **Test Deployment**
   ```bash
   # Test with validation only
   ansible-playbook site.yml --tags "media,validation"
   
   # Deploy with dry-run
   ansible-playbook site.yml --tags "media" --check
   ```

### Benefits of Migration
1. **Maintainability**: Easier to maintain and update individual components
2. **Reusability**: Role can be used across different environments
3. **Flexibility**: Granular control over service deployment
4. **Integration**: Better integration with existing infrastructure
5. **Documentation**: Comprehensive documentation and examples
6. **Testing**: Built-in validation and health checks

## Integration Points

### Monitoring Stack
- Prometheus targets automatically configured
- Grafana dashboards created
- Loki log aggregation set up
- Telegraf metrics collection enabled

### Security Infrastructure
- Fail2ban rules configured
- CrowdSec collections enabled
- SSL/TLS certificates managed
- Access control integrated

### Backup System
- Automated backup schedules
- Retention policies applied
- Verification procedures
- Recovery scripts created

### Homepage Dashboard
- Service entries automatically created
- Status monitoring configured
- Quick access links set up
- Custom widgets available

## Next Steps

### Immediate Actions
1. Create the `templates/` directory with all required Jinja2 templates
2. Test the role in a development environment
3. Update the main playbook to use the new role
4. Configure custom variables as needed

### Future Enhancements
1. Add more media services (Plex, Emby, etc.)
2. Implement advanced transcoding configurations
3. Add more monitoring dashboards
4. Enhance security features
5. Improve backup strategies

### Documentation
1. Complete the README.md with usage examples
2. Create troubleshooting guides
3. Add configuration examples
4. Document integration procedures

## Support and Maintenance

### Regular Maintenance
- Monitor service health and performance
- Review and update security configurations
- Verify backup integrity
- Update service versions as needed

### Troubleshooting
- Check service logs in `{{ logs_dir }}/media/`
- Use health check scripts in `{{ config_dir }}/`
- Review monitoring dashboards
- Consult the comprehensive README.md

### Updates
- Follow semantic versioning for role updates
- Test changes in development environment
- Maintain backward compatibility
- Document all changes in changelog

This modular approach provides a robust, maintainable, and scalable solution for media stack deployment that integrates seamlessly with your existing homelab infrastructure. 