# RomM Role

This role deploys and manages RomM (ROM Management System) for the homelab environment with **100% automatic variable handling** and **zero manual configuration required**. It provides modular tasks for deployment, validation, monitoring, backup, security, and homepage integration.

## 🚀 **Automatic Setup Features**

### ✅ **Comprehensive Variable Coverage**
- **All RomM variables automatically generated** - No manual editing required
- **Cryptographically secure credentials** - Industry-standard security
- **Complete service coverage** - Every RomM variable handled
- **Environment variable automation** - Full .env file generation

### 🔐 **Enhanced Security**
- **256-bit encryption** for RomM credentials
- **Complex password requirements** for admin access
- **API key prefixing** for easy identification
- **Secure vault generation** with proper entropy

### 🔧 **Automatic Configuration**
- **Complete configuration files** generated automatically
- **Service enablement** based on user preferences
- **Network configuration** with proper validation
- **Resource limits** with sensible defaults

## 📋 **What Gets Automatically Configured**

### **RomM Core Variables**
- ✅ RomM admin credentials and authentication
- ✅ RomM secret key and API keys
- ✅ Database configuration (SQLite/PostgreSQL)
- ✅ Domain and subdomain configuration
- ✅ Traefik integration with SSL/TLS
- ✅ Monitoring and health checks
- ✅ Backup and retention settings

### **Security Variables**
- ✅ RomM admin password
- ✅ RomM secret key
- ✅ RomM API key
- ✅ Database passwords
- ✅ Rate limiting and security headers
- ✅ CORS and authentication settings

### **Integration Variables**
- ✅ Homepage integration
- ✅ Monitoring integration
- ✅ Alerting configuration
- ✅ Notification settings
- ✅ Resource limits

## 🏗️ **Features**
- Deploy and configure RomM with zero manual configuration
- Traefik integration with SSL/TLS
- Monitoring and alerting integration
- Automated backup and restore
- Security hardening and compliance
- Homepage integration
- Health checks and validation
- Comprehensive variable management

## 📁 **Directory Structure**
- `defaults/`: Default variables (enhanced for automatic setup)
- `handlers/`: Service handlers
- `tasks/`: Modular tasks (main, deploy, monitoring, security, backup, homepage, alerts, validate, etc.)
- `templates/`: Jinja2 templates for configs, scripts, homepage, etc.

## 🚀 **Usage**

### **Automatic Deployment**
Include this role in your playbook:
```yaml
- hosts: all
  roles:
    - role: romm
```

### **Manual Override (Optional)**
If you need to customize specific variables:
```yaml
- hosts: all
  roles:
    - role: romm
      vars:
        romm_admin_email: "custom@example.com"
        romm_database_type: "postgresql"
```

## 🔧 **Variables**

### **Automatically Generated Variables**
All RomM variables are automatically generated and managed securely:

```yaml
# Core Configuration (Auto-generated)
romm_enabled: true
romm_domain: "romm.{{ domain }}"
romm_subdomain: "romm"

# Authentication (Auto-generated)
romm_auth_enabled: true
romm_auth_method: "authentik"
romm_admin_email: "{{ admin_email }}"
romm_admin_password: "{{ vault_romm_admin_password }}"
romm_secret_key: "{{ vault_romm_secret_key }}"

# Database (Auto-generated)
romm_database_enabled: true
romm_database_type: "sqlite"
romm_database_password: "{{ vault_romm_database_password }}"

# API (Auto-generated)
romm_api_enabled: true
romm_api_key: "{{ vault_romm_api_key }}"
```

### **Vault Variables (Auto-generated)**
```yaml
# RomM Vault Variables (Automatically Generated)
vault_romm_admin_password: "[secure-random-32-char]"
vault_romm_secret_key: "[secure-random-64-char]"
vault_romm_database_password: "[secure-random-32-char]"
vault_romm_api_key: "[secure-random-64-char]"
```

