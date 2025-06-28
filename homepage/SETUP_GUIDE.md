# Homepage Dashboard Setup Guide

This guide provides step-by-step instructions for deploying and configuring the comprehensive Homepage dashboard for your homelab environment.

## 📋 Prerequisites

Before starting, ensure you have:

- **Docker & Docker Compose** installed and running
- **Domain name** with DNS configured
- **Traefik reverse proxy** (recommended)
- **API keys** for external services (weather, monitoring, etc.)

## 🚀 Quick Deployment

### Step 1: Download Configuration

1. **Navigate to the homepage directory**:
   ```bash
   cd homepage/
   ```

2. **Make the deployment script executable**:
   ```bash
   chmod +x deploy.sh
   ```

### Step 2: Initial Setup

1. **Run the deployment script**:
   ```bash
   ./deploy.sh
   ```

   This will:
   - Check prerequisites
   - Create backup of existing configuration
   - Validate configuration files
   - Create `.env` file
   - Deploy Homepage services
   - Perform health checks

2. **Edit the environment file**:
   ```bash
   nano .env
   ```

   Update the following key values:
   - `DOMAIN=yourdomain.com`
   - `OPENWEATHER_API_KEY=your_api_key`
   - `ADMIN_PASSWORD=your_secure_password`

### Step 3: Configure Services

1. **Update domain names** in configuration files:
   ```bash
   # Replace all instances of {{ domain }} with your actual domain
   sed -i 's/{{ domain }}/yourdomain.com/g' config/*.yml
   ```

2. **Add API keys** to `config/services.yml`:
   - Replace `your_sonarr_api_key` with actual Sonarr API key
   - Replace `your_radarr_api_key` with actual Radarr API key
   - Continue for all services you use

3. **Customize service URLs** if needed:
   - Update internal URLs if services run on different ports
   - Modify health check endpoints if different

### Step 4: Restart Services

```bash
docker-compose restart
```

### Step 5: Access Dashboard

Open your browser and navigate to:
```
https://homepage.yourdomain.com
```

## ⚙️ Detailed Configuration

### Service Groups Overview

The dashboard is organized into themed service groups:

#### 🎬 Media Stack (Blue/Purple Theme)
- **Sonarr**: TV show management
- **Radarr**: Movie management
- **Jellyfin**: Media server
- **Overseerr**: Media requests
- **Prowlarr**: Indexer management
- **Bazarr**: Subtitle management
- **Tautulli**: Media statistics

#### 📊 Monitoring & Observability (Green/Teal Theme)
- **Grafana**: Metrics dashboard
- **Prometheus**: Metrics collection
- **AlertManager**: Alert management
- **Loki**: Log aggregation
- **Node Exporter**: System metrics

#### ⚙️ Management & Control (Orange/Amber Theme)
- **Portainer**: Container management
- **Authentik**: Identity management
- **Traefik**: Reverse proxy
- **Homepage**: Dashboard itself

#### 🛡️ Security & Network (Red/Security Theme)
- **CrowdSec**: Intrusion detection
- **Fail2ban**: Intrusion prevention
- **UFW**: Firewall status

#### 🌐 External Resources (Gray/Neutral Theme)
- **GitHub**: Code repository
- **Documentation**: System docs
- **Support**: Help resources
- **Status Pages**: External monitoring

### Adding New Services

1. **Add service to `config/services.yml`**:
   ```yaml
   - Your Service:
       icon: your-service.png
       href: https://your-service.yourdomain.com
       description: Service description
       widget:
         type: your-service
         url: http://your-service:port
         key: your_api_key
       health:
         url: http://your-service:port/health
         interval: 30
       auth:
         type: api_key
         header: X-API-Key
   ```

2. **Add service icon**:
   - Place icon file in `config/icons/`
   - Use PNG format, recommended size: 32x32 or 64x64 pixels

3. **Configure health checks**:
   - Set appropriate health check endpoint
   - Configure check interval (30-60 seconds recommended)
   - Test health endpoint manually

4. **Restart Homepage**:
   ```bash
   docker-compose restart
   ```

### Customizing Appearance

#### Theme Customization

1. **Edit `config/custom.css`**:
   - Modify color variables in `:root`
   - Customize service group themes
   - Adjust animations and effects

2. **Update `config/config.yml`**:
   - Change background image
   - Modify layout settings
   - Adjust widget configuration

#### Widget Configuration

1. **Weather Widget**:
   ```yaml
   weather:
     provider: openweathermap
     apiKey: your_api_key
     latitude: 40.7128
     longitude: -74.0060
     units: metric
   ```

