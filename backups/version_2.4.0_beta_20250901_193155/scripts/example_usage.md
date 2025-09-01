# Service Integration Wizard - Example Usage

This document demonstrates how to use the Service Integration Wizard to add a new service to your Ansible homelab stack.

## Example: Adding a Simple Web Application

Let's add a simple web application called "myapp" to demonstrate the wizard in action.

### Step 1: Run the Wizard

```bash
# From your ansible_homelab project root
./scripts/add_service.sh
```

### Step 2: Interactive Input

The wizard will prompt you for information:

```
========================================
  ANSIBLE HOMELAB SERVICE WIZARD
========================================
Starting service integration wizard...

============================================================
ANSIBLE HOMELAB SERVICE INTEGRATION WIZARD
============================================================

Service Name (lowercase, no spaces): myapp
Repository URL: https://github.com/user/myapp
Display Name (for homepage): My Awesome App
Description: A fantastic web application for managing tasks

Available categories:
  1. media
  2. automation
  3. utilities
  4. security
  5. databases
  6. storage
  7. monitoring
Select category (1-7): 3

Available deployment stages:
  stage1: Infrastructure (security, core services)
  stage2: Core Services (databases, storage, logging)
  stage3: Applications (media, automation, utilities)
  stage3.5: Dashboard and Management (homepage)
Select stage (default: stage3): 3

Analyzing repository: https://github.com/user/myapp
```

### Step 3: Generated Output

The wizard will generate the complete role structure:

```
Generating role structure for myapp...
✓ Role structure created: roles/myapp

Updating main configuration for myapp...
✓ Main configuration updated

Validating integration for myapp...
✓ Integration validation passed

============================================================
INTEGRATION SUMMARY
============================================================
Service Name: myapp
Display Name: My Awesome App
Category: utilities
Stage: stage3
Port: 8080
Domain: myapp.yourdomain.com
Repository: https://github.com/user/myapp
============================================================

🎉 Successfully integrated My Awesome App into your homelab stack!

Next steps:
1. Review the generated configuration in roles/myapp/
2. Customize any specific settings in group_vars/all/roles.yml
3. Run: ansible-playbook site.yml --tags myapp
4. Access the service at: https://myapp.yourdomain.com
```

### Step 4: Generated Files

The wizard creates the following structure:

```
roles/myapp/
├── README.md
├── defaults/
│   └── main.yml          # All configurable variables
├── tasks/
│   ├── main.yml          # Main orchestration
│   ├── deploy.yml        # Deployment tasks
│   ├── monitoring.yml    # Monitoring integration
│   ├── security.yml      # Security hardening
│   ├── backup.yml        # Backup configuration
│   ├── homepage.yml      # Homepage integration
│   ├── alerts.yml        # Alerting rules
│   ├── validate.yml      # Pre-deployment validation
│   └── validate_deployment.yml # Post-deployment validation
├── templates/
│   ├── docker-compose.yml.j2    # Docker Compose with Traefik
│   ├── monitoring.yml.j2        # Prometheus configuration
│   ├── security.yml.j2          # Security rules
│   ├── backup.sh.j2             # Backup script
│   ├── homepage-service.yml.j2  # Homepage service config
│   └── alerts.yml.j2            # Alert rules
└── handlers/
    └── main.yml          # Service handlers
```

### Step 5: Review Generated Configuration

#### Defaults (roles/myapp/defaults/main.yml)
```yaml
---
# My Awesome App Role Default Variables

# =============================================================================
# CORE CONFIGURATION
# =============================================================================

# Service enablement
myapp_enabled: true

# Container configuration
myapp_image: "myapp:latest"
myapp_version: "latest"
myapp_container_name: "myapp"
myapp_restart_policy: "unless-stopped"

# Port configuration
myapp_port: 8080
myapp_external_port: "8080"
myapp_internal_port: "8080"

# Domain configuration
myapp_domain: "myapp.{{ domain | default('localhost') }}"

# =============================================================================
# TRAEFIK INTEGRATION
# =============================================================================

myapp_traefik_enabled: true
myapp_traefik_middleware: ""

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================

myapp_monitoring_enabled: true
myapp_healthcheck_enabled: true
myapp_healthcheck_interval: "30s"
myapp_healthcheck_timeout: "10s"
myapp_healthcheck_retries: 3
myapp_healthcheck_start_period: "40s"

# ... (more configuration)
```

