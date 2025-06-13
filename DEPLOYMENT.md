# Deployment Guide

This guide provides detailed steps for deploying and validating the homelab environment.

## Pre-deployment Checklist

### System Verification
1. Verify system requirements:
   ```bash
   # Check CPU cores and frequency
   nproc
   lscpu | grep "CPU MHz"
   
   # Check available memory
   free -h
   
   # Check disk space and type
   df -h
   lsblk -d -o name,rota
   
   # Check network speed and configuration
   speedtest-cli
   ip a
   ```

2. Verify software prerequisites:
   ```bash
   # Check Ansible version and configuration
   ansible --version
   ansible-config dump | grep -v "^#"
   
   # Check Python version and packages
   python3 --version
   pip list
   
   # Check Docker installation and configuration
   docker --version
   docker-compose --version
   docker info
   ```

3. Verify network connectivity:
   ```bash
   # Test SSH connection to all hosts
   ansible all -m ping
   
   # Verify DNS resolution
   dig +short your-domain.com
   
   # Check port availability
   nc -zv your-domain.com 80
   nc -zv your-domain.com 443
   ```

### Configuration Verification
1. Verify inventory configuration:
   ```bash
   # Validate inventory syntax
   ansible-inventory --list
   
   # Check host connectivity
   ansible all -m ping
   ```

2. Verify variable files:
   ```bash
   # Check variable syntax
   ansible-playbook main.yml --syntax-check
   
   # Validate vault files
   ansible-vault view group_vars/all/proxmox_vault.yml
   ```

## Deployment Steps

### 1. Initial Setup

1. Clone and run setup script:
   ```bash
   git clone https://github.com/yourusername/ansible_homelab.git
   cd ansible_homelab
   ./scripts/setup.sh
   ```

2. Review generated configuration:
   - `inventory/hosts.yml`: Verify host information
   - `group_vars/all/proxmox_vault.yml`: Check Proxmox settings
   - `group_vars/all/vars.yml`: Review service configuration
   - `group_vars/all/network.yml`: Verify network settings
   - `group_vars/all/security.yml`: Review security settings

3. Validate configuration:
   ```bash
   # Run syntax check
   ansible-playbook main.yml --syntax-check
   
   # Run in check mode
   ansible-playbook main.yml --check
   ```

### 2. Proxmox VM Deployment

1. Verify Proxmox access:
   ```bash
   # Test Proxmox connection
   ansible-playbook main.yml --tags setup --check
   
   # Verify API token
   curl -k -s https://proxmox:8006/api2/json/cluster/status \
     -H "Authorization: PVEAPIToken=root@pam!tokenid=tokensecret"
   ```

2. Deploy VM:
   ```bash
   # Deploy VM with default settings
   ansible-playbook main.yml --tags proxmox
   
   # Or deploy with custom settings
   ansible-playbook main.yml --tags proxmox \
     -e "vm_memory=4096 vm_cores=4 vm_disk=50"
   ```

3. Verify VM deployment:
   ```bash
   # Check VM status
   ansible-playbook main.yml --tags proxmox -e "vm_state=info"
   
   # Check resource usage
   ansible-playbook main.yml --tags proxmox -e "vm_state=resources"
   
   # Verify network connectivity
   ansible-playbook main.yml --tags proxmox -e "vm_state=network"
   ```

### 3. Foundation Deployment

1. Deploy system essentials:
   ```bash
   ansible-playbook main.yml --tags foundation
   ```

2. Validate foundation deployment:
   ```bash
   # Check system updates
   ansible all -m shell -a "apt list --upgradable"
   
   # Check Docker installation
   ansible all -m shell -a "docker info"
   
   # Check network configuration
   ansible all -m shell -a "ip a"
   
   # Verify system time
   ansible all -m shell -a "timedatectl status"
   ```

### 4. Core Services Deployment

1. Deploy core services:
   ```bash
   ansible-playbook main.yml --tags infrastructure
   ```

2. Validate core services:
   ```bash
   # Check Traefik
   curl -I https://traefik.your-domain.com
   curl -k https://traefik.your-domain.com/api/rawdata
   
   # Check Authentik
   curl -I https://auth.your-domain.com
   curl -k https://auth.your-domain.com/api/v3/core/applications/
   
   # Check monitoring infrastructure
   curl -I https://grafana.your-domain.com
   curl -k https://prometheus.your-domain.com/api/v1/status/config
   ```

### 5. Monitoring Stack Deployment

1. Deploy monitoring services:
   ```bash
   ansible-playbook main.yml --tags monitoring
   ```

