# Paperless-ngx Ansible Role

A comprehensive Ansible role for deploying and managing Paperless-ngx document management system in a production homelab environment.

## Overview

This role provides a complete deployment solution for Paperless-ngx, including:

- **Container Deployment**: Docker-based deployment with proper resource management
- **Traefik Integration**: Reverse proxy configuration with SSL/TLS automation
- **Authentication**: Authentik SSO integration or local authentication
- **Monitoring**: Full TIG stack integration (Telegraf/InfluxDB/Grafana + Prometheus)
- **Security**: CrowdSec and Fail2ban protection
- **Backup**: Automated backup strategy with encryption and retention
- **Homepage Integration**: Dashboard integration with health monitoring
- **Alerting**: Comprehensive alerting with multiple notification channels

## Features

### Core Features
- ✅ Document OCR and text extraction
- ✅ Automatic document classification
- ✅ Full-text search capabilities
- ✅ Tag and correspondent management
- ✅ Export and backup functionality
- ✅ Web-based interface
- ✅ REST API access

### Infrastructure Integration
- ✅ Traefik reverse proxy with SSL/TLS
- ✅ Authentik SSO authentication
- ✅ PostgreSQL database backend
- ✅ Redis caching layer
- ✅ Full monitoring stack integration
- ✅ Security protection (CrowdSec + Fail2ban)
- ✅ Automated backups with encryption
- ✅ Homepage dashboard integration
- ✅ Comprehensive alerting system

## Requirements

### System Requirements
- Ubuntu 20.04+ or Debian 11+
- Docker and Docker Compose
- PostgreSQL 12+ (if using external database)
- Redis 6+ (if using external Redis)
- At least 4GB RAM (2GB for Paperless-ngx)
- At least 50GB storage space

### Ansible Requirements
- Ansible 2.12+
- Community Docker collection
- Community PostgreSQL collection

### Dependencies
- Traefik reverse proxy
- PostgreSQL database
- Redis cache
- Monitoring stack (optional)
- Authentik SSO (optional)

## Role Variables

### Basic Configuration
```yaml
# Service Configuration
paperless_ngx_enabled: true
paperless_ngx_version: "latest"
paperless_ngx_image: "ghcr.io/paperless-ngx/paperless-ngx:latest"

# Container Configuration
paperless_ngx_container_name: "paperless-ngx"
paperless_ngx_restart_policy: "unless-stopped"
paperless_ngx_network_mode: "bridge"

# Domain Configuration
paperless_ngx_subdomain: "docs"
paperless_ngx_domain: "{{ paperless_ngx_subdomain }}.{{ domain }}"
```

### Database Configuration
```yaml
# Database Configuration
paperless_ngx_database_type: "postgresql"  # Options: postgresql, sqlite
paperless_ngx_database_host: "{{ postgresql_host | default('postgresql') }}"
paperless_ngx_database_port: "{{ postgresql_port | default(5432) }}"
paperless_ngx_database_name: "paperless"
paperless_ngx_database_user: "paperless"
paperless_ngx_database_password: "{{ lookup('password', '/dev/null length=32 chars=ascii_letters,digits') }}"
```

### Authentication Configuration
```yaml
# Authentication Configuration
paperless_ngx_auth_enabled: true
paperless_ngx_auth_method: "authentik"  # Options: authentik, basic, none
paperless_ngx_admin_email: "{{ admin_email | default('admin@' + domain) }}"
paperless_ngx_admin_password: "{{ lookup('password', '/dev/null length=32 chars=ascii_letters,digits') }}"
```

### OCR Configuration
```yaml
# OCR Configuration
paperless_ngx_ocr_enabled: true
paperless_ngx_ocr_language: "eng"
paperless_ngx_ocr_clean: true
paperless_ngx_ocr_deskew: true
paperless_ngx_ocr_rotate_pages: true
paperless_ngx_ocr_rotate_pages_threshold: 12.0
paperless_ngx_ocr_max_image_pixels: 16777216
paperless_ngx_ocr_output_type: "pdf"
paperless_ngx_ocr_pages: 1
```

### Resource Limits
```yaml
# Resource Limits
paperless_ngx_memory_limit: "2g"
paperless_ngx_cpu_limit: "1.0"
paperless_ngx_storage_limit: "50g"
```

### Backup Configuration
```yaml
# Backup Configuration
paperless_ngx_backup_enabled: true
paperless_ngx_backup_schedule: "0 2 * * *"  # Daily at 2 AM
paperless_ngx_backup_retention: 7  # Keep backups for 7 days
paperless_ngx_backup_compression: true
paperless_ngx_backup_include_media: true
paperless_ngx_backup_include_database: true
```

## Usage

### Basic Usage

1. Include the role in your playbook:
```yaml
- hosts: all
  roles:
    - paperless_ngx
```

2. Set required variables in your inventory or group_vars:
```yaml
# Required variables
domain: "yourdomain.com"
username: "your_username"
puid: 1000
pgid: 1000
```

### Advanced Usage

1. Customize the configuration:
```yaml
# Custom configuration
paperless_ngx_ocr_language: "eng+fra+deu"  # Multiple languages
paperless_ngx_consumer_polling: 5  # Faster polling
paperless_ngx_memory_limit: "4g"  # More memory
paperless_ngx_backup_retention: 30  # Longer retention
```

2. Enable specific features:
```yaml
# Enable specific integrations
paperless_ngx_monitoring_enabled: true
paperless_ngx_alerting_enabled: true
paperless_ngx_homepage_enabled: true
paperless_ngx_crowdsec_enabled: true
paperless_ngx_fail2ban_enabled: true
```

