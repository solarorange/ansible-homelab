# Proxy Sub-Role

This sub-role manages reverse proxy infrastructure for the security stack, including Traefik and SSL/TLS termination. It provides modular tasks for deployment, validation, monitoring, backup, security hardening, and homepage integration.

## Features
- Deploy and configure Traefik or other reverse proxies
- SSL/TLS certificate management
- Vault integration for sensitive credentials
- Monitoring and alerting integration
- Automated backup and restore
- Security hardening and compliance
- Homepage integration

## Directory Structure
- defaults/main.yml         # Default variables
- vars/main.yml             # Sensitive variables
- handlers/main.yml         # Handlers for service restarts
- tasks/main.yml            # Main entry point
- tasks/deploy.yml          # Deployment tasks
- tasks/validate.yml        # Validation tasks
- tasks/validate_deployment.yml # Health checks
- tasks/monitoring.yml      # Monitoring integration
- tasks/backup.yml          # Backup & restore
- tasks/security.yml        # Security hardening
- tasks/homepage.yml        # Homepage integration
- tasks/alerts.yml          # Alerting integration
- templates/                # Service and homepage templates 