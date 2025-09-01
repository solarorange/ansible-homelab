# User Guides: Getting Started with Your Homelab

## Table of Contents

1. [Beginner's Guide](#beginners-guide)
2. [Intermediate User Guide](#intermediate-user-guide)
3. [Advanced User Guide](#advanced-user-guide)
4. [Family User Guide](#family-user-guide)
5. [Business User Guide](#business-user-guide)

---

## Beginner's Guide

### Who This Guide Is For
- You're new to home servers and networking
- You want to set up basic services without getting overwhelmed
- You prefer step-by-step instructions with explanations
- You want to start small and grow over time

### What You'll Learn
- Basic concepts of home servers
- How to set up your first service
- How to access and use your services
- Basic troubleshooting

### Prerequisites
- A computer (can be old, but should be from the last 10 years)
- Basic internet connection
- Ability to follow step-by-step instructions
- 2-4 hours of setup time

### Step 1: Understanding the Basics

#### What is a Home Server?
Think of a home server like a smart computer that runs 24/7 and provides services to your home network. It's like having a mini data center in your house.

#### Why Use a Home Server?
- **Privacy**: Your data stays in your home
- **Control**: You decide what services to run
- **Cost**: One-time investment instead of monthly fees
- **Learning**: Great way to learn about technology

#### What Services Can You Run?
- **Media Server**: Watch your movies and TV shows
- **File Storage**: Store and share files
- **Photo Backup**: Automatic backup of your photos
- **Ad Blocking**: Block ads across your entire network

### Step 2: Planning Your Setup

#### Choose Your Hardware
**Option A: Repurpose an Old Computer**
- Any computer from the last 10 years
- At least 4GB RAM
- At least 500GB storage
- Network connection

**Option B: Buy a Small Server**
- Mini PC (like Intel NUC)
- 8GB RAM minimum
- 1TB storage minimum
- Cost: $200-500

#### Choose Your Operating System
We recommend **Ubuntu Server** because:
- Free and open source
- Well documented
- Stable and secure
- Easy to manage

### Step 3: Basic Setup

#### 1. Install Ubuntu Server
1. Download Ubuntu Server from ubuntu.com
2. Create a bootable USB drive
3. Install on your computer
4. Note down your computer's IP address

#### 2. Install Docker
Docker is like a container system that makes it easy to run different services.

```bash
# Connect to your server via SSH
ssh username@your-server-ip

# Update the system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to the docker group
sudo usermod -aG docker $USER
```

#### 3. Install Your First Service: Homepage
Homepage is a dashboard that shows all your services.

```bash
# Create a directory for your services
mkdir -p ~/docker/homepage
cd ~/docker/homepage

# Create docker-compose.yml file
nano docker-compose.yml
```

Add this content:
```yaml
version: '3.8'
services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    container_name: homepage
    ports:
      - "3000:3000"
    volumes:
      - ./data:/app/config
    restart: unless-stopped
```

Start the service:
```bash
docker-compose up -d
```

#### 4. Access Your Dashboard
Open your web browser and go to: `http://your-server-ip:3000`

You should see a clean dashboard where you can add your services.

### Step 4: Adding Your First Media Service

#### Install Jellyfin (Media Server)
Jellyfin is like your own Netflix.

```bash
# Create directory for Jellyfin
mkdir -p ~/docker/jellyfin
cd ~/docker/jellyfin

# Create docker-compose.yml
nano docker-compose.yml
```

Add this content:
```yaml
version: '3.8'
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096"
    volumes:
      - ./config:/config
      - /path/to/your/movies:/movies
      - /path/to/your/tv:/tv
    restart: unless-stopped
```

Start Jellyfin:
```bash
docker-compose up -d
```

Access Jellyfin at: `http://your-server-ip:8096`

### Step 5: Basic Management

#### Viewing Your Services
- Go to your Homepage dashboard
- Add Jellyfin as a service
- Click on the service to access it

#### Stopping and Starting Services
```bash
# Stop a service
docker-compose down

# Start a service
docker-compose up -d

# View running services
docker ps
```

#### Updating Services
```bash
# Update a service
docker-compose pull
docker-compose up -d
```

### Step 6: Basic Troubleshooting

#### Service Won't Start
1. Check if Docker is running: `sudo systemctl status docker`
2. Check logs: `docker-compose logs`
3. Check disk space: `df -h`

#### Can't Access Service
1. Check if service is running: `docker ps`
2. Check port: `netstat -tlnp | grep 8096`
3. Check firewall: `sudo ufw status`

#### Common Commands
```bash
# View all containers
docker ps -a

# View logs
docker logs container-name

# Restart a container
docker restart container-name

# Remove a container
docker rm container-name
```

### Next Steps for Beginners
1. Add more media services (Sonarr, Radarr)
2. Set up file storage (Nextcloud)
3. Configure backups
4. Learn about networking

---

## Intermediate User Guide

### Who This Guide Is For
- You have basic Linux knowledge
- You want to set up multiple services
- You understand networking concepts
- You want to customize your setup

### What You'll Learn
- Service orchestration with Docker Compose
- Network configuration and security
- Monitoring and logging
- Automation and scripting

### Prerequisites
- Completed beginner guide
- Basic Linux command line knowledge
- Understanding of networking concepts
- 4-8 hours of setup time

### Step 1: Advanced Setup

#### Install Ansible
Ansible automates the setup and management of your services.

```bash
# Install Ansible
sudo apt install ansible -y

# Install Python dependencies
sudo apt install python3-pip -y
pip3 install docker-compose
```

#### Clone This Repository
```bash
# Clone the homelab repository
git clone https://github.com/your-repo/ansible_homelab.git
cd ansible_homelab

# Install requirements
pip3 install -r requirements.txt
```

### Step 2: Configuration Management

#### Create Your Configuration
```bash
# Copy example configuration
cp group_vars/all/common.yml.example group_vars/all/common.yml

# Edit your configuration
nano group_vars/all/common.yml
```

Key configuration options:
```yaml
# Your domain name
domain: "yourdomain.com"

# Server IP addresses
server_ips:
  - "192.168.1.100"
  - "192.168.1.101"

# Docker configuration
docker_dir: "/opt/docker"
docker_data_root: "/opt/docker/data"
```

#### Environment Variables
Create a `.env` file for sensitive information:
```bash
# Create environment file
nano .env
```

Add your configuration:
```bash
HOMELAB_DOMAIN=yourdomain.com
CLOUDFLARE_EMAIL=your-email@domain.com
CLOUDFLARE_API_TOKEN=your-api-token
```

### Step 3: Service Orchestration

#### Understanding Docker Compose
Docker Compose manages multiple services together.

Example `docker-compose.yml`:
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
    restart: unless-stopped

  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.jellyfin.rule=Host(`jellyfin.yourdomain.com`)"
    volumes:
      - ./jellyfin:/config
      - /media/movies:/movies
    restart: unless-stopped
```

#### Reverse Proxy Setup
Traefik acts as a traffic director for your services.

```yaml
# traefik.yml
api:
  dashboard: true

entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
```

### Step 4: Network and Security

#### Firewall Configuration
```bash
# Install UFW
sudo apt install ufw -y

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

#### SSL Certificates
Set up automatic SSL certificates with Let's Encrypt:

```yaml
# Add to traefik.yml
certificatesResolvers:
  letsencrypt:
    acme:
      email: your-email@domain.com
      storage: acme.json
      httpChallenge:
        entryPoint: web
```

#### VPN Setup
Install WireGuard for secure remote access:

```bash
# Install WireGuard
sudo apt install wireguard -y

# Generate keys
wg genkey | sudo tee /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
```

### Step 5: Monitoring and Logging

#### Install Monitoring Stack
```bash
# Create monitoring directory
mkdir -p ~/docker/monitoring
cd ~/docker/monitoring

# Create docker-compose.yml for monitoring
nano docker-compose.yml
```

Add monitoring services:
```yaml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3001:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    restart: unless-stopped

volumes:
  grafana-data:
```

#### Log Management
Set up centralized logging:

```yaml
services:
  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    restart: unless-stopped

  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    volumes:
      - /var/log:/var/log
      - ./promtail.yml:/etc/promtail/config.yml
    restart: unless-stopped
```

### Step 6: Automation

#### Backup Automation
Create automated backup scripts:

```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup"

# Backup Docker volumes
docker run --rm -v /var/lib/docker/volumes:/volumes -v $BACKUP_DIR:/backup alpine tar czf /backup/docker-volumes-$DATE.tar.gz /volumes

# Backup configuration files
tar czf $BACKUP_DIR/config-$DATE.tar.gz /opt/docker/config

# Clean old backups (keep 7 days)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

#### Service Updates
Create update script:

```bash
#!/bin/bash
# update-services.sh
cd /opt/docker

# Update all services
for dir in */; do
    if [ -f "$dir/docker-compose.yml" ]; then
        echo "Updating $dir"
        cd "$dir"
        docker-compose pull
        docker-compose up -d
        cd ..
    fi
done

# Clean up old images
docker image prune -f
```

### Step 7: Advanced Configuration

#### Performance Tuning
Optimize Docker performance:

```json
// /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "default-ulimits": {
    "nofile": {
      "Hard": 64000,
      "Name": "nofile",
      "Soft": 64000
    }
  }
}
```

#### Resource Limits
Set resource limits for containers:

```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.5'
```

### Next Steps for Intermediate Users
1. Set up CI/CD pipelines
2. Implement advanced monitoring
3. Configure high availability
4. Set up development environments

---

## Advanced User Guide

### Who This Guide Is For
- You have extensive Linux and networking experience
- You want to build a production-grade system
- You understand container orchestration
- You want to implement advanced features

### What You'll Learn
- Production deployment strategies
- High availability configuration
- Advanced security hardening
- Performance optimization
- CI/CD integration

### Prerequisites
- Completed intermediate guide
- Advanced Linux knowledge
- Understanding of container orchestration
- Experience with monitoring and logging
- 8-16 hours of setup time

### Step 1: Production Architecture

#### Multi-Server Setup
Design a distributed architecture:

```yaml
# inventory.yml
all:
  children:
    load_balancers:
      hosts:
        lb01:
          ansible_host: 192.168.1.10
        lb02:
          ansible_host: 192.168.1.11
    
    application_servers:
      hosts:
        app01:
          ansible_host: 192.168.1.20
        app02:
          ansible_host: 192.168.1.21
    
    database_servers:
      hosts:
        db01:
          ansible_host: 192.168.1.30
        db02:
          ansible_host: 192.168.1.31
    
    storage_servers:
      hosts:
        storage01:
          ansible_host: 192.168.1.40
        storage02:
          ansible_host: 192.168.1.41
```

#### High Availability Configuration
Set up redundant services:

```yaml
# haproxy.cfg
global
    daemon
    maxconn 4096

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http_front
    bind *:80
    bind *:443 ssl crt /etc/ssl/certs/combined.pem
    redirect scheme https if !{ ssl_fc }
    
    acl host_jellyfin hdr(host) -i jellyfin.yourdomain.com
    use_backend jellyfin_backend if host_jellyfin

backend jellyfin_backend
    balance roundrobin
    option httpchk GET /health
    server app01 192.168.1.20:8096 check
    server app02 192.168.1.21:8096 check
```

### Step 2: Advanced Security

#### Network Segmentation
Implement VLANs and network isolation:

```bash
# /etc/network/interfaces
auto vlan100
iface vlan100 inet static
    address 192.168.100.1
    netmask 255.255.255.0
    vlan_raw_device eth0

auto vlan200
iface vlan200 inet static
    address 192.168.200.1
    netmask 255.255.255.0
    vlan_raw_device eth0
```

#### Container Security
Implement security policies:

```yaml
# security-policy.yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-jellyfin
spec:
  podSelector:
    matchLabels:
      app: jellyfin
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
    ports:
    - protocol: TCP
      port: 8096
```

#### Secrets Management
Use HashiCorp Vault for secrets:

```yaml
# vault-config.yml
version: '3.8'
services:
  vault:
    image: vault:latest
    container_name: vault
    ports:
      - "8200:8200"
    environment:
      - VAULT_DEV_ROOT_TOKEN_ID=dev-token
      - VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200
    cap_add:
      - IPC_LOCK
    restart: unless-stopped
```

### Step 3: Performance Optimization

#### Database Optimization
Optimize PostgreSQL for high performance:

```sql
-- postgresql.conf optimizations
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 4MB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
```

#### Storage Optimization
Implement ZFS for advanced storage features:

```bash
# Create ZFS pool
zpool create tank mirror /dev/sdb /dev/sdc

# Create datasets
zfs create tank/docker
zfs create tank/backups
zfs create tank/media

# Set compression
zfs set compression=lz4 tank/docker
zfs set compression=gzip tank/backups

# Set snapshots
zfs set snapdir=visible tank
```

#### Network Optimization
Optimize network performance:

```bash
# /etc/sysctl.conf optimizations
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
```

### Step 4: Advanced Monitoring

#### Custom Metrics
Create custom Prometheus metrics:

```python
# custom_metrics.py
from prometheus_client import Counter, Histogram, Gauge
import time

# Custom metrics
requests_total = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])
request_duration = Histogram('http_request_duration_seconds', 'HTTP request duration')
active_connections = Gauge('active_connections', 'Number of active connections')

# Example usage
@request_duration.time()
def handle_request(method, endpoint):
    requests_total.labels(method=method, endpoint=endpoint).inc()
    active_connections.inc()
    # Process request
    active_connections.dec()
```

#### Advanced Alerting
Create sophisticated alerting rules:

```yaml
# alerting-rules.yml
groups:
- name: homelab_alerts
  rules:
  - alert: HighCPUUsage
    expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage on {{ $labels.instance }}"
      description: "CPU usage is above 80% for 5 minutes"

  - alert: ServiceDown
    expr: up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Service {{ $labels.job }} is down"
      description: "Service {{ $labels.job }} has been down for more than 1 minute"
```

### Step 5: CI/CD Integration

#### GitLab CI Pipeline
Set up automated deployment:

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

test:
  stage: test
  script:
    - ansible-playbook --check --diff playbooks/test.yml

build:
  stage: build
  script:
    - docker build -t myapp:$CI_COMMIT_SHA .
    - docker push myapp:$CI_COMMIT_SHA

deploy:
  stage: deploy
  script:
    - ansible-playbook playbooks/deploy.yml
  only:
    - main
```

#### Automated Testing
Implement comprehensive testing:

```python
# test_services.py
import requests
import pytest
import time

class TestServices:
    def test_jellyfin_health(self):
        response = requests.get('http://jellyfin:8096/health')
        assert response.status_code == 200
    
    def test_database_connection(self):
        # Test database connectivity
        pass
    
    def test_backup_functionality(self):
        # Test backup processes
        pass
```

### Step 6: Disaster Recovery

#### Backup Strategy
Implement comprehensive backup strategy:

```bash
#!/bin/bash
# disaster-recovery-backup.sh

# Configuration
BACKUP_ROOT="/backup"
RETENTION_DAYS=30
DATE=$(date +%Y%m%d_%H%M%S)

# Database backups
pg_dump -h localhost -U postgres jellyfin > $BACKUP_ROOT/db/jellyfin_$DATE.sql

# Configuration backups
tar czf $BACKUP_ROOT/config/config_$DATE.tar.gz /opt/docker/config

# Volume backups
docker run --rm -v /var/lib/docker/volumes:/volumes -v $BACKUP_ROOT/volumes:/backup \
    alpine tar czf /backup/volumes_$DATE.tar.gz /volumes

# Offsite backup
rsync -avz $BACKUP_ROOT/ backup-server:/backup/

# Cleanup old backups
find $BACKUP_ROOT -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_ROOT -name "*.sql" -mtime +$RETENTION_DAYS -delete
```

#### Recovery Procedures
Create recovery documentation:

```markdown
# Disaster Recovery Procedures

## Database Recovery
1. Stop affected services
2. Restore from backup: `psql -h localhost -U postgres jellyfin < backup.sql`
3. Start services

## Full System Recovery
1. Provision new server
2. Restore configuration files
3. Restore Docker volumes
4. Verify all services
5. Update DNS records
```

### Next Steps for Advanced Users
1. Implement Kubernetes orchestration
2. Set up multi-region deployment
3. Implement advanced security features
4. Create custom automation tools

---

## Family User Guide

### Who This Guide Is For
- Families wanting to share media and files
- Parents wanting to control internet access
- Households wanting to save money on subscriptions
- Non-technical users who want simple setup

### What You'll Learn
- How to set up shared family services
- Parental controls and monitoring
- Cost-saving strategies
- Simple management interfaces

### Family-Friendly Services

#### Shared Media Library
Set up Jellyfin for family movie nights:

```yaml
# family-media.yml
version: '3.8'
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096"
    volumes:
      - ./config:/config
      - /family/movies:/movies
      - /family/tv:/tv
      - /family/music:/music
    environment:
      - JELLYFIN_PublishedServerUrl=jellyfin.yourdomain.com
    restart: unless-stopped
```

#### Family Photo Sharing
Set up Immich for family photos:

```yaml
services:
  immich:
    image: ghcr.io/immich-app/immich-server:latest
    container_name: immich
    ports:
      - "3001:3001"
    volumes:
      - ./data:/data
      - /family/photos:/photos
    environment:
      - DATABASE_URL=postgresql://immich:password@db:5432/immich
    restart: unless-stopped
```

#### Family File Sharing
Set up Nextcloud for family file storage:

```yaml
services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    ports:
      - "8080:80"
    volumes:
      - ./data:/var/www/html
      - /family/documents:/var/www/html/data
    environment:
      - MYSQL_ROOT_PASSWORD=password
    restart: unless-stopped
```

### Parental Controls

#### Internet Filtering
Set up Pi-hole with family-friendly lists:

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
      - WEBPASSWORD=family-password
    volumes:
      - ./etc-pihole:/etc/pihole
      - ./etc-dnsmasq.d:/etc/dnsmasq.d
    restart: unless-stopped
```

#### Time Management
Set up automated time limits:

```bash
#!/bin/bash
# family-time-control.sh

# Block devices during bedtime
iptables -A FORWARD -m time --timestart 22:00 --timestop 07:00 -j DROP

# Allow educational sites during homework time
iptables -A FORWARD -m time --timestart 15:00 --timestop 17:00 -d educational-site.com -j ACCEPT
```

### Cost Savings Calculator

#### Monthly Savings
- **Netflix**: $15.99/month
- **Spotify Family**: $14.99/month
- **Google One (2TB)**: $9.99/month
- **iCloud (2TB)**: $9.99/month
- **VPN Service**: $12.99/month
- **Password Manager**: $4.99/month

**Total Monthly Savings**: $69.94
**Annual Savings**: $839.28

#### Setup Costs
- **Hardware**: $300-500
- **Storage**: $200-400
- **Setup Time**: 4-6 hours

**Break-even Time**: 8-12 months

### Family Management Interface

#### Simple Dashboard
Create a family-friendly homepage:

```yaml
# family-dashboard.yml
version: '3.8'
services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    container_name: homepage
    ports:
      - "3000:3000"
    volumes:
      - ./config:/app/config
    environment:
      - TITLE="Family Dashboard"
    restart: unless-stopped
```

#### Family Calendar
Set up shared calendar:

```yaml
services:
  calibre-web:
    image: linuxserver/calibre-web:latest
    container_name: calibre-web
    ports:
      - "8083:8083"
    volumes:
      - ./config:/config
      - /family/books:/books
    environment:
      - PUID=1000
      - PGID=1000
    restart: unless-stopped
```

### Family Setup Checklist

#### Phase 1: Basic Setup (Week 1)
- [ ] Install server hardware
- [ ] Set up basic network
- [ ] Install media server
- [ ] Add family movies and TV shows

#### Phase 2: File Sharing (Week 2)
- [ ] Set up file storage
- [ ] Configure family accounts
- [ ] Set up photo sharing
- [ ] Configure backups

#### Phase 3: Parental Controls (Week 3)
- [ ] Install ad blocker
- [ ] Configure time limits
- [ ] Set up content filtering
- [ ] Test all restrictions

#### Phase 4: Optimization (Week 4)
- [ ] Fine-tune performance
- [ ] Set up monitoring
- [ ] Create family documentation
- [ ] Train family members

### Family Maintenance

#### Weekly Tasks
- [ ] Check system health
- [ ] Update media library
- [ ] Review access logs
- [ ] Backup family data

#### Monthly Tasks
- [ ] Update all services
- [ ] Review parental controls
- [ ] Check storage usage
- [ ] Update family passwords

#### Quarterly Tasks
- [ ] Review cost savings
- [ ] Update family policies
- [ ] Plan new features
- [ ] Family training session

---

## Business User Guide

### Who This Guide Is For
- Small business owners
- Remote teams
- Development teams
- Organizations needing secure infrastructure

### What You'll Learn
- Business-grade security
- Team collaboration tools
- Development environment setup
- Compliance and backup strategies

### Business Services Setup

#### Team Collaboration
Set up GitLab for development:

```yaml
# business-collaboration.yml
version: '3.8'
services:
  gitlab:
    image: gitlab/gitlab-ce:latest
    container_name: gitlab
    ports:
      - "80:80"
      - "443:443"
      - "22:22"
    volumes:
      - ./gitlab:/etc/gitlab
      - ./gitlab/logs:/var/log/gitlab
      - ./gitlab/data:/var/opt/gitlab
    environment:
      - GITLAB_OMNIBUS_CONFIG=external_url 'http://gitlab.yourdomain.com'
    restart: unless-stopped
```

#### Document Management
Set up Paperless-ngx for document storage:

```yaml
services:
  paperless-ngx:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    container_name: paperless-ngx
    ports:
      - "8010:8000"
    volumes:
      - ./data:/usr/src/paperless/data
      - ./media:/usr/src/paperless/media
      - ./export:/usr/src/paperless/export
    environment:
      - PAPERLESS_REDIS=redis://redis:6379
      - PAPERLESS_DBHOST=db
    restart: unless-stopped
```

#### Team Communication
Set up Mattermost for team chat:

```yaml
services:
  mattermost:
    image: mattermost/mattermost-team-edition:latest
    container_name: mattermost
    ports:
      - "8065:8065"
    volumes:
      - ./mattermost:/mattermost
    environment:
      - MM_SQLSETTINGS_DRIVERNAME=postgres
      - MM_SQLSETTINGS_DATASOURCE=postgres://mmuser:password@db:5432/mattermost?sslmode=disable
    restart: unless-stopped
```

### Security for Business

#### VPN for Remote Access
Set up WireGuard for secure remote access:

```bash
# Generate server keys
wg genkey | sudo tee /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key

# Create server configuration
sudo nano /etc/wireguard/wg0.conf
```

Server configuration:
```ini
[Interface]
PrivateKey = <server-private-key>
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```

#### Advanced Firewall
Configure business-grade firewall:

```bash
# Install and configure UFW
sudo apt install ufw -y

# Configure firewall rules
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 51820/udp  # WireGuard
sudo ufw enable
```

#### Intrusion Detection
Set up CrowdSec for threat detection:

```yaml
services:
  crowdsec:
    image: crowdsecurity/crowdsec:latest
    container_name: crowdsec
    volumes:
      - ./crowdsec:/etc/crowdsec
      - /var/log:/var/log:ro
    environment:
      - COLLECTIONS=crowdsecurity/sshd crowdsecurity/nginx
    restart: unless-stopped
```

### Development Environment

#### CI/CD Pipeline
Set up automated deployment:

```yaml
# .gitlab-ci.yml for business
stages:
  - test
  - security
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2

test:
  stage: test
  script:
    - npm install
    - npm test
  coverage: '/All files[^|]*\|[^|]*\|[^|]*\|[^|]*\s+(\d+)/'

security:
  stage: security
  script:
    - npm audit
    - sonar-scanner

build:
  stage: build
  script:
    - docker build -t myapp:$CI_COMMIT_SHA .
    - docker push myapp:$CI_COMMIT_SHA
  only:
    - main

deploy:
  stage: deploy
  script:
    - ansible-playbook playbooks/deploy.yml
  environment:
    name: production
  only:
    - main
```

#### Code Quality Tools
Set up SonarQube for code analysis:

```yaml
services:
  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9000:9000"
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    environment:
      - SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true
    restart: unless-stopped

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
```

### Compliance and Backup

#### Automated Backups
Set up business-grade backup system:

```bash
#!/bin/bash
# business-backup.sh

# Configuration
BACKUP_ROOT="/backup"
RETENTION_DAYS=90
DATE=$(date +%Y%m%d_%H%M%S)
ENCRYPTION_KEY="your-encryption-key"

# Database backups
pg_dump -h localhost -U postgres --all > $BACKUP_ROOT/db/full_backup_$DATE.sql

# Encrypt backup
gpg --encrypt --recipient $ENCRYPTION_KEY $BACKUP_ROOT/db/full_backup_$DATE.sql

# Configuration backups
tar czf $BACKUP_ROOT/config/config_$DATE.tar.gz /opt/docker/config

# Offsite backup with encryption
rsync -avz --progress $BACKUP_ROOT/ backup-server:/backup/

# Verify backup integrity
sha256sum $BACKUP_ROOT/db/full_backup_$DATE.sql.gpg > $BACKUP_ROOT/db/full_backup_$DATE.sql.gpg.sha256

# Cleanup old backups
find $BACKUP_ROOT -name "*.sql.gpg" -mtime +$RETENTION_DAYS -delete
find $BACKUP_ROOT -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
```

#### Audit Logging
Set up comprehensive audit logging:

```yaml
services:
  auditd:
    image: auditd:latest
    container_name: auditd
    volumes:
      - /var/log:/var/log
      - /etc:/etc:ro
    environment:
      - AUDIT_RULES="-w /etc/passwd -p wa -k identity"
    restart: unless-stopped
```

### Business Monitoring

#### Business Metrics Dashboard
Create business-specific monitoring:

```yaml
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./dashboards:/etc/grafana/provisioning/dashboards
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=secure-password
    restart: unless-stopped
```

#### SLA Monitoring
Set up service level agreement monitoring:

```yaml
# sla-monitoring.yml
groups:
- name: sla_alerts
  rules:
  - alert: ServiceSLAViolation
    expr: (up == 0) or (http_request_duration_seconds > 2)
    for: 5m
    labels:
      severity: critical
      sla: violated
    annotations:
      summary: "SLA violation detected"
      description: "Service is not meeting SLA requirements"
```

### Business Setup Checklist

#### Phase 1: Infrastructure (Week 1)
- [ ] Set up secure network
- [ ] Install VPN access
- [ ] Configure firewall
- [ ] Set up monitoring

#### Phase 2: Collaboration (Week 2)
- [ ] Install GitLab
- [ ] Set up team accounts
- [ ] Configure CI/CD
- [ ] Set up document management

#### Phase 3: Security (Week 3)
- [ ] Implement access controls
- [ ] Set up audit logging
- [ ] Configure backup encryption
- [ ] Test security measures

#### Phase 4: Compliance (Week 4)
- [ ] Set up compliance monitoring
- [ ] Configure automated backups
- [ ] Implement disaster recovery
- [ ] Create compliance documentation

### Business Maintenance

#### Daily Tasks
- [ ] Check system health
- [ ] Review security alerts
- [ ] Monitor backup status
- [ ] Check team access

#### Weekly Tasks
- [ ] Update all services
- [ ] Review audit logs
- [ ] Test backup restoration
- [ ] Update security patches

#### Monthly Tasks
- [ ] Review compliance status
- [ ] Update business policies
- [ ] Conduct security audit
- [ ] Plan infrastructure improvements

This comprehensive user guide system provides different paths for users of all technical levels, from complete beginners to advanced system administrators, ensuring everyone can successfully deploy and manage their homelab infrastructure. 