# Homelab Homepage Dashboard

A comprehensive, enhanced homepage dashboard for homelab infrastructure with complete service integration, monitoring, and automation capabilities.

## 🚀 Features

### Complete Service Coverage
- **Infrastructure Services**: Traefik, Authentik, Portainer, Watchtower
- **Monitoring Stack**: Grafana, Prometheus, Loki, AlertManager, Uptime Kuma, Dashdot
- **Security Services**: CrowdSec, Fail2ban, Pi-hole, UFW, WireGuard
- **Database Services**: PostgreSQL, MariaDB, Redis, Elasticsearch, Kibana
- **Media Stack**: All ARR services (Sonarr, Radarr, Lidarr, Readarr, Prowlarr, Bazarr), Jellyfin, Overseerr, Tautulli
- **Storage Services**: Nextcloud, Vaultwarden, Paperless, MinIO, Filebrowser
- **Automation Services**: Home Assistant, Node-RED, n8n, Zigbee2MQTT
- **Backup Services**: Kopia, Duplicati, Restic
- **Utility Services**: Tdarr, Unmanic, Requestrr, Pulsarr

### Enhanced Visual Design
- Modern, responsive UI with gradient backgrounds
- Service-specific color themes and styling
- Hover effects and animations
- Status indicators and health monitoring
- Mobile-friendly design

### Advanced Functionality
- Real-time service health monitoring
- API key management with encryption
- Automated backup and recovery
- System resource monitoring
- Weather integration
- Search functionality
- Calendar integration

## 📋 Prerequisites

### System Requirements
- Docker and Docker Compose
- Python 3.8+
- curl, jq, yq utilities
- Traefik network (for reverse proxy)

### Required Dependencies
```bash
# Install system dependencies
sudo apt update
sudo apt install -y docker.io docker-compose python3 python3-pip curl jq

# Install Python dependencies
pip3 install pyyaml requests cryptography
```

## 🛠️ Installation

### Quick Deployment
```bash
# Clone the repository (if not already done)
cd /path/to/your/homelab

# Deploy the complete homepage
./homepage/deploy_enhanced.sh deploy
```

### Manual Installation
```bash
# 1. Navigate to homepage directory
cd homepage

# 2. Create necessary directories
mkdir -p config backups logs scripts

# 3. Set your domain (optional)
export DOMAIN=yourdomain.com

# 4. Deploy
./deploy_enhanced.sh deploy
```

## ⚙️ Configuration

### Environment Variables
```bash
# Domain for services
export DOMAIN=homelab.local

# Homepage port
export HOMEPAGE_PORT=3000
```

### API Key Management
The homepage includes a comprehensive API key management system:

```bash
# Add API key for a service
python3 scripts/api_key_manager.py add sonarr your_sonarr_api_key

# Test all API keys
python3 scripts/api_key_manager.py test --all

# Generate configuration files
python3 scripts/api_key_manager.py generate
```

### Service Configuration
Edit the service configurations in `config/services.yml`:

```yaml
- group: Media Stack
  icon: tv.png
  className: media-stack
  items:
    - Sonarr:
        icon: sonarr.png
        href: https://sonarr.{{ domain }}
        description: TV Show Management & Automation
        widget:
          type: sonarr
          url: http://sonarr:8989
          key: your_sonarr_api_key
        health:
          url: http://sonarr:8989/health
          interval: 30
        auth:
          type: api_key
          header: X-API-Key
```

## 🎨 Customization

### Custom CSS
The homepage includes extensive CSS customization options in `config/custom.css`:

```css
/* Custom service group themes */
.infrastructure-stack {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
  border-color: rgba(59, 130, 246, 0.3);
}

/* Custom animations */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Widget Configuration
Configure widgets in `config/widgets.yml`:

```yaml
# System monitoring widget
system_resources:
  label: System Resources
  type: resources
  url: http://localhost:3001
  config:
    cpu: true
    memory: true
    disk: true
    network: true
    temperature: true
    interval: 30
```

## 🔧 Management

### Deployment Script Commands
```bash
# Deploy complete homepage
./deploy_enhanced.sh deploy

# Show status
./deploy_enhanced.sh status

# View logs
./deploy_enhanced.sh logs

# Stop services
./deploy_enhanced.sh stop

# Start services
./deploy_enhanced.sh start

# Restart services
./deploy_enhanced.sh restart

# Update to latest version
./deploy_enhanced.sh update

# Create backup
./deploy_enhanced.sh backup

# Restore from backup
./deploy_enhanced.sh restore backup_file.tar.gz
```

### Health Monitoring
The homepage includes automated health monitoring:

```bash
# Run health check once
python3 scripts/health_monitor.py --once

# Start continuous monitoring
python3 scripts/health_monitor.py --interval 60

# Check specific service
python3 scripts/health_monitor.py --service sonarr
```

### Backup Management
```bash
# Create backup
python3 scripts/backup_manager.py create --name my_backup

# List backups
python3 scripts/backup_manager.py list

# Restore backup
python3 scripts/backup_manager.py restore backup_file.tar.gz

