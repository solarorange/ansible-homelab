# Backup Orchestration System

## Overview

The backup orchestration system implements a **staggered backup schedule** to eliminate resource contention and improve backup reliability. Instead of all services backing up at the same time (3:00 AM), services are now distributed across a 7-hour window from 1:00 AM to 7:00 AM.

## Problem Solved

### Before (All at 3:00 AM)
- **Resource Contention**: 20+ services competing for CPU, memory, and I/O
- **Backup Failures**: Services timing out or failing due to resource exhaustion
- **Poor Performance**: System becomes unresponsive during backup window
- **Difficult Troubleshooting**: Hard to identify which service caused issues

### After (Staggered Schedule)
- **Reduced Contention**: Maximum 3-6 services backing up simultaneously
- **Better Reliability**: Each service has dedicated resources
- **Improved Performance**: System remains responsive
- **Easier Monitoring**: Clear visibility into backup status

## New Backup Schedule

### 1:00 AM - Critical Services
Essential infrastructure services that must backup first:
- **00:01** - Authentik (Authentication)
- **05:01** - Traefik (Reverse Proxy)
- **10:01** - Vault (Secrets Management)
- **15:01** - PostgreSQL (Database)
- **20:01** - MariaDB (Database)
- **25:01** - Redis (Cache)

### 2:00 AM - High Priority Services
Important services with moderate data:
- **00:02** - Home Assistant (Home Automation)
- **05:02** - Zigbee2MQTT (IoT Bridge)
- **10:02** - Mosquitto (MQTT Broker)
- **15:02** - InfluxDB (Time Series Database)
- **20:02** - Telegraf (Metrics Collection)

### 3:00 AM - Media Core Services
Core media management applications:
- **00:03** - Sonarr (TV Shows)
- **05:03** - Radarr (Movies)
- **10:03** - Lidarr (Music)
- **15:03** - Readarr (Books)
- **20:03** - Prowlarr (Indexers)
- **25:03** - Bazarr (Subtitles)

### 4:00 AM - Media Download Services
Download and processing applications:
- **00:04** - qBittorrent (BitTorrent Client)
- **05:04** - Sabnzbd (Usenet Client)
- **10:04** - Tdarr (Media Transcoding)
- **15:04** - Komga (Comic Books)
- **20:04** - Audiobookshelf (Audiobooks)

### 5:00 AM - Media Playback Services
Streaming and playback applications:
- **00:05** - Jellyfin (Media Server)
- **05:05** - Emby (Media Server)
- **10:05** - Tautulli (Statistics)
- **15:05** - Overseerr (Request Management)

### 6:00 AM - File Services
File storage and sharing applications:
- **00:06** - Nextcloud (File Storage)
- **05:06** - Samba (File Sharing)
- **10:06** - Syncthing (File Sync)
- **15:06** - Paperless-ngx (Document Management)
- **20:06** - Immich (Photo Management)

### 7:00 AM - Utility Services
Monitoring and utility applications:
- **00:07** - Portainer (Container Management)
- **05:07** - Grafana (Monitoring Dashboards)
- **10:07** - Prometheus (Metrics Collection)
- **15:07** - Loki (Log Aggregation)
- **20:07** - Alertmanager (Alert Management)
- **25:07** - Pi-hole (DNS/Ad Blocking)

## Backup Dependencies

The system ensures services backup in the correct order:

```yaml
dependencies:
  sonarr:
    depends_on: ["postgresql", "qbittorrent"]
  radarr:
    depends_on: ["postgresql", "qbittorrent"]
  jellyfin:
    depends_on: ["postgresql", "sonarr", "radarr"]
  nextcloud:
    depends_on: ["postgresql", "redis"]
```

## Resource Management

### Limits
- **Max Concurrent Backups**: 3
- **Max Backup Duration**: 120 minutes
- **Max Backup Size**: 50 GB
- **Backup Timeout**: 30 minutes

### Monitoring
- **CPU Threshold**: 80%
- **Memory Threshold**: 80%
- **Disk Threshold**: 90%
- **I/O Threshold**: 80%

## Installation

### 1. Deploy the Backup Orchestration
```bash
ansible-playbook site.yml --tags backup,orchestration
```

### 2. Update Existing Schedules
```bash
ansible-playbook site.yml --tags backup,schedules
```

### 3. Test the System
```bash
./scripts/test_backup_orchestration.sh
```

## Configuration

### Main Configuration File
Location: `{{ backup_dir }}/orchestration/config.yml`

Key settings:
```yaml
resource_limits:
  max_concurrent_backups: 3
  max_backup_duration_minutes: 120
  max_backup_size_gb: 50
  backup_timeout_minutes: 30

monitoring:
  enabled: true
  check_interval_minutes: 30
  alert_on_failure: true
  alert_on_timeout: true
```

### Customizing Schedules
Edit `group_vars/all/vars.yml`:
```yaml
backup_schedules:
  sonarr: "0 3 * * *"  # Change to desired time
  radarr: "5 3 * * *"  # Change to desired time
```

## Monitoring and Logs

