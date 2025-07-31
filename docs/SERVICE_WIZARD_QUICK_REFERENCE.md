# 🚀 Service Integration Wizard - Quick Reference

## ⚡ **Quick Commands**

### **Interactive Mode (Recommended)**
```bash
./scripts/add_service.sh
```

### **Non-Interactive Mode**
```bash
python3 scripts/service_wizard.py --service-name "jellyfin" --repository-url "https://github.com/jellyfin/jellyfin"
```

## 📋 **Service Information**

| Field | Example | Description |
|-------|---------|-------------|
| **Service Name** | `jellyfin` | Lowercase, no spaces, used for domain |
| **Repository URL** | `https://github.com/jellyfin/jellyfin` | GitHub/GitLab repository |
| **Display Name** | `Jellyfin Media Server` | Name shown in homepage |
| **Description** | `Modern media solution` | Brief description |

## 📂 **Service Categories**

| Category | Examples | Use Case |
|----------|----------|----------|
| **media** | Plex, Jellyfin, Sonarr, Radarr | Media streaming and management |
| **automation** | Home Assistant, Node-RED, n8n | Automation and orchestration |
| **utilities** | Homepage, Grafana, Portainer | Utility and helper services |
| **security** | Authentik, Fail2ban, WireGuard | Security and authentication |
| **databases** | PostgreSQL, Redis, MariaDB | Database services |
| **storage** | Nextcloud, Syncthing, Samba | Storage and file management |
| **monitoring** | Prometheus, Grafana, Loki | Monitoring and observability |

## 🚀 **Deployment Stages**

| Stage | Examples | When to Use |
|-------|----------|-------------|
| **stage1** | Traefik, Authentik, Pi-hole | Infrastructure (deploys first) |
| **stage2** | PostgreSQL, Redis, Prometheus | Core services (depends on infrastructure) |
| **stage3** | Plex, Jellyfin, Home Assistant | Applications (depends on core services) |
| **stage3.5** | Homepage, Uptime Kuma | Dashboard and management (depends on applications) |

## 🔧 **Generated Integration**

### **What the Wizard Creates**
- ✅ **Complete Ansible role** with all required files
- ✅ **Docker Compose** with Traefik integration
- ✅ **Monitoring** (Prometheus, Grafana dashboards)
- ✅ **Security** (fail2ban, access controls)
- ✅ **Backup** (automated scripts with retention)
- ✅ **Homepage** (service registration and status)
- ✅ **Alerting** (Prometheus alert rules)

### **What Gets Updated**
- ✅ `group_vars/all/roles.yml` - Service enablement
- ✅ `site.yml` - Role added to correct stage
- ✅ Port conflict detection and validation

## 🚀 **Deployment Steps**

### **1. Review Generated Configuration**
```bash
nano roles/{service}/defaults/main.yml
nano roles/{service}/templates/docker-compose.yml.j2
```

### **2. Deploy the Service**
```bash
# Validate first
ansible-playbook site.yml --tags {service} --check

# Deploy
ansible-playbook site.yml --tags {service}
```

### **3. Access Your Service**
```bash
# URL
https://{service}.yourdomain.com

# Check logs
docker logs {service}

# Monitor health
docker ps | grep {service}
```

## 💡 **Pro Tips**

### **Before Running Wizard**
- ✅ **Backup your configuration**: `git add . && git commit -m "Backup"`
- ✅ **Check available ports**: `python3 scripts/check_port_conflicts.py`
- ✅ **Review existing services**: `ls roles/`

### **After Running Wizard**
- ✅ **Review generated files** before deployment
- ✅ **Test with --check flag** first
- ✅ **Monitor logs** after deployment
- ✅ **Verify homepage integration**

### **Troubleshooting**
- **Port conflicts**: Edit `roles/{service}/defaults/main.yml`
- **Template errors**: Re-run wizard or check file permissions
- **Integration failures**: Check validation output

## 📖 **Full Documentation**

For complete details, examples, and troubleshooting:
**[Service Integration Wizard Guide](SERVICE_INTEGRATION_WIZARD.md)**

---

**🎉 Happy Service Adding!** 