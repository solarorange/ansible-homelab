# Ansible Quick Reference Card

## 🚀 Essential Commands

### Basic Operations
```bash
# Test connectivity
ansible all -m ping

# Gather system facts
ansible all -m setup

# Run command on all hosts
ansible all -m shell -a "uptime"

# Run with privilege escalation
ansible all -m shell -a "whoami" --become
```

### Playbook Operations
```bash
# Run playbook
ansible-playbook playbook.yml

# Run with extra variables
ansible-playbook playbook.yml -e "version=2.0.0"

# Run in check mode (dry run)
ansible-playbook playbook.yml --check

# Run with verbose output
ansible-playbook playbook.yml -v

# Run specific tags
ansible-playbook playbook.yml --tags "deploy,config"

# Skip specific tags
ansible-playbook playbook.yml --skip-tags "backup"
```

### Inventory Management
```bash
# List all hosts
ansible all --list-hosts

# List hosts in group
ansible webservers --list-hosts

# Run on specific host
ansible hostname -m ping

# Run on specific group
ansible webservers -m ping
```

## 🔧 Docker Operations

### Container Management
```yaml
# Deploy container
- name: Deploy nginx container
  community.docker.docker_container:
    name: nginx
    image: nginx:latest
    state: started
    ports:
      - "80:80"
    restart_policy: unless-stopped

# Stop container
- name: Stop container
  community.docker.docker_container:
    name: nginx
    state: stopped

# Remove container
- name: Remove container
  community.docker.docker_container:
    name: nginx
    state: absent
```

### Docker Compose
```yaml
# Deploy stack
- name: Deploy docker stack
  community.docker.docker_compose:
    project_src: /path/to/compose
    state: present

# Update stack
- name: Update stack
  community.docker.docker_compose:
    project_src: /path/to/compose
    state: present
    pull: yes
```

## 🗄️ Database Operations

### MySQL
```yaml
# Create database
- name: Create MySQL database
  community.mysql.mysql_db:
    name: myapp
    state: present

# Create user
- name: Create MySQL user
  community.mysql.mysql_user:
    name: myuser
    password: "{{ mysql_password }}"
    priv: 'myapp.*:ALL'
    state: present

# Backup database
- name: Backup MySQL database
  community.mysql.mysql_db:
    name: myapp
    state: dump
    target: /backups/myapp.sql
```

### PostgreSQL
```yaml
# Create database
- name: Create PostgreSQL database
  community.postgresql.postgresql_db:
    name: myapp
    state: present

# Create user
- name: Create PostgreSQL user
  community.postgresql.postgresql_user:
    name: myuser
    password: "{{ postgres_password }}"
    db: myapp
    priv: ALL
    state: present
```

## 📊 Monitoring Operations

### Prometheus
```yaml
# Deploy Prometheus
- name: Deploy Prometheus
  community.docker.docker_container:
    name: prometheus
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    state: started
```

### Grafana
```yaml
# Deploy Grafana
- name: Deploy Grafana
  community.docker.docker_container:
    name: grafana
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD={{ grafana_password }}
    state: started
```

## 🔐 Security Operations

### SSL/TLS Certificates
```yaml
# Generate self-signed certificate
- name: Generate SSL certificate
  community.crypto.openssl_certificate:
    path: /etc/ssl/certs/example.crt
    privatekey_path: /etc/ssl/private/example.key
    common_name: example.com
    organization: My Organization
    country: US
    state: California
    locality: San Francisco
    days: 365
```

### Password Management
```yaml
# Generate password hash
- name: Generate password hash
  community.crypto.password_hash:
    password: "{{ plaintext_password }}"
    algorithm: sha512_crypt

# Store in vault
- name: Store password in vault
  ansible.builtin.set_fact:
    encrypted_password: "{{ plaintext_password | password_hash('sha512_crypt') }}"
```

## 🌐 Network Operations

### DNS Management
```yaml
# Add DNS record
- name: Add DNS record
  community.dns.dns_record:
    name: "{{ record_name }}"
    value: "{{ record_value }}"
    type: A
    zone: "{{ dns_zone }}"
    provider: cloudflare
    api_token: "{{ cloudflare_token }}"
```