## 🔗 **Integration**
- **Monitoring**: Prometheus, Grafana, logrotate
- **Backup**: Scheduled, compressed, encrypted
- **Security**: Hardening, access control, fail2ban, firewall
- **Homepage**: Service registration and status
- **Authentication**: Authentik integration
- **Traefik**: SSL/TLS with automatic certificate management

## ✅ **Validation & Health Checks**
- Automated validation and health scripts for RomM
- Service readiness checks
- API endpoint validation
- Database connectivity tests

## 📊 **Configuration**
- **Port**: 3004
- **Domain**: romm.{{ domain }}
- **Category**: utilities
- **Stage**: stage3
- **Authentication**: Authentik (recommended)
- **Database**: SQLite (default) or PostgreSQL
- **Backup**: Daily at 2 AM
- **Monitoring**: Prometheus metrics enabled

## 🔗 **Dependencies**
- None (standalone service)

## 🌐 **Environment Variables**
All environment variables are automatically generated:

```bash
# System Configuration
TZ={{ timezone }}
PUID={{ ansible_user_id }}
PGID={{ ansible_user_id }}

# RomM Configuration
ROMM_DOMAIN={{ romm_domain }}
ROMM_SECRET_KEY={{ vault_romm_secret_key }}
ROMM_ADMIN_EMAIL={{ romm_admin_email }}
ROMM_ADMIN_PASSWORD={{ vault_romm_admin_password }}
ROMM_API_KEY={{ vault_romm_api_key }}
```

## 📁 **Volumes**
- `{{ docker_data_root }}/romm:/data` - RomM data
- `{{ docker_config_root }}/romm:/config` - RomM configuration
- `{{ docker_logs_root }}/romm:/logs` - RomM logs
- `{{ docker_backup_root }}/romm:/backups` - RomM backups

## 🔒 **Security Features**
- **No hardcoded passwords** - All credentials in vault
- **Rate limiting** - Configurable request limits
- **Security headers** - Enhanced security
- **CORS protection** - Cross-origin request control
- **Fail2ban integration** - Intrusion prevention
- **CrowdSec integration** - Advanced threat detection

## 📈 **Monitoring Features**
- **Health checks** - Service availability monitoring
- **Metrics collection** - Prometheus integration
- **Log aggregation** - Centralized logging
- **Alerting** - Multi-channel notifications
- **Performance monitoring** - Resource usage tracking

## 🔄 **Backup Features**
- **Automated backups** - Daily scheduled backups
- **Data retention** - Configurable retention periods
- **Compression** - Space-efficient storage
- **Encryption** - Secure backup storage
- **Recovery testing** - Backup validation

## 🎯 **Zero Configuration Deployment**

The RomM role is designed for **zero manual configuration**:

1. **Automatic Variable Generation**: All RomM variables are automatically generated
2. **Secure Credential Management**: All passwords and keys stored in Ansible Vault
3. **Environment File Generation**: Complete .env file automatically created
4. **Service Integration**: Automatic integration with monitoring, backup, and security systems
5. **Health Validation**: Automatic service validation and health checks

## 📝 **Author**
Enhanced by Ansible Homelab Service Integration Wizard

## 🔄 **Updates**
- **v2.0**: Enhanced for automatic variable management
- **v1.0**: Initial RomM role implementation

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose and pre-change snapshot automatically if a deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., romm
    sudo cp {{ backup_dir }}/${SERVICE}/last_good/docker-compose.yml {{ docker_dir }}/${SERVICE}/docker-compose.yml
    if [ -f {{ backup_dir }}/${SERVICE}/last_good/.env ]; then sudo cp {{ backup_dir }}/${SERVICE}/last_good/.env {{ docker_dir }}/${SERVICE}/.env; fi
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```
  - Option B — restore pre-change snapshot
    ```bash
    SERVICE=<service>
    ls -1 {{ backup_dir }}/${SERVICE}/prechange_*.tar.gz
    sudo tar -xzf {{ backup_dir }}/${SERVICE}/prechange_<TIMESTAMP>.tar.gz -C /
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```

- Rollback to a recorded rollback point (target host):
  ```bash
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```

- Full stack version rollback:
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```
