# Enhanced Homepage Dashboard for Ansible Homelab

A comprehensive, production-ready homepage dashboard for managing and monitoring a complete homelab infrastructure. This enhanced version includes dynamic service discovery, real-time health monitoring, advanced widgets, and beautiful visual design.

## 🚀 Features

### Core Features
- **Complete Service Coverage**: All homelab services organized into logical categories
- **Dynamic Service Discovery**: Automatic detection and configuration of new services
- **Real-time Health Monitoring**: Live status monitoring with response times and metrics
- **Advanced Widgets**: Functional widgets for each service with metrics and quick actions
- **Beautiful UI**: Modern, responsive design with custom CSS and animations
- **Service Grouping**: Logical organization with custom styling for each category
- **Quick Actions**: Direct access to service logs, restart, and configuration

### Service Categories
1. **Infrastructure & Management** - Traefik, Authentik, Portainer, Watchtower
2. **Monitoring & Observability** - Grafana, Prometheus, Loki, AlertManager, Uptime Kuma
3. **Security & Network** - CrowdSec, Fail2ban, Pi-hole, UFW, WireGuard
4. **Databases & Storage** - PostgreSQL, MariaDB, Redis, Elasticsearch, Nextcloud
5. **Media Stack** - Jellyfin, Sonarr, Radarr, Lidarr, Readarr, Prowlarr, Bazarr
6. **Automation & Development** - Home Assistant, Node-RED, n8n, Code Server
7. **Backup & Recovery** - Kopia, Duplicati, Restic
8. **Utilities & Tools** - Tdarr, Unmanic, Requestrr, MinIO, Filebrowser
9. **External Resources** - GitHub, Documentation, Status Pages

## 📁 File Structure

```
homepage/
├── config/
│   ├── config.yml              # Main configuration
│   ├── services.yml            # Service definitions
│   ├── bookmarks.yml           # Bookmark organization
│   ├── custom.css              # Enhanced styling
│   ├── docker.yml              # Docker configuration
│   └── settings.yml            # Additional settings
├── scripts/
│   ├── service_discovery.py    # Dynamic service discovery
│   ├── health_monitor.py       # Health monitoring
│   └── homepage-health-monitor.service  # Systemd service
└── README_ENHANCED.md          # This documentation
```

## 🛠️ Installation & Setup

### Prerequisites
- Docker and Docker Compose
- Python 3.8+ (for monitoring scripts)
- Ansible 2.9+ (for deployment)

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone <your-repo>
   cd ansible_homelab/homepage
   ```

2. **Configure environment**:
   ```bash
   cp env.example .env
   # Edit .env with your domain and API keys
   ```

3. **Deploy with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

4. **Install monitoring dependencies**:
   ```bash
   pip install docker requests pyyaml aiohttp
   ```

5. **Enable health monitoring**:
   ```bash
   sudo cp scripts/homepage-health-monitor.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable homepage-health-monitor
   sudo systemctl start homepage-health-monitor
   ```

## ⚙️ Configuration

### Main Configuration (`config.yml`)

The main configuration file includes:
- Dashboard title and description
- Theme and layout settings
- Widget configuration
- Weather and search settings
- System monitoring configuration

```yaml
title: Homelab Dashboard
description: Enhanced Homelab Infrastructure Dashboard
theme: dark
layout: default

# Widget configuration
widgets:
  - resources
  - system
  - docker
  - weather
  - calendar
  # ... more widgets

# Weather configuration
weather:
  label: Weather
  latitude: 40.7128
  longitude: -74.0060
  units: metric
  provider: openweathermap
  apiKey: your_openweathermap_api_key
```

### Service Configuration (`services.yml`)

Services are organized into groups with comprehensive configuration:

```yaml
- group: Infrastructure & Management
  icon: settings.png
  className: infrastructure-stack
  items:
    - Traefik:
        icon: traefik.png
        href: https://traefik.{{ domain }}
        description: Reverse Proxy & Load Balancer
        widget:
          type: traefik
          url: http://traefik:8080
          key: your_traefik_api_key
        health:
          url: http://traefik:8080/ping
          interval: 30
        auth:
          type: api_key
```

### Custom Styling (`custom.css`)

Enhanced CSS with:
- Modern color scheme and gradients
- Responsive design
- Smooth animations
- Service group theming
- Status indicators
- Accessibility features

## 🔍 Dynamic Service Discovery

The service discovery script automatically detects running services:

### Features
- **Docker Container Scanning**: Detects services running in Docker containers
- **Network Port Scanning**: Identifies services by scanning common ports
- **Health Check Integration**: Verifies service availability
- **Automatic Configuration**: Updates `services.yml` with discovered services

### Usage

```bash
# Run service discovery
python3 scripts/service_discovery.py

# Run with custom config directory
python3 scripts/service_discovery.py --config-dir /path/to/config

# Run discovery and exit
python3 scripts/service_discovery.py --once
```

### Service Detection Logic

1. **Docker Discovery**:
   - Scans running containers
   - Matches container names to known services
   - Extracts container IP addresses
   - Verifies service health endpoints

2. **Network Discovery**:
   - Scans common service ports
   - Attempts HTTP requests to identify services
   - Validates service responses

3. **Configuration Generation**:
   - Creates service entries with proper widgets
   - Sets up health monitoring
   - Organizes services into groups

## 📊 Health Monitoring

Real-time health monitoring with comprehensive metrics:

### Features
- **Concurrent Health Checks**: Monitors all services simultaneously
- **Response Time Tracking**: Measures service response times
- **Status Classification**: Online, offline, warning, unknown
- **Metrics Collection**: Uptime, version, performance data
- **JSON Output**: Structured data for integration

### Usage

```bash
# Run health monitoring once
python3 scripts/health_monitor.py --once

