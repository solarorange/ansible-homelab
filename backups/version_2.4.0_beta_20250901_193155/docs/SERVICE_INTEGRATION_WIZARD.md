# Service Integration Wizard

The Ansible Homelab Service Integration Wizard automates the process of adding new services to your homelab stack. It generates all necessary files, configurations, and integrations following the established patterns in your codebase.

## Overview

The wizard creates a complete Ansible role for any service by:
1. Analyzing the service's repository for configuration details
2. Generating a complete role structure with all required files
3. Integrating with Traefik, monitoring, backup, security, and homepage
4. Updating main configuration files
5. Validating the integration

## Quick Start

### Interactive Mode
```bash
# From your ansible_homelab project root
./scripts/add_service.sh
```

### Non-Interactive Mode
```bash
# Direct Python execution
python3 scripts/service_wizard.py --service-name "myapp" --repository-url "https://github.com/user/myapp"
```

## Features

### 🚀 Automated Role Generation
- Creates complete role structure following your established patterns
- Generates all required task files (deploy, monitoring, security, backup, etc.)
- Creates Docker Compose templates with Traefik integration
- Generates variable files with sensible defaults

### 🔗 Full Stack Integration
- **Traefik Integration**: Automatic SSL/TLS, routing, and middleware
- **Monitoring**: Prometheus metrics, Grafana dashboards, health checks
- **Security**: Hardening, access controls, fail2ban integration
- **Backup**: Automated backup scripts with retention policies
- **Homepage**: Service registration and status monitoring
- **Alerting**: Prometheus alert rules and notification integration

### 🛡️ Validation & Safety
- Port conflict detection
- Variable validation
- Template syntax checking
- Integration testing
- Rollback capabilities

### 📁 Generated Structure
```
roles/{service_name}/
├── README.md                 # Comprehensive documentation
├── defaults/
│   └── main.yml             # All configurable variables
├── tasks/
│   ├── main.yml             # Main orchestration
│   ├── deploy.yml           # Deployment tasks
│   ├── monitoring.yml       # Monitoring integration
│   ├── security.yml         # Security hardening
│   ├── backup.yml           # Backup configuration
│   ├── homepage.yml         # Homepage integration
│   ├── alerts.yml           # Alerting rules
│   ├── validate.yml         # Pre-deployment validation
│   └── validate_deployment.yml # Post-deployment validation
├── templates/
│   ├── docker-compose.yml.j2 # Docker Compose with Traefik
│   ├── monitoring.yml.j2     # Prometheus configuration
│   ├── security.yml.j2       # Security rules
│   ├── backup.sh.j2          # Backup script
│   ├── homepage-service.yml.j2 # Homepage service config
│   └── alerts.yml.j2         # Alert rules
└── handlers/
    └── main.yml             # Service handlers
```

## Usage Examples

