# Utilities Stack Role

A comprehensive Ansible role for deploying and managing utility infrastructure in a homelab environment. This role provides modular deployment of container management, media processing, and dashboard utilities with full integration to monitoring, security, backup, and homepage systems.

## Overview

The Utilities Stack role deploys and manages:

### Container Management
- **Portainer** - Container management UI

### Media Processing
- **Tdarr** - Distributed media transcoding

### Dashboards
- **Homepage** - Unified dashboard
- **Tautulli** - Plex statistics and monitoring

## Features

- **Modular Design**: Separate deployment of container management, media processing, and dashboards
- **Comprehensive Monitoring**: Integration with Prometheus, Grafana, Loki, and Alertmanager
- **Security Hardening**: Firewall, Fail2ban, access control, and SSL/TLS
- **Automated Backup**: Configurable backup schedules with verification and recovery
- **Homepage Integration**: Automatic dashboard and widget configuration
- **Alerting**: Multi-channel notifications
- **Health Checks**: Automated health monitoring and recovery

## Requirements

- Docker and Docker Compose
- Ansible 2.9+
- Monitoring stack (Prometheus, Grafana, Loki, Alertmanager)
- Homepage role (optional)

## Role Variables

See `defaults/main.yml` for all available variables. Sensitive variables (API keys, passwords) must be set in `group_vars/all/vault.yml`.

## Directory Structure

```
roles/utilities/
├── defaults/
│   └── main.yml
├── handlers/
│   └── main.yml
├── tasks/
│   ├── main.yml
│   ├── validate.yml
│   ├── prerequisites.yml
│   ├── container_management.yml
│   ├── media_processing.yml
│   ├── dashboards.yml
│   ├── monitoring.yml
│   ├── security.yml
│   ├── backup.yml
│   ├── homepage.yml
│   └── validate_deployment.yml
├── container_management/
│   └── tasks/
│       └── main.yml
├── media_processing/
│   └── tasks/
│       └── main.yml
├── dashboards/
│   └── tasks/
│       └── main.yml
├── templates/
│   ├── portainer/
│   ├── tdarr/
│   ├── tautulli/
│   ├── homepage/
│   └── setup_homepage_icons.sh.j2
└── README.md
```

## Usage

### Basic Usage
```yaml
- hosts: utility_servers
  roles:
    - utilities
```

### Tagged Execution
```bash
ansible-playbook site.yml --tags "utilities,container_management"
ansible-playbook site.yml --tags "utilities,media_processing"
ansible-playbook site.yml --tags "utilities,dashboards"
ansible-playbook site.yml --tags "utilities,monitoring"
ansible-playbook site.yml --tags "utilities,security"
ansible-playbook site.yml --tags "utilities,backup"
ansible-playbook site.yml --tags "utilities,homepage"
ansible-playbook site.yml --tags "utilities,validation"
```

## Monitoring Integration

- Prometheus metrics for all utility services
- Grafana dashboards for Portainer, Tdarr, Tautulli
- Loki log aggregation
- Alertmanager notifications

## Backup and Recovery

- Automated scheduled backups for all utility configurations
- Backup verification and retention
- Disaster recovery scripts

## Security Features

- Firewall and access control
- Fail2ban and CrowdSec integration
- SSL/TLS and security headers
- Security monitoring and alerting

## Homepage Integration

- Automatic configuration of homepage dashboard entries and widgets for all utilities
- API key management via vault

## Maintenance

- Health checks and monitoring
- Log rotation and cleanup
- Automated updates and rollback

## Troubleshooting

See the documentation in `docs/` and the troubleshooting section in this README for common issues and solutions. 