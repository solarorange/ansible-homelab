# Homepage Quick Deployment Guide

This guide provides a quick start for deploying the Homepage automation system.

## Prerequisites

- Ansible 2.9+
- Docker and Docker Compose
- Python 3.6+
- Domain name with DNS configured
- Traefik reverse proxy (deployed by security role)

## Quick Start

### 1. Configure Environment Variables

Add to your `group_vars/all/vault.yml`:

```yaml
# Homepage Configuration
homepage_enabled: true
homepage_subdomain: "homepage"
homepage_theme: "dark"
homepage_language: "en"
homepage_timezone: "America/New_York"

# Weather Configuration (optional)
weather_lat: "40.7128"
weather_lon: "-74.0060"
weather_api_key: "your_openweathermap_api_key"

# API Configuration
vault_homepage_api_secret: "your_api_secret_here"
```

### 2. Deploy Homepage

```bash
# Deploy Homepage with all services
ansible-playbook site.yml --tags homepage

# Or deploy specific components
ansible-playbook site.yml --tags homepage,homepage-deploy
ansible-playbook site.yml --tags homepage,homepage-config
```

### 3. Access Homepage

- **URL**: https://homepage.your-domain.com
- **Local URL**: http://localhost:3000

## Configuration

### Service API Keys

Update service API keys in `group_vars/all/vault.yml`:

```yaml
# Service API Keys
vault_grafana_api_key: "your_grafana_api_key"
vault_sonarr_api_key: "your_sonarr_api_key"
vault_radarr_api_key: "your_radarr_api_key"
vault_jellyfin_api_key: "your_jellyfin_api_key"
# ... add more as needed
```

### Customize Services

Edit `roles/homepage/templates/services.yml.j2` to:
- Add new services
- Modify service URLs
- Change service groups
- Update descriptions

### Customize Bookmarks

Edit `roles/homepage/templates/bookmarks.yml.j2` to:
- Add new bookmark categories
- Modify bookmark URLs
- Organize bookmarks differently

## Management

### Basic Commands

```bash
# Navigate to Homepage directory
cd /opt/docker/homepage

# Show status
./scripts/manage.sh status

# View logs
./scripts/manage.sh logs -f

# Restart services
./scripts/manage.sh restart

# Health check
./scripts/manage.sh health
```

### Backup and Recovery

```bash
# Create backup
./scripts/manage.sh backup

# Restore from backup
./scripts/manage.sh restore /path/to/backup.tar.gz
```

### Update Homepage

```bash
# Update to latest version
./scripts/manage.sh update
```

## Troubleshooting

### Common Issues

#### Homepage Not Accessible
```bash
# Check container status
docker ps | grep homepage

# Check logs
docker logs homepage

# Test local access
curl -I http://localhost:3000
```

#### Widgets Not Working
```bash
# Check API keys
grep -r "your_api_key" /opt/docker/homepage/config/

# Test API endpoints
./scripts/manage.sh api
```

#### Configuration Issues
```bash
# Validate configuration
./scripts/manage.sh config

# Check configuration files
ls -la /opt/docker/homepage/config/
```

### Log Files

- **Application Logs**: `/opt/logs/homepage/`
- **Backup Logs**: `/opt/logs/homepage/backup.log`
- **Health Check Logs**: `/opt/logs/homepage/healthcheck.log`

## Customization

### Adding New Services

1. Add to `roles/homepage/templates/services.yml.j2`:
```yaml
- NewService:
    icon: newservice.png
    href: https://newservice.{{ domain }}
    description: New Service Description
    group: Infrastructure
    widget:
      type: newservice
      url: http://newservice:8080
      key: your_newservice_api_key
```

2. Update Python script in `roles/homepage/templates/setup_homepage.py.j2`

3. Redeploy:
```bash
ansible-playbook site.yml --tags homepage,homepage-config
```

### Custom Themes

1. Modify `roles/homepage/templates/config.yml.j2`
2. Add custom CSS/JS files
3. Restart Homepage:
```bash
./scripts/manage.sh restart
```

## Integration

### With Monitoring Stack

Homepage integrates with:
- **Grafana**: Metrics dashboards
- **Prometheus**: Service monitoring
- **AlertManager**: Alert management
- **Loki**: Log aggregation

### With Security Stack

Homepage integrates with:
- **Traefik**: Reverse proxy and SSL
- **Authentik**: Authentication
- **Fail2ban**: Intrusion prevention

### With Backup System

Homepage includes:
- Automated daily backups
- Configuration backup
- Data backup
- Recovery procedures

## Next Steps

1. **Configure API Keys**: Update service API keys for widgets
2. **Set Weather Location**: Configure weather widget with your location
3. **Customize Bookmarks**: Add your own bookmarks and resources
4. **Test Services**: Verify all service integrations work
5. **Monitor Health**: Set up monitoring and alerts
6. **Regular Maintenance**: Schedule backups and updates

## Support

- **Documentation**: [HOMEPAGE_AUTOMATION.md](HOMEPAGE_AUTOMATION.md)
- **GitHub**: Report issues and contribute
- **Community**: Join discussions on Discord/Reddit

## Quick Reference

### URLs
- Homepage: https://homepage.your-domain.com
- Traefik: https://traefik.your-domain.com
- Grafana: https://grafana.your-domain.com
- Authentik: https://auth.your-domain.com

### Directories
- Docker: `/opt/docker/homepage/`
- Config: `/opt/docker/homepage/config/`
- Logs: `/opt/logs/homepage/`
- Backups: `/opt/backup/homepage/`

### Scripts
- Management: `/opt/docker/homepage/scripts/manage.sh`
- Backup: `/opt/docker/homepage/scripts/backup.sh`
- Health Check: `/opt/docker/homepage/scripts/healthcheck.sh`

### Commands
```bash
# Deploy
ansible-playbook site.yml --tags homepage

# Manage
cd /opt/docker/homepage && ./scripts/manage.sh [command]

# Backup
./scripts/manage.sh backup

# Health Check
./scripts/manage.sh health
``` 