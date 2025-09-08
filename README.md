# 🏠 Ansible Homelab v3.0

**🚀 Production-Ready Homelab Automation Platform**

A comprehensive, enterprise-grade homelab automation solution built with Ansible, Docker, and modern DevOps practices. **Now with 88+ services, zero hardcoded secrets, production-ready security, and enhanced DNS automation!**

## 🎉 **v3.0.0 Major Release - Enhanced DNS Automation**

**🔒 Security & Reliability Improvements:**
- **Enhanced DNS Automation** - Secrets now securely managed via environment variables
- **True Idempotency** - Proper change detection with DNS_CHANGED markers
- **Configurable Python Interpreter** - Support for virtual environments and custom paths
- **Production-Ready Error Handling** - Improved validation and failure detection
- **Flexible Configuration** - Server IP and interpreter paths configurable via environment variables

**📖 See [RELEASE_NOTES_v3.0.0.md](RELEASE_NOTES_v3.0.0.md) for complete details on the DNS automation overhaul.**

[![Production Ready](https://img.shields.io/badge/Production-Ready-brightgreen)](https://github.com/solarorange/ansible_homelab)
[![Security](https://img.shields.io/badge/Security-Hardened-red)](https://github.com/solarorange/ansible_homelab)
[![Services](https://img.shields.io/badge/Services-88+-blue)](https://github.com/solarorange/ansible_homelab)
[![License](https://img.shields.io/badge/License-MIT-green)](https://github.com/solarorange/ansible_homelab)

## 🎯 **Comprehensive Service Stack (88+ Services)**

### 🔐 **Security & Authentication (6 Services)**
- **Authentik** - Enterprise identity provider with SSO
- **Traefik** - Reverse proxy with automatic SSL/TLS
- **CrowdSec** - Real-time intrusion detection and prevention
- **Fail2ban** - Advanced brute force protection
- **Vault** - Secrets management and encryption
- **Wireguard** - VPN server and client management

### 📊 **Monitoring & Observability (8 Services)**
- **Prometheus** - Metrics collection and storage
- **Grafana** - Advanced visualization and dashboards
- **Loki** - Log aggregation and analysis
- **AlertManager** - Intelligent alert routing and notification
- **Telegraf** - Metrics collection agent
- **Blackbox Exporter** - Endpoint monitoring
- **Promtail** - Log shipping agent
- **InfluxDB** - Time-series database for metrics

### 🗄️ **Databases & Storage (7 Services)**
- **PostgreSQL** - Primary relational database
- **Redis** - High-performance caching and sessions
- **MariaDB/MySQL** - Alternative relational databases
- **Elasticsearch** - Search and analytics engine
- **Nextcloud** - File sharing and collaboration
- **Samba** - File sharing and network storage
- **Syncthing** - File synchronization

### 📺 **Media Services (24 Services)**
- **Sonarr** - TV show management and automation
- **Radarr** - Movie management and automation
- **Lidarr** - Music management and automation
- **Readarr** - Book management and automation
- **Prowlarr** - Indexer management
- **Bazarr** - Subtitle management
- **Jellyfin** - Media server with transcoding
- **Emby** - Alternative media server
- **Plex** - Premium media server
- **Overseerr** - Media requests and discovery
- **Tautulli** - Media statistics and monitoring
- **ErsatzTV** - Live TV streaming service
- **Audiobookshelf** - Audiobook management
- **Komga** - Comic book management
- **Calibre** - E-book management
- **Tdarr** - Media transcoding automation
- **Unmanic** - Media processing automation
- **SABnzbd** - Usenet downloader
- **qBittorrent** - BitTorrent client
- **Deluge** - Alternative BitTorrent client
- **Transmission** - Lightweight BitTorrent client
- **rTorrent** - Command-line BitTorrent client
- **Immich** - AI-powered photo management
- **File Browser** - Web-based file manager

### 🔗 **Knowledge & Productivity (10 Services)**
- **Linkwarden** - Bookmark and knowledge management
- **Paperless-ngx** - Document management and OCR
- **BookStack** - Wiki and documentation platform
- **Vaultwarden** - Self-hosted password manager (Bitwarden alternative)
- **MinIO** - S3-compatible object storage
- **Harbor** - Container registry
- **GitLab** - Git repository management
- **Code Server** - Web-based VS Code
- **Dumbassets** - Asset management system
- **Paperless** - Document management

### 🤖 **Automation & Development (6 Services)**
- **n8n** - Powerful workflow automation platform
- **Node-RED** - IoT and automation flows
- **Home Assistant** - Smart home automation
- **Portainer** - Docker container management
- **Watchtower** - Automatic container updates
- **Mosquitto** - MQTT message broker

### 🔧 **Utilities & Management (10 Services)**
- **Homepage** - Service dashboard and monitoring
- **Health Checks** - Comprehensive service monitoring
- **Kopia** - Cross-platform backup solution
- **Gluetun** - VPN client for containers
- **Pinchflat** - Media server management
- **Fing** - Network device discovery and monitoring
- **ROMM** - Retro game management and emulation
- **Uptime Kuma** - Uptime monitoring
- **Guacamole** - Remote desktop gateway
- **Requestrr** - Media request management

### 🌐 **Network Services (3 Services)**
- **Pi-hole** - DNS ad-blocking and network management
- **Nginx Proxy Manager** - Web server and reverse proxy
- **Fing** - Network device discovery and monitoring

### 📊 **Additional Dashboards (3 Services)**
- **Dashdot** - System dashboard
- **Heimdall** - Application dashboard
- **Homarr** - Service dashboard

### 🔐 **Security Enhancements**
- ✅ **Zero Hardcoded Secrets** - All credentials managed via Ansible Vault
- ✅ **Comprehensive Privilege Validation** - Secure privilege escalation controls
- ✅ **Enhanced Container Security** - Security contexts and user mappings
- ✅ **Network Segmentation** - Proper isolation and security policies
- ✅ **Encryption at Rest & Transit** - End-to-end security

### ⚡ **Performance & Reliability**
- ✅ **Production-Ready Health Checks** - Replaced all hardcoded sleep statements
- ✅ **Comprehensive Error Handling** - Robust failure recovery mechanisms
- ✅ **System Optimization** - Kernel tuning for container workloads
- ✅ **Resource Management** - Proper limits and requests
- ✅ **Scalability Ready** - Horizontal and vertical scaling support

## 🚀 **Quick Start (30 Minutes)**

**Get your production-ready homelab running in under 30 minutes!**

1. **Clone and setup**:
   ```bash
   git clone https://github.com/solarorange/ansible_homelab.git
   cd ansible_homelab
   chmod +x scripts/*.sh
   ```

2. **Run the seamless setup wizard**:
   ```bash
   ./scripts/seamless_setup.sh
   ```
   > **🎯 Seamless Setup** - 100% automatic variable handling with zero manual configuration required!

3. **Access your homelab**:
   - 🌐 **Dashboard**: `https://dash.yourdomain.com`
   - 🔐 **Authentication**: `https://auth.yourdomain.com`
   - 📊 **Monitoring**: `https://grafana.yourdomain.com`

4. **📖 Read the Post-Setup Guide**:
   - 📋 **[POST_SETUP_GUIDE.md](POST_SETUP_GUIDE.md)** - Complete guide to accessing and using all 60+ services
   - 🚀 **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Essential URLs and commands for quick access
   - 📚 **[DOCUMENTATION.md](DOCUMENTATION.md)** - Complete documentation index
   - 🎯 **✨ NEW: Automatic Domain Personalization** - All documentation automatically updated with your domain!

## 🎯 **✨ NEW: Automatic Domain Personalization**

**🚀 The Ultimate Turnkey Experience - Your Documentation is Automatically Personalized!**

When you run the seamless setup script, it automatically:
- ✅ **Updates all documentation** with your actual domain
- ✅ **Creates personalized guides** with your service URLs ready to use
- ✅ **Generates custom quick references** with your domain
- ✅ **Updates interactive scripts** with your domain
- ✅ **Zero manual editing required** - everything works immediately

**Example**: If you enter `myhomelab.com`, all documentation automatically shows:
- `https://dash.myhomelab.com` instead of `https://dash.your-domain.com`
- `https://grafana.myhomelab.com` instead of `https://grafana.your-domain.com`
- All 60+ service URLs personalized and ready to use!

**Files automatically personalized**:
- `POST_SETUP_GUIDE_PERSONALIZED.md` - Complete guide with your domain
- `QUICK_REFERENCE_PERSONALIZED.md` - Quick reference with your domain
- `scripts/post_setup_info.sh` - Interactive script with your domain

**✨ Bonus**: The setup wizard asks if you want to run the post-setup info script immediately, showing all your service URLs right after setup!

---

## 🎯 **🚀 Service Integration Wizard - Add Any Service in Minutes!**

**The most powerful feature of this homelab platform - add ANY service to your homelab with full automation!**

### **✨ What the Wizard Does**
- ✅ **Complete Role Generation** - Creates full Ansible role structure
- ✅ **Full Stack Integration** - Traefik, monitoring, security, backup, homepage
- ✅ **Smart Analysis** - Analyzes repositories for configuration details
- ✅ **Validation & Safety** - Port conflict detection and error checking
- ✅ **Consistent Patterns** - Follows your established conventions

### **🚀 How to Use the Wizard**

**Interactive Mode (Recommended):**
```bash
# Start the interactive wizard
./scripts/add_service.sh
```

**Non-Interactive Mode:**
```bash
# Add a specific service
python3 scripts/service_wizard.py --service-name "jellyfin" --repository-url "https://github.com/jellyfin/jellyfin"
```

### **🎯 Wizard Capabilities**

**✨ Complete Automation:**
- **Ansible Role Generation** - Full role structure with tasks, templates, defaults
- **Docker Integration** - Docker Compose with proper networking and security
- **Traefik Configuration** - Automatic SSL certificates and reverse proxy
- **Monitoring Setup** - Prometheus metrics, Grafana dashboards, health checks
- **Security Integration** - Authentik SSO, CrowdSec protection, Fail2ban rules
- **Backup Configuration** - Automated backups with encryption
- **Homepage Dashboard** - Automatic dashboard integration
- **Alert Configuration** - Prometheus alerts and notifications

**🔧 Smart Features:**
- **Port Conflict Detection** - Automatically detects and resolves port conflicts
- **Repository Analysis** - Analyzes GitHub repositories for configuration details
- **Health Check Generation** - Creates appropriate health check endpoints
- **Security Hardening** - Applies security best practices automatically
- **Documentation Generation** - Creates comprehensive documentation

**📊 Integration Examples:**
```bash
# Add a media service
./scripts/add_service.sh
# → Generates: Traefik config, monitoring, backup, homepage widget

# Add a database
python3 scripts/service_wizard.py --service-name "postgres" --repository-url "https://github.com/docker-library/postgres"
# → Generates: Full database role with security, monitoring, backup

# Add a utility
./scripts/add_service.sh
# → Generates: Complete utility integration with all systems
```

**📖 Documentation:** [Service Integration Wizard Guide](docs/SERVICE_INTEGRATION_WIZARD.md) - Complete documentation and examples

## 🏠 **✨ NEW: External Server Integration - Unify Your Entire Homelab!**

**🚀 Seamlessly integrate external servers (Synology, Unraid, Proxmox, etc.) into your HomelabOS ecosystem!**

### **🎯 What It Does**
- ✅ **SSL Certificate Management** - Automatic Let's Encrypt certificates for external servers
- ✅ **DNS Configuration** - Automatic subdomain creation via Cloudflare API
- ✅ **Grafana Monitoring** - Custom dashboards for each external server
- ✅ **Traefik Proxy** - Reverse proxy with authentication and security
- ✅ **Health Monitoring** - Automated health checks and alerting
- ✅ **Backup Integration** - Automated backup configuration
- ✅ **Homepage Integration** - Unified dashboard access for all servers

### **🚀 Quick Integration**

**Interactive Setup (Recommended):**
```bash
./scripts/integrate_server.sh
```

**Command Line Setup:**
```bash
./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000
```

**Configuration File Setup:**
```bash
./scripts/integrate_server.sh --config config/external_servers.yml
```

### **📋 Supported External Servers**
- **Storage**: Synology, TrueNAS, Unraid
- **Virtualization**: Proxmox, VMware ESXi
- **Home Automation**: Home Assistant, OpenHAB
- **Network**: Routers, Pi-hole, Firewalls
- **Security**: NVR systems, IP cameras
- **Development**: Git servers, CI/CD systems
- **Gaming**: Game servers, Steam servers

### **🌐 Unified Access**
After integration, access all your servers at:
- **Homepage Dashboard**: `https://dash.yourdomain.com`
- **Grafana Monitoring**: `https://grafana.yourdomain.com`
- **Individual Servers**: `https://server-name.yourdomain.com`

**📖 Documentation:** [External Server Integration Guide](docs/EXTERNAL_SERVER_INTEGRATION.md) - Complete guide and examples


## 🏗️ **Production-Ready Architecture**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Internet      │    │   Cloudflare    │    │   Your Server   │
│                 │◄──►│   (DNS + SSL)   │◄──►│                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Traefik (Reverse Proxy)                     │
│                    ┌─────────────┬─────────────┐               │
│                    │   HTTP/80   │  HTTPS/443  │               │
│                    └─────────────┴─────────────┘               │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Docker Network: homelab                     │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │  Authentik  │  │   Grafana   │  │   Sonarr    │            │
│  │  (Auth)     │  │ (Monitoring)│  │  (TV Shows) │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Radarr    │  │   Immich    │  │ Linkwarden  │            │
│  │  (Movies)   │  │  (Photos)   │  │(Bookmarks)  │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │     n8n     │  │   Pezzo     │  │  Reconya    │            │
│  │(Automation) │  │   (AI)      │  │(Monitoring) │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │ Vaultwarden │  │ ErsatzTV    │  │DumbAssets   │            │
│  │(Passwords)  │  │ (Live TV)   │  │(Assets)     │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 **Key Features**

### ✅ **Production Ready**
- **High Availability** - Service redundancy and failover
- **Security Hardened** - Industry-standard security practices
- **Automated Backups** - Data protection and recovery
- **Monitoring & Alerting** - Proactive issue detection
- **Performance Optimized** - Resource-efficient operation
- **Zero-Downtime Updates** - Seamless service updates

### 🔄 **Automated Operations**
- **🚀 Service Integration Wizard** - **Add additional services in minutes!** See [Service Integration Wizard Guide](docs/SERVICE_INTEGRATION_WIZARD.md)
- **Comprehensive Variable Coverage** - 100% automatic configuration
- **Automated Secret Rotation** - Secure credential management
- **Enhanced Health Monitoring** - Continuous service validation
- **Auto-Recovery** - Automatic service restoration
- **Resource Management** - Intelligent resource allocation

### 🛡️ **Enterprise Security**
- **SSO Authentication** - Single sign-on for all services
- **SSL/TLS Encryption** - End-to-end encryption
- **Intrusion Detection** - Real-time threat monitoring
- **Access Control** - Role-based permissions
- **Audit Logging** - Comprehensive activity tracking
- **Network Segmentation** - Proper isolation

### 📊 **Advanced Monitoring**
- **Grafana Dashboards** - Custom dashboards for all services
- **Prometheus Metrics** - Comprehensive metrics collection
- **Loki Logs** - Centralized log aggregation
- **AlertManager** - Intelligent alert routing
- **Performance Monitoring** - Resource usage tracking
- **Security Monitoring** - Threat detection and response

## 📊 **System Requirements**

### **Minimum Requirements**
- **OS**: Ubuntu 20.04+ / Debian 11+ / CentOS 8+
- **CPU**: 4 cores
- **RAM**: 8GB
- **Storage**: 100GB
- **Network**: Static IP address

### **Recommended Requirements**
- **OS**: Ubuntu 22.04 LTS
- **CPU**: 8+ cores
- **RAM**: 16GB+
- **Storage**: 500GB+ SSD
- **Network**: Gigabit connection

## 🚀 **Deployment Options**

### **🚀 Seamless Setup (Recommended)**
```bash
# One-command setup with zero configuration
git clone https://github.com/solarorange/ansible_homelab.git
cd ansible_homelab
./scripts/seamless_setup.sh
```

> **🎯 Seamless Setup** - Provides **100% automatic variable handling** with **zero manual configuration required**. The seamless setup script handles all configuration automatically.

### **Manual Deployment**
```bash
# 1. Setup environment
./scripts/setup_environment.sh

# 2. Configure vault
cp group_vars/all/vault_template.yml group_vars/all/vault.yml
ansible-vault encrypt group_vars/all/vault.yml

# 3. Deploy infrastructure
ansible-playbook site.yml --ask-vault-pass
```

### **Staged Deployment**
```bash
# Deploy in stages for testing
ansible-playbook site.yml --tags stage1 --ask-vault-pass  # Infrastructure
ansible-playbook site.yml --tags stage2 --ask-vault-pass  # Core services
ansible-playbook site.yml --tags stage3 --ask-vault-pass  # Applications
ansible-playbook site.yml --tags stage4 --ask-vault-pass  # Validation
```

## 🔧 **Configuration**

### **Environment Variables**
The enhanced setup script creates a comprehensive `.env` file:

```bash
# Basic Configuration
HOMELAB_DOMAIN=your-domain.com
HOMELAB_TIMEZONE=America/New_York
HOMELAB_USERNAME=homelab
HOMELAB_PUID=1000
HOMELAB_PGID=1000

# Network Configuration
HOMELAB_SUBNET=192.168.1.0/24
HOMELAB_GATEWAY=192.168.1.1
UPSTREAM_DNS_1=1.1.1.1
UPSTREAM_DNS_2=8.8.8.8

# Cloudflare Configuration
CLOUDFLARE_ENABLED=true
CLOUDFLARE_EMAIL=your-email@domain.com
CLOUDFLARE_API_TOKEN=your-api-token

# Service Configuration
MONITORING_ENABLED=true
MEDIA_ENABLED=true
SECURITY_ENABLED=true
AUTOMATION_ENABLED=true
UTILITIES_ENABLED=true
PRODUCTIVITY_ENABLED=true
```

### **Service Configuration**
Each service can be customized through:
- **Environment variables** in `.env`
- **Docker Compose files** in `/opt/docker/<service>/`
- **Configuration files** in `/opt/config/<service>/`
- **Ansible variables** in `group_vars/all/`

## 📈 **Monitoring & Health**

### **Service Health**
- **Grafana Dashboards** - System and service metrics
- **Prometheus Alerts** - Automated alerting
- **Health Checks** - Service availability monitoring
- **Log Analysis** - Centralized log management
- **Performance Monitoring** - Resource usage tracking

### **Key Metrics**
- **System Resources** - CPU, memory, disk usage
- **Service Performance** - Response times, error rates
- **Network Traffic** - Bandwidth, connection counts
- **Security Events** - Failed logins, suspicious activity
- **Application Metrics** - Service-specific monitoring

## 🔄 **Maintenance**

### **Automated Tasks**
- **Daily Backups** - Automated data protection
- **Weekly Updates** - Security and feature updates
- **Monthly Cleanup** - Log rotation and cleanup
- **Quarterly Reviews** - Performance and security audits
- **Secret Rotation** - Automated credential updates

### **Manual Tasks**
- **Configuration Updates** - Service configuration changes
- **Security Reviews** - Regular security assessments
- **Performance Tuning** - Optimization based on usage
- **Documentation Updates** - Keep docs current

## 🛠️ **Advanced Features**

### **🔄 Version Management System - Complete Fallback Protection**
**Enterprise-grade version management with multiple rollback options!**

#### **🎯 Multi-Level Fallback Strategy**
- **Git Tags** - Clean, tagged releases (recommended)
- **Version Backups** - Complete state snapshots
- **Git Commits** - Fine-grained history
- **Emergency Backups** - Last resort recovery

#### **🚀 Version Management Commands**
```bash
# Check current version
python3 scripts/version_manager.py info

# Create version backup
python3 scripts/version_manager.py backup

# List rollback options
./scripts/version_rollback.sh --list

# Rollback to previous version
./scripts/version_rollback.sh tag:v2.0.0
./scripts/version_rollback.sh backup:backups/versions/v2.0.0_20241219_143022
./scripts/version_rollback.sh commit:06f4db6

# Emergency backup
./scripts/version_rollback.sh --backup
```

#### **🛡️ Safety Features**
- **Automatic backup before rollback** - Never lose your current state
- **Confirmation prompts** - Prevent accidental rollbacks
- **Validation** - Ensure rollback success
- **Multiple fallback options** - Always have a recovery path

**📖 Documentation:** [Version Management Guide](docs/VERSION_MANAGEMENT.md) - Complete version management documentation

### **🚀 Service Integration Wizard - The Ultimate Homelab Feature!**
**The most powerful feature of this platform - add ANY service to your homelab with complete automation!**

#### **🎯 What Makes This Special**
This isn't just another automation tool - it's a **complete service integration platform** that:

- **🎯 Zero Manual Configuration** - Everything is automated from start to finish
- **🔧 Full Stack Integration** - Integrates with every component of your homelab
- **🛡️ Production-Ready Security** - Applies enterprise security practices automatically
- **📊 Complete Monitoring** - Sets up monitoring, alerting, and dashboards
- **🔄 Smart Validation** - Detects conflicts and validates configurations

#### **✨ Complete Automation Capabilities**

**🚀 Service Deployment:**
```bash
# Interactive wizard (recommended)
./scripts/add_service.sh

# Direct service addition
python3 scripts/service_wizard.py --service-name "jellyfin" --repository-url "https://github.com/jellyfin/jellyfin"
```

**🎯 What Gets Created Automatically:**
- ✅ **Complete Ansible Role** - Full role structure with tasks, templates, defaults
- ✅ **Docker Integration** - Docker Compose with proper networking and security
- ✅ **Traefik Configuration** - Automatic SSL certificates and reverse proxy
- ✅ **Monitoring Setup** - Prometheus metrics, Grafana dashboards, health checks
- ✅ **Security Integration** - Authentik SSO, CrowdSec protection, Fail2ban rules
- ✅ **Backup Configuration** - Automated backups with encryption
- ✅ **Homepage Dashboard** - Automatic dashboard integration
- ✅ **Alert Configuration** - Prometheus alerts and notifications

**🔧 Smart Features:**
- **Port Conflict Detection** - Automatically detects and resolves port conflicts
- **Repository Analysis** - Analyzes GitHub repositories for configuration details
- **Health Check Generation** - Creates appropriate health check endpoints
- **Security Hardening** - Applies security best practices automatically
- **Documentation Generation** - Creates comprehensive documentation

#### **📊 Real-World Examples**

**Add a Media Service:**
```bash
./scripts/add_service.sh
# → Generates: Traefik config, monitoring, backup, homepage widget
# → Integrates: SSL certificates, authentication, monitoring, alerts
```

**Add a Database:**
```bash
python3 scripts/service_wizard.py --service-name "postgres" --repository-url "https://github.com/docker-library/postgres"
# → Generates: Full database role with security, monitoring, backup
# → Integrates: Connection pooling, metrics, automated backups
```

**Add a Utility:**
```bash
./scripts/add_service.sh
# → Generates: Complete utility integration with all systems
# → Integrates: Dashboard widgets, monitoring, security policies
```

#### **📖 Complete Documentation**
- **[Service Integration Wizard Guide](docs/SERVICE_INTEGRATION_WIZARD.md)** - Complete documentation and examples
- **[Quick Reference](docs/SERVICE_WIZARD_QUICK_REFERENCE.md)** - Command reference and tips
- **[Best Practices](docs/SERVICE_INTEGRATION_BEST_PRACTICES.md)** - Advanced usage patterns

### **Security Audit**
```bash
# Comprehensive security check
./scripts/security_audit.sh
```

### **Deployment Validation**
```bash
# Validate deployment health
./scripts/validate_deployment.sh
```

### **Port Conflict Detection**
```bash
# Check for port conflicts
python3 scripts/check_port_conflicts.py
```

## 📚 **Documentation**

### 🚀 **Getting Started**
- **[Seamless Setup Guide](scripts/seamless_setup.sh)** - Complete setup with zero configuration
- **[Quick Start Guide](QUICK_START_GUIDE.md)** - Complete setup in 30 minutes
- **[Deployment Checklist](DEPLOYMENT_CHECKLIST.md)** - Step-by-step verification
- **[Prerequisites](PREREQUISITES.md)** - System requirements and preparation

### 🔧 **Configuration & Management**
- **[Architecture Guide](docs/ARCHITECTURE.md)** - Detailed system design
- **[Service Configuration](docs/SERVICES.md)** - Individual service setup
- **[🚀 Service Integration Wizard](docs/SERVICE_INTEGRATION_WIZARD.md)** - **Add additional services easily**
- **[Service Wizard Quick Reference](docs/SERVICE_WIZARD_QUICK_REFERENCE.md)** - Command reference and tips
- **[Security Guide](docs/SECURITY.md)** - Security best practices
- **[Monitoring Setup](docs/MONITORING.md)** - Monitoring configuration

### 🛠️ **Operations & Maintenance**
- **[Troubleshooting Guide](TROUBLESHOOTING.md)** - Common issues and solutions
- **[Maintenance Guide](docs/MAINTENANCE.md)** - Regular maintenance tasks
- **[Backup & Recovery](docs/BACKUP_ORCHESTRATION.md)** - Data protection
- **[Performance Tuning](docs/PERFORMANCE_TUNING.md)** - Optimization guide

### 📖 **Advanced Topics**
- **[Disaster Recovery](docs/DISASTER_RECOVERY.md)** - Recovery procedures
- **[Scaling Strategies](docs/SCALING_STRATEGIES.md)** - Growth planning
- **[CI/CD Integration](docs/CI_CD_INTEGRATION.md)** - Automation pipelines
- **[Advanced Best Practices](docs/ADVANCED_BEST_PRACTICES.md)** - Expert tips

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Setup**
```bash
# Clone with submodules
git clone --recursive https://github.com/solarorange/ansible_homelab.git

# Install development dependencies
pip install -r requirements-dev.txt

# Run tests
ansible-playbook tests/test_deployment.yml
```

### **Testing**
- **Unit Tests** - Individual component testing
- **Integration Tests** - Service interaction testing
- **End-to-End Tests** - Complete deployment testing
- **Performance Tests** - Load and stress testing
- **Security Tests** - Vulnerability scanning

## 📞 **Support**

### **Getting Help**
1. **Check the documentation** - Start with the guides above
2. **Search existing issues** - Look for similar problems
3. **Create a new issue** - Provide detailed information
4. **Join discussions** - Ask questions in GitHub Discussions

### **Support Information**
When asking for help, please include:
- **OS and version**
- **Ansible version**
- **Docker version**
- **Error messages**
- **Relevant logs**
- **Configuration details**

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- **Ansible Community** - For the amazing automation framework
- **Docker Community** - For containerization technology
- **Open Source Projects** - For all the services included
- **Contributors** - For their valuable contributions

---

## 🎉 **Ready to Get Started?**

1. **Run the seamless setup script**: `./scripts/seamless_setup.sh`
2. **Check the [Deployment Checklist](DEPLOYMENT_CHECKLIST.md)**
3. **Follow the setup instructions**
4. **🚀 Try the [Service Integration Wizard](docs/SERVICE_INTEGRATION_WIZARD.md) to add additional services**
5. **Join our community for support**

**Happy Homelabbing! 🏠✨**

---

## 🚀 **🚀 The Ultimate Homelab Feature - Service Integration Wizard!**

**🎯 The most powerful feature of this platform - add ANY service to your homelab with complete automation!**

### **✨ Why This Is Revolutionary**
This isn't just another automation tool - it's a **complete service integration platform** that transforms how you add services to your homelab:

- **🎯 Zero Manual Configuration** - Everything is automated from start to finish
- **🔧 Full Stack Integration** - Integrates with every component of your homelab
- **🛡️ Production-Ready Security** - Applies enterprise security practices automatically
- **📊 Complete Monitoring** - Sets up monitoring, alerting, and dashboards
- **🔄 Smart Validation** - Detects conflicts and validates configurations

### **🚀 How to Use the Wizard**

**Interactive Mode (Recommended):**
```bash
# Start the interactive wizard
./scripts/add_service.sh
```

**Direct Service Addition:**
```bash
# Add a specific service
python3 scripts/service_wizard.py --service-name "jellyfin" --repository-url "https://github.com/jellyfin/jellyfin"
```

### **🎯 What Gets Created Automatically**

**✨ Complete Automation:**
- ✅ **Complete Ansible Role** - Full role structure with tasks, templates, defaults
- ✅ **Docker Integration** - Docker Compose with proper networking and security
- ✅ **Traefik Configuration** - Automatic SSL certificates and reverse proxy
- ✅ **Monitoring Setup** - Prometheus metrics, Grafana dashboards, health checks
- ✅ **Security Integration** - Authentik SSO, CrowdSec protection, Fail2ban rules
- ✅ **Backup Configuration** - Automated backups with encryption
- ✅ **Homepage Dashboard** - Automatic dashboard integration
- ✅ **Alert Configuration** - Prometheus alerts and notifications

**🔧 Smart Features:**
- **Port Conflict Detection** - Automatically detects and resolves port conflicts
- **Repository Analysis** - Analyzes GitHub repositories for configuration details
- **Health Check Generation** - Creates appropriate health check endpoints
- **Security Hardening** - Applies security best practices automatically
- **Documentation Generation** - Creates comprehensive documentation

### **📊 Real-World Examples**

**Add a Media Service:**
```bash
./scripts/add_service.sh
# → Generates: Traefik config, monitoring, backup, homepage widget
# → Integrates: SSL certificates, authentication, monitoring, alerts
```

**Add a Database:**
```bash
python3 scripts/service_wizard.py --service-name "postgres" --repository-url "https://github.com/docker-library/postgres"
# → Generates: Full database role with security, monitoring, backup
# → Integrates: Connection pooling, metrics, automated backups
```

**Add a Utility:**
```bash
./scripts/add_service.sh
# → Generates: Complete utility integration with all systems
# → Integrates: Dashboard widgets, monitoring, security policies
```

### **📖 Complete Documentation**
- **[Service Integration Wizard Guide](docs/SERVICE_INTEGRATION_WIZARD.md)** - Complete documentation and examples
- **[Quick Reference](docs/SERVICE_WIZARD_QUICK_REFERENCE.md)** - Command reference and tips
- **[Best Practices](docs/SERVICE_INTEGRATION_BEST_PRACTICES.md)** - Advanced usage patterns

**🎯 This is what makes this homelab platform truly special - the ability to add ANY service with complete automation!**

---

## 🔄 **Version Management - Complete Fallback Protection**

**🛡️ Enterprise-grade version management with multiple rollback options!**

### **🎯 Multi-Level Fallback Strategy**
- **Git Tags** - Clean, tagged releases (recommended)
- **Version Backups** - Complete state snapshots  
- **Git Commits** - Fine-grained history
- **Emergency Backups** - Last resort recovery

### **🚀 Quick Version Management**
```bash
# Check current version
python3 scripts/version_manager.py info

# Create version backup
python3 scripts/version_manager.py backup

# List rollback options
./scripts/version_rollback.sh --list

# Rollback to previous version
./scripts/version_rollback.sh tag:v2.0.0
./scripts/version_rollback.sh backup:backups/versions/v2.0.0_20241219_143022
./scripts/version_rollback.sh commit:06f4db6

# Emergency backup
./scripts/version_rollback.sh --backup
```

### **🛡️ Safety Features**
- **Automatic backup before rollback** - Never lose your current state
- **Confirmation prompts** - Prevent accidental rollbacks
- **Validation** - Ensure rollback success
- **Multiple fallback options** - Always have a recovery path

**📖 Documentation:** [Version Management Guide](docs/VERSION_MANAGEMENT.md) - Complete version management documentation

**🎯 This version management system ensures you can always recover from any issues and maintain a stable, production-ready homelab!**

---

**⭐ Star this repository if you find it helpful!** 