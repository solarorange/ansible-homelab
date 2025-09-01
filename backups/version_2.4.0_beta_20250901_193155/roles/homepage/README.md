# Homepage Role

This role deploys and configures Homepage (https://github.com/benphelps/homepage) with comprehensive automation for homelab services.

## Features

- **Automated Deployment**: Docker-based deployment with Traefik integration
- **Pre-configured Services**: All homelab services with proper icons, URLs, and descriptions
- **Service Groups**: Organized into logical categories (Media, Monitoring, Management, Security, etc.)
- **Widgets**: Weather, system monitoring, and service-specific widgets
- **Bookmarks**: Pre-configured bookmarks for common resources
- **Theme Configuration**: Dark theme with custom styling
- **API Integration**: REST API configuration for dynamic updates
- **Health Monitoring**: Service health checks and status monitoring

## Service Categories

### Media Services
- Sonarr, Radarr, Jellyfin, Overseerr, Prowlarr, Bazarr, Tautulli

### Monitoring Services
- Grafana, Prometheus, AlertManager, Loki

### Management Services
- Portainer, Authentik, Traefik

### Security Services
- CrowdSec, Fail2ban

### Utility Services
- Homepage itself, Watchtower

### External Services
- GitHub, Documentation, Support links

## Configuration

The role uses a Python script (`setup_homepage.py`) to configure Homepage via its REST API, similar to the Authentik setup script.

### Environment Variables

- `HOMEPAGE_URL`: Homepage service URL
- `DOMAIN`: Your domain name
- `WEATHER_LAT`: Latitude for weather widget
- `WEATHER_LON`: Longitude for weather widget
- `WEATHER_API_KEY`: OpenWeatherMap API key

### Service Configuration

Services are configured with:
- Proper icons from Homepage's icon library
- Service-specific widgets where available
- Group categorization
- Health monitoring integration

## Usage

```bash
# Deploy Homepage with all services
ansible-playbook site.yml --tags homepage

# Deploy only Homepage without configuration
ansible-playbook site.yml --tags homepage,homepage-deploy

# Configure Homepage services only
ansible-playbook site.yml --tags homepage,homepage-config
```

## Files

- `tasks/main.yml`: Main deployment tasks
- `tasks/deploy.yml`: Docker deployment
- `tasks/configure.yml`: Service configuration
- `templates/setup_homepage.py.j2`: Python configuration script
- `templates/docker-compose.yml.j2`: Docker Compose configuration
- `templates/config.yml.j2`: Homepage main configuration
- `templates/services.yml.j2`: Service definitions
- `templates/bookmarks.yml.j2`: Bookmark definitions
- `vars/main.yml`: Role variables

## Integration

This role integrates with:
- Traefik for reverse proxy
- Authentik for authentication
- Monitoring stack for health checks
- Backup system for configuration backup 

## Rollback

- Automatic rollback on failed deploys: The deploy wrapper restores the last-known-good Compose and pre-change snapshot automatically if a deployment fails.

- Manual rollback (this service):
  - Option A — restore last-known-good Compose
    ```bash
    SERVICE=<service>  # e.g., homepage
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

- Rollback to a recorded rollback point (target host):
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