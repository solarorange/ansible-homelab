# Homelab Dashboard - Homepage Configuration

A comprehensive, production-ready Homepage configuration for homelab environments with advanced features, monitoring integration, and modern UI design.

## 🚀 Features

### 📊 **Service Management**
- **Organized Service Groups**: Media Stack, Monitoring & Observability, Management & Control, Security & Network, External Resources
- **Health Monitoring**: Real-time service status with configurable health checks
- **Authentication Integration**: Support for API keys, session-based auth, and OAuth
- **Custom Styling**: Themed service groups with gradient backgrounds and hover effects

### 🎨 **Modern UI/UX**
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices
- **Dark Mode**: Beautiful dark theme with custom CSS variables
- **Custom CSS**: Advanced styling with animations, gradients, and modern design elements
- **Accessibility**: WCAG compliant with focus indicators and reduced motion support

### 📈 **Advanced Widgets**
- **Weather Widget**: OpenWeatherMap integration with forecast and detailed metrics
- **System Monitoring**: CPU, RAM, disk, network, and temperature monitoring
- **Docker Integration**: Container status and resource usage
- **Search Widget**: Configurable search providers (DuckDuckGo, Google, Bing)

### 🔧 **Configuration Management**
- **Modular Structure**: Separate config files for services, bookmarks, and settings
- **Environment Variables**: Support for dynamic configuration
- **Health Check Integration**: Automatic service discovery and monitoring
- **Backup & Recovery**: Automated backup configuration

## 📁 File Structure

```
homepage/
├── config/
│   ├── config.yml          # Main configuration
│   ├── services.yml        # Service definitions
│   ├── bookmarks.yml       # Bookmark categories
│   ├── docker.yml          # Docker compose configuration
│   ├── settings.yml        # Advanced settings
│   └── custom.css          # Custom styling
├── docker-compose.yml      # Main docker compose file
└── README.md              # This file
```

## 🛠️ Installation & Setup

### Prerequisites

- Docker and Docker Compose
- Domain name with DNS configured
- Traefik reverse proxy (recommended)
- API keys for external services

### Quick Start

1. **Clone or download the configuration files**
   ```bash
   cd homepage/
   ```

2. **Configure environment variables**
   ```bash
   # Copy and edit the environment file
   cp .env.example .env
   nano .env
   ```

3. **Update configuration files**
   - Replace `{{ domain }}` with your actual domain
   - Add your API keys in `config.yml` and `services.yml`
   - Customize service URLs and endpoints

4. **Deploy with Docker Compose**
   ```bash
   docker-compose up -d
   ```

5. **Access the dashboard**
   ```
   https://homepage.yourdomain.com
   ```

## ⚙️ Configuration

### Main Configuration (`config.yml`)

The main configuration file includes:
- Dashboard title and description
- Theme and layout settings
- Widget configuration
- Custom CSS integration
- Weather and system monitoring settings

### Service Configuration (`services.yml`)

Organized into service groups:

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

### Bookmarks Configuration (`bookmarks.yml`)

Organized bookmark categories:
- **Documentation & Guides**: System and service documentation
- **Support & Community**: Forums and technical support
- **Development Resources**: Code repositories and tools
- **Monitoring & Status**: System monitoring and external status
- **External Services**: Cloud services and utilities
- **Media & Entertainment**: Streaming and media services
- **Utilities & Tools**: Network and development tools
- **Learning & Reference**: Educational resources

## 🎨 Customization

### Custom CSS (`custom.css`)

The custom CSS file provides:
- **CSS Variables**: Consistent color scheme and spacing
- **Service Group Themes**: Gradient backgrounds for each service category
- **Responsive Design**: Mobile-first approach with breakpoints
- **Animations**: Smooth transitions and hover effects
- **Accessibility**: Focus indicators and reduced motion support

### Theme Customization

You can customize the appearance by modifying:
- Color variables in `:root`
- Service group themes
- Widget styling
- Animation effects

