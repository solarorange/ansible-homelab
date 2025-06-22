# Firewall Sub-Role

This sub-role manages firewall and intrusion detection infrastructure for the security stack, including Fail2Ban and CrowdSec. It provides modular tasks for deployment, validation, monitoring, backup, security hardening, and homepage integration.

## Features
- Deploy and configure Fail2Ban, CrowdSec, and firewall rules
- Intrusion detection and prevention
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