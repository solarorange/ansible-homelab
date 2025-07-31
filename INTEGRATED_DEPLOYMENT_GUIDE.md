# Integrated Homelab Deployment Guide

## Overview

The seamless deployment script now includes **integrated server preparation**, creating a true end-to-end automation from stock Ubuntu to fully deployed homelab. No separate scripts needed!

## 🎯 **What's New: Integrated Server Preparation**

### **Before (Separate Scripts)**
```bash
# Step 1: Server preparation (separate script)
sudo ./scripts/server_preparation.sh

# Step 2: Homelab deployment (separate script)
./scripts/seamless_setup.sh
```

### **Now (Single Script)**
```bash
# One script does everything!
sudo ./scripts/seamless_setup.sh
```

## 🚀 **Complete Automation Flow**

### **Step 1: Detection & Preparation**
The script automatically detects if server preparation is needed:
- ✅ **Ubuntu Detection** - Checks if running on Ubuntu
- ✅ **Docker Check** - Detects if Docker is installed
- ✅ **Preparation Offer** - Prompts to run server preparation
- ✅ **Root Access** - Handles root privileges automatically

### **Step 2: Server Preparation (If Needed)**
If server preparation is required, it automatically:
- ✅ **Static IP Configuration** - Interactive setup with validation
- ✅ **SSH Key Generation** - Automatic RSA key pair creation
- ✅ **SSH Server Hardening** - Security-focused configuration
- ✅ **Firewall Setup** - UFW with homelab-specific rules
- ✅ **System Security** - Fail2ban, security tools, sysctl hardening
- ✅ **User Management** - Homelab user creation with sudo access
- ✅ **Docker Installation** - Official Docker CE with compose
- ✅ **Ansible Installation** - Latest version from PPA
- ✅ **Essential Packages** - All required tools and security utilities

### **Step 3: Homelab Deployment**
After server preparation (or if already prepared):
- ✅ **Configuration Gathering** - Interactive setup
- ✅ **DNS Automation** - Cloudflare API integration
- ✅ **Secure Vault Generation** - Cryptographically secure credentials
- ✅ **Configuration Creation** - All Ansible variables
- ✅ **SSH Setup** - Key distribution and validation
- ✅ **Service Deployment** - Complete homelab stack

## 📋 **Usage Scenarios**

### **Scenario 1: Stock Ubuntu Installation**
```bash
# Download the script
wget https://raw.githubusercontent.com/your-repo/ansible_homelab/main/scripts/seamless_setup.sh
chmod +x seamless_setup.sh

# Run as root (server preparation will be offered)
sudo ./seamless_setup.sh
```

**What happens:**
1. Script detects stock Ubuntu (no Docker)
2. Offers server preparation automation
3. Runs complete server preparation
4. Switches to homelab user
5. Continues with homelab deployment
6. Complete homelab ready in ~2 hours

### **Scenario 2: Pre-prepared Server**
```bash
# Run as homelab user (server already prepared)
./seamless_setup.sh
```

**What happens:**
1. Script detects Docker is installed
2. Skips server preparation
3. Proceeds directly to homelab deployment
4. Complete homelab ready in ~1 hour

### **Scenario 3: Non-Ubuntu System**
```bash
# Run on non-Ubuntu system
sudo ./seamless_setup.sh
```

**What happens:**
1. Script detects non-Ubuntu system
2. Warns that server preparation is not available
3. Checks for required dependencies
4. Proceeds with homelab deployment if dependencies are met

## 🔍 **Example Output (Integrated Flow)**

