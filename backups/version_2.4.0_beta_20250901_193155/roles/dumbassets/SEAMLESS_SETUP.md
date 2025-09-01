# DumbAssets Seamless Setup Guide

## Overview

The DumbAssets role has been enhanced to provide **zero-configuration deployment** with seamless setup capabilities. All variables that require configuration are now automatically handled with sensible defaults and environment variable overrides.

## Key Improvements

### 1. Environment Variable Integration

All configuration variables now support environment variable overrides:

```bash
# Before: Required manual configuration in group_vars
dumbassets_pin: "1234"  # Had to be manually set

# After: Automatic with environment variable support
dumbassets_pin: "{{ lookup('env', 'DUMBASSETS_PIN') | default('1234') }}"
```

### 2. Zero-Configuration Deployment

The role can now be deployed without any manual configuration:

```bash
# Zero-configuration deployment
ansible-playbook site.yml --tags dumbassets
```

### 3. Automatic Subdomain Configuration

The subdomain is automatically configured based on the `subdomains.dumbassets` entry in `group_vars/all/vars.yml`:

```yaml
# Automatically added to group_vars/all/vars.yml
subdomains:
  dumbassets: "assets"  # Results in assets.yourdomain.com
```

### 4. Comprehensive Default Values

All variables have sensible defaults that work out-of-the-box:

- **PIN**: `1234` (with clear warning to change)
- **Port**: `3004` (conflict-free)
- **Network**: `homelab` (standard network)
- **Directories**: Based on global Docker configuration
- **Security**: All hardening enabled by default
- **Monitoring**: Full integration enabled
- **Backup**: Automated backups enabled

### 5. Deployment Script

A comprehensive deployment script provides easy deployment with optional customization:

```bash
# Zero-config deployment
./roles/dumbassets/deploy.sh

# Custom PIN
./roles/dumbassets/deploy.sh -p 5678

# Full customization
./roles/dumbassets/deploy.sh -p secure123 -t "My Asset Tracker" -c EUR
```

## Environment Variables Reference

### Essential Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_PIN` | `1234` | **IMPORTANT**: Change after deployment |
| `DUMBASSETS_SITE_TITLE` | `Asset Tracker` | Site title |
| `DUMBASSETS_CURRENCY_CODE` | `USD` | Currency for asset values |

### Network Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_PORT` | `3004` | Internal port |
| `DUMBASSETS_EXTERNAL_PORT` | `3004` | External port |
| `DUMBASSETS_NETWORK` | `homelab` | Docker network |

### Advanced Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DUMBASSETS_TIMEZONE` | `America/New_York` | Container timezone |
| `DUMBASSETS_APPRISE_URL` | `` | Notification URL |
| `DUMBASSETS_BACKUP_ENCRYPTION` | `false` | Backup encryption |
| `DUMBASSETS_DEBUG` | `false` | Debug mode |

## Deployment Examples

### 1. Minimal Deployment (Zero Config)

```bash
# No environment variables needed
ansible-playbook site.yml --tags dumbassets
```

**Result**: 
- Service accessible at `https://assets.yourdomain.com`
- PIN: `1234`
- All integrations enabled
- Security hardening applied

### 2. Custom PIN Only

```bash
export DUMBASSETS_PIN="5678"
ansible-playbook site.yml --tags dumbassets
```

### 3. Production Deployment

```bash
export DUMBASSETS_PIN="$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-8)"
export DUMBASSETS_SITE_TITLE="Corporate Asset Management"
export DUMBASSETS_CURRENCY_CODE="USD"
export DUMBASSETS_BACKUP_ENCRYPTION="true"
export DUMBASSETS_APPRISE_URL="slack://webhook_url"
ansible-playbook site.yml --tags dumbassets
```

### 4. Using Deployment Script

