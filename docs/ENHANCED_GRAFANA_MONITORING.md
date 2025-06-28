# Enhanced Grafana Monitoring System for Homelab

## Overview

This document outlines the comprehensive Grafana monitoring system implemented for the homelab infrastructure. The system includes six specialized dashboards, comprehensive alert rules, and multiple notification channels to provide complete visibility into the homelab environment.

## Dashboard Overview

### 1. Homelab Overview Dashboard
**File**: `roles/grafana/templates/dashboards/homelab-overview.json.j2`

**Purpose**: High-level system health and performance overview

**Key Features**:
- System health percentage across all services
- Active alerts count with severity filtering
- CPU, Memory, and Disk usage across all instances
- Network traffic and Docker container statistics
- Service status overview
- Time series graphs for resource usage trends
- Alert history by severity level
- Service response times

**Variables**:
- Instance selection (multi-select)
- Service filtering (multi-select)
- Container filtering (multi-select)
- Alert severity filtering
- Datacenter and environment selection
- Service category filtering
- Time range selection

**Annotations**:
- Service deployments
- Active alerts
- Backup events
- Security events
- System updates
- Container events
- SSL certificate events
- Network interface changes

### 2. Docker Services Dashboard
**File**: `roles/grafana/templates/dashboards/docker-services.json.j2`

**Purpose**: Comprehensive container monitoring and management

**Key Features**:
- Container count by state (running, exited, created, paused)
- Total CPU and Memory usage across containers
- Container restart tracking
- Top CPU and Memory consumers
- Container health status monitoring
- Network and Disk I/O per container
- Container restart history

**Variables**:
- Container selection (multi-select)
- Container state filtering
- Service category filtering
- Instance selection
- Time range selection

**Annotations**:
- Container restarts
- Container OOM events
- High memory usage alerts
- High CPU usage alerts
- Container health check failures

### 3. Media Stack Dashboard
**File**: `roles/grafana/templates/dashboards/media-stack.json.j2`

**Purpose**: Media services monitoring and performance tracking

**Key Features**:
- Media services health overview
- Total media library size
- Active downloads count
- Plex streams monitoring
- Service status for all media applications
- Library statistics by media type
- Download and processing activity trends
- Error rates for media services
- Disk usage for media storage
- Quality distribution analysis

**Variables**:
- Media service selection (Plex, Sonarr, Radarr, Bazarr, etc.)
- Instance filtering
- Media type filtering
- Quality profile selection
- Time range selection

**Annotations**:
- Media downloads
- Media processing events
- Plex activity
- Service errors
- Disk space warnings

### 4. Security Monitoring Dashboard
**File**: `roles/grafana/templates/dashboards/security-monitoring.json.j2`

**Purpose**: Security threats and authentication monitoring

**Key Features**:
- Security services health overview
- Active threats count
- Failed login attempt rates
- Banned IP addresses count
- Security service status
- SSL certificate expiry monitoring
- Threat activity trends
- Authentication failure trends
- IP ban activity
- Traefik security events
- Threat distribution by severity
- Top attack sources

**Variables**:
- Security service selection (CrowdSec, Fail2Ban, Authentik, etc.)
- Threat level filtering
- Instance selection
- Attack type filtering
- Time range selection

**Annotations**:
- Security threats
- Failed login attempts
- IP bans
- SSL certificate expiry
- Traefik security events

### 5. Network & Infrastructure Dashboard
**File**: `roles/grafana/templates/dashboards/network-infrastructure.json.j2`

**Purpose**: Network performance and infrastructure monitoring

**Key Features**:
- Network services health overview
- Total network traffic monitoring
- Traefik request rates
- DNS query rates
- Network service status
- Network interface status
- Network traffic trends
- Traefik request rate trends
- DNS query rate trends
- Network latency monitoring
- Traefik response code distribution
- Top DNS queries

**Variables**:
- Network service selection (Traefik, Pi-hole, WireGuard, etc.)
- Instance filtering
- Network interface selection
- Protocol filtering
- Time range selection

**Annotations**:
- Network interface changes
- High network usage
- Traefik request events
- DNS query activity
- VPN connection changes

### 6. Backup & Storage Dashboard
**File**: `roles/grafana/templates/dashboards/backup-storage.json.j2`

**Purpose**: Backup job monitoring and storage management

**Key Features**:
- Backup success rate calculation
- Total storage usage
- Storage utilization percentages
- Backup size monitoring
- Backup job status
- Filesystem status
- Backup activity trends
- Storage usage trends
- Disk I/O activity
- Backup size trends
- Storage distribution analysis
- Backup job details

**Variables**:
- Backup job selection
- Storage device filtering
- Filesystem type filtering
- Mount point selection
- Time range selection

**Annotations**:
- Backup events
- Backup failures
- Low disk space warnings
- High disk I/O alerts
- Storage errors

## Alert Rules Configuration

### Critical Alerts
**File**: `roles/grafana/templates/alert-rules.yml.j2`

**Service Down Alerts**:
- ServiceDown: Service not responding for 5+ minutes
- DockerServiceDown: Docker daemon not responding
- TraefikDown: Reverse proxy not responding
- DatabaseDown: Database services not responding

**Resource Usage Alerts**:
- HighCPUUsage: CPU usage above 90% for 10+ minutes
- HighMemoryUsage: Memory usage above 95% for 5+ minutes
- HighDiskUsage: Disk usage above 95% for 5+ minutes

**SSL Certificate Alerts**:
- SSLCertificateExpiringSoon: Certificates expiring within 7 days

**Backup Alerts**:
- BackupFailed: Backup job failures
- BackupTooOld: No successful backup in 24 hours

**Security Alerts**:
- HighSecurityThreats: Critical security threats detected
- MultipleFailedLogins: High rate of failed login attempts

