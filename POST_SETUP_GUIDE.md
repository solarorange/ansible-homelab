# 🎉 POST-SETUP GUIDE: Accessing Your Homelab Services

## 🚀 **Congratulations! Your Homelab is Ready**

After running the seamless setup script, your homelab is **production-ready** with **60+ services**, **zero port conflicts**, and **complete automation**. This guide shows you exactly how to access and use everything.

---

## 🔑 **Step 1: Access Your Main Dashboard**

### **Primary Access Point**
- **URL**: `https://dash.your-domain.com` (replace `your-domain.com` with your actual domain)
- **Default Credentials**: `admin` / (password from your vault configuration)
- **Purpose**: Beautiful, organized view of all 60+ services

### **What You'll See**
- **Service Status**: Real-time health of all services
- **Quick Access**: One-click access to any service
- **System Overview**: CPU, memory, disk usage
- **Recent Activity**: Latest system events

---

## 🛡️ **Step 2: Set Up Authentication (Authentik)**

### **Central Identity Provider**
- **URL**: `https://auth.your-domain.com`
- **Default Credentials**: `admin` / (password from your vault)
- **Purpose**: Single sign-on (SSO) for all your services

### **What's Pre-Configured**
- ✅ All services automatically registered
- ✅ SSO integration ready
- ✅ User management interface
- ✅ Security policies applied

---

## 📊 **Step 3: Access Key Management Services**

### **Container Management**
- **Portainer**: `https://portainer.your-domain.com`
  - Manage all Docker containers
  - Create during first login
  - Monitor container health

### **Monitoring & Observability**
- **Grafana**: `https://grafana.your-domain.com`
  - **Default**: `admin` / (vault password)
  - **Pre-configured dashboards**:
    - 🏠 Homelab Overview
    - 🐳 Docker Services
    - 🎬 Media Stack
    - 🛡️ Security Monitoring
    - 🌐 Network Infrastructure
    - 💾 Backup & Storage

- **Prometheus**: `https://prometheus.your-domain.com`
  - Metrics database
  - Service health monitoring

- **AlertManager**: `https://alerts.your-domain.com`
  - Alert management
  - 60+ pre-configured alerts

---

## 🎬 **Step 4: Configure Media Services**

### **Media Management (ARR Stack)**
- **Sonarr** (TV Shows): `https://sonarr.your-domain.com`
- **Radarr** (Movies): `https://radarr.your-domain.com`
- **Lidarr** (Music): `https://lidarr.your-domain.com`
- **Readarr** (Books): `https://readarr.your-domain.com`

### **Media Players**
- **Jellyfin**: `https://jellyfin.your-domain.com`
- **Plex**: `https://plex.your-domain.com`
- **Emby**: `https://emby.your-domain.com`

### **Media Processing**
- **Tdarr**: `https://tdarr.your-domain.com`
- **Unmanic**: `https://unmanic.your-domain.com`
- **Overseerr**: `https://overseerr.your-domain.com`

---

## 🛠️ **Step 5: Access Development & Automation Tools**

- **Code Server** (Web IDE): `https://code.your-domain.com`
- **GitLab**: `https://gitlab.your-domain.com`
- **n8n** (Workflow Automation): `https://n8n.your-domain.com`
- **Pezzo** (AI Development): `https://pezzo.your-domain.com`

---

## 📁 **Step 6: File & Document Management**

- **Nextcloud** (File Storage): `https://nextcloud.your-domain.com`
- **Paperless-ngx** (Document Management): `https://paperless.your-domain.com`
- **Bookstack** (Wiki): `https://bookstack.your-domain.com`
- **Linkwarden** (Bookmarks): `https://linkwarden.your-domain.com`

---

## 🔍 **Step 7: Network & Security Monitoring**

- **Reconya** (Network Discovery): `https://reconya.your-domain.com`
- **Fing** (Network Monitoring): `https://fing.your-domain.com`
- **Pi-hole** (DNS/Ad Blocking): `https://pihole.your-domain.com`
- **CrowdSec** (Intrusion Prevention): `https://crowdsec.your-domain.com`

---

## 🎯 **Complete Service Access List**

### **Core Infrastructure**
- **Traefik Dashboard**: `https://traefik.your-domain.com`
- **Authentik**: `https://auth.your-domain.com`
- **Homepage**: `https://dash.your-domain.com`
- **Portainer**: `https://portainer.your-domain.com`

### **Monitoring & Logging**
- **Grafana**: `https://grafana.your-domain.com`
- **Prometheus**: `https://prometheus.your-domain.com`
- **AlertManager**: `https://alerts.your-domain.com`
- **Loki**: `https://loki.your-domain.com`
- **Uptime Kuma**: `https://uptime.your-domain.com`

