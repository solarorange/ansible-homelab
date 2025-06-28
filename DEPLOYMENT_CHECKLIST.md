# ✅ Deployment Checklist

This checklist ensures a successful deployment of your Ansible Homelab. Follow each step in order and check off items as you complete them.

## 📋 **Pre-Deployment Checklist**

### System Requirements
- [ ] **Server**: Ubuntu 20.04+ / Debian 11+ / CentOS 8+
- [ ] **Hardware**: 8GB+ RAM, 100GB+ storage, 4+ CPU cores
- [ ] **Network**: Static IP address configured
- [ ] **Domain**: Domain name with DNS access
- [ ] **SSH Access**: SSH key or password access to server

### Server Preparation
- [ ] **System Updated**: `apt update && apt upgrade -y`
- [ ] **Essential Packages**: curl, wget, git, python3, python3-pip installed
- [ ] **Ansible Installed**: `apt install ansible`
- [ ] **Docker Installed**: Using official Docker installation script
- [ ] **User Permissions**: User added to docker group
- [ ] **Firewall**: UFW installed and configured (optional)

### Network Configuration
- [ ] **Static IP**: Server has static IP address
- [ ] **DNS Records**: Domain DNS configured to point to server IP
- [ ] **Ports Open**: Ports 80, 443, 22 accessible
- [ ] **Cloudflare**: Domain added to Cloudflare (recommended)
- [ ] **SSL/TLS**: Cloudflare SSL/TLS set to "Full" or "Full (strict)"

## 🚀 **Deployment Steps**

### Step 1: Project Setup
- [ ] **Repository Cloned**: `git clone https://github.com/yourusername/ansible_homelab.git`
- [ ] **Directory Changed**: `cd ansible_homelab`
- [ ] **Scripts Executable**: `chmod +x scripts/*.sh`
- [ ] **Setup Script Run**: `./scripts/setup_environment.sh`
- [ ] **Configuration Reviewed**: `.env` file contains correct values

### Step 2: Environment Configuration
- [ ] **Domain Name**: Set in `.env` file
- [ ] **Server IP**: Set in `.env` file
- [ ] **Timezone**: Set in `.env` file
- [ ] **Username**: Set in `.env` file
- [ ] **Network Settings**: Gateway, DNS, subnet configured
- [ ] **Cloudflare Settings**: API token and email configured (if using)
- [ ] **SMTP Settings**: Configured (optional)
- [ ] **Passwords Generated**: All service passwords generated

### Step 3: Vault Configuration
- [ ] **Vault Template Created**: `group_vars/all/vault_template.yml` exists
- [ ] **Vault File Created**: `cp group_vars/all/vault_template.yml group_vars/all/vault.yml`
- [ ] **Vault Encrypted**: `ansible-vault encrypt group_vars/all/vault.yml`
- [ ] **Vault Password**: Vault password securely stored
- [ ] **Vault Tested**: Can decrypt vault file

### Step 4: DNS Configuration
- [ ] **A Records**: All service subdomains point to server IP
  - [ ] `@` → Server IP
  - [ ] `traefik` → Server IP
  - [ ] `auth` → Server IP
  - [ ] `grafana` → Server IP
  - [ ] `sonarr` → Server IP
  - [ ] `radarr` → Server IP
  - [ ] `jellyfin` → Server IP
  - [ ] `overseerr` → Server IP
- [ ] **DNS Propagation**: DNS changes propagated (can take up to 48 hours)
- [ ] **DNS Test**: `nslookup your-domain.com` returns correct IP

### Step 5: Pre-flight Checks
- [ ] **Connectivity Test**: `ansible all -m ping` successful
- [ ] **Configuration Check**: `ansible-playbook site.yml --check --ask-vault-pass`
- [ ] **Syntax Check**: `ansible-playbook site.yml --syntax-check`
- [ ] **Inventory Valid**: `ansible-inventory --list` shows correct hosts

### Step 6: Infrastructure Deployment
- [ ] **Security Setup**: Firewall, SSH hardening, security tools
- [ ] **Docker Setup**: Docker installation and configuration
- [ ] **Network Setup**: Docker networks and routing
- [ ] **Directory Structure**: All required directories created
- [ ] **Permissions**: Correct file and directory permissions

### Step 7: Core Services Deployment
- [ ] **Authentication**: Authentik identity provider deployed
- [ ] **Reverse Proxy**: Traefik reverse proxy deployed
- [ ] **Monitoring**: Prometheus, Grafana, Loki deployed
- [ ] **Databases**: PostgreSQL and Redis deployed
- [ ] **Logging**: Centralized logging system deployed

### Step 8: Application Services Deployment
- [ ] **Media Services**: Sonarr, Radarr, Jellyfin deployed
- [ ] **Utilities**: Portainer, Homepage deployed
- [ ] **Security**: CrowdSec, Fail2ban deployed
- [ ] **Backup**: Backup system deployed
- [ ] **Automation**: Watchtower, health checks deployed

### Step 9: Validation & Testing
- [ ] **Service Health**: All services show "healthy" status
- [ ] **Connectivity**: All services accessible via domain
- [ ] **SSL Certificates**: SSL certificates issued and working
- [ ] **Authentication**: Authentik login working
- [ ] **Monitoring**: Grafana dashboards populated
- [ ] **Backup**: Backup system tested

## 🔍 **Post-Deployment Verification**

### Service Access Verification
- [ ] **Authentik**: https://auth.your-domain.com accessible
- [ ] **Grafana**: https://grafana.your-domain.com accessible
- [ ] **Sonarr**: https://sonarr.your-domain.com accessible
- [ ] **Radarr**: https://radarr.your-domain.com accessible
- [ ] **Jellyfin**: https://jellyfin.your-domain.com accessible
- [ ] **Portainer**: https://portainer.your-domain.com accessible
- [ ] **Homepage**: https://homepage.your-domain.com accessible