**Network Alerts**:
- NetworkInterfaceDown: Network interface down
- HighNetworkLatency: Network latency above 0.5 seconds

### Warning Alerts
**Service Health Alerts**:
- ServiceUnhealthy: Service health checks failing
- ContainerRestarting: Container restart events
- ContainerHighMemory: Container memory usage above 85%

**Resource Usage Warnings**:
- HighCPUUsageWarning: CPU usage above 80% for 15+ minutes
- HighMemoryUsageWarning: Memory usage above 85% for 10+ minutes
- HighDiskUsageWarning: Disk usage above 85% for 10+ minutes

**Performance Alerts**:
- HighResponseTime: 95th percentile response time above 5 seconds
- HighErrorRate: Error rate above 5%

**SSL Certificate Warnings**:
- SSLCertificateExpiringWarning: Certificates expiring within 30 days

**Security Warnings**:
- HighFailedLogins: Failed login attempts above 10/second
- SecurityThreatsDetected: High security threats detected

**Backup Warnings**:
- BackupSlow: Backup running for more than 1 hour
- BackupSizeIncreased: Backup size increased by 50% in 24 hours

**Media Stack Warnings**:
- MediaServiceHighQueue: Queue size above 50 items
- MediaDownloadSlow: Download speed below 1 MB/s

**Network Warnings**:
- HighNetworkLatencyWarning: Network latency above 0.1 seconds
- DNSQuerySlow: DNS query time above 0.5 seconds

### Info Alerts
**Information Notifications**:
- ServiceDeployed: Service deployment events
- BackupCompleted: Successful backup completions
- MediaDownloadCompleted: Media download completions
- SSLCertificateRenewed: SSL certificate renewals

## Notification Channels

### Email Notifications
- **Critical Alerts**: Immediate notification with detailed information
- **Warning Alerts**: 5-minute frequency with service details
- **Info Alerts**: 15-minute frequency for informational purposes

### Discord Notifications
- Rich embed messages with color coding
- Service-specific information
- Dashboard links for quick access
- Username and avatar customization

### Slack Notifications
- Channel-specific notifications
- Color-coded messages by severity
- Service and instance information
- Dashboard and runbook links

### Telegram Notifications
- HTML-formatted messages
- Bot token and chat ID configuration
- Service-specific details
- Direct dashboard links

### Webhook Notifications
- Custom webhook endpoints
- JSON payload with alert details
- Configurable HTTP methods
- Service integration support

### Push Notifications
- Mobile push notifications
- Custom notification service integration
- Alert summary and details
- Quick action support

## Dashboard Features

### Responsive Design
- Mobile-friendly layouts
- Adaptive panel sizing
- Touch-optimized controls
- Responsive grid system

### Theme Support
- Dark theme (default)
- Light theme support
- Custom color schemes
- Consistent styling across dashboards

### Interactive Panels
- Drill-down capabilities
- Panel-specific filtering
- Dynamic query updates
- Real-time data refresh

### Time Range Selectors
- Custom time ranges (1h, 6h, 12h, 24h, 7d, 30d)
- Relative time options
- Quick time presets
- Manual time input

### Variable Support
- Multi-select variables
- Query-based variables
- Custom variable lists
- Dynamic variable updates

### Annotations
- Event-based annotations
- Service deployment markers
- Alert correlation
- Historical event tracking

### Export Capabilities
- Dashboard export (JSON)
- Panel export (PNG, PDF)
- Data export (CSV, JSON)
- Sharing capabilities

## Integration Links

Each dashboard includes navigation links to:
- Related dashboards
- Service management interfaces
- Documentation pages
- External monitoring tools
- Quick action shortcuts

## Deployment Configuration

### Grafana Configuration
- **Theme**: Dark theme by default
- **Timezone**: Configurable (default: UTC)
- **Refresh Rate**: 30 seconds by default
- **Auto-refresh**: Configurable intervals

### Data Sources
- **Prometheus**: Primary metrics source
- **Loki**: Log aggregation
- **InfluxDB**: Time series data (optional)

### Provisioning
- **Dashboards**: Auto-provisioned from templates
- **Data Sources**: Pre-configured connections
- **Alert Rules**: Prometheus alertmanager integration
- **Notification Channels**: Pre-configured templates

## Monitoring Metrics

### System Metrics
- CPU, Memory, Disk usage
- Network traffic and latency
- Service health and status
- Container performance

### Application Metrics
- Media service performance
- Security threat detection
- Network service health
- Backup job status

### Business Metrics
- Service availability
- Response times
- Error rates
- Resource utilization

## Best Practices

### Dashboard Design
- Consistent layout and styling
- Logical panel grouping
- Clear visual hierarchy
- Meaningful thresholds

### Alert Configuration
- Appropriate severity levels
- Reasonable thresholds
- Actionable notifications
- Proper escalation paths

### Performance Optimization
- Efficient queries
- Appropriate refresh rates
- Resource-conscious panels
- Optimized data retention

## Maintenance

### Regular Tasks
- Review and update thresholds
- Validate alert effectiveness
- Update dashboard queries
- Monitor system performance

### Updates
- Dashboard template updates
- Alert rule modifications
- Notification channel changes
- Integration improvements

## Troubleshooting

### Common Issues
- Missing metrics
- Alert false positives
- Dashboard loading issues
- Notification failures

### Resolution Steps
- Verify data source connectivity
- Check metric availability
- Validate alert expressions
- Test notification channels

## Conclusion

This enhanced Grafana monitoring system provides comprehensive visibility into the homelab infrastructure with specialized dashboards for different service categories, comprehensive alerting, and multiple notification channels. The system is designed to be scalable, maintainable, and user-friendly while providing the necessary insights for effective homelab management. 