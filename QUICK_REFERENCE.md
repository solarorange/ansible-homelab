# 🚀 Quick Reference Card

## 🎯 **Essential Access URLs**

### **Primary Dashboards**
- **🏠 Homepage Dashboard**: `https://dash.your-domain.com`
- **🔐 Authentik (SSO)**: `https://auth.your-domain.com`
- **📊 Grafana**: `https://grafana.your-domain.com`
- **🐳 Portainer**: `https://portainer.your-domain.com`

### **Media Services**
- **🎬 Jellyfin**: `https://jellyfin.your-domain.com`
- **📺 Plex**: `https://plex.your-domain.com`
- **📺 Sonarr**: `https://sonarr.your-domain.com`
- **🎬 Radarr**: `https://radarr.your-domain.com`
- **🎵 Lidarr**: `https://lidarr.your-domain.com`

### **Development Tools**
- **💻 Code Server**: `https://code.your-domain.com`
- **🔧 GitLab**: `https://gitlab.your-domain.com`
- **🤖 n8n**: `https://n8n.your-domain.com`
- **🧠 Pezzo**: `https://pezzo.your-domain.com`

### **Storage & Files**
- **☁️ Nextcloud**: `https://nextcloud.your-domain.com`
- **📁 Filebrowser**: `https://filebrowser.your-domain.com`
- **📚 Bookstack**: `https://bookstack.your-domain.com`
- **📄 Paperless**: `https://paperless.your-domain.com`

## 🔧 **Quick Commands**

### **System Status**
```bash
# Check all services
docker ps

# System resources
htop
df -h

# Service logs
docker logs <service-name>
```

### **Monitoring**
```bash
# Check monitoring stack
docker ps | grep -E "(grafana|prometheus|loki)"

# Firewall status
sudo ufw status

# SSL certificates
sudo certbot certificates
```

## 🆘 **Troubleshooting**

### **Service Won't Start**
```bash
# Check Docker
systemctl status docker

# Restart service
docker restart <service-name>

# View logs
docker logs <service-name>
```

### **Domain Not Accessible**
```bash
# Check DNS
nslookup your-domain.com

# Check firewall
ufw status
```

## 📖 **Full Documentation**

- **📋 [POST_SETUP_GUIDE.md](POST_SETUP_GUIDE.md)** - Complete guide to all services
- **🚀 [QUICK_START_GUIDE.md](QUICK_START_GUIDE.md)** - Initial setup guide
- **🔧 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Troubleshooting guide

---

**💡 Pro Tip**: Start with the Homepage Dashboard at `https://dash.your-domain.com` - it's your central hub for all services! 