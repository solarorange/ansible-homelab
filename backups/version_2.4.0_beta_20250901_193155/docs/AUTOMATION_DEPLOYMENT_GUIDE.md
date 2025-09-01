# Python Automation Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the improved Python automation scripts for Authentik, Homepage, and Grafana in your Ansible homelab environment. The scripts have been enhanced with critical security fixes, comprehensive error handling, and reliability improvements.

## Prerequisites

### System Requirements
- Python 3.8 or higher
- Ansible 2.12 or higher
- Docker and Docker Compose
- Access to all target services (Authentik, Homepage, Grafana)

### Required Python Packages
```bash
pip install requests pyyaml jinja2 urllib3
```

### Environment Setup
1. **Clone the repository** (if not already done):
   ```bash
   git clone <your-repo-url>
   cd ansible_homelab
   ```

2. **Set up virtual environment** (recommended):
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

## Security Configuration

### 1. Credential Management

**⚠️ CRITICAL: Never hardcode credentials in scripts**

Create a secure credentials file:
```bash
# Create encrypted credentials file
mkdir -p secrets
touch secrets/automation_credentials.yml
chmod 600 secrets/automation_credentials.yml
```

Add your credentials to `secrets/automation_credentials.yml`:
```yaml
# Authentik Configuration
authentik:
  admin_user: "admin"
  admin_password: "{{ vault_authentik_password }}"
  api_token: "{{ vault_authentik_token }}"
  domain: "auth.yourdomain.com"
  port: 9000

# Homepage Configuration
homepage:
  api_key: "{{ vault_homepage_api_key }}"
  domain: "homepage.yourdomain.com"
  port: 3000

# Grafana Configuration
grafana:
  admin_user: "admin"
  admin_password: "{{ vault_grafana_password }}"
  domain: "grafana.yourdomain.com"
  port: 3000
```

### 2. SSL Certificate Configuration

Ensure all services use valid SSL certificates:
```bash
# Verify SSL certificates
openssl s_client -connect auth.yourdomain.com:443 -servername auth.yourdomain.com
openssl s_client -connect homepage.yourdomain.com:443 -servername homepage.yourdomain.com
openssl s_client -connect grafana.yourdomain.com:443 -servername grafana.yourdomain.com
```

## Deployment Steps

### Phase 1: Pre-Deployment Validation

1. **Run pre-flight checks**:
   ```bash
   # Test all automation scripts
   python3 scripts/test_automation_improvements.py
   
   # Validate configuration files
   python3 scripts/validate_configuration.py
   ```

2. **Verify service connectivity**:
   ```bash
   # Test Authentik connection
   curl -k https://auth.yourdomain.com/api/v3/core/applications/
   
   # Test Homepage connection
   curl -k https://homepage.yourdomain.com/api/services
   
   # Test Grafana connection
   curl -k https://grafana.yourdomain.com/api/health
   ```

### Phase 2: Service Deployment Order

**Important**: Deploy services in the correct order to ensure proper integration.

1. **Deploy Authentik first** (authentication provider):
   ```bash
   ansible-playbook playbooks/homepage_grafana_authentik_automation.yml \
     --tags "authentik" \
     --extra-vars "deploy_authentik=true"
   ```

2. **Deploy Grafana** (monitoring and dashboards):
   ```bash
   ansible-playbook playbooks/homepage_grafana_authentik_automation.yml \
     --tags "grafana" \
     --extra-vars "deploy_grafana=true"
   ```

3. **Deploy Homepage** (service dashboard):
   ```bash
   ansible-playbook playbooks/homepage_grafana_authentik_automation.yml \
     --tags "homepage" \
     --extra-vars "deploy_homepage=true"
   ```

### Phase 3: Integration Configuration

1. **Configure OAuth/OIDC integration**:
   ```bash
   # Run the integration automation
   python3 scripts/configure_integrations.py \
     --authentik-url https://auth.yourdomain.com \
     --homepage-url https://homepage.yourdomain.com \
     --grafana-url https://grafana.yourdomain.com
   ```

2. **Verify integration**:
   ```bash
   # Test OAuth flow
   python3 scripts/test_oauth_integration.py
   
   # Test service discovery
   python3 scripts/test_service_discovery.py
   ```

## Configuration Files

### 1. Homepage Configuration

Create `config/homepage/services.yml`:
```yaml
services:
  - name: "Grafana"
    url: "https://grafana.yourdomain.com"
    description: "Monitoring and Analytics"
    icon: "grafana"
    category: "Monitoring"
    health_url: "https://grafana.yourdomain.com/api/health"
    auth_type: "oauth"
    
  - name: "Authentik"
    url: "https://auth.yourdomain.com"
    description: "Identity Provider"
    icon: "authentik"
    category: "Security"
    health_url: "https://auth.yourdomain.com/api/v3/core/applications/"
    auth_type: "oauth"
```

### 2. Grafana Configuration

Create `config/grafana/datasources.yml`:
```yaml
datasources:
  - name: "Prometheus"
    type: "prometheus"
    url: "http://prometheus:9090"
    access: "proxy"
    is_default: true
    
  - name: "Loki"
    type: "loki"
    url: "http://loki:3100"
    access: "proxy"
```

### 3. Authentik Configuration

Create `config/authentik/applications.yml`:
```yaml
applications:
  - name: "Homepage"
    slug: "homepage"
    provider: "oauth2"
    redirect_uris: ["https://homepage.yourdomain.com/auth/callback"]
    
  - name: "Grafana"
    slug: "grafana"
    provider: "oauth2"
    redirect_uris: ["https://grafana.yourdomain.com/login/generic_oauth"]
```

