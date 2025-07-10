# Infrastructure Validation System

This document describes the comprehensive infrastructure validation system that automatically checks DNS records, firewall rules, and SSL certificates before deployment.

## Overview

The infrastructure validation system ensures that your homelab environment is properly configured before deployment by validating:

1. **DNS Records** - All required domains resolve to the correct IP address
2. **Firewall Rules** - Required ports are open and critical ports are blocked
3. **SSL Certificates** - All certificates are valid, not expired, and match their domains
4. **Traefik Status** - Reverse proxy is running and properly configured

## Quick Start

### Run Validation Before Deployment

```bash
# Run validation as part of the main deployment
ansible-playbook main.yml --tags validation

# Run validation independently
ansible-playbook playbooks/validate_infrastructure.yml

# Run validation with custom options
ansible-playbook playbooks/validate_infrastructure.yml \
  -e "validation_strict_mode=false" \
  -e "validation_skip_ssl=true"
```

### Run Validation Script Directly

```bash
# Basic validation
python3 scripts/validate_infrastructure.py \
  --domain yourdomain.com \
  --server-ip 192.168.1.100

# Verbose output with JSON report
python3 scripts/validate_infrastructure.py \
  --domain yourdomain.com \
  --server-ip 192.168.1.100 \
  --verbose \
  --output validation_report.json
```

## Validation Checks

### DNS Records Validation

**What it checks:**
- All subdomains resolve to the correct server IP
- DNS resolution is working properly
- No DNS propagation issues

**Domains validated:**
- `yourdomain.com`
- `traefik.yourdomain.com`
- `auth.yourdomain.com`
- `grafana.yourdomain.com`
- `pihole.yourdomain.com`
- `homepage.yourdomain.com`
- `portainer.yourdomain.com`
- `sonarr.yourdomain.com`
- `radarr.yourdomain.com`
- `jellyfin.yourdomain.com`
- `overseerr.yourdomain.com`
- `nextcloud.yourdomain.com`
- `git.yourdomain.com`
- `vault.yourdomain.com`
- `vpn.yourdomain.com`

**Expected result:** All domains should resolve to your server IP address.

### Firewall Rules Validation

**What it checks:**
- UFW firewall is enabled and active
- Required ports are open
- Critical security ports are blocked

**Required open ports:**
- **22/tcp** - SSH access
- **80/tcp** - HTTP traffic
- **443/tcp** - HTTPS traffic
- **53/tcp** - DNS TCP
- **53/udp** - DNS UDP
- **51820/udp** - WireGuard VPN

**Critical ports (should be blocked):**
- **21/tcp** - FTP
- **23/tcp** - Telnet
- **25/tcp** - SMTP
- **110/tcp** - POP3
- **143/tcp** - IMAP
- **3306/tcp** - MySQL
- **5432/tcp** - PostgreSQL
- **6379/tcp** - Redis
- **27017/tcp** - MongoDB

### SSL Certificate Validation

**What it checks:**
- Certificates are not expired
- Certificates are not expiring within 30 days
- Certificate subject matches domain name
- Certificate chain is valid
- Certificates are issued by trusted CAs

**Validation criteria:**
- ✅ Certificate is not expired
- ✅ Certificate is not expiring within 30 days
- ✅ Certificate subject matches domain name
- ✅ Certificate chain is valid
- ✅ Certificate is issued by a trusted CA

### Traefik Status Validation

**What it checks:**
- Traefik container is running
- Traefik API is responding
- Certificate resolver is properly configured

## Configuration Options

### Environment Variables

```bash
# Domain configuration
export HOMELAB_DOMAIN="yourdomain.com"

# Server IP
export HOMELAB_IP_ADDRESS="192.168.1.100"

# Validation options
export VALIDATION_STRICT_MODE="true"
export VALIDATION_SKIP_SSL="false"
export VALIDATION_SKIP_FIREWALL="false"
export VALIDATION_SKIP_DNS="false"
```

### Ansible Variables

```yaml
# In group_vars/all/common.yml or inventory
validation_strict_mode: true
validation_skip_ssl: false
validation_skip_firewall: false
validation_skip_dns: false
```

### Command Line Options

```bash
# Skip specific validations
ansible-playbook playbooks/validate_infrastructure.yml \
  -e "validation_skip_ssl=true" \
  -e "validation_skip_firewall=true"

# Run in non-strict mode (warnings don't fail deployment)
ansible-playbook playbooks/validate_infrastructure.yml \
  -e "validation_strict_mode=false"
```

## Integration with Deployment

### Pre-Deployment Validation

The validation system is automatically integrated into the main deployment workflow:

```yaml
# In main.yml
- name: Pre-deployment validation
  include_tasks: tasks/validate/infrastructure.yml
  tags: [validation, pre-deployment]
```

### Post-Deployment Validation

```yaml
# In main.yml
- name: Post-deployment validation
  include_tasks: tasks/validate/infrastructure.yml
  tags: [validation, post-deployment]
```

## Troubleshooting

### Common DNS Issues

**Problem:** DNS resolution fails
```bash
# Check DNS records
nslookup yourdomain.com
nslookup traefik.yourdomain.com

# Verify DNS propagation
dig yourdomain.com +short
```

