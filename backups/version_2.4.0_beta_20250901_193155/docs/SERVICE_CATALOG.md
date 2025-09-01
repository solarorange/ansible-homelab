# Service Catalog: Complete Guide to Homelab Services

## Table of Contents

1. [Infrastructure Services](#infrastructure-services)
2. [Media & Entertainment Services](#media--entertainment-services)
3. [Security & Privacy Services](#security--privacy-services)
4. [Storage & File Services](#storage--file-services)
5. [Development & Business Services](#development--business-services)
6. [Home Automation Services](#home-automation-services)
7. [Monitoring & Management Services](#monitoring--management-services)
8. [Utility Services](#utility-services)

---

## Infrastructure Services

### Traefik (Reverse Proxy)
**What it does**: Acts as a smart traffic director for your network, routing requests to the correct services.

**Why you need it**: 
- Provides a single entry point for all your services
- Handles SSL certificates automatically
- Load balances traffic across multiple servers
- Simplifies service management

**How it works**:
- Listens on ports 80 and 443
- Routes traffic based on domain names
- Automatically obtains SSL certificates from Let's Encrypt
- Provides a web dashboard for monitoring

**Use cases**:
- Access all services through custom domain names
- Secure HTTPS connections for all services
- Load balancing for high availability
- Service discovery and health checking

**Configuration example**:
```yaml
version: '3.8'
services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.yml:/etc/traefik/traefik.yml
      - ./acme.json:/acme.json
    restart: unless-stopped
```

### Authentik (Identity Provider)
**What it does**: Provides single sign-on (SSO) authentication for all your services.

**Why you need it**:
- One login for all services
- Centralized user management
- Advanced security features
- Integration with external providers

**How it works**:
- Acts as an identity provider (IdP)
- Integrates with services via SAML, OAuth, or OpenID Connect
- Provides user directory and group management
- Offers multi-factor authentication

**Use cases**:
- Single login for family members
- Business user management
- Integration with Google, Microsoft, or other providers
- Advanced access control policies

### Docker (Container Platform)
**What it does**: Provides the foundation for running all services in isolated containers.

**Why you need it**:
- Isolates services from each other
- Simplifies deployment and updates
- Provides consistent environments
- Resource management and limits

**How it works**:
- Each service runs in its own container
- Containers share the host operating system
- Images are downloaded and cached
- Volumes persist data between container restarts

**Use cases**:
- Running multiple services on one server
- Easy service updates and rollbacks
- Resource isolation and security
- Simplified backup and migration

---

## Media & Entertainment Services

### Jellyfin (Media Server)
**What it does**: Your own Netflix - streams movies, TV shows, and music to any device.

**Why you need it**:
- Watch your media collection anywhere
- No monthly subscription fees
- Complete control over your content
- Advanced features like transcoding

**How it works**:
- Scans your media folders for movies, TV shows, and music
- Automatically downloads metadata (posters, descriptions)
- Transcodes media for different devices
- Provides web interface and mobile apps

**Use cases**:
- Family movie nights
- Personal media library
- Remote viewing when traveling
- Sharing media with friends and family

**Configuration example**:
```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096"
    volumes:
      - ./config:/config
      - /media/movies:/movies
      - /media/tv:/tv
      - /media/music:/music
    environment:
      - JELLYFIN_PublishedServerUrl=jellyfin.yourdomain.com
    restart: unless-stopped
```

### Sonarr (TV Show Management)
**What it does**: Automatically downloads and organizes TV shows.

**Why you need it**:
- Automates TV show downloads
- Organizes episodes automatically
- Integrates with download clients
- Quality management and upgrades

**How it works**:
- Monitors your TV show library
- Searches for new episodes
- Sends downloads to SABnzbd or qBittorrent
- Renames and organizes files
- Integrates with Jellyfin

**Use cases**:
- Automatic TV show downloads
- Quality upgrades when better versions become available
- Integration with media servers
- Remote management via web interface

### Radarr (Movie Management)
**What it does**: Automatically downloads and organizes movies.

**Why you need it**:
- Automates movie downloads
- Quality management and upgrades
- Integration with media servers
- Remote management capabilities

**How it works**:
- Monitors your movie library
- Searches for new releases
- Manages quality preferences
- Integrates with download clients and media servers

**Use cases**:
- Building a movie collection
- Quality management
- Integration with Jellyfin or Plex
- Remote movie requests

### Lidarr (Music Management)
**What it does**: Automatically downloads and organizes music.

**Why you need it**:
- Automates music downloads
- Quality management
- Integration with music players
- Artist and album tracking

**How it works**:
- Monitors your music library
- Searches for new releases
- Manages quality preferences
- Integrates with download clients

**Use cases**:
- Building a music collection
- Quality management
- Integration with music servers
- Artist tracking and notifications

### Readarr (Book Management)
**What it does**: Automatically downloads and organizes e-books and audiobooks.

**Why you need it**:
- Automates book downloads
- Supports multiple formats
- Integration with e-readers
- Author tracking

**How it works**:
- Monitors your book library
- Searches for new releases
- Manages different formats
- Integrates with Calibre

**Use cases**:
- Building an e-book library
- Audiobook management
- Integration with e-readers
- Author tracking and notifications

### Prowlarr (Indexer Management)
**What it does**: Centralized indexer management for all your download services.

**Why you need it**:
- Single interface for all indexers
- Automatic indexer testing
- Integration with all download services
- Simplified configuration

**How it works**:
- Manages multiple indexers
- Tests indexer availability
- Provides API for other services
- Handles authentication

**Use cases**:
- Centralized indexer management
- Integration with Sonarr, Radarr, Lidarr
- Indexer testing and monitoring
- Simplified setup

### Bazarr (Subtitle Management)
**What it does**: Automatically downloads subtitles for your media.

**Why you need it**:
- Automatic subtitle downloads
- Multiple language support
- Quality management
- Integration with media servers

**How it works**:
- Monitors your media library
- Searches for subtitles
- Downloads and renames files
- Integrates with media servers

**Use cases**:
- Multi-language households
- Accessibility support
- Integration with media servers
- Quality subtitle management

### SABnzbd (Usenet Downloader)
**What it does**: Downloads files from Usenet newsgroups.

**Why you need it**:
- Fast downloads
- Automatic repair of damaged files
- Integration with media managers
- Web-based interface

**How it works**:
- Connects to Usenet providers
- Downloads NZB files
- Repairs and extracts files
- Integrates with media managers

**Use cases**:
- Fast media downloads
- Integration with Sonarr, Radarr
- Automated downloads
- Web-based management

### qBittorrent (BitTorrent Client)
**What it does**: Downloads files using the BitTorrent protocol.

**Why you need it**:
- Free downloads
- Integration with media managers
- Web-based interface
- Advanced features

**How it works**:
- Connects to BitTorrent trackers
- Downloads and uploads files
- Manages bandwidth
- Integrates with media managers

**Use cases**:
- Free media downloads
- Integration with Sonarr, Radarr
- Web-based management
- Bandwidth control

### Overseerr (Media Requests)
**What it does**: Web interface for requesting movies and TV shows.

**Why you need it**:
- User-friendly request interface
- Integration with media managers
- Approval workflows
- User management

**How it works**:
- Provides web interface for requests
- Integrates with Sonarr and Radarr
- Manages user permissions
- Sends notifications

**Use cases**:
- Family media requests
- Business media requests
- User management
- Approval workflows

### Tautulli (Media Statistics)
**What it does**: Tracks and reports on media server usage.

**Why you need it**:
- Usage statistics
- User activity monitoring
- Media consumption reports
- Integration with media servers

**How it works**:
- Monitors media server activity
- Tracks user behavior
- Generates reports
- Sends notifications

**Use cases**:
- Usage monitoring
- User activity tracking
- Media consumption analysis
- Integration with media servers

### Immich (Photo Management)
**What it does**: Self-hosted photo backup and sharing platform.

**Why you need it**:
- Automatic photo backup
- Photo sharing
- Mobile app support
- Privacy control

**How it works**:
- Uploads photos from mobile devices
- Organizes photos by date and location
- Provides sharing capabilities
- Offers mobile apps

**Use cases**:
- Photo backup
- Family photo sharing
- Mobile photo management
- Privacy-focused photo storage

### Calibre Web (E-book Server)
**What it does**: Web interface for managing and reading e-books.

**Why you need it**:
- E-book library management
- Web-based reading
- Multiple format support
- User management

**How it works**:
- Manages e-book library
- Provides web interface
- Supports multiple formats
- Integrates with Calibre

**Use cases**:
- E-book library management
- Web-based reading
- Family e-book sharing
- Integration with Readarr

### Audiobookshelf (Audiobook Server)
**What it does**: Self-hosted audiobook server with mobile apps.

**Why you need it**:
- Audiobook management
- Mobile app support
- Progress tracking
- Multiple user support

**How it works**:
- Manages audiobook library
- Provides mobile apps
- Tracks listening progress
- Supports multiple users

**Use cases**:
- Audiobook management
- Mobile listening
- Progress tracking
- Family audiobook sharing

### Komga (Comic Book Server)
**What it does**: Self-hosted comic book and manga server.

**Why you need it**:
- Comic book management
- Web-based reading
- Multiple format support
- User management

**How it works**:
- Manages comic book library
- Provides web interface
- Supports multiple formats
- User management

**Use cases**:
- Comic book library management
- Web-based reading
- Family comic sharing
- Multiple format support

---

## Security & Privacy Services

### Pi-hole (DNS Ad Blocker)
**What it does**: Blocks ads and malicious websites at the DNS level across your entire network.

**Why you need it**:
- Blocks ads on all devices
- Improves network performance
- Enhances privacy
- Protects against malicious sites

**How it works**:
- Acts as DNS server for your network
- Filters requests against blocklists
- Provides web interface for management
- Logs all DNS requests

**Use cases**:
- Network-wide ad blocking
- Privacy protection
- Malicious site blocking
- Network monitoring

**Configuration example**:
```yaml
services:
  pihole:
    image: pihole/pihole:latest
    container_name: pihole
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "8081:80"
    environment:
      - TZ=America/New_York
      - WEBPASSWORD=your-password
    volumes:
      - ./etc-pihole:/etc/pihole
      - ./etc-dnsmasq.d:/etc/dnsmasq.d
    restart: unless-stopped
```

### CrowdSec (Intrusion Detection)
**What it does**: Detects and blocks malicious activity on your network.

**Why you need it**:
- Real-time threat detection
- Community-driven protection
- Automatic blocking
- Detailed logging

**How it works**:
- Monitors system logs
- Detects suspicious patterns
- Blocks malicious IPs
- Integrates with firewall

**Use cases**:
- Network security
- Threat detection
- Automatic protection
- Security monitoring

### Fail2ban (Intrusion Prevention)
**What it does**: Monitors logs and automatically bans IPs that show malicious behavior.

**Why you need it**:
- Protects against brute force attacks
- Automatic IP banning
- Configurable rules
- Integration with firewall

**How it works**:
- Monitors log files
- Detects attack patterns
- Bans malicious IPs
- Integrates with firewall

**Use cases**:
- SSH protection
- Web server protection
- Mail server protection
- Custom rule creation

### Vault (Secrets Management)
**What it does**: Securely stores and manages sensitive information like passwords and API keys.

**Why you need it**:
- Secure secret storage
- Access control
- Audit logging
- Integration with applications

**How it works**:
- Encrypts secrets at rest
- Provides API for access
- Manages access policies
- Logs all access

**Use cases**:
- Password management
- API key storage
- Certificate management
- Application secrets

### WireGuard (VPN)
**What it does**: Provides secure remote access to your home network.

**Why you need it**:
- Secure remote access
- High performance
- Easy configuration
- Cross-platform support

**How it works**:
- Creates encrypted tunnel
- Routes traffic through tunnel
- Provides secure access
- Minimal overhead

**Use cases**:
- Remote network access
- Secure file access
- Mobile device protection
- Business remote access

---

## Storage & File Services

### Nextcloud (File Storage)
**What it does**: Self-hosted cloud storage and file sharing platform.

**Why you need it**:
- File storage and sharing
- Mobile app support
- Integration with other services
- Privacy control

**How it works**:
- Provides web interface
- Syncs files across devices
- Manages user accounts
- Integrates with storage

**Use cases**:
- File storage and sharing
- Mobile file access
- Family file sharing
- Business file management

### Samba (File Sharing)
**What it does**: Provides Windows-compatible file sharing on your network.

**Why you need it**:
- Windows file sharing
- Network drives
- User authentication
- Cross-platform support

**How it works**:
- Implements SMB protocol
- Provides network shares
- Manages user access
- Integrates with Windows

**Use cases**:
- Network file sharing
- Windows integration
- Backup storage
- Media storage

### Syncthing (File Synchronization)
**What it does**: Synchronizes files between devices automatically.

**Why you need it**:
- Automatic file sync
- No cloud dependency
- Cross-platform support
- Real-time sync

**How it works**:
- Detects file changes
- Syncs across devices
- Manages conflicts
- Provides web interface

**Use cases**:
- File synchronization
- Backup automation
- Cross-device sync
- No cloud dependency

### MinIO (Object Storage)
**What it does**: S3-compatible object storage for applications and backups.

**Why you need it**:
- S3-compatible storage
- Scalable storage
- Application integration
- Backup storage

**How it works**:
- Provides S3 API
- Manages objects
- Handles replication
- Web interface

**Use cases**:
- Application storage
- Backup storage
- Media storage
- Development storage

---

## Development & Business Services

### GitLab (Code Repository)
**What it does**: Self-hosted Git repository with CI/CD capabilities.

**Why you need it**:
- Code version control
- CI/CD pipelines
- Issue tracking
- Team collaboration

**How it works**:
- Manages Git repositories
- Provides web interface
- Runs CI/CD pipelines
- Manages projects

**Use cases**:
- Code development
- Team collaboration
- CI/CD automation
- Project management

### Harbor (Container Registry)
**What it does**: Self-hosted container image registry.

**Why you need it**:
- Container image storage
- Security scanning
- Access control
- Integration with CI/CD

**How it works**:
- Stores container images
- Provides web interface
- Manages access
- Integrates with Docker

**Use cases**:
- Container development
- CI/CD integration
- Image security
- Team collaboration

### Paperless-ngx (Document Management)
**What it does**: Digital document filing and management system.

**Why you need it**:
- Document organization
- OCR processing
- Search capabilities
- Tag management

**How it works**:
- Scans documents
- Extracts text with OCR
- Organizes with tags
- Provides search

**Use cases**:
- Document management
- Receipt organization
- Business document storage
- Personal filing system

### BookStack (Documentation)
**What it does**: Self-hosted documentation and knowledge management platform.

**Why you need it**:
- Documentation management
- Knowledge sharing
- Team collaboration
- Book organization

**How it works**:
- Organizes content in books
- Provides rich text editor
- Manages permissions
- Search functionality

**Use cases**:
- Team documentation
- Knowledge management
- Project documentation
- Personal notes

### Filebrowser (File Manager)
**What it does**: Web-based file manager for your server.

**Why you need it**:
- Web file management
- File upload/download
- User management
- Integration with storage

**How it works**:
- Provides web interface
- Manages files
- Handles uploads
- User authentication

**Use cases**:
- Web file management
- File sharing
- Storage management
- User access control

---

## Home Automation Services

### Home Assistant (Smart Home Hub)
**What it does**: Central hub for controlling all your smart home devices.

**Why you need it**:
- Device integration
- Automation rules
- Mobile app support
- Privacy control

**How it works**:
- Connects to smart devices
- Provides automation engine
- Offers mobile apps
- Manages integrations

**Use cases**:
- Smart home control
- Automation rules
- Device integration
- Mobile control

### Mosquitto (MQTT Broker)
**What it does**: Message broker for IoT devices and home automation.

**Why you need it**:
- IoT communication
- Device integration
- Lightweight protocol
- Reliable messaging

**How it works**:
- Receives messages from devices
- Routes to subscribers
- Manages connections
- Provides security

**Use cases**:
- IoT device communication
- Home automation
- Sensor data collection
- Device control

### Zigbee2MQTT (Zigbee Bridge)
**What it does**: Connects Zigbee devices to your home automation system.

**Why you need it**:
- Zigbee device support
- Integration with Home Assistant
- Local control
- Device management

**How it works**:
- Connects Zigbee devices
- Converts to MQTT
- Integrates with Home Assistant
- Manages devices

**Use cases**:
- Zigbee device control
- Home automation
- Sensor integration
- Device management

### Node-RED (Automation Platform)
**What it does**: Visual programming tool for home automation.

**Why you need it**:
- Visual automation
- Easy programming
- Device integration
- Complex workflows

**How it works**:
- Provides visual editor
- Connects devices
- Creates workflows
- Manages automation

**Use cases**:
- Home automation
- Complex workflows
- Device integration
- Visual programming

### n8n (Workflow Automation)
**What it does**: Workflow automation platform for connecting different services.

**Why you need it**:
- Service integration
- Workflow automation
- Visual programming
- API connections

**How it works**:
- Connects to APIs
- Creates workflows
- Provides visual editor
- Manages automation

**Use cases**:
- Service integration
- Workflow automation
- API connections
- Business automation

---

## Monitoring & Management Services

### Prometheus (Metrics Collection)
**What it does**: Collects and stores time-series metrics from your services.

**Why you need it**:
- Metrics collection
- Data storage
- Query language
- Alerting integration

**How it works**:
- Scrapes metrics from services
- Stores time-series data
- Provides query language
- Integrates with alerting

**Use cases**:
- Service monitoring
- Performance tracking
- Capacity planning
- Alerting

### Grafana (Data Visualization)
**What it does**: Creates beautiful dashboards and graphs from your metrics data.

**Why you need it**:
- Data visualization
- Dashboard creation
- Alert management
- Multiple data sources

**How it works**:
- Connects to data sources
- Creates dashboards
- Manages alerts
- Provides visualization

**Use cases**:
- System monitoring
- Performance visualization
- Alert management
- Business metrics

### Loki (Log Aggregation)
**What it does**: Collects and stores logs from all your services.

**Why you need it**:
- Log collection
- Centralized storage
- Fast queries
- Integration with Grafana

**How it works**:
- Collects logs
- Stores efficiently
- Provides queries
- Integrates with Grafana

**Use cases**:
- Log management
- Troubleshooting
- Security monitoring
- Performance analysis

### Promtail (Log Collection)
**What it does**: Collects logs and sends them to Loki.

**Why you need it**:
- Log collection
- File monitoring
- Service discovery
- Loki integration

**How it works**:
- Monitors log files
- Discovers services
- Sends to Loki
- Handles parsing

**Use cases**:
- Log collection
- Service monitoring
- File monitoring
- Loki integration

### Alertmanager (Alert Management)
**What it does**: Manages and routes alerts from your monitoring system.

**Why you need it**:
- Alert routing
- Deduplication
- Grouping
- Notification management

**How it works**:
- Receives alerts
- Groups and deduplicates
- Routes notifications
- Manages silence

**Use cases**:
- Alert management
- Notification routing
- Alert grouping
- Silence management

### Telegraf (Metrics Collection)
**What it does**: Collects metrics from various sources and sends them to monitoring systems.

**Why you need it**:
- Metrics collection
- Multiple inputs
- Data processing
- Multiple outputs

**How it works**:
- Collects from inputs
- Processes data
- Sends to outputs
- Handles buffering

**Use cases**:
- System monitoring
- Application metrics
- Custom metrics
- Data collection

### InfluxDB (Time Series Database)
**What it does**: Stores time-series data for monitoring and analytics.

**Why you need it**:
- Time-series storage
- Fast queries
- Data retention
- Integration with monitoring

**How it works**:
- Stores time-series data
- Provides queries
- Manages retention
- Handles writes

**Use cases**:
- Monitoring data
- Performance metrics
- IoT data
- Analytics

### Blackbox Exporter (Uptime Monitoring)
**What it does**: Monitors the availability of HTTP, HTTPS, DNS, TCP, and ICMP endpoints.

**Why you need it**:
- Uptime monitoring
- Service availability
- Response time tracking
- Multiple protocols

**How it works**:
- Probes endpoints
- Measures response times
- Reports availability
- Integrates with Prometheus

**Use cases**:
- Service monitoring
- Uptime tracking
- Performance monitoring
- Availability alerts

---

## Utility Services

### Homepage (Dashboard)
**What it does**: Beautiful, simple dashboard for all your services.

**Why you need it**:
- Service overview
- Quick access
- Customizable
- Mobile friendly

**How it works**:
- Displays service cards
- Provides quick links
- Customizable layout
- Responsive design

**Use cases**:
- Service management
- Quick access
- Family dashboard
- Business overview

### Fing (Network Discovery)
**What it does**: Discovers and monitors devices on your network.

**Why you need it**:
- Network discovery
- Device monitoring
- Network mapping
- Security monitoring

**How it works**:
- Scans network
- Discovers devices
- Monitors activity
- Provides alerts

**Use cases**:
- Network management
- Device monitoring
- Security monitoring
- Network mapping

### Backup Services
**What it does**: Automated backup and disaster recovery for your data.

**Why you need it**:
- Data protection
- Disaster recovery
- Automated backups
- Multiple storage options

**How it works**:
- Schedules backups
- Compresses data
- Encrypts backups
- Manages retention

**Use cases**:
- Data protection
- Disaster recovery
- Compliance
- Business continuity

### Kopia (Backup Tool)
**What it does**: Fast and secure backup tool with deduplication.

**Why you need it**:
- Fast backups
- Deduplication
- Encryption
- Multiple storage backends

**How it works**:
- Creates snapshots
- Deduplicates data
- Encrypts backups
- Supports multiple backends

**Use cases**:
- System backups
- File backups
- Cloud backups
- Disaster recovery

This comprehensive service catalog provides detailed information about each service in your homelab, helping you understand what each one does, why you need it, and how to configure it for your specific use case. 