2. **System Monitoring**:
   ```yaml
   system:
     showCpu: true
     showMemory: true
     showDisk: true
     showNetwork: true
     showTemperature: true
   ```

3. **Search Widget**:
   ```yaml
   search:
     provider: duckduckgo
     target: _blank
     placeholder: "Search the web..."
   ```

### Bookmark Organization

The bookmarks are organized into categories:

- **Documentation & Guides**: System and service documentation
- **Support & Community**: Forums and technical support
- **Development Resources**: Code repositories and tools
- **Monitoring & Status**: System monitoring and external status
- **External Services**: Cloud services and utilities
- **Media & Entertainment**: Streaming and media services
- **Utilities & Tools**: Network and development tools
- **Learning & Reference**: Educational resources

To add new bookmarks:

1. **Edit `config/bookmarks.yml`**:
   ```yaml
   Category Name:
     - Subcategory:
         - "[Link Text](https://link.url)"
   ```

2. **Restart Homepage** to apply changes

## 🔧 Advanced Configuration

### Health Monitoring

Each service includes configurable health checks:

```yaml
health:
  url: http://service:port/health
  interval: 30  # seconds
  timeout: 10   # seconds
  retries: 3
```

### Authentication Integration

Configure authentication for services:

```yaml
auth:
  type: api_key  # api_key, session, oauth
  header: X-API-Key
  timeout: 30
```

### Traefik Integration

For Traefik reverse proxy integration:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.homepage.rule=Host(`homepage.yourdomain.com`)"
  - "traefik.http.routers.homepage.entrypoints=websecure"
  - "traefik.http.routers.homepage.tls.certresolver=letsencrypt"
```

### Authentik SSO

Configure Single Sign-On with Authentik:

```yaml
auth:
  type: oauth
  provider: authentik
  clientId: your_client_id
  clientSecret: your_client_secret
  redirectUri: https://homepage.yourdomain.com/auth/callback
```

## 📊 Monitoring & Alerts

### Health Check Status

Services display status indicators:
- 🟢 **Green**: Service online
- 🔴 **Red**: Service offline
- 🟡 **Yellow**: Service warning

### Integration with Monitoring Stack

Homepage integrates with:
- **Grafana**: Dashboard metrics and alerts
- **Prometheus**: System and service metrics
- **AlertManager**: Alert routing and notification
- **Loki**: Log aggregation and querying

### Setting Up Alerts

1. **Configure alert thresholds** in `config/settings.yml`:
   ```yaml
   alerts:
     rules:
       - name: High CPU Usage
         condition: cpu > 80
         duration: 5m
       - name: Service Down
         condition: service_status == "down"
         duration: 1m
   ```

2. **Set up notification channels**:
   ```yaml
   notifications:
     discord:
       enabled: true
       webhook: your_discord_webhook_url
     email:
       enabled: true
       host: smtp.gmail.com
       username: your_email@gmail.com
       password: your_app_password
   ```

## 🔄 Backup & Recovery

### Automatic Backups

Configured backup features:
- **Daily backups**: Automated backup scheduling
- **Multiple locations**: Local, S3, and FTP backup
- **Compression**: Space-efficient backup storage
- **Retention policies**: Configurable backup retention

### Manual Backup

```bash
# Create backup
./deploy.sh backup

# Restore from backup
./deploy.sh restore backup-file.tar.gz
```

### Backup Configuration

Edit backup settings in `config/settings.yml`:

```yaml
backup:
  auto:
    enabled: true
    schedule: "0 2 * * *"  # Daily at 2 AM
    retention: 30  # days
  locations:
    - type: local
      path: ./backups
    - type: s3
      bucket: homepage-backups
      region: us-east-1
```

## 🚨 Troubleshooting

### Common Issues

#### Services Not Showing Up

1. **Check service URLs and ports**:
   ```bash
   curl -f http://service:port/health
   ```

2. **Verify API keys**:
   - Check API key format
   - Ensure API key has correct permissions
   - Test API key manually

3. **Review health check endpoints**:
   - Verify health check URLs are correct
   - Check if services require authentication for health checks

#### Widgets Not Working

1. **Weather widget issues**:
   - Verify OpenWeatherMap API key
   - Check latitude/longitude coordinates
   - Ensure API key has correct permissions

2. **System monitoring issues**:
   - Check Docker socket permissions
   - Verify system monitoring container is running
   - Review resource limits

3. **Search widget issues**:
   - Test search provider manually
   - Check network connectivity
   - Verify search provider configuration

#### Styling Issues

1. **Clear browser cache**:
   - Hard refresh (Ctrl+F5 or Cmd+Shift+R)
   - Clear browser cache completely

2. **Check CSS syntax**:
   ```bash
   # Validate CSS syntax
   csslint config/custom.css
   ```

3. **Verify CSS file path**:
   - Ensure custom.css is in config directory
   - Check file permissions

### Debug Mode

Enable debug logging:

```yaml
logging:
  level: debug
  output: stdout
