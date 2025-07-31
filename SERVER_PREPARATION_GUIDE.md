# Server Preparation Automation Guide

## Overview

The server preparation script automates the complete setup of a stock Ubuntu desktop installation for homelab deployment. It handles static IP configuration, SSH key setup, server hardening, and all essential software installation.

## 🎯 **What Gets Automated**

### **Network Configuration**
- ✅ **Static IP Setup** - Automatic netplan configuration
- ✅ **Gateway Configuration** - Default route setup
- ✅ **DNS Configuration** - Primary and secondary DNS
- ✅ **Network Validation** - Connectivity testing

### **SSH Security**
- ✅ **SSH Key Generation** - Automatic RSA key pair creation
- ✅ **SSH Server Hardening** - Security-focused configuration
- ✅ **Password Authentication Disabled** - Key-based auth only
- ✅ **Root Login Disabled** - Enhanced security

### **System Security**
- ✅ **Firewall Setup** - UFW with homelab-specific rules
- ✅ **Fail2ban Configuration** - Intrusion prevention
- ✅ **System Hardening** - Sysctl security settings
- ✅ **Security Tools** - rkhunter, chkrootkit, lynis
- ✅ **Automatic Updates** - Security patch automation

### **Software Installation**
- ✅ **Docker CE** - Official Docker with compose
- ✅ **Ansible** - Latest version from PPA
- ✅ **Essential Packages** - All required tools
- ✅ **Development Tools** - Git, Python, build tools

### **User Management**
- ✅ **Homelab User Creation** - Dedicated service user
- ✅ **Sudo Access** - Proper privilege escalation
- ✅ **SSH Key Distribution** - Keys copied to new user
- ✅ **Secure Passwords** - Cryptographically random

## 🚀 **Quick Start**

### **Prerequisites**
- Stock Ubuntu 20.04+ desktop installation
- Root access (sudo privileges)
- Internet connection
- Physical or remote access to server

### **Step 1: Download and Run**
```bash
# Download the script to your server
wget https://raw.githubusercontent.com/your-repo/ansible_homelab/main/scripts/server_preparation.sh

# Make executable
chmod +x server_preparation.sh

# Run as root
sudo ./server_preparation.sh
```

### **Step 2: Follow Interactive Prompts**
The script will guide you through:
1. **Network Configuration** - Static IP, gateway, DNS
2. **User Setup** - Homelab username
3. **Security Confirmation** - Review security settings

### **Step 3: Verify Setup**
```bash
# Test SSH connection
ssh homelab@YOUR_STATIC_IP

# Check Docker
docker --version

# Check Ansible
ansible --version

# View server information
cat /home/homelab/server_info.txt
```

## 📋 **Interactive Configuration**

### **Network Configuration**
The script will ask for:
- **Static IP Address** (defaults to current IP)
- **Gateway IP** (defaults to current gateway)
- **Primary DNS** (defaults to 8.8.8.8)
- **Secondary DNS** (defaults to 8.8.4.4)

### **User Configuration**
- **Homelab Username** (defaults to "homelab")
- **SSH Key Generation** (automatic)
- **Password Generation** (automatic secure password)

## 🔒 **Security Features**

### **SSH Hardening**
```bash
# Security settings applied:
- Password authentication: DISABLED
- Root login: DISABLED
- Key-based authentication: ENABLED
- Strong encryption algorithms only
- Connection timeouts configured
- Maximum authentication attempts: 3
```

### **Firewall Configuration**
```bash
# UFW rules applied:
- Default policy: DENY incoming, ALLOW outgoing
- SSH (port 22): ALLOWED
- HTTP (port 80): ALLOWED
- HTTPS (port 443): ALLOWED
- DNS (port 53): ALLOWED
- Local network: ALLOWED
```

### **System Security**
```bash
# Security hardening applied:
- Automatic security updates: ENABLED
- Fail2ban: CONFIGURED and ENABLED
- System limits: INCREASED
- Network security: HARDENED
- Security tools: INSTALLED
```

## 📊 **What Gets Installed**

### **Essential Packages**
```bash
curl wget git python3 python3-pip python3-venv
software-properties-common apt-transport-https
ca-certificates gnupg lsb-release htop iotop
nethogs tree vim nano rsync unzip zip jq bc
logrotate fail2ban rkhunter chkrootkit lynis
```

### **Docker Installation**
```bash
# Official Docker CE
- Docker Engine
- Docker CLI
- Containerd
- Docker Compose Plugin
```

### **Ansible Installation**
```bash
# Latest Ansible from PPA
- Ansible core
- Ansible collections
- Python dependencies
```

## 🔍 **Example Output**

