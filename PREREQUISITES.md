# Pre-deployment Requirements and Configuration

This document outlines all the information and configurations needed before running the Ansible homelab playbook. Please ensure you have all these items ready before proceeding with the deployment.

## Required Information

### 1. Proxmox VE Configuration
- Proxmox VE hostname or IP address
- Proxmox VE admin credentials (either password or API token)
- Storage location for VMs
- Network bridge name (default: vmbr0)
- VLAN ID (if using VLANs)

### 2. Network Configuration
- Domain name for your homelab
- Internal network subnet (e.g., 192.168.1.0/24)
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
  subnet: 192.168.1.0/24
  gateway: 192.168.1.1
  dns_servers:
    - 8.8.8.8
    - 8.8.4.4
```

### 4. Service Configuration
Edit `group_vars/all/vars.yml`:
```yaml
services:
  traefik:
    email: your-email@domain.com
  authentik:
    admin_email: admin@domain.com
  grafana:
    admin_password: your-secure-password
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