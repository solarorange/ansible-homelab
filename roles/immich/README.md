# Immich Role

A production-ready Ansible role for deploying and managing Immich photo management system in a homelab environment.

## Overview

Immich is a high-performance self-hosted photo and video backup solution. This role provides a complete deployment solution with monitoring, backup, security, and integration capabilities.

## Features

- **Complete Service Stack**: Deploys all Immich components (server, web, database, Redis, machine learning)
- **Production Ready**: Includes health checks, resource limits, and proper networking
- **Security Integration**: Traefik integration with SSL/TLS, authentication, and security headers
- **Monitoring**: Prometheus metrics, Grafana dashboards, and health monitoring
- **Backup System**: Automated backup and restore capabilities
- **Homepage Integration**: Seamless integration with Homepage dashboard
- **Alerting**: Comprehensive alerting system with multiple notification channels
- **Logging**: Structured logging with Loki integration
- **High Availability**: Proper service dependencies and restart policies

## Components

### Core Services
- **Immich Server**: Main API server (port 3001)
- **Immich Web**: Web interface (port 3000)
- **PostgreSQL**: Database for metadata (port 5432)
- **Redis**: Caching and session storage (port 6379)
- **Machine Learning**: AI-powered features (port 3003)

### Supporting Services
- **Traefik**: Reverse proxy and SSL termination
- **Monitoring**: Prometheus, Grafana, Loki
- **Backup**: Automated backup system
- **Security**: CrowdSec, Fail2ban integration

## Requirements

### System Requirements
- Docker and Docker Compose
- PostgreSQL 14+ (or use included container)
- Redis (or use included container)
- Minimum 4GB RAM (8GB recommended)
- 50GB+ storage for photos and metadata

### Ansible Requirements
- Ansible 2.12+
- `community.docker` collection
- `ansible.posix` collection
- `community.general` collection

## Role Variables

### Basic Configuration
```yaml
# Enable/disable the service
immich_enabled: true

# Service version
immich_version: "latest"

# Network configuration
immich_network_name: "immich"
immich_network_external: true

# Domain configuration
immich_subdomain: "immich"
```

### Database Configuration
```yaml
# Database settings
immich_database_type: "postgresql"
immich_database_host: "immich-postgres"
immich_database_port: 5432
immich_database_name: "immich"
immich_database_user: "postgres"
immich_database_password: "{{ vault_immich_postgres_password }}"
```

### Redis Configuration
```yaml
# Redis settings
immich_redis_host: "immich-redis"
immich_redis_port: 6379
immich_redis_password: "{{ vault_immich_redis_password }}"
immich_redis_db: 0
```

### Security Configuration
```yaml
# Authentication
immich_auth_enabled: true
immich_auth_method: "authentik"

# Security features
immich_security_headers: true
immich_rate_limiting: true
immich_rate_limit_requests: 100
immich_rate_limit_window: 60
```

### Monitoring Configuration
```yaml
# Monitoring features
immich_monitoring_enabled: true
immich_metrics_enabled: true
immich_health_check_enabled: true
immich_health_check_interval: 30

# Prometheus integration
immich_prometheus_enabled: true
immich_prometheus_metrics: true
immich_prometheus_scrape_interval: 30
```

### Backup Configuration
```yaml
# Backup settings
immich_backup_enabled: true
immich_backup_schedule: "0 2 * * *"  # Daily at 2 AM
immich_backup_retention: 7
immich_backup_compression: true
immich_backup_include_photos: true
immich_backup_include_database: true
immich_backup_include_config: true
```

### Homepage Integration
```yaml
# Homepage integration
immich_homepage_enabled: true
immich_homepage_category: "Media"
immich_homepage_description: "Photo Management & Sharing"
immich_homepage_icon: "immich.png"
immich_homepage_widget_enabled: true
```

## Dependencies

### Required Vault Variables
```yaml
# Database passwords
vault_immich_postgres_password: "secure_password"
vault_immich_redis_password: "secure_password"

# JWT secret
vault_immich_jwt_secret: "secure_jwt_secret"

# Admin password (optional)
vault_immich_admin_password: "admin_password"
```

### Service Dependencies
- Docker
- Traefik (for reverse proxy)
- Monitoring infrastructure (optional)
- Authentik (for authentication)

## Usage

### Basic Deployment
```yaml
# In your playbook
- hosts: homelab
  roles:
    - immich
```

### With Custom Configuration
```yaml
# In your playbook with custom variables
- hosts: homelab
  vars:
    immich_subdomain: "photos"
    immich_backup_schedule: "0 3 * * *"  # 3 AM instead of 2 AM
    immich_homepage_category: "Photos"
  roles:
    - immich
```

### Tags Usage
```bash
# Deploy only Immich
ansible-playbook site.yml --tags immich

# Deploy with monitoring
ansible-playbook site.yml --tags "immich,monitoring"

# Deploy with backup
ansible-playbook site.yml --tags "immich,backup"

# Validate deployment
ansible-playbook site.yml --tags "immich,validation"
```