```
================================================
  🚀 Seamless Homelab Deployment
  🔐 Complete Turnkey & Automatic Setup
  📋 PRIMARY SETUP SCRIPT - No other setup needed
  🔧 INCLUDES SERVER PREPARATION - Stock Ubuntu to Homelab
================================================

[STEP 1] Checking prerequisites and server preparation...

🔍 Server Preparation Check
⚠ Docker not found - server preparation needed

Server Preparation Required:
This appears to be a stock Ubuntu installation that needs server preparation.
The seamless setup can automatically prepare your server for homelab deployment.

Run server preparation automation? [Y/n]: Y

[STEP 1.1] Running server preparation automation...
Executing server preparation script...

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

✓ Server preparation completed

✅ Server is now ready for homelab deployment!

🔄 Switching to homelab user for deployment...
Server preparation completed. Now switching to homelab user for deployment.

Switching to user: homelab
Please run the deployment as the homelab user:
sudo -u homelab ./seamless_setup.sh

Or continue as current user (not recommended):
Continue as current user? [y/N]: N

# User runs: sudo -u homelab ./seamless_setup.sh

[STEP 2] Gathering comprehensive configuration...

Basic Configuration:
Enter your domain name (e.g., homelab.local): myhomelab.local
Enter username for homelab user (default: homelab): homelab
Enter server IP address: 192.168.1.100
Enter gateway IP (default: 192.168.1.1): 192.168.1.1
Enter admin email address (default: admin@myhomelab.local): admin@myhomelab.local
Enter timezone (default: America/New_York): America/New_York
Enter PUID (default: 1000): 1000
Enter PGID (default: 1000): 1000

Service Selection:
Select which services to deploy:
Deploy security services (Traefik, Authentik, Fail2ban)? [Y/n]: Y
Deploy media services (Plex, Sonarr, Radarr)? [Y/n]: Y
Deploy monitoring (Grafana, Prometheus)? [Y/n]: Y
Deploy utilities (Portainer, Homepage)? [Y/n]: Y
Deploy productivity services (Linkwarden, Paperless)? [Y/n]: Y
Deploy automation services (n8n, Node-RED)? [Y/n]: Y

Cloudflare Configuration (Optional but recommended for SSL):
Enable Cloudflare integration? [Y/n]: Y
Cloudflare Email: your-email@example.com
Cloudflare API Token: [hidden]

DNS Automation (Optional):
Automatically create all DNS records using Cloudflare API? [Y/n]: Y

🎉 DNS Automation Enabled!
The setup will automatically create all required DNS records:
• Root domain (@) → 192.168.1.100
• 40+ subdomains → 192.168.1.100
• Automatic validation after creation

Required Cloudflare API Permissions:
• Zone:Zone:Read
• Zone:DNS:Edit
• Zone:Zone Settings:Edit

[STEP 3.5] Automating DNS record creation...

🔧 Creating DNS records via Cloudflare API...
✓ DNS automation completed successfully

[STEP 3] Generating comprehensive secure vault variables...
✓ Comprehensive secure vault variables generated

🔐 CREDENTIALS BACKUP - YOUR HOMELAB KEYS
File Location: /home/homelab/credentials_backup.enc
File Size: 2.1K
Status: Encrypted with AES-256-CBC

⚠️  CRITICAL: This file contains ALL passwords and secrets for your homelab!

📋 IMMEDIATE BACKUP REQUIREMENTS:
1. Copy to secure location: External drive, cloud storage, or password manager
2. Store multiple copies: At least 2-3 secure locations
3. Test decryption: Verify you can decrypt the file
4. Document location: Note where you stored the backup

🔒 RECOMMENDED STORAGE OPTIONS:
• Encrypted external drive
• Password manager (1Password, Bitwarden, etc.)
• Cloud storage with encryption (Google Drive, Dropbox)
• Physical safe or secure location

🚨 SECURITY WARNINGS:
• Never commit this file to version control
• Never share this file via email or messaging
• Keep this file separate from your homelab server
• Consider this file as valuable as your house keys

✅ This file is your ONLY backup of homelab credentials!

[STEP 4] Creating comprehensive configuration files...
✓ Comprehensive configuration files created

[STEP 4.5] Updating Homepage configuration with generated API keys...
✓ Homepage configuration files updated with generated API keys

[STEP 5] Setting up SSH access...
✓ SSH access configured

[STEP 6] Installing Ansible collections...
✓ Ansible collections installed

[STEP 7] Validating setup...
✓ Setup validation completed

Configuration Summary:
Domain: myhomelab.local
Server: homelab@192.168.1.100
Admin Email: admin@myhomelab.local
Security: Enabled
Media: Enabled
Monitoring: Enabled
Utilities: Enabled
Productivity: Enabled
Automation: Enabled

 Security Features:
✓ Cryptographically secure password generation
✓ Encrypted vault file
✓ Secure credentials backup
✓ Complex password requirements
✓ API key prefixing for identification
✓ Comprehensive variable coverage
✓ Automatic configuration generation
✓ Integrated server preparation (NEW)

Proceed with deployment? [Y/n]: Y

[STEP 8] Deploying infrastructure...
Deploying Stage 1: Infrastructure...
Deploying Stage 2: Core Services...
Deploying Stage 3: Applications...
Deploying Stage 4: Validation...
✓ Infrastructure deployment completed

[STEP 9] Post-deployment configuration...
✓ Post-deployment configuration completed

================================================
🎉 Seamless deployment completed successfully!

🔐 CREDENTIALS BACKUP - YOUR HOMELAB KEYS
📁 File: /home/homelab/credentials_backup.enc
📊 Size: 2.1K
🔒 Status: Encrypted with AES-256-CBC

🌐 Access your homelab at: https://dash.myhomelab.local
📋 Check deployment_summary.txt for full details

🚨 CRITICAL: Backup credentials_backup.enc immediately!
This file contains ALL passwords and secrets for your homelab!
```

