# Homepage Configuration Documentation

## Overview

Homepage serves as the central dashboard for the Watchtower homelab infrastructure, providing quick access to all deployed services with monitoring widgets and organized bookmarks.

## Service Coverage

### ✅ Fully Configured Services

#### Infrastructure Services
- **Traefik** - Reverse proxy with authentication
- **Authentik** - Identity and access management
- **Portainer** - Container management interface

#### Monitoring Stack
- **Grafana** - Metrics visualization dashboard
- **Prometheus** - Metrics collection and storage
- **InfluxDB** - Time series database
- **Loki** - Log aggregation
- **Promtail** - Log collection agent
- **Alertmanager** - Alert routing and management
- **Blackbox Exporter** - Blackbox monitoring
- **Telegraf** - Metrics collection agent
- **Uptime Kuma** - Uptime monitoring
- **Dashdot** - System dashboard

#### Network Services
- **Pi-hole** - DNS ad blocker
- **Nginx Proxy Manager** - Proxy management interface

#### Media Stack
- **Jellyfin** - Media server
- **Emby** - Media server (alternative)
- **Sonarr** - TV show management
- **Radarr** - Movie management
- **Lidarr** - Music management
- **Readarr** - Book management
- **Prowlarr** - Indexer management
- **Bazarr** - Subtitle management
- **Tautulli** - Media statistics
- **Overseerr** - Media requests
- **Pulsarr** - Media requests (alternative)
- **Komga** - Comic management
- **Audiobookshelf** - Audiobook management
- **Calibre Web** - E-book management
- **Tdarr** - Media transcoding
- **SABnzbd** - Usenet downloader
- **qBittorrent** - Torrent downloader

#### Storage & Databases
- **PostgreSQL** - Database
- **MariaDB** - Database
- **Redis** - Cache
- **Elasticsearch** - Search engine
- **Kibana** - Analytics dashboard
- **Nextcloud** - File storage
- **Samba** - File sharing
- **Syncthing** - File synchronization
- **MinIO** - Object storage
- **Paperless** - Document management
- **BookStack** - Wiki & documentation
- **Immich** - Photo management
- **FileBrowser** - File browser

#### Security Services
- **Crowdsec** - Security monitoring
- **Fail2ban** - Intrusion prevention
- **Vault** - Secrets management
- **Vaultwarden** - Password manager
- **Wireguard** - VPN

#### Automation & Smart Home
- **Home Assistant** - Home automation
- **Zigbee2MQTT** - Zigbee gateway
- **Mosquitto** - MQTT broker
- **Node-RED** - Flow automation
- **n8n** - Workflow automation

#### Development & CI/CD
- **GitLab** - Git repository
- **Harbor** - Container registry
- **Code Server** - Web IDE
- **Guacamole** - Remote desktop

#### Backup Services
- **Kopia** - Backup system
- **Duplicati** - Backup system

#### Utility Services
- **Heimdall** - Application dashboard
- **Homarr** - Dashboard
- **Requestrr** - Media requests
- **Unmanic** - Media processing
- **Watchtower** - Container updates

## Configuration Files

### 1. `config.yml`
Main Homepage configuration including:
- Theme and layout settings
- Widget configurations
- Service categories
- Bookmark organization

### 2. `services.yml`
Service definitions with:
- Service URLs and descriptions
- Widget configurations
- API key integration
- Conditional deployment based on `enabled_services`

### 3. `bookmarks.yml`
Organized bookmarks by category:
- Infrastructure
- Network
- Media
- Storage
- Security
- Automation
- Development
- External resources

## API Key Management

The following services require API keys for widget functionality:

```yaml
# Generated automatically during deployment
- traefik, authentik, portainer, grafana, jellyfin
- sonarr, radarr, lidarr, readarr, prowlarr, bazarr
- tautulli, overseerr, homeassistant, nextcloud
- gitlab, harbor, minio, paperless, bookstack
- immich, filebrowser, kopia, duplicati
- uptimekuma, guacamole, requestrr, unmanic
- pihole, vaultwarden, promtail
```

## Domain Configuration

