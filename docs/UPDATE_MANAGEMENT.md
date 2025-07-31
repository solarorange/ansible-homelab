# Update Management Guide

## Overview

Your Ansible homelab stack includes a comprehensive update management system with both automated and manual update capabilities. This guide explains how to use and maintain your update infrastructure.

## Current Update Infrastructure

### 1. Automated Updates (Already Running)

#### Watchtower Container Updates
- **Service**: `containrrr/watchtower`
- **Schedule**: Daily at 4 AM (`0 4 * * *`)
- **Location**: `roles/automation/container_management/tasks/main.yml`
- **Features**:
  - Automatic Docker image updates
  - Cleanup of old images
  - Configurable logging levels
  - Integration with monitoring stack

#### Automated Maintenance
- **Schedule**: Daily at 3 AM (`0 3 * * *`)
- **Location**: `roles/automation/scheduling/tasks/main.yml`
- **Features**:
  - System optimization
  - Docker maintenance (`docker system prune`)
  - Logged operations
  - Systemd timer management

#### Service-Specific Schedules
- **Media services**: Weekly updates (`0 4 * * 0`)
- **Paperless-ngx**: Weekly updates (`0 4 * * 0`)
- **Immich**: Weekly updates (`0 4 * * 0`)

### 2. Manual Update Script

The `scripts/update_stack.sh` script provides manual update capabilities and status monitoring.

## Usage

### Quick Commands

```bash
# Show current stack status
./scripts/update_stack.sh

# Check for available updates
./scripts/update_stack.sh check

# Update Docker images manually
./scripts/update_stack.sh docker

# Update Ansible playbook from git
./scripts/update_stack.sh playbook

# Update system packages
./scripts/update_stack.sh system

# Force Watchtower manual update
./scripts/update_stack.sh watchtower

# Run Ansible playbook update
./scripts/update_stack.sh ansible

# Run all updates
./scripts/update_stack.sh all
```

### Detailed Usage

#### 1. Status Check
```bash
./scripts/update_stack.sh status
```
Shows:
- Docker container status
- Watchtower status
- Systemd timers status
- Recent update logs

#### 2. Update Check
```bash
./scripts/update_stack.sh check
```
Checks for:
- Docker image updates
- Ansible playbook updates (git)
- System package updates

#### 3. Manual Docker Updates
```bash
./scripts/update_stack.sh docker
```
- Creates backup before updates
- Pulls latest images for all containers
- Restarts containers with new images
- Cleans up old images

#### 4. Playbook Updates
```bash
./scripts/update_stack.sh playbook
```
- Stashes local changes
- Pulls latest changes from git
- Reapplies stashed changes

#### 5. System Updates
```bash
./scripts/update_stack.sh system
```
- Updates system packages (apt/dnf)
- Removes old packages
- Cleans package cache

## Best Practices

### 1. Update Frequency

#### Recommended Schedule
- **Critical Services**: Weekly manual updates
- **Media Services**: Weekly automated updates
- **System Packages**: Monthly manual updates
- **Ansible Playbook**: As needed (when new features/fixes are available)

#### Automated vs Manual
- **Automated**: Use for routine, low-risk updates
- **Manual**: Use for major updates, testing, or troubleshooting

### 2. Update Process

#### Before Updates
1. Check current status: `./scripts/update_stack.sh status`
2. Check for updates: `./scripts/update_stack.sh check`
3. Review update logs: `tail -f logs/stack_updates.log`
4. Ensure backups are current

#### During Updates
1. Monitor the update process
2. Check service health after updates
3. Verify critical services are running
4. Review logs for any errors

#### After Updates
1. Validate all services are working
2. Test critical functionality
3. Update documentation if needed
4. Clean up old backups (older than 30 days)

### 3. Monitoring and Alerting

#### Log Monitoring
- **Location**: `logs/stack_updates.log`
- **Rotation**: Automatic via logrotate
- **Retention**: 30 days

