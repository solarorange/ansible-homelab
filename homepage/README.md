# Homelab Homepage Dashboard

This directory contains the configuration for the Homepage dashboard, which provides a beautiful and functional interface for your homelab services.

## Configuration Files

- `config.yml`: Main configuration file for Homepage
- `services.yml`: Service definitions and widget configurations
- `bookmarks.yml`: Organized bookmarks for quick access to services
- `docker-compose.yml`: Docker Compose configuration for deployment

## Setup Instructions

1. Replace all instances of `zorg.media` in the configuration files with your actual domain name if different.

2. Generate and configure API keys for services that require them:
   - Traefik
   - Authentik
   - Portainer
   - Grafana
   - Jellyfin
   - Plex
   - Sonarr
   - Radarr
   - Lidarr
   - Readarr
   - Prowlarr
   - Bazarr
   - Tautulli
   - Overseerr
   - Home Assistant
   - Nextcloud
   - GitLab
   - Harbor
   - MinIO
   - Paperless
   - BookStack
   - Immich
   - FileBrowser
   - Kopia
   - Duplicati
   - Uptime Kuma
   - Guacamole
   - Requestrr
   - Unmanic

3. Deploy using Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. Access the dashboard at `https://homepage.zorg.media`

## Customization

- Modify `config.yml` to change the theme, layout, and enabled widgets
- Update `services.yml` to add, remove, or modify service configurations
- Edit `bookmarks.yml` to organize your bookmarks differently
- Customize icons by placing them in the `config/icons` directory

## Security Notes

- Keep your API keys secure and never commit them to version control
- Consider using environment variables or a secrets manager for sensitive data
- Regularly update the Homepage container to get the latest features and security patches

## Troubleshooting

1. If widgets are not loading:
   - Check API keys and URLs in `services.yml`
   - Verify network connectivity between Homepage and services
   - Check service logs for errors

2. If bookmarks are not working:
   - Verify domain names and URLs
   - Check if services are accessible
   - Ensure proper DNS configuration

3. If the dashboard is not accessible:
   - Check if the container is running
   - Verify port mappings
   - Check Traefik configuration
   - Review container logs

## Maintenance

- Regularly update the Homepage container:
  ```bash
  docker-compose pull
  docker-compose up -d
  ```

- Backup your configuration:
  ```bash
  tar -czf homepage-config-backup.tar.gz config/
  ```

## Additional Resources

- [Homepage Documentation](https://gethomepage.dev)
- [Homepage GitHub Repository](https://github.com/gethomepage/homepage)
- [Homepage Discord Community](https://discord.gg/gethomepage) 