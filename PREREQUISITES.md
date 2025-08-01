# Watchtower Deployment Prerequisites

This document outlines all the information and configurations needed before running the Ansible Watchtower playbook. Please ensure you have all these items ready before proceeding with the deployment.

## Required Information

### 1. Proxmox VE Configuration
- Proxmox VE hostname or IP address
- Proxmox VE admin credentials (either password or API token)
- Storage location for VMs
- Network bridge name (default: vmbr0)
- VLAN ID (if using VLANs)

### 2. Network Configuration
- Domain name for your Watchtower
- Internal network subnet (e.g., 192.168.40.0/24)
- Gateway IP address
- DNS servers
- Static IP addresses for each service (if using static IPs)
- Port forwarding rules (if exposing services to the internet)

### 3. Cloudflare Configuration (if using Cloudflare)
- Cloudflare API token
- Zone ID
- Domain name
- Email address

### 4. Service-Specific Requirements

#### Authentication (Authentik)
- Admin email
- Admin password
- SMTP server details (if using email notifications)

#### Monitoring Stack
- Grafana admin credentials
- Prometheus retention period
- InfluxDB database name and credentials

#### Media Services
- Jellyfin admin credentials
- Sonarr/Radarr API keys
- Download client credentials

#### Storage Services
- Nextcloud admin credentials
- Samba share credentials
- Syncthing device ID

## Configuration Files to Update

### 1. Inventory Configuration
Edit `inventory/hosts.yml`:
```yaml
all:
  children:
    proxmox:
      hosts:
        proxmox:
          ansible_host: YOUR_PROXMOX_IP
          proxmox_host: YOUR_PROXMOX_IP
          proxmox_user: root@pam
```

### 2. Proxmox Vault
Create/update `group_vars/all/proxmox_vault.yml`:
```yaml
proxmox_password: YOUR_PROXMOX_PASSWORD
# OR
proxmox_token_id: YOUR_TOKEN_ID
proxmox_token_secret: YOUR_TOKEN_SECRET
```

### 3. Network Variables
Edit `group_vars/all/vars.yml`:
```yaml
network:
  domain: your-domain.com
  subnet: 192.168.40.0/24
  gateway: 192.168.40.1
  dns_servers:
    - 8.8.8.8
    - 8.8.4.4
```

### 4. Service Configuration
Edit `group_vars/all/vars.yml`:
```yaml
services:
  traefik:
    email: admin@your-domain.com
  authentik:
    admin_email: admin@your-domain.com
  grafana:
    admin_password: changeme  # Change this to a secure password
```

## Pre-deployment Checklist

1. [ ] Proxmox VE is installed and accessible
2. [ ] Network configuration is documented
3. [ ] DNS records are prepared (if using custom domain)
4. [ ] All required credentials are documented
5. [ ] Storage is available on Proxmox
6. [ ] Network ports are open (if exposing services)
7. [ ] SSL certificates are ready (if using custom certificates)
8. [ ] Backup strategy is defined
9. [ ] Resource limits are defined for each VM
10. [ ] All configuration files are updated with your values

## Running the Playbook

Once you have completed all the above requirements:

1. Verify your configuration:
   ```bash
   ansible-playbook main.yml --check
   ```

2. Run the playbook:
   ```bash
   ansible-playbook main.yml
   ```

## Troubleshooting

If you encounter issues during deployment:

1. Check the Ansible logs:
   ```bash
   tail -f ansible.log
   ```

2. Verify Proxmox connectivity:
   ```bash
   ansible-playbook main.yml --tags setup -vv
   ```

3. Check VM deployment:
   ```bash
   ansible-playbook main.yml --tags proxmox -vv
   ```

For more detailed troubleshooting, refer to the `TROUBLESHOOTING.md` file.

# Pre-Deployment Checklist

## Overview
This checklist ensures a successful turnkey deployment of the Ansible homelab automation project. Follow each section in order to properly configure your environment before running the playbooks.

## Prerequisites

### 1. System Requirements
- [ ] Ubuntu 20.04+ or Debian 11+ server
- [ ] Minimum 4 CPU cores (8+ recommended)
- [ ] Minimum 8GB RAM (16GB+ recommended)
- [ ] Minimum 500GB storage (1TB+ recommended)
- [ ] Static IP address configured
- [ ] Domain name with DNS access
- [ ] Root or sudo access to the server