### Adding New Services

1. **Add to services.yml**:
   ```yaml
   - Your Service:
       icon: your-service.png
       href: https://your-service.{{ domain }}
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

2. **Add icon**: Place service icon in the icons directory
3. **Configure health checks**: Set appropriate health check endpoints
4. **Test the configuration**: Restart Homepage to apply changes

## 🔧 Advanced Features

### Health Monitoring

Each service includes configurable health checks:
- **URL-based checks**: HTTP/HTTPS endpoint monitoring
- **Interval configuration**: Customizable check frequency
- **Authentication support**: API key and session-based auth
- **Status indicators**: Visual status with color coding

### Widget Integration

Advanced widget configuration includes:
- **Weather data**: Real-time weather with forecast
- **System metrics**: CPU, memory, disk, and network monitoring
- **Docker stats**: Container resource usage
- **Search functionality**: Multiple search providers

### Security Features

- **Authentication**: Basic auth and OAuth support
- **Access control**: IP whitelisting and HTTPS enforcement
- **API security**: Rate limiting and CORS configuration
- **Session management**: Configurable session timeouts

## 📊 Monitoring & Alerts

### Health Checks

Services are automatically monitored with:
- **Status indicators**: Green (online), red (offline), yellow (warning)
- **Response time tracking**: Performance monitoring
- **Last check timestamps**: Audit trail
- **Configurable thresholds**: Custom alert conditions

### Integration with Monitoring Stack

Homepage integrates with:
- **Grafana**: Dashboard metrics and alerts
- **Prometheus**: System and service metrics
- **AlertManager**: Alert routing and notification
- **Loki**: Log aggregation and querying

## 🔄 Backup & Recovery

### Automatic Backups

Configured backup features:
- **Daily backups**: Automated backup scheduling
- **Multiple locations**: Local, S3, and FTP backup
- **Compression**: Space-efficient backup storage
- **Retention policies**: Configurable backup retention

### Recovery Procedures

1. **Stop Homepage**: `docker-compose down`
2. **Restore configuration**: Copy backup files to config directory
3. **Restart services**: `docker-compose up -d`
4. **Verify functionality**: Check service status and widgets

## 🚨 Troubleshooting

### Common Issues

1. **Services not showing up**
   - Check service URLs and ports
   - Verify API keys and authentication
   - Review health check endpoints

2. **Widgets not working**
   - Verify API keys for external services
   - Check network connectivity
   - Review widget configuration

3. **Styling issues**
   - Clear browser cache
   - Check CSS syntax in custom.css
   - Verify CSS file path in config

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
curl -f http://service:port/health
```

## 🔗 Integration Examples

### Traefik Integration

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.homepage.rule=Host(`homepage.yourdomain.com`)"
  - "traefik.http.routers.homepage.entrypoints=websecure"
  - "traefik.http.routers.homepage.tls.certresolver=letsencrypt"
```

### Authentik SSO

```yaml
auth:
  type: oauth
  provider: authentik
  clientId: your_client_id
  clientSecret: your_client_secret
  redirectUri: https://homepage.yourdomain.com/auth/callback
```

## 📈 Performance Optimization

### Resource Limits

Configured resource limits:
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

### Caching

Enable caching for better performance:
```yaml
cache:
  enabled: true
  type: memory
  ttl: 300
  maxSize: 100
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This configuration is provided under the MIT License. See LICENSE file for details.

## 🙏 Acknowledgments

- [Homepage](https://gethomepage.dev) - The amazing dashboard application
- [Traefik](https://traefik.io) - Reverse proxy and load balancer
- [Docker](https://docker.com) - Container platform
- The homelab community for inspiration and feedback

## 📞 Support

For support and questions:
- Create an issue in the repository
- Join the [Homepage Discord](https://discord.gg/homelab)
- Check the [Homepage documentation](https://gethomepage.dev)

---

**Happy Homelabbing! 🏠** 