### Example 1: Adding a Media Service (Jellyfin)
```bash
$ ./scripts/add_service.sh

📋 SERVICE INFORMATION
----------------------------------------
Service Name (lowercase, no spaces): jellyfin
  ✓ Examples: jellyfin, postgres, homepage, portainer
  ✓ Your service will be accessible at: jellyfin.yourdomain.com
Repository URL: https://github.com/jellyfin/jellyfin
  ✓ Examples: https://github.com/jellyfin/jellyfin
Display Name (for homepage): Jellyfin Media Server
Description: Modern media solution for the modern web

📂 SERVICE CATEGORY
----------------------------------------
Select the category that best describes your service:
  1. media
     Media streaming and management (Plex, Jellyfin, Sonarr, Radarr, Tautulli)
  2. automation
     Automation and orchestration (Home Assistant, Node-RED, n8n, Portainer)
  3. utilities
     Utility and helper services (Homepage, Grafana, Uptime Kuma, Portainer)
  4. security
     Security and authentication (Authentik, Fail2ban, CrowdSec, WireGuard)
  5. databases
     Database services (PostgreSQL, Redis, MariaDB, Elasticsearch)
  6. storage
     Storage and file management (Nextcloud, Syncthing, Samba, rclone)
  7. monitoring
     Monitoring and observability (Prometheus, Grafana, Loki, Alertmanager)

Select category (1-7): 1
  ✓ Selected: media - Media streaming and management (Plex, Jellyfin, Sonarr, Radarr, Tautulli)

🚀 DEPLOYMENT STAGE
----------------------------------------
Select when this service should be deployed:
  stage1: Infrastructure (security, core services) - Deploys FIRST
     Examples: Traefik, Authentik, Pi-hole, WireGuard, Fail2ban
  stage2: Core Services (databases, storage, logging) - Depends on infrastructure
     Examples: PostgreSQL, Redis, MariaDB, Elasticsearch, Loki, Prometheus
  stage3: Applications (media, automation, utilities) - Depends on core services
     Examples: Plex, Jellyfin, Sonarr, Home Assistant, Portainer, Grafana
  stage3.5: Dashboard and Management (homepage) - Depends on applications
     Examples: Homepage, Uptime Kuma, monitoring dashboards

Select stage (default: stage3): 3
  ✓ Selected: stage3 - Applications (media, automation, utilities) - Depends on core services

# The wizard will:
# 1. Analyze the repository
# 2. Generate complete role structure
# 3. Update main configuration
# 4. Validate integration
```

### Example 2: Adding a Database Service
```bash
$ python3 scripts/service_wizard.py --service-name "postgres" --repository-url "https://github.com/docker-library/postgres"
```

## Configuration Options

### Service Categories
1. **media** - Media streaming and management
2. **automation** - Automation and orchestration
3. **utilities** - Utility and helper services
4. **security** - Security and authentication
5. **databases** - Database services
6. **storage** - Storage and file management
7. **monitoring** - Monitoring and observability

### Deployment Stages
- **stage1** - Infrastructure (security, core services)
- **stage2** - Core Services (databases, storage, logging)
- **stage3** - Applications (media, automation, utilities)
- **stage3.5** - Dashboard and Management (homepage)

### Generated Variables
The wizard generates comprehensive variables in `defaults/main.yml`:

```yaml
# Core Configuration
service_enabled: true
service_image: "service:latest"
service_port: 8080
service_domain: "service.yourdomain.com"

# Traefik Integration
service_traefik_enabled: true
service_traefik_middleware: ""

# Monitoring
service_monitoring_enabled: true
service_healthcheck_enabled: true

# Security
service_security_enabled: true
service_read_only: false

# Backup
service_backup_enabled: true
service_backup_retention_days: 30

# Homepage
service_homepage_enabled: true
service_homepage_group: "utilities"

# Resource Limits
service_memory_limit: "512M"
service_cpu_limit: "0.5"
```

## Integration Points

### Traefik Integration
- Automatic SSL/TLS certificate management
- Domain-based routing
- Middleware support
- Health check integration

### Monitoring Integration
- Prometheus metrics scraping
- Grafana dashboard templates
- Health check endpoints
- Alert rule generation

### Security Integration
- Security hardening rules
- Access control policies
- Fail2ban integration
- Firewall rules

### Backup Integration
- Automated backup scripts
- Data and configuration backup
- Retention policies
- Restore procedures

### Homepage Integration
- Service registration
- Status monitoring
- Custom icons and groups
- Widget integration

## Customization

### Post-Generation Customization
After running the wizard, you can customize:

1. **Variables**: Edit `roles/{service}/defaults/main.yml`
2. **Templates**: Modify `roles/{service}/templates/`
3. **Tasks**: Customize `roles/{service}/tasks/`
4. **Configuration**: Update `group_vars/all/roles.yml`

### Advanced Customization
```bash
# Customize the service configuration
nano roles/myapp/defaults/main.yml

# Modify Docker Compose template
nano roles/myapp/templates/docker-compose.yml.j2

# Add custom tasks
nano roles/myapp/tasks/custom.yml

# Update main configuration
nano group_vars/all/roles.yml
```

