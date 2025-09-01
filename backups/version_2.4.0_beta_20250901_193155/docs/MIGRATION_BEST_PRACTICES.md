# Migration Best Practices

## Overview

This document provides best practices for migrating from the task-based architecture to the new role-based architecture. Following these guidelines will ensure a smooth transition and maintain system stability.

## Pre-Migration Checklist

### 1. System Backup
- [ ] Create full system backup
- [ ] Backup all configuration files
- [ ] Document current service states
- [ ] Test backup restoration procedure

### 2. Environment Preparation
- [ ] Update Ansible to latest stable version
- [ ] Install required collections and roles
- [ ] Verify SSH connectivity to all hosts
- [ ] Check available disk space

### 3. Configuration Review
- [ ] Review current task files for custom modifications
- [ ] Document any custom configurations
- [ ] Identify service dependencies
- [ ] Plan role enablement strategy

## Migration Strategy

### Phase 1: Infrastructure Preparation
1. **Deploy core infrastructure roles first**
   ```bash
   ansible-playbook site.yml --tags infrastructure
   ```

2. **Validate infrastructure deployment**
   ```bash
   ansible-playbook validation.yml --tags infrastructure
   ```

3. **Test rollback procedures**
   ```bash
   ansible-playbook rollback.yml --tags security --check
   ```

### Phase 2: Service Migration
1. **Migrate monitoring and logging**
   ```bash
   ansible-playbook site.yml --tags monitoring
   ```

2. **Migrate service roles**
   ```bash
   ansible-playbook site.yml --tags services
   ```

3. **Validate all services**
   ```bash
   ansible-playbook validation.yml
   ```

### Phase 3: Cleanup and Optimization
1. **Remove obsolete task files**
   ```bash
   ./scripts/cleanup_obsolete_tasks.sh
   ```

2. **Optimize configuration**
   ```bash
   ansible-playbook site.yml --tags optimization
   ```

3. **Final validation**
   ```bash
   ansible-playbook validation.yml --tags report
   ```

## Configuration Management

### Master Configuration (`group_vars/all/roles.yml`)

#### Best Practices
1. **Use descriptive variable names**
   ```yaml
   # Good
   security_authentication_enabled: true
   media_arr_services_enabled: true
   
   # Avoid
   auth_enabled: true
   arr_enabled: true
   ```

2. **Group related variables**
   ```yaml
   # Security configuration
   security_authentication_enabled: true
   security_proxy_enabled: true
   security_dns_enabled: true
   
   # Media configuration
   media_arr_services_enabled: true
   media_downloaders_enabled: true
   media_players_enabled: true
   ```

3. **Use consistent naming conventions**
   ```yaml
   # Role enablement flags
   {role_name}_enabled: true
   
   # Component enablement flags
   {role_name}_{component}_enabled: true
   
   # Service-specific flags
   {service_name}_enabled: true
   ```

### Role-Specific Configuration

#### Default Values (`roles/{role}/defaults/main.yml`)
```yaml
# Set sensible defaults
service_port: 8080
service_version: "latest"
service_restart_policy: "unless-stopped"

# Use conditional defaults
service_enabled: "{{ service_enabled | default(true) }}"
service_backup_enabled: "{{ service_backup_enabled | default(true) }}"
```

#### Role Variables (`roles/{role}/vars/main.yml`)
```yaml
# Role-specific variables that shouldn't be overridden
role_name: "my_service"
required_collections:
  - community.docker
  - ansible.posix
```

## Testing and Validation

### Pre-Deployment Testing
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

### Continuous Validation
```bash
# Create validation script
cat > validate_deployment.sh << 'EOF'
#!/bin/bash
echo "Running deployment validation..."
ansible-playbook validation.yml --tags validation
if [ $? -eq 0 ]; then
    echo "Validation successful"
else
    echo "Validation failed"
    exit 1
fi
EOF

chmod +x validate_deployment.sh
```

## Rollback Procedures

### Role-Level Rollback
```bash
# Rollback specific role
ansible-playbook rollback.yml --tags security -e "rollback_confirm=true"

# Rollback multiple roles
ansible-playbook rollback.yml --tags security,databases -e "rollback_confirm=true"
```