```
================================================
  🔧 Server Preparation Automation
  🛡️  Security-First Ubuntu Configuration
  📋 Complete Server Setup & Hardening
================================================

[STEP 1] Gathering network information...
✓ Network information gathered
Current IP: 192.168.1.100
Interface: enp0s3
Gateway: 192.168.1.1
Subnet: /24
DNS: 8.8.8.8 8.8.4.4

[STEP 2] Configuring static IP address...

Network Configuration:
Enter static IP address (default: 192.168.1.100): 192.168.1.100
Enter gateway IP (default: 192.168.1.1): 192.168.1.1
Enter primary DNS (default: 8.8.8.8): 8.8.8.8
Enter secondary DNS (default: 8.8.4.4): 8.8.4.4

✓ Network configuration gathered
Static IP: 192.168.1.100
Gateway: 192.168.1.1
DNS: 8.8.8.8, 8.8.4.4
Network: 192.168.1.0/24

[STEP 3] Setting up static IP configuration...
✓ Backed up current netplan configuration
✓ Static IP configuration applied successfully
✓ Network connectivity verified

[STEP 4] Setting up SSH key authentication...
✓ SSH key pair generated
✓ SSH public key added to authorized_keys

[STEP 5] Configuring SSH server security...
✓ SSH configuration is valid
✓ SSH service restarted

[STEP 6] Setting up firewall (UFW)...
✓ UFW installed
✓ Firewall configured and enabled

[STEP 7] Installing essential packages...
✓ Essential packages installed

[STEP 8] Configuring system security...
✓ System security configured

[STEP 9] Creating homelab user...
Enter homelab username (default: homelab): homelab
✓ Created user: homelab
✓ Set secure password for homelab
✓ Homelab user configured

[STEP 10] Installing Docker...
✓ Docker installed and configured

[STEP 11] Installing Ansible...
✓ Ansible installed

[STEP 12] Generating server information...
✓ Server information generated

[STEP 13] SSH Key Information...

🔑 SSH KEY INFORMATION
Public Key Location: /home/ubuntu/.ssh/id_rsa.pub
Private Key Location: /home/ubuntu/.ssh/id_rsa

Copy this public key to your local machine:
scp ubuntu@192.168.1.100:/home/ubuntu/.ssh/id_rsa.pub ~/.ssh/homelab_server.pub

Or copy the private key to your local machine:
scp ubuntu@192.168.1.100:/home/ubuntu/.ssh/id_rsa ~/.ssh/homelab_server

Test SSH connection:
ssh homelab@192.168.1.100

================================================
🎉 Server preparation completed successfully!

📋 SUMMARY:
✅ Static IP configured: 192.168.1.100
✅ SSH keys generated and configured
✅ Firewall enabled and configured
✅ System security hardened
✅ Homelab user created: homelab
✅ Docker installed and configured
✅ Ansible installed
✅ Essential packages installed

📁 Server information saved to:
/home/homelab/server_info.txt

🚀 Ready for homelab deployment!
```

## ⚠️ **Troubleshooting**

### **Common Issues**

#### **1. Network Configuration Fails**
```bash
# If static IP configuration fails:
sudo netplan try --timeout 30
sudo netplan apply

# Check network status:
ip addr show
ip route show
```

#### **2. SSH Connection Issues**
```bash
# Test SSH locally:
ssh localhost

# Check SSH service:
sudo systemctl status ssh

# Check SSH configuration:
sudo sshd -t
```

#### **3. Docker Installation Issues**
```bash
# Check Docker service:
sudo systemctl status docker

# Test Docker:
sudo docker run hello-world

# Check user groups:
groups $USER
```

#### **4. Firewall Issues**
```bash
# Check UFW status:
sudo ufw status

# Check UFW rules:
sudo ufw status numbered

# Reset UFW if needed:
sudo ufw --force reset
```

### **Recovery Procedures**

#### **Network Recovery**
```bash
# Restore original network config:
sudo cp /etc/netplan/01-network-manager-all.yaml.backup /etc/netplan/01-network-manager-all.yaml
sudo netplan apply
```

#### **SSH Recovery**
```bash
# Restore original SSH config:
sudo cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
sudo systemctl restart ssh
```

## 🔐 **Security Notes**

### **SSH Key Management**
- **Private Key**: Keep secure, never share
- **Public Key**: Can be shared safely
- **Backup**: Store keys in secure location
- **Rotation**: Regularly rotate SSH keys

### **Firewall Rules**
- **Default Policy**: Deny incoming, allow outgoing
- **SSH Protection**: Rate limiting via fail2ban
- **Service Access**: Only required ports open
- **Local Network**: Full access for management

### **System Security**
- **Automatic Updates**: Security patches applied automatically
- **Intrusion Detection**: Fail2ban monitors SSH access
- **Security Tools**: rkhunter, chkrootkit, lynis installed
- **System Hardening**: Kernel parameters optimized for security

## 📈 **Benefits**

### **Time Savings**
- **Manual Setup**: 2-3 hours
- **Automated Setup**: 15-20 minutes
- **Time Reduction**: 90% faster

### **Error Reduction**
- **No manual configuration errors**
- **Consistent security settings**
- **Automatic validation**
- **Rollback mechanisms**

### **Security Improvements**
- **SSH hardened by default**
- **Firewall configured automatically**
- **Security tools pre-installed**
- **System hardening applied**

## 🎯 **Next Steps**

After server preparation:
1. **Copy SSH key** to your local machine
2. **Test SSH connection** to the server
3. **Run homelab deployment**: `./scripts/seamless_setup.sh`
4. **Configure DNS records** (automated if using Cloudflare)
5. **Deploy homelab services** (fully automated)

The server preparation script ensures your Ubuntu system is ready for homelab deployment with enterprise-grade security and all required software pre-installed. 