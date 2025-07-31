# Service Integration Wizard

The Service Integration Wizard automates the process of adding new services to your Ansible homelab stack. It generates complete Ansible roles with full integration including monitoring, backup, security, and homepage integration.

## Quick Start

### Interactive Mode (Recommended)
```bash
# Run the wizard interactively
./scripts/add_service.sh

# Or run the Python script directly
python3 scripts/service_wizard.py
```

### Non-Interactive Mode
```bash
# Add a service with basic information
./scripts/add_service.sh --service-name jellyfin --repository-url https://github.com/jellyfin/jellyfin

# Or run the Python script directly
python3 scripts/service_wizard.py --service-name jellyfin --repository-url https://github.com/jellyfin/jellyfin
```

## What the Wizard Does

The service wizard automatically:

1. **Collects Service Information**
   - Service name and display name
   - Repository URL and description
   - Category and deployment stage
   - Ports, environment variables, volumes

2. **Generates Complete Role Structure**
   ```
   roles/{service_name}/
   ├── defaults/main.yml          # Default variables
   ├── tasks/
   │   ├── main.yml              # Main task orchestration
   │   ├── deploy.yml            # Deployment tasks
   │   ├── monitoring.yml        # Monitoring configuration
   │   ├── security.yml          # Security hardening
   │   ├── backup.yml            # Backup configuration
   │   ├── homepage.yml          # Homepage integration
   │   ├── alerts.yml            # Alerting rules
   │   ├── validate.yml          # Configuration validation
   │   └── validate_deployment.yml # Deployment validation
   ├── templates/
   │   ├── docker-compose.yml.j2 # Docker Compose template
   │   ├── monitoring.yml.j2     # Prometheus configuration
   │   ├── security.yml.j2       # Security rules
   │   ├── backup.sh.j2          # Backup script
   │   ├── homepage-service.yml.j2 # Homepage service config
   │   └── alerts.yml.j2         # Alerting rules
   ├── handlers/main.yml         # Service handlers
   └── README.md                 # Role documentation
   ```

3. **Updates Main Configuration**
   - Adds service to `group_vars/all/roles.yml`
   - Updates `site.yml` with the new role
   - Configures proper deployment stage

4. **Validates Integration**
   - Checks for port conflicts
   - Validates role structure
   - Ensures proper integration

## Service Categories

The wizard supports these categories:

- **media**: Media streaming and management (Plex, Jellyfin, Sonarr, Radarr)
- **automation**: Automation and orchestration (Home Assistant, Node-RED, n8n)
- **utilities**: Utility and helper services (Homepage, Grafana, Portainer)
- **security**: Security and authentication (Authentik, Fail2ban, WireGuard)
- **databases**: Database services (PostgreSQL, Redis, MariaDB)
- **storage**: Storage and file management (Nextcloud, Syncthing)
- **monitoring**: Monitoring and observability (Prometheus, Grafana, Loki)

## Deployment Stages

- **stage1**: Infrastructure (security, core services) - Deploys FIRST
- **stage2**: Core Services (databases, storage, logging) - Depends on infrastructure
- **stage3**: Applications (media, automation, utilities) - Depends on core services
- **stage3.5**: Dashboard and Management (homepage) - Depends on applications

## Generated Features

### Docker Compose Integration
- Automatic Traefik integration with SSL/TLS
- Health checks and monitoring
- Resource limits and security options
- Volume management and environment variables

### Monitoring Integration
- Prometheus metrics scraping
- Grafana dashboard templates
- Health check endpoints
- Performance monitoring

### Security Features
- Security hardening rules
- Access control configuration
- Fail2ban integration
- Firewall rules

### Backup & Recovery
- Automated backup scripts
- Configurable retention policies
- Data and configuration backup
- Recovery procedures

### Homepage Integration
- Service registration
- Status monitoring
- Quick access links
- Service grouping

### Alerting
- Prometheus alerting rules
- Alertmanager integration
- Configurable severity levels
- Notification channels

## Usage Examples

### Adding a Media Service
```bash
./scripts/add_service.sh
# Service Name: jellyfin
# Repository URL: https://github.com/jellyfin/jellyfin
# Display Name: Jellyfin
# Description: Media streaming server
# Category: media
# Stage: stage3
```

### Adding a Database Service
```bash
./scripts/add_service.sh
# Service Name: postgres
# Repository URL: https://github.com/docker-library/postgres
# Display Name: PostgreSQL
# Description: Relational database
# Category: databases
# Stage: stage2
```

### Adding a Security Service
```bash
./scripts/add_service.sh
# Service Name: authentik
# Repository URL: https://github.com/goauthentik/server
# Display Name: Authentik
# Description: Identity provider
# Category: security
# Stage: stage1
```

## Post-Integration Steps

After running the wizard:

1. **Review Configuration**
   ```bash
   nano roles/{service_name}/defaults/main.yml
   nano roles/{service_name}/templates/docker-compose.yml.j2
   ```

2. **Customize Settings**
   ```bash
   nano group_vars/all/roles.yml
   nano site.yml
   ```

3. **Deploy the Service**
   ```bash
   # Validate first
   ansible-playbook site.yml --tags {service_name} --check
   
   # Deploy
   ansible-playbook site.yml --tags {service_name}
   ```

4. **Access Your Service**
   - URL: `https://{service_name}.yourdomain.com`
   - Homepage: Check your homepage dashboard
   - Monitoring: Check Grafana dashboards

## Troubleshooting

### Common Issues

1. **Port Conflicts**
   - The wizard will warn about port conflicts
   - Change the port in `roles/{service_name}/defaults/main.yml`

2. **Missing Dependencies**
   - Ensure all required services are enabled
   - Check the dependencies list in the generated role

3. **Configuration Errors**
   - Review the generated templates
   - Check Ansible syntax: `ansible-playbook site.yml --syntax-check`

### Validation Commands

```bash
# Check role syntax
ansible-playbook site.yml --tags {service_name} --syntax-check

# Validate configuration
ansible-playbook site.yml --tags {service_name} --check

# Test deployment
ansible-playbook site.yml --tags {service_name} --limit localhost
```

## Advanced Usage

### Custom Repository Analysis
The wizard attempts to analyze GitHub repositories to extract:
- Docker Compose configurations
- Port mappings
- Environment variables
- Volume mounts
- Dependencies

### Manual Configuration
If repository analysis fails, you can manually configure:
- Port assignments
- Environment variables
- Volume mappings
- Dependencies

### Integration with Existing Services
The wizard automatically:
- Checks for conflicts with existing services
- Integrates with existing monitoring
- Configures proper networking
- Sets up backup integration

## Tips

1. **Use Descriptive Names**: Choose service names that are clear and memorable
2. **Check Port Conflicts**: Review existing port assignments before adding services
3. **Test Incrementally**: Deploy services one at a time to isolate issues
4. **Monitor Resources**: Keep track of resource usage as you add services
5. **Backup Regularly**: Use the generated backup scripts to protect your data

## Support

For issues or questions:
1. Check the generated README.md in the role directory
2. Review the Ansible playbook logs
3. Check the service documentation
4. Validate the configuration files

The wizard generates comprehensive documentation for each service, making it easy to understand and maintain your homelab stack. 