# Grafana Automation System

## Overview

This comprehensive Ansible automation system provides complete Grafana deployment and configuration for homelab environments. It includes pre-configured dashboards, data sources, users, alerts, and monitoring setup with full integration into the existing monitoring stack.

## Features

### Core Functionality
- **Automated Deployment**: Docker-based Grafana deployment with proper configuration
- **Data Source Configuration**: Pre-configured Prometheus, Loki, PostgreSQL, Redis, and custom data sources
- **Dashboard Management**: Import and customize dashboards for all homelab services
- **User Management**: Create users, teams, and configure permissions
- **Alerting System**: Comprehensive alert rules and notification channels
- **Theme Configuration**: Dark theme and custom styling
- **Health Monitoring**: Built-in health checks and monitoring

### Dashboard Categories
1. **System Overview**: CPU, Memory, Disk, Network monitoring
2. **Service Monitoring**: Docker containers, service health, response times
3. **Media Services**: Sonarr/Radarr, Jellyfin, download monitoring
4. **Security Monitoring**: Authentication, firewall, intrusion detection
5. **Network & Infrastructure**: Traefik, SSL certificates, DNS health
6. **Database Monitoring**: PostgreSQL, Redis, MariaDB metrics
7. **Storage Monitoring**: File systems, backups, cloud storage

### Data Sources
- **Prometheus**: Metrics collection and storage
- **Loki**: Log aggregation and querying
- **PostgreSQL**: Database metrics and performance
- **Redis**: Cache metrics and performance
- **Node Exporter**: System metrics
- **Custom Homelab Metrics**: Service-specific metrics

### Alerting Configuration
- High resource usage alerts (CPU, Memory, Disk)
- Service down notifications
- Security event alerts
- Backup failure notifications
- SSL certificate expiration warnings
- Database connection issues

## Architecture

### File Structure
```
roles/grafana/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   ├── main.yml              # Main orchestration
│   ├── deploy.yml            # Deployment tasks
│   ├── datasources.yml       # Data source configuration
│   ├── dashboards.yml        # Dashboard management
│   ├── users.yml             # User and permission management
│   ├── alerts.yml            # Alert configuration
│   ├── monitoring.yml        # Health monitoring
│   ├── backup.yml            # Backup configuration
│   └── validation.yml        # Validation tasks
├── templates/
│   ├── docker-compose.yml.j2 # Docker Compose configuration
│   ├── grafana.ini.j2        # Grafana configuration
│   ├── datasources.yml.j2    # Data sources provisioning
│   ├── dashboards.yml.j2     # Dashboards provisioning
│   └── dashboards/
│       ├── system-overview.json.j2
│       ├── services.json.j2
│       ├── security.json.j2
│       ├── media.json.j2
│       ├── network.json.j2
│       ├── databases.json.j2
│       └── storage.json.j2
├── handlers/
│   └── main.yml              # Service handlers
└── scripts/
    └── setup_grafana.py      # Python configuration script
```

### Python Configuration Script

The `setup_grafana.py` script provides comprehensive Grafana configuration via REST API:

#### Features
- **Data Source Management**: Create, update, and validate data sources
- **Dashboard Provisioning**: Import dashboards and organize into folders
- **User Management**: Create users and assign roles
- **Team Management**: Create teams and manage members
- **Alert Configuration**: Setup notification channels and alert rules
- **Health Monitoring**: Validate all components

#### Usage
```bash
# Basic setup
python3 setup_grafana.py \
  --url http://localhost:3000 \
  --username admin \
  --password admin \
  --config-dir config

# With custom options
python3 setup_grafana.py \
  --url https://grafana.example.com \
  --username admin \
  --password secure_password \
  --config-dir /path/to/config \
  --timeout 60 \
  --no-verify-ssl
```

## Configuration

### Variables

#### Core Configuration
```yaml
# Grafana Application Settings
grafana_enabled: true
grafana_version: "10.2.0"
grafana_image: "grafana/grafana-oss:{{ grafana_version }}"
grafana_container_name: "grafana"
grafana_port: 3000
grafana_admin_user: "admin"
grafana_admin_password: "{{ vault_grafana_admin_password }}"
grafana_secret_key: "{{ vault_grafana_secret_key }}"
grafana_domain: "grafana.{{ domain }}"

# Database Configuration
grafana_database_type: "sqlite3"  # sqlite3, mysql, postgres
grafana_database_host: "localhost"
grafana_database_name: "grafana"
grafana_database_user: "grafana"
grafana_database_password: "{{ vault_grafana_db_password }}"
```

