# Authentication Sub-Role

This sub-role manages authentication infrastructure for the security stack, including SSO, Authentik, and OAuth services. It provides modular tasks for deployment, validation, monitoring, backup, security hardening, and homepage integration.

## Features
- Deploy and configure Authentik or other SSO solutions
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