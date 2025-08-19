# External Server Integration Guide

## Overview

The External Server Integration system allows you to seamlessly integrate external servers (like Synology NAS, Unraid, Proxmox, etc.) into your HomelabOS ecosystem. This provides unified SSL certificate management, monitoring, DNS configuration, and security integration.

## 🚀 **What It Does**

### **Core Features**
- **SSL Certificate Management**: Automatic Let's Encrypt certificates for external servers
- **DNS Configuration**: Automatic subdomain creation via Cloudflare API
- **Grafana Monitoring**: Dashboard integration for external servers
- **Traefik Proxy**: Reverse proxy configuration with authentication
- **Health Monitoring**: Automated health checks and alerting
- **Backup Integration**: Automated backup configuration
- **Homepage Integration**: Add external servers to your dashboard

### **Supported Server Types**
- **Storage Servers**: Synology, TrueNAS, Unraid
- **Virtualization**: Proxmox, VMware ESXi
- **Home Automation**: Home Assistant, OpenHAB
- **Network Devices**: Routers, Pi-hole, Firewalls
- **Security**: NVR systems, IP cameras
- **Development**: Git servers, CI/CD systems
- **Gaming**: Game servers, Steam servers

## 📋 **Quick Start**

### **1. Interactive Setup (Recommended)**
```bash
# Run the interactive setup
./scripts/integrate_server.sh
```

This will guide you through:
- Server details (name, IP, port)
- Subdomain configuration
- SSL certificate setup
- Authentication options
- Monitoring configuration
- Backup settings

### **2. Command Line Setup**
```bash
# Integrate a single server
./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000

# With custom subdomain
./scripts/integrate_server.sh --name nas --ip 192.168.1.100 --port 5000 --subdomain storage

# With authentication and monitoring
./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000 --auth --monitoring --backup
```

### **3. Configuration File Setup**
```bash
# Create configuration file
cp config/external_servers.yml my_servers.yml

# Edit the configuration
nano my_servers.yml

# Integrate all servers
./scripts/integrate_server.sh --config my_servers.yml
```

## 🔧 **Configuration Examples**

### **Synology NAS Integration**
```yaml
servers:
  - name: "synology"
    ip_address: "192.168.1.100"
    port: 5000
    subdomain: "nas"
    description: "Synology NAS - File Storage and Media Server"
    category: "storage"
    ssl_enabled: true
    auth_enabled: true
    monitoring_enabled: true
    backup_enabled: true
    ssl_email: "admin@yourdomain.com"
    auth_method: "authentik"
    health_check_path: "/webapi/entry.cgi"
    health_check_timeout: 15
    backup_paths:
      - "/volume1/homes"
      - "/volume1/shared"
    backup_schedule: "0 2 * * *"
```

### **Proxmox Virtualization Server**
```yaml
servers:
  - name: "proxmox"
    ip_address: "192.168.1.102"
    port: 8006
    protocol: "https"
    subdomain: "proxmox"
    description: "Proxmox VE - Virtualization Platform"
    category: "virtualization"
    ssl_enabled: true
    auth_enabled: true
    monitoring_enabled: true
    backup_enabled: false
    ssl_email: "admin@yourdomain.com"
    auth_method: "authentik"
    health_check_path: "/api2/json/version"
    health_check_timeout: 15
```

### **Home Assistant Automation**
```yaml
servers:
  - name: "homeassistant"
    ip_address: "192.168.1.104"
    port: 8123
    protocol: "http"
    subdomain: "home"
    description: "Home Assistant - Home Automation"
    category: "automation"
    ssl_enabled: true
    auth_enabled: true
    monitoring_enabled: true
    backup_enabled: true
    ssl_email: "admin@yourdomain.com"
    auth_method: "authentik"
    health_check_path: "/api/"
    health_check_timeout: 10
    backup_paths:
      - "/config"
    backup_schedule: "0 4 * * *"
```

## 🔐 **Security Features**

### **Authentication Options**
- **None**: No authentication required
- **Basic**: Username/password authentication
- **Authentik**: Integration with your Authentik SSO

### **SSL/TLS Security**
- Automatic Let's Encrypt certificate generation
- Certificate renewal monitoring
- SSL security headers
- OCSP stapling
- Certificate transparency monitoring

### **Access Control**
- Rate limiting per service
- IP whitelisting
- Security headers
- Session management
- Failed login protection

## 📊 **Monitoring Integration**

### **Grafana Dashboards**
Each integrated server gets:
- **Status Panel**: Server up/down status
- **Response Time Graph**: Performance monitoring
- **Custom Metrics**: Service-specific metrics
- **Alerting**: Configurable alerts

### **Health Checks**
- **HTTP Health Checks**: Web service monitoring
- **TCP Port Checks**: Network service monitoring
- **Custom Endpoints**: API health checks
- **Response Time Monitoring**: Performance tracking

### **Alerting**
- **Server Down Alerts**: Immediate notification
- **High Response Time**: Performance warnings
- **SSL Certificate Expiration**: Security alerts
- **Backup Failure Alerts**: Data protection

## 💾 **Backup Integration**

### **Automated Backups**
- **Scheduled Backups**: Configurable schedules
- **Encrypted Backups**: GPG encryption
- **Compression**: Automatic compression
- **Retention Policies**: Configurable retention

### **Backup Types**
- **File System Backups**: Directory backups
- **Database Backups**: Database dumps
- **Configuration Backups**: Config files
- **Incremental Backups**: Efficient storage