#### Health Checks
```bash
# Check service health
docker ps --format "table {{.Names}}\t{{.Status}}"

# Check specific service logs
docker logs <service_name> --tail=50

# Check system resources
htop
df -h
```

### 4. Troubleshooting

#### Common Issues

**Docker Update Failures**
```bash
# Check Docker daemon
systemctl status docker

# Check disk space
df -h

# Check Docker logs
journalctl -u docker -f
```

**Ansible Update Failures**
```bash
# Check git status
git status

# Check for conflicts
git diff

# Reset to clean state
git reset --hard origin/main
```

**Service Startup Failures**
```bash
# Check service logs
docker logs <service_name>

# Check configuration
docker exec <service_name> cat /config/config.yml

# Restart service
docker restart <service_name>
```

#### Recovery Procedures

**Rollback Docker Updates**
```bash
# List available images
docker images

# Rollback to previous image
docker tag <previous_image> <current_image>
docker restart <container_name>
```

**Rollback Ansible Changes**
```bash
# Revert to previous commit
git log --oneline -5
git reset --hard <previous_commit>

# Reapply playbook
ansible-playbook main.yml --tags rollback
```

## Configuration

### Update Schedules

#### Current Configuration
```yaml
# roles/automation/defaults/main.yml
container_updater_schedule: "0 4 * * *"  # Daily at 4 AM
container_updater_log_level: "info"
container_updater_cleanup: true

# Service-specific schedules
media_update_schedule: "0 4 * * 0"  # Weekly at 4 AM on Sunday
paperless_ngx_update_schedule: "0 4 * * 0"
immich_update_schedule: "0 4 * * 0"
```

#### Customizing Schedules
1. Edit `group_vars/all/common.yml` for global settings
2. Edit role defaults for service-specific settings
3. Restart affected services after changes

### Update Policies

#### Selective Updates
```bash
# Update specific service only
docker pull <service_image>
docker restart <service_container>

# Update specific service group
ansible-playbook main.yml --tags media
```

#### Update Notifications
- Configure alerting in Grafana
- Set up email notifications
- Use Discord/Slack webhooks

## Integration with Existing Automation

### 1. Watchtower Integration
The manual update script works alongside Watchtower:
- Manual updates don't interfere with automated updates
- Watchtower continues to run on schedule
- Both systems log to the same location

### 2. Ansible Integration
```bash
# Run playbook with update tags
ansible-playbook main.yml --tags update

# Run specific service updates
ansible-playbook main.yml --tags sonarr,radarr

# Run validation after updates
ansible-playbook main.yml --tags validate
```

### 3. Monitoring Integration
- Updates are logged to `logs/stack_updates.log`
- Prometheus metrics track update success/failure
- Grafana dashboards show update history
- AlertManager sends notifications for failures

## Security Considerations

### 1. Update Verification
- Verify image signatures when possible
- Use trusted image sources
- Review changelogs before major updates

### 2. Backup Strategy
- Automatic backups before updates
- Test backup restoration procedures
- Maintain multiple backup locations

### 3. Access Control
- Limit update permissions to authorized users
- Use SSH keys for remote access
- Monitor update activities

## Maintenance

### 1. Regular Tasks
- Review update logs weekly
- Clean up old backups monthly
- Update documentation as needed
- Test recovery procedures quarterly

### 2. Performance Optimization
- Monitor update impact on system performance
- Schedule updates during low-usage periods
- Use staggered updates for large deployments

### 3. Documentation Updates
- Keep this guide current
- Document any custom procedures
- Maintain troubleshooting guides

## Support

### Getting Help
1. Check the logs: `tail -f logs/stack_updates.log`
2. Review this documentation
3. Check service-specific documentation
4. Search existing issues in the repository

### Contributing
- Report bugs with detailed logs
- Suggest improvements to the update process
- Contribute to documentation updates
- Test new features before deployment

---

**Note**: This update management system is designed to work seamlessly with your existing automation while providing manual control when needed. The automated updates handle routine maintenance, while the manual script provides flexibility for testing, troubleshooting, and major updates. 