# Homepage Automation System

This document describes the comprehensive Ansible automation system for Homepage (https://github.com/benphelps/homepage) that pre-configures the service dashboard with all homelab services.

## Overview

The Homepage automation system provides:

- **Automated Deployment**: Docker-based deployment with Traefik integration
- **Pre-configured Services**: All homelab services with proper icons, URLs, and descriptions
- **Service Groups**: Organized into logical categories (Media, Monitoring, Management, Security, etc.)
- **Widgets**: Weather, system monitoring, and service-specific widgets
- **Bookmarks**: Pre-configured bookmarks for common resources
- **Theme Configuration**: Dark theme with custom styling
- **API Integration**: REST API configuration for dynamic updates
- **Health Monitoring**: Service health checks and status monitoring

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Homepage Automation                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Deploy    │  │  Configure  │  │   Monitor   │        │
│  │   Tasks     │  │   Tasks     │  │   Tasks     │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Python    │  │   Docker    │  │   Scripts   │        │
│  │   Script    │  │   Compose   │  │  (Backup,   │        │
│  │             │  │             │  │   Health)   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Config    │  │  Services   │  │ Bookmarks   │        │
│  │   Templates │  │  Templates  │  │ Templates   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## Service Categories

### Infrastructure Services
- **Traefik**: Reverse proxy and load balancer
- **Authentik**: Identity provider and SSO
- **Portainer**: Container management

### Monitoring Services
- **Grafana**: Metrics dashboard and visualization
- **Prometheus**: Metrics collection and storage
- **AlertManager**: Alert management
- **Loki**: Log aggregation
- **Uptime Kuma**: Uptime monitoring
- **Dashdot**: System dashboard

### Media Services
- **Jellyfin**: Media server and streaming
- **Sonarr**: TV show management
- **Radarr**: Movie management
- **Lidarr**: Music management
- **Readarr**: Book management
- **Prowlarr**: Indexer management
- **Bazarr**: Subtitle management
- **Tautulli**: Media statistics
- **Overseerr**: Media requests
- **Requestrr**: Discord media requests
- **Unmanic**: Media processing

### Storage Services
- **Nextcloud**: File storage and sync
- **FileBrowser**: Web file manager
- **MinIO**: Object storage
- **Paperless**: Document management
- **BookStack**: Wiki and documentation
- **Immich**: Photo management
- **Kopia**: Backup system
- **Duplicati**: Backup system

### Security Services
- **CrowdSec**: Security monitoring
- **Fail2ban**: Intrusion prevention
- **Vaultwarden**: Password manager

### Development Services
- **GitLab**: Git repository management
- **Harbor**: Container registry
- **Code Server**: Web IDE
- **Guacamole**: Remote desktop gateway

### Automation Services
- **Home Assistant**: Home automation
- **Zigbee2MQTT**: Zigbee gateway
- **Node-RED**: Flow automation
- **n8n**: Workflow automation

### Utility Services
- **Homepage**: Dashboard itself
- **Watchtower**: Container updates
- **Heimdall**: Application dashboard
- **Homarr**: Dashboard

## Configuration

### Environment Variables

The automation system uses the following environment variables:

```bash
# Required
HOMEPAGE_URL=http://localhost:3000
DOMAIN=your-domain.com

# Optional
WEATHER_LAT=40.7128
WEATHER_LON=-74.0060
WEATHER_API_KEY=your_openweathermap_api_key
HOMEPAGE_API_SECRET=your_api_secret
```

### Service Configuration

Each service is configured with:

- **Icon**: Proper icon from Homepage's icon library
- **URL**: Service URL with domain substitution
- **Description**: Clear description of service purpose
- **Group**: Logical grouping for organization
- **Widget**: Service-specific widget configuration (where available)

### Widget Support

The automation includes widgets for:

- **System Resources**: CPU, memory, disk usage
- **Docker**: Container status and resource usage
- **Weather**: Current weather conditions
- **Service-specific**: Grafana, Prometheus, Traefik, etc.

## Python Configuration Script

The `setup_homepage.py` script provides:

### Features
- **REST API Integration**: Configures Homepage via its REST API
- **Service Configuration**: Automatically configures all homelab services
- **Bookmark Setup**: Creates organized bookmarks for common resources
- **Weather Widget**: Configures weather widget with user's location
- **Theme Configuration**: Sets up dark theme and custom styling
- **Error Handling**: Comprehensive error handling and retry logic
- **Idempotent**: Safe to run multiple times

### Usage

```bash
# Run the configuration script
python3 setup_homepage.py

# Environment variables are automatically loaded
export HOMEPAGE_URL=http://localhost:3000
export DOMAIN=your-domain.com
export WEATHER_LAT=40.7128
export WEATHER_LON=-74.0060
export WEATHER_API_KEY=your_api_key
```

### API Endpoints

The script interacts with Homepage's REST API:

- `GET /api/health` - Health check
- `POST /api/services` - Configure services
- `POST /api/bookmarks` - Configure bookmarks
- `POST /api/weather` - Configure weather widget
- `POST /api/config` - Configure theme and settings

## Deployment

### Ansible Role Structure

```
roles/homepage/
├── README.md                 # Role documentation
├── defaults/main.yml         # Default variables
├── tasks/
│   ├── main.yml             # Main orchestration
│   ├── deploy.yml           # Docker deployment
│   └── configure.yml        # Service configuration
├── templates/
│   ├── setup_homepage.py.j2 # Python configuration script
│   ├── docker-compose.yml.j2 # Docker Compose configuration
│   ├── config.yml.j2        # Homepage main configuration
│   ├── services.yml.j2      # Service definitions
│   ├── bookmarks.yml.j2     # Bookmark definitions
│   ├── backup.sh.j2         # Backup script
│   ├── manage.sh.j2         # Management script
│   ├── healthcheck.sh.j2    # Health check script
│   ├── logrotate.conf.j2    # Log rotation configuration
│   └── health-monitor.yml.j2 # Health monitoring configuration
├── handlers/main.yml        # Role handlers
├── vars/main.yml           # Role variables
└── meta/main.yml          # Role metadata
```

### Deployment Commands

```bash
# Deploy Homepage with all services
ansible-playbook site.yml --tags homepage

# Deploy only Homepage without configuration
ansible-playbook site.yml --tags homepage,homepage-deploy

# Configure Homepage services only
ansible-playbook site.yml --tags homepage,homepage-config

# Deploy specific components
ansible-playbook site.yml --tags homepage,homepage-deploy,homepage-config
```

### Integration with Main Playbook

The Homepage role is integrated into the main `site.yml` playbook:

```yaml
# Stage 3.5: Dashboard and Management (depends on applications)
- name: homepage
  tags: [homepage, dashboard, stage3.5]
  when: homepage_enabled | default(true)
```

## Management

### Management Script

The `manage.sh` script provides comprehensive management capabilities:

```bash
# Show status
./manage.sh status

# View logs
./manage.sh logs -f

# Restart services
./manage.sh restart

# Update to latest version
./manage.sh update

# Create backup
./manage.sh backup

# Restore from backup
./manage.sh restore /path/to/backup.tar.gz

# Show configuration
./manage.sh config

# Health check
./manage.sh health

# Test API
./manage.sh api
```

### Backup and Recovery

#### Backup Script Features
- **Automated Backups**: Scheduled backups with retention
- **Configuration Backup**: All configuration files
- **Data Backup**: Service data and state
- **Compression**: Gzip compression for efficiency
- **Manifest Creation**: Detailed backup manifests
- **Notification**: Discord/Slack notifications

#### Backup Schedule
```bash
# Daily backup at 2 AM
0 2 * * * /opt/docker/homepage/scripts/backup.sh
```

#### Recovery Process
```bash
# Restore from backup
./manage.sh restore /opt/backup/homepage/homepage_backup_20231201_020000.tar.gz
```

### Health Monitoring

#### Health Check Script
The `healthcheck.sh` script performs comprehensive health checks:

- **Container Status**: Verify container is running
- **Port Listening**: Check if port is accessible
- **Web Interface**: Test web interface accessibility
- **API Health**: Verify API endpoints
- **Configuration**: Validate configuration files
- **Resources**: Monitor resource usage
- **Logs**: Check for errors in logs

#### Health Check Endpoints
- `http://localhost:3000/` - Web interface
- `http://localhost:3000/api/health` - API health
- `http://localhost:3000/api/services` - Services API
- `http://localhost:3000/api/bookmarks` - Bookmarks API

## Security

### Security Features
- **SSL/TLS**: Automatic SSL certificate management via Traefik
- **Security Headers**: Comprehensive security headers
- **Rate Limiting**: API rate limiting protection
- **CORS Configuration**: Configurable CORS settings
- **Authentication**: Optional basic authentication
- **IP Whitelisting**: Configurable IP access control

### Security Headers
```yaml
security:
  headers:
    enabled: true
    content_security_policy: "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https:;"
    x_frame_options: "SAMEORIGIN"
    x_content_type_options: "nosniff"
    referrer_policy: "strict-origin-when-cross-origin"
```

## Monitoring Integration

### Prometheus Metrics
- **Response Time**: Service response time monitoring
- **Error Rates**: API error rate tracking
- **Resource Usage**: Container resource monitoring
- **Health Status**: Service health status metrics

### Grafana Dashboards
- **Homepage Health**: Dedicated Homepage health dashboard
- **Service Status**: Service availability monitoring
- **Performance Metrics**: Response time and resource usage
- **Alert Management**: Alert status and history

### AlertManager Integration
- **Health Alerts**: Service health status alerts
- **Performance Alerts**: Response time and resource alerts
- **Error Alerts**: API error and failure alerts
- **Recovery Alerts**: Service recovery notifications

## Performance Optimization

### Caching
```yaml
cache:
  enabled: true
  ttl: 300  # 5 minutes
```

### Compression
```yaml
compression:
  enabled: true
  level: 6
```

### Rate Limiting
```yaml
rate_limiting:
  enabled: true
  window_ms: 900000  # 15 minutes
  max_requests: 100
```

## Troubleshooting

### Common Issues

#### Service Not Accessible
```bash
# Check container status
docker ps | grep homepage

# Check logs
docker logs homepage

# Test connectivity
curl -I http://localhost:3000
```

#### Configuration Issues
```bash
# Validate configuration
./manage.sh config

# Check configuration files
ls -la /opt/docker/homepage/config/

# Test API endpoints
./manage.sh api
```

#### Widget Issues
```bash
# Check API keys
grep -r "your_api_key" /opt/docker/homepage/config/

# Test individual widgets
curl http://localhost:3000/api/services
```

### Log Files
- **Application Logs**: `/opt/logs/homepage/`
- **Backup Logs**: `/opt/logs/homepage/backup.log`
- **Health Check Logs**: `/opt/logs/homepage/healthcheck.log`

### Debug Mode
```bash
# Enable debug logging
export HOMEPAGE_LOG_LEVEL=debug

# Restart with debug
./manage.sh restart
```

## Customization

### Adding New Services
1. Add service to `services.yml.j2` template
2. Update Python script with service configuration
3. Add service to appropriate group
4. Configure widget if available

### Custom Themes
1. Modify `config.yml.j2` template
2. Add custom CSS/JS files
3. Update theme configuration
4. Restart Homepage

### Custom Widgets
1. Create widget configuration
2. Add to services configuration
3. Update Python script
4. Test widget functionality

## Best Practices

### Security
- Use strong API keys for services
- Enable SSL/TLS encryption
- Configure security headers
- Implement rate limiting
- Regular security updates

### Performance
- Enable caching for static content
- Use compression for responses
- Monitor resource usage
- Optimize widget configurations
- Regular performance testing

### Maintenance
- Regular backups
- Monitor logs for errors
- Update Homepage regularly
- Test recovery procedures
- Document customizations

### Monitoring
- Set up comprehensive monitoring
- Configure meaningful alerts
- Monitor service dependencies
- Track performance metrics
- Regular health checks

## Support

### Documentation
- [Homepage Documentation](https://gethomepage.dev)
- [Ansible Documentation](https://docs.ansible.com)
- [Docker Documentation](https://docs.docker.com)

### Community
- [Reddit r/homelab](https://reddit.com/r/homelab)
- [Reddit r/selfhosted](https://reddit.com/r/selfhosted)
- [Discord](https://discord.gg/homelab)

### Issues and Contributions
- Report issues on GitHub
- Submit pull requests
- Join community discussions
- Share configurations and improvements

## Conclusion

The Homepage automation system provides a comprehensive solution for deploying and managing a homelab dashboard with minimal manual configuration. The system is designed to be:

- **Automated**: Minimal manual intervention required
- **Comprehensive**: Covers all major homelab services
- **Maintainable**: Easy to update and customize
- **Reliable**: Robust error handling and recovery
- **Secure**: Built-in security features
- **Scalable**: Easy to extend with new services

This automation system transforms the complex task of setting up a homelab dashboard into a simple, repeatable process that can be deployed across multiple environments with confidence. 