## 🌐 **DNS Management**

### **Automatic DNS Records**
- **Subdomain Creation**: Automatic subdomain setup
- **Cloudflare Integration**: API-driven DNS management
- **Record Validation**: DNS propagation checking
- **SSL Certificate Validation**: DNS challenge support

### **Supported DNS Providers**
- **Cloudflare**: Full API integration
- **Manual DNS**: Manual record creation
- **Other Providers**: Extensible for other providers

## 🔄 **Integration Process**

### **Step-by-Step Integration**
1. **DNS Record Creation**: Creates subdomain DNS record
2. **SSL Certificate Generation**: Obtains Let's Encrypt certificate
3. **Traefik Proxy Configuration**: Sets up reverse proxy
4. **Grafana Dashboard Creation**: Adds monitoring dashboard
5. **Health Check Configuration**: Sets up monitoring
6. **Backup Script Generation**: Creates backup automation
7. **Homepage Integration**: Adds to dashboard

### **Integration Reports**
Each integration generates a detailed report:
```json
{
  "server": {
    "name": "synology",
    "ip_address": "192.168.1.100",
    "port": 5000,
    "subdomain": "nas"
  },
  "integration_time": "2024-01-15T10:30:00",
  "results": {
    "dns": true,
    "ssl": true,
    "proxy": true,
    "monitoring": true,
    "health_check": true,
    "backup": true,
    "homepage": true
  },
  "summary": {
    "total_steps": 7,
    "successful_steps": 7,
    "failed_steps": 0
  }
}
```

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **SSL Certificate Issues**
```bash
# Check certificate status
docker exec traefik traefik cert info

# Renew certificates manually
docker exec traefik traefik cert renew

# Check certificate expiration
openssl x509 -in /etc/traefik/certs/nas.yourdomain.com.crt -text -noout | grep "Not After"
```

#### **DNS Issues**
```bash
# Check DNS propagation
dig nas.yourdomain.com

# Test DNS resolution
nslookup nas.yourdomain.com

# Check Cloudflare API
curl -X GET "https://api.cloudflare.com/client/v4/zones" \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

#### **Monitoring Issues**
```bash
# Check Prometheus targets
curl http://prometheus:9090/api/v1/targets

# Check Grafana API
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://grafana:3000/api/dashboards
```

### **Log Files**
- **Integration Logs**: `/var/log/homelab/external_integration.log`
- **Traefik Logs**: `docker logs traefik`
- **Grafana Logs**: `docker logs grafana`
- **Prometheus Logs**: `docker logs prometheus`

## 📚 **Advanced Configuration**

### **Custom Health Checks**
```yaml
servers:
  - name: "custom_server"
    health_check_path: "/api/health"
    health_check_timeout: 30
    metrics_endpoint: "/metrics"
```

### **Custom Authentication**
```yaml
servers:
  - name: "secure_server"
    auth_method: "authentik"
    auth_config:
      provider: "authentik"
      auth_url: "https://auth.yourdomain.com/outpost.goauthentik.io/auth/traefik"
```

### **Custom Backup Scripts**
```yaml
servers:
  - name: "database_server"
    backup_enabled: true
    backup_paths:
      - "/var/lib/mysql"
      - "/etc/mysql"
    backup_script: "custom_backup.sh"
```

## 🔧 **Maintenance**

### **Regular Maintenance Tasks**
```bash
# Check integration status
./scripts/integrate_server.sh --status

# Update SSL certificates
./scripts/integrate_server.sh --renew-certs

# Test all integrations
./scripts/integrate_server.sh --test-all

# Clean up old backups
./scripts/integrate_server.sh --cleanup
```

### **Monitoring Dashboard**
Access your integrated servers at:
- **Homepage Dashboard**: `https://dash.yourdomain.com`
- **Grafana Monitoring**: `https://grafana.yourdomain.com`
- **Traefik Dashboard**: `https://traefik.yourdomain.com`

## 🎯 **Best Practices**

### **Security**
- Always enable SSL for external access
- Use Authentik for authentication when possible
- Regularly rotate API keys and passwords
- Monitor SSL certificate expiration
- Enable rate limiting for all services

### **Performance**
- Use appropriate health check timeouts
- Configure monitoring intervals based on service criticality
- Enable compression for web services
- Use caching where appropriate

### **Reliability**
- Test integrations before production use
- Monitor backup success rates
- Set up alerting for critical services
- Regular health check validation

### **Documentation**
- Document custom configurations
- Maintain integration reports
- Update server information regularly
- Keep backup schedules documented

## 🚀 **Future Enhancements**

### **Planned Features**
- **Kubernetes Integration**: Native K8s service discovery
- **Multi-Cluster Support**: Manage multiple homelab clusters
- **Advanced Monitoring**: Custom metrics and dashboards
- **Automated Remediation**: Self-healing capabilities
- **Mobile App Integration**: Mobile monitoring and control

### **Community Contributions**
- **Custom Health Checks**: Community health check templates
- **Server Templates**: Pre-configured server configurations
- **Monitoring Dashboards**: Community Grafana dashboards
- **Backup Strategies**: Advanced backup configurations

---

## 📞 **Support**

For issues or questions:
1. Check the troubleshooting section above
2. Review integration logs in `/var/log/homelab/`
3. Check the HomelabOS documentation
4. Create an issue in the project repository

**Happy Homelabbing! 🏠** 