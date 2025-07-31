# Homelab Port Management System

## Overview

The Homelab Port Management System is a centralized solution designed to prevent port conflicts and ensure consistent service deployment across the homelab infrastructure. This system provides automated detection, validation, and resolution of port conflicts.

## Problem Solved

### Original Port Conflicts
The following services were conflicting on port 3000:
- **Homepage** (Primary Dashboard) - Port 3000
- **Immich Web** (Photo Management) - Port 3000  
- **Pezzo Server** (AI Prompt Management) - Port 3000

### Resolution
- **Homepage**: Kept port 3000 (Primary dashboard)
- **Pezzo Server**: Moved to port 3001
- **Pezzo Proxy**: Moved to port 3002
- **Immich Web**: Moved to port 3003
- **Immich Server**: Moved to port 3004
- **Immich ML**: Moved to port 3005

## System Components

### 1. Centralized Port Management (`group_vars/all/port_management.yml`)

This file contains:
- **Port Ranges**: Organized by service category
- **Service Documentation**: Detailed port assignments
- **Validation Rules**: Reserved ports and valid ranges
- **Conflict Resolution**: Historical changes and reasons
- **Monitoring Configuration**: Automated conflict detection

### 2. Port Conflict Detector (`scripts/port_conflict_detector.py`)

A Python script that:
- Scans all service configurations for port assignments
- Detects conflicts between services
- Validates against the centralized management system
- Generates recommendations for conflict resolution
- Provides detailed reports

### 3. Updated Service Configurations

All affected services have been updated with new port assignments:

#### Pezzo Service (`roles/pezzo/defaults/main.yml`)
```yaml
# Port Configuration
pezzo_server_port: 3001  # Changed from 3000
pezzo_console_port: 8080
pezzo_proxy_port: 3002  # Changed from 3000
```

#### Immich Service (`roles/immich/defaults/main.yml`)
```yaml
# Service ports
immich_server_port: 3004  # Changed from 3001
immich_web_port: 3003  # Changed from 3000
immich_ml_port: 3005  # Changed from 3003
```

## Port Range Organization

### Infrastructure & Management (1000-1999)
- Traefik Dashboard: 8080
- Portainer: 9000
- Authentik: 9000
- Watchtower: 8082

### Monitoring & Observability (2000-2999)
- Prometheus: 9090
- Alertmanager: 9093
- Grafana: 3000
- Loki: 3100

### Web Applications & Dashboards (3000-3999)
- Homepage: 3000 (Primary dashboard)
- Pezzo Server: 3001
- Pezzo Proxy: 3002
- Immich Web: 3003
- Immich Server: 3004
- Immich ML: 3005

### Media & Entertainment (4000-4999)
- Jellyfin: 8096
- Sonarr: 8989
- Radarr: 7878
- Lidarr: 8686

### Development & Automation (5000-5999)
- n8n: 5678
- Node-RED: 1880
- Home Assistant: 8123

### Storage & Backup (6000-6999)
- Nextcloud: 8080
- Vaultwarden: 8080
- Kopia: 6000

### Security & Authentication (7000-7999)
- Pi-hole: 80
- WireGuard: 51820
- CrowdSec: 7000

### Database & Cache (8000-8999)
- PostgreSQL: 5432
- Redis: 6379
- MongoDB: 27017

### Specialized Services (9000-9999)
- Supertokens: 3567
- Local KMS: 9981
- Weather API: 9000

## Usage

### Running Port Conflict Detection

```bash
# Basic conflict detection
python3 scripts/port_conflict_detector.py

# Generate detailed report
python3 scripts/port_conflict_detector.py --report

# Validate against management system
python3 scripts/port_conflict_detector.py --validate

# Attempt automatic fixes (not yet implemented)
python3 scripts/port_conflict_detector.py --fix
```

### Checking Current Port Assignments

```bash
# View all service port assignments
python3 scripts/port_conflict_detector.py --report | grep "SERVICE PORT ASSIGNMENTS" -A 50
```

### Adding New Services

1. **Update Port Management File**:
   ```yaml
   # Add to appropriate section in group_vars/all/port_management.yml
   new_service:
     port: 3010
     description: "New service description"
     url: "https://newservice.{{ domain }}"
     category: "Appropriate Category"
     priority: "Medium"
   ```

2. **Update Service Configuration**:
   ```yaml
   # In roles/newservice/defaults/main.yml
   newservice_port: 3010
   ```

3. **Run Validation**:
   ```bash
   python3 scripts/port_conflict_detector.py --validate
   ```

