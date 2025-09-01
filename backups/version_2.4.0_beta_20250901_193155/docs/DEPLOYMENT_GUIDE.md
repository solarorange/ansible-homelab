# Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the Ansible homelab automation project using the staged deployment approach. The deployment is designed to be turnkey and production-ready.

## Staged Deployment Architecture

### Stage 1: Infrastructure
**Purpose**: Establish the foundational infrastructure and security framework
**Roles**: Security
**Dependencies**: None
**Duration**: ~10-15 minutes

**What happens**:
- System hardening and security configuration
- Docker installation and configuration
- Traefik reverse proxy setup
- SSL/TLS certificate management
- Firewall and access control configuration

### Stage 2: Core Services
**Purpose**: Deploy essential services that other applications depend on
**Roles**: Databases, Storage, Logging, Certificate Management
**Dependencies**: Stage 1 (Infrastructure)
**Duration**: ~20-30 minutes

**What happens**:
- PostgreSQL and Redis database deployment
- Storage services (Samba, NFS) configuration
- Logging infrastructure (Loki, Promtail)
- Certificate monitoring and automation
- Monitoring stack (Prometheus, Grafana, AlertManager)

### Stage 3: Applications
**Purpose**: Deploy user-facing applications and services
**Roles**: Media, Paperless-ngx, Fing, Utilities, Automation
**Dependencies**: Stage 2 (Core Services)
**Duration**: ~30-45 minutes

**What happens**:
- Media stack deployment (Sonarr, Radarr, Jellyfin, etc.)
- Document management (Paperless-ngx)
- Network monitoring (Fing)
- Utility services (Portainer, Tautulli, etc.)
- Automation and scheduling services

### Stage 4: Validation
**Purpose**: Verify deployment success and optimize performance
**Tasks**: Health checks, monitoring, backup orchestration, security hardening
**Dependencies**: All previous stages
**Duration**: ~10-15 minutes

**What happens**:
- Service health validation
- Performance monitoring setup
- Backup orchestration configuration
- Security hardening application
- Documentation generation

## Pre-Deployment Checklist

Before starting deployment, ensure you have completed the [Pre-Deployment Checklist](PREREQUISITES.md).

## Deployment Commands

### Full Deployment
```bash
# Deploy everything in one command
ansible-playbook -i inventory.yml site.yml --ask-vault-pass
```

### Staged Deployment
```bash
# Stage 1: Infrastructure
ansible-playbook -i inventory.yml site.yml --tags "stage1" --ask-vault-pass

# Stage 2: Core Services
ansible-playbook -i inventory.yml site.yml --tags "stage2" --ask-vault-pass

# Stage 3: Applications
ansible-playbook -i inventory.yml site.yml --tags "stage3" --ask-vault-pass

# Stage 4: Validation
ansible-playbook -i inventory.yml site.yml --tags "stage4" --ask-vault-pass
```

### Individual Role Deployment
```bash
# Deploy specific roles
ansible-playbook -i inventory.yml site.yml --tags "security" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "databases" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "media" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "paperless" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "fing" --ask-vault-pass
ansible-playbook -i inventory.yml site.yml --tags "utilities" --ask-vault-pass
```

### Validation and Testing
```bash
# Validate configuration
ansible-playbook -i inventory.yml site.yml --tags "validation" --ask-vault-pass

# Test connectivity
ansible all -m ping -i inventory.yml

# Check syntax
ansible-playbook --syntax-check site.yml
```

## Deployment Process

### Step 1: Environment Preparation
1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd ansible_homelab
   ```

2. **Configure inventory**:
   Edit `inventory.yml` with your server details

3. **Set up vault**:
   ```bash
   ansible-vault create group_vars/all/vault.yml
   # Add all required vault variables
   ```

4. **Configure environment variables**:
   Edit `group_vars/all/common.yml` with your domain and network settings

### Step 2: Infrastructure Deployment
```bash
ansible-playbook -i inventory.yml site.yml --tags "stage1" --ask-vault-pass
```

**Expected output**:
- Security hardening completed
- Docker installed and configured
- Traefik reverse proxy running
- SSL certificates obtained

**Verification**:
- Check Traefik dashboard: `https://traefik.yourdomain.com`
- Verify Docker is running: `docker ps`
- Check SSL certificates are valid

### Step 3: Core Services Deployment
```bash
ansible-playbook -i inventory.yml site.yml --tags "stage2" --ask-vault-pass
```

**Expected output**:
- PostgreSQL and Redis databases running
- Storage services configured
- Logging infrastructure operational
- Monitoring stack deployed

**Verification**:
- Check Grafana dashboard: `https://grafana.yourdomain.com`
- Verify databases are accessible
- Check logs are being collected

### Step 4: Applications Deployment
```bash
ansible-playbook -i inventory.yml site.yml --tags "stage3" --ask-vault-pass
```