# Run continuous monitoring
python3 scripts/health_monitor.py --interval 60

# Run with custom config directory
python3 scripts/health_monitor.py --config-dir /path/to/config
```

### Health Data Output

The monitoring script generates two JSON files:

1. **`health_status.json`**: Detailed health data for each service
2. **`health_summary.json`**: Aggregated summary with statistics

Example summary:
```json
{
  "summary": {
    "total_services": 25,
    "online_services": 23,
    "offline_services": 2,
    "warning_services": 0,
    "unknown_services": 0,
    "uptime_percentage": 92.0,
    "average_response_time": 0.15,
    "last_updated": "2024-01-15T10:30:00"
  },
  "by_status": {
    "online": ["traefik", "grafana", "jellyfin", ...],
    "offline": ["service1", "service2"],
    "warning": [],
    "unknown": []
  },
  "by_group": {
    "Infrastructure & Management": [
      {
        "name": "traefik",
        "status": "online",
        "response_time": 0.05
      }
    ]
  }
}
```

## 🎨 Customization

### Adding New Services

1. **Define Service Configuration**:
   ```yaml
   - NewService:
       icon: newservice.png
       href: https://newservice.{{ domain }}
       description: New Service Description
       widget:
         type: newservice
         url: http://newservice:8080
         key: your_newservice_api_key
       health:
         url: http://newservice:8080/health
         interval: 30
       auth:
         type: api_key
   ```

2. **Add to Service Discovery**:
   ```python
   'newservice': {
       'port': 8080,
       'health_path': '/health',
       'widget_type': 'newservice',
       'group': 'Your Group',
       'className': 'your-group-stack'
   }
   ```

3. **Create Custom Widget** (if needed):
   - Add widget type to Homepage
   - Implement widget functionality
   - Add to widget configuration

### Custom CSS Styling

Add custom styles for new service groups:

```css
.your-group-stack {
  background: linear-gradient(135deg, rgba(255, 0, 0, 0.1) 0%, rgba(0, 255, 0, 0.1) 100%);
  border-color: rgba(255, 0, 0, 0.3);
}

.your-group-stack::before {
  background: linear-gradient(90deg, #ff0000, #00ff00);
}
```

### Widget Customization

Customize widgets for specific services:

```yaml
widget:
  type: custom_widget
  url: http://service:port
  key: your_api_key
  options:
    refresh_interval: 30
    show_metrics: true
    custom_parameters:
      param1: value1
      param2: value2
```

## 🔧 Maintenance

### Regular Tasks

1. **Update Service Discovery**:
   ```bash
   # Run service discovery to detect new services
   python3 scripts/service_discovery.py
   ```

2. **Monitor Health Status**:
   ```bash
   # Check health monitoring logs
   sudo journalctl -u homepage-health-monitor -f
   
   # View health summary
   cat config/health_summary.json
   ```

3. **Backup Configuration**:
   ```bash
   # Backup configuration files
   tar -czf homepage-config-backup-$(date +%Y%m%d).tar.gz config/
   ```

### Troubleshooting

#### Service Discovery Issues
- Check Docker daemon status
- Verify network connectivity
- Review service discovery logs
- Ensure proper permissions

#### Health Monitoring Issues
- Check Python dependencies
- Verify service endpoints
- Review monitoring logs
- Check systemd service status

#### Widget Issues
- Verify API keys and endpoints
- Check service authentication
- Review widget configuration
- Test service connectivity

## 📈 Performance Optimization

### Resource Usage
- **Memory**: ~100MB for homepage + ~50MB for monitoring
- **CPU**: Minimal usage, peaks during health checks
- **Network**: Low bandwidth for health checks
- **Storage**: ~10MB for configuration and logs

### Optimization Tips
1. **Adjust Health Check Intervals**: Increase intervals for stable services
2. **Limit Concurrent Checks**: Reduce load during peak times
3. **Use Caching**: Cache health results for frequently checked services
4. **Optimize Widgets**: Disable unnecessary widgets for better performance

## 🔒 Security Considerations

### Access Control
- Use API keys for service authentication
- Implement proper firewall rules
- Restrict access to monitoring endpoints
- Use HTTPS for all external access

### Data Protection
- Encrypt sensitive configuration data
- Secure API keys and tokens
- Implement proper logging
- Regular security updates

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Testing
```bash
# Test service discovery
python3 scripts/service_discovery.py --once

# Test health monitoring
python3 scripts/health_monitor.py --once

# Test configuration
python3 -c "import yaml; yaml.safe_load(open('config/services.yml'))"
```

## 📚 Additional Resources

### Documentation
- [Homepage Documentation](https://gethomepage.dev)
- [Docker Documentation](https://docs.docker.com)
- [Ansible Documentation](https://docs.ansible.com)

### Community
- [Reddit r/homelab](https://reddit.com/r/homelab)
- [Reddit r/selfhosted](https://reddit.com/r/selfhosted)
- [Discord Homelab](https://discord.gg/homelab)

### Support
- Create an issue on GitHub
- Check the troubleshooting section
- Review logs for error messages
- Test with minimal configuration

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Homepage](https://github.com/gethomepage/homepage) - The base dashboard
- [Ansible](https://www.ansible.com) - Automation framework
- [Docker](https://www.docker.com) - Container platform
- The homelab community for inspiration and feedback

---

**Note**: This enhanced homepage dashboard is designed for production use in homelab environments. Always test thoroughly in your specific environment and ensure proper security measures are in place. 