2. Validate monitoring stack:
   ```bash
   # Check InfluxDB
   curl -I https://influxdb.your-domain.com
   curl -k https://influxdb.your-domain.com/health
   
   # Check Prometheus
   curl -I https://prometheus.your-domain.com
   curl -k https://prometheus.your-domain.com/api/v1/query?query=up
   
   # Check Grafana
   curl -I https://grafana.your-domain.com
   curl -k https://grafana.your-domain.com/api/health
   
   # Verify metrics collection
   curl -k https://prometheus.your-domain.com/api/v1/query?query=up
   curl -k https://prometheus.your-domain.com/api/v1/query?query=node_memory_MemTotal_bytes
   ```

### 6. Security Services Deployment

1. Deploy security services:
   ```bash
   ansible-playbook main.yml --tags security
   ```

2. Validate security services:
   ```bash
   # Check CrowdSec
   curl -I https://crowdsec.your-domain.com
   curl -k https://crowdsec.your-domain.com/v1/decisions
   
   # Check Vault
   curl -I https://vault.your-domain.com
   curl -k https://vault.your-domain.com/v1/sys/health
   
   # Verify WireGuard
   wg show
   wg show all
   
   # Check fail2ban
   fail2ban-client status
   fail2ban-client status sshd
   ```

### 7. Media Stack Deployment

1. Deploy media services:
   ```bash
   ansible-playbook main.yml --tags media
   ```

2. Validate media services:
   ```bash
   # Check Jellyfin
   curl -I https://jellyfin.your-domain.com
   curl -k https://jellyfin.your-domain.com/System/Info
   
   # Check Sonarr
   curl -I https://sonarr.your-domain.com
   curl -k https://sonarr.your-domain.com/api/v3/system/status
   
   # Check Radarr
   curl -I https://radarr.your-domain.com
   curl -k https://radarr.your-domain.com/api/v3/system/status
   ```

### 8. File Services Deployment

1. Deploy file services:
   ```bash
   ansible-playbook main.yml --tags storage
   ```

2. Validate file services:
   ```bash
   # Check Nextcloud
   curl -I https://nextcloud.your-domain.com
   curl -k https://nextcloud.your-domain.com/status.php
   
   # Check Samba
   smbclient -L //your-server-ip
   smbclient -L //your-server-ip -U your-username
   
   # Check Syncthing
   curl -I https://syncthing.your-domain.com
   curl -k https://syncthing.your-domain.com/rest/system/status
   ```

### 9. Automation Services Deployment

1. Deploy automation services:
   ```bash
   ansible-playbook main.yml --tags automation
   ```

2. Validate automation services:
   ```bash
   # Check Home Assistant
   curl -I https://homeassistant.your-domain.com
   curl -k https://homeassistant.your-domain.com/api/
   
   # Check Node-RED
   curl -I https://nodered.your-domain.com
   curl -k https://nodered.your-domain.com/flows
   
   # Check MQTT broker
   mosquitto_sub -h your-server-ip -t '#' -v
   mosquitto_pub -h your-server-ip -t 'test' -m 'test'
   ```

### 10. Utility Services Deployment

1. Deploy utility services:
   ```bash
   ansible-playbook main.yml --tags utilities
   ```

2. Validate utility services:
   ```bash
   # Check Portainer
   curl -I https://portainer.your-domain.com
   curl -k https://portainer.your-domain.com/api/status
   
   # Check Uptime Kuma
   curl -I https://uptime.your-domain.com
   curl -k https://uptime.your-domain.com/api/status-page
   
   # Check Guacamole
   curl -I https://guacamole.your-domain.com
   curl -k https://guacamole.your-domain.com/api/session/data/mysql/activeConnections
   ```

## Post-deployment Validation

### 1. Run Validation Script
```bash
./scripts/validate.sh
```

### 2. Check Service Health
```bash
# Check all services
ansible-playbook main.yml --tags validate

# Check specific service
ansible-playbook main.yml --tags "{{ service_name }}" -e "check_status=true"
```

### 3. Verify Monitoring
```bash
# Check Prometheus targets
curl -k https://prometheus.your-domain.com/api/v1/targets

# Check Grafana dashboards
curl -k https://grafana.your-domain.com/api/dashboards

# Check alert rules
curl -k https://prometheus.your-domain.com/api/v1/rules
```

### 4. Verify Security
```bash
# Check SSL certificates
curl -vI https://your-domain.com

# Check firewall rules
iptables -L -n -v

# Check fail2ban status
fail2ban-client status
```

### 5. Verify Backups
```bash
# Check backup status
ansible-playbook main.yml --tags backup -e "check_status=true"

# Verify backup integrity
ansible-playbook main.yml --tags backup -e "verify=true"
```

## Troubleshooting

If you encounter any issues during deployment, please refer to [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common problems and solutions.

## Rollback Procedures

If you need to rollback any changes, please refer to the [Rollback Procedures](#rollback-procedures) section in the README.md file. 