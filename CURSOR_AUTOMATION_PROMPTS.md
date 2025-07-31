# Cursor Automation Implementation Prompts

## Overview

These comprehensive prompts are designed for Cursor to implement the remaining automations in our homelab deployment system. Each prompt includes detailed requirements, technical specifications, and integration points.

---

## 🚀 **Prompt 1: External Service Integration Automation**

### **Objective**
Implement automated setup for Slack, Discord, and Telegram integrations during homelab deployment.

### **Prompt**
```
I need to implement automated external service integration for our homelab deployment system. This should handle Slack, Discord, and Telegram setup during the seamless deployment process.

**Requirements:**

1. **Slack Integration:**
   - Create webhook URL generation automation
   - Test webhook connectivity
   - Configure webhook for different alert types (security, monitoring, backup)
   - Store webhook URL securely in vault

2. **Discord Integration:**
   - Create Discord bot setup automation
   - Generate bot token and invite link
   - Configure bot permissions (send messages, read channels)
   - Test bot connectivity
   - Store bot token securely in vault

3. **Telegram Integration:**
   - Create Telegram bot setup automation
   - Generate bot token via BotFather
   - Get chat ID for notifications
   - Test bot connectivity
   - Store bot token and chat ID securely in vault

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store credentials in `group_vars/all/vault.yml`
- **Validation:** Test connectivity before proceeding
- **Error Handling:** Graceful fallback if services are unavailable
- **Security:** All tokens stored encrypted in vault

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}External Service Integration (Optional):${NC}"
read -p "Configure Slack notifications? [y/N]: " configure_slack
if [[ $configure_slack =~ ^[Yy]$ ]]; then
    # Slack automation logic
fi

read -p "Configure Discord notifications? [y/N]: " configure_discord
if [[ $configure_discord =~ ^[Yy]$ ]]; then
    # Discord automation logic
fi

read -p "Configure Telegram notifications? [y/N]: " configure_telegram
if [[ $configure_telegram =~ ^[Yy]$ ]]; then
    # Telegram automation logic
fi
```

**Implementation Files:**
- `scripts/slack_integration.sh` - Slack webhook automation
- `scripts/discord_integration.sh` - Discord bot automation  
- `scripts/telegram_integration.sh` - Telegram bot automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Credential storage

**Expected Output:**
- Interactive prompts for each service
- Automatic webhook/bot creation
- Connectivity testing
- Secure credential storage
- Integration with existing notification system

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 2: Backup Infrastructure Automation**

### **Objective**
Implement automated cloud storage integration for backup infrastructure (Backblaze, AWS S3, Google Cloud Storage).

### **Prompt**
```
I need to implement automated backup infrastructure setup for our homelab deployment system. This should handle cloud storage integration for automated backups.

**Requirements:**

1. **Backblaze B2 Integration:**
   - Create application key with specific permissions
   - Create bucket for homelab backups
   - Configure bucket lifecycle policies
   - Test connectivity and permissions
   - Store credentials securely

2. **AWS S3 Integration:**
   - Create IAM user with minimal permissions
   - Create S3 bucket with encryption
   - Configure bucket policies and lifecycle
   - Test connectivity and permissions
   - Store credentials securely

3. **Google Cloud Storage Integration:**
   - Create service account with minimal permissions
   - Create storage bucket with encryption
   - Configure bucket lifecycle policies
   - Test connectivity and permissions
   - Store credentials securely

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store credentials in `group_vars/all/vault.yml`
- **Validation:** Test connectivity and permissions before proceeding
- **Error Handling:** Graceful fallback if cloud services are unavailable
- **Security:** All credentials stored encrypted in vault
- **Backup Strategy:** Configure retention policies and encryption

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}Backup Infrastructure Setup (Optional):${NC}"
read -p "Configure cloud backup storage? [y/N]: " configure_backup
if [[ $configure_backup =~ ^[Yy]$ ]]; then
    echo "Select backup provider:"
    echo "1. Backblaze B2"
    echo "2. AWS S3"
    echo "3. Google Cloud Storage"
    read -p "Enter choice (1-3): " backup_provider
    
    case $backup_provider in
        1) # Backblaze automation
        2) # AWS S3 automation
        3) # Google Cloud automation
    esac
fi
```

**Implementation Files:**
- `scripts/backblaze_integration.sh` - Backblaze B2 automation
- `scripts/aws_s3_integration.sh` - AWS S3 automation
- `scripts/gcs_integration.sh` - Google Cloud Storage automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Credential storage
- `roles/backup/tasks/main.yml` - Backup automation tasks

