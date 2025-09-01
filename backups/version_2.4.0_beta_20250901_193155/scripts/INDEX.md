# Scripts Directory Index

## 🚀 **Primary Setup Scripts**

### **Main Setup**
- **[seamless_setup.sh](seamless_setup.sh)** - Complete turnkey homelab deployment (30 minutes)
- **[post_setup_info.sh](post_setup_info.sh)** - Display all service URLs after setup

### **Service Management**
- **[add_service.sh](add_service.sh)** - Service integration wizard (add new services)
- **[integrate_server.sh](integrate_server.sh)** - **✨ NEW: External server integration wizard**

## 🏠 **✨ NEW: External Server Integration**

**`integrate_server.sh`** - Seamlessly integrate external servers into your HomelabOS ecosystem!

### **Quick Usage**
```bash
# Interactive setup (recommended)
./scripts/integrate_server.sh

# Command line setup
./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000

# Configuration file setup
./scripts/integrate_server.sh --config config/external_servers.yml
```

### **Supported External Servers**
- **Storage**: Synology, TrueNAS, Unraid
- **Virtualization**: Proxmox, VMware ESXi
- **Home Automation**: Home Assistant, OpenHAB
- **Network**: Routers, Pi-hole, Firewalls
- **Security**: NVR systems, IP cameras
- **Development**: Git servers, CI/CD systems
- **Gaming**: Game servers, Steam servers

### **Integration Features**
- ✅ **SSL Certificates** - Automatic Let's Encrypt certificates
- ✅ **DNS Management** - Automatic subdomain creation
- ✅ **Grafana Monitoring** - Custom dashboards for each server
- ✅ **Traefik Proxy** - Reverse proxy with authentication
- ✅ **Health Monitoring** - Automated health checks and alerting
- ✅ **Backup Integration** - Automated backup configuration
- ✅ **Homepage Integration** - Unified dashboard access

**📖 Complete Guide**: [External Server Integration Guide](../docs/EXTERNAL_SERVER_INTEGRATION.md)

## 🔧 **Utility Scripts**

### **Configuration & Setup**
- **[setup_environment.sh](setup_environment.sh)** - Environment setup and validation
- **[setup_vault_env.sh](setup_vault_env.sh)** - Vault environment configuration
- **[setup_monitoring_env.sh](setup_monitoring_env.sh)** - Monitoring environment setup

### **Deployment & Validation**
- **[test_deployment.sh](test_deployment.sh)** - Test deployment configuration
- **[validate_services.sh](validate_services.sh)** - Validate all services
- **[check_port_conflicts.py](check_port_conflicts.py)** - Port conflict detection

### **DNS & Network**
- **[automate_dns_setup.py](automate_dns_setup.py)** - Automated DNS record creation
- **[service_discovery/](service_discovery/)** - Service discovery utilities

### **Documentation**
- **[post_setup_info.sh](post_setup_info.sh)** - Display service URLs and information
- **[generate_docs.sh](generate_docs.sh)** - Generate personalized documentation

## 📚 **Documentation**

- **[README_SERVICE_WIZARD.md](README_SERVICE_WIZARD.md)** - Service integration wizard guide
- **[EXTERNAL_SERVER_INTEGRATION.md](../docs/EXTERNAL_SERVER_INTEGRATION.md)** - External server integration guide

---

**💡 Pro Tip**: Start with `seamless_setup.sh` for initial deployment, then use `integrate_server.sh` to add external servers to your ecosystem! 