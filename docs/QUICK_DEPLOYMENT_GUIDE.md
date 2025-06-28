# Quick Deployment Guide

## Overview

This guide provides step-by-step instructions for quickly deploying the Ansible homelab using the new role-based architecture.

## Prerequisites

### System Requirements
- Ubuntu 20.04+ or Debian 11+
- 4+ CPU cores
- 8GB+ RAM
- 100GB+ storage
- Static IP address
- Domain name with DNS control

### Required Software
```bash
# Install Ansible
sudo apt update
sudo apt install -y ansible python3-pip

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Git
sudo apt install -y git
```

## Quick Start

### 1. Clone and Setup
```bash
# Clone repository
git clone https://github.com/solarorange/ansible_homelab.git
cd ansible_homelab

# Run setup script
./scripts/setup.sh
```

### 2. Configure Environment
```bash
# Edit master configuration
nano group_vars/all/roles.yml

# Edit system variables
nano group_vars/all/vars.yml

# Update inventory
nano inventory.yml
```

### 3. Deploy Infrastructure
```bash
# Deploy all services
ansible-playbook site.yml

# Or deploy step by step
ansible-playbook site.yml --tags infrastructure
ansible-playbook site.yml --tags monitoring
ansible-playbook site.yml --tags services
```

### 4. Validate Deployment
```bash
# Run validation
ansible-playbook validation.yml

# Check service status
docker ps
```

## Configuration Examples

### Basic Configuration (`group_vars/all/vars.yml`)
```yaml
# System configuration
username: "homelab"
domain: "your-domain.com"
timezone: "UTC"

# Network configuration
ip_address: "192.168.1.100"
gateway: "192.168.1.1"
dns_servers:
  - "8.8.8.8"
  - "8.8.4.4"

# Directory structure
docker_dir: "/home/{{ username }}/docker"
data_dir: "/home/{{ username }}/data"
config_dir: "/home/{{ username }}/config"
backup_dir: "/home/{{ username }}/backups"
```

### Role Configuration (`group_vars/all/roles.yml`)
```yaml
# Enable core roles
security_enabled: true
databases_enabled: true
storage_enabled: true
media_enabled: true
automation_enabled: true
utilities_enabled: true

# Security configuration
security_authentication_enabled: true
security_proxy_enabled: true
security_dns_enabled: true

# Media configuration
media_arr_services_enabled: true
media_downloaders_enabled: true
media_players_enabled: true

# Database configuration
databases_cache_enabled: true
databases_relational_enabled: true
```

### Inventory Configuration (`inventory.yml`)
```yaml
all:
  children:
    homelab:
      hosts:
        homelab-server:
          ansible_host: 192.168.1.100
          ansible_user: homelab
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

## Deployment Options

### Full Deployment
```bash
# Deploy everything
ansible-playbook site.yml
```

### Selective Deployment
```bash
# Deploy infrastructure only
ansible-playbook site.yml --tags infrastructure

# Deploy specific roles
ansible-playbook site.yml --tags security,databases

# Deploy services only
ansible-playbook site.yml --tags services

# Skip specific roles
ansible-playbook site.yml --skip-tags paperless,fing
```

### Staged Deployment
```bash
# Phase 1: Infrastructure
ansible-playbook site.yml --tags infrastructure

# Phase 2: Monitoring
ansible-playbook site.yml --tags monitoring

# Phase 3: Services
ansible-playbook site.yml --tags services

# Phase 4: Validation
ansible-playbook validation.yml
```

## Service Access

### Default URLs
After deployment, services will be available at:

- **Traefik Dashboard**: https://traefik.your-domain.com
- **Authentik**: https://auth.your-domain.com
- **Homepage**: https://dash.your-domain.com
- **Grafana**: https://grafana.your-domain.com
- **Portainer**: https://portainer.your-domain.com
- **Plex**: https://plex.your-domain.com
- **Sonarr**: https://sonarr.your-domain.com
- **Radarr**: https://radarr.your-domain.com

### Default Credentials
- **Authentik Admin**: admin@your-domain.com / (set in vars.yml)
- **Grafana Admin**: admin / (set in vars.yml)
- **Portainer**: (create during first login)

## Validation and Testing

### Pre-Deployment Checks
```bash
# Syntax check
ansible-playbook site.yml --syntax-check