All services are configured with subdomains under the main domain:

```yaml
subdomains:
  # Infrastructure
  traefik: "traefik"
  authentik: "auth"
  portainer: "portainer"
  
  # Monitoring
  grafana: "grafana"
  prometheus: "prometheus"
  loki: "loki"
  promtail: "logs"
  alertmanager: "alerts"
  
  # Network
  pihole: "dns"
  nginx_proxy_manager: "proxy"
  
  # Security
  vault: "vault"
  vaultwarden: "passwords"
  wireguard: "vpn"
  
  # Utilities
  watchtower: "updates"
  # ... and many more
```

## Widget Configuration

Each service can have monitoring widgets configured:

```yaml
widget:
  type: service_name
  url: http://service:port
  key: api_key_for_authentication
```

## Deployment Process

1. **Configuration Generation**: Templates are processed with Ansible variables
2. **API Key Generation**: Secure API keys are generated for each service
3. **Icon Setup**: Service icons are downloaded from Homepage repository
4. **Container Deployment**: Homepage container is deployed with all configurations
5. **Health Check**: Service availability is verified

## Troubleshooting

### Common Issues

1. **Missing Icons**
   - Run the icon setup script: `./setup_icons.sh`
   - Check icon permissions and ownership

2. **Widget Not Working**
   - Verify API key is correctly configured
   - Check service is running and accessible
   - Validate widget type is supported

3. **Service Not Appearing**
   - Ensure service is in `enabled_services` list
   - Check conditional logic in template
   - Verify service deployment completed successfully

4. **Domain Issues**
   - Confirm subdomain is configured in `vars.yml`
   - Check DNS records are properly set
   - Verify Traefik routing configuration

### Debugging Commands

```bash
# Check Homepage logs
docker logs homepage

# Verify configuration files
cat /home/username/docker/homepage/config/services.yml

# Test service connectivity
curl -I http://service:port

# Check API key validity
curl -H "Authorization: Bearer API_KEY" http://service:port/api/endpoint
```

## Customization

### Adding New Services

1. Add service to `enabled_services` in `vars.yml`
2. Configure subdomain in `subdomains` section
3. Add service configuration to `templates/homepage/services.yml.j2`
4. Add widget configuration to `templates/homepage/config.yml.j2`
5. Add bookmark entry to `templates/homepage/bookmarks.yml.j2`
6. Generate API key in `tasks/homepage.yml`
7. Add icon to `scripts/setup_homepage_icons.sh`

### Modifying Widgets

Edit the widget configuration in `services.yml`:

```yaml
widget:
  type: custom_widget_type
  url: http://service:port
  key: api_key
  options:
    custom_option: value
```

### Theme Customization

Modify `config.yml` for theme settings:

```yaml
theme: dark  # or light
background: custom_background_url
favicon: custom_favicon_url
```

## Security Considerations

1. **API Keys**: Stored securely in Ansible vault
2. **Access Control**: Integrated with Authentik for authentication
3. **Network Security**: Services run on internal Docker networks
4. **SSL/TLS**: All external access uses HTTPS via Traefik

## Performance Optimization

1. **Widget Refresh**: Configure appropriate refresh intervals
2. **Icon Caching**: Icons are cached locally
3. **Resource Limits**: Container resource limits prevent overload
4. **Monitoring**: System resources are monitored via widgets

## Maintenance

### Regular Tasks

1. **Update Icons**: Run icon setup script after adding new services
2. **Rotate API Keys**: Periodically regenerate service API keys
3. **Backup Configuration**: Backup Homepage configuration files
4. **Monitor Logs**: Check Homepage logs for errors

### Backup Strategy

```bash
# Backup Homepage configuration
tar -czf homepage_config_backup.tar.gz /home/username/docker/homepage/config/

# Restore configuration
tar -xzf homepage_config_backup.tar.gz -C /home/username/docker/homepage/
```

## Support

For issues with Homepage configuration:
1. Check the [Homepage documentation](https://gethomepage.dev)
2. Review Ansible playbook logs
3. Verify service-specific configurations
4. Check Docker container logs 