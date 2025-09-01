# Production Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the Ansible Homelab in a production environment with enterprise-grade security, monitoring, and reliability.

## Prerequisites

### System Requirements

- **Minimum Hardware:**
  - CPU: 4 cores (2.0 GHz or higher)
  - RAM: 8GB (16GB recommended)
  - Storage: 100GB SSD (500GB+ recommended)
  - Network: Gigabit Ethernet

- **Operating System:**
  - Ubuntu 20.04 LTS or 22.04 LTS
  - Debian 11 or 12
  - CentOS 8+ or Rocky Linux 8+

- **Software Requirements:**
  - Docker 20.10+
  - Python 3.8+
  - Ansible 2.9+

### Network Requirements

- Static IP address
- Port 80 and 443 open (for web services)
- Port 22 open (for SSH access)
- DNS control for your domain
- Cloudflare account (recommended)

## Pre-Deployment Setup

### 1. Environment Configuration

```bash
# Clone the repository
git clone <repository-url>
cd ansible_homelab

# Run environment setup script
./scripts/setup_environment.sh

# Edit environment variables
nano .env
```

**Required Environment Variables:**

```bash
# Domain Configuration
HOMELAB_DOMAIN=your-domain.com
HOMELAB_TIMEZONE=America/New_York

# User Configuration
HOMELAB_USERNAME=homelab
HOMELAB_PUID=1000
HOMELAB_PGID=1000
HOMELAB_IP_ADDRESS=192.168.40.100

# Cloudflare Configuration (Required for SSL)
CLOUDFLARE_EMAIL=your-email@domain.com
CLOUDFLARE_API_KEY=your-cloudflare-api-key

# Email Configuration
ADMIN_EMAIL=admin@your-domain.com
MONITORING_EMAIL=monitoring@your-domain.com

# SMTP Configuration (Optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Ansible Environment
ANSIBLE_ENVIRONMENT=production
```

### 2. DNS Configuration

Configure DNS records in Cloudflare or your DNS provider:

```
Type    Name                    Value
A       @                       YOUR_SERVER_IP
A       traefik                 YOUR_SERVER_IP
A       auth                    YOUR_SERVER_IP
A       dns                     YOUR_SERVER_IP
A       grafana                 YOUR_SERVER_IP
A       portainer               YOUR_SERVER_IP
A       plex                    YOUR_SERVER_IP
A       sonarr                  YOUR_SERVER_IP
A       radarr                  YOUR_SERVER_IP
A       dash                    YOUR_SERVER_IP
```

### 3. SSH Key Setup

```bash
# Generate SSH key (if not already done)
ssh-keygen -t ed25519 -f ~/.ssh/homelab_key -N "" -C "homelab@your-domain.com"

# Copy public key to target server
ssh-copy-id -i ~/.ssh/homelab_key.pub homelab@YOUR_SERVER_IP

# Test SSH connection
ssh -i ~/.ssh/homelab_key homelab@YOUR_SERVER_IP
```

### 4. Target Server Preparation

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Python and pip
sudo apt install -y python3 python3-pip python3-venv

# Install required packages
sudo apt install -y ufw fail2ban htop iotop nethogs
```

## Deployment Process

### Phase 1: Validation

```bash
# Test connectivity
ansible all -m ping

# Run pre-flight validation
ansible-playbook site.yml --tags validation

# Check system requirements
ansible-playbook tests/integration/test_deployment.yml --tags preflight
```

### Phase 2: Infrastructure Deployment

```bash
# Deploy security infrastructure
ansible-playbook site.yml --tags stage1

# Verify security services
ansible-playbook tests/integration/test_deployment.yml --tags security
```

### Phase 3: Core Services

```bash
# Deploy databases and storage
ansible-playbook site.yml --tags stage2

# Verify core services
ansible-playbook tests/integration/test_deployment.yml --tags databases,monitoring
```

### Phase 4: Applications

```bash
# Deploy media and utility services
ansible-playbook site.yml --tags stage3

# Verify all services
ansible-playbook tests/integration/test_deployment.yml --tags media,utilities
```

### Phase 5: Final Validation

```bash
# Run comprehensive tests
ansible-playbook tests/integration/test_deployment.yml

# Generate deployment report
ansible-playbook site.yml --tags stage4
```

## Post-Deployment Configuration

### 1. SSL Certificate Verification

```bash
# Check certificate status
openssl s_client -connect your-domain.com:443 -servername your-domain.com

# Verify certificate chain
openssl s_client -connect your-domain.com:443 -servername your-domain.com -showcerts
```

### 2. Security Hardening

```bash
# Review firewall rules
sudo ufw status verbose

# Check fail2ban status
sudo fail2ban-client status