### **Media Services**
- **Jellyfin**: `https://jellyfin.your-domain.com`
- **Plex**: `https://plex.your-domain.com`
- **Emby**: `https://emby.your-domain.com`
- **Sonarr**: `https://sonarr.your-domain.com`
- **Radarr**: `https://radarr.your-domain.com`
- **Lidarr**: `https://lidarr.your-domain.com`
- **Readarr**: `https://readarr.your-domain.com`
- **Bazarr**: `https://bazarr.your-domain.com`
- **Tautulli**: `https://tautulli.your-domain.com`
- **Overseerr**: `https://overseerr.your-domain.com`

### **Download Services**
- **SABnzbd**: `https://sabnzbd.your-domain.com`
- **qBittorrent**: `https://qbittorrent.your-domain.com`
- **Transmission**: `https://transmission.your-domain.com`
- **Deluge**: `https://deluge.your-domain.com`

### **Development & Automation**
- **Code Server**: `https://code.your-domain.com`
- **GitLab**: `https://gitlab.your-domain.com`
- **n8n**: `https://n8n.your-domain.com`
- **Pezzo**: `https://pezzo.your-domain.com`
- **Harbor**: `https://harbor.your-domain.com`

### **Storage & Backup**
- **Nextcloud**: `https://nextcloud.your-domain.com`
- **Filebrowser**: `https://filebrowser.your-domain.com`
- **Syncthing**: `https://syncthing.your-domain.com`
- **Duplicati**: `https://duplicati.your-domain.com`
- **Kopia**: `https://kopia.your-domain.com`

### **Documentation & Knowledge**
- **Bookstack**: `https://bookstack.your-domain.com`
- **Paperless-ngx**: `https://paperless.your-domain.com`
- **Linkwarden**: `https://linkwarden.your-domain.com`

### **Security & Network**
- **Pi-hole**: `https://pihole.your-domain.com`
- **Reconya**: `https://reconya.your-domain.com`
- **Fing**: `https://fing.your-domain.com`
- **Vaultwarden**: `https://vaultwarden.your-domain.com`

### **Media Libraries**
- **Komga** (Comics): `https://komga.your-domain.com`
- **Audiobookshelf**: `https://audiobookshelf.your-domain.com`
- **Calibre** (Books): `https://calibre.your-domain.com`
- **Immich** (Photos): `https://immich.your-domain.com`

### **Utilities**
- **Requestrr**: `https://requestrr.your-domain.com`
- **ErsatzTV**: `https://ersatztv.your-domain.com`
- **Dumbassets**: `https://dumbassets.your-domain.com`
- **ROMM**: `https://romm.your-domain.com`

---

## 🔧 **Quick Verification Commands**

### **Check System Status**
```bash
# 1. Verify all services are running
docker ps

# 2. Check system resources
htop
df -h
free -h

# 3. Verify monitoring is active
docker ps | grep -E "(grafana|prometheus|loki|alertmanager)"

# 4. Check firewall status
sudo ufw status

# 5. Verify backups are scheduled
crontab -l | grep backup

# 6. Check SSL certificates
sudo certbot certificates
```

### **Check Service Health**
```bash
# View service logs
docker logs traefik
docker logs authentik
docker logs grafana

# Monitor network
netstat -tulpn

# Check service status
systemctl status docker
```

---

## 🎯 **What's Already Configured**

### **✅ Monitoring (100% Automated)**
- **6 comprehensive dashboards** ready to use
- **60+ alert rules** monitoring everything
- **Complete log aggregation** system
- **Performance metrics** collection
- **Service health monitoring**

### **✅ Security (100% Automated)**
- **Firewall rules** protecting your system
- **SSL certificates** auto-renewing
- **Authentication system** configured
- **Intrusion detection** active
- **Security monitoring** enabled

### **✅ Backup (100% Automated)**
- **Automated backup schedules** running
- **Database backups** daily at 2 AM
- **Configuration backups** daily at 3 AM
- **SSL certificate backups** daily at 4 AM
- **Full system backups** weekly on Sunday

### **✅ Networking (100% Automated)**
- **Reverse proxy** configured
- **Load balancing** active
- **SSL termination** enabled
- **Service discovery** working
- **Port conflict resolution** complete

---

## 🚀 **Next Steps & Configuration**

### **1. Initial Setup Tasks**
```bash
# Check all services are running
docker ps

# View system status
htop
df -h

# Check service logs if needed
docker logs <service-name>
```

### **2. Configure Media Services**
1. **Set up download clients** in Sonarr/Radarr
2. **Add media libraries** in Jellyfin/Plex
3. **Configure indexers** for content discovery

### **3. Set Up Monitoring (Optional Customization)**
1. **Access Grafana**: `https://grafana.your-domain.com`
2. **Review pre-configured dashboards**
3. **Add notification channels** (Discord, Slack, etc.)
4. **Adjust alert thresholds** if needed

