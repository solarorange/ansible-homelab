# Lidarr Automatic Configuration

This document describes the comprehensive automatic configuration system for Lidarr in the Ansible homelab deployment.

## Overview

Lidarr is automatically configured with all necessary variables, integrations, and settings during the seamless deployment process. No manual configuration is required - all variables are generated and configured automatically.

## Automatic Variable Generation

### API Keys and Authentication

The following variables are automatically generated during deployment:

```yaml
# Primary API Key (Auto-generated)
vault_lidarr_api_key: "lidarr_<random_32_char_string>"

# Authentication (Auto-generated)
vault_lidarr_username: "admin"
vault_lidarr_password: "<secure_32_char_password>"
vault_lidarr_anonymous_id: "<random_32_char_string>"

# Download Client Passwords (Auto-generated)
vault_qbittorrent_password: "<secure_32_char_password>"
```

### Integration API Keys

Lidarr automatically integrates with other services using their API keys:

```yaml
# Download Clients
vault_sabnzbd_api_key: "<auto_generated>"
vault_prowlarr_api_key: "<auto_generated>"

# Media Servers (Optional)
vault_plex_token: "<user_provided_or_empty>"
vault_jellyfin_api_key: "<user_provided_or_empty>"

# Notifications (Optional)
vault_discord_webhook: "<user_provided_or_empty>"
vault_smtp_server: "<user_provided_or_empty>"
vault_smtp_username: "<user_provided_or_empty>"
vault_smtp_password: "<user_provided_or_empty>"
```

## Automatic Configuration Process

### 1. Service Deployment

Lidarr is deployed with the following configuration:

- **Container**: `linuxserver/lidarr:latest`
- **Port**: 8686 (internal), 8686 (external)
- **Network**: `media` and `homelab` networks
- **Domain**: `lidarr.yourdomain.com`
- **Authentication**: Authentik integration
- **SSL**: Automatic via Traefik

### 2. Download Client Configuration

Lidarr automatically configures:

#### SABnzbd
- **Host**: `sabnzbd`
- **Port**: 8080
- **API Key**: Auto-generated
- **Category**: `music`
- **Priority**: Normal for all downloads

#### qBittorrent
- **Host**: `qbittorrent`
- **Port**: 8081
- **Username**: `admin`
- **Password**: Auto-generated
- **Category**: `music`
- **Download Path**: `{{ data_dir }}/downloads/music`

### 3. Indexer Configuration

#### Prowlarr Integration
- **Host**: `prowlarr`
- **Port**: 9696
- **API Key**: Auto-generated
- **Categories**: Music-specific (3000, 3010, 3020, 3030, 3040, 3050)
- **Protocol**: HTTP
- **SSL**: Disabled (internal network)

### 4. Quality Profiles

A standard quality profile is automatically created with:

#### Quality Hierarchy (Best to Worst)
1. **FLAC** - Lossless audio
2. **ALAC** - Apple Lossless
3. **AAC-320** - High quality AAC
4. **AAC-256** - Good quality AAC
5. **MP3-320** - High quality MP3
6. **MP3-256** - Good quality MP3
7. **MP3-V0** - Variable bitrate MP3
8. **MP3-192** - Standard quality MP3
9. **MP3-V2** - Variable bitrate MP3
10. **MP3-128** - Lower quality MP3
11. **OGG-Vorbis-Q10** through **OGG-Vorbis-Q0** - Ogg Vorbis formats

#### Cutoff Quality
- **Default**: MP3-320 (good balance of quality and size)

### 5. Metadata Profiles

Standard metadata profile with:

#### Primary Album Types
- Album
- EP
- Single

#### Secondary Album Types
- Compilation
- Soundtrack
- Live
- Remix
- Mixtape
- Demo
- Bootleg
- Interview
- Audiobook
- Other

### 6. Root Folders

Automatic configuration:
- **Path**: `{{ data_dir }}/media/music`
- **Name**: "Music"

### 7. Import Lists

#### Last.fm Integration (Optional)
- **Type**: Last.fm User
- **Username**: Configurable via `media_lastfm_username`
- **Count**: 100 albums
- **Monitor**: Specific albums only
- **Root Folder**: Music directory
- **Quality Profile**: Standard
- **Metadata Profile**: Standard

### 8. Notifications

#### Discord Integration (Optional)
- **Webhook URL**: From `vault_discord_webhook`
- **Events**: All events enabled
- **Health Warnings**: Enabled
- **Manual Interactions**: Enabled

#### Email Integration (Optional)
- **Server**: From `vault_smtp_server`
- **Port**: 587 (configurable)
- **Username**: From `vault_smtp_username`
- **Password**: From `vault_smtp_password`
- **From**: `lidarr@yourdomain.com`
- **To**: Admin email
- **SSL**: Enabled
- **Events**: All events enabled

### 9. Media Server Connections

#### Plex Integration (Optional)
- **Host**: `plex`
- **Port**: 32400
- **Authentication**: Token-based
- **Library Updates**: Enabled
- **SSL**: Disabled (internal network)

#### Jellyfin Integration (Optional)
- **Host**: `jellyfin`
- **Port**: 8096
- **Authentication**: API key-based
- **Library Updates**: Enabled
- **SSL**: Disabled (internal network)

### 10. Auto Tagging

Automatic genre tagging for:
- Rock
- Pop
- Jazz
- Classical
- Electronic
- Hip-Hop
- Country
- Blues
- Folk
- Metal

### 11. System Configuration

