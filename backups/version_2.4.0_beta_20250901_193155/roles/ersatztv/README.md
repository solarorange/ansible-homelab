# ErsatzTV Role

A comprehensive Ansible role for deploying and managing ErsatzTV in a homelab environment. ErsatzTV is beta software for configuring and streaming custom live channels using your media library.

## Overview

ErsatzTV provides IPTV server and HDHomeRun emulation support for a wide range of client applications, allowing you to create custom live channels from your media library.

### Features

- **Local Media Support**: Use local media files with optional sidecar NFO metadata
- **IPTV Server**: Support for IPTV clients and HDHomeRun emulation
- **Multiple Streaming Modes**: MPEG-TS or HLS streaming with channel-specific settings
- **Collection-based Scheduling**: Powerful scheduling with collections containing TV shows, seasons, episodes, and movies
- **Hardware Acceleration**: Support for QSV, NVENC, and VAAPI transcoding
- **Media Server Integration**: Plex, Jellyfin, and Emby media and metadata support
- **Music Support**: Song and music video libraries
- **Filler Content**: Pre-roll, mid-roll, post-roll filler options
- **Subtitle Support**: Subtitle burn-in capabilities

## Requirements

### System Requirements
- Minimum 2 CPU cores
- 4GB RAM (8GB recommended for transcoding)
- 10GB+ storage space for configuration and transcoding
- Docker and Docker Compose
- Ansible 2.9+

### Dependencies
- Docker role
- Traefik role (for reverse proxy)
- Media stack role (for media library access)
- Monitoring infrastructure (optional)

## Role Variables

### Main Configuration
```yaml
# Enable/disable ErsatzTV
ersatztv_enabled: true

# Container configuration
ersatztv_image: "ghcr.io/ersatztv/ersatztv:latest"
ersatztv_container_name: "ersatztv"
ersatztv_restart_policy: "unless-stopped"

# Network configuration
ersatztv_network_name: "media"
ersatztv_network_external: true
ersatztv_port: 8409
ersatztv_subdomain: "ersatztv"
```

### Volume Configuration
```yaml
# Directory structure
ersatztv_config_dir: "/opt/docker/ersatztv/config"
ersatztv_data_dir: "/opt/docker/ersatztv/data"
ersatztv_logs_dir: "/opt/docker/ersatztv/logs"
ersatztv_transcode_dir: "/opt/docker/ersatztv/transcode"

# Media library mounts
ersatztv_media_mounts:
  - "/mnt/media/movies:/media/movies:ro"
  - "/mnt/media/tv:/media/tv:ro"
  - "/mnt/media/music:/media/music:ro"
```

### Resource Configuration
```yaml
# Resource limits
ersatztv_resources:
  limits:
    cpus: '2'
    memory: 4G
  reservations:
    cpus: '0.5'
    memory: 1G
```

### Traefik Integration
```yaml
# Traefik configuration
ersatztv_traefik_enabled: true
ersatztv_traefik_ssl_resolver: "cloudflare"
ersatztv_traefik_auth_enabled: true
```

## Installation

### Basic Installation
```bash
# Add to your playbook
- hosts: homelab
  roles:
    - ersatztv
```

### With Custom Configuration
```bash
# Create group_vars/all/ersatztv.yml
ersatztv_enabled: true
ersatztv_port: 8409
ersatztv_subdomain: "tv"
ersatztv_media_mounts:
  - "/mnt/media/movies:/media/movies:ro"
  - "/mnt/media/tv:/media/tv:ro"
```

## Configuration

### Initial Setup
1. Deploy the role using Ansible
2. Access ErsatzTV at `https://ersatztv.yourdomain.com`
3. Configure media libraries in the web interface
4. Set up collections and scheduling
5. Configure streaming settings

### Media Library Configuration
- **Local Files**: Mount media directories as read-only volumes
- **Plex Integration**: Configure Plex server connection
- **Jellyfin Integration**: Configure Jellyfin server connection
- **Emby Integration**: Configure Emby server connection

### Channel Configuration
- **Collections**: Create collections of media content
- **Scheduling**: Set up chronological or random playback
- **Streaming Mode**: Choose MPEG-TS or HLS
- **Transcoding**: Configure hardware acceleration if available

### Hardware Acceleration
```yaml
# Enable VAAPI (Intel GPU)
ersatztv_hardware_acceleration: "vaapi"
ersatztv_vaapi_device: "/dev/dri/renderD128"

# Enable NVENC (NVIDIA GPU)
ersatztv_hardware_acceleration: "nvenc"
ersatztv_nvidia_runtime: true
```

## Integration Points

### Traefik Integration
- Automatic SSL certificate management
- Reverse proxy configuration
- Authentication integration (optional)

### Monitoring Integration
- Prometheus metrics collection
- Grafana dashboard templates
- Health check monitoring
- Log aggregation with Loki

### Backup Integration
- Configuration backup
- Database backup (if using external database)
- Scheduled backup automation

### Homepage Integration
- Automatic service discovery
- Dashboard widget configuration
- Status monitoring

## Usage

### Web Interface
- **URL**: `https://ersatztv.yourdomain.com`
- **Default Port**: 8409
- **Authentication**: Configured via Traefik

### API Access
- **API Endpoint**: `https://ersatztv.yourdomain.com/api`
- **Documentation**: Available in web interface

### Client Applications
- **IPTV Clients**: VLC, Kodi, Plex, etc.
- **HDHomeRun Clients**: Compatible with HDHomeRun applications
- **Mobile Apps**: IPTV player applications

## Troubleshooting

### Common Issues