#### Data Sources Configuration
```yaml
grafana_datasources:
  prometheus:
    enabled: true
    name: "Prometheus"
    type: "prometheus"
    url: "http://prometheus:9090"
    access: "proxy"
    is_default: true
    editable: true
    json_data:
      timeInterval: "15s"
      queryTimeout: "60s"
      httpMethod: "POST"
    secure_json_data: {}
    
  loki:
    enabled: true
    name: "Loki"
    type: "loki"
    url: "http://loki:3100"
    access: "proxy"
    is_default: false
    editable: true
    json_data:
      maxLines: 1000
    secure_json_data: {}
```

#### Dashboard Configuration
```yaml
grafana_dashboards_enabled: true
grafana_dashboard_auto_refresh: "30s"
grafana_dashboard_timezone: "{{ timezone | default('UTC') }}"
grafana_dashboard_theme: "dark"

grafana_dashboard_folders:
  - name: "System Overview"
    description: "System-level monitoring dashboards"
    uid: "system-overview"
  - name: "Services"
    description: "Service-specific dashboards"
    uid: "services"
  - name: "Security"
    description: "Security monitoring dashboards"
    uid: "security"
```

#### Alerting Configuration
```yaml
grafana_alerting_enabled: true
grafana_alerting_execution_timeout: "30s"
grafana_alerting_evaluation_timeout: "30s"
grafana_alerting_max_attempts: 3

grafana_notification_channels:
  email:
    enabled: true
    name: "Email"
    type: "email"
    settings:
      addresses: "admin@{{ domain }}"
    is_default: true
    
  slack:
    enabled: false
    name: "Slack"
    type: "slack"
    settings:
      url: "{{ vault_slack_webhook_url }}"
    is_default: false

grafana_alert_rules:
  high_cpu:
    enabled: true
    name: "High CPU Usage"
    condition: "avg(rate(node_cpu_seconds_total{mode!='idle'}[5m])) * 100 > 90"
    for: "5m"
    severity: "critical"
```

## Usage

### Basic Deployment
```yaml
# Include in your playbook
- hosts: monitoring
  roles:
    - grafana
```

### Custom Configuration
```yaml
# Customize Grafana deployment
- hosts: monitoring
  vars:
    grafana_admin_password: "{{ vault_secure_password }}"
    grafana_datasources:
      prometheus:
        enabled: true
        url: "http://prometheus:9090"
      loki:
        enabled: true
        url: "http://loki:3100"
    grafana_dashboard_categories:
      system_overview:
        enabled: true
        folder: "System Overview"
      security:
        enabled: true
        folder: "Security"
  roles:
    - grafana
```

### Advanced Configuration
```yaml
# Advanced Grafana setup
- hosts: monitoring
  vars:
    grafana_database_type: "postgres"
    grafana_database_host: "postgresql"
    grafana_database_name: "grafana"
    grafana_database_user: "grafana"
    grafana_database_password: "{{ vault_grafana_db_password }}"
    
    grafana_notification_channels:
      email:
        enabled: true
        settings:
          addresses: "admin@example.com"
      discord:
        enabled: true
        settings:
          url: "{{ vault_discord_webhook_url }}"
      webhook:
        enabled: true
        settings:
          url: "{{ vault_webhook_url }}"
    
    grafana_alert_rules:
      high_cpu:
        enabled: true
        condition: "avg(rate(node_cpu_seconds_total{mode!='idle'}[5m])) * 100 > 90"
        for: "5m"
        severity: "critical"
      high_memory:
        enabled: true
        condition: "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90"
        for: "5m"
        severity: "critical"
      service_down:
        enabled: true
        condition: "up == 0"
        for: "2m"
        severity: "critical"
  roles:
    - grafana
```

## Dashboards

### System Overview Dashboard
- **CPU Usage**: Real-time CPU utilization with thresholds
- **Memory Usage**: Memory consumption with alerts
- **Disk Usage**: File system monitoring
- **System Load**: Load average monitoring
- **Network Traffic**: Network I/O statistics
- **Service Status**: Service health monitoring
- **Docker Containers**: Container status and count
- **System Uptime**: System boot time
- **Temperature**: Hardware temperature monitoring

### Service Monitoring Dashboard
- **Service Health**: Overall service status
- **Response Times**: Service response time monitoring
- **Error Rates**: Error rate tracking
- **Resource Usage**: Per-service resource consumption
- **Dependencies**: Service dependency mapping
- **Performance Trends**: Historical performance data

