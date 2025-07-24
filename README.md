# 🏠 Ansible Homelab v2.0

**🚀 Production-Ready Homelab Automation Platform**

A comprehensive, enterprise-grade homelab automation solution built with Ansible, Docker, and modern DevOps practices. **Now with 25+ services, zero hardcoded secrets, and production-ready security!**

[![Production Ready](https://img.shields.io/badge/Production-Ready-brightgreen)](https://github.com/solarorange/ansible_homelab)
[![Security](https://img.shields.io/badge/Security-Hardened-red)](https://github.com/solarorange/ansible_homelab)
[![Services](https://img.shields.io/badge/Services-25+-blue)](https://github.com/solarorange/ansible_homelab)
[![License](https://img.shields.io/badge/License-MIT-green)](https://github.com/solarorange/ansible_homelab)

## 🎯 **What's New in v2.0**

### 🆕 **8 New Services Added**
- 📸 **Immich** - AI-powered photo management with facial recognition
- 🔗 **Linkwarden** - Bookmark and knowledge management system
- 🤖 **n8n** - Powerful workflow automation platform
- 🧠 **Pezzo** - AI prompt management and optimization
- 🔍 **Reconya** - Network reconnaissance and monitoring
- 🔐 **Vaultwarden** - Self-hosted password manager (Bitwarden alternative)
- 📺 **ErsatzTV** - Live TV streaming service
- 📦 **DumbAssets** - Asset management and organization system

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

2. **Run the enhanced seamless setup wizard**:
   ```bash
   ./scripts/seamless_setup.sh
   ```
   > **🎯 NEW: Enhanced Setup** - 100% automatic variable handling with zero manual configuration required!

3. **Access your homelab**:
   - 🌐 **Dashboard**: `https://dash.yourdomain.com`
   - 🔐 **Authentication**: `https://auth.yourdomain.com`
   - 📊 **Monitoring**: `https://grafana.yourdomain.com`

## 🏗️ **Complete Service Stack (25+ Services)**

### 🔐 **Security & Authentication**
- **Authentik** - Enterprise identity provider with SSO
- **Traefik** - Reverse proxy with automatic SSL/TLS
- **CrowdSec** - Real-time intrusion detection and prevention
- **Fail2ban** - Advanced brute force protection
- **UFW Firewall** - Network security and access control
- **Vaultwarden** - Self-hosted password manager

### 📊 **Monitoring & Observability**
- **Prometheus** - Metrics collection and storage
- **Grafana** - Advanced visualization and dashboards
- **Loki** - Log aggregation and analysis
- **AlertManager** - Intelligent alert routing and notification
- **Node Exporter** - System metrics collection
- **Reconya** - Network reconnaissance and monitoring

### 🗄️ **Databases & Storage**
- **PostgreSQL** - Primary relational database
- **Redis** - High-performance caching and sessions
- **InfluxDB** - Time-series database for metrics
- **Automated Backup System** - Comprehensive data protection
- **Storage Management** - Intelligent file organization

### 📺 **Media Services**
- **Sonarr** - TV show management and automation
- **Radarr** - Movie management and automation
- **Lidarr** - Music management and automation
- **Readarr** - Book management and automation
- **Prowlarr** - Indexer management
- **Bazarr** - Subtitle management
- **Jellyfin** - Media server with transcoding
- **Overseerr** - Media requests and discovery
- **Tautulli** - Media statistics and monitoring
- **ErsatzTV** - Live TV streaming service
- **Download Clients** - qBittorrent, SABnzbd

### 📸 **Photo & Media Management**
- **Immich** - AI-powered photo management with facial recognition
- **File Browser** - Web-based file manager
- **MinIO** - S3-compatible object storage

### 🔗 **Knowledge & Productivity**
- **Linkwarden** - Bookmark and knowledge management
- **Paperless-ngx** - Document management and OCR
- **BookStack** - Wiki and documentation platform
- **Nextcloud** - File sharing and collaboration

### 🤖 **Automation & Development**
- **n8n** - Powerful workflow automation platform
- **Node-RED** - IoT and automation flows
- **Home Assistant** - Smart home automation
- **GitLab** - Git repository management
- **Harbor** - Container registry
- **Code Server** - Web-based VS Code

### 🧠 **AI & Machine Learning**
- **Pezzo** - AI prompt management and optimization
- **Pezzo AI** - AI model management and deployment

### 🔧 **Utilities & Management**
- **Portainer** - Docker container management
- **Homepage** - Service dashboard and monitoring
- **Watchtower** - Automatic container updates
- **Health Checks** - Comprehensive service monitoring
- **DumbAssets** - Asset management and organization

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
- **Service Integration Wizard** - Easy service addition
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

### **🚀 Enhanced Seamless Setup (Recommended)**
```bash
# One-command setup with zero configuration
git clone https://github.com/solarorange/ansible_homelab.git
cd ansible_homelab
./scripts/seamless_setup.sh
```

> **🎯 NEW: Enhanced Setup** - Provides **100% automatic variable handling** with **zero manual configuration required**. See [ENHANCED_SETUP_README.md](ENHANCED_SETUP_README.md) for details.

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

### **Service Integration Wizard**
```bash
# Add new services easily
./scripts/service_wizard.py
```

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
- **[Enhanced Setup Guide](ENHANCED_SETUP_README.md)** - Complete setup with zero configuration
- **[Quick Start Guide](QUICK_START_GUIDE.md)** - Complete setup in 30 minutes
- **[Deployment Checklist](DEPLOYMENT_CHECKLIST.md)** - Step-by-step verification
- **[Prerequisites](PREREQUISITES.md)** - System requirements and preparation

### 🔧 **Configuration & Management**
- **[Architecture Guide](docs/ARCHITECTURE.md)** - Detailed system design
- **[Service Configuration](docs/SERVICES.md)** - Individual service setup
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

1. **Read the [Enhanced Setup Guide](ENHANCED_SETUP_README.md)**
2. **Check the [Deployment Checklist](DEPLOYMENT_CHECKLIST.md)**
3. **Follow the setup instructions**
4. **Join our community for support**

**Happy Homelabbing! 🏠✨**

---

**⭐ Star this repository if you find it helpful!** 