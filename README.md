# Enhanced Ansible Homelab Playbook

A production-ready Ansible playbook for deploying and managing a comprehensive homelab environment with monitoring, automation, security, and media services.

## Table of Contents
- [Prerequisites](#prerequisites)
- [System Requirements](#system-requirements)
- [Quick Start](#quick-start)
- [Installation Guide](#installation-guide)
- [Configuration](#configuration)
- [Deployment Guide](#deployment-guide)
- [Troubleshooting](#troubleshooting)
- [Rollback Procedures](#rollback-procedures)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [Monitoring Setup and Deployment](#monitoring-setup-and-deployment)

## Prerequisites

### Required Software
- Ansible 2.9 or higher
- Python 3.8 or higher
- Docker Engine 20.10 or higher
- Docker Compose 2.0 or higher
- Proxmox VE 7.0 or higher
- Git 2.25 or higher
- SSH client and server
- OpenSSL 1.1.1 or higher

### Required Accounts and Services
- Proxmox VE host with API access
- Cloudflare account (for DNS management)
- Domain name with DNS control
- SMTP server for notifications (optional)
- Backup storage solution

### Required Knowledge
- Linux system administration
- Docker containers and orchestration
- Network configuration and routing
- DNS management and SSL/TLS
- Proxmox VE administration
- Basic Ansible concepts

## System Requirements

### Minimum Requirements (Single VM Deployment)
- CPU: 4 cores (2.0 GHz or higher)
- RAM: 8GB DDR4
- Storage: 100GB SSD (NVMe preferred)
- Network: 1Gbps Ethernet
- OS: Ubuntu 20.04 LTS or Debian 11

### Recommended Requirements (Multi-VM Deployment)
- Core Server:
  - CPU: 4 cores (2.5 GHz or higher)
  - RAM: 8GB DDR4
  - Storage: 100GB NVMe SSD
  - Network: 2.5Gbps Ethernet
  - OS: Ubuntu 22.04 LTS

- Monitoring Server:
  - CPU: 2 cores (2.0 GHz or higher)
  - RAM: 4GB DDR4
  - Storage: 50GB NVMe SSD
  - Network: 1Gbps Ethernet
  - OS: Ubuntu 22.04 LTS

- Automation Server:
  - CPU: 2 cores (2.0 GHz or higher)
  - RAM: 4GB DDR4
  - Storage: 50GB NVMe SSD
  - Network: 1Gbps Ethernet
  - OS: Ubuntu 22.04 LTS

- Security Server:
  - CPU: 2 cores (2.0 GHz or higher)
  - RAM: 4GB DDR4
  - Storage: 50GB NVMe SSD
  - Network: 1Gbps Ethernet
  - OS: Ubuntu 22.04 LTS

### Network Requirements
- Static IP addresses for all servers
- Port forwarding configured on router
- DNS records properly configured
- SSL/TLS certificates available
- Firewall rules configured

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ansible_homelab.git
   cd ansible_homelab
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```
   This will:
   - Install required collections and roles
   - Create necessary directory structure
   - Set up Proxmox vault file
   - Generate SSH keys
   - Create initial configuration files
   - Validate system requirements
   - Configure network settings

3. Review and edit configuration:
   - `inventory/hosts.yml`: Update host information
   - `group_vars/all/proxmox_vault.yml`: Review Proxmox settings
   - `group_vars/all/vars.yml`: Configure your services
   - `group_vars/all/network.yml`: Configure network settings
   - `group_vars/all/security.yml`: Configure security settings

4. Run the playbook:
   ```bash
   ansible-playbook main.yml
   ```

## Configuration

### Proxmox Configuration
The playbook supports two authentication methods:

1. Password Authentication:
   ```yaml
   proxmox_host: "proxmox.local"
   proxmox_user: "root@pam"
   proxmox_password: "your-password"
   ```

2. API Token Authentication (Recommended):
   ```yaml
   proxmox_host: "proxmox.local"
   proxmox_user: "root@pam"
   proxmox_token_id: "your-token-id"
   proxmox_token_secret: "your-token-secret"
   ```

### Resource Management
Configure VM resources in `group_vars/all/proxmox.yml`:

```yaml
resource_limits:
  memory:
    min: 1024  # Minimum memory in MB
    max: 8192  # Maximum memory in MB
  cpu:
    min: 1     # Minimum CPU cores
    max: 8     # Maximum CPU cores
  disk:
    min: 10    # Minimum disk space in GB
    max: 100   # Maximum disk space in GB
  backup:
    enabled: true
    schedule: "0 2 * * *"  # Daily at 2 AM
    retention: 7  # Days to keep backups
```

### Network Configuration
Configure networking in `group_vars/all/network.yml`:

```yaml
network_config:
  bridge: "vmbr0"
  vlan: "optional-vlan-id"
  ip_config: "static"  # or dhcp
  gateway: "192.168.1.1"
  dns_servers:
    - "8.8.8.8"
    - "8.8.4.4"
  firewall:
    enabled: true
    rules:
      - port: 80
        protocol: tcp
        action: allow
      - port: 443
        protocol: tcp
        action: allow
```

### Security Configuration
Configure security settings in `group_vars/all/security.yml`:

```yaml
security_config:
  ssl:
    provider: "letsencrypt"
    email: "your-email@domain.com"
    staging: false
  firewall:
    enabled: true
    default_policy: "drop"
  fail2ban:
    enabled: true
    max_retries: 3
    ban_time: 3600
  wireguard:
    enabled: true
    port: 51820
```

### Certificate Management Configuration
Configure certificate management in `group_vars/all/certificate_management.yml`:

```yaml
certificate_management:
  provider: "letsencrypt"  # or "self-signed"
  staging: false  # Set to true for testing
  email: "your-email@domain.com"
  domains:
    - domain: "your-domain.com"
      subdomains:
        - "www"
        - "api"
        - "auth"
    - domain: "another-domain.com"
      subdomains:
        - "app"
  renewal:
    enabled: true
    schedule: "0 0 1 * *"  # Monthly at midnight
    days_before_expiry: 30
  storage:
    type: "file"  # or "vault"
    path: "/etc/ssl/certs"
    backup: true
  validation:
    method: "dns"  # or "http"
    dns_provider: "cloudflare"
    http_port: 80
```

### Logging Configuration
Configure logging in `group_vars/all/logging.yml`:

```yaml
logging:
  aggregation:
    enabled: true
    type: "filebeat"  # or "fluentd"
    hosts:
      - "log-server.your-domain.com:5044"
    ssl:
      enabled: true
      ca_cert: "/etc/ssl/certs/ca.pem"
      client_cert: "/etc/ssl/certs/client.pem"
      client_key: "/etc/ssl/private/client.key"
  
  storage:
    type: "elasticsearch"  # or "loki"
    hosts:
      - "elasticsearch.your-domain.com:9200"
    indices:
      prefix: "logs-"
      retention: "30d"
    backup:
      enabled: true
      schedule: "0 1 * * *"  # Daily at 1 AM
      retention: "90d"
  
  analysis:
    enabled: true
    type: "kibana"  # or "grafana"
    dashboards:
      - name: "system-logs"
        refresh: "5m"
      - name: "application-logs"
        refresh: "1m"
    alerts:
      enabled: true
      channels:
        - type: "email"
          recipients:
            - "admin@your-domain.com"
        - type: "slack"
          webhook: "https://hooks.slack.com/services/xxx"
  
  retention:
    enabled: true
    policies:
      - name: "system-logs"
        pattern: "system-*"
        max_age: "30d"
        max_size: "10GB"
      - name: "application-logs"
        pattern: "app-*"
        max_age: "90d"
        max_size: "50GB"
  
  shipping:
    enabled: true
    batch_size: 2048
    compression: true
    timeout: "30s"
    retry:
      max_attempts: 3
      initial_interval: "1s"
      max_interval: "10s"
```

## Deployment Guide

For detailed deployment instructions, please refer to [DEPLOYMENT.md](DEPLOYMENT.md).

## Troubleshooting

For common issues and solutions, please refer to [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Rollback Procedures

### VM Rollback
1. Stop the VM:
   ```bash
   ansible-playbook main.yml --tags proxmox -e "vm_state=stopped"
   ```

2. Restore from backup:
   ```bash
   ansible-playbook main.yml --tags proxmox -e "vm_restore=true"
   ```

### Service Rollback
1. Restore service configuration:
   ```bash
   ansible-playbook main.yml --tags "{{ service_name }}" -e "restore=true"
   ```

2. Verify service status:
   ```bash
   ansible-playbook main.yml --tags "{{ service_name }}" -e "check_status=true"
   ```

## Architecture

The homelab architecture consists of several key components:

1. Core Infrastructure:
   - Proxmox VE for virtualization
   - Docker for containerization
   - Traefik for reverse proxy
   - Authentik for authentication

2. Monitoring Stack:
   - Prometheus for metrics collection
   - Grafana for visualization
   - InfluxDB for time-series data
   - Alertmanager for notifications

3. Security Services:
   - CrowdSec for intrusion detection
   - Vault for secrets management
   - WireGuard for VPN
   - Fail2ban for brute force protection
   - Certificate Management for SSL/TLS

4. Media Services:
   - Jellyfin for media streaming
   - Sonarr for TV shows
   - Radarr for movies
   - Plex for media management

5. File Services:
   - Nextcloud for file sharing
   - Samba for network shares
   - Syncthing for file synchronization
   - Backup solutions

6. Automation Services:
   - Home Assistant for home automation
   - Node-RED for automation flows
   - MQTT broker for IoT communication
   - Task scheduling

7. Logging Services:
   - Centralized logging system
   - Log aggregation and analysis
   - Log retention management
   - Log-based alerting

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Monitoring Setup and Deployment

### Prometheus & Grafana
1. Configure monitoring in `group_vars/all/vars.yml`
2. Deploy monitoring stack:
   ```bash
   ansible-playbook main.yml --tags monitoring
   ```

### Node Exporter
1. Enable node exporter in Proxmox configuration
2. Deploy node exporter:
   ```bash
   ansible-playbook main.yml --tags monitoring
   ``` 