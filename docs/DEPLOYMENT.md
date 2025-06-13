# Homelab Deployment Guide

This guide provides detailed instructions for deploying and validating your homelab environment.

## Table of Contents
1. [Pre-deployment Checklist](#pre-deployment-checklist)
2. [Deployment Steps](#deployment-steps)
3. [Post-deployment Validation](#post-deployment-validation)
4. [Troubleshooting Deployment Issues](#troubleshooting-deployment-issues)
5. [Rollback Procedures](#rollback-procedures)
6. [Maintenance Procedures](#maintenance-procedures)

## Pre-deployment Checklist

### System Requirements
```bash
# Check system resources
free -h  # Minimum 4GB RAM
df -h    # Minimum 20GB free space
nproc    # Minimum 2 CPU cores

# Verify network connectivity
ping -c 4 8.8.8.8
ping -c 4 google.com

# Check DNS resolution
nslookup example.com
```

### Prerequisites
```bash
# Verify Ansible installation
ansible --version  # Should be 2.9.0 or higher

# Check Python version
python3 --version  # Should be 3.8 or higher

# Verify SSH access
ssh -T user@host

# Check Docker installation
docker --version
docker-compose --version
```

### Configuration Validation
```bash
# Verify inventory file
ansible-inventory --list

# Check variable definitions
cat group_vars/all.yml

# Validate playbook syntax
ansible-playbook main.yml --syntax-check
```

## Deployment Steps

### Initial Setup
```bash
# Clone repository
git clone https://github.com/your-repo/homelab.git
cd homelab

# Install dependencies
ansible-galaxy install -r requirements.yml

# Generate SSH keys
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

### Foundation Deployment
```bash
# Deploy base system
ansible-playbook main.yml --tags foundation

# Verify system configuration
./verify-foundation.sh

# Check system services
systemctl status docker
systemctl status sshd
```

### Core Services
```bash
# Deploy core services
ansible-playbook main.yml --tags core

# Validate service deployment
./verify-core-services.sh

# Check service health
curl -s http://localhost:8080/health
```

### Monitoring Stack
```bash
# Deploy monitoring
ansible-playbook main.yml --tags monitoring

# Verify monitoring setup
./verify-monitoring.sh

# Check metrics collection
curl -s http://localhost:9090/api/v1/query?query=up
```

### Security Services
```bash
# Deploy security services
ansible-playbook main.yml --tags security

# Validate security configuration
./verify-security.sh

# Check firewall rules
ufw status
```

### Media Stack
```bash
# Deploy media services
ansible-playbook main.yml --tags media

# Verify media services
./verify-media.sh

# Test media access
curl -s http://localhost:8096/System/Info
```

### File Services
```bash
# Deploy file services
ansible-playbook main.yml --tags files

# Validate file services
./verify-files.sh

# Test file access
smbclient -L //localhost
```

### Automation Services
```bash
# Deploy automation
ansible-playbook main.yml --tags automation

# Verify automation setup
./verify-automation.sh

# Test automation workflows
curl -s http://localhost:8123/api/services
```

### Utility Services
```bash
# Deploy utilities
ansible-playbook main.yml --tags utilities

# Validate utility services
./verify-utilities.sh

# Test utility functions
curl -s http://localhost:8080/api/health
```

### Dashboard Deployment
```bash
# Deploy dashboard
ansible-playbook main.yml --tags dashboard

# Verify dashboard setup
./verify-dashboard.sh

# Check dashboard access
curl -s http://localhost:3000/api/health
```

## Post-deployment Validation

### System Health Checks
```bash
# Check system status
systemctl status

# Verify resource usage
htop

# Check disk space
df -h

# Monitor system logs
journalctl -p 3 --since "1 hour ago"
```

### Service Validation
```bash
# Verify all services
./verify-all-services.sh

# Check service dependencies
docker-compose ps

# Validate service communication
./verify-service-communication.sh

# Test service endpoints
./test-endpoints.sh
```

### Security Validation
```bash
# Verify security configuration
./verify-security-config.sh

# Check firewall rules
ufw status verbose

# Validate SSL certificates
./verify-ssl.sh

# Test security measures
./test-security.sh
```

### Backup Validation
```bash
# Verify backup configuration
./verify-backup-config.sh

# Test backup process
./test-backup.sh

# Validate backup integrity
./verify-backup-integrity.sh

# Check backup retention
./verify-backup-retention.sh
```

### Network Validation
```bash
# Verify network configuration
./verify-network.sh

# Check port accessibility
./verify-ports.sh

# Test DNS resolution
./verify-dns.sh

# Validate reverse proxy
./verify-proxy.sh
```

### Performance Validation
```bash
# Check system performance
./verify-performance.sh

# Test resource limits
./verify-resources.sh

# Validate scaling
./verify-scaling.sh

# Check response times
./verify-response-times.sh
```

## Troubleshooting Deployment Issues

### Service Startup Issues
```bash
# Check service logs
docker-compose logs

# Verify service configuration
docker-compose config

# Test service connectivity
./test-service-connectivity.sh

# Debug service issues
./debug-service.sh
```

### Network Issues
```bash
# Check network configuration
ip a

# Verify DNS resolution
cat /etc/resolv.conf

# Test network connectivity
./test-network.sh

# Debug network issues
./debug-network.sh
```

### Resource Issues
```bash
# Check resource usage
./check-resources.sh

# Verify resource limits
./verify-limits.sh

# Optimize resource allocation
./optimize-resources.sh

# Debug resource issues
./debug-resources.sh
```

## Rollback Procedures

### Service Rollback
```bash
# Stop affected services
docker-compose down

# Restore from backup
./restore-service.sh

# Verify restoration
./verify-restoration.sh

# Restart services
docker-compose up -d
```

### Full Stack Rollback
```bash
# Stop all services
./stop-all.sh

# Restore system state
./restore-system.sh

# Verify system state
./verify-system.sh

# Restart stack
./start-all.sh
```

## Maintenance Procedures

### Regular Updates
```bash
# Update system packages
apt update && apt upgrade -y

# Update Docker images
docker-compose pull

# Update Ansible playbooks
git pull origin main
```

### Backup Procedures
```bash
# Create system backup
./backup-system.sh

# Verify backup
./verify-backup.sh

# Clean old backups
./clean-backups.sh
```

### Monitoring Maintenance
```bash
# Check monitoring status
./check-monitoring.sh

# Update monitoring rules
./update-monitoring.sh

# Verify alerting
./verify-alerts.sh
```

## Validation Scripts

### Service Validation
```bash
#!/bin/bash
# verify-all-services.sh

# Check Docker services
echo "Checking Docker services..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Verify service health
echo "Verifying service health..."
for service in $(docker ps --format "{{.Names}}"); do
    curl -s http://localhost:8080/health/$service
done

# Check service logs
echo "Checking service logs..."
docker-compose logs --tail=100

# Verify service dependencies
echo "Verifying service dependencies..."
docker-compose ps
```

### Security Validation
```bash
#!/bin/bash
# verify-security-config.sh

# Check firewall status
echo "Checking firewall status..."
ufw status verbose

# Verify SSL certificates
echo "Verifying SSL certificates..."
for cert in /etc/ssl/certs/*.pem; do
    openssl x509 -in $cert -text -noout
done

# Check security services
echo "Checking security services..."
systemctl status fail2ban
systemctl status ufw
systemctl status apparmor

# Verify security logs
echo "Checking security logs..."
tail -f /var/log/auth.log
```

### Performance Validation
```bash
#!/bin/bash
# verify-performance.sh

# Check CPU usage
echo "Checking CPU usage..."
top -b -n 1

# Monitor memory usage
echo "Monitoring memory usage..."
free -h

# Check disk I/O
echo "Checking disk I/O..."
iostat -x 1 5

# Verify network performance
echo "Verifying network performance..."
iperf3 -c localhost
```

## Getting Help

If you encounter issues during deployment:

1. Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Review the [Maintenance Guide](MAINTENANCE.md)
3. Check system logs
4. Contact support

## Contributing

To improve this deployment guide:

1. Fork the repository
2. Add your deployment procedures
3. Submit a pull request

Your contributions help improve the homelab deployment process! 