**Expected Output:**
- Interactive provider selection
- Automatic credential generation
- Bucket/container creation
- Permission configuration
- Connectivity testing
- Integration with existing backup system

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 3: SSL Certificate Management Automation**

### **Objective**
Implement automated wildcard certificate setup and certificate renewal monitoring.

### **Prompt**
```
I need to implement automated SSL certificate management for our homelab deployment system. This should handle wildcard certificates and certificate renewal monitoring.

**Requirements:**

1. **Wildcard Certificate Setup:**
   - Automate Let's Encrypt wildcard certificate creation
   - Configure DNS challenge for wildcard certificates
   - Set up automatic renewal
   - Configure Traefik to use wildcard certificates
   - Test certificate validity

2. **Certificate Renewal Monitoring:**
   - Monitor certificate expiration dates
   - Send alerts before certificates expire
   - Automatic renewal attempts
   - Certificate transparency monitoring
   - Backup certificate management

3. **Certificate Transparency:**
   - Monitor CT logs for certificate issuance
   - Alert on unexpected certificate creation
   - Log certificate changes
   - Validate certificate chain

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store certificate information in `group_vars/all/vault.yml`
- **Validation:** Test certificate validity and renewal process
- **Error Handling:** Graceful fallback if certificate creation fails
- **Security:** All certificate data stored encrypted in vault
- **Monitoring:** Integration with existing monitoring stack

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}SSL Certificate Management (Optional):${NC}"
read -p "Configure wildcard SSL certificates? [y/N]: " configure_ssl
if [[ $configure_ssl =~ ^[Yy]$ ]]; then
    read -p "Domain for wildcard certificate: " wildcard_domain
    read -p "Enable certificate renewal monitoring? [Y/n]: " cert_monitoring
    
    # SSL automation logic
fi
```

**Implementation Files:**
- `scripts/ssl_certificate_setup.sh` - Wildcard certificate automation
- `scripts/certificate_monitoring.sh` - Renewal monitoring
- `scripts/certificate_transparency.sh` - CT monitoring
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Certificate storage
- `roles/traefik/templates/traefik.yml.j2` - Certificate configuration

**Expected Output:**
- Interactive domain configuration
- Automatic wildcard certificate creation
- Renewal monitoring setup
- Certificate transparency monitoring
- Integration with Traefik configuration

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 4: External Monitoring Setup Automation**

### **Objective**
Implement automated external monitoring setup (Uptime Kuma, Pingdom, StatusCake).

### **Prompt**
```
I need to implement automated external monitoring setup for our homelab deployment system. This should handle external uptime monitoring services.

**Requirements:**

1. **Uptime Kuma Integration:**
   - Create Uptime Kuma instance
   - Configure monitoring endpoints
   - Set up notification channels
   - Configure monitoring intervals
   - Test monitoring functionality

2. **Pingdom Integration:**
   - Create Pingdom account
   - Configure HTTP checks
   - Set up notification settings
   - Configure monitoring locations
   - Test monitoring functionality

3. **StatusCake Integration:**
   - Create StatusCake account
   - Configure uptime tests
   - Set up notification settings
   - Configure test locations
   - Test monitoring functionality

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store credentials in `group_vars/all/vault.yml`
- **Validation:** Test monitoring functionality before proceeding
- **Error Handling:** Graceful fallback if services are unavailable
- **Security:** All credentials stored encrypted in vault
- **Monitoring:** Integration with existing monitoring stack

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}External Monitoring Setup (Optional):${NC}"
read -p "Configure external monitoring? [y/N]: " configure_monitoring
if [[ $configure_monitoring =~ ^[Yy]$ ]]; then
    echo "Select monitoring provider:"
    echo "1. Uptime Kuma (Self-hosted)"
    echo "2. Pingdom"
    echo "3. StatusCake"
    read -p "Enter choice (1-3): " monitoring_provider
    
    case $monitoring_provider in
        1) # Uptime Kuma automation
        2) # Pingdom automation
        3) # StatusCake automation
    esac
fi
```

**Implementation Files:**
- `scripts/uptime_kuma_setup.sh` - Uptime Kuma automation
- `scripts/pingdom_integration.sh` - Pingdom automation
- `scripts/statuscake_integration.sh` - StatusCake automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Credential storage
- `roles/monitoring/tasks/external_monitoring.yml` - Monitoring tasks

**Expected Output:**
- Interactive provider selection
- Automatic account creation
- Monitoring endpoint configuration
- Notification setup
- Integration with existing monitoring

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 5: Network Infrastructure Automation**

