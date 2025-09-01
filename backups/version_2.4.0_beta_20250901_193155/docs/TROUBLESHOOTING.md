# Troubleshooting Guide: Common Issues and Solutions

## Table of Contents

1. [Quick Diagnostic Commands](#quick-diagnostic-commands)
2. [Service-Specific Issues](#service-specific-issues)
3. [Network Issues](#network-issues)
4. [Performance Issues](#performance-issues)
5. [Security Issues](#security-issues)
6. [Backup and Recovery Issues](#backup-and-recovery-issues)
7. [Docker Issues](#docker-issues)
8. [Database Issues](#database-issues)
9. [Emergency Procedures](#emergency-procedures)

---

## Quick Diagnostic Commands

### System Health Check
```bash
# Overall system status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
df -h
free -h
uptime

# Check critical services
curl -f http://localhost:3000/api/health || echo "Homepage down"
curl -f http://localhost:8096/health || echo "Jellyfin down"
curl -f http://localhost:3001/api/health || echo "Grafana down"

# Check logs for errors
docker logs --tail=50 $(docker ps --format "{{.Names}}") | grep -i error
```

### Network Connectivity
```bash
# Test internet connectivity
ping -c 3 8.8.8.8
nslookup google.com

# Test local network
ping -c 3 192.168.1.1
netstat -tlnp | grep LISTEN

# Test DNS resolution
dig @8.8.8.8 google.com
dig @localhost yourdomain.com
```

### Resource Usage
```bash
# Check resource usage
htop
docker stats --no-stream
iotop
iftop

# Check disk I/O
iostat -x 1 5
```

---

## Service-Specific Issues

### Jellyfin Issues

#### Problem: Jellyfin won't start
**Symptoms**: Container exits immediately or won't start

**Diagnosis**:
```bash
# Check container logs
docker logs jellyfin --tail=100

# Check container status
docker ps -a | grep jellyfin

# Check port conflicts
netstat -tlnp | grep 8096
```

**Solutions**:
```bash
# Solution 1: Port conflict
# Stop conflicting service
docker stop conflicting_service
docker start jellyfin

# Solution 2: Permission issues
# Fix permissions
sudo chown -R 1000:1000 /opt/docker/jellyfin/config
docker start jellyfin

# Solution 3: Configuration error
# Check configuration
docker exec jellyfin cat /config/system.xml
# Fix configuration and restart
docker restart jellyfin
```

#### Problem: Jellyfin can't access media files
**Symptoms**: Media library shows no content or access denied errors

**Diagnosis**:
```bash
# Check file permissions
ls -la /media/movies
ls -la /media/tv

# Check container mounts
docker inspect jellyfin | grep -A 10 "Mounts"

# Test file access from container
docker exec jellyfin ls -la /movies
```

**Solutions**:
```bash
# Solution 1: Fix permissions
sudo chown -R 1000:1000 /media/movies /media/tv
sudo chmod -R 755 /media/movies /media/tv

# Solution 2: Fix mount points
# Update docker-compose.yml
volumes:
  - /media/movies:/movies:ro
  - /media/tv:/tv:ro
docker-compose up -d jellyfin

# Solution 3: Check SELinux/AppArmor
# Disable SELinux temporarily
sudo setenforce 0
# Or configure SELinux policies
```

#### Problem: Jellyfin transcoding issues
**Symptoms**: Videos won't play or poor performance during transcoding

**Diagnosis**:
```bash
# Check transcoding settings
docker exec jellyfin cat /config/system.xml | grep -i transcode

# Check hardware acceleration
docker exec jellyfin nvidia-smi  # For NVIDIA
docker exec jellyfin vainfo      # For Intel/AMD

# Check transcoding logs
docker logs jellyfin | grep -i transcode
```

**Solutions**:
```bash
# Solution 1: Enable hardware acceleration
# Add to docker-compose.yml
devices:
  - /dev/dri:/dev/dri
environment:
  - JELLYFIN_FFMPEG_OPTS="-hwaccel vaapi -vaapi_device /dev/dri/renderD128"

# Solution 2: Adjust transcoding settings
# In Jellyfin web interface:
# Dashboard > Playback > Transcoding
# Enable hardware acceleration
# Set maximum transcoding threads

# Solution 3: Increase container resources
# Add to docker-compose.yml
deploy:
  resources:
    limits:
      memory: 4G
      cpus: '2.0'
```

### Sonarr/Radarr Issues

#### Problem: Sonarr/Radarr can't connect to download clients
**Symptoms**: Downloads fail or show connection errors

**Diagnosis**:
```bash
# Check download client status
docker ps | grep -E "(sabnzbd|qbittorrent)"

# Check network connectivity
docker exec sonarr ping -c 3 sabnzbd
docker exec sonarr ping -c 3 qbittorrent

# Check API connectivity
curl -f http://sabnzbd:8080/api?mode=version
curl -f http://qbittorrent:8080/api/v2/app/version
```

**Solutions**:
```bash
# Solution 1: Fix network connectivity
# Ensure containers are on same network
docker network ls
docker network connect homelab_network sonarr
docker network connect homelab_network sabnzbd

# Solution 2: Update API settings
# In Sonarr/Radarr web interface:
# Settings > Download Clients
# Update hostname, port, and API key

# Solution 3: Restart services
docker restart sonarr sabnzbd
```

#### Problem: Indexers not working
**Symptoms**: No search results or indexer errors

**Diagnosis**:
```bash
# Check indexer status
# In Sonarr/Radarr web interface:
# Settings > Indexers > Test

# Check Prowlarr logs
docker logs prowlarr --tail=50

# Check network connectivity
docker exec sonarr curl -f https://indexer-site.com
```

**Solutions**:
```bash
# Solution 1: Update indexer configuration
# In Prowlarr web interface:
# Indexers > Edit > Test

# Solution 2: Check API limits
# Some indexers have rate limits
# Wait and retry

# Solution 3: Update Prowlarr
docker-compose pull prowlarr
docker-compose up -d prowlarr
```

### Nextcloud Issues

#### Problem: Nextcloud sync errors
**Symptoms**: Files not syncing or sync conflicts

**Diagnosis**:
```bash
# Check Nextcloud logs
docker logs nextcloud --tail=100

# Check file permissions
ls -la /opt/docker/nextcloud/data

# Check database connectivity
docker exec nextcloud occ status
```

**Solutions**:
```bash
# Solution 1: Fix permissions
sudo chown -R www-data:www-data /opt/docker/nextcloud/data
sudo chmod -R 755 /opt/docker/nextcloud/data

# Solution 2: Clear cache
docker exec nextcloud occ files:scan --all
docker exec nextcloud occ files:cleanup

# Solution 3: Check storage space
df -h
# Free up space if needed
```

#### Problem: Nextcloud performance issues
**Symptoms**: Slow file operations or high resource usage

**Diagnosis**:
```bash
# Check resource usage
docker stats nextcloud

# Check database performance
docker exec postgres psql -U nextcloud -c "SELECT * FROM pg_stat_activity;"

# Check file count
docker exec nextcloud find /var/www/html/data -type f | wc -l
```

**Solutions**:
```bash
# Solution 1: Optimize database
docker exec postgres psql -U nextcloud -c "VACUUM ANALYZE;"

# Solution 2: Enable Redis caching
# Add to docker-compose.yml
environment:
  - REDIS_HOST=redis
  - REDIS_HOST_PORT=6379

# Solution 3: Increase resources
deploy:
  resources:
    limits:
      memory: 2G
      cpus: '1.0'
```

### Traefik Issues

#### Problem: SSL certificate errors
**Symptoms**: HTTPS not working or certificate warnings

**Diagnosis**:
```bash
# Check certificate status
openssl x509 -in /opt/docker/traefik/acme.json -text -noout

# Check Let's Encrypt rate limits
curl -s https://letsencrypt.org/rate-limits/

# Check Traefik logs
docker logs traefik | grep -i cert
```

**Solutions**:
```bash
# Solution 1: Force certificate renewal
docker exec traefik traefik cert --renew

# Solution 2: Check domain configuration
# Verify DNS records point to your server
dig yourdomain.com

# Solution 3: Clear certificate cache
rm /opt/docker/traefik/acme.json
docker restart traefik
```

#### Problem: Service routing issues
**Symptoms**: Services not accessible or wrong service responding

**Diagnosis**:
```bash
# Check Traefik configuration
docker exec traefik cat /etc/traefik/traefik.yml

# Check service labels
docker inspect service_name | grep -A 10 "Labels"

# Check routing logs
docker logs traefik | grep -i route
```

**Solutions**:
```bash
# Solution 1: Fix service labels
# Update docker-compose.yml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.service.rule=Host(`service.yourdomain.com`)"

# Solution 2: Check network configuration
docker network ls
docker network connect traefik_network service_name

# Solution 3: Restart Traefik
docker restart traefik
```

---

## Network Issues

### DNS Issues

#### Problem: Pi-hole not blocking ads
**Symptoms**: Ads still showing or DNS queries not being blocked

**Diagnosis**:
```bash
# Check Pi-hole status
docker logs pihole --tail=50

# Check DNS queries
curl -s http://localhost:8081/admin/api.php?summary

# Check blocklists
docker exec pihole pihole -g
```

**Solutions**:
```bash
# Solution 1: Update blocklists
docker exec pihole pihole -g
docker restart pihole

# Solution 2: Check DNS configuration
# Verify devices are using Pi-hole DNS
# Check router DNS settings

# Solution 3: Clear DNS cache
docker exec pihole pihole restartdns
```

#### Problem: Internal DNS resolution issues
**Symptoms**: Can't access services by internal domain names

**Diagnosis**:
```bash
# Check DNS resolution
nslookup service.local
dig @localhost service.local

# Check Pi-hole configuration
docker exec pihole cat /etc/pihole/custom.list
```

**Solutions**:
```bash
# Solution 1: Add custom DNS records
# In Pi-hole web interface:
# Local DNS > DNS Records
# Add: service.local -> 192.168.1.100

# Solution 2: Check network configuration
# Ensure devices are using Pi-hole DNS

# Solution 3: Restart DNS service
docker restart pihole
```

### VPN Issues

#### Problem: WireGuard VPN not working
**Symptoms**: Can't connect to VPN or no internet access

**Diagnosis**:
```bash
# Check WireGuard status
sudo wg show

# Check firewall rules
sudo ufw status

# Check routing
ip route show
```

**Solutions**:
```bash
# Solution 1: Restart WireGuard
sudo systemctl restart wg-quick@wg0

# Solution 2: Check firewall configuration
sudo ufw allow 51820/udp
sudo ufw reload

# Solution 3: Check routing configuration
# Ensure proper NAT rules are in place
```

### Load Balancer Issues

#### Problem: Load balancer not distributing traffic
**Symptoms**: All traffic going to one server or service unavailable

**Diagnosis**:
```bash
# Check load balancer status
docker logs haproxy --tail=50

# Check backend health
curl -f http://localhost:8080/stats

# Check service connectivity
curl -f http://backend1:port/health
curl -f http://backend2:port/health
```

**Solutions**:
```bash
# Solution 1: Check backend configuration
# Update haproxy.cfg
backend app_backend
    server app1 backend1:port check
    server app2 backend2:port check

# Solution 2: Restart load balancer
docker restart haproxy

# Solution 3: Check network connectivity
# Ensure all backends are reachable
```

---

## Performance Issues

### High CPU Usage

#### Problem: System CPU usage consistently high
**Symptoms**: Slow response times, high load average

**Diagnosis**:
```bash
# Check CPU usage by process
top -p 1

# Check Docker container CPU usage
docker stats --no-stream

# Check system load
uptime
```

**Solutions**:
```bash
# Solution 1: Identify high-CPU containers
docker stats --no-stream | sort -k3 -hr

# Solution 2: Limit container resources
# Add to docker-compose.yml
deploy:
  resources:
    limits:
      cpus: '1.0'

# Solution 3: Optimize applications
# Check for infinite loops or inefficient code
# Enable caching where possible
```

### High Memory Usage

#### Problem: System running out of memory
**Symptoms**: OOM errors, slow performance, swap usage

**Diagnosis**:
```bash
# Check memory usage
free -h

# Check swap usage
swapon --show

# Check memory usage by container
docker stats --no-stream
```

**Solutions**:
```bash
# Solution 1: Increase swap space
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Solution 2: Limit container memory
# Add to docker-compose.yml
deploy:
  resources:
    limits:
      memory: 1G

# Solution 3: Optimize applications
# Enable memory caching
# Reduce concurrent connections
```

### High Disk I/O

#### Problem: Slow disk operations
**Symptoms**: Slow file operations, high iowait

**Diagnosis**:
```bash
# Check disk I/O
iostat -x 1 5

# Check disk usage
df -h

# Check I/O by process
iotop
```

**Solutions**:
```bash
# Solution 1: Optimize disk usage
# Move frequently accessed data to SSD
# Use RAID for better performance

# Solution 2: Optimize applications
# Enable disk caching
# Reduce logging verbosity

# Solution 3: Check for disk issues
sudo smartctl -a /dev/sda
```

---

## Security Issues

### Authentication Issues

#### Problem: Can't log into services
**Symptoms**: Login failures, authentication errors

**Diagnosis**:
```bash
# Check Authentik logs
docker logs authentik --tail=50

# Check service logs
docker logs service_name | grep -i auth

# Check network connectivity
curl -f http://authentik:9000/api/v3/core/users/
```

**Solutions**:
```bash
# Solution 1: Reset user password
docker exec authentik ak user reset-password username

# Solution 2: Check service configuration
# Verify OAuth/SSO settings in service config

# Solution 3: Restart authentication service
docker restart authentik
```

### Firewall Issues

#### Problem: Services not accessible
**Symptoms**: Connection refused, timeout errors

**Diagnosis**:
```bash
# Check firewall status
sudo ufw status

# Check port availability
netstat -tlnp | grep port

# Test connectivity
telnet localhost port
```

**Solutions**:
```bash
# Solution 1: Allow required ports
sudo ufw allow port/tcp
sudo ufw reload

# Solution 2: Check service configuration
# Verify service is listening on correct port

# Solution 3: Restart firewall
sudo ufw disable
sudo ufw enable
```

### SSL/TLS Issues

#### Problem: SSL certificate errors
**Symptoms**: Browser warnings, certificate expired

**Diagnosis**:
```bash
# Check certificate expiration
openssl x509 -in cert.pem -noout -dates

# Check certificate chain
openssl x509 -in cert.pem -noout -text

# Test SSL connection
openssl s_client -connect domain:443 -servername domain
```

**Solutions**:
```bash
# Solution 1: Renew certificate
docker exec traefik traefik cert --renew

# Solution 2: Check certificate chain
# Ensure intermediate certificates are included

# Solution 3: Update certificate manually
# Replace certificate files and restart service
```

---

## Backup and Recovery Issues

### Backup Failures

#### Problem: Automated backups failing
**Symptoms**: Backup jobs failing, no backup files created

**Diagnosis**:
```bash
# Check backup logs
tail -f /var/log/backup.log

# Check disk space
df -h /backup

# Check backup script permissions
ls -la /usr/local/bin/backup.sh
```

**Solutions**:
```bash
# Solution 1: Free up disk space
# Remove old backups
find /backup -type f -mtime +30 -delete

# Solution 2: Fix permissions
sudo chmod +x /usr/local/bin/backup.sh

# Solution 3: Check database connectivity
# Ensure database is accessible for backup
```

### Recovery Issues

#### Problem: Can't restore from backup
**Symptoms**: Restoration fails, corrupted backup files

**Diagnosis**:
```bash
# Check backup file integrity
tar -tzf backup.tar.gz >/dev/null

# Check backup file size
ls -lh backup.tar.gz

# Test backup extraction
tar -tzf backup.tar.gz | head -10
```

**Solutions**:
```bash
# Solution 1: Use different backup
# Try restoring from older backup

# Solution 2: Repair backup file
# Use backup repair tools if available

# Solution 3: Manual restoration
# Extract backup manually and restore files
```

---

## Docker Issues

### Container Won't Start

#### Problem: Container exits immediately
**Symptoms**: Container status shows "Exited", won't start

**Diagnosis**:
```bash
# Check container logs
docker logs container_name --tail=100

# Check container status
docker ps -a | grep container_name

# Check resource limits
docker inspect container_name | grep -A 10 "HostConfig"
```

**Solutions**:
```bash
# Solution 1: Fix configuration
# Check and fix docker-compose.yml or run command

# Solution 2: Check dependencies
# Ensure required services are running

# Solution 3: Clear container data
docker rm container_name
docker volume rm volume_name
docker-compose up -d
```

### Image Pull Issues

#### Problem: Can't pull Docker images
**Symptoms**: Pull fails, network timeout

**Diagnosis**:
```bash
# Check internet connectivity
ping -c 3 8.8.8.8

# Check Docker daemon
sudo systemctl status docker

# Check DNS resolution
nslookup registry-1.docker.io
```

**Solutions**:
```bash
# Solution 1: Restart Docker daemon
sudo systemctl restart docker

# Solution 2: Use different registry
# Configure mirror registry

# Solution 3: Check firewall
# Ensure Docker can access internet
```

### Volume Issues

#### Problem: Data not persisting
**Symptoms**: Data lost after container restart

**Diagnosis**:
```bash
# Check volume mounts
docker inspect container_name | grep -A 10 "Mounts"

# Check volume data
docker volume ls
docker volume inspect volume_name

# Check file permissions
ls -la /opt/docker/data/
```

**Solutions**:
```bash
# Solution 1: Fix volume configuration
# Update docker-compose.yml volume mounts

# Solution 2: Fix permissions
sudo chown -R 1000:1000 /opt/docker/data/

# Solution 3: Recreate volume
docker volume rm volume_name
docker-compose up -d
```

---

## Database Issues

### PostgreSQL Issues

#### Problem: Database connection failures
**Symptoms**: Connection refused, authentication errors

**Diagnosis**:
```bash
# Check PostgreSQL status
docker logs postgres --tail=50

# Check database connectivity
docker exec postgres pg_isready

# Check connection limits
docker exec postgres psql -U postgres -c "SHOW max_connections;"
```

**Solutions**:
```bash
# Solution 1: Restart database
docker restart postgres

# Solution 2: Check credentials
# Verify username/password in service configuration

# Solution 3: Increase connection limits
# Update postgresql.conf
max_connections = 200
```

### Database Performance Issues

#### Problem: Slow database queries
**Symptoms**: Slow application performance, high CPU usage

**Diagnosis**:
```bash
# Check active queries
docker exec postgres psql -U postgres -c "
SELECT pid, now() - pg_stat_activity.query_start AS duration, query 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';
"

# Check database size
docker exec postgres psql -U postgres -c "
SELECT pg_size_pretty(pg_database_size('database_name'));
"
```

**Solutions**:
```bash
# Solution 1: Optimize queries
# Add indexes, optimize slow queries

# Solution 2: Increase resources
# Add more memory/CPU to database container

# Solution 3: Database maintenance
docker exec postgres psql -U postgres -c "VACUUM ANALYZE;"
```

---

## Emergency Procedures

### Complete System Failure

#### Problem: System completely unresponsive
**Symptoms**: No network, no services, can't SSH

**Emergency Response**:
```bash
# 1. Physical access required
# Connect directly to server

# 2. Check hardware
# Verify power, network cables, disk health

# 3. Boot into recovery mode
# Use recovery kernel or live USB

# 4. Check filesystem
fsck -f /dev/sda1

# 5. Mount and check logs
mount /dev/sda1 /mnt
cat /mnt/var/log/syslog | tail -100
```

### Data Loss Recovery

#### Problem: Critical data lost
**Symptoms**: Files missing, database corrupted

**Emergency Response**:
```bash
# 1. Stop all services
docker-compose down

# 2. Check backup availability
ls -la /backup/

# 3. Restore from backup
tar -xzf /backup/latest/config.tar.gz -C /opt/docker/
docker exec -i postgres pg_restore -U postgres -d postgres < /backup/latest/database.sql

# 4. Verify restoration
docker-compose up -d
# Check service health
```

### Security Breach Response

#### Problem: Suspected security breach
**Symptoms**: Unusual activity, unauthorized access

**Emergency Response**:
```bash
# 1. Isolate system
# Disconnect from network

# 2. Collect evidence
mkdir -p /var/log/incident-$(date +%Y%m%d-%H%M%S)
cp /var/log/auth.log /var/log/incident-*/
cp /var/log/syslog /var/log/incident-*/

# 3. Block suspicious IPs
# Update firewall rules

# 4. Reset compromised accounts
docker exec authentik ak user reset-password username

# 5. Restore from clean backup
# Use backup from before breach
```

### Performance Emergency

#### Problem: System performance critically degraded
**Symptoms**: Extremely slow response, high resource usage

**Emergency Response**:
```bash
# 1. Identify resource bottleneck
htop
df -h
free -h

# 2. Stop non-critical services
docker stop service1 service2

# 3. Restart critical services
docker restart traefik postgres

# 4. Clear caches
echo 3 > /proc/sys/vm/drop_caches

# 5. Monitor recovery
# Watch system metrics
```

This comprehensive troubleshooting guide provides solutions for the most common issues you'll encounter with your homelab system. Always start with the diagnostic commands to identify the root cause before applying solutions. 