```bash
# Zero-config
./roles/dumbassets/deploy.sh

# Custom PIN (auto-generates secure PIN if not provided)
./roles/dumbassets/deploy.sh -p 5678

# Full customization
./roles/dumbassets/deploy.sh \
  -p secure123 \
  -t "My Asset Tracker" \
  -c EUR \
  -z "Europe/Berlin" \
  -n "discord://webhook_url"

# Demo mode
./roles/dumbassets/deploy.sh -d -p demo123
```

## Automatic Integrations

The role automatically integrates with all homelab services:

### Infrastructure
- **Traefik**: SSL/TLS termination and routing
- **Docker**: Container management and networking
- **UFW**: Firewall rules

### Monitoring
- **Prometheus**: Metrics collection
- **Grafana**: Dashboards and visualization
- **Loki**: Centralized logging
- **Alertmanager**: Alert routing

### Security
- **Fail2Ban**: Intrusion prevention
- **Container Security**: Read-only filesystem, no-new-privileges
- **SSL/TLS**: Automatic certificate management

### Management
- **Homepage**: Dashboard integration
- **Backup**: Automated backup procedures
- **Health Checks**: Service monitoring

## Validation and Safety

### Pre-Deployment Validation

The role includes comprehensive validation:

- Configuration variable checks
- Port availability verification
- Directory permission validation
- Dependency verification (Traefik, etc.)

### Post-Deployment Validation

- Service health checks
- Web interface accessibility
- API endpoint verification
- Integration testing
- Log analysis

### Safety Features

- **Backup before changes**: Automatic backup creation
- **Rollback capability**: Easy service restoration
- **Conflict detection**: Port and resource conflict prevention
- **Error handling**: Comprehensive error recovery

## Troubleshooting

### Common Issues

1. **Port Conflicts**: Change `DUMBASSETS_PORT` or `DUMBASSETS_EXTERNAL_PORT`
2. **Permission Issues**: Ensure Docker directories are accessible
3. **Network Issues**: Verify Traefik is running and configured
4. **PIN Issues**: Ensure PIN is at least 4 characters long

### Validation Commands

```bash
# Check service status
docker ps dumbassets

# View logs
docker logs dumbassets

# Test connectivity
curl -f http://localhost:3004/health

# Check configuration
docker exec dumbassets cat /app/config/config.json
```

### Recovery

```bash
# Restart service
docker restart dumbassets

# Restore from backup
docker exec dumbassets /app/scripts/restore.sh backup_file.tar.gz

# Complete redeployment
ansible-playbook site.yml --tags dumbassets
```

## Best Practices

### Security
1. **Always change the default PIN** after deployment
2. **Use strong PINs** (8+ characters recommended)
3. **Enable backup encryption** for sensitive data
4. **Monitor logs** for security events

### Configuration
1. **Use environment variables** for customization
2. **Test in staging** before production
3. **Document custom configurations**
4. **Regular updates** using the role's update mechanisms

### Operations
1. **Enable monitoring** for proactive management
2. **Regular backups** with verification
3. **Health check monitoring** for service availability
4. **Log rotation** for storage management

## Migration from Manual Configuration

If you have existing manual configurations:

1. **Export current settings** as environment variables
2. **Run the seamless deployment** with your variables
3. **Verify functionality** matches your previous setup
4. **Remove manual configurations** from group_vars

## Support and Documentation

- **Configuration Guide**: `CONFIGURATION.md` - Complete environment variable reference
- **README**: `README.md` - Role overview and usage
- **Deployment Script**: `deploy.sh` - Easy deployment with customization
- **Templates**: All templates include comprehensive documentation

## Conclusion

The DumbAssets role now provides a truly seamless deployment experience with:

- ✅ **Zero-configuration deployment** with sensible defaults
- ✅ **Environment variable overrides** for all settings
- ✅ **Automatic integration** with homelab services
- ✅ **Comprehensive validation** and error handling
- ✅ **Easy customization** through deployment script
- ✅ **Production-ready** security and monitoring

This makes it perfect for both quick testing and production deployments without requiring manual configuration. 