### Security Dashboard
- **Authentication Events**: Login attempts and failures
- **Firewall Activity**: Firewall rule hits and blocks
- **Intrusion Detection**: Security alerts and events
- **SSL Certificate Status**: Certificate expiration monitoring
- **Access Logs**: User access patterns
- **Security Metrics**: Security-related metrics

### Media Services Dashboard
- **Sonarr Activity**: Download queue and activity
- **Radarr Activity**: Movie download monitoring
- **Jellyfin Streaming**: Streaming statistics
- **Download Speeds**: Download performance
- **Media Library**: Library statistics
- **Transcoding**: Transcoding performance

### Network Dashboard
- **Traefik Metrics**: Reverse proxy statistics
- **SSL Certificate Monitoring**: Certificate health
- **DNS Resolution**: DNS query monitoring
- **Network Connectivity**: Network health checks
- **Bandwidth Usage**: Network bandwidth monitoring
- **Connection Counts**: Active connection monitoring

### Database Dashboard
- **PostgreSQL Metrics**: Database performance
- **Redis Metrics**: Cache performance
- **MariaDB Metrics**: Database statistics
- **Connection Pools**: Connection pool monitoring
- **Query Performance**: Query execution times
- **Database Health**: Overall database health

### Storage Dashboard
- **File System Usage**: Disk space monitoring
- **Backup Status**: Backup job monitoring
- **Cloud Storage**: Cloud storage metrics
- **I/O Performance**: Storage I/O statistics
- **Storage Health**: Storage system health
- **Capacity Planning**: Storage capacity trends

## Alerting

### Alert Rules
The system includes comprehensive alert rules for:

#### System Alerts
- **High CPU Usage**: CPU utilization > 90% for 5 minutes
- **High Memory Usage**: Memory usage > 90% for 5 minutes
- **High Disk Usage**: Disk usage > 90% for 5 minutes
- **System Load**: Load average > 2 for 5 minutes
- **High Temperature**: Temperature > 80°C

#### Service Alerts
- **Service Down**: Service not responding for 2 minutes
- **High Error Rate**: Error rate > 5% for 5 minutes
- **High Response Time**: Response time > 500ms for 5 minutes
- **Service Degraded**: Service performance degraded

#### Security Alerts
- **Failed Login Attempts**: Multiple failed login attempts
- **Firewall Blocks**: High number of firewall blocks
- **SSL Certificate Expiry**: Certificate expires in < 30 days
- **Security Events**: Security-related events detected

#### Infrastructure Alerts
- **Backup Failures**: Backup job failures
- **Database Issues**: Database connection problems
- **Network Issues**: Network connectivity problems
- **Storage Issues**: Storage system problems

### Notification Channels
- **Email**: Email notifications
- **Slack**: Slack webhook notifications
- **Discord**: Discord webhook notifications
- **Webhook**: Custom webhook notifications

## Monitoring

### Health Checks
- **Container Health**: Docker container status
- **API Health**: Grafana API responsiveness
- **Data Source Health**: Data source connectivity
- **Dashboard Health**: Dashboard availability
- **Alert Health**: Alert system status

### Performance Monitoring
- **Response Times**: API response time monitoring
- **Resource Usage**: Container resource consumption
- **Database Performance**: Database query performance
- **Memory Usage**: Memory consumption patterns
- **CPU Usage**: CPU utilization patterns

### Metrics Collection
- **System Metrics**: Host system metrics
- **Application Metrics**: Grafana application metrics
- **Database Metrics**: Database performance metrics
- **Network Metrics**: Network performance metrics
- **Storage Metrics**: Storage performance metrics

## Backup and Recovery

### Backup Configuration
- **Automated Backups**: Daily automated backups
- **Configuration Backup**: Grafana configuration backup
- **Database Backup**: Database backup (if using external database)
- **Dashboard Backup**: Dashboard JSON export
- **User Backup**: User and team configuration backup

### Backup Schedule
- **Daily Backups**: Automatic daily backups at 2 AM
- **Retention Policy**: 30-day retention policy
- **Compression**: Compressed backup files
- **Verification**: Backup integrity verification

### Recovery Procedures
- **Configuration Recovery**: Restore Grafana configuration
- **Database Recovery**: Restore database (if applicable)
- **Dashboard Recovery**: Restore dashboards
- **User Recovery**: Restore users and teams

## Integration