### Emergency Rollback
```bash
# Full system rollback
ansible-playbook rollback.yml -e "rollback_confirm=true"

# Manual rollback (if playbook fails)
docker stop $(docker ps -q)
docker start $(docker ps -aq)
```

## Performance Optimization

### Parallel Execution
```yaml
# In site.yml, group independent roles
roles:
  - name: security
    tags: [security, infrastructure]
  
  - name: databases
    tags: [databases, infrastructure]
  
  # These can run in parallel
  - name: media
    tags: [media, services]
  - name: automation
    tags: [automation, services]
```

### Resource Management
```yaml
# Limit concurrent operations
ansible_ssh_pipelining: true
ansible_ssh_args: '-o ControlMaster=auto -o ControlPersist=60s'

# Use forks for parallel execution
ansible_forks: 10
```

## Monitoring and Alerting

### Health Checks
```yaml
# Add health checks to roles
- name: Health check service
  ansible.builtin.uri:
    url: "http://localhost:{{ service_port }}/health"
    method: GET
    status_code: [200]
  register: health_check
  retries: 3
  delay: 10
```

### Logging
```yaml
# Configure logging for roles
- name: Configure service logging
  ansible.builtin.template:
    src: logging.conf.j2
    dest: "/etc/{{ service_name }}/logging.conf"
    mode: '0644'
  notify: restart service
```

## Troubleshooting

### Common Issues

#### 1. Role Dependencies
**Problem**: Services fail due to missing dependencies
**Solution**: Ensure proper role execution order
```yaml
# Check dependencies in site.yml
roles:
  - name: databases  # Must run first
  - name: media      # Depends on databases
```

#### 2. Variable Conflicts
**Problem**: Variables override each other
**Solution**: Use namespaced variables
```yaml
# Use role-specific namespaces
security_traefik_enabled: true
media_plex_enabled: true
```

#### 3. Service Failures
**Problem**: Services don't start after migration
**Solution**: Check configuration and dependencies
```bash
# Validate service configuration
ansible-playbook validation.yml --tags validation

# Check service logs
docker logs service_name
```

### Debug Commands
```bash
# Verbose output
ansible-playbook site.yml -vvv

# Check specific task
ansible-playbook site.yml --tags security --check --diff

# Validate inventory
ansible-inventory --list

# Test connectivity
ansible all -m ping
```

## Maintenance

### Regular Tasks
1. **Update roles and collections**
   ```bash
   ansible-galaxy collection install --upgrade community.docker
   ansible-galaxy role install --force username.role_name
   ```

2. **Review and update configuration**
   ```bash
   # Review master configuration
   nano group_vars/all/roles.yml
   
   # Update system variables
   nano group_vars/all/vars.yml
   ```

3. **Run validation**
   ```bash
   ansible-playbook validation.yml
   ```

### Backup Strategy
```bash
# Create configuration backup
tar -czf config_backup_$(date +%Y%m%d).tar.gz group_vars/ roles/

# Create data backup
ansible-playbook backup.yml

# Test backup restoration
ansible-playbook rollback.yml --tags test --check
```

## Documentation

### Role Documentation
Each role should include:
- `README.md` - Role description and usage
- `defaults/main.yml` - Default variables
- `vars/main.yml` - Role-specific variables
- `tasks/main.yml` - Main tasks
- `handlers/main.yml` - Handlers
- `templates/` - Configuration templates
- `files/` - Static files

### Example Role Structure
```
roles/my_service/
├── README.md
├── defaults/
│   └── main.yml
├── vars/
│   └── main.yml
├── tasks/
│   ├── main.yml
│   ├── deploy.yml
│   ├── configure.yml
│   └── validate.yml
├── handlers/
│   └── main.yml
├── templates/
│   └── config.yml.j2
└── files/
    └── static_file.conf
```

## Conclusion

Following these best practices will ensure a successful migration to the role-based architecture. The key points are:

1. **Plan thoroughly** - Understand dependencies and requirements
2. **Test extensively** - Use check mode and validation
3. **Backup everything** - Have rollback procedures ready
4. **Document changes** - Keep track of modifications
5. **Monitor closely** - Watch for issues during migration
6. **Validate results** - Ensure everything works as expected

The role-based architecture provides better organization, reusability, and maintainability. With proper planning and execution, the migration will result in a more robust and manageable infrastructure. 