# Verify SSH configuration
sudo sshd -T | grep -E "permitrootlogin|passwordauthentication"
```

### 3. Monitoring Setup

```bash
# Access monitoring dashboards
# Grafana: https://grafana.your-domain.com
# Prometheus: https://prometheus.your-domain.com
# AlertManager: https://alerts.your-domain.com

# Configure alerting channels
# Edit: group_vars/all/vault.yml
# Add: Slack, Discord, Telegram, or email webhooks
```

### 4. Backup Configuration

```bash
# Test backup functionality
sudo /opt/backups/backup.sh --test

# Schedule automated backups
sudo crontab -e
# Add: 0 2 * * * /opt/backups/backup.sh

# Verify backup retention
ls -la /opt/backups/
```

## Security Best Practices

### 1. Access Control

- Use SSH keys only (disable password authentication)
- Restrict SSH access to specific IP addresses
- Use VPN for remote access
- Implement two-factor authentication where possible

### 2. Network Security

- Configure firewall rules properly
- Use VLANs for network segmentation
- Monitor network traffic
- Implement intrusion detection

### 3. Application Security

- Keep all services updated
- Use strong passwords and API keys
- Implement rate limiting
- Monitor application logs

### 4. Data Protection

- Encrypt sensitive data at rest
- Use secure communication protocols
- Implement backup encryption
- Regular security audits

## Monitoring and Alerting

### 1. Service Monitoring

```bash
# Check service status
docker ps

# View service logs
docker logs <container-name>

# Monitor resource usage
docker stats
```

### 2. System Monitoring

```bash
# Check system resources
htop
iotop
nethogs

# Monitor disk usage
df -h
du -sh /opt/docker/*

# Check network connectivity
ping -c 4 8.8.8.8
```

### 3. Alert Configuration

Configure alerts for:
- High CPU/Memory usage (>80%)
- High disk usage (>85%)
- Service failures
- Security events
- Backup failures

## Troubleshooting

### Common Issues

1. **SSL Certificate Issues**
   ```bash
   # Check certificate status
   docker logs traefik
   
   # Verify DNS configuration
   nslookup your-domain.com
   
   # Test certificate renewal
   docker exec traefik traefik version
   ```

2. **Service Startup Failures**
   ```bash
   # Check service logs
   docker logs <service-name>
   
   # Verify dependencies
   docker-compose ps
   
   # Check resource constraints
   docker stats
   ```

3. **Network Connectivity Issues**
   ```bash
   # Test internal connectivity
   docker exec <container> ping <target>
   
   # Check firewall rules
   sudo ufw status
   
   # Verify DNS resolution
   docker exec <container> nslookup google.com
   ```

### Recovery Procedures

1. **Service Recovery**
   ```bash
   # Restart failed service
   docker-compose restart <service>
   
   # Check service health
   docker-compose ps
   ```

2. **System Recovery**
   ```bash
   # Restore from backup
   sudo /opt/backups/restore.sh --service <service-name>
   
   # Rollback deployment
   ansible-playbook rollback.yml
   ```

3. **Emergency Procedures**
   ```bash
   # Stop all services
   docker-compose down
   
   # Emergency maintenance mode
   ansible-playbook site.yml --tags maintenance
   ```

## Maintenance

### Regular Maintenance Tasks

1. **Weekly**
   - Review system logs
   - Check backup status
   - Update security packages
   - Monitor resource usage

2. **Monthly**
   - Review security configurations
   - Update application containers
   - Test disaster recovery procedures
   - Review monitoring alerts

3. **Quarterly**
   - Security audit
   - Performance optimization
   - Capacity planning
   - Documentation updates

### Update Procedures

```bash
# Update containers
docker-compose pull
docker-compose up -d

# Update system packages
sudo apt update && sudo apt upgrade

# Update Ansible playbooks
git pull origin main
ansible-playbook site.yml --tags update
```

## Support and Resources

### Documentation
- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [Security Guide](docs/SECURITY.md)
- [Monitoring Guide](docs/MONITORING.md)
- [Backup Guide](docs/BACKUP_ORCHESTRATION.md)

### Community Support
- GitHub Issues
- Discord Community
- Reddit r/homelab

### Professional Support
- Email: support@your-domain.com
- Phone: +1-XXX-XXX-XXXX
- Emergency: +1-XXX-XXX-XXXX

## Compliance and Auditing

### Security Compliance
- Regular vulnerability scans
- Penetration testing
- Security policy enforcement
- Incident response procedures

### Audit Logging
- System access logs
- Application activity logs
- Security event logs
- Change management logs

### Data Protection
- GDPR compliance (if applicable)
- Data retention policies
- Privacy protection measures
- Regular compliance audits

---

**Note:** This guide assumes a production environment with proper security measures. Always test in a staging environment before deploying to production. 