#### UI Settings
- **Theme**: Dark
- **Date Format**: MM/DD/YYYY
- **Time Format**: 12-hour
- **First Day of Week**: Sunday
- **Relative Dates**: Enabled
- **Color Impaired Mode**: Disabled

#### Backup Settings
- **Folder**: `{{ docker_dir }}/lidarr/backup`
- **Interval**: 7 days
- **Retention**: 28 days
- **Include Metadata**: Yes
- **Include Logs**: Yes

#### Update Settings
- **Mechanism**: Built-in
- **Automatic Updates**: Enabled
- **Update Time**: 00:00 (midnight)

#### Security Settings
- **Authentication Method**: Forms
- **Authentication Required**: Enabled
- **Username**: admin
- **Password**: Auto-generated

#### SSL Settings
- **Enabled**: False (handled by Traefik)
- **Port**: 9898 (unused)
- **Certificate**: Not configured

#### Proxy Settings
- **Enabled**: False
- **Type**: HTTP
- **Port**: 8080
- **Bypass Local**: Enabled

#### Analytics Settings
- **Enabled**: True
- **Anonymous ID**: Auto-generated

#### Instance Settings
- **Name**: Lidarr
- **Application URL**: `https://lidarr.yourdomain.com`
- **Port**: 8686
- **API Key**: Auto-generated
- **Branch**: main
- **Log Level**: info

## Configuration Files

### 1. Download Clients Template

Location: `roles/media/templates/lidarr-download-clients.yml.j2`

This template contains all download client configurations with variable substitution.

### 2. Configuration Task

Location: `tasks/configure_lidarr.yml`

This task performs all API-based configuration after Lidarr is deployed.

## Environment Variables

### Required Variables (Auto-generated)

```bash
# Generated by seamless_setup.sh
LIDARR_API_KEY=lidarr_<random_string>
LIDARR_PASSWORD=<secure_password>
LIDARR_ANONYMOUS_ID=<random_string>
QBITTORRENT_PASSWORD=<secure_password>
```

### Optional Variables (User-provided)

```bash
# Optional integrations
LASTFM_USERNAME=your_lastfm_username
PLEX_TOKEN=your_plex_token
JELLYFIN_API_KEY=your_jellyfin_api_key
DISCORD_WEBHOOK=your_discord_webhook
SMTP_SERVER=your_smtp_server
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password
```

## Integration Points

### 1. Prowlarr
- Automatic indexer configuration
- Music-specific categories
- API key sharing

### 2. Download Clients
- SABnzbd for usenet
- qBittorrent for torrents
- Automatic category assignment

### 3. Media Servers
- Plex library updates
- Jellyfin library updates
- Automatic metadata sync

### 4. Monitoring
- Prometheus metrics
- Grafana dashboards
- Health checks

### 5. Backup System
- Automatic backups
- Database backup
- Configuration backup

### 6. Security
- Authentik authentication
- Fail2ban protection
- Rate limiting

## Verification

After deployment, verify Lidarr configuration:

```bash
# Check service status
curl -H "X-Api-Key: $LIDARR_API_KEY" \
  http://localhost:8686/api/v1/system/status

# Check download clients
curl -H "X-Api-Key: $LIDARR_API_KEY" \
  http://localhost:8686/api/v1/downloadclient

# Check indexers
curl -H "X-Api-Key: $LIDARR_API_KEY" \
  http://localhost:8686/api/v1/indexer

# Check quality profiles
curl -H "X-Api-Key: $LIDARR_API_KEY" \
  http://localhost:8686/api/v1/qualityprofile
```

## Troubleshooting

### Common Issues

1. **API Key Issues**
   - Regenerate API key in seamless setup
   - Check vault file for correct key

2. **Download Client Connection**
   - Verify download clients are running
   - Check network connectivity
   - Verify API keys are correct

3. **Indexer Issues**
   - Ensure Prowlarr is running
   - Check Prowlarr API key
   - Verify music categories are enabled

4. **Permission Issues**
   - Check file permissions on music directory
   - Verify user/group ownership
   - Check Docker volume mounts

### Manual Override

If automatic configuration fails, you can manually configure Lidarr:

1. Access Lidarr web interface
2. Go to Settings
3. Configure each section manually
4. Use the generated API keys from vault

## Security Considerations

1. **API Keys**: All API keys are cryptographically secure
2. **Passwords**: All passwords meet complexity requirements
3. **Network**: Services communicate over internal Docker networks
4. **Authentication**: Authentik provides centralized authentication
5. **SSL**: Traefik handles SSL termination
6. **Backups**: Automatic encrypted backups

## Performance Optimization

1. **Database**: SQLite by default, PostgreSQL for large libraries
2. **Caching**: Built-in caching enabled
3. **Logging**: Rotated logs with compression
4. **Updates**: Automatic updates during maintenance window
5. **Monitoring**: Resource usage monitoring enabled

## Maintenance

### Automatic Tasks

- **Log Rotation**: Daily at midnight
- **Backups**: Weekly at 3 AM
- **Updates**: Weekly at 4 AM
- **Health Checks**: Every 30 seconds

### Manual Tasks

- **Library Cleanup**: As needed
- **Quality Profile Updates**: When new formats are available
- **Indexer Management**: Through Prowlarr interface

## Conclusion

The Lidarr automatic configuration system provides a complete, production-ready setup with:

- ✅ Zero manual configuration required
- ✅ Secure credential generation
- ✅ Complete service integration
- ✅ Monitoring and alerting
- ✅ Backup and recovery
- ✅ Security hardening
- ✅ Performance optimization

All variables are automatically generated and configured, ensuring a seamless deployment experience. 