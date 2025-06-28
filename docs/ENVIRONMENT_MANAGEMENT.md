# Environment Management Guide

## Table of Contents

1. [Overview](#overview)
2. [Environment Types](#environment-types)
3. [Environment Configuration](#environment-configuration)
4. [Environment Isolation](#environment-isolation)
5. [Configuration Management](#configuration-management)
6. [Deployment Strategies](#deployment-strategies)
7. [Environment Promotion](#environment-promotion)
8. [Environment Monitoring](#environment-monitoring)
9. [Environment Cleanup](#environment-cleanup)
10. [Best Practices](#best-practices)

## Overview

This guide covers the management of multiple environments (development, staging, production) for the Ansible homelab infrastructure. Proper environment management ensures consistent deployments, reduces risks, and enables safe testing of changes.

## Environment Types

### Development Environment

**Purpose**: Local development and testing
**Characteristics**:
- Minimal resource usage
- Fast iteration cycles
- Debugging enabled
- Non-critical data

**Configuration**:
```yaml
# group_vars/all/environments/development.yml
environment: development
deployment_mode: development

# Resource limits
resource_limits:
  max_concurrent_containers: 5
  max_concurrent_backups: 1
  cpu_threshold: 90
  memory_threshold: 90

# Development-specific settings
development:
  debug_enabled: true
  hot_reload: true
  log_level: DEBUG
  monitoring_retention: 7
  backup_retention: 7
  security_scanning: false
  compliance_checking: false

# Service configuration
services:
  databases:
    data_persistence: false
    backup_enabled: false
  
  monitoring:
    retention_days: 7
    alerting_enabled: false
  
  media:
    transcoding_enabled: false
    download_enabled: false
```

### Staging Environment

**Purpose**: Pre-production testing and validation
**Characteristics**:
- Production-like configuration
- Safe testing environment
- Performance testing
- Integration testing

**Configuration**:
```yaml
# group_vars/all/environments/staging.yml
environment: staging
deployment_mode: staging

# Resource limits
resource_limits:
  max_concurrent_containers: 10
  max_concurrent_backups: 2
  cpu_threshold: 85
  memory_threshold: 85

# Staging-specific settings
staging:
  debug_enabled: false
  hot_reload: false
  log_level: INFO
  monitoring_retention: 30
  backup_retention: 30
  security_scanning: true
  compliance_checking: true

# Service configuration
services:
  databases:
    data_persistence: true
    backup_enabled: true
    backup_retention: 30
  
  monitoring:
    retention_days: 30
    alerting_enabled: true
  
  media:
    transcoding_enabled: true
    download_enabled: true
    test_data_only: true
```

### Production Environment

**Purpose**: Live production services
**Characteristics**:
- High availability
- Performance optimized
- Security hardened
- Comprehensive monitoring

**Configuration**:
```yaml
# group_vars/all/environments/production.yml
environment: production
deployment_mode: production

# Resource limits
resource_limits:
  max_concurrent_containers: 20
  max_concurrent_backups: 3
  cpu_threshold: 80
  memory_threshold: 85

# Production-specific settings
production:
  debug_enabled: false
  hot_reload: false
  log_level: WARNING
  monitoring_retention: 90
  backup_retention: 365
  security_scanning: true
  compliance_checking: true
  auto_scaling: true

# Service configuration
services:
  databases:
    data_persistence: true
    backup_enabled: true
    backup_retention: 365
    encryption: true
  
  monitoring:
    retention_days: 90
    alerting_enabled: true
    auto_scaling: true
  
  media:
    transcoding_enabled: true
    download_enabled: true
    optimization_enabled: true
```

## Environment Configuration

### Environment Detection

```yaml
# group_vars/all/environment_config.yml
# Environment detection and configuration
environment: "{{ lookup('env', 'ANSIBLE_ENVIRONMENT') | default('development') }}"

# Environment-specific variable loading
environment_configs:
  development:
    config_file: "group_vars/all/environments/development.yml"
    inventory: "inventory/development.yml"
    tags: ["dev", "development"]
  
  staging:
    config_file: "group_vars/all/environments/staging.yml"
    inventory: "inventory/staging.yml"
    tags: ["staging", "test"]
  
  production:
    config_file: "group_vars/all/environments/production.yml"
    inventory: "inventory/production.yml"
    tags: ["prod", "production"]
```

### Environment-Specific Playbooks

```yaml
# playbooks/environment_deploy.yml
---
- name: Deploy to specific environment
  hosts: "{{ target_hosts | default('all') }}"
  become: true
  gather_facts: true
  
  vars_files:
    - "group_vars/all/environments/{{ environment }}.yml"
    - "group_vars/all/common.yml"
  
  pre_tasks:
    - name: Validate environment configuration
      ansible.builtin.include_tasks: tasks/validate_environment.yml
      tags: [always, validation]
  
  roles:
    - name: security
      when: security_enabled | default(true)
    
    - name: databases
      when: databases_enabled | default(true)
    
    - name: storage
      when: storage_enabled | default(true)
    
    - name: logging
      when: logging_enabled | default(true)
    
    - name: media
      when: media_enabled | default(true)
    
    - name: automation
      when: automation_enabled | default(true)
    
    - name: utilities
      when: utilities_enabled | default(true)
  
  post_tasks:
    - name: Environment-specific post-deployment tasks
      ansible.builtin.include_tasks: "tasks/environments/{{ environment }}_post_deploy.yml"
      when: environment is defined
```

### Environment Variables

```bash
# Environment-specific environment variables
# .env.development
ANSIBLE_ENVIRONMENT=development
ANSIBLE_INVENTORY=inventory/development.yml
ANSIBLE_TAGS=dev,development
DEBUG_ENABLED=true
LOG_LEVEL=DEBUG

# .env.staging
ANSIBLE_ENVIRONMENT=staging
ANSIBLE_INVENTORY=inventory/staging.yml
ANSIBLE_TAGS=staging,test
DEBUG_ENABLED=false
LOG_LEVEL=INFO

# .env.production
ANSIBLE_ENVIRONMENT=production
ANSIBLE_INVENTORY=inventory/production.yml
ANSIBLE_TAGS=prod,production
DEBUG_ENABLED=false
LOG_LEVEL=WARNING
```

## Environment Isolation

### Network Isolation

```yaml
# group_vars/all/network/isolation.yml
network_isolation:
  enabled: true
  
  # VLAN configuration
  vlans:
    development:
      vlan_id: 100
      subnet: "192.168.100.0/24"
      gateway: "192.168.100.1"
    
    staging:
      vlan_id: 200
      subnet: "192.168.200.0/24"
      gateway: "192.168.200.1"
    
    production:
      vlan_id: 300
      subnet: "192.168.300.0/24"
      gateway: "192.168.300.1"
  
  # Firewall rules
  firewall_rules:
    development:
      - allow: "192.168.100.0/24"
      - deny: "192.168.200.0/24"
      - deny: "192.168.300.0/24"
    
    staging:
      - allow: "192.168.200.0/24"
      - allow: "192.168.100.0/24"  # Allow dev access
      - deny: "192.168.300.0/24"
    
    production:
      - allow: "192.168.300.0/24"
      - allow: "192.168.200.0/24"  # Allow staging access
      - deny: "192.168.100.0/24"
```

### Data Isolation

```yaml
# group_vars/all/data/isolation.yml
data_isolation:
  enabled: true
  
  # Database isolation
  databases:
    development:
      database_name: "homelab_dev"
      user_prefix: "dev_"
      data_retention: 7
    
    staging:
      database_name: "homelab_staging"
      user_prefix: "staging_"
      data_retention: 30
    
    production:
      database_name: "homelab_prod"
      user_prefix: "prod_"
      data_retention: 365
  
  # Storage isolation
  storage:
    development:
      base_path: "/opt/homelab/dev"
      backup_path: "/opt/backups/dev"
    
    staging:
      base_path: "/opt/homelab/staging"
      backup_path: "/opt/backups/staging"
    
    production:
      base_path: "/opt/homelab/prod"
      backup_path: "/opt/backups/prod"
```

## Configuration Management

### Environment-Specific Configurations

```yaml
# group_vars/all/config_management.yml
config_management:
  enabled: true
  
  # Configuration templates
  templates:
    development:
      source: "templates/environments/development/"
      destination: "/opt/homelab/dev/config/"
    
    staging:
      source: "templates/environments/staging/"
      destination: "/opt/homelab/staging/config/"
    
    production:
      source: "templates/environments/production/"
      destination: "/opt/homelab/prod/config/"
  
  # Configuration validation
  validation:
    enabled: true
    strict_mode: true
    schema_validation: true
```

### Configuration Versioning

```yaml
# group_vars/all/config_versioning.yml
config_versioning:
  enabled: true
  
  # Version control
  git:
    enabled: true
    repository: "https://github.com/your-repo/homelab-configs"
    branch: "{{ environment }}"
    auto_commit: true
  
  # Configuration backup
  backup:
    enabled: true
    retention: 30
    compression: true
```

## Deployment Strategies

### Environment-Specific Deployment

```bash
# Development deployment
ansible-playbook -i inventory/development.yml playbooks/environment_deploy.yml \
  --extra-vars "environment=development" \
  --tags "dev,development"

# Staging deployment
ansible-playbook -i inventory/staging.yml playbooks/environment_deploy.yml \
  --extra-vars "environment=staging" \
  --tags "staging,test"

# Production deployment
ansible-playbook -i inventory/production.yml playbooks/environment_deploy.yml \
  --extra-vars "environment=production" \
  --tags "prod,production"
```

### Blue-Green Deployment

```yaml
# playbooks/blue_green_deploy.yml
---
- name: Blue-Green Deployment
  hosts: "{{ target_hosts }}"
  become: true
  
  vars:
    blue_hosts: "{{ groups['blue'] | default([]) }}"
    green_hosts: "{{ groups['green'] | default([]) }}"
    active_environment: "{{ active_env | default('blue') }}"
  
  tasks:
    - name: Deploy to inactive environment
      ansible.builtin.include_tasks: tasks/deploy_to_inactive.yml
      when: active_environment == 'blue'
      vars:
        target_hosts: "{{ green_hosts }}"
        deployment_color: green
    
    - name: Deploy to inactive environment
      ansible.builtin.include_tasks: tasks/deploy_to_inactive.yml
      when: active_environment == 'green'
      vars:
        target_hosts: "{{ blue_hosts }}"
        deployment_color: blue
    
    - name: Validate deployment
      ansible.builtin.include_tasks: tasks/validate_deployment.yml
    
    - name: Switch traffic
      ansible.builtin.include_tasks: tasks/switch_traffic.yml
```

## Environment Promotion

### Promotion Procedures

```yaml
# playbooks/environment_promotion.yml
---
- name: Promote environment
  hosts: localhost
  gather_facts: false
  
  vars:
    source_environment: "{{ source_env | default('development') }}"
    target_environment: "{{ target_env | default('staging') }}"
  
  tasks:
    - name: Validate source environment
      ansible.builtin.include_tasks: tasks/validate_environment.yml
      vars:
        environment: "{{ source_environment }}"
    
    - name: Create promotion snapshot
      ansible.builtin.include_tasks: tasks/create_promotion_snapshot.yml
    
    - name: Deploy to target environment
      ansible.builtin.include_tasks: tasks/deploy_to_target.yml
    
    - name: Validate target environment
      ansible.builtin.include_tasks: tasks/validate_environment.yml
      vars:
        environment: "{{ target_environment }}"
    
    - name: Update environment status
      ansible.builtin.include_tasks: tasks/update_environment_status.yml
```

### Promotion Validation

```yaml
# tasks/validate_promotion.yml
---
- name: Validate promotion readiness
  block:
    - name: Check service health
      ansible.builtin.uri:
        url: "{{ item.url }}"
        method: GET
        status_code: 200
      loop: "{{ services }}"
    
    - name: Check database connectivity
      ansible.builtin.command: "{{ item.check_command }}"
      loop: "{{ databases }}"
      register: db_checks
      failed_when: db_checks.results | selectattr('rc', 'ne', 0) | list | length > 0
    
    - name: Check backup status
      ansible.builtin.include_tasks: tasks/check_backup_status.yml
    
    - name: Check security compliance
      ansible.builtin.include_tasks: tasks/check_security_compliance.yml
```

## Environment Monitoring

### Environment-Specific Monitoring

```yaml
# group_vars/all/monitoring/environment.yml
environment_monitoring:
  enabled: true
  
  # Environment-specific dashboards
  dashboards:
    development:
      - name: "Development Overview"
        description: "Development environment monitoring"
        panels:
          - resource_usage
          - service_status
          - error_logs
    
    staging:
      - name: "Staging Overview"
        description: "Staging environment monitoring"
        panels:
          - resource_usage
          - service_status
          - performance_metrics
          - test_results
    
    production:
      - name: "Production Overview"
        description: "Production environment monitoring"
        panels:
          - resource_usage
          - service_status
          - performance_metrics
          - security_events
          - business_metrics
  
  # Environment-specific alerts
  alerts:
    development:
      - high_error_rate
      - service_down
    
    staging:
      - high_error_rate
      - service_down
      - performance_degradation
      - test_failure
    
    production:
      - high_error_rate
      - service_down
      - performance_degradation
      - security_violation
      - backup_failure
```

### Environment Health Checks

```yaml
# tasks/environment_health_check.yml
---
- name: Environment health check
  block:
    - name: Check system resources
      ansible.builtin.shell: |
        echo "CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1)%"
        echo "Memory: $(free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')"
        echo "Disk: $(df -h / | awk 'NR==2{print $5}')"
      register: system_health
    
    - name: Check service status
      ansible.builtin.service_facts:
    
    - name: Check container health
      community.docker.docker_container_info:
        name: "{{ item }}"
      loop: "{{ containers }}"
      register: container_health
    
    - name: Generate health report
      ansible.builtin.template:
        src: templates/health_report.yml.j2
        dest: "/tmp/health_report_{{ environment }}.yml"
      vars:
        environment: "{{ environment }}"
        system_health: "{{ system_health.stdout_lines }}"
        container_health: "{{ container_health.results }}"
```

## Environment Cleanup

### Cleanup Procedures

```yaml
# playbooks/environment_cleanup.yml
---
- name: Clean up environment
  hosts: "{{ target_hosts }}"
  become: true
  
  vars:
    environment: "{{ target_env | default('development') }}"
    cleanup_level: "{{ level | default('standard') }}"
  
  tasks:
    - name: Standard cleanup
      ansible.builtin.include_tasks: tasks/cleanup/standard.yml
      when: cleanup_level in ['standard', 'full']
    
    - name: Full cleanup
      ansible.builtin.include_tasks: tasks/cleanup/full.yml
      when: cleanup_level == 'full'
    
    - name: Environment reset
      ansible.builtin.include_tasks: tasks/cleanup/reset.yml
      when: cleanup_level == 'reset'
```

### Cleanup Tasks

```yaml
# tasks/cleanup/standard.yml
---
- name: Clean up Docker resources
  block:
    - name: Remove stopped containers
      community.docker.docker_container:
        name: "{{ item }}"
        state: absent
      loop: "{{ stopped_containers }}"
    
    - name: Remove unused images
      community.docker.docker_image:
        name: "{{ item }}"
        state: absent
      loop: "{{ unused_images }}"
    
    - name: Remove unused volumes
      community.docker.docker_volume:
        name: "{{ item }}"
        state: absent
      loop: "{{ unused_volumes }}"

- name: Clean up logs
  block:
    - name: Rotate log files
      ansible.builtin.shell: "logrotate -f /etc/logrotate.conf"
    
    - name: Remove old log files
      ansible.builtin.file:
        path: "{{ item }}"
        state: absent
      loop: "{{ old_log_files }}"

- name: Clean up temporary files
  ansible.builtin.file:
    path: "{{ item }}"
    state: absent
  loop: "{{ temp_directories }}"
```

## Best Practices

### Environment Management Best Practices

1. **Consistent Configuration**
   - Use environment-specific configuration files
   - Maintain configuration templates
   - Version control all configurations

2. **Isolation**
   - Separate networks for each environment
   - Isolate data and storage
   - Use different credentials for each environment

3. **Automation**
   - Automate environment creation
   - Automate deployment procedures
   - Automate cleanup procedures

4. **Monitoring**
   - Monitor each environment separately
   - Set up environment-specific alerts
   - Track environment health metrics

5. **Security**
   - Apply appropriate security measures for each environment
   - Use different security policies
   - Regular security audits

6. **Documentation**
   - Document environment configurations
   - Document deployment procedures
   - Document troubleshooting procedures

### Environment Promotion Best Practices

1. **Validation**
   - Always validate before promotion
   - Run comprehensive tests
   - Check security compliance

2. **Rollback**
   - Maintain rollback procedures
   - Keep environment snapshots
   - Test rollback procedures

3. **Communication**
   - Notify stakeholders of promotions
   - Document promotion decisions
   - Track promotion history

4. **Testing**
   - Test in staging before production
   - Use production-like data in staging
   - Perform load testing

### Environment Cleanup Best Practices

1. **Regular Cleanup**
   - Schedule regular cleanup tasks
   - Monitor resource usage
   - Clean up unused resources

2. **Safe Cleanup**
   - Backup before cleanup
   - Verify cleanup procedures
   - Test cleanup in non-production first

3. **Documentation**
   - Document cleanup procedures
   - Track cleanup history
   - Monitor cleanup effectiveness

## Conclusion

Proper environment management is crucial for maintaining a reliable and scalable infrastructure. This guide provides comprehensive procedures for managing development, staging, and production environments.

Key takeaways:
- Use environment-specific configurations
- Maintain proper isolation between environments
- Automate deployment and cleanup procedures
- Monitor and validate each environment
- Follow security best practices
- Document all procedures and configurations

For additional information, refer to:
- [Production Deployment Guide](PRODUCTION_DEPLOYMENT_GUIDE.md)
- [CI/CD Integration Guide](CI_CD_INTEGRATION.md)
- [Monitoring and Alerting Guide](MONITORING_AND_ALERTING.md)
- [Security Compliance Guide](SECURITY_COMPLIANCE.md) 