### Firewall Rules
```yaml
# Allow port
- name: Allow HTTP traffic
  ansible.builtin.ufw:
    rule: allow
    port: '80'
    proto: tcp
    state: enabled

# Block IP
- name: Block malicious IP
  ansible.builtin.ufw:
    rule: deny
    from_ip: 192.168.1.100
    state: enabled
```

## 📁 File Operations

### File Management
```yaml
# Copy file
- name: Copy configuration file
  ansible.builtin.copy:
    src: config.yml
    dest: /etc/app/config.yml
    owner: app
    group: app
    mode: '0644'

# Create directory
- name: Create log directory
  ansible.builtin.file:
    path: /var/log/myapp
    state: directory
    owner: app
    group: app
    mode: '0755'

# Template file
- name: Configure application
  ansible.builtin.template:
    src: config.j2
    dest: /etc/app/config.yml
    owner: app
    group: app
    mode: '0644'
```

## 🔄 Service Management

### Systemd Services
```yaml
# Start service
- name: Start application service
  ansible.builtin.systemd:
    name: myapp
    state: started
    enabled: yes
    daemon_reload: yes

# Restart service
- name: Restart service
  ansible.builtin.systemd:
    name: myapp
    state: restarted

# Stop service
- name: Stop service
  ansible.builtin.systemd:
    name: myapp
    state: stopped
```

## 🚨 Error Handling

### Conditional Execution
```yaml
# Run only if condition is met
- name: Update application
  ansible.builtin.shell: update-app.sh
  when: app_needs_update | bool

# Run with retry
- name: Deploy with retry
  ansible.builtin.shell: deploy.sh
  register: deploy_result
  retries: 3
  delay: 10
  until: deploy_result.rc == 0
```

### Error Recovery
```yaml
# Handle errors gracefully
- name: Deploy application
  block:
    - name: Stop old version
      ansible.builtin.systemd:
        name: myapp
        state: stopped
    
    - name: Deploy new version
      ansible.builtin.copy:
        src: app.jar
        dest: /opt/myapp/app.jar
    
    - name: Start new version
      ansible.builtin.systemd:
        name: myapp
        state: started
  
  rescue:
    - name: Rollback to previous version
      ansible.builtin.systemd:
        name: myapp
        state: started
```

## 📝 Useful Variables

### Common Variables
```yaml
# In group_vars/all.yml
app_name: myapp
app_version: "2.0.0"
app_port: 8080
app_user: myapp
app_group: myapp
app_home: /opt/myapp
app_logs: /var/log/myapp

# Database variables
db_host: localhost
db_port: 5432
db_name: myapp
db_user: myapp
db_password: "{{ vault_db_password }}"

# Monitoring variables
prometheus_port: 9090
grafana_port: 3000
alertmanager_port: 9093
```

## 🔍 Debugging Commands

### Verbose Output
```bash
# Different verbosity levels
ansible-playbook playbook.yml -v      # Basic
ansible-playbook playbook.yml -vv     # More detail
ansible-playbook playbook.yml -vvv    # Connection info
ansible-playbook playbook.yml -vvvv   # Debug level
```

### Syntax and Validation
```bash
# Check syntax
ansible-playbook playbook.yml --syntax-check

# List tasks
ansible-playbook playbook.yml --list-tasks

# List hosts
ansible-playbook playbook.yml --list-hosts

# Start at specific task
ansible-playbook playbook.yml --start-at-task "Deploy application"
```

## 🎯 Best Practices

1. **Use handlers** for service restarts
2. **Implement idempotency** in all tasks
3. **Use vault** for sensitive data
4. **Tag tasks** for selective execution
5. **Use conditionals** for environment-specific tasks
6. **Implement proper error handling**
7. **Use templates** for configuration files
8. **Version control** all playbooks
9. **Test in staging** before production
10. **Document variables** and their purposes

## 📚 Quick Tips

- Use `gather_facts: no` to skip fact gathering for faster execution
- Use `serial: 1` for rolling updates
- Use `any_errors_fatal: true` to stop on first error
- Use `max_fail_percentage: 25` to allow some failures
- Use `run_once: true` for tasks that should run only once
- Use `delegate_to: localhost` for local-only tasks