## Directory Structure

```
roles/paperless_ngx/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   ├── main.yml              # Main task file
│   ├── validate.yml          # Configuration validation
│   ├── prerequisites.yml     # Prerequisites setup
│   ├── deploy.yml            # Service deployment
│   ├── monitoring.yml        # Monitoring integration
│   ├── security.yml          # Security configuration
│   ├── backup.yml            # Backup configuration
│   ├── homepage.yml          # Homepage integration
│   ├── alerts.yml            # Alerting configuration
│   └── validate_deployment.yml # Final validation
├── templates/
│   ├── docker-compose.yml.j2 # Docker Compose template
│   ├── env.j2               # Environment file template
│   └── ...                  # Other configuration templates
├── handlers/
│   └── main.yml             # Service handlers
└── README.md                # This file
```

## Data Locations

### Default Data Directories
- **Documents**: `{{ data_dir }}/paperless-ngx/documents`
- **Consume**: `{{ data_dir }}/paperless-ngx/consume`
- **Export**: `{{ docker_dir }}/paperless-ngx/export`
- **Backup**: `{{ backup_dir }}/paperless-ngx`
- **Logs**: `{{ logs_dir }}/paperless-ngx`

### Configuration Files
- **Docker Compose**: `{{ docker_dir }}/paperless-ngx/docker-compose.yml`
- **Environment**: `{{ docker_dir }}/paperless-ngx/.env`
- **Nginx Config**: `{{ config_dir }}/paperless-ngx/nginx/nginx.conf`

## Monitoring

### Metrics
- Container health and resource usage
- Document processing statistics
- OCR performance metrics
- API response times
- Database connection status

### Logs
- Application logs: `{{ logs_dir }}/paperless-ngx/application/`
- Nginx logs: `{{ logs_dir }}/paperless-ngx/nginx/`
- OCR logs: `{{ logs_dir }}/paperless-ngx/ocr/`

### Dashboards
- Grafana dashboard: `https://{{ grafana_subdomain }}.{{ domain }}/d/paperless-ngx`
- Prometheus targets: `https://{{ prometheus_subdomain }}.{{ domain }}/targets`
- Loki logs: `https://{{ loki_subdomain }}.{{ domain }}/explore`

## Security

### Authentication
- **Authentik SSO**: Recommended for production
- **Local Authentication**: For simple setups
- **API Tokens**: For programmatic access

### Protection
- **CrowdSec**: Real-time threat detection
- **Fail2ban**: Brute force protection
- **Rate Limiting**: API and web interface protection
- **SSL/TLS**: Automatic certificate management

### Access Control
- IP whitelisting (optional)
- Role-based access control
- API rate limiting
- Session management

## Backup and Recovery

### Backup Strategy
- **Daily Backups**: Full system backup
- **Weekly Backups**: Compressed archives
- **Monthly Backups**: Long-term retention
- **Encryption**: AES-256 encryption for sensitive data

### Backup Components
- Database (PostgreSQL dump)
- Media files (documents, thumbnails)
- Configuration files
- Log files

### Recovery Procedures
1. Stop the service
2. Restore database
3. Restore media files
4. Restore configuration
5. Start the service
6. Verify functionality

## Troubleshooting

### Common Issues

1. **Container won't start**
   - Check resource limits
   - Verify database connectivity
   - Check log files

2. **OCR not working**
   - Verify OCR language configuration
   - Check container capabilities
   - Monitor OCR logs

3. **Authentication issues**
   - Verify Authentik configuration
   - Check API tokens
   - Review authentication logs

4. **Performance issues**
   - Monitor resource usage
   - Adjust memory/CPU limits
   - Optimize database queries

### Log Locations
- **Container logs**: `docker logs {{ paperless_ngx_container_name }}`
- **Application logs**: `{{ logs_dir }}/paperless-ngx/application/`
- **Nginx logs**: `{{ logs_dir }}/paperless-ngx/nginx/`
- **OCR logs**: `{{ logs_dir }}/paperless-ngx/ocr/`

### Health Checks
- **Web interface**: `https://{{ paperless_ngx_domain }}`
- **Health endpoint**: `https://{{ paperless_ngx_domain }}/api/health/`
- **API endpoint**: `https://{{ paperless_ngx_domain }}/api/`

## Tags

The role supports the following tags for selective execution:

- `paperless-ngx`: All tasks
- `validation`: Configuration and deployment validation
- `setup`: Prerequisites and setup tasks
- `deploy`: Service deployment
- `monitoring`: Monitoring integration
- `security`: Security configuration
- `backup`: Backup configuration
- `homepage`: Homepage integration
- `alerts`: Alerting configuration

### Example Usage with Tags
```bash
# Deploy only the service
ansible-playbook playbook.yml --tags "paperless-ngx,deploy"

# Configure only monitoring
ansible-playbook playbook.yml --tags "paperless-ngx,monitoring"

# Full deployment with validation
ansible-playbook playbook.yml --tags "paperless-ngx"
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This role is licensed under the MIT License. See the LICENSE file for details.

## Support

For support and questions:
- Check the troubleshooting section
- Review the logs and monitoring
- Consult the Paperless-ngx documentation
- Open an issue on the repository

## Changelog

### Version 1.0.0
- Initial release
- Complete deployment automation
- Full monitoring integration
- Security hardening
- Backup and recovery procedures
- Homepage integration
- Comprehensive alerting 