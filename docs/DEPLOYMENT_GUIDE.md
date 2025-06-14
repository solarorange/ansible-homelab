# Homelab Deployment Guide

## Overview
This guide provides detailed instructions for deploying and managing the homelab infrastructure using Ansible.

## Prerequisites

### System Requirements
- Proxmox VE 7.0 or later
- Minimum 16GB RAM
- 4+ CPU cores
- 100GB+ storage
- Network connectivity

### Required Software
- Ansible 2.9+
- Python 3.8+
- Git
- SSH client

### Network Requirements
- Static IP assignment
- DNS resolution
- Port forwarding (if needed)
- VLAN support (optional)

## Installation

### 1. Clone Repository
```bash
git clone https://github.com/solarorange/ansible-homelab.git
cd ansible-homelab
```

### 2. Install Dependencies
```bash
ansible-galaxy install -r requirements.yml
```

### 3. Configure Environment
1. Copy example inventory:
```bash
cp inventory.example.yml inventory.yml
```

2. Edit inventory.yml with your settings:
```yaml
[homelab_core]
homelab-core ansible_host=192.168.1.100 ansible_user=homelab
```

3. Configure variables in group_vars/all/vars.yml:
```yaml
domain: zorg.media
username: your_username
```

## Deployment

### 1. Initial Setup
```bash
ansible-playbook main.yml --tags setup
```

### 2. Core Services
```bash
ansible-playbook main.yml --tags foundation
```

### 3. Service Deployment
```bash
# Deploy all services
ansible-playbook main.yml

# Deploy specific service groups
ansible-playbook main.yml --tags monitoring
ansible-playbook main.yml --tags media
ansible-playbook main.yml --tags security
```

## Service Management

### Starting Services
```bash
ansible-playbook main.yml --tags start
```

### Stopping Services
```bash
ansible-playbook main.yml --tags stop
```

### Updating Services
```bash
ansible-playbook main.yml --tags update
```

## Monitoring

### Accessing Dashboards
- Grafana: https://grafana.zorg.media
- Prometheus: https://prometheus.zorg.media
- Alertmanager: https://alertmanager.zorg.media

### Setting Up Alerts
1. Configure notification channels in Alertmanager
2. Define alert rules in Prometheus
3. Set up Grafana dashboards

## Backup and Recovery

### Automated Backups
- Daily incremental backups
- Weekly full backups
- Monthly archives

### Manual Backup
```bash
ansible-playbook main.yml --tags backup
```

### Restore from Backup
```bash
ansible-playbook main.yml --tags restore --extra-vars "backup_date=YYYY-MM-DD"
```

## Security

### Access Control
- SSH key authentication
- VPN access
- Service authentication

### Security Updates
```bash
ansible-playbook main.yml --tags security-update
```

### Security Scanning
```bash
ansible-playbook main.yml --tags security-scan
```

## Troubleshooting

### Common Issues
1. Service startup failures
2. Network connectivity
3. Resource constraints
4. Configuration errors

### Debugging
```bash
# Enable verbose output
ansible-playbook main.yml -vvv

# Check service logs
ansible-playbook main.yml --tags logs

# Validate configuration
ansible-playbook main.yml --tags validate
```

### Recovery Procedures
1. Service rollback
2. Configuration restore
3. Data recovery

## Maintenance

### Regular Tasks
- Weekly security updates
- Monthly backup verification
- Quarterly performance review
- Annual capacity planning

### Update Procedures
1. Backup current state
2. Update Ansible playbooks
3. Run deployment
4. Verify services

## Performance Tuning

### Resource Allocation
- CPU limits
- Memory constraints
- Storage quotas
- Network bandwidth

### Optimization
- Service configuration
- Cache settings
- Database tuning
- Network optimization

## Documentation

### Additional Resources
- [Service Documentation](docs/SERVICES.md)
- [Security Guide](docs/SECURITY.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [API Documentation](docs/API.md)

### Contributing
1. Fork repository
2. Create feature branch
3. Submit pull request
4. Update documentation

## Support

### Getting Help
- GitHub Issues
- Documentation
- Community Forums
- Email Support

### Reporting Issues
1. Check existing issues
2. Provide detailed information
3. Include logs and configuration
4. Describe expected behavior 