## File Structure

```
roles/immich/
├── defaults/
│   └── main.yml          # Default variables
├── tasks/
│   ├── main.yml          # Main task file
│   ├── validate.yml      # Configuration validation
│   ├── prerequisites.yml # System setup
│   ├── deploy.yml        # Service deployment
│   ├── monitoring.yml    # Monitoring setup
│   ├── security.yml      # Security configuration
│   ├── backup.yml        # Backup setup
│   ├── homepage.yml      # Homepage integration
│   ├── alerts.yml        # Alerting setup
│   └── validate_deployment.yml # Deployment validation
├── templates/
│   ├── docker-compose.yml.j2  # Docker Compose template
│   ├── env.j2                 # Environment variables
│   ├── traefik.yml.j2         # Traefik configuration
│   └── ...                    # Other templates
├── handlers/
│   └── main.yml          # Service handlers
└── README.md             # This file
```

## Access Information

After deployment, Immich will be available at:
- **Web Interface**: `https://immich.yourdomain.com`
- **API**: `https://immich.yourdomain.com/api`
- **Health Check**: `https://immich.yourdomain.com/api/health`

### Default Credentials
- **Email**: `admin@yourdomain.com`
- **Password**: Set in vault or use default

## Monitoring

### Health Checks
- Service health endpoints
- Database connectivity
- Redis connectivity
- Container status monitoring

### Metrics
- Prometheus metrics available at `/metrics`
- Grafana dashboard included
- Custom alerting rules

### Logs
- Structured JSON logging
- Loki integration for log aggregation
- Log rotation and retention

## Backup and Recovery

### Automated Backups
- Daily backups at 2 AM (configurable)
- Database and configuration backup
- Photo backup (optional)
- 7-day retention (configurable)

### Manual Backup
```bash
# Create manual backup
sudo systemctl start immich-backup

# Verify backup
sudo systemctl start immich-backup-verify
```

### Restore Process
```bash
# Stop services
docker-compose -f /opt/docker/immich/docker-compose.yml down

# Restore from backup
sudo /opt/docker/immich/restore.sh

# Start services
docker-compose -f /opt/docker/immich/docker-compose.yml up -d
```

## Security Features

### Network Security
- Traefik reverse proxy with SSL/TLS
- Rate limiting and DDoS protection
- Security headers
- CORS configuration

### Authentication
- Authentik integration
- JWT token management
- Session management
- Access control

### Monitoring
- CrowdSec integration
- Fail2ban rules
- Security audit logging
- Intrusion detection

## Troubleshooting

### Common Issues

#### Service Not Starting
```bash
# Check container logs
docker logs immich-server
docker logs immich-web
docker logs immich-postgres
docker logs immich-redis

# Check service status
docker-compose -f /opt/docker/immich/docker-compose.yml ps
```

#### Database Connection Issues
```bash
# Test database connectivity
docker exec immich-postgres pg_isready -U postgres -d immich

# Check database logs
docker logs immich-postgres
```

#### Health Check Failures
```bash
# Check health endpoint
curl -f http://localhost:3001/api/health

# Check service logs
journalctl -u immich-monitoring -f
```

### Log Locations
- **Application Logs**: `/opt/logs/immich/`
- **System Logs**: `journalctl -u immich-*`
- **Backup Logs**: `/opt/logs/immich/backup/`
- **Health Logs**: `/opt/logs/immich/health/`

### Performance Tuning
```yaml
# Resource limits
immich_memory_limit: "8g"
immich_cpu_limit: "4.0"
immich_storage_limit: "500g"

# Cache configuration
immich_cache_enabled: true
immich_cache_size: "1g"
immich_cache_ttl: 3600
```

## Maintenance

### Updates
```bash
# Update images
docker-compose -f /opt/docker/immich/docker-compose.yml pull

# Restart services
docker-compose -f /opt/docker/immich/docker-compose.yml up -d
```

### Maintenance Tasks
- Database optimization
- Log cleanup
- Cache clearing
- Index rebuilding

### Scheduled Maintenance
- Weekly maintenance window (configurable)
- Automated cleanup tasks
- Performance optimization

## Integration Points

### Homepage
- Service status widget
- Quick access links
- Service metrics

### Monitoring Stack
- Prometheus metrics scraping
- Grafana dashboards
- AlertManager integration

### Security Stack
- Traefik integration
- Authentik authentication
- CrowdSec protection

### Backup Stack
- Automated backup scheduling
- Backup verification
- Retention management

## Contributing

1. Follow the existing code structure
2. Add appropriate tests
3. Update documentation
4. Follow security best practices

## License

This role is part of the Ansible Homelab project and follows the same licensing terms.

## Support

For issues and questions:
- Check the troubleshooting section
- Review logs and health checks
- Consult the Immich documentation
- Open an issue in the project repository 