### Log Locations
- **Orchestrator Logs**: `{{ backup_dir }}/orchestration/logs/orchestrator.log`
- **Service Logs**: `{{ backup_dir }}/orchestration/logs/{service}_backup.log`
- **Resource Monitor**: `{{ backup_dir }}/orchestration/logs/resource_monitor.log`
- **Status Tracker**: `{{ backup_dir }}/orchestration/logs/status_tracker.log`

### Status Files
- **Service Status**: `{{ backup_dir }}/orchestration/status/{service}.status`
- **Process IDs**: `{{ backup_dir }}/orchestration/status/{service}.pid`
- **Start Times**: `{{ backup_dir }}/orchestration/status/{service}.started`

### Viewing Logs
```bash
# View orchestrator logs
tail -f {{ backup_dir }}/orchestration/logs/orchestrator.log

# View specific service logs
tail -f {{ backup_dir }}/orchestration/logs/sonarr_backup.log

# Check backup status
ls -la {{ backup_dir }}/orchestration/status/
```

## Manual Operations

### Run Backup Orchestration Manually
```bash
{{ backup_dir }}/orchestration/backup_orchestrator.sh
```

### Check Resource Usage
```bash
{{ backup_dir }}/orchestration/resource_monitor.sh
```

### Verify Dependencies
```bash
{{ backup_dir }}/orchestration/dependency_checker.sh sonarr
```

### Clean Up Old Backups
```bash
{{ backup_dir }}/orchestration/cleanup.sh
```

## Troubleshooting

### Common Issues

#### 1. Backup Not Starting
**Symptoms**: Service backup doesn't start at scheduled time
**Check**:
- Verify cron job exists: `crontab -l | grep service_name`
- Check orchestrator logs: `tail -f {{ backup_dir }}/orchestration/logs/orchestrator.log`
- Verify service is running: `docker ps | grep service_name`

#### 2. Backup Timing Out
**Symptoms**: Backup runs longer than expected
**Check**:
- Resource usage: `{{ backup_dir }}/orchestration/resource_monitor.sh`
- Service logs: `tail -f {{ backup_dir }}/orchestration/logs/{service}_backup.log`
- Adjust timeout in config if needed

#### 3. Dependency Issues
**Symptoms**: Service backup fails due to missing dependencies
**Check**:
- Dependency status: `{{ backup_dir }}/orchestration/dependency_checker.sh service_name`
- Ensure dependent services completed successfully

#### 4. Resource Contention
**Symptoms**: High CPU/memory usage during backups
**Check**:
- Current resource usage: `top`, `free`, `df`
- Adjust resource limits in config
- Consider moving some services to different time slots

### Debug Mode
Enable debug logging by editing the orchestrator script:
```bash
# Add debug output
set -x
```

## Benefits

### 1. Reliability
- **Reduced Failures**: Less resource contention means fewer timeouts
- **Better Dependencies**: Services wait for dependencies to complete
- **Resource Monitoring**: Automatic throttling when resources are high

### 2. Performance
- **System Responsiveness**: System remains usable during backups
- **Faster Backups**: Each service has dedicated resources
- **Better I/O**: Reduced disk contention

### 3. Monitoring
- **Clear Visibility**: Easy to see which backups are running
- **Status Tracking**: Real-time status of all backup operations
- **Logging**: Comprehensive logging for troubleshooting

### 4. Maintenance
- **Easier Troubleshooting**: Clear separation of backup operations
- **Flexible Scheduling**: Easy to adjust timing for specific services
- **Resource Management**: Automatic resource monitoring and throttling

## Migration from Old System

### Before Migration
1. **Document Current Schedule**: Note which services currently backup at 3:00 AM
2. **Test New System**: Run test backup orchestration on non-production system
3. **Backup Current Configuration**: Save current cron jobs and backup scripts

### During Migration
1. **Deploy Orchestration**: Run the Ansible playbook with backup tags
2. **Update Schedules**: Apply the new staggered schedule
3. **Test Each Time Slot**: Verify backups work in their new time slots

### After Migration
1. **Monitor First Week**: Watch for any issues with the new schedule
2. **Adjust Timing**: Fine-tune timing if needed
3. **Set Up Notifications**: Configure alerts for backup failures

## Future Enhancements

### Planned Features
- **Web Dashboard**: Web interface for monitoring backup status
- **Email Notifications**: Automatic email alerts for backup failures
- **Backup Verification**: Automatic verification of backup integrity
- **Cloud Integration**: Support for cloud backup destinations
- **Backup Compression**: Automatic compression of backup files

### Customization Options
- **Service-Specific Settings**: Different retention policies per service
- **Weekend Schedules**: Extended backup windows on weekends
- **Holiday Schedules**: Special backup schedules for holidays
- **Bandwidth Throttling**: Limit backup bandwidth during peak hours

## Support

For issues or questions about the backup orchestration system:

1. **Check Logs**: Review the log files in `{{ backup_dir }}/orchestration/logs/`
2. **Run Test Script**: Execute `./scripts/test_backup_orchestration.sh`
3. **Review Documentation**: Check this document and related Ansible playbooks
4. **Community Support**: Post issues in the project repository

---

*Last Updated: $6/21/25*
*Version: 1.0* 