## 🔧 **Technical Details**

### **Integration Points**

#### **1. Detection Logic**
```bash
# Check if Ubuntu and Docker missing
if [[ -f /etc/os-release ]] && grep -q "Ubuntu" /etc/os-release; then
    if ! command -v docker &> /dev/null; then
        # Offer server preparation
    fi
fi
```

#### **2. User Switching**
```bash
# After server prep, switch to homelab user
if [[ -n "$run_server_prep" ]] && [[ $run_server_prep =~ ^[Yy]$ ]]; then
    HOMELAB_USER=${HOMELAB_USER:-homelab}
    # Switch to homelab user for deployment
fi
```

#### **3. Environment Reload**
```bash
# Reload environment after server prep
source ~/.bashrc 2>/dev/null || true
```

### **Error Handling**

#### **Server Preparation Failures**
- ✅ **Network Configuration** - Automatic rollback to DHCP
- ✅ **SSH Configuration** - Restore original SSH config
- ✅ **Docker Installation** - Graceful failure with instructions
- ✅ **User Creation** - Skip if user already exists

#### **Deployment Failures**
- ✅ **Configuration Validation** - Syntax checking before deployment
- ✅ **SSH Connectivity** - Test connection before proceeding
- ✅ **Ansible Validation** - Playbook syntax checking
- ✅ **Rollback Mechanisms** - Restore previous configurations

## 📊 **Benefits of Integration**

### **Time Savings**
- **Before**: 2-3 hours server prep + 1-2 hours deployment = 3-5 hours total
- **After**: 2-3 hours total (integrated flow)
- **Improvement**: 25-40% faster total setup

### **Error Reduction**
- **No manual script switching**
- **Consistent user context**
- **Automatic environment setup**
- **Integrated validation**

### **User Experience**
- **Single command deployment**
- **Automatic detection and preparation**
- **Clear progress tracking**
- **Comprehensive error handling**

## 🎯 **Next Steps**

After integrated deployment:
1. **Backup credentials** - Store credentials_backup.enc securely
2. **Test access** - Verify all services are accessible
3. **Configure bookmarks** - Set up Homepage dashboard
4. **Monitor health** - Check Grafana dashboards
5. **Set up alerts** - Configure notification systems

The integrated deployment creates a true one-command homelab setup from stock Ubuntu to fully deployed production-ready homelab! 