### **Objective**
Implement automated router configuration and network infrastructure setup.

### **Prompt**
```
I need to implement automated network infrastructure setup for our homelab deployment system. This should handle router configuration and network setup.

**Requirements:**

1. **Router Configuration:**
   - Detect router type and model
   - Configure port forwarding rules
   - Set up DMZ configuration
   - Configure DNS settings
   - Test network connectivity

2. **VLAN Setup:**
   - Create VLANs for network segmentation
   - Configure VLAN routing
   - Set up VLAN security policies
   - Configure VLAN monitoring
   - Test VLAN connectivity

3. **Load Balancer Setup:**
   - Configure load balancer rules
   - Set up health checks
   - Configure SSL termination
   - Set up monitoring
   - Test load balancer functionality

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store configuration in `group_vars/all/vault.yml`
- **Validation:** Test network connectivity before proceeding
- **Error Handling:** Graceful fallback if router configuration fails
- **Security:** All configuration stored encrypted in vault
- **Network:** Integration with existing network stack

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}Network Infrastructure Setup (Optional):${NC}"
read -p "Configure network infrastructure? [y/N]: " configure_network
if [[ $configure_network =~ ^[Yy]$ ]]; then
    echo "Select network configuration:"
    echo "1. Router Configuration"
    echo "2. VLAN Setup"
    echo "3. Load Balancer Setup"
    read -p "Enter choice (1-3): " network_config
    
    case $network_config in
        1) # Router automation
        2) # VLAN automation
        3) # Load balancer automation
    esac
fi
```

**Implementation Files:**
- `scripts/router_configuration.sh` - Router automation
- `scripts/vlan_setup.sh` - VLAN automation
- `scripts/load_balancer_setup.sh` - Load balancer automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Configuration storage
- `roles/network/tasks/main.yml` - Network tasks

**Expected Output:**
- Interactive network configuration
- Automatic router setup
- VLAN configuration
- Load balancer setup
- Network connectivity testing

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 6: Development Environment Automation**

### **Objective**
Implement automated development environment setup (IDE, Git, CI/CD).

### **Prompt**
```
I need to implement automated development environment setup for our homelab deployment system. This should handle IDE, Git, and CI/CD configuration.

**Requirements:**

1. **IDE/Editor Setup:**
   - Install and configure VS Code Server
   - Set up development extensions
   - Configure Git integration
   - Set up debugging tools
   - Configure workspace settings

2. **Git Repository Setup:**
   - Create GitLab/GitHub integration
   - Set up repository structure
   - Configure webhooks
   - Set up branch protection
   - Configure CI/CD pipelines

3. **CI/CD Pipeline Setup:**
   - Configure GitLab CI/CD
   - Set up GitHub Actions
   - Configure deployment pipelines
   - Set up testing automation
   - Configure monitoring integration

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store credentials in `group_vars/all/vault.yml`
- **Validation:** Test development environment before proceeding
- **Error Handling:** Graceful fallback if setup fails
- **Security:** All credentials stored encrypted in vault
- **Development:** Integration with existing development stack

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}Development Environment Setup (Optional):${NC}"
read -p "Configure development environment? [y/N]: " configure_dev
if [[ $configure_dev =~ ^[Yy]$ ]]; then
    echo "Select development setup:"
    echo "1. IDE/Editor Setup"
    echo "2. Git Repository Setup"
    echo "3. CI/CD Pipeline Setup"
    read -p "Enter choice (1-3): " dev_config
    
    case $dev_config in
        1) # IDE automation
        2) # Git automation
        3) # CI/CD automation
    esac
fi
```

**Implementation Files:**
- `scripts/ide_setup.sh` - IDE automation
- `scripts/git_setup.sh` - Git automation
- `scripts/cicd_setup.sh` - CI/CD automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Credential storage
- `roles/development/tasks/main.yml` - Development tasks

**Expected Output:**
- Interactive development setup
- Automatic IDE configuration
- Git repository setup
- CI/CD pipeline configuration
- Development environment testing

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 7: Media Library Automation**

### **Objective**
Implement automated media library setup and content management.