## Service Access URLs

After the port changes, services are accessible at:

### Primary Dashboard
- **Homepage**: https://homepage.{{ domain }} (Port 3000)

### AI & Development
- **Pezzo**: https://pezzo.{{ domain }} (Ports 3001, 3002, 8080)

### Media Management
- **Immich**: https://immich.{{ domain }} (Ports 3003, 3004, 3005)

## Monitoring & Alerting

### Automated Monitoring
The system includes automated monitoring with:
- **Conflict Detection**: Real-time port conflict detection
- **Validation**: Continuous validation against management system
- **Alerting**: Automatic alerts for conflicts and violations
- **Logging**: Comprehensive logging of port changes

### Health Checks
All services include health checks on their new ports:
- Pezzo Server: `http://localhost:3001/api/healthz`
- Pezzo Proxy: `http://localhost:3002/health`
- Immich Web: `http://localhost:3003/health`
- Immich Server: `http://localhost:3004/health`
- Immich ML: `http://localhost:3005/health`

## Best Practices

### 1. Port Assignment Guidelines
- **Reserved Ports**: Never use ports 1-1023 (system ports)
- **Standard Services**: Use well-known ports for standard services
- **Custom Services**: Use ports 3000+ for custom applications
- **Documentation**: Always document port assignments

### 2. Conflict Prevention
- **Centralized Management**: Use the port management system
- **Validation**: Run conflict detection before deployment
- **Testing**: Test port assignments in staging environment
- **Documentation**: Keep port documentation up to date

### 3. Service Deployment
- **Validation**: Always validate ports before deployment
- **Health Checks**: Implement proper health checks
- **Monitoring**: Monitor service availability
- **Backup**: Backup port configurations

## Troubleshooting

### Common Issues

#### 1. Service Won't Start
```bash
# Check if port is already in use
sudo netstat -tlnp | grep :3000

# Check service logs
docker logs <service-container-name>
```

#### 2. Port Conflict Detected
```bash
# Run conflict detection
python3 scripts/port_conflict_detector.py --report

# Check current port assignments
python3 scripts/port_conflict_detector.py --validate
```

#### 3. Service Not Accessible
```bash
# Check if service is running
docker ps | grep <service-name>

# Check port binding
docker port <service-container-name>

# Test connectivity
curl -f http://localhost:<port>/health
```

### Recovery Procedures

#### 1. Emergency Port Change
```bash
# Stop conflicting service
docker stop <service-name>

# Update configuration
# Edit the appropriate defaults/main.yml file

# Restart service
docker start <service-name>
```

#### 2. Rollback Procedure
```bash
# Revert to previous port assignment
# Edit the appropriate defaults/main.yml file

# Restart service
docker restart <service-name>

# Validate changes
python3 scripts/port_conflict_detector.py --validate
```

## Future Enhancements

### Planned Features
1. **Automatic Conflict Resolution**: Automated port reassignment
2. **Dynamic Port Allocation**: Automatic port assignment for new services
3. **Port Reservation System**: Reserve ports for planned services
4. **Integration with CI/CD**: Automated validation in deployment pipelines
5. **Web Interface**: Web-based port management dashboard

### Monitoring Enhancements
1. **Real-time Monitoring**: Live port conflict detection
2. **Predictive Analysis**: Predict potential conflicts
3. **Performance Impact**: Monitor impact of port changes
4. **Service Dependencies**: Track service dependencies

## Maintenance

### Regular Tasks
1. **Monthly**: Run full port conflict detection
2. **Quarterly**: Review and update port assignments
3. **Annually**: Audit port management system
4. **As Needed**: Update documentation for new services

### Backup Procedures
1. **Configuration Backup**: Backup port management files
2. **Service Backup**: Backup service configurations
3. **Documentation Backup**: Backup port documentation
4. **Validation Backup**: Backup validation reports

## Support

### Getting Help
1. **Check Documentation**: Review this document and related files
2. **Run Diagnostics**: Use the port conflict detector
3. **Check Logs**: Review service and system logs
4. **Community Support**: Reach out to homelab community

### Reporting Issues
When reporting port-related issues, include:
- Service name and version
- Current port assignment
- Error messages
- Conflict detection output
- System information

## Conclusion

The Port Management System provides a robust foundation for preventing port conflicts and ensuring reliable service deployment. By following the guidelines and using the provided tools, you can maintain a conflict-free homelab environment.

For questions or issues, refer to the troubleshooting section or run the port conflict detector for automated diagnostics. 