#### Service Not Starting
```bash
# Check container logs
docker logs ersatztv

# Check resource usage
docker stats ersatztv

# Verify volume permissions
ls -la /opt/docker/ersatztv/
```

#### Transcoding Issues
```bash
# Check hardware acceleration
docker exec ersatztv ffmpeg -hide_banner -f lavfi -i testsrc -t 1 -f null -

# Verify GPU access
docker exec ersatztv ls -la /dev/dri/
```

#### Network Issues
```bash
# Check Traefik configuration
docker logs traefik | grep ersatztv

# Verify DNS resolution
nslookup ersatztv.yourdomain.com
```

### Log Locations
- **Application Logs**: `/opt/docker/ersatztv/logs/`
- **Docker Logs**: `docker logs ersatztv`
- **Traefik Logs**: `docker logs traefik`

### Performance Optimization
- **Hardware Acceleration**: Enable VAAPI or NVENC for better performance
- **Resource Limits**: Adjust CPU and memory limits based on usage
- **Transcode Directory**: Use tmpfs for faster transcoding
- **Media Library**: Optimize media file organization

## Security Considerations

### Network Security
- **Reverse Proxy**: All traffic goes through Traefik
- **SSL/TLS**: Automatic certificate management
- **Authentication**: Optional authentication via Traefik

### Container Security
- **Read-only Media**: Media directories mounted as read-only
- **Resource Limits**: CPU and memory limits prevent resource exhaustion
- **Non-root User**: Container runs as non-root user
- **Security Options**: No new privileges enabled

### Hardening Notes
- The compose template enforces `security_opt: [no-new-privileges:true]` and `cap_drop: [ALL]`.
- `read_only` is disabled by default due to transcode and cache directories; tmpfs mounts are used for `/tmp`.

### Data Protection
- **Configuration Backup**: Regular backup of configuration
- **Media Protection**: Media files are read-only in container
- **Log Rotation**: Automatic log rotation and cleanup

## Monitoring and Alerting

### Metrics Collection
- **Prometheus**: Application metrics collection
- **Grafana**: Dashboard templates included
- **Health Checks**: Automated health monitoring

### Alerting
- **Service Status**: Monitor service availability
- **Resource Usage**: CPU and memory monitoring
- **Error Rates**: Track application errors
- **Performance**: Monitor transcoding performance

## Backup and Recovery

### Backup Configuration
```yaml
# Backup settings
ersatztv_backup_enabled: true
ersatztv_backup_retention: 30
ersatztv_backup_schedule: "0 2 * * *"
```

### Backup Contents
- Configuration files
- Database (if external)
- Custom settings
- Channel configurations

### Recovery Process
1. Stop ErsatzTV service
2. Restore configuration from backup
3. Restore database if applicable
4. Start service
5. Verify functionality

## Development and Customization

### Custom Docker Image
```yaml
# Use custom image
ersatztv_image: "your-registry/ersatztv:custom"
ersatztv_image_pull_policy: "always"
```

### Environment Variables
```yaml
# Custom environment variables
ersatztv_environment:
  - "CUSTOM_VAR=value"
  - "DEBUG=true"
```

### Volume Customization
```yaml
# Custom volume mounts
ersatztv_custom_volumes:
  - "/custom/path:/container/path:ro"
```

## Support and Community

### Documentation
- **Official Docs**: [ersatztv.org](https://ersatztv.org/)
- **GitHub**: [ErsatzTV Repository](https://github.com/ErsatzTV/ErsatzTV)

### Community
- **Discord**: [ErsatzTV Community](https://discord.gg/hHaJm3yGy6)
- **Forum**: [ErsatzTV Discussion](https://discuss.ersatztv.org/)

### Issues and Bug Reports
- **GitHub Issues**: Report bugs and feature requests
- **Community Support**: Get help from the community

## License

This role is released under the MIT License. ErsatzTV itself is released under the zlib license.

## Changelog

### Version 1.0.0
- Initial role implementation
- Basic ErsatzTV deployment
- Traefik integration
- Monitoring integration
- Backup configuration
- Homepage integration 

## Rollback

- Automatic rollback on failed deploys: The compose deploy wrapper restores last-known-good Compose and the pre-change snapshot if a deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., ersatztv
    sudo cp {{ backup_dir }}/${SERVICE}/last_good/docker-compose.yml {{ docker_dir }}/${SERVICE}/docker-compose.yml
    if [ -f {{ backup_dir }}/${SERVICE}/last_good/.env ]; then sudo cp {{ backup_dir }}/${SERVICE}/last_good/.env {{ docker_dir }}/${SERVICE}/.env; fi
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```
  - Option B — restore pre-change snapshot
    ```bash
    SERVICE=<service>
    ls -1 {{ backup_dir }}/${SERVICE}/prechange_*.tar.gz
    sudo tar -xzf {{ backup_dir }}/${SERVICE}/prechange_<TIMESTAMP>.tar.gz -C /
    docker compose -f {{ docker_dir }}/${SERVICE}/docker-compose.yml up -d
    ```

- Rollback to a recorded rollback point (run on the target host):
  ```bash
  ls -1 {{ docker_dir }}/rollback/rollback-point-*.json | sed -E 's/.*rollback-point-([0-9]+)\.json/\1/'
  sudo {{ docker_dir }}/rollback/rollback.sh <ROLLBACK_ID>
  ```

- Full stack version rollback:
  ```bash
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh --list
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh tag:vX.Y.Z
  /Users/rob/Cursor/ansible_homelab/scripts/version_rollback.sh backup:/Users/rob/Cursor/ansible_homelab/backups/versions/<backup_dir>
  ```