# 🏠 Ansible Homelab

A comprehensive, production-ready homelab automation solution built with Ansible, Docker, and modern DevOps practices.

## 🚀 **Quick Start**

**Get your homelab running in under 30 minutes!**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/ansible_homelab.git
   cd ansible_homelab
   ```

2. **Run the seamless one-touch setup wizard**:
   ```bash
   chmod +x scripts/*.sh
   ./scripts/seamless_setup.sh
   ```
   > **Recommended:** `seamless_setup.sh` is the preferred, all-in-one interactive setup wizard. It will prompt you for all required values, generate secure credentials, configure everything, and deploy your stack in one go.

3. **Follow the deployment guide**:
   - 📖 **[Quick Start Guide](QUICK_START_GUIDE.md)** - Complete step-by-step setup
   - ✅ **[Deployment Checklist](DEPLOYMENT_CHECKLIST.md)** - Ensure nothing is missed
   - 🔧 **[Troubleshooting Guide](TROUBLESHOOTING.md)** - Solve common issues

## 📋 **What's Included**

### 🔐 **Security & Authentication**
- **Authentik** - Identity provider with SSO
- **Traefik** - Reverse proxy with automatic SSL
- **CrowdSec** - Intrusion detection and prevention
- **Fail2ban** - Brute force protection
- **UFW Firewall** - Network security

### 📊 **Monitoring & Observability**
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Loki** - Log aggregation
- **AlertManager** - Alert routing and notification
- **Node Exporter** - System metrics

### 🗄️ **Databases & Storage**
- **PostgreSQL** - Primary database
- **Redis** - Caching and sessions
- **Backup System** - Automated data protection
- **Storage Management** - File organization

### 📺 **Media Services**
- **Sonarr** - TV show management
- **Radarr** - Movie management
- **Jellyfin** - Media server
- **Overseerr** - Media requests
- **Download Clients** - qBittorrent, SABnzbd

### 🔧 **Utilities & Management**
- **Portainer** - Docker management
- **Homepage** - Service dashboard
- **Watchtower** - Automatic updates
- **Health Checks** - Service monitoring

## 🏗️ **Architecture**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Internet      │    │   Cloudflare    │    │   Your Server   │
│                 │◄──►│   (DNS + SSL)   │◄──►│                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Traefik (Reverse Proxy)                 │
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
│  │   Radarr    │  │  Jellyfin   │  │  PostgreSQL │            │
│  │  (Movies)   │  │ (Media)     │  │ (Database)  │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │  Prometheus │  │     Loki    │  │    Redis    │            │
│  │ (Metrics)   │  │   (Logs)    │  │  (Cache)    │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

## 📚 **Documentation**

### 🚀 **Getting Started**
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

## 🎯 **Key Features**

### ✅ **Production Ready**
- **High Availability** - Service redundancy and failover
- **Security Hardened** - Industry-standard security practices
- **Automated Backups** - Data protection and recovery
- **Monitoring & Alerting** - Proactive issue detection
- **Performance Optimized** - Resource-efficient operation

### 🔄 **Automated Operations**
- **Zero-Downtime Updates** - Seamless service updates
- **Health Monitoring** - Continuous service validation
- **Auto-Recovery** - Automatic service restoration
- **Resource Management** - Intelligent resource allocation
- **Log Aggregation** - Centralized logging and analysis

### 🛡️ **Enterprise Security**
- **SSO Authentication** - Single sign-on for all services
- **SSL/TLS Encryption** - End-to-end encryption
- **Intrusion Detection** - Real-time threat monitoring
- **Access Control** - Role-based permissions
- **Audit Logging** - Comprehensive activity tracking

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

### **Quick Deployment**
```bash
# 1. Clone and setup
git clone https://github.com/yourusername/ansible_homelab.git
cd ansible_homelab
./scripts/seamless_setup.sh
```

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
The setup script creates a `.env` file with all necessary configuration:

```bash
# Basic Configuration
DOMAIN=your-domain.com
SERVER_IP=192.168.1.100
TIMEZONE=America/New_York
USERNAME=homelab

# Network Configuration
GATEWAY_IP=192.168.1.1
DNS_SERVERS=1.1.1.1,8.8.8.8
INTERNAL_SUBNET=192.168.1.0/24

# Cloudflare Configuration
CLOUDFLARE_EMAIL=your-email@domain.com
CLOUDFLARE_API_TOKEN=your-api-token
```

### **Service Configuration**
Each service can be customized through:
- **Environment variables** in `.env`
- **Docker Compose files** in `/opt/docker/<service>/`
- **Configuration files** in `/opt/config/<service>/`

## 📈 **Monitoring & Health**

### **Service Health**
- **Grafana Dashboards** - System and service metrics
- **Prometheus Alerts** - Automated alerting
- **Health Checks** - Service availability monitoring
- **Log Analysis** - Centralized log management

### **Key Metrics**
- **System Resources** - CPU, memory, disk usage
- **Service Performance** - Response times, error rates
- **Network Traffic** - Bandwidth, connection counts
- **Security Events** - Failed logins, suspicious activity

## 🔄 **Maintenance**

### **Automated Tasks**
- **Daily Backups** - Automated data protection
- **Weekly Updates** - Security and feature updates
- **Monthly Cleanup** - Log rotation and cleanup
- **Quarterly Reviews** - Performance and security audits

### **Manual Tasks**
- **Configuration Updates** - Service configuration changes
- **Security Reviews** - Regular security assessments
- **Performance Tuning** - Optimization based on usage
- **Documentation Updates** - Keep docs current

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Setup**
```bash
# Clone with submodules
git clone --recursive https://github.com/yourusername/ansible_homelab.git

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

1. **Read the [Quick Start Guide](QUICK_START_GUIDE.md)**
2. **Check the [Deployment Checklist](DEPLOYMENT_CHECKLIST.md)**
3. **Follow the setup instructions**
4. **Join our community for support**

**Happy Homelabbing! 🏠✨** 