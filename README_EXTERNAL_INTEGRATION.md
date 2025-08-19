# External Server Integration for HomelabOS

## 🚀 Quick Start

Integrate external servers (like Synology, Unraid, Proxmox) into your HomelabOS ecosystem with SSL certificates, monitoring, and unified management.

### **Interactive Setup (Recommended)**
```bash
./scripts/integrate_server.sh
```

### **Command Line Setup**
```bash
./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000
```

### **Configuration File Setup**
```bash
./scripts/integrate_server.sh --config config/external_servers.yml
```

## ✨ What It Does

- **SSL Certificates**: Automatic Let's Encrypt certificates
- **DNS Management**: Automatic subdomain creation
- **Grafana Monitoring**: Custom dashboards for each server
- **Traefik Proxy**: Reverse proxy with authentication
- **Health Monitoring**: Automated health checks
- **Backup Integration**: Automated backup configuration
- **Homepage Integration**: Unified dashboard access

## 📋 Supported Servers

- **Storage**: Synology, TrueNAS, Unraid
- **Virtualization**: Proxmox, VMware ESXi
- **Home Automation**: Home Assistant, OpenHAB
- **Network**: Routers, Pi-hole, Firewalls
- **Security**: NVR systems, IP cameras
- **Development**: Git servers, CI/CD systems
- **Gaming**: Game servers, Steam servers

## 🔧 Configuration

Edit `config/external_servers.yml` to customize:
- Server IP addresses and ports
- Subdomain names
- Authentication methods
- Monitoring settings
- Backup schedules
- SSL configuration

## 📊 Monitoring

Access your integrated servers at:
- **Homepage Dashboard**: `https://dash.yourdomain.com`
- **Grafana Monitoring**: `https://grafana.yourdomain.com`
- **Traefik Dashboard**: `https://traefik.yourdomain.com`

## 📚 Documentation

See `docs/EXTERNAL_SERVER_INTEGRATION.md` for complete documentation.

---

**Happy Homelabbing! 🏠** 