# Dry run
ansible-playbook site.yml --check --diff

# Validate specific roles
ansible-playbook site.yml --tags security --check
```

### Post-Deployment Validation
```bash
# Full validation
ansible-playbook validation.yml

# Role-specific validation
ansible-playbook validation.yml --tags security,databases

# Generate health report
ansible-playbook validation.yml --tags report
```

### Manual Validation
```bash
# Check Docker containers
docker ps

# Check service logs
docker logs traefik
docker logs authentik

# Check system resources
htop
df -h
```

## Troubleshooting

### Common Issues

#### 1. SSH Connection Issues
```bash
# Test SSH connectivity
ansible all -m ping

# Check SSH configuration
ssh -i ~/.ssh/id_rsa homelab@192.168.1.100
```

#### 2. Docker Issues
```bash
# Check Docker status
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker

# Check Docker permissions
sudo usermod -aG docker $USER
```

#### 3. Service Failures
```bash
# Check service status
docker ps -a

# View service logs
docker logs service_name

# Restart service
docker restart service_name
```

#### 4. Configuration Errors
```bash
# Validate configuration
ansible-playbook site.yml --syntax-check

# Check variable syntax
ansible-inventory --list

# Debug specific task
ansible-playbook site.yml --tags security -vvv
```

### Debug Commands
```bash
# Verbose output
ansible-playbook site.yml -vvv

# Check specific role
ansible-playbook site.yml --tags security --check --diff

# Validate inventory
ansible-inventory --list

# Test connectivity
ansible all -m ping
```

## Rollback Procedures

### Role-Level Rollback
```bash
# Rollback specific role
ansible-playbook rollback.yml --tags security -e "rollback_confirm=true"

# Rollback multiple roles
ansible-playbook rollback.yml --tags security,databases -e "rollback_confirm=true"
```

### Full System Rollback
```bash
# Rollback entire system
ansible-playbook rollback.yml -e "rollback_confirm=true"
```

### Emergency Rollback
```bash
# Stop all services
docker stop $(docker ps -q)

# Start services manually
docker start traefik
docker start authentik
# ... start other services as needed
```

## Maintenance

### Regular Tasks
```bash
# Update system
sudo apt update && sudo apt upgrade

# Update Docker images
docker system prune -a

# Backup configuration
tar -czf config_backup_$(date +%Y%m%d).tar.gz group_vars/ roles/

# Run validation
ansible-playbook validation.yml
```

### Monitoring
```bash
# Check system resources
htop
df -h
free -h

# Check service status
docker ps

# Check logs
docker logs service_name

# Monitor network
netstat -tulpn
```

## Next Steps

### 1. Customize Configuration
- Review and update `group_vars/all/roles.yml`
- Configure service-specific settings
- Set up backup schedules
- Configure monitoring alerts

### 2. Add Custom Services
- Create new roles in `roles/` directory
- Add role configuration to `group_vars/all/roles.yml`
- Update dependencies in `site.yml`
- Add validation tasks

### 3. Set Up Monitoring
- Configure Grafana dashboards
- Set up alerting rules
- Configure log aggregation
- Set up backup monitoring

### 4. Security Hardening
- Review firewall rules
- Configure SSL certificates
- Set up intrusion detection
- Implement access controls

## Support

### Documentation
- [Role Migration Summary](ROLE_MIGRATION_SUMMARY.md)
- [Migration Best Practices](MIGRATION_BEST_PRACTICES.md)
- [Troubleshooting Guide](../TROUBLESHOOTING.md)

### Getting Help
- Check the troubleshooting section
- Review service logs
- Run validation playbook
- Check GitHub issues
- Use GitHub discussions

## Conclusion

This quick deployment guide provides the essential steps to get your Ansible homelab up and running with the new role-based architecture. The modular design makes it easy to customize and extend the infrastructure according to your needs.

Remember to:
1. **Test thoroughly** before production deployment
2. **Backup regularly** to prevent data loss
3. **Monitor closely** to catch issues early
4. **Document changes** for future reference
5. **Update regularly** to maintain security and stability 