```

### Health Check Testing

Test individual service health:

```bash
# Test service health endpoint
curl -f http://service:port/health

# Check service logs
docker-compose logs service-name

# Test API endpoints
curl -H "X-API-Key: your_api_key" http://service:port/api/health
```

### Performance Issues

1. **Check resource usage**:
   ```bash
   docker stats
   ```

2. **Review resource limits**:
   ```yaml
   deploy:
     resources:
       limits:
         memory: 512M
         cpus: '0.5'
   ```

3. **Enable caching**:
   ```yaml
   cache:
     enabled: true
     type: memory
     ttl: 300
   ```

## 🔧 Maintenance

### Regular Updates

1. **Update Homepage**:
   ```bash
   ./deploy.sh update
   ```

2. **Update configuration**:
   - Review new features and configuration options
   - Update service configurations as needed
   - Test new functionality

### Monitoring Maintenance

1. **Review health check logs**:
   ```bash
   docker-compose logs -f homepage
   ```

2. **Check service status**:
   ```bash
   ./deploy.sh status
   ```

3. **Monitor resource usage**:
   ```bash
   docker stats homepage
   ```

### Backup Maintenance

1. **Test backup restoration**:
   ```bash
   # Create test backup
   ./deploy.sh backup
   
   # Test restore in separate environment
   ./deploy.sh restore backup-file.tar.gz
   ```

2. **Clean up old backups**:
   ```bash
   # Remove backups older than 30 days
   find backups/ -name "*.tar.gz" -mtime +30 -delete
   ```

## 📈 Performance Optimization

### Resource Optimization

1. **Adjust resource limits**:
   ```yaml
   deploy:
     resources:
       limits:
         memory: 512M
         cpus: '0.5'
       reservations:
         memory: 256M
         cpus: '0.25'
   ```

2. **Enable caching**:
   ```yaml
   cache:
     enabled: true
     type: memory
     ttl: 300
     maxSize: 100
   ```

3. **Optimize health check intervals**:
   - Increase intervals for stable services
   - Decrease intervals for critical services

### Network Optimization

1. **Use internal networks**:
   ```yaml
   networks:
     - traefik
     - internal
   ```

2. **Optimize health check timeouts**:
   ```yaml
   health:
     timeout: 5
     retries: 2
   ```

## 🔐 Security Considerations

### API Key Security

1. **Use environment variables**:
   ```bash
   # Store API keys in .env file
   SONARR_API_KEY=your_api_key
   ```

2. **Rotate API keys regularly**:
   - Set up automated key rotation
   - Monitor API key usage
   - Use least privilege principle

### Access Control

1. **Configure authentication**:
   ```yaml
   security:
     auth:
       enabled: true
       type: basic
       users:
         - username: admin
           password: your_secure_password
   ```

2. **Restrict access**:
   ```yaml
   access:
     allowExternalAccess: false
     allowedIPs: ["192.168.1.0/24"]
     requireHTTPS: true
   ```

### Network Security

1. **Use HTTPS**:
   - Configure SSL certificates
   - Enable HSTS
   - Use secure cookies

2. **Network segmentation**:
   - Use separate networks for different service tiers
   - Implement firewall rules
   - Monitor network traffic

## 📞 Support

### Getting Help

1. **Check documentation**:
   - [Homepage Documentation](https://gethomepage.dev)
   - [Configuration Examples](https://gethomepage.dev/configs/)

2. **Community support**:
   - [Homepage Discord](https://discord.gg/homelab)
   - [Reddit r/homelab](https://reddit.com/r/homelab)
   - [GitHub Issues](https://github.com/gethomepage/homepage/issues)

3. **Debug information**:
   ```bash
   # Collect debug information
   ./deploy.sh status
   docker-compose logs
   docker system info
   ```

### Contributing

1. **Report issues**:
   - Include configuration files
   - Provide error logs
   - Describe steps to reproduce

2. **Submit improvements**:
   - Fork the repository
   - Create feature branch
   - Submit pull request

---

**Happy Homelabbing! 🏠**

For additional support and updates, visit the [Homepage project](https://gethomepage.dev) and join the community. 