# Clean up old backups
python3 scripts/backup_manager.py cleanup --days 30
```

## 📊 Service Integration

### Infrastructure Services
- **Traefik**: Reverse proxy and load balancer monitoring
- **Authentik**: Identity provider and SSO integration
- **Portainer**: Container management and orchestration
- **Watchtower**: Automated container updates

### Monitoring Stack
- **Grafana**: Metrics dashboard and visualization
- **Prometheus**: Metrics collection and storage
- **AlertManager**: Alert management and routing
- **Loki**: Log aggregation and query
- **Uptime Kuma**: Uptime monitoring and status pages
- **Dashdot**: System dashboard and hardware monitoring

### Security Services
- **CrowdSec**: Intrusion detection and prevention
- **Fail2ban**: Intrusion prevention system
- **Pi-hole**: DNS ad blocker and network protection
- **UFW**: Uncomplicated firewall
- **WireGuard**: VPN server

### Media Stack
- **Jellyfin**: Media server and streaming
- **Sonarr**: TV show management and automation
- **Radarr**: Movie management and automation
- **Lidarr**: Music management and automation
- **Readarr**: Book management and automation
- **Prowlarr**: Indexer management
- **Bazarr**: Subtitle management
- **Tautulli**: Media statistics and analytics
- **Overseerr**: Media requests and discovery
- **SABnzbd**: Usenet downloader
- **qBittorrent**: Torrent client
- **Immich**: Photo management

### Automation Services
- **Home Assistant**: Home automation platform
- **Node-RED**: Flow-based programming
- **n8n**: Workflow automation
- **Zigbee2MQTT**: Zigbee bridge
- **Code Server**: Web-based VS Code
- **GitLab**: Git repository management
- **Harbor**: Container registry

### Storage Services
- **Nextcloud**: File storage and collaboration
- **Vaultwarden**: Password manager
- **Paperless**: Document management
- **MinIO**: Object storage
- **Filebrowser**: Web file manager
- **Bookstack**: Wiki and documentation

### Backup Services
- **Kopia**: Fast and secure backup
- **Duplicati**: Backup with encryption
- **Restic**: Fast and secure backups

### Utility Services
- **Tdarr**: Distributed media transcoding
- **Unmanic**: Media library optimizer
- **Requestrr**: Discord bot for media requests
- **Pulsarr**: ARR service status dashboard

## 🔐 Security

### API Key Encryption
All API keys are stored with AES-256 encryption:

```bash
# Keys are automatically encrypted when stored
python3 scripts/api_key_manager.py add service_name api_key

# Keys are decrypted when needed for service communication
```

### Access Control
- HTTPS enforcement with Let's Encrypt certificates
- API rate limiting
- Session timeout configuration
- IP whitelisting support

## 📈 Monitoring and Alerts

### Health Checks
- Automatic service health monitoring
- Response time tracking
- Status reporting to dashboard
- Alert integration with monitoring stack

### Metrics Collection
- System resource monitoring (CPU, memory, disk, network)
- Container health metrics
- Service response times
- Error rate tracking

## 🚨 Troubleshooting

### Common Issues

#### Homepage not accessible
```bash
# Check if containers are running
docker-compose ps

# Check logs
docker-compose logs homepage

# Check port binding
netstat -tlnp | grep 3000
```

#### API keys not working
```bash
# Test specific service
python3 scripts/api_key_manager.py test --service sonarr

# Regenerate configuration
python3 scripts/api_key_manager.py generate
```

#### Health monitoring not working
```bash
# Check systemd service status
sudo systemctl status homepage-health-monitor

# Check service logs
sudo journalctl -u homepage-health-monitor -f

# Test health check manually
python3 scripts/health_monitor.py --once
```

### Log Locations
- **Container logs**: `docker-compose logs`
- **Systemd logs**: `journalctl -u homepage-health-monitor`
- **Application logs**: `logs/` directory
- **Health status**: `config/health_status.json`

## 🔄 Updates and Maintenance

### Regular Maintenance
```bash
# Weekly backup
python3 scripts/backup_manager.py create --name weekly_backup

# Monthly cleanup
python3 scripts/backup_manager.py cleanup --days 30

# Update services
./deploy_enhanced.sh update
```

### Version Updates
```bash
# Pull latest images
docker-compose pull

# Restart with new images
docker-compose up -d

# Verify deployment
./deploy_enhanced.sh status
```

## 📚 Documentation

### Additional Resources
- [Homepage Documentation](https://gethomepage.dev)
- [Docker Documentation](https://docs.docker.com)
- [Traefik Documentation](https://doc.traefik.io)
- [Ansible Documentation](https://docs.ansible.com)

### Configuration Examples
- [Service Configuration Examples](docs/service-configuration-examples.md)
- [Widget Configuration Guide](docs/widget-configuration-guide.md)
- [Customization Guide](docs/customization-guide.md)
- [Security Hardening](docs/security-hardening.md)

## 🤝 Contributing

### Development Setup
```bash
# Clone repository
git clone <repository-url>
cd ansible_homelab/homepage

# Install development dependencies
pip3 install -r requirements-dev.txt

# Run tests
python3 -m pytest tests/

# Format code
black scripts/
isort scripts/
```

### Adding New Services
1. Add service definition to `config/services.yml`
2. Add widget configuration to `config/widgets.yml`
3. Update API key manager with service details
4. Test service integration
5. Update documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Homepage](https://github.com/benphelps/homepage) - The base homepage application
- [Traefik](https://traefik.io/) - Reverse proxy and load balancer
- [Docker](https://www.docker.com/) - Container platform
- [Ansible](https://www.ansible.com/) - Automation platform

---

**Note**: This homepage dashboard is designed for homelab environments. Ensure proper security measures are in place when exposing services to the internet. 