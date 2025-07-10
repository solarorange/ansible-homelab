#!/bin/bash

# Homepage Icons Setup Script
# Downloads and sets up icons for all services in the Homepage configuration

set -e

# Configuration
ICONS_DIR="/home/{{ username }}/docker/homepage/config/icons"
ICONS_REPO="https://raw.githubusercontent.com/gethomepage/homepage/main/public/icons"

# Create icons directory if it doesn't exist
mkdir -p "$ICONS_DIR"

# List of all service icons needed
declare -a icons=(
    # Infrastructure
    "traefik.png"
    "authentik.png"
    "portainer.png"
    
    # Monitoring
    "grafana.png"
    "prometheus.png"
    "influxdb.png"
    "loki.png"
    "promtail.png"
    "alertmanager.png"
    "blackbox.png"
    "telegraf.png"
    "uptimekuma.png"
    "dashdot.png"
    "fing.png"
    
    # Network
    "pihole.png"
    "nginx.png"
    
    # Media
    "jellyfin.png"
    "emby.png"
    "sonarr.png"
    "radarr.png"
    "lidarr.png"
    "readarr.png"
    "prowlarr.png"
    "bazarr.png"
    "tautulli.png"
    "overseerr.png"
    "pulsarr.png"
    "komga.png"
    "audiobookshelf.png"
    "calibre.png"
    "tdarr.png"
    "sabnzbd.png"
    "qbittorrent.png"
    
    # Storage
    "postgresql.png"
    "mariadb.png"
    "redis.png"
    "elasticsearch.png"
    "kibana.png"
    "nextcloud.png"
    "samba.png"
    "syncthing.png"
    "minio.png"
    "paperless.png"
    "bookstack.png"
    "immich.png"
    "filebrowser.png"
    
    # Security
    "crowdsec.png"
    "fail2ban.png"
    "vault.png"
    "vaultwarden.png"
    "wireguard.png"
    
    # Automation
    "homeassistant.png"
    "zigbee2mqtt.png"
    "mosquitto.png"
    "nodered.png"
    "n8n.png"
    
    # Development
    "gitlab.png"
    "harbor.png"
    "codeserver.png"
    "guacamole.png"
    
    # Backup
    "kopia.png"
    "duplicati.png"
    
    # Utilities
    "heimdall.png"
    "homarr.png"
    "requestrr.png"
    "unmanic.png"
    "watchtower.png"
)

echo "Setting up Homepage icons..."

# Function to print error messages
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if icons directory exists
if [[ ! -d "$ICONS_DIR" ]]; then
    print_error "Icons directory $ICONS_DIR not found."
    exit 1
fi

# Download each icon
for icon in "${icons[@]}"; do
    if [ ! -f "$ICONS_DIR/$icon" ]; then
        echo "Downloading $icon..."
        curl -s -o "$ICONS_DIR/$icon" "$ICONS_REPO/$icon"
        if [ $? -eq 0 ]; then
            echo "✓ Downloaded $icon"
        else
            echo "✗ Failed to download $icon"
        fi
    else
        echo "✓ $icon already exists"
    fi
done

# Set proper permissions
chown -R {{ username }}:{{ username }} "$ICONS_DIR"
chmod -R 644 "$ICONS_DIR"

echo "Homepage icons setup complete!"
echo "Icons directory: $ICONS_DIR" 