### **4. Security Hardening (Optional)**
1. **Review firewall rules**: `sudo ufw status`
2. **Check backup schedules**: `crontab -l`
3. **Monitor SSL certificates**: `sudo certbot certificates`

---

## 🎉 **Pro Tips**

### **Getting Started**
1. **Start with the Homepage Dashboard** - it's your central hub
2. **Use Authentik for SSO** - one login for all services
3. **Monitor with Grafana** - keep an eye on system health
4. **Check the logs** - if something breaks, logs will help

### **Daily Operations**
1. **Check Homepage Dashboard** for service status
2. **Review Grafana dashboards** for system health
3. **Monitor alerts** in AlertManager
4. **Verify backups** are completing successfully

### **Troubleshooting**
1. **Check service logs**: `docker logs <service-name>`
2. **Validate deployment**: `ansible-playbook tasks/validate_services.yml --ask-vault-pass`
3. **Review documentation**: Check the `docs/` folder
4. **Check system resources**: `htop`, `df -h`, `docker ps`

---

## 🆘 **Need Help?**

### **Common Issues & Solutions**

#### **Issue: Services Won't Start**
```bash
# Check Docker status
systemctl status docker

# Check service logs
docker logs <service-name>

# Restart Docker
systemctl restart docker
```

#### **Issue: Domain Not Accessible**
```bash
# Check DNS propagation
nslookup your-domain.com

# Check firewall
ufw status
```

#### **Issue: SSL Certificate Problems**
```bash
# Check certificate status
sudo certbot certificates

# Renew certificates
sudo certbot renew
```

### **Getting Support**
1. **Check service logs** for error messages
2. **Review the troubleshooting guide** in `docs/TROUBLESHOOTING.md`
3. **Run validation playbook**: `ansible-playbook tasks/validate_services.yml --ask-vault-pass`
4. **Check GitHub issues** for known problems

---

## 🏠 **✨ External Server Integration**

### **Unify Your Entire Homelab Ecosystem**

**🚀 Seamlessly integrate external servers (Synology, Unraid, Proxmox, etc.) into your HomelabOS ecosystem!**

#### **Quick Integration**
```bash
# Interactive setup (recommended)
./scripts/integrate_server.sh

# Command line setup
./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000

# Configuration file setup
./scripts/integrate_server.sh --config config/external_servers.yml
```

#### **What Gets Integrated**
- ✅ **SSL Certificates** - Automatic Let's Encrypt certificates
- ✅ **DNS Management** - Automatic subdomain creation
- ✅ **Grafana Monitoring** - Custom dashboards for each server
- ✅ **Traefik Proxy** - Reverse proxy with authentication
- ✅ **Health Monitoring** - Automated health checks and alerting
- ✅ **Backup Integration** - Automated backup configuration
- ✅ **Homepage Integration** - Unified dashboard access

#### **Supported External Servers**
- **Storage**: Synology, TrueNAS, Unraid
- **Virtualization**: Proxmox, VMware ESXi
- **Home Automation**: Home Assistant, OpenHAB
- **Network**: Routers, Pi-hole, Firewalls
- **Security**: NVR systems, IP cameras
- **Development**: Git servers, CI/CD systems
- **Gaming**: Game servers, Steam servers

#### **Unified Access**
After integration, access all your servers at:
- **Homepage Dashboard**: `https://dash.your-domain.com`
- **Grafana Monitoring**: `https://grafana.your-domain.com`
- **Individual Servers**: `https://server-name.your-domain.com`

**📖 Complete Guide**: [External Server Integration Guide](docs/EXTERNAL_SERVER_INTEGRATION.md)

---

## 🎯 **Success Metrics**

### **✅ 100% Automation**
- Zero manual configuration required
- All services deploy automatically
- Port conflicts automatically resolved
- Security settings pre-configured

### **✅ 100% Security**
- All secrets vault-managed
- SSL/TLS encryption enabled
- Network segmentation implemented
- Intrusion detection active

### **✅ 100% Monitoring**
- All services monitored
- Metrics collection active
- Log aggregation enabled
- Alerting configured

### **✅ 100% Production Ready**
- Turnkey deployment
- Zero conflicts guaranteed
- Comprehensive documentation
- Public-ready codebase

---

## 🏆 **You're All Set!**

Your homelab is now **production-ready** with:
- **60+ services** across 8 categories
- **Zero port conflicts** guaranteed
- **Complete automation** from deployment to monitoring
- **Enterprise-grade security** and monitoring
- **Turnkey operation** - just access and use!

**Start exploring your services at**: `https://dash.your-domain.com`

---

*This guide covers everything you need to know after running the seamless setup. Your homelab is ready for production use! 🚀* 