**Expected output**:
- Media stack services running
- Document management operational
- Network monitoring active
- Utility services deployed

**Verification**:
- Check media services: `https://sonarr.yourdomain.com`
- Verify document management: `https://docs.yourdomain.com`
- Test network monitoring: `https://fing.yourdomain.com`

### Step 5: Validation and Optimization
```bash
ansible-playbook -i inventory.yml site.yml --tags "stage4" --ask-vault-pass
```

**Expected output**:
- All services validated
- Monitoring configured
- Backups scheduled
- Security hardened
- Documentation generated

**Verification**:
- Check health dashboard
- Verify backup procedures
- Review security configurations
- Test monitoring alerts

## Post-Deployment Verification

### Service Health Checks
```bash
# Check all containers
docker ps

# Check service logs
docker logs <container_name>

# Verify network connectivity
curl -I https://traefik.yourdomain.com
```

### Monitoring Verification
1. **Grafana Dashboard**: `https://grafana.yourdomain.com`
   - Default credentials: admin/admin
   - Check for monitoring data
   - Verify dashboards are populated

2. **Prometheus**: `https://prometheus.yourdomain.com`
   - Check targets are up
   - Verify metrics are being collected

3. **AlertManager**: `https://alertmanager.yourdomain.com`
   - Check alert rules
   - Verify notification channels

### Security Verification
```bash
# Check Fail2ban status
sudo fail2ban-client status

# Check CrowdSec status
sudo crowdsec status

# Verify SSL certificates
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com
```

### Backup Verification
```bash
# Check backup scripts
ls -la /home/username/backups/

# Test backup procedures
sudo /home/username/config/backup-test.sh

# Verify backup retention
find /home/username/backups/ -name "*.tar.gz" -mtime +7
```

## Troubleshooting

### Common Issues

#### Vault Password Issues
```bash
# Reset vault password
ansible-vault rekey group_vars/all/vault.yml

# Test vault access
ansible-vault view group_vars/all/vault.yml
```

#### Network Connectivity Issues
```bash
# Check DNS resolution
nslookup yourdomain.com

# Check port forwarding
netstat -tlnp | grep :80
netstat -tlnp | grep :443

# Test SSL certificates
openssl s_client -connect yourdomain.com:443
```

#### Docker Issues
```bash
# Check Docker status
sudo systemctl status docker

# Check Docker logs
sudo journalctl -u docker

# Restart Docker
sudo systemctl restart docker
```

#### Service Dependencies
```bash
# Check service dependencies
docker-compose ps

# Restart specific services
docker-compose restart <service_name>

# Check service logs
docker-compose logs <service_name>
```

### Log Locations
- **Ansible logs**: `~/.ansible.log`
- **Service logs**: `/home/username/logs/`
- **Docker logs**: `docker logs <container_name>`
- **System logs**: `/var/log/`
- **Application logs**: `/home/username/docker/*/logs/`

### Recovery Procedures

#### Rollback to Previous Stage
```bash
# Rollback to specific stage
ansible-playbook -i inventory.yml rollback.yml --tags "stage2" --ask-vault-pass
```

#### Service Recovery
```bash
# Restart all services
docker-compose -f /home/username/docker/docker-compose.yml restart

# Restore from backup
sudo /home/username/config/restore.sh
```

## Performance Optimization

### Resource Monitoring
```bash
# Check system resources
htop
df -h
free -h

# Monitor Docker resources
docker stats
```

### Scaling Considerations
- **CPU**: Monitor usage and scale containers as needed
- **Memory**: Adjust memory limits for high-usage services
- **Storage**: Monitor disk usage and implement cleanup procedures
- **Network**: Optimize bandwidth usage for media services

## Maintenance

### Regular Maintenance Tasks
```bash
# Update containers
docker-compose pull
docker-compose up -d

# Clean up old images
docker image prune -f

# Rotate logs
sudo logrotate -f /etc/logrotate.d/homelab

# Check backups
sudo /home/username/config/backup-verify.sh
```

### Security Updates
```bash
# Update system packages
sudo apt update && sudo apt upgrade

# Update Docker
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io

# Update Ansible
pip install --upgrade ansible
```

## Support

### Documentation
- [Pre-Deployment Checklist](PREREQUISITES.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [Role Documentation](roles/)
- [Advanced Best Practices](docs/ADVANCED_BEST_PRACTICES.md)

### Getting Help
1. Check the troubleshooting guide
2. Review service logs
3. Verify configuration files
4. Test individual components
5. Check system resources

### Emergency Procedures
1. **Service Down**: Restart using `docker-compose restart`
2. **Data Loss**: Restore from backup using restore script
3. **Security Breach**: Review logs and update security configurations
4. **Performance Issues**: Scale resources or optimize configurations

---

**Note**: This deployment guide assumes you have completed the pre-deployment checklist. Always test in a staging environment before deploying to production. 