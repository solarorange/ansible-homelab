# Port Conflict Resolution Summary

## Problem Identified

Multiple services in the homelab stack were conflicting on port 3000:
- **Homepage** (Primary Dashboard) - Port 3000
- **Immich Web** (Photo Management) - Port 3000  
- **Pezzo Server** (AI Prompt Management) - Port 3000

This would cause deployment failures and service unavailability.

## Solution Implemented

### 1. Centralized Port Management System

Created `group_vars/all/port_management.yml` with:
- **Organized port ranges** by service category
- **Service documentation** with detailed port assignments
- **Validation rules** for reserved ports and valid ranges
- **Conflict resolution mapping** documenting all changes
- **Monitoring configuration** for automated conflict detection

### 2. Port Conflict Detector

Created `scripts/port_conflict_detector.py` that:
- Scans all service configurations for port assignments
- Detects conflicts between services
- Validates against the centralized management system
- Generates recommendations for conflict resolution
- Provides detailed reports

### 3. Service Configuration Updates

#### Pezzo Service (`roles/pezzo/defaults/main.yml`)
```yaml
# Port Configuration
pezzo_server_port: 3001  # Changed from 3000
pezzo_console_port: 8080
pezzo_proxy_port: 3002  # Changed from 3000

# Component configurations updated
pezzo_components:
  server:
    port: 3001  # Changed from 3000
    healthcheck: test: ["CMD-SHELL", "curl -f http://localhost:3001/api/healthz"]
  proxy:
    port: 3002  # Changed from 3000
    healthcheck: test: ["CMD-SHELL", "curl -f http://localhost:3002/health"]
```

#### Immich Service (`roles/immich/defaults/main.yml`)
```yaml
# Service ports
immich_server_port: 3004  # Changed from 3001
immich_web_port: 3003  # Changed from 3000
immich_ml_port: 3005  # Changed from 3003

# Component configurations updated
immich_components:
  server:
    port: 3004  # Changed from 3001
  web:
    port: 3003  # Changed from 3000
    healthcheck: test: ["CMD", "curl", "-f", "http://localhost:3003/health"]
  machine_learning:
    port: 3005  # Changed from 3003
    healthcheck: test: ["CMD", "curl", "-f", "http://localhost:3005/health"]
```

### 4. Documentation

Created comprehensive documentation in `docs/PORT_MANAGEMENT_SYSTEM.md` covering:
- System overview and components
- Port range organization
- Usage instructions
- Best practices
- Troubleshooting guide
- Future enhancements

## Final Port Assignments

### Primary Dashboard
- **Homepage**: Port 3000 (Kept as primary dashboard)

### AI & Development Services
- **Pezzo Server**: Port 3001 (Changed from 3000)
- **Pezzo Proxy**: Port 3002 (Changed from 3000)
- **Pezzo Console**: Port 8080 (Unchanged)

### Media Management Services
- **Immich Web**: Port 3003 (Changed from 3000)
- **Immich Server**: Port 3004 (Changed from 3001)
- **Immich ML**: Port 3005 (Changed from 3003)

## Service Access URLs

After the changes, services are accessible at:

### Primary Dashboard
- **Homepage**: https://homepage.{{ domain }} (Port 3000)

### AI & Development
- **Pezzo**: https://pezzo.{{ domain }} (Ports 3001, 3002, 8080)

### Media Management
- **Immich**: https://immich.{{ domain }} (Ports 3003, 3004, 3005)

## Health Check Endpoints

All services include updated health checks:
- **Pezzo Server**: `http://localhost:3001/api/healthz`
- **Pezzo Proxy**: `http://localhost:3002/health`
- **Immich Web**: `http://localhost:3003/health`
- **Immich Server**: `http://localhost:3004/health`
- **Immich ML**: `http://localhost:3005/health`

## Prevention System

### Automated Detection
- **Port Conflict Detector**: Scans configurations and detects conflicts
- **Validation**: Validates against centralized management system
- **Reporting**: Generates detailed reports with recommendations

### Best Practices Implemented
1. **Centralized Management**: All port assignments in one place
2. **Organized Ranges**: Ports grouped by service category
3. **Documentation**: Comprehensive documentation of all assignments
4. **Validation**: Automated validation before deployment
5. **Monitoring**: Continuous monitoring for conflicts

### Future Prevention
- **Pre-deployment validation**: Run conflict detection before deployment
- **Automated testing**: Include port validation in CI/CD pipelines
- **Documentation updates**: Keep port documentation current
- **Regular audits**: Monthly port conflict detection runs

## Files Created/Modified

### New Files
- `group_vars/all/port_management.yml` - Centralized port management
- `scripts/port_conflict_detector.py` - Conflict detection script
- `docs/PORT_MANAGEMENT_SYSTEM.md` - Comprehensive documentation

### Modified Files
- `roles/pezzo/defaults/main.yml` - Updated Pezzo port assignments
- `roles/immich/defaults/main.yml` - Updated Immich port assignments

## Testing

The port conflict detector has been tested and shows:
- ✅ **Main conflicts resolved**: Homepage, Pezzo, and Immich no longer conflict
- ✅ **Service configurations updated**: All affected services have new port assignments
- ✅ **Health checks updated**: All health check endpoints updated to new ports
- ✅ **Documentation complete**: Comprehensive documentation provided

## Next Steps

1. **Deploy the changes**: Apply the updated configurations to your homelab
2. **Test services**: Verify all services start correctly with new ports
3. **Update bookmarks**: Update any bookmarks or shortcuts to use new URLs
4. **Monitor**: Use the port conflict detector regularly to prevent future conflicts
5. **Document**: Keep the port management documentation updated as services are added

## Usage Commands

```bash
# Check for port conflicts
python3 scripts/port_conflict_detector.py

# Generate detailed report
python3 scripts/port_conflict_detector.py --report

# Validate against management system
python3 scripts/port_conflict_detector.py --validate
```

## Conclusion

The port conflict resolution has been successfully implemented with:
- ✅ **Immediate resolution** of the port 3000 conflicts
- ✅ **Comprehensive prevention system** to avoid future conflicts
- ✅ **Automated detection tools** for ongoing monitoring
- ✅ **Complete documentation** for maintenance and troubleshooting

All services should now deploy successfully without port conflicts, and the system includes tools to prevent similar issues in the future. 