### Service Configuration Verification
- [ ] **Authentik**: Admin account created and working
- [ ] **Grafana**: Data sources configured (Prometheus, Loki)
- [ ] **Sonarr**: Can connect to download clients
- [ ] **Radarr**: Can connect to download clients
- [ ] **Jellyfin**: Media libraries configured
- [ ] **Monitoring**: Alerts configured and working
- [ ] **Backup**: Automated backups scheduled

### Security Verification
- [ ] **SSL Certificates**: All services use HTTPS
- [ ] **Authentication**: Services protected by Authentik
- [ ] **Firewall**: Unnecessary ports closed
- [ ] **SSH**: SSH hardened and secure
- [ ] **Updates**: Automatic updates configured

### Performance Verification
- [ ] **Resource Usage**: CPU and memory usage acceptable
- [ ] **Response Times**: Services respond quickly
- [ ] **Storage**: Adequate disk space available
- [ ] **Network**: Network performance acceptable

## 🔧 **Configuration Tasks**

### Authentik Configuration
- [ ] **Admin Account**: Admin password changed
- [ ] **Applications**: Services added as applications
- [ ] **Providers**: OAuth/OpenID Connect configured
- [ ] **Users**: User accounts created
- [ ] **Groups**: User groups configured

### Grafana Configuration
- [ ] **Data Sources**: Prometheus and Loki added
- [ ] **Dashboards**: Imported or created dashboards
- [ ] **Alerts**: Alert rules configured
- [ ] **Users**: User accounts created
- [ ] **Permissions**: User permissions set

### Media Services Configuration
- [ ] **Sonarr**: Download clients and indexers added
- [ ] **Radarr**: Download clients and indexers added
- [ ] **Jellyfin**: Media libraries and users created
- [ ] **Download Clients**: qBittorrent, SABnzbd configured
- [ ] **Indexers**: Usenet and torrent indexers added

### Monitoring Configuration
- [ ] **Alert Rules**: Critical alerts configured
- [ ] **Notification Channels**: Email/Discord/Slack configured
- [ ] **Dashboards**: Custom dashboards created
- [ ] **Metrics**: Key metrics identified and monitored
- [ ] **Logs**: Log aggregation working

## 🔄 **Maintenance Setup**

### Automated Maintenance
- [ ] **Updates**: Automatic system updates configured
- [ ] **Backups**: Automated backup schedule set
- [ ] **Monitoring**: Health checks configured
- [ ] **Log Rotation**: Log rotation configured
- [ ] **Cleanup**: Automated cleanup tasks scheduled

### Manual Maintenance Tasks
- [ ] **Weekly**: Check system health and logs
- [ ] **Monthly**: Review and update configurations
- [ ] **Quarterly**: Test backup restoration
- [ ] **Annually**: Review security settings

## 📊 **Documentation**

### User Documentation
- [ ] **Service URLs**: Document all service URLs
- [ ] **Credentials**: Document admin credentials
- [ ] **Configuration**: Document custom configurations
- [ ] **Troubleshooting**: Document common issues and solutions

### Technical Documentation
- [ ] **Architecture**: Document system architecture
- [ ] **Configuration**: Document configuration files
- [ ] **Backup**: Document backup procedures
- [ ] **Recovery**: Document recovery procedures

## 🚨 **Troubleshooting Checklist**

### Common Issues
- [ ] **Services Not Starting**: Check Docker logs and resource usage
- [ ] **Domain Not Accessible**: Check DNS and firewall settings
- [ ] **SSL Issues**: Check Cloudflare settings and certificate status
- [ ] **Authentication Issues**: Check Authentik configuration
- [ ] **Database Issues**: Check database connectivity and credentials

### Emergency Procedures
- [ ] **Service Recovery**: Know how to restart failed services
- [ ] **Backup Restoration**: Know how to restore from backup
- [ ] **Configuration Reset**: Know how to reset configurations
- [ ] **Contact Information**: Have support contact information ready

## ✅ **Final Verification**

### Complete System Check
- [ ] **All Services Running**: `docker ps` shows all services healthy
- [ ] **All URLs Accessible**: All service URLs accessible via HTTPS
- [ ] **All Features Working**: All configured features functional
- [ ] **Performance Acceptable**: System performance within acceptable limits
- [ ] **Security Verified**: Security measures in place and working

### Documentation Complete
- [ ] **Setup Guide**: Quick start guide completed
- [ ] **Troubleshooting**: Troubleshooting guide available
- [ ] **Maintenance**: Maintenance procedures documented
- [ ] **Recovery**: Recovery procedures documented

### Handover Complete
- [ ] **Credentials**: All credentials documented and secure
- [ ] **Access**: All access methods tested
- [ ] **Monitoring**: Monitoring and alerting working
- [ ] **Backup**: Backup system tested and verified

---

## 🎉 **Deployment Complete!**

Once all items above are checked, your Ansible Homelab is fully deployed and ready for use!

### Next Steps:
1. **Configure your media services** with download clients and indexers
2. **Set up your media libraries** in Jellyfin
3. **Customize your dashboards** in Grafana
4. **Set up monitoring alerts** for critical services
5. **Test your backup system** to ensure data protection
6. **Join the community** for support and updates

### Support Resources:
- **Quick Start Guide**: [QUICK_START_GUIDE.md](QUICK_START_GUIDE.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Documentation**: [README.md](README.md)
- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and help

---

**Remember**: This checklist is a living document. Update it as you customize your deployment and add new services! 