### 2. Network Configuration
- [ ] Static IP address assigned
- [ ] DNS records configured for your domain
- [ ] Port forwarding configured (if behind NAT)
- [ ] Firewall rules prepared
- [ ] Network ranges identified for services

### 3. Software Prerequisites
- [ ] Python 3.8+ installed
- [ ] Ansible 2.12+ installed
- [ ] Git installed
- [ ] Docker and Docker Compose installed
- [ ] SSH key-based authentication configured

## Vault Configuration

### 4. Create Ansible Vault File
```bash
# Create vault file
ansible-vault create group_vars/all/vault.yml

# Or edit existing vault file
ansible-vault edit group_vars/all/vault.yml
```

### 5. Required Vault Variables

#### Database Passwords
```yaml
# PostgreSQL
vault_postgresql_password: "your_secure_postgresql_password"
vault_media_database_password: "your_secure_media_db_password"
vault_paperless_database_password: "your_secure_paperless_db_password"
vault_fing_database_password: "your_secure_fing_db_password"

# Redis
vault_redis_password: "your_secure_redis_password"
```

#### Service Authentication
```yaml
# Admin passwords
vault_paperless_admin_password: "your_secure_paperless_admin_password"
vault_paperless_secret_key: "your_secure_paperless_secret_key"
vault_fing_admin_password: "your_secure_fing_admin_password"

# API Keys
vault_paperless_admin_token: "your_secure_paperless_api_token"
vault_fing_api_key: "your_secure_fing_api_key"

# Media service API keys
vault_sabnzbd_api_key: "your_secure_sabnzbd_api_key"
vault_sonarr_api_key: "your_secure_sonarr_api_key"
vault_radarr_api_key: "your_secure_radarr_api_key"
vault_lidarr_api_key: "your_secure_lidarr_api_key"
vault_readarr_api_key: "your_secure_readarr_api_key"
vault_prowlarr_api_key: "your_secure_prowlarr_api_key"
vault_bazarr_api_key: "your_secure_bazarr_api_key"
```

#### Email Configuration
```yaml
# SMTP settings
vault_smtp_username: "your_smtp_username"
vault_smtp_password: "your_smtp_password"
```

#### Notification Services
```yaml
# Slack
vault_slack_webhook: "your_slack_webhook_url"

# Discord
vault_discord_webhook: "your_discord_webhook_url"
```

#### Watchtower
```yaml
# Container update service
vault_watchtower_token: "your_secure_watchtower_token"
```

## Environment Configuration

### 6. Domain and Network Settings
Edit `group_vars/all/common.yml`:
```yaml
# Domain configuration
domain: "yourdomain.com"
admin_email: "admin@yourdomain.com"

# Network configuration
network_range: "192.168.1.0/24"
gateway_ip: "192.168.1.1"
dns_servers:
  - "8.8.8.8"
  - "8.8.4.4"

# Timezone
timezone: "UTC"
```

### 7. User Configuration
```yaml
# System user
username: "your_username"
user_id: 1000
group_id: 1000

# Directory paths
docker_dir: "/home/{{ username }}/docker"
data_dir: "/home/{{ username }}/data"
config_dir: "/home/{{ username }}/config"
backup_dir: "/home/{{ username }}/backups"
logs_dir: "/home/{{ username }}/logs"
```

### 8. Service Configuration
```yaml
# Enable/disable services
security_enabled: true
databases_enabled: true
storage_enabled: true
logging_enabled: true
media_enabled: true
paperless_ngx_enabled: true
fing_enabled: true
utilities_enabled: true
certificate_management_enabled: true

# Monitoring
monitoring_enabled: true
grafana_enabled: true
prometheus_enabled: true
loki_enabled: true
alertmanager_enabled: true

# Security
crowdsec_enabled: true
fail2ban_enabled: true
authentik_enabled: true
```

### 9. Traefik Configuration
```yaml
# Reverse proxy
traefik_enabled: true
traefik_network: "homelab"
traefik_ssl_resolver: "cloudflare"  # or "letsencrypt"

# SSL certificates
ssl_enabled: true
ssl_email: "admin@yourdomain.com"
```

