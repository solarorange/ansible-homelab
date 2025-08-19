# 🚀 PRODUCTION DEPLOYMENT GUIDE
## Bulletproof Homelab Setup - Addresses All Known Issues

This guide provides a **production-ready** deployment process that fixes all the issues we've encountered during testing.

---

## 📋 **PREREQUISITES**

### **1. Server Requirements**
- ✅ Ubuntu 20.04+ server with internet access
- ✅ User with sudo privileges (default: `ubuntu`)
- ✅ Static IP address
- ✅ Domain name (for SSL)

### **2. Local Requirements**
- ✅ macOS/Linux with SSH client
- ✅ SSH key pair (`~/.ssh/id_rsa`)
- ✅ Cloudflare account with API token

---

## 🔧 **STEP 1: Prepare Your Environment**

### **1.1 Create .env File**
```bash
# Copy the template
cp env.template .env

# Edit with your values
nano .env
```

**Required .env contents:**
```bash
# Server Configuration
HOMELAB_IP_ADDRESS=192.168.1.19
TARGET_SSH_USER=ubuntu
TARGET_SSH_PASSWORD=your_ubuntu_password

# Domain Configuration  
HOMELAB_DOMAIN=yourdomain.com

# Cloudflare Configuration
CLOUDFLARE_EMAIL=your_email@domain.com
CLOUDFLARE_API_TOKEN=your_cloudflare_api_token
CLOUDFLARE_ENABLED=Y
DNS_AUTOMATION=Y

# Service Selection
ALL_SERVICES_ENABLED=Y
```

### **1.2 Generate SSH Key (if needed)**
```bash
# Generate SSH key if you don't have one
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "homelab-deployment"
```

---

## 🚀 **STEP 2: Production Deployment**

### **2.1 Run Production Deployment Script**
```bash
# Make script executable
chmod +x scripts/production_deploy.sh

# Run production deployment
./scripts/production_deploy.sh
```

**What this script does:**
1. ✅ Validates environment variables
2. ✅ Tests SSH connectivity
3. ✅ Installs SSH key automatically
4. ✅ Creates clean inventory file
5. ✅ Configures Ansible properly
6. ✅ Creates vault password file
7. ✅ Tests Ansible connectivity
8. ✅ Runs seamless setup

### **2.2 Alternative: Manual Step-by-Step**
If you prefer manual control:

```bash
# Step 1: Load environment
set -a && source .env && set +a

# Step 2: Test SSH
ssh -o ConnectTimeout=10 ubuntu@192.168.1.19 "echo 'SSH working'"

# Step 3: Install SSH key (if needed)
sshpass -p "$TARGET_SSH_PASSWORD" ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@192.168.1.19

# Step 4: Create inventory
cat > inventory.yml << EOF
---
all:
  hosts:
    homelab-server:
      ansible_host: $HOMELAB_IP_ADDRESS
      ansible_user: $TARGET_SSH_USER
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
      ansible_python_interpreter: /usr/bin/python3
      ansible_ssh_common_args: "-o BatchMode=yes -o PasswordAuthentication=no"
EOF

# Step 5: Create ansible.cfg
cat > ansible.cfg << EOF
[defaults]
inventory = inventory.yml
host_key_checking = False
timeout = 30

[privilege_escalation]
become = True
become_method = sudo
become_ask_pass = False
become_user = root
EOF

# Step 6: Test Ansible
ansible all -m ping

# Step 7: Run deployment
./scripts/seamless_setup.sh --non-interactive
```

---

## 🔍 **TROUBLESHOOTING**

### **Issue 1: SSH Connection Failed**
```bash
# Test basic connectivity
ping 192.168.1.19

# Test SSH with verbose output
ssh -v ubuntu@192.168.1.19

# Check if user exists on server
ssh ubuntu@192.168.1.19 "whoami"
```

**Solutions:**
- ✅ Verify IP address is correct
- ✅ Ensure user exists on server
- ✅ Check firewall settings
- ✅ Verify SSH service is running

### **Issue 2: SSH Key Installation Failed**
```bash
# Manual key installation
sshpass -p "your_password" ssh ubuntu@192.168.1.19 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
sshpass -p "your_password" scp ~/.ssh/id_rsa.pub ubuntu@192.168.1.19:/tmp/
sshpass -p "your_password" ssh ubuntu@192.168.1.19 'cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

### **Issue 3: Ansible Connectivity Failed**
```bash
# Test with verbose output
ansible all -m ping -vvv

# Check inventory syntax
ansible-inventory --list

# Test specific host
ansible homelab-server -m ping
```

**Solutions:**
- ✅ Verify inventory.yml syntax
- ✅ Check ansible.cfg configuration
- ✅ Ensure SSH key is working
- ✅ Verify Python interpreter path

### **Issue 4: Vault Password Issues**
```bash
# Create vault password file
echo "your-secure-password" > .vault_password
chmod 600 .vault_password
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
```

---

## ✅ **VERIFICATION**

### **Post-Deployment Checks**
```bash
# 1. Check service status
ansible all -m shell -a "docker ps"

# 2. Check web interfaces
curl -k https://dash.yourdomain.com

# 3. Check logs
ansible all -m shell -a "docker logs traefik"

# 4. Check SSL certificates
ansible all -m shell -a "ls -la /etc/letsencrypt/live/"
```

### **Expected Results**
- ✅ All Docker containers running
- ✅ SSL certificates generated
- ✅ DNS records created
- ✅ Services accessible via HTTPS
- ✅ Authentication working

---

## 🎯 **QUICK START COMMANDS**

### **One-Command Deployment**
```bash
# 1. Setup environment
cp env.template .env && nano .env

# 2. Run production deployment
./scripts/production_deploy.sh
```

### **Verification Commands**
```bash
# Check deployment status
ansible all -m ping
ansible all -m shell -a "docker ps --format 'table {{.Names}}\t{{.Status}}'"

# Access services
open https://dash.yourdomain.com
open https://auth.yourdomain.com
```

---

## 🔐 **SECURITY NOTES**

- ✅ `.env` file is in `.gitignore` - never commit it
- ✅ Vault password file is automatically created and secured
- ✅ SSH keys are generated with proper permissions
- ✅ All passwords are cryptographically secure
- ✅ SSL certificates are automatically managed

---

## 📞 **SUPPORT**

If you encounter issues:

1. **Check logs**: `tail -f seamless_deployment.log`
2. **Verify environment**: `echo $HOMELAB_IP_ADDRESS`
3. **Test connectivity**: `ssh ubuntu@192.168.1.19 "echo test"`
4. **Check Ansible**: `ansible all -m ping -vvv`

**Common Issues:**
- DNS propagation delays (wait 5-10 minutes)
- Firewall blocking ports (check UFW/iptables)
- Insufficient disk space (check with `df -h`)
- Memory constraints (check with `free -h`)