### **Prompt**
```
I need to implement automated media library setup for our homelab deployment system. This should handle media source configuration and content management.

**Requirements:**

1. **Media Source Configuration:**
   - Set up media directories structure
   - Configure permissions and ownership
   - Set up media scanning
   - Configure metadata extraction
   - Set up media organization

2. **Download Client Setup:**
   - Configure qBittorrent
   - Set up Usenet clients
   - Configure download paths
   - Set up download monitoring
   - Configure download automation

3. **Media Library Scanning:**
   - Set up automatic library scanning
   - Configure metadata fetching
   - Set up artwork downloading
   - Configure library organization
   - Set up backup procedures

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store configuration in `group_vars/all/vault.yml`
- **Validation:** Test media library functionality before proceeding
- **Error Handling:** Graceful fallback if setup fails
- **Security:** All configuration stored encrypted in vault
- **Media:** Integration with existing media stack

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}Media Library Setup (Optional):${NC}"
read -p "Configure media library? [y/N]: " configure_media
if [[ $configure_media =~ ^[Yy]$ ]]; then
    echo "Select media setup:"
    echo "1. Media Source Configuration"
    echo "2. Download Client Setup"
    echo "3. Media Library Scanning"
    read -p "Enter choice (1-3): " media_config
    
    case $media_config in
        1) # Media source automation
        2) # Download client automation
        3) # Library scanning automation
    esac
fi
```

**Implementation Files:**
- `scripts/media_source_setup.sh` - Media source automation
- `scripts/download_client_setup.sh` - Download client automation
- `scripts/media_library_setup.sh` - Library scanning automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Configuration storage
- `roles/media/tasks/library_setup.yml` - Media tasks

**Expected Output:**
- Interactive media setup
- Automatic directory creation
- Download client configuration
- Library scanning setup
- Media library testing

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 🚀 **Prompt 8: Advanced Security Hardening**

### **Objective**
Implement advanced security hardening including network segmentation and IDS/IPS.

### **Prompt**
```
I need to implement advanced security hardening for our homelab deployment system. This should handle network segmentation and IDS/IPS configuration.

**Requirements:**

1. **Network Segmentation:**
   - Create VLANs for different services
   - Configure VLAN routing
   - Set up VLAN security policies
   - Configure VLAN monitoring
   - Test VLAN connectivity

2. **IDS/IPS Setup:**
   - Install and configure Snort/Suricata
   - Set up intrusion detection rules
   - Configure alert notifications
   - Set up log monitoring
   - Configure automatic updates

3. **Advanced Firewall:**
   - Configure iptables/nftables
   - Set up advanced firewall rules
   - Configure DDoS protection
   - Set up traffic monitoring
   - Configure automatic rule updates

**Technical Specifications:**

- **Integration Point:** Add to `scripts/seamless_setup.sh` in the `get_configuration()` function
- **Storage:** Store configuration in `group_vars/all/vault.yml`
- **Validation:** Test security configuration before proceeding
- **Error Handling:** Graceful fallback if setup fails
- **Security:** All configuration stored encrypted in vault
- **Monitoring:** Integration with existing security stack

**Code Structure:**
```bash
# Add to get_configuration() function
echo ""
echo -e "${YELLOW}Advanced Security Hardening (Optional):${NC}"
read -p "Configure advanced security? [y/N]: " configure_security
if [[ $configure_security =~ ^[Yy]$ ]]; then
    echo "Select security setup:"
    echo "1. Network Segmentation"
    echo "2. IDS/IPS Setup"
    echo "3. Advanced Firewall"
    read -p "Enter choice (1-3): " security_config
    
    case $security_config in
        1) # Network segmentation automation
        2) # IDS/IPS automation
        3) # Advanced firewall automation
    esac
fi
```

**Implementation Files:**
- `scripts/network_segmentation.sh` - Network segmentation automation
- `scripts/ids_ips_setup.sh` - IDS/IPS automation
- `scripts/advanced_firewall.sh` - Advanced firewall automation
- Update `scripts/seamless_setup.sh` - Integration points
- Update `group_vars/all/vault.yml` - Configuration storage
- `roles/security/tasks/advanced_hardening.yml` - Security tasks

**Expected Output:**
- Interactive security setup
- Automatic VLAN configuration
- IDS/IPS setup
- Advanced firewall configuration
- Security testing

Please implement this automation following our security-first approach with no hardcoded values.
```

---

## 📋 **Implementation Priority Order**

1. **External Service Integration** - High impact, low complexity
2. **Backup Infrastructure** - Critical for data protection
3. **SSL Certificate Management** - Security improvement
4. **External Monitoring** - Reliability improvement
5. **Network Infrastructure** - Complete automation
6. **Development Environment** - Developer experience
7. **Media Library** - User experience
8. **Advanced Security** - Security enhancement

Each prompt includes comprehensive requirements, technical specifications, and integration points to ensure successful implementation following our security-first approach. 