**Solutions:**
1. Ensure DNS records point to your server IP
2. Wait for DNS propagation (up to 48 hours)
3. Check DNS provider configuration

### Common Firewall Issues

**Problem:** Required ports are blocked
```bash
# Check UFW status
sudo ufw status numbered

# Check specific ports
sudo ufw status | grep "80/tcp"
sudo ufw status | grep "443/tcp"
```

**Solutions:**
1. Enable UFW: `sudo ufw enable`
2. Allow required ports: `sudo ufw allow 80/tcp`
3. Check for conflicting rules

### Common SSL Issues

**Problem:** SSL certificate errors
```bash
# Check certificate expiration
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com

# Check certificate details
echo | openssl s_client -servername yourdomain.com -connect yourdomain.com:443 2>/dev/null | openssl x509 -noout -dates
```

**Solutions:**
1. Ensure Traefik is running
2. Check certificate renewal configuration
3. Verify domain matches certificate

### Common Traefik Issues

**Problem:** Traefik validation fails
```bash
# Check container status
docker ps | grep traefik

# Check API health
curl http://localhost:8080/api/health

# Check logs
docker logs traefik
```

**Solutions:**
1. Start Traefik container
2. Check Traefik configuration
3. Verify certificate resolver setup

## Validation Reports

### Automatic Report Generation

The validation system automatically generates detailed reports:

```bash
# Report location
./validation_report_YYYYMMDD_HHMMSS.md

# JSON report (when using --output)
./validation_report.json
```

### Report Contents

- **Executive Summary** - Overall validation status
- **Detailed Results** - Per-check results and issues
- **Recommendations** - Actions to take
- **Troubleshooting Guide** - Common issues and solutions

### Example Report

```markdown
# Infrastructure Validation Report

**Generated:** 2024-01-15T10:30:00Z  
**Domain:** yourdomain.com  
**Server IP:** 192.168.1.100  
**Validation Status:** ✅ PASSED

## Executive Summary

The infrastructure validation completed successfully. All critical checks passed, and the system is ready for deployment.

⚠️ Warnings: 2 warning(s) were found that should be addressed.

## Detailed Results

### DNS Records Validation
**Status:** ✅ PASSED

### Firewall Rules Validation  
**Status:** ✅ PASSED

### SSL Certificate Validation
**Status:** ✅ PASSED

### Traefik Status Validation
**Status:** ✅ PASSED
```

## Advanced Usage

### Custom Validation Scripts

You can extend the validation system by creating custom validation scripts:

```python
#!/usr/bin/env python3
# custom_validation.py

from validate_infrastructure import InfrastructureValidator

class CustomValidator(InfrastructureValidator):
    def validate_custom_service(self):
        # Add custom validation logic
        pass

# Usage
validator = CustomValidator("yourdomain.com", "192.168.1.100")
validator.validate_custom_service()
```

### Integration with CI/CD

```yaml
# .github/workflows/validate.yml
name: Infrastructure Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Run Infrastructure Validation
        run: |
          python3 scripts/validate_infrastructure.py \
            --domain ${{ secrets.DOMAIN }} \
            --server-ip ${{ secrets.SERVER_IP }} \
            --output validation_results.json
      
      - name: Upload Validation Report
        uses: actions/upload-artifact@v2
        with:
          name: validation-report
          path: validation_results.json
```

### Monitoring Integration

```yaml
# prometheus/validation_metrics.yml
- job_name: 'infrastructure_validation'
  static_configs:
    - targets: ['localhost:8080']
  metrics_path: '/metrics'
  scrape_interval: 1h
```

## Best Practices

### 1. Run Validation Regularly

```bash
# Daily validation check
0 6 * * * /usr/local/bin/validate_infrastructure.py --domain yourdomain.com --server-ip 192.168.1.100 --output /var/log/validation_daily.json
```

### 2. Monitor Validation Results

```bash
# Check validation status
python3 scripts/validate_infrastructure.py \
  --domain yourdomain.com \
  --server-ip 192.168.1.100 \
  --output /tmp/validation.json

# Parse results
jq '.success' /tmp/validation.json
```

### 3. Integrate with Alerting

```python
# alert_on_validation_failure.py
import json
import requests

with open('/tmp/validation.json') as f:
    results = json.load(f)

if not results['success']:
    # Send alert
    requests.post('https://hooks.slack.com/services/...', 
                 json={'text': f"Infrastructure validation failed: {results['errors']}"})
```

### 4. Version Control Validation Results

```bash
# Commit validation reports
git add validation_report_*.md
git commit -m "Update infrastructure validation report"
git push
```

## Support

For issues with the validation system:

1. **Check the logs:** Review validation output for specific error messages
2. **Review documentation:** Check this guide and related documentation
3. **Run in verbose mode:** Use `--verbose` flag for detailed output
4. **Check prerequisites:** Ensure all required packages are installed

## Contributing

To contribute to the validation system:

1. Fork the repository
2. Create a feature branch
3. Add your validation logic
4. Update documentation
5. Submit a pull request

---

**Last Updated:** {{ ansible_date_time.iso8601 }}  
**Version:** 1.0 