### 10. Backup Configuration
```yaml
# Backup settings
backup_enabled: true
backup_retention_days: 7
backup_compression: true
backup_notifications_enabled: true
```

## Staged Deployment Configuration

### 11. Deployment Stages
The playbook implements staged deployment in the following order:

#### Stage 1: Infrastructure
- [ ] Security hardening
- [ ] Docker setup
- [ ] Traefik reverse proxy
- [ ] Monitoring infrastructure

#### Stage 2: Core Services
- [ ] Database services
- [ ] Storage services
- [ ] Logging services

#### Stage 3: Applications
- [ ] Media stack
- [ ] Document management
- [ ] Network monitoring
- [ ] Utilities

#### Stage 4: Validation
- [ ] Health checks
- [ ] Service validation
- [ ] Performance testing

### 12. Inventory Configuration
Edit `inventory.yml`:
```yaml
all:
  children:
    homelab:
      hosts:
        your-server:
          ansible_host: your-server-ip
          ansible_user: your-username
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
          ansible_become: true
          ansible_become_method: sudo
```

## Pre-Deployment Validation

### 13. System Checks
```bash
# Check system resources
free -h
df -h
nproc

# Check network connectivity
ping -c 3 google.com
nslookup yourdomain.com

# Check Docker
docker --version
docker-compose --version

# Check Ansible
ansible --version
ansible-vault --version
```

### 14. Configuration Validation
```bash
# Validate inventory
ansible-inventory --list -i inventory.yml

# Validate playbook syntax
ansible-playbook --syntax-check site.yml

# Test connectivity
ansible all -m ping -i inventory.yml
```

### 15. Vault Validation
```bash
# Test vault access
ansible-vault view group_vars/all/vault.yml

# Validate vault variables are accessible
ansible all -m debug -a "msg='Vault test'" -i inventory.yml --ask-vault-pass
```

## Deployment Commands

### 16. Staged Deployment
```bash
# Stage 1: Infrastructure
ansible-playbook -i inventory.yml site.yml --tags "infrastructure" --ask-vault-pass

# Stage 2: Core Services
ansible-playbook -i inventory.yml site.yml --tags "core_services" --ask-vault-pass

# Stage 3: Applications
ansible-playbook -i inventory.yml site.yml --tags "applications" --ask-vault-pass

# Stage 4: Validation
ansible-playbook -i inventory.yml site.yml --tags "validation" --ask-vault-pass

# Full deployment
ansible-playbook -i inventory.yml site.yml --ask-vault-pass
```

### 17. Individual Role Deployment
```bash
# Deploy specific roles
ansible-playbook -i inventory.yml site.yml --tags "security" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "databases" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "media" --ask-vault-pass
```

## Post-Deployment Verification

### 18. Service Health Checks
- [ ] Traefik dashboard accessible
- [ ] Grafana dashboard accessible
- [ ] All services showing healthy status
- [ ] SSL certificates working
- [ ] Monitoring data flowing

### 19. Security Verification
- [ ] Fail2ban active
- [ ] CrowdSec monitoring
- [ ] SSL/TLS working
- [ ] Access controls in place

### 20. Backup Verification
- [ ] Backup scripts working
- [ ] Backup retention working
- [ ] Recovery procedures tested

## Troubleshooting

### 21. Common Issues
- [ ] Vault password not working
- [ ] Network connectivity issues
- [ ] Docker permission problems
- [ ] SSL certificate issues
- [ ] Service dependency problems

### 22. Log Locations
- [ ] Ansible logs: `~/.ansible.log`
- [ ] Service logs: `{{ logs_dir }}/`
- [ ] Docker logs: `docker logs <container_name>`
- [ ] System logs: `/var/log/`

## Support

### 23. Documentation
- [ ] README.md reviewed
- [ ] Role documentation reviewed
- [ ] Troubleshooting guide reviewed
- [ ] Backup procedures documented

### 24. Contact Information
- [ ] Support channels identified
- [ ] Emergency procedures documented
- [ ] Escalation process defined

---

**Note**: This checklist must be completed before running any deployment playbooks. Skipping any step may result in deployment failures or security issues. 