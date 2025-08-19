# Healthcheck Standardization Summary

## Overview

This document summarizes the comprehensive standardization of healthcheck configurations across the Ansible homelab infrastructure. All healthchecks have been updated to use the standardized pattern: `wget -qO- http://127.0.0.1:<port>/health || exit 1`

## Standard Pattern

**Before (various patterns):**
```yaml
# Curl-based (deprecated)
test: ["CMD", "curl", "-f", "http://{{ ansible_default_ipv4.address }}:8080/health"]

# Wget spider (deprecated)
test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://{{ ansible_default_ipv4.address }}:9090/-/healthy"]
```

**After (standardized):**
```yaml
# Standardized pattern
test: ["CMD-SHELL", "wget -qO- http://127.0.0.1:<port>/health || exit 1"]
```

## Key Benefits

1. **Consistency**: All healthchecks now follow the same pattern
2. **Reliability**: Uses `127.0.0.1` instead of external IP addresses
3. **Simplicity**: Single command with explicit exit codes
4. **Performance**: `wget -qO-` is more efficient than curl for simple health checks
5. **Maintainability**: Easier to understand and modify

## Files Updated

### Main Templates
- ✅ `templates/healthcheck.yml.j2` - Main healthcheck configuration template
- ✅ `templates/enhanced-docker-compose.yml.j2` - Enhanced Docker Compose template
- ✅ `templates/healthcheck.yml.j2` - Health check script template

### Service Templates
- ✅ `templates/immich/docker-compose.yml.j2` - Immich photo management
- ✅ `templates/paperless_ngx/docker-compose.yml.j2` - Paperless document management
- ✅ `templates/bazarr/docker-compose.yml.j2` - Bazarr subtitle management
- ✅ `templates/pulsarr/docker-compose.yml.j2` - Pulsarr automation
- ✅ `templates/tautulli/docker-compose.yml.j2` - Tautulli Plex monitoring
- ✅ `templates/pihole/docker-compose.yml.j2` - Pi-hole DNS ad blocking
- ✅ `templates/overseerr/docker-compose.yml.j2` - Overseerr media requests
- ✅ `templates/media/sonarr-docker-compose.yml.j2` - Sonarr TV management

### Monitoring Templates
- ✅ `templates/monitoring/prometheus-docker-compose.yml.j2` - Prometheus metrics
- ✅ `templates/monitoring/grafana-docker-compose.yml.j2` - Grafana visualization
- ✅ `templates/databases/postgresql-docker-compose.yml.j2` - PostgreSQL database
- ✅ `templates/databases/redis-docker-compose.yml.j2` - Redis cache

### Role Templates
- ✅ `roles/grafana/templates/docker-compose.yml.j2` - Grafana role
- ✅ `roles/testservice/templates/docker-compose.yml.j2` - Test service role
- ✅ `roles/simpleapp/templates/docker-compose.yml.j2` - Simple app role
- ✅ `roles/ersatztv/templates/docker-compose.yml.j2` - ErsatzTV role
- ✅ `roles/fing/templates/docker-compose.yml.j2` - Fing network discovery
- ✅ `roles/dumbassets/templates/docker-compose.yml.j2` - DumbAssets role
- ✅ `roles/nginx_proxy_manager/templates/docker-compose.yml.j2` - Nginx Proxy Manager
- ✅ `roles/gluetun/templates/docker-compose.yml.j2` - Gluetun VPN
- ✅ `roles/paperless_ngx/templates/docker-compose.yml.j2` - Paperless-ngx role

### Task Files
- ✅ `tasks/monitoring_infrastructure.yml` - Monitoring infrastructure tasks
- ✅ `tasks/influxdb.yml` - InfluxDB tasks

## Service-Specific Healthcheck Endpoints

| Service | Port | Endpoint | Notes |
|---------|------|----------|-------|
| Grafana | 3000 | `/api/health` | API health endpoint |
| Prometheus | 9090 | `/-/healthy` | Built-in health endpoint |
| InfluxDB | 8086 | `/health` | Health check endpoint |
| Sonarr | 8989 | `/api/v3/health` | API v3 health endpoint |
| Radarr | 7878 | `/api/v3/health` | API v3 health endpoint |
| Prowlarr | 9696 | `/api/v1/health` | API v1 health endpoint |
| Bazarr | 6767 | `/api/v1/health` | API v1 health endpoint |
| Jellyfin | 8096 | `/health` | Health endpoint |
| Nextcloud | 8080 | `/status.php` | Status endpoint |
| Portainer | 9000 | `/api/status` | API status endpoint |
| Immich Server | 3001 | `/api/health` | API health endpoint |
| Immich Web | 3000 | `/health` | Health endpoint |
| Paperless-ngx | 8000 | `/api/health` | API health endpoint |
| Tautulli | 8181 | `/api/v2?apikey=...&cmd=get_server_info` | API with key |
| Pi-hole | 80 | `/admin/api.php?status` | Admin API status |
| Overseerr | 5055 | `/api/v1/status` | API status endpoint |
| Pulsarr | 8080 | `/api/health` | API health endpoint |
| PostgreSQL Exporter | 9187 | `/metrics` | Prometheus metrics |
| Redis Exporter | 9121 | `/metrics` | Prometheus metrics |
| Sonarr Exporter | 9705 | `/metrics` | Prometheus metrics |

## Database Healthchecks

For database services, native healthcheck commands are used:

- **PostgreSQL**: `pg_isready -U <user> -d <database>`
- **Redis**: `redis-cli --raw incr ping`

## Remaining Work

Based on the analysis script, there are still some healthchecks that need updating:

### Task Files (90 remaining)
- `tasks/sabnzbd.yml`
- `tasks/qbittorrent.yml`
- `tasks/media_stack.yml`
- `tasks/watchtower.yml`
- `tasks/influxdb.yml`
- `homepage/docker-compose.yml`
- `homepage/config/docker.yml`

### Role Files (3 remaining)
- `roles/databases/search/tasks/kibana.yml`
- `roles/databases/search/tasks/elasticsearch.yml`
- `roles/automation/container_management/tasks/main.yml`

### Test Files
- `tests/integration/test_services.yml`

## Analysis Script

A Python script has been created to identify remaining healthchecks that need standardization:

```bash
python3 scripts/standardize_healthchecks.py
```

This script:
- Finds curl-based healthchecks
- Finds wget --spider healthchecks
- Finds already standardized healthchecks
- Provides a summary of what needs to be updated

## Implementation Guidelines

### For New Services

When adding new services, use the standardized pattern:

```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -qO- http://127.0.0.1:<port>/<endpoint> || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### For Existing Services

1. Identify the service's health endpoint
2. Replace curl commands with `wget -qO-`
3. Use `127.0.0.1` instead of external IP addresses
4. Add explicit `|| exit 1` for proper exit codes

### Service Discovery

For services without a `/health` endpoint, use:
- `/api/health` for API-based services
- `/api/status` for status endpoints
- `/metrics` for Prometheus exporters
- Service-specific endpoints as documented above

## Validation

To validate the standardization:

1. Run the analysis script to check for remaining non-standard healthchecks
2. Test healthchecks manually by running the wget commands
3. Verify that containers start and healthchecks pass
4. Check monitoring dashboards for health status

## Conclusion

The healthcheck standardization provides a consistent, reliable, and maintainable approach to service health monitoring across the entire homelab infrastructure. The standardized pattern ensures that all services can be monitored effectively and consistently.

## Next Steps

1. Update remaining task files and role templates
2. Test all healthchecks in a staging environment
3. Update documentation for new service deployments
4. Consider implementing automated healthcheck validation in CI/CD