#### Docker Compose Template (roles/myapp/templates/docker-compose.yml.j2)
```yaml
version: '3.8'

services:
  myapp:
    image: {{ myapp_image }}
    container_name: {{ myapp_container_name }}
    restart: {{ myapp_restart_policy }}
    
    # Environment variables
    environment:
      {% for key, value in myapp_environment.items() %}
      - {{ key }}={{ value }}
      {% endfor %}
      - TZ: "{{ timezone | default('UTC') }}"
      - PUID: "{{ ansible_user_id | default(1000) }}"
      - PGID: "{{ ansible_user_id | default(1000) }}"
    
    # Volumes
    volumes:
      {% for volume in myapp_volumes %}
      - {{ volume }}
      {% endfor %}
      - "{{ docker_data_root }}/myapp:/data"
      - "{{ docker_config_root }}/myapp:/config"
      - "{{ docker_logs_root }}/myapp:/logs"
    
    # Ports
    ports:
      - "{{ myapp_external_port }}:{{ myapp_internal_port }}"
    
    # Networks
    networks:
      {% for network in myapp_networks %}
      - {{ network }}
      {% endfor %}
    
    # Labels for Traefik
    {% if myapp_traefik_enabled | default(true) %}
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=homelab"
      - "traefik.http.routers.myapp.rule=Host(`{{ myapp_domain }}`)"
      - "traefik.http.routers.myapp.entrypoints=https"
      - "traefik.http.routers.myapp.tls=true"
      - "traefik.http.routers.myapp.tls.certresolver=cloudflare"
      - "traefik.http.services.myapp.loadbalancer.server.port={{ myapp_internal_port }}"
      {% if myapp_traefik_middleware is defined %}
      - "traefik.http.routers.myapp.middlewares={{ myapp_traefik_middleware }}"
      {% endif %}
    {% endif %}
    
    # ... (more configuration)
```

### Step 6: Updated Configuration Files

#### group_vars/all/roles.yml
```yaml
# Added by wizard:
myapp_enabled: true

enabled_services:
  # ... existing services ...
  - myapp
```

#### site.yml
```yaml
  roles:
    # ... existing roles ...
    
    # Stage 3: Applications (depends on core services)
    - name: myapp
      tags: [myapp, utilities, stage3]
      when: myapp_enabled | default(true)
      
    # ... other roles ...
```

### Step 7: Deploy the Service

```bash
# Validate the configuration
ansible-playbook site.yml --tags myapp --check

# Deploy the service
ansible-playbook site.yml --tags myapp

# Test the service
curl -I https://myapp.yourdomain.com
```

### Step 8: Verify Integration

#### Check Homepage Integration
The service should appear in your homepage dashboard at the configured URL.

#### Check Monitoring
```bash
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.labels.job=="myapp")'

# Check Grafana dashboards
# The service should have a monitoring dashboard available
```

#### Check Traefik
```bash
# Check Traefik dashboard
# The service should appear in the Traefik dashboard with SSL certificate
```

## Example: Adding a Database Service

For a more complex example, let's add a PostgreSQL service:

```bash
python3 scripts/service_wizard.py --service-name "postgres" --repository-url "https://github.com/docker-library/postgres"
```

This would generate:
- Database-specific configuration
- Volume mounts for data persistence
- Environment variables for database setup
- Backup scripts for database dumps
- Monitoring for database metrics

## Example: Adding a Media Service

For a media service like Jellyfin:

```bash
./scripts/add_service.sh

Service Name: jellyfin
Repository URL: https://github.com/jellyfin/jellyfin
Display Name: Jellyfin Media Server
Description: Modern media solution for the modern web
Category: 1 (media)
Stage: 3 (applications)
```

This would generate:
- Media-specific configuration
- Hardware acceleration support
- Large volume mounts for media files
- Transcoding configuration
- Media-specific monitoring

## Troubleshooting Examples

### Port Conflict
```
Warning: Port 8080 is already used by grafana
```
**Solution**: The wizard detected a conflict. Edit `roles/myapp/defaults/main.yml` and change the port.

### Template Error
```
Error: Missing required files: defaults/main.yml
```
**Solution**: Re-run the wizard or check file permissions.

### Integration Failure
```
Error: Service integration validation failed
```
**Solution**: Check the validation output and fix any issues manually.

## Best Practices Demonstrated

1. **Backup before running**: `git add . && git commit -m "Backup before adding myapp"`
2. **Review generated files**: Check all templates and configurations
3. **Test incrementally**: Deploy and test one component at a time
4. **Monitor after deployment**: Check logs, metrics, and health status
5. **Document customizations**: Note any manual changes made after generation

This example demonstrates the complete workflow from running the wizard to deploying and verifying a new service in your homelab stack. 