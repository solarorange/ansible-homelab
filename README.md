# Ansible Homelab - Role-Based Infrastructure

A production-ready Ansible playbook for deploying and managing a comprehensive homelab environment with monitoring, automation, security, media, and storage services using a modern role-based architecture.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Role Structure](#role-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Validation and Testing](#validation-and-testing)
- [Rollback Procedures](#rollback-procedures)
- [Troubleshooting](#troubleshooting)
- [Migration Guide](#migration-guide)
- [Contributing](#contributing)

## Overview

This Ansible homelab project provides a complete infrastructure-as-code solution for deploying and managing a production-ready homelab environment. The project uses a modern role-based architecture that provides:

- **Modular Design**: Each service category is organized into focused roles
- **Dependency Management**: Clear execution order and role dependencies
- **Centralized Configuration**: Master configuration file for all role variables
- **Comprehensive Validation**: Built-in testing and validation procedures
- **Rollback Capabilities**: Role-level and system-wide rollback procedures
- **Documentation**: Complete documentation for each role and component

## Architecture

### Role-Based Structure

```
ansible_homelab/
├── site.yml                    # Main playbook using roles
├── validation.yml              # Comprehensive validation playbook
├── rollback.yml                # Rollback procedures
├── roles/                      # All service roles
│   ├── security/               # Security infrastructure
│   ├── databases/              # Database services
│   ├── storage/                # Storage infrastructure
│   ├── logging/                # Centralized logging
│   ├── certificate_management/ # SSL/TLS certificates
│   ├── media/                  # Media stack
│   ├── automation/             # Automation services
│   ├── utilities/              # Utility services
│   ├── paperless_ngx/          # Document management
│   └── fing/                   # Network monitoring
├── group_vars/                 # Centralized variables
│   └── all/
│       ├── roles.yml           # Master role configuration
│       ├── vars.yml            # System-wide variables
│       ├── common.yml          # Common settings
│       └── proxmox.yml         # Proxmox-specific settings
├── inventory/                  # Host definitions
├── tasks/                      # Post-deployment tasks
├── docs/                       # Comprehensive documentation
└── scripts/                    # Utility scripts
```

### Role Dependencies

```yaml
# Infrastructure (no dependencies)
security: []
databases: []
storage: []

# Monitoring (depends on infrastructure)
logging: [security, databases]
certificate_management: [security]

# Services (depend on infrastructure and monitoring)
media: [databases, storage, security]
automation: [databases, security]
utilities: [databases, security]
paperless_ngx: [databases, storage, security]
fing: [security]
```

## Prerequisites

### Required Software
- Ansible 2.9 or higher
- Python 3.8 or higher
- Docker Engine 20.10 or higher
- Docker Compose 2.0 or higher
- Git 2.25 or higher
- SSH client and server
- OpenSSL 1.1.1 or higher

### Required Accounts and Services
- Domain name with DNS control
- Cloudflare account (for DNS management)
- SMTP server for notifications (optional)
- Backup storage solution

### System Requirements

#### Minimum Requirements (Single Server)
- CPU: 4 cores (2.0 GHz or higher)
- RAM: 8GB DDR4
- Storage: 100GB SSD (NVMe preferred)
- Network: 1Gbps Ethernet
- OS: Ubuntu 20.04 LTS or Debian 11

#### Recommended Requirements (Multi-Server)
- Core Server: 4 cores, 8GB RAM, 100GB NVMe SSD
- Monitoring Server: 2 cores, 4GB RAM, 50GB NVMe SSD
- Storage Server: 2 cores, 4GB RAM, 500GB+ storage
- Security Server: 2 cores, 4GB RAM, 50GB NVMe SSD

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/solarorange/ansible_homelab.git
   cd ansible_homelab
   ```

2. **Run the setup script**:
   ```bash
   ./scripts/setup.sh
   ```

3. **Configure your environment**:
   ```bash
   # Edit master configuration
   nano group_vars/all/roles.yml
   
   # Edit system variables
   nano group_vars/all/vars.yml
   
   # Update inventory
   nano inventory.yml
   ```

4. **Deploy the infrastructure**:
   ```bash
   # Deploy all services
   ansible-playbook site.yml
   
   # Deploy specific roles
   ansible-playbook site.yml --tags security,databases
   
   # Validate deployment
   ansible-playbook validation.yml
   ```

## Role Structure

### Core Infrastructure Roles

#### Security Role (`roles/security/`)
- **Authentication**: Authentik for SSO
- **Reverse Proxy**: Traefik with automatic SSL
- **DNS**: Pi-hole for ad blocking and DNS
- **Firewall**: UFW configuration
- **VPN**: WireGuard setup
- **Security Monitoring**: CrowdSec, Fail2ban

#### Databases Role (`roles/databases/`)
- **Cache**: Redis for session and cache storage
- **Relational**: PostgreSQL and MariaDB
- **Search**: Elasticsearch and Kibana
- **Monitoring**: Database health checks and backup

#### Storage Role (`roles/storage/`)
- **File Systems**: Samba for network shares
- **Sync Services**: Syncthing for file synchronization
- **Cloud Storage**: Nextcloud for personal cloud
- **Backup**: Automated backup procedures

### Monitoring and Logging Roles

#### Logging Role (`roles/logging/`)
- **Log Aggregation**: Loki for centralized logging
- **Log Collection**: Promtail for log shipping
- **Metrics**: Prometheus for time-series data
- **Alerting**: Alertmanager for notifications
- **System Metrics**: Telegraf and InfluxDB

#### Certificate Management Role (`roles/certificate_management/`)
- **SSL/TLS**: Automated certificate renewal
- **mTLS**: Mutual TLS certificate generation
- **Monitoring**: Certificate expiration alerts

### Service Roles

#### Media Role (`roles/media/`)
- **ARR Services**: Sonarr, Radarr, Prowlarr, Bazarr, Lidarr, Readarr
- **Downloaders**: qBittorrent, SABnzbd
- **Media Players**: Plex, Jellyfin, Emby
- **Media Management**: Tautulli, Overseerr
- **Media Processing**: Tdarr

#### Automation Role (`roles/automation/`)
- **Container Management**: Portainer, Watchtower
- **Home Automation**: Home Assistant, Node-RED
- **Scheduling**: Cron job management
- **MQTT**: Mosquitto broker

#### Utilities Role (`roles/utilities/`)
- **Dashboards**: Homepage, Grafana
- **Media Processing**: Tdarr
- **System Utilities**: Various helper services

### Specialized Roles

#### Paperless-ngx Role (`roles/paperless_ngx/`)
- Document management and OCR
- Automated document processing
- Search and organization

#### Fing Role (`roles/fing/`)
- Network device discovery
- Network monitoring
- Device tracking

## Configuration

### Master Configuration (`group_vars/all/roles.yml`)

The master configuration file centralizes all role variables:

```yaml
# Role enablement
security_enabled: true
databases_enabled: true
storage_enabled: true
media_enabled: true
automation_enabled: true
utilities_enabled: true

# Role-specific configuration
security_authentication_enabled: true
security_proxy_enabled: true
databases_cache_enabled: true
media_arr_services_enabled: true
```

### System Variables (`group_vars/all/vars.yml`)

System-wide configuration variables:

```yaml
# Basic system configuration
username: "your_username"
domain: "your-domain.com"
timezone: "UTC"

# Directory structure
docker_dir: "/home/{{ username }}/docker"
data_dir: "/home/{{ username }}/data"
config_dir: "/home/{{ username }}/config"
backup_dir: "/home/{{ username }}/backups"
```

## Deployment

### Full Deployment
```bash
# Deploy all services
ansible-playbook site.yml
```

### Selective Deployment
```bash
# Deploy infrastructure only
ansible-playbook site.yml --tags infrastructure

# Deploy specific roles
ansible-playbook site.yml --tags security,databases

# Deploy services only
ansible-playbook site.yml --tags services

# Skip specific roles
ansible-playbook site.yml --skip-tags paperless,fing
```

### Pre-Deployment Validation
```bash
# Check mode (dry run)
ansible-playbook site.yml --check --diff

# Validate specific roles
ansible-playbook site.yml --tags security --check
```

## Validation and Testing

### Comprehensive Validation
```bash
# Run full validation
ansible-playbook validation.yml

# Validate specific components
ansible-playbook validation.yml --tags security,databases
```

### Service Health Checks
```bash
# Check service status
ansible-playbook validation.yml --tags validation

# Generate health report
ansible-playbook validation.yml --tags report
```

## Rollback Procedures

### Role-Level Rollback
```bash
# Rollback specific role
ansible-playbook rollback.yml --tags security -e "rollback_confirm=true"

# Rollback all services
ansible-playbook rollback.yml --tags services -e "rollback_confirm=true"
```

### Full System Rollback
```bash
# Rollback entire system
ansible-playbook rollback.yml -e "rollback_confirm=true"
```

## Troubleshooting

### Common Issues

1. **Role Dependencies**: Ensure roles are deployed in the correct order
2. **Configuration Errors**: Check variable syntax in `group_vars/all/roles.yml`
3. **Service Failures**: Use validation playbook to identify issues
4. **Network Issues**: Verify DNS and firewall configuration

### Debug Commands
```bash
# Verbose output
ansible-playbook site.yml -vvv

# Check specific role
ansible-playbook site.yml --tags security --check --diff

# Validate configuration
ansible-playbook validation.yml --tags validation
```

### Logs and Reports
- Service logs: `/home/{{ username }}/logs/`
- Validation reports: `/home/{{ username }}/logs/validation_report_*.txt`
- Rollback reports: `/home/{{ username }}/logs/rollback_report_*.txt`

## Migration Guide

If you're migrating from the old task-based structure, see the comprehensive migration guide:

- [Role Migration Summary](docs/ROLE_MIGRATION_SUMMARY.md)
- [Migration Best Practices](docs/MIGRATION_BEST_PRACTICES.md)

### Migration Scripts
```bash
# Clean up obsolete task files
./scripts/cleanup_obsolete_tasks.sh

# Dry run first
./scripts/cleanup_obsolete_tasks.sh true
```

## Contributing

### Development Guidelines
1. Follow the role-based architecture
2. Use centralized configuration
3. Implement proper validation
4. Add comprehensive documentation
5. Test thoroughly before submitting

### Adding New Roles
1. Create role structure in `roles/`
2. Add role configuration to `group_vars/all/roles.yml`
3. Update dependencies in `site.yml`
4. Add validation tasks
5. Update documentation

### Testing
```bash
# Test new role
ansible-playbook site.yml --tags your_new_role --check

# Validate role
ansible-playbook validation.yml --tags your_new_role
```

## Support

- **Documentation**: See `docs/` directory for detailed guides
- **Issues**: Report bugs and feature requests via GitHub issues
- **Discussions**: Use GitHub discussions for questions and help

## License

This project is licensed under the MIT License - see the LICENSE file for details. 