# API Reference: Service APIs and Integration Points

## Table of Contents

1. [Authentication APIs](#authentication-apis)
2. [Media Service APIs](#media-service-apis)
3. [File Service APIs](#file-service-apis)
4. [Monitoring APIs](#monitoring-apis)
5. [Security APIs](#security-apis)
6. [Automation APIs](#automation-apis)
7. [Database APIs](#database-apis)
8. [Integration Examples](#integration-examples)

---

## Authentication APIs

### Authentik API

#### Base URL
```
http://authentik:9000/api/v3/
```

#### Authentication
```bash
# Get API token
curl -X POST http://authentik:9000/api/v3/core/tokens/ \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "admin@yourdomain.com",
    "password": "your-password"
  }'
```

#### User Management
```bash
# List users
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://authentik:9000/api/v3/core/users/

# Create user
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://authentik:9000/api/v3/core/users/ \
  -d '{
    "username": "newuser",
    "email": "user@yourdomain.com",
    "password": "secure-password"
  }'

# Update user
curl -X PUT -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://authentik:9000/api/v3/core/users/USER_ID/ \
  -d '{
    "is_active": true,
    "groups": ["media-users"]
  }'
```

#### Group Management
```bash
# List groups
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://authentik:9000/api/v3/core/groups/

# Create group
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://authentik:9000/api/v3/core/groups/ \
  -d '{
    "name": "media-users",
    "parent_name": "users"
  }'
```

#### Application Management
```bash
# List applications
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://authentik:9000/api/v3/core/applications/

# Create OAuth application
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://authentik:9000/api/v3/core/applications/ \
  -d '{
    "name": "jellyfin",
    "slug": "jellyfin",
    "provider": "oauth2",
    "client_type": "confidential",
    "redirect_uris": "http://jellyfin:8096/auth/callback"
  }'
```

---

## Media Service APIs

### Jellyfin API

#### Base URL
```
http://jellyfin:8096/
```

#### Authentication
```bash
# Authenticate user
curl -X POST http://jellyfin:8096/Users/AuthenticateByName \
  -H "Content-Type: application/json" \
  -d '{
    "Username": "admin",
    "Pw": "password"
  }'

# Get API key
curl -H "X-Emby-Token: YOUR_TOKEN" \
  http://jellyfin:8096/Auth/Keys
```

#### Library Management
```bash
# Get libraries
curl -H "X-Emby-Token: YOUR_TOKEN" \
  http://jellyfin:8096/Library/VirtualFolders

# Get library items
curl -H "X-Emby-Token: YOUR_TOKEN" \
  "http://jellyfin:8096/Users/USER_ID/Items?ParentId=LIBRARY_ID"

# Search items
curl -H "X-Emby-Token: YOUR_TOKEN" \
  "http://jellyfin:8096/Users/USER_ID/Items?SearchTerm=search_term"
```

#### Playback Management
```bash
# Get playback info
curl -H "X-Emby-Token: YOUR_TOKEN" \
  http://jellyfin:8096/Users/USER_ID/Items/ITEM_ID/PlaybackInfo

# Start playback
curl -X POST -H "X-Emby-Token: YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://jellyfin:8096/Sessions/Playing \
  -d '{
    "ItemId": "ITEM_ID",
    "PlaySessionId": "SESSION_ID"
  }'
```

### Sonarr API

#### Base URL
```
http://sonarr:8989/api/v3/
```

#### Authentication
```bash
# API key is configured in Sonarr settings
curl -H "X-Api-Key: YOUR_API_KEY" \
  http://sonarr:8989/api/v3/system/status
```

#### Series Management
```bash
# Get all series
curl -H "X-Api-Key: YOUR_API_KEY" \
  http://sonarr:8989/api/v3/series

# Add series
curl -X POST -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  http://sonarr:8989/api/v3/series \
  -d '{
    "title": "Series Title",
    "tvdbId": 12345,
    "qualityProfileId": 1,
    "rootFolderPath": "/tv",
    "monitored": true
  }'

# Search for series
curl -H "X-Api-Key: YOUR_API_KEY" \
  "http://sonarr:8989/api/v3/series/lookup?term=search_term"
```

#### Episode Management
```bash
# Get episodes for series
curl -H "X-Api-Key: YOUR_API_KEY" \
  "http://sonarr:8989/api/v3/episode?seriesId=SERIES_ID"

# Search for episodes
curl -X POST -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  http://sonarr:8989/api/v3/command \
  -d '{
    "name": "EpisodeSearch",
    "episodeIds": [EPISODE_ID]
  }'
```

### Radarr API

#### Base URL
```
http://radarr:7878/api/v3/
```

#### Authentication
```bash
# API key is configured in Radarr settings
curl -H "X-Api-Key: YOUR_API_KEY" \
  http://radarr:7878/api/v3/system/status
```

#### Movie Management
```bash
# Get all movies
curl -H "X-Api-Key: YOUR_API_KEY" \
  http://radarr:7878/api/v3/movie

# Add movie
curl -X POST -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  http://radarr:7878/api/v3/movie \
  -d '{
    "title": "Movie Title",
    "tmdbId": 12345,
    "qualityProfileId": 1,
    "rootFolderPath": "/movies",
    "monitored": true
  }'

# Search for movie
curl -H "X-Api-Key: YOUR_API_KEY" \
  "http://radarr:7878/api/v3/movie/lookup?term=search_term"
```

---

## File Service APIs

### Nextcloud API

#### Base URL
```
http://nextcloud:8080/remote.php/webdav/
```

#### Authentication
```bash
# Basic authentication
curl -u "username:password" \
  http://nextcloud:8080/remote.php/webdav/

# OAuth2 authentication
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://nextcloud:8080/remote.php/webdav/
```

#### File Operations
```bash
# List files
curl -u "username:password" \
  http://nextcloud:8080/remote.php/webdav/path/to/folder

# Upload file
curl -X PUT -u "username:password" \
  -T "local_file.txt" \
  http://nextcloud:8080/remote.php/webdav/path/to/file.txt

# Download file
curl -u "username:password" \
  http://nextcloud:8080/remote.php/webdav/path/to/file.txt

# Create folder
curl -X MKCOL -u "username:password" \
  http://nextcloud:8080/remote.php/webdav/path/to/newfolder

# Delete file/folder
curl -X DELETE -u "username:password" \
  http://nextcloud:8080/remote.php/webdav/path/to/file.txt
```

#### User Management
```bash
# Create user
curl -X POST -u "admin:password" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  http://nextcloud:8080/ocs/v1.php/cloud/users \
  -d "userid=newuser&password=password&email=user@domain.com"

# Get user info
curl -u "admin:password" \
  http://nextcloud:8080/ocs/v1.php/cloud/users/username

# Update user
curl -X PUT -u "admin:password" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  http://nextcloud:8080/ocs/v1.php/cloud/users/username \
  -d "key=quota&value=1073741824"
```

### Samba API

#### Base URL
```
smb://server/share/
```

#### File Operations
```bash
# Mount share
sudo mount -t cifs //server/share /mnt/share \
  -o username=user,password=pass

# List files
smbclient //server/share -U username -c "ls"

# Upload file
smbclient //server/share -U username -c "put local_file.txt"

# Download file
smbclient //server/share -U username -c "get remote_file.txt"
```

---

## Monitoring APIs

### Prometheus API

#### Base URL
```
http://prometheus:9090/api/v1/
```

#### Query API
```bash
# Instant query
curl "http://prometheus:9090/api/v1/query?query=up"

# Range query
curl "http://prometheus:9090/api/v1/query_range?query=up&start=2023-01-01T00:00:00Z&end=2023-01-01T23:59:59Z&step=1h"

# Get metrics
curl "http://prometheus:9090/api/v1/label/__name__/values"

# Get series
curl "http://prometheus:9090/api/v1/series?match[]=up"
```

#### Management API
```bash
# Get targets
curl "http://prometheus:9090/api/v1/targets"

# Get rules
curl "http://prometheus:9090/api/v1/rules"

# Get alerts
curl "http://prometheus:9090/api/v1/alerts"

# Reload configuration
curl -X POST "http://prometheus:9090/-/reload"
```

### Grafana API

#### Base URL
```
http://grafana:3000/api/
```

#### Authentication
```bash
# Get API key
curl -X POST -H "Content-Type: application/json" \
  http://grafana:3000/api/auth/keys \
  -d '{
    "name": "api-key",
    "role": "Admin"
  }'
```

#### Dashboard Management
```bash
# Get dashboards
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://grafana:3000/api/search

# Get dashboard by UID
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://grafana:3000/api/dashboards/uid/DASHBOARD_UID

# Create dashboard
curl -X POST -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  http://grafana:3000/api/dashboards/db \
  -d '{
    "dashboard": {
      "title": "New Dashboard",
      "panels": []
    }
  }'
```

#### User Management
```bash
# Get users
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://grafana:3000/api/admin/users

# Create user
curl -X POST -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  http://grafana:3000/api/admin/users \
  -d '{
    "login": "newuser",
    "email": "user@domain.com",
    "password": "password"
  }'
```

### Loki API

#### Base URL
```
http://loki:3100/
```

#### Query API
```bash
# Query logs
curl -G -s "http://loki:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job="docker"}' \
  --data-urlencode 'start=1640995200' \
  --data-urlencode 'end=1641081600'

# Get labels
curl "http://loki:3100/loki/api/v1/labels"

# Get label values
curl "http://loki:3100/loki/api/v1/label/job/values"
```

---

## Security APIs

### CrowdSec API

#### Base URL
```
http://crowdsec:8080/api/v1/
```

#### Decision Management
```bash
# Get decisions
curl "http://crowdsec:8080/api/v1/decisions"

# Add decision
curl -X POST -H "Content-Type: application/json" \
  http://crowdsec:8080/api/v1/decisions \
  -d '{
    "ip": "192.168.1.100",
    "duration": "1h",
    "scenario": "manual-ban"
  }'

# Delete decision
curl -X DELETE \
  "http://crowdsec:8080/api/v1/decisions?ip=192.168.1.100"
```

#### Alert Management
```bash
# Get alerts
curl "http://crowdsec:8080/api/v1/alerts"

# Get alert by ID
curl "http://crowdsec:8080/api/v1/alerts/ALERT_ID"
```

### Fail2ban API

#### Base URL
```
http://fail2ban:8080/
```

#### Jail Management
```bash
# Get jails
curl "http://fail2ban:8080/jails"

# Get jail status
curl "http://fail2ban:8080/jails/sshd/status"

# Ban IP
curl -X POST -H "Content-Type: application/json" \
  http://fail2ban:8080/jails/sshd/ban \
  -d '{"ip": "192.168.1.100"}'

# Unban IP
curl -X POST -H "Content-Type: application/json" \
  http://fail2ban:8080/jails/sshd/unban \
  -d '{"ip": "192.168.1.100"}'
```

### Pi-hole API

#### Base URL
```
http://pihole:8081/admin/api.php
```

#### Statistics
```bash
# Get summary
curl "http://pihole:8081/admin/api.php?summary"

# Get top items
curl "http://pihole:8081/admin/api.php?topItems"

# Get recent blocked
curl "http://pihole:8081/admin/api.php?recentBlocked"
```

#### Management
```bash
# Enable Pi-hole
curl "http://pihole:8081/admin/api.php?enable&auth=YOUR_TOKEN"

# Disable Pi-hole
curl "http://pihole:8081/admin/api.php?disable&auth=YOUR_TOKEN"

# Add to whitelist
curl "http://pihole:8081/admin/api.php?add&list=whitelist&domain=example.com&auth=YOUR_TOKEN"

# Add to blacklist
curl "http://pihole:8081/admin/api.php?add&list=blacklist&domain=ads.example.com&auth=YOUR_TOKEN"
```

---

## Automation APIs

### Home Assistant API

#### Base URL
```
http://homeassistant:8123/api/
```

#### Authentication
```bash
# Get long-lived access token
# Generated in Home Assistant UI: Profile > Long-Lived Access Tokens
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://homeassistant:8123/api/
```

#### State Management
```bash
# Get all states
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://homeassistant:8123/api/states

# Get entity state
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://homeassistant:8123/api/states/light.living_room

# Set entity state
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://homeassistant:8123/api/states/light.living_room \
  -d '{
    "state": "on",
    "attributes": {
      "brightness": 255
    }
  }'
```

#### Service Calls
```bash
# Call service
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://homeassistant:8123/api/services/light/turn_on \
  -d '{
    "entity_id": "light.living_room"
  }'
```

#### Automation Management
```bash
# Get automations
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://homeassistant:8123/api/config/automation/config

# Trigger automation
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  http://homeassistant:8123/api/services/automation/trigger \
  -d '{
    "entity_id": "automation.example"
  }'
```

### Node-RED API

#### Base URL
```
http://nodered:1880/
```

#### Flow Management
```bash
# Get flows
curl http://nodered:1880/flows

# Deploy flows
curl -X POST -H "Content-Type: application/json" \
  http://nodered:1880/flows \
  -d '{
    "flows": [...]
  }'
```

#### Node Management
```bash
# Get nodes
curl http://nodered:1880/nodes

# Get node info
curl http://nodered:1880/nodes/NODE_ID
```

---

## Database APIs

### PostgreSQL API

#### Connection
```bash
# Direct connection
psql -h localhost -U username -d database

# Connection string
postgresql://username:password@localhost:5432/database
```

#### Query API
```sql
-- Get database info
SELECT version(), current_database(), current_user;

-- Get table info
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Get column info
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'table_name';
```

#### Management API
```sql
-- Create database
CREATE DATABASE new_database;

-- Create user
CREATE USER new_user WITH PASSWORD 'password';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE database_name TO user_name;

-- Backup database
pg_dump -h localhost -U username -d database > backup.sql

-- Restore database
psql -h localhost -U username -d database < backup.sql
```

### Redis API

#### Base URL
```
redis://localhost:6379
```

#### Key-Value Operations
```bash
# Set value
redis-cli SET key value

# Get value
redis-cli GET key

# Delete key
redis-cli DEL key

# Check if key exists
redis-cli EXISTS key
```

#### List Operations
```bash
# Push to list
redis-cli LPUSH list_name value
redis-cli RPUSH list_name value

# Pop from list
redis-cli LPOP list_name
redis-cli RPOP list_name

# Get list range
redis-cli LRANGE list_name 0 -1
```

#### Hash Operations
```bash
# Set hash field
redis-cli HSET hash_name field value

# Get hash field
redis-cli HGET hash_name field

# Get all hash fields
redis-cli HGETALL hash_name
```

---

## Integration Examples

### Media Request Workflow

#### 1. User requests media via Overseerr
```bash
# Create request
curl -X POST -H "X-Api-Key: OVERSEERR_API_KEY" \
  -H "Content-Type: application/json" \
  http://overseerr:5055/api/v1/request \
  -d '{
    "mediaType": "movie",
    "mediaId": 12345,
    "requestedBy": "user@domain.com"
  }'
```

#### 2. Overseerr sends to Radarr
```bash
# Radarr receives request via webhook
curl -X POST -H "X-Api-Key: RADARR_API_KEY" \
  -H "Content-Type: application/json" \
  http://radarr:7878/api/v3/movie \
  -d '{
    "title": "Movie Title",
    "tmdbId": 12345,
    "qualityProfileId": 1,
    "rootFolderPath": "/movies",
    "monitored": true
  }'
```

#### 3. Radarr searches and downloads
```bash
# Search for movie
curl -X POST -H "X-Api-Key: RADARR_API_KEY" \
  -H "Content-Type: application/json" \
  http://radarr:7878/api/v3/command \
  -d '{
    "name": "MoviesSearch",
    "movieIds": [MOVIE_ID]
  }'
```

#### 4. Notify user of completion
```bash
# Send notification via webhook
curl -X POST -H "Content-Type: application/json" \
  http://notification-service/webhook \
  -d '{
    "type": "movie_downloaded",
    "title": "Movie Title",
    "user": "user@domain.com"
  }'
```

### Monitoring Integration

#### 1. Collect metrics from services
```bash
# Collect Jellyfin metrics
curl -H "X-Emby-Token: JELLYFIN_TOKEN" \
  http://jellyfin:8096/System/Info

# Collect Sonarr metrics
curl -H "X-Api-Key: SONARR_API_KEY" \
  http://sonarr:8989/api/v3/system/status

# Collect system metrics
curl http://prometheus:9090/api/v1/query?query=up
```

#### 2. Store in Prometheus
```bash
# Push metrics to Prometheus
curl -X POST -H "Content-Type: application/json" \
  http://prometheus:9090/api/v1/write \
  -d '{
    "metrics": [
      {
        "name": "jellyfin_users_online",
        "value": 5,
        "timestamp": 1640995200
      }
    ]
  }'
```

#### 3. Create Grafana dashboard
```bash
# Create dashboard via API
curl -X POST -H "Authorization: Bearer GRAFANA_TOKEN" \
  -H "Content-Type: application/json" \
  http://grafana:3000/api/dashboards/db \
  -d '{
    "dashboard": {
      "title": "Homelab Overview",
      "panels": [
        {
          "title": "Active Users",
          "type": "stat",
          "targets": [
            {
              "expr": "jellyfin_users_online"
            }
          ]
        }
      ]
    }
  }'
```

### Security Integration

#### 1. Monitor for threats
```bash
# Check CrowdSec decisions
curl http://crowdsec:8080/api/v1/decisions

# Check Fail2ban status
curl http://fail2ban:8080/jails/sshd/status
```

#### 2. Block malicious IPs
```bash
# Add IP to firewall
curl -X POST -H "Content-Type: application/json" \
  http://firewall-api/block \
  -d '{
    "ip": "192.168.1.100",
    "reason": "brute_force_attack",
    "duration": "1h"
  }'
```

#### 3. Update Pi-hole blacklist
```bash
# Add domain to blacklist
curl "http://pihole:8081/admin/api.php?add&list=blacklist&domain=malicious.com&auth=PIHOLE_TOKEN"
```

### Backup Integration

#### 1. Trigger backup
```bash
# Start backup process
curl -X POST -H "Content-Type: application/json" \
  http://backup-service/api/v1/backup \
  -d '{
    "type": "full",
    "services": ["jellyfin", "nextcloud", "postgres"],
    "destination": "local"
  }'
```

#### 2. Monitor backup progress
```bash
# Check backup status
curl http://backup-service/api/v1/backup/status

# Get backup logs
curl http://backup-service/api/v1/backup/logs
```

#### 3. Verify backup
```bash
# Verify backup integrity
curl -X POST -H "Content-Type: application/json" \
  http://backup-service/api/v1/backup/verify \
  -d '{
    "backup_id": "backup_20230101_120000"
  }'
```

This comprehensive API reference provides detailed information about all service APIs and integration points in your homelab system, enabling you to build custom integrations and automate workflows. 