## Validation and Testing

### Pre-Deployment Validation
```bash
# Validate the generated role
ansible-playbook site.yml --tags myapp --check

# Validate syntax
ansible-playbook site.yml --syntax-check
```

### Deployment Testing
```bash
# Deploy the new service
ansible-playbook site.yml --tags myapp

# Test the service
curl -I https://myapp.yourdomain.com

# Check monitoring
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.labels.job=="myapp")'
```

### Rollback
```bash
# Disable the service
ansible-playbook site.yml --tags myapp -e "myapp_enabled=false"

# Remove the role (manual)
rm -rf roles/myapp
# Update group_vars/all/roles.yml
# Update site.yml
```

## Troubleshooting

### Common Issues

#### Port Conflicts
```
Warning: Port 8080 is already used by existing-service
```
**Solution**: Modify the port in `roles/{service}/defaults/main.yml`

#### Template Errors
```
Error: Missing required files: defaults/main.yml
```
**Solution**: Re-run the wizard or manually create missing files

#### Integration Failures
```
Error: Service integration validation failed
```
**Solution**: Check the validation output and fix issues manually

### Debug Commands
```bash
# Verbose wizard output
python3 scripts/service_wizard.py -v

# Check generated files
find roles/{service} -type f -exec echo "=== {} ===" \; -exec cat {} \;

# Validate Ansible syntax
ansible-playbook site.yml --syntax-check

# Test specific role
ansible-playbook site.yml --tags {service} --check --diff
```

## Best Practices

### Before Running the Wizard
1. **Backup your configuration**
   ```bash
   git add . && git commit -m "Backup before adding new service"
   ```

2. **Check available ports**
   ```bash
   python3 scripts/check_port_conflicts.py
   ```

3. **Review existing services**
   ```bash
   ls roles/ | grep -v "^\.$"
   ```

### After Running the Wizard
1. **Review generated configuration**
   ```bash
   diff roles/{service}/defaults/main.yml roles/grafana/defaults/main.yml
   ```

2. **Test in staging**
   ```bash
   ansible-playbook site.yml --tags {service} --check
   ```

3. **Validate integration**
   ```bash
   ansible-playbook site.yml --tags validation
   ```

### Maintenance
1. **Keep services updated**
   ```bash
   # Update service image
   sed -i 's/image: ".*"/image: "new-image:latest"/' roles/{service}/defaults/main.yml
   ```

2. **Monitor resource usage**
   ```bash
   # Check service resources
   docker stats {service}
   ```

3. **Review logs regularly**
   ```bash
   # Check service logs
   docker logs {service}
   ```

## Contributing

### Extending the Wizard
The wizard is designed to be extensible:

1. **Add new categories**: Modify the `categories` list in `service_wizard.py`
2. **Add new templates**: Create new template files in the `_generate_templates` method
3. **Add new validations**: Extend the `validate_integration` method
4. **Add new integrations**: Modify the configuration update methods

### Template Customization
Templates use Jinja2 syntax and follow established patterns:

```jinja2
# Example template variable
{{ service_name }}_enabled: true

# Example conditional
{% if service_traefik_enabled | default(true) %}
labels:
  - "traefik.enable=true"
{% endif %}

# Example loops
{% for volume in service_volumes %}
  - {{ volume }}
{% endfor %}
```

## Support

### Getting Help
1. **Check the logs**: `python3 scripts/service_wizard.py -v`
2. **Review documentation**: This file and role READMEs
3. **Validate manually**: Check generated files against existing roles
4. **Test incrementally**: Deploy and test one component at a time

### Reporting Issues
When reporting issues, include:
1. Service name and repository URL
2. Wizard output and error messages
3. Generated files (if any)
4. Expected vs actual behavior
5. System information (OS, Python version, etc.)

---

**Note**: This wizard follows the established patterns in your Ansible homelab stack. Always review generated configurations before deployment in production environments. 