## Monitoring and Health Checks

### 1. Set up Monitoring

Create monitoring dashboards:
```bash
# Import Grafana dashboards
python3 roles/grafana/scripts/grafana_automation.py \
  --config config/grafana/dashboards.yml \
  --import-dashboards

# Configure alerting
python3 roles/grafana/scripts/grafana_automation.py \
  --config config/grafana/alerts.yml \
  --configure-alerts
```

### 2. Health Check Scripts

Create automated health checks:
```bash
# Create health check script
cat > scripts/health_check.py << 'EOF'
#!/usr/bin/env python3
import requests
import sys
import json

def check_service(url, name):
    try:
        response = requests.get(url, timeout=10, verify=True)
        if response.status_code == 200:
            print(f"✅ {name}: Healthy")
            return True
        else:
            print(f"❌ {name}: Unhealthy (HTTP {response.status_code})")
            return False
    except Exception as e:
        print(f"❌ {name}: Error - {e}")
        return False

services = [
    ("https://auth.yourdomain.com/api/v3/core/applications/", "Authentik"),
    ("https://homepage.yourdomain.com/api/services", "Homepage"),
    ("https://grafana.yourdomain.com/api/health", "Grafana")
]

all_healthy = True
for url, name in services:
    if not check_service(url, name):
        all_healthy = False

sys.exit(0 if all_healthy else 1)
EOF

chmod +x scripts/health_check.py
```

### 3. Automated Monitoring

Set up cron jobs for automated monitoring:
```bash
# Add to crontab
echo "*/5 * * * * /path/to/ansible_homelab/scripts/health_check.py >> /var/log/automation_health.log 2>&1" | crontab -
```

## Troubleshooting

### Common Issues

1. **SSL Certificate Errors**:
   ```bash
   # Check certificate validity
   openssl x509 -in /path/to/cert.pem -text -noout
   
   # Update certificates if needed
   certbot renew --force-renewal
   ```

2. **Authentication Failures**:
   ```bash
   # Test API authentication
   python3 scripts/test_authentication.py
   
   # Check token validity
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://auth.yourdomain.com/api/v3/core/applications/
   ```

3. **Service Discovery Issues**:
   ```bash
   # Check Docker labels
   docker ps --format "table {{.Names}}\t{{.Labels}}"
   
   # Test service discovery
   python3 scripts/test_service_discovery.py --verbose
   ```

### Log Analysis

Check automation logs:
```bash
# View recent logs
tail -f logs/automation.log

# Search for errors
grep -i error logs/automation.log

# Check specific service logs
tail -f logs/security/authentik/authentik_automation.log
tail -f logs/homepage_automation.log
tail -f logs/grafana_automation.log
```

## Security Best Practices

### 1. Network Security
- Use HTTPS for all external communications
- Implement proper firewall rules
- Use VPN for remote access
- Regular security updates

### 2. Access Control
- Use strong, unique passwords
- Implement MFA where possible
- Regular credential rotation
- Principle of least privilege

### 3. Monitoring and Alerting
- Monitor for suspicious activities
- Set up intrusion detection
- Regular security audits
- Automated vulnerability scanning

## Backup and Recovery

### 1. Configuration Backups
```bash
# Create backup script
cat > scripts/backup_configs.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backups/automation/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup configuration files
cp -r config/ "$BACKUP_DIR/"
cp -r secrets/ "$BACKUP_DIR/"

# Backup logs
cp -r logs/ "$BACKUP_DIR/"

# Create archive
tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"
rm -rf "$BACKUP_DIR"

echo "Backup created: $BACKUP_DIR.tar.gz"
EOF

chmod +x scripts/backup_configs.sh
```

### 2. Recovery Procedures
```bash
# Restore configuration
tar -xzf backup_20241219_143022.tar.gz
cp -r backup_20241219_143022/config/* config/
cp -r backup_20241219_143022/secrets/* secrets/

# Restart services
ansible-playbook playbooks/homepage_grafana_authentik_automation.yml --tags "restart"
```

## Performance Optimization

### 1. Resource Monitoring
```bash
# Monitor resource usage
python3 scripts/monitor_resources.py

# Optimize based on usage patterns
python3 scripts/optimize_configuration.py
```

### 2. Caching and Connection Pooling
- Enable Redis caching for frequently accessed data
- Implement connection pooling for database connections
- Use CDN for static assets

## Maintenance Schedule

### Daily
- Check health status
- Review error logs
- Monitor resource usage

### Weekly
- Update security patches
- Review access logs
- Test backup procedures

### Monthly
- Security audit
- Performance review
- Configuration optimization

### Quarterly
- Full system review
- Update documentation
- Disaster recovery testing

## Support and Documentation

### Useful Commands
```bash
# Quick status check
python3 scripts/status_check.py

# Configuration validation
python3 scripts/validate_all_configs.py

# Performance test
python3 scripts/performance_test.py

# Security scan
python3 scripts/security_scan.py
```

### Documentation
- [Automation Review Summary](AUTOMATION_REVIEW_SUMMARY.md)
- [Python Automation Checklist](PYTHON_AUTOMATION_CHECKLIST.md)
- [Advanced Best Practices](ADVANCED_BEST_PRACTICES.md)

## Conclusion

The improved Python automation scripts provide a robust, secure, and reliable foundation for your homelab automation. With proper deployment and maintenance, they will provide hands-off operation with minimal manual intervention.

**Next Steps**:
1. Deploy according to this guide
2. Set up monitoring and alerting
3. Configure automated backups
4. Schedule regular maintenance
5. Monitor and optimize performance

For additional support or questions, refer to the troubleshooting section or create an issue in the repository. 