# Security Stack Ansible Role

A comprehensive Ansible role for deploying and managing a complete security stack in a production homelab environment.

## Overview

This role provides a modular, production-ready solution for homelab security, including:
- **Authentication**: Authentik for SSO and identity management.
- **Reverse Proxy**: Traefik for secure application routing and automated SSL/TLS.
- **DNS Security**: Pi-hole for network-wide ad-blocking and DNS filtering.
- **Firewall**: Fail2ban (host-based) and CrowdSec (container-based) for intrusion prevention.
- **VPN**: WireGuard for secure remote access.

## Features

- ✅ Modular deployment of all security components.
- ✅ Integration with monitoring (Prometheus, Grafana, Loki).
- ✅ Automated backup and recovery procedures.
- ✅ Security hardening and compliance checks.
- ✅ Homepage integration for easy access to service UIs.
- ✅ Comprehensive validation and health checks.
- ✅ Centralized configuration with Ansible Vault support for secrets.

## Requirements

- Ansible 2.12+
- Docker and Docker Compose
- `community.docker` Ansible collection

## Role Variables

Variables are defined in `defaults/main.yml`. All sensitive values (passwords, API keys) should be stored in Ansible Vault and referenced like `{{ vault_... }}`.

### Main Switches
```yaml
security_enabled: true
security_authentication_enabled: true
security_proxy_enabled: true
security_dns_enabled: true
security_firewall_enabled: true
security_vpn_enabled: true
```

### Service Configuration Examples
```yaml
# Authentik
security_authentik:
  enabled: true
  secret_key: "{{ vault_authentik_secret_key }}"
  postgres_password: "{{ vault_authentik_postgres_password }}"
  admin_password: "{{ vault_authentik_admin_password }}"

# Traefik
security_traefik:
  enabled: true
  cloudflare_api_token: "{{ vault_cloudflare_api_token }}"

# Pi-hole
security_pihole:
  enabled: true
  admin_password: "{{ vault_pihole_admin_password }}"

# WireGuard Peers
security_wireguard:
  peers:
    - name: myphone
      preshared_key: "{{ vault_wireguard_myphone_psk }}"
      allowed_ips: "10.13.13.2/32"
```

## Usage

1.  Include the role in your playbook:
    ```yaml
    - hosts: all
      roles:
        - security
    ```
2.  Ensure all `vault_` variables are defined in your Ansible Vault.

## Directory Structure

```
roles/security/
├── defaults/
│   └── main.yml
├── handlers/
│   └── main.yml
├── tasks/
│   ├── main.yml
│   └── ... (modular task files)
├── templates/
│   └── ... (service templates)
├── authentication/
├── proxy/
├── dns/
├── firewall/
└── vpn/
```

## Variables & Vault Integration
- All tunable variables are in `defaults/main.yml`.
- Sensitive variables (passwords, keys) are referenced in `vars/main.yml` and can be overridden in `group_vars/` or `host_vars/` (vault-encrypted recommended).
- Example:
  ```yaml
  authentik_admin_password: "{{ vault_authentik_admin_password | default(lookup('password', '/dev/null length=32 chars=ascii_letters,digits')) }}"
  ```
- To override, create `group_vars/all/vault.yml` (encrypted with `ansible-vault`).

## Usage
1. Include the role in your playbook:
   ```yaml
   - hosts: security
     roles:
       - security
   ```
2. Set/override variables as needed in inventory or group_vars.
3. Ensure vault files are available for sensitive data.

## Sub-Roles
- `authentication`: Authentik, SSO, OAuth, etc.
- `proxy`: Traefik, SSL/TLS, routing
- `dns`: Pi-hole, DNS filtering
- `firewall`: Fail2Ban, CrowdSec, access control
- `vpn`: WireGuard, remote access

## Integration
- Monitoring: Prometheus, Grafana, Loki, Alertmanager
- Backup: Scheduled, encrypted, validated
- Security: Hardening, compliance, access control
- Homepage: Service registration and status

## Validation & Health Checks
- Automated validation and health scripts for all security services

## Extending & Customizing
- Add new services by extending the relevant sub-role
- Override any variable in your inventory or group_vars
- Use vault for all sensitive data

---

For detailed variable documentation, see `defaults/main.yml`. 

## Rollback

- Automatic rollback on failed deploys: Safe deploy restores last-known-good Compose and the pre-change snapshot automatically when a deployment fails.

- Manual rollback (a specific security component):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., security, dns, proxy, firewall, vpn, authentication
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

- Rollback to a recorded rollback point (run on the target host):
  ```bash
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```

- Full stack version rollback (entire repository):
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```