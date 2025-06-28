# Production Deployment Guide

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Environment Setup](#environment-setup)
4. [Pre-Deployment Checklist](#pre-deployment-checklist)
5. [Deployment Procedures](#deployment-procedures)
6. [Post-Deployment Validation](#post-deployment-validation)
7. [Monitoring and Alerting](#monitoring-and-alerting)
8. [Security Hardening](#security-hardening)
9. [Backup and Recovery](#backup-and-recovery)
10. [Performance Tuning](#performance-tuning)
11. [Scaling Strategies](#scaling-strategies)
12. [Maintenance Procedures](#maintenance-procedures)
13. [Troubleshooting](#troubleshooting)
14. [Disaster Recovery](#disaster-recovery)

## Overview

This guide provides comprehensive procedures for deploying the Ansible homelab infrastructure to production environments. The infrastructure includes:

- **Core Infrastructure**: Security, databases, storage, networking
- **Monitoring Stack**: Prometheus, Grafana, Loki, AlertManager
- **Media Services**: Plex, Jellyfin, Sonarr, Radarr, etc.
- **Automation**: Home automation, scheduling, container management
- **Utilities**: Dashboards, media processing, backup orchestration
- **Security**: Authentication, VPN, firewall, DNS protection

## Prerequisites

### System Requirements

#### Minimum Requirements
- **CPU**: 4 cores (8+ recommended)
- **RAM**: 8GB (16GB+ recommended)
- **Storage**: 100GB SSD + additional storage for media
- **Network**: 1Gbps connection
- **OS**: Ubuntu 20.04+ or Debian 11+

#### Recommended Requirements
- **CPU**: 8+ cores
- **RAM**: 32GB+
- **Storage**: 500GB+ NVMe SSD + 10TB+ for media
- **Network**: 2.5Gbps+ connection
- **OS**: Ubuntu 22.04 LTS

### Software Prerequisites

```bash
# Install Ansible
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Python dependencies
sudo apt install -y python3-pip python3-venv
pip3 install docker-compose

# Install monitoring tools
sudo apt install -y htop iotop nethogs
```

### Network Requirements

- **Static IP**: Configure static IP for the server
- **Port Forwarding**: Configure router for required ports
- **DNS**: Set up domain name and DNS records
- **SSL Certificates**: Obtain SSL certificates for services
- **Firewall**: Configure firewall rules

## Environment Setup

### Environment Configuration

Create environment-specific configuration files:

```yaml
# group_vars/all/environments/production.yml
environment: production
deployment_mode: production

# Resource limits for production
resource_limits:
  max_concurrent_containers: 20
  max_concurrent_backups: 3
  cpu_threshold: 80
  memory_threshold: 85

# Production security settings
security_hardening:
  enabled: true
  compliance_frameworks:
    - cis_docker_benchmark
    - nist_cybersecurity_framework

# Production monitoring
monitoring:
  retention_days: 90
  alerting_enabled: true
  auto_scaling: true

# Production backup strategy
backup_strategies:
  incremental:
    enabled: true
    retention_days: 365
    encryption: true
    compression: true
```

### Inventory Configuration

```yaml
# inventory/production.yml
all:
  children:
    production:
      hosts:
        homelab-prod-01:
          ansible_host: 192.168.1.100
          ansible_user: ansible
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
          environment: production
          datacenter: primary
          role: main_server
          
        homelab-prod-02:
          ansible_host: 192.168.1.101
          ansible_user: ansible
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
          environment: production
          datacenter: primary
          role: backup_server
      
      vars:
        ansible_python_interpreter: /usr/bin/python3
        deployment_environment: production
```

## Pre-Deployment Checklist

### System Preparation

- [ ] Update system packages
- [ ] Configure static IP address
- [ ] Set up SSH key authentication
- [ ] Configure firewall rules
- [ ] Install required software
- [ ] Configure DNS resolution
- [ ] Set up SSL certificates
- [ ] Configure backup storage
- [ ] Test network connectivity
- [ ] Verify disk space

### Security Preparation

- [ ] Review security policies
- [ ] Configure user accounts
- [ ] Set up monitoring access
- [ ] Configure audit logging
- [ ] Test security controls
- [ ] Verify compliance requirements

### Network Preparation

- [ ] Configure port forwarding
- [ ] Set up reverse proxy
- [ ] Configure load balancer
- [ ] Test external connectivity
- [ ] Verify SSL certificates
- [ ] Configure DNS records

## Deployment Procedures

### 1. Initial Deployment

```bash
# Clone the repository
git clone https://github.com/your-repo/ansible_homelab.git
cd ansible_homelab

# Create production inventory
cp inventory.yml inventory/production.yml
# Edit inventory/production.yml with your production hosts

# Set environment variables
export ANSIBLE_ENVIRONMENT=production
export ANSIBLE_INVENTORY=inventory/production.yml

# Run pre-flight checks
ansible-playbook -i inventory/production.yml tasks/pre_tasks.yml --tags validation

# Deploy core infrastructure
ansible-playbook -i inventory/production.yml site.yml --tags infrastructure

# Deploy monitoring stack
ansible-playbook -i inventory/production.yml site.yml --tags monitoring

# Deploy services
ansible-playbook -i inventory/production.yml site.yml --tags services

# Apply security hardening
ansible-playbook -i inventory/production.yml site.yml --tags security,hardening
```

### 2. Staged Deployment

For large deployments, use staged approach:

```bash
# Stage 1: Core infrastructure
ansible-playbook -i inventory/production.yml site.yml \
  --tags "security,databases,storage" \
  --limit homelab-prod-01

# Stage 2: Monitoring and logging
ansible-playbook -i inventory/production.yml site.yml \
  --tags "logging,certificate_management" \
  --limit homelab-prod-01

# Stage 3: Media services
ansible-playbook -i inventory/production.yml site.yml \
  --tags "media" \
  --limit homelab-prod-01

# Stage 4: Automation and utilities
ansible-playbook -i inventory/production.yml site.yml \
  --tags "automation,utilities" \
  --limit homelab-prod-01

# Stage 5: Validation and optimization
ansible-playbook -i inventory/production.yml site.yml \
  --tags "validation,optimization" \
  --limit homelab-prod-01
```

### 3. Blue-Green Deployment

For zero-downtime deployments:

```bash
# Deploy to green environment
ansible-playbook -i inventory/production.yml site.yml \
  --limit homelab-prod-02 \
  --extra-vars "deployment_color=green"

# Validate green environment
ansible-playbook -i inventory/production.yml tasks/validate.yml \
  --limit homelab-prod-02

# Switch traffic to green
ansible-playbook -i inventory/production.yml tasks/switch_traffic.yml \
  --extra-vars "active_environment=green"

# Deploy to blue environment (now inactive)
ansible-playbook -i inventory/production.yml site.yml \
  --limit homelab-prod-01 \
  --extra-vars "deployment_color=blue"
```

## Post-Deployment Validation

### Service Validation

```bash
# Run comprehensive validation
ansible-playbook -i inventory/production.yml tasks/validate.yml

# Check service health
ansible-playbook -i inventory/production.yml tasks/advanced_health_monitoring.yml

# Verify monitoring
ansible-playbook -i inventory/production.yml tasks/monitor_performance.yml

# Test backup procedures
ansible-playbook -i inventory/production.yml tasks/verify_backups.yml
```

### Performance Validation

```bash
# Run performance tests
ansible-playbook -i inventory/production.yml tests/automated/test_runner.yml

# Check resource utilization
ansible-playbook -i inventory/production.yml tasks/monitor_performance.yml

# Validate security compliance
ansible-playbook -i inventory/production.yml tasks/advanced_security_hardening.yml
```

## Monitoring and Alerting

### Monitoring Stack Configuration

The monitoring stack includes:

- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Loki**: Log aggregation
- **AlertManager**: Alert routing and notification

### Alert Configuration

```yaml
# group_vars/all/monitoring/alerts.yml
alerting:
  enabled: true
  
  # Critical alerts
  critical:
    - service_down
    - disk_space_critical
    - memory_critical
    - backup_failure
    - security_violation
  
  # Warning alerts
  warning:
    - high_cpu_usage
    - high_memory_usage
    - disk_space_warning
    - service_degraded
  
  # Notification channels
  notifications:
    email:
      enabled: true
      recipients:
        - admin@yourdomain.com
    slack:
      enabled: true
      webhook_url: "{{ lookup('env', 'SLACK_WEBHOOK') }}"
    pagerduty:
      enabled: true
      api_key: "{{ lookup('env', 'PAGERDUTY_API_KEY') }}"
```

### Dashboard Configuration

```yaml
# group_vars/all/monitoring/dashboards.yml
dashboards:
  - name: "Homelab Overview"
    description: "Main dashboard for homelab services"
    panels:
      - system_metrics
      - service_status
      - resource_utilization
      - network_traffic
  
  - name: "Security Dashboard"
    description: "Security monitoring and compliance"
    panels:
      - security_events
      - compliance_status
      - firewall_logs
      - authentication_events
```

## Security Hardening

### System Hardening

```bash
# Apply security hardening
ansible-playbook -i inventory/production.yml tasks/advanced_security_hardening.yml

# Configure firewall
ansible-playbook -i inventory/production.yml roles/security/tasks/firewall.yml

# Set up authentication
ansible-playbook -i inventory/production.yml roles/security/tasks/authentication.yml

# Configure VPN
ansible-playbook -i inventory/production.yml roles/security/tasks/vpn.yml
```

### Compliance Configuration

```yaml
# group_vars/all/security/compliance.yml
compliance:
  enabled: true
  
  frameworks:
    cis_docker_benchmark:
      enabled: true
      scan_schedule: "weekly"
    
    nist_cybersecurity_framework:
      enabled: true
      controls:
        - identify
        - protect
        - detect
        - respond
        - recover
    
    gdpr_compliance:
      enabled: true
      data_retention: 365
      encryption: true
```

## Backup and Recovery

### Backup Configuration

```yaml
# group_vars/all/backup/strategy.yml
backup_strategies:
  incremental:
    enabled: true
    schedule: "0 2 * * *"  # Daily at 2 AM
    retention_days: 365
    compression: true
    encryption: true
    
  full_backup:
    schedule: "0 2 * * 0"  # Weekly on Sunday
    retention_weeks: 52
    
  disaster_recovery:
    enabled: true
    replication: true
    offsite_backup: true
```

### Recovery Procedures

```bash
# Test backup restoration
ansible-playbook -i inventory/production.yml tasks/verify_backups.yml

# Perform disaster recovery test
ansible-playbook -i inventory/production.yml tasks/disaster_recovery_test.yml

# Restore from backup (if needed)
ansible-playbook -i inventory/production.yml tasks/restore_from_backup.yml \
  --extra-vars "backup_date=2024-01-15"
```

## Performance Tuning

### System Optimization

```yaml
# group_vars/all/performance/tuning.yml
performance_tuning:
  system:
    kernel_parameters:
      vm.swappiness: 10
      vm.dirty_ratio: 15
      vm.dirty_background_ratio: 5
    
    io_scheduler: "deadline"
    cpu_governor: "performance"
    
  docker:
    storage_driver: "overlay2"
    log_driver: "json-file"
    log_max_size: "10m"
    log_max_files: 3
```

### Resource Optimization

```bash
# Apply performance tuning
ansible-playbook -i inventory/production.yml tasks/performance_tuning.yml

# Monitor performance
ansible-playbook -i inventory/production.yml tasks/monitor_performance.yml

# Optimize based on metrics
ansible-playbook -i inventory/production.yml tasks/optimize_resources.yml
```

## Scaling Strategies

### Horizontal Scaling

```yaml
# inventory/scaled_production.yml
all:
  children:
    production:
      hosts:
        homelab-prod-01:
          role: main_server
          services: [databases, monitoring, core_services]
          
        homelab-prod-02:
          role: media_server
          services: [media_services, processing]
          
        homelab-prod-03:
          role: backup_server
          services: [backup, archive]
          
        homelab-prod-04:
          role: load_balancer
          services: [nginx, haproxy]
```

### Vertical Scaling

```yaml
# group_vars/all/scaling/vertical.yml
vertical_scaling:
  enabled: true
  
  resource_upgrades:
    memory:
      threshold: 85
      increment: "4G"
      max_memory: "64G"
    
    cpu:
      threshold: 80
      increment: 2
      max_cores: 16
    
    storage:
      threshold: 80
      increment: "100G"
      max_storage: "10T"
```

## Maintenance Procedures

### Regular Maintenance

```bash
# Weekly maintenance
ansible-playbook -i inventory/production.yml tasks/maintenance/weekly.yml

# Monthly maintenance
ansible-playbook -i inventory/production.yml tasks/maintenance/monthly.yml

# Quarterly maintenance
ansible-playbook -i inventory/production.yml tasks/maintenance/quarterly.yml
```

### Update Procedures

```bash
# Update system packages
ansible-playbook -i inventory/production.yml tasks/update_system.yml

# Update Docker images
ansible-playbook -i inventory/production.yml tasks/update_containers.yml

# Update Ansible roles
ansible-galaxy install -r requirements.yml --force
```

## Troubleshooting

### Common Issues

1. **Service Failures**
   ```bash
   # Check service status
   ansible-playbook -i inventory/production.yml tasks/troubleshoot_services.yml
   
   # View logs
   ansible-playbook -i inventory/production.yml tasks/view_logs.yml
   ```

2. **Performance Issues**
   ```bash
   # Analyze performance
   ansible-playbook -i inventory/production.yml tasks/analyze_performance.yml
   
   # Optimize resources
   ansible-playbook -i inventory/production.yml tasks/optimize_resources.yml
   ```

3. **Security Issues**
   ```bash
   # Security audit
   ansible-playbook -i inventory/production.yml tasks/security_audit.yml
   
   # Compliance check
   ansible-playbook -i inventory/production.yml tasks/compliance_check.yml
   ```

### Diagnostic Tools

```bash
# Run diagnostics
ansible-playbook -i inventory/production.yml tasks/diagnostics.yml

# Generate health report
ansible-playbook -i inventory/production.yml tasks/health_report.yml

# Export logs for analysis
ansible-playbook -i inventory/production.yml tasks/export_logs.yml
```

## Disaster Recovery

### Recovery Procedures

```bash
# Full system recovery
ansible-playbook -i inventory/production.yml tasks/disaster_recovery/full_recovery.yml

# Service-specific recovery
ansible-playbook -i inventory/production.yml tasks/disaster_recovery/service_recovery.yml

# Data recovery
ansible-playbook -i inventory/production.yml tasks/disaster_recovery/data_recovery.yml
```

### Recovery Testing

```bash
# Test recovery procedures
ansible-playbook -i inventory/production.yml tasks/disaster_recovery/test_recovery.yml

# Validate recovery
ansible-playbook -i inventory/production.yml tasks/disaster_recovery/validate_recovery.yml
```

## Conclusion

This production deployment guide provides comprehensive procedures for deploying and maintaining your Ansible homelab infrastructure in production environments. Follow these procedures carefully and always test in staging environments before deploying to production.

For additional information, refer to:
- [Advanced Best Practices](ADVANCED_BEST_PRACTICES.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [Security Guide](SECURITY.md)
- [Monitoring Guide](MONITORING.md)
- [Maintenance Guide](MAINTENANCE.md) 