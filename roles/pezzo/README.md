# Pezzo Role

## Overview

The Pezzo role provides a complete deployment solution for [Pezzo](https://github.com/pezzolabs/pezzo), an open-source AI prompt management and analytics platform. This role automates the deployment, configuration, monitoring, and maintenance of Pezzo services in a production-ready homelab environment.

## Features

### Core Services
- **Pezzo Server**: Main API server for prompt management
- **Pezzo Console**: Web-based user interface
- **Pezzo Proxy**: API proxy service
- **PostgreSQL**: Primary database for application data
- **Redis**: Caching and session storage
- **ClickHouse**: Analytics and metrics database
- **SuperTokens**: Authentication and user management
- **Local KMS**: Key management service

### Production Features
- **Docker Compose**: Containerized deployment with proper networking
- **Traefik Integration**: Reverse proxy with SSL/TLS termination
- **Health Checks**: Comprehensive health monitoring for all services
- **Resource Limits**: CPU and memory constraints for optimal performance
- **Logging**: Structured logging with rotation and retention
- **Backup**: Automated database and configuration backups
- **Monitoring**: Prometheus metrics, Grafana dashboards, and Loki logs
- **Security**: CrowdSec, Fail2ban, rate limiting, and security headers
- **Homepage Integration**: Dashboard integration with status monitoring
- **Alerting**: Comprehensive alerting with AlertManager
- **Systemd Service**: System service management with auto-restart

## Requirements

### Ansible
- Ansible 2.12+
- Python 3.8+
- Docker and Docker Compose
- Required collections:
  - `community.docker`
  - `community.general`
  - `ansible.posix`
  - `community.crypto`

### System Requirements
- Linux distribution with systemd
- Docker Engine 20.10+
- Docker Compose 2.0+
- Minimum 4GB RAM
- Minimum 20GB storage
- Network access for Docker image pulls

### Dependencies
- Traefik (for reverse proxy)
- Monitoring stack (Prometheus, Grafana, Loki)
- Authentication provider (Authentik recommended)

## Role Variables

### Basic Configuration
```yaml
# Service Configuration
pezzo_enabled: true
pezzo_version: "latest"
pezzo_subdomain: "pezzo"

# Container Configuration
pezzo_container_restart_policy: "unless-stopped"
pezzo_network_name: "pezzo"
pezzo_network_external: true
```

### Port Configuration
```yaml
# Port Configuration
pezzo_server_port: 3000
pezzo_console_port: 4200
pezzo_proxy_port: 3001
```

### Database Configuration
```yaml
# Database Configuration
pezzo_database_type: "postgresql"
pezzo_database_host: "pezzo-postgres"
pezzo_database_port: 5432
pezzo_database_name: "pezzo"
pezzo_database_user: "postgres"
pezzo_database_password: "{{ vault_pezzo_postgres_password }}"
```

### Redis Configuration
```yaml
# Redis Configuration
pezzo_redis_host: "pezzo-redis"
pezzo_redis_port: 6379
pezzo_redis_password: "{{ vault_pezzo_redis_password }}"
pezzo_redis_db: 0
```

### ClickHouse Configuration
```yaml
# ClickHouse Configuration
pezzo_clickhouse_host: "pezzo-clickhouse"
pezzo_clickhouse_port: 8123
pezzo_clickhouse_user: "default"
pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password }}"
```

### Authentication Configuration
```yaml
# Authentication Configuration
pezzo_auth_enabled: true
pezzo_auth_method: "authentik"  # Options: authentik, basic, none
pezzo_admin_email: "{{ admin_email }}"
```

### Monitoring Configuration
```yaml
# Monitoring Configuration
pezzo_monitoring_enabled: true
pezzo_prometheus_enabled: true
pezzo_grafana_enabled: true
pezzo_loki_enabled: true
pezzo_telegraf_enabled: true
```

### Security Configuration
```yaml
# Security Configuration
pezzo_security_headers: true
pezzo_rate_limiting: true
pezzo_rate_limit_requests: 100
pezzo_rate_limit_window: 60
pezzo_cors_enabled: false
pezzo_crowdsec_enabled: true
pezzo_fail2ban_enabled: true
```

### Backup Configuration
```yaml
# Backup Configuration
pezzo_backup_enabled: true
pezzo_backup_schedule: "0 3 * * *"  # Daily at 3 AM
pezzo_backup_retention: 7  # Days
pezzo_backup_compression: true
pezzo_backup_include_database: true
pezzo_backup_include_config: true
```

### Homepage Integration
```yaml
# Homepage Integration
pezzo_homepage_enabled: true
pezzo_homepage_category: "AI & Development"
pezzo_homepage_description: "AI Prompt Management & Analytics Platform"
pezzo_homepage_icon: "pezzo.png"
pezzo_homepage_widget_enabled: true
```

### Alerting Configuration
```yaml
# Alerting Configuration
pezzo_alerting_enabled: true
pezzo_alerting_provider: "alertmanager"
pezzo_alerting_webhook: "http://alertmanager:9093/api/v1/alerts"
```

### Resource Limits
```yaml
# Resource Limits
pezzo_memory_limit: "4g"
pezzo_cpu_limit: "2.0"
pezzo_storage_limit: "100g"
```

## Usage

### Basic Deployment
```yaml
# In your playbook
- hosts: homelab
  roles:
    - pezzo
```

### With Custom Configuration
```yaml
# In your playbook with custom variables
- hosts: homelab
  vars:
    pezzo_subdomain: "ai-platform"
    pezzo_homepage_category: "AI Tools"
    pezzo_backup_schedule: "0 2 * * *"
  roles:
    - pezzo
```

### Conditional Deployment
```yaml
# Deploy only if enabled
- hosts: homelab
  roles:
    - role: pezzo
      when: pezzo_enabled | default(true)
```

## Directory Structure

```
roles/pezzo/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   ├── main.yml              # Main task file
│   ├── validate.yml          # Configuration validation
│   ├── prerequisites.yml     # Setup prerequisites
│   ├── deploy.yml            # Service deployment
│   ├── monitoring.yml        # Monitoring configuration
│   ├── security.yml          # Security configuration
│   ├── backup.yml            # Backup configuration
│   ├── homepage.yml          # Homepage integration
│   ├── alerts.yml            # Alerting configuration
│   └── validate_deployment.yml # Deployment validation
├── templates/
│   ├── docker-compose.yml.j2 # Docker Compose template
│   ├── env.j2                # Environment variables
│   ├── pezzo.service.j2      # Systemd service
│   └── ...                   # Other configuration templates
├── handlers/
│   └── main.yml              # Service handlers
├── vars/
│   └── main.yml              # Role-specific variables
└── README.md                 # This file
```

## Service Architecture

### Network Layout
```
Internet
    ↓
Traefik (Reverse Proxy)
    ↓
Pezzo Services:
├── Pezzo Server (API)
├── Pezzo Console (UI)
├── Pezzo Proxy
├── PostgreSQL (Database)
├── Redis (Cache)
├── ClickHouse (Analytics)
├── SuperTokens (Auth)
└── Local KMS (Keys)
```

### Service Dependencies
```
Pezzo Console
    ↓
Pezzo Server
    ↓
├── PostgreSQL
├── Redis
├── ClickHouse
├── SuperTokens
└── Local KMS
```

## Monitoring

### Metrics Collection
- **Prometheus**: Application metrics, database metrics, system metrics
- **Grafana**: Pre-configured dashboards for Pezzo services
- **Loki**: Centralized log aggregation and querying
- **Telegraf**: System and container metrics collection

### Health Checks
- Container health checks for all services
- API endpoint health monitoring
- Database connectivity verification
- Service dependency validation

### Logging
- Structured JSON logging
- Log rotation and retention
- Centralized log collection
- Log level configuration

## Security

### Authentication
- SuperTokens integration for user management
- Authentik SSO integration
- Basic authentication fallback
- JWT token management

### Network Security
- Traefik reverse proxy with SSL/TLS
- Rate limiting and DDoS protection
- Security headers (HSTS, CSP, etc.)
- CORS configuration

### Access Control
- CrowdSec threat intelligence
- Fail2ban intrusion prevention
- IP whitelisting/blacklisting
- API key management

## Backup and Recovery

### Automated Backups
- Daily database backups
- Configuration file backups
- Compressed backup storage
- Backup verification and testing

### Backup Retention
- Configurable retention periods
- Automated cleanup of old backups
- Backup integrity verification
- Cross-system backup validation

### Disaster Recovery
- Complete system restore procedures
- Database recovery scripts
- Configuration restoration
- Service recovery validation

## Maintenance

### Updates
- Automated Docker image updates
- Configuration migration handling
- Database schema updates
- Service restart coordination

### Health Monitoring
- Continuous health checks
- Performance monitoring
- Resource usage tracking
- Alert generation

### Troubleshooting
- Comprehensive logging
- Debug mode configuration
- Service status monitoring
- Error recovery procedures

## Integration Points

### Traefik Integration
- Automatic SSL certificate management
- Load balancing and failover
- Request routing and middleware
- Health check integration

### Homepage Integration
- Service status monitoring
- Quick access links
- Service metrics display
- Configuration management

### Monitoring Stack Integration
- Prometheus metrics scraping
- Grafana dashboard provisioning
- Loki log aggregation
- AlertManager notification routing

## Troubleshooting

### Common Issues

#### Service Won't Start
1. Check Docker service status: `systemctl status docker`
2. Verify network connectivity: `docker network ls`
3. Check container logs: `docker logs pezzo-server`
4. Validate configuration: `{{ pezzo_config_dir }}/verify_service.sh`

#### Database Connection Issues
1. Verify PostgreSQL container: `docker ps | grep pezzo-postgres`
2. Check database logs: `docker logs pezzo-postgres`
3. Test connectivity: `docker exec pezzo-postgres pg_isready`
4. Verify credentials in environment file

#### Authentication Problems
1. Check SuperTokens container: `docker ps | grep pezzo-supertokens`
2. Verify SuperTokens logs: `docker logs pezzo-supertokens`
3. Check authentication configuration
4. Validate JWT tokens

#### Performance Issues
1. Monitor resource usage: `docker stats`
2. Check log levels and verbosity
3. Review resource limits configuration
4. Analyze Prometheus metrics

### Debug Mode
Enable debug logging by setting:
```yaml
pezzo_log_level: "debug"
```

### Log Locations
- Application logs: `{{ logs_dir }}/pezzo/`
- Docker logs: `docker logs <container-name>`
- System logs: `journalctl -u pezzo`

## Development

### Local Development
1. Clone the role repository
2. Install dependencies: `ansible-galaxy install -r requirements.yml`
3. Configure variables in `group_vars/`
4. Run playbook: `ansible-playbook -i inventory site.yml`

### Testing
- Validate configuration: `ansible-playbook --syntax-check site.yml`
- Test deployment: `ansible-playbook --check site.yml`
- Run specific tags: `ansible-playbook --tags pezzo site.yml`

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make changes and test thoroughly
4. Submit a pull request with documentation

## License

This role is licensed under the MIT License. See the LICENSE file for details.

## Support

### Documentation
- [Pezzo Official Documentation](https://docs.pezzo.ai/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Documentation](https://docs.docker.com/)

### Community
- [Pezzo GitHub Repository](https://github.com/pezzolabs/pezzo)
- [Ansible Community](https://docs.ansible.com/ansible/latest/community/)
- [Homelab Community](https://www.reddit.com/r/homelab/)

### Issues
- Report bugs via GitHub Issues
- Request features through GitHub Discussions
- Contribute improvements via Pull Requests

## Changelog

### Version 1.0.0
- Initial release
- Complete Pezzo deployment automation
- Production-ready configuration
- Comprehensive monitoring and security
- Backup and recovery functionality
- Homepage integration
- Alerting system 