### Monitoring Stack Integration
- **Prometheus**: Metrics collection and storage
- **Loki**: Log aggregation and querying
- **AlertManager**: Alert routing and notification
- **Node Exporter**: System metrics collection
- **cAdvisor**: Container metrics collection

### Security Integration
- **Traefik**: Reverse proxy integration
- **Authentik**: Authentication integration
- **SSL/TLS**: Secure communication
- **Firewall**: Network security integration

### Backup Integration
- **Automated Backups**: Integration with backup system
- **Cloud Storage**: Cloud storage integration
- **Monitoring**: Backup monitoring and alerting
- **Verification**: Backup verification and testing

## Troubleshooting

### Common Issues

#### Container Issues
```bash
# Check container status
docker ps -a | grep grafana

# Check container logs
docker logs grafana

# Restart container
docker restart grafana
```

#### API Issues
```bash
# Test API health
curl -f http://localhost:3000/api/health

# Test authentication
curl -u admin:password http://localhost:3000/api/user

# Check data sources
curl -u admin:password http://localhost:3000/api/datasources
```

#### Configuration Issues
```bash
# Check configuration files
ls -la /path/to/grafana/config/

# Validate configuration
docker exec grafana grafana-cli --config /etc/grafana/grafana.ini admin reset-admin-password

# Check logs
tail -f /path/to/grafana/logs/grafana.log
```

#### Dashboard Issues
```bash
# Check dashboard provisioning
curl -u admin:password http://localhost:3000/api/search

# Check folder structure
curl -u admin:password http://localhost:3000/api/folders

# Import dashboard manually
curl -X POST -H "Content-Type: application/json" \
  -u admin:password \
  -d @dashboard.json \
  http://localhost:3000/api/dashboards/db
```

### Debugging

#### Enable Debug Logging
```yaml
grafana_logging_level: "debug"
grafana_logging_mode: "console"
```

#### Check Python Script
```bash
# Test Python script
python3 setup_grafana.py --help

# Run with debug output
python3 setup_grafana.py \
  --url http://localhost:3000 \
  --username admin \
  --password admin \
  --config-dir config \
  --debug
```

#### Validate Configuration
```bash
# Validate Ansible variables
ansible-playbook --check playbook.yml

# Validate templates
ansible-playbook --syntax-check playbook.yml

# Run with verbose output
ansible-playbook -vvv playbook.yml
```

## Maintenance

### Regular Maintenance Tasks
- **Log Rotation**: Automatic log rotation
- **Database Maintenance**: Database optimization
- **Plugin Updates**: Plugin version updates
- **Configuration Backups**: Regular configuration backups
- **Performance Monitoring**: Continuous performance monitoring

### Updates
- **Version Updates**: Grafana version updates
- **Security Updates**: Security patch updates
- **Plugin Updates**: Plugin updates
- **Configuration Updates**: Configuration updates

### Monitoring
- **Health Monitoring**: Continuous health monitoring
- **Performance Monitoring**: Performance tracking
- **Alert Monitoring**: Alert system monitoring
- **Backup Monitoring**: Backup system monitoring

## Security

### Security Features
- **Authentication**: Secure authentication
- **Authorization**: Role-based access control
- **Encryption**: Data encryption in transit and at rest
- **Audit Logging**: Comprehensive audit logging
- **Network Security**: Network-level security

### Best Practices
- **Strong Passwords**: Use strong, unique passwords
- **Regular Updates**: Keep Grafana updated
- **Access Control**: Implement proper access controls
- **Monitoring**: Monitor for security events
- **Backups**: Regular security backups

## Performance

### Performance Optimization
- **Resource Limits**: Container resource limits
- **Database Optimization**: Database performance tuning
- **Caching**: Implement caching strategies
- **Query Optimization**: Optimize dashboard queries
- **Monitoring**: Performance monitoring

### Scaling
- **Horizontal Scaling**: Scale across multiple instances
- **Load Balancing**: Implement load balancing
- **Database Scaling**: Scale database backend
- **Caching**: Implement caching layers
- **Monitoring**: Scale monitoring infrastructure

## Conclusion

This comprehensive Grafana automation system provides a complete solution for deploying and managing Grafana in homelab environments. It includes all necessary components for monitoring, alerting, and management with full integration into existing infrastructure.

The system is designed to be:
- **Comprehensive**: Complete monitoring solution
- **Automated**: Fully automated deployment and configuration
- **Scalable**: Designed for growth and expansion
- **Secure**: Built with security best practices
- **Maintainable**: Easy to maintain and update

For additional support and documentation, refer to the individual component documentation and the main project documentation. 