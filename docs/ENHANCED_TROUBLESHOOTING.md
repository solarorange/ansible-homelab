# Enhanced Troubleshooting Guide: Visual Diagnostic & Solutions

## Table of Contents

1. [Quick Diagnostic Flowcharts](#quick-diagnostic-flowcharts)
2. [Service-Specific Troubleshooting](#service-specific-troubleshooting)
3. [Network Issues](#network-issues)
4. [Performance Problems](#performance-problems)
5. [Security Issues](#security-issues)
6. [Data Recovery](#data-recovery)
7. [Emergency Procedures](#emergency-procedures)

---

## Quick Diagnostic Flowcharts

### System Health Check Flow
```
START TROUBLESHOOTING
         │
         ▼
┌─────────────────┐
│  CAN YOU ACCESS │
│  THE SERVER?    │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
   YES       NO
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ SERVICES│ │ NETWORK │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ ARE ALL │ │ CAN YOU │
│ SERVICES│ │ PING THE│
│ RUNNING?│ │ SERVER? │
└─────────┘ └─────────┘
    │         │
┌───┴───┐ ┌───┴───┐
▼       ▼ ▼       ▼
YES     NO YES     NO
│       │ │       │
▼       ▼ ▼       ▼
┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
│SYSTEM│ │START│ │ROUTER│ │CHECK│
│OKAY  │ │SERV │ │ISSUE │ │CABLE│
└─────┘ └─────┘ └─────┘ └─────┘
```

### Service Access Flow
```
CAN'T ACCESS SERVICE
         │
         ▼
┌─────────────────┐
│  WHICH SERVICE? │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│ MEDIA   │ │ MONITOR │
│ SERVICE │ │ SERVICE │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ JELLYFIN│ │ GRAFANA │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CONTAINER│ │ CONTAINER│
│ RUNNING? │ │ RUNNING? │
└─────────┘ └─────────┘
    │         │
┌───┴───┐ ┌───┴───┐
▼       ▼ ▼       ▼
YES     NO YES     NO
│       │ │       │
▼       ▼ ▼       ▼
┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
│CHECK│ │START│ │CHECK│ │START│
│PORT │ │CONT │ │PORT │ │CONT │
└─────┘ └─────┘ └─────┘ └─────┘
```

### Network Connectivity Flow
```
NETWORK ISSUES
         │
         ▼
┌─────────────────┐
│  CAN YOU PING   │
│  THE SERVER?    │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
   YES       NO
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ PORTS   │ │ ROUTER  │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ PORTS   │ │ ROUTER  │
│ OPEN?   │ │ WORKING?│
└─────────┘ └─────────┘
    │         │
┌───┴───┐ ┌───┴───┐
▼       ▼ ▼       ▼
YES     NO YES     NO
│       │ │       │
▼       ▼ ▼       ▼
┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
│CHECK│ │OPEN │ │RESET│ │CHECK│
│FIREW│ │PORTS│ │ROUT │ │CABLE│
└─────┘ └─────┘ └─────┘ └─────┘
```

---

## Service-Specific Troubleshooting

### Jellyfin Issues

#### Problem: Can't Access Jellyfin
```
SYMPTOM: Can't access Jellyfin web interface

DIAGNOSTIC STEPS:
1. Check if container is running
   docker ps | grep jellyfin

2. Check container logs
   docker logs jellyfin

3. Check port binding
   netstat -tulpn | grep 8096

4. Check firewall
   sudo ufw status

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ Container Not Running                                   │
├─────────────────────────────────────────────────────────┤
│ • Start container: docker-compose up -d                 │
│ • Check docker-compose.yml syntax                       │
│ • Verify image exists: docker images | grep jellyfin    │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Port Already in Use                                     │
├─────────────────────────────────────────────────────────┤
│ • Change port in docker-compose.yml                     │
│ • Kill process using port: sudo lsof -ti:8096 | xargs kill│
│ • Check for other Jellyfin instances                    │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Firewall Blocking                                       │
├─────────────────────────────────────────────────────────┤
│ • Allow port: sudo ufw allow 8096                       │
│ • Check router firewall settings                        │
│ • Verify network configuration                          │
└─────────────────────────────────────────────────────────┘
```

#### Problem: Media Not Showing
```
SYMPTOM: Media files not appearing in Jellyfin

DIAGNOSTIC STEPS:
1. Check library scan status
   - Go to Admin → Libraries
   - Check last scan time

2. Check file permissions
   ls -la /path/to/media

3. Check volume mounts
   docker inspect jellyfin

4. Check media file formats
   file /path/to/media/file

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ Permission Issues                                       │
├─────────────────────────────────────────────────────────┤
│ • Fix permissions: sudo chown -R 1000:1000 /media       │
│ • Check SELinux if applicable                           │
│ • Verify user/group mapping in docker-compose.yml      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Volume Mount Issues                                     │
├─────────────────────────────────────────────────────────┤
│ • Verify paths in docker-compose.yml                    │
│ • Check if directories exist                            │
│ • Restart container after path changes                  │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Unsupported Formats                                     │
├─────────────────────────────────────────────────────────┤
│ • Check supported formats in Jellyfin docs              │
│ • Convert files to supported format                     │
│ • Enable transcoding in Jellyfin settings               │
└─────────────────────────────────────────────────────────┘
```

### Traefik Issues

#### Problem: SSL Certificate Errors
```
SYMPTOM: SSL certificate warnings or errors

DIAGNOSTIC STEPS:
1. Check certificate status
   docker logs traefik | grep -i cert

2. Check DNS resolution
   nslookup yourdomain.com

3. Check port 80/443 access
   telnet yourdomain.com 80
   telnet yourdomain.com 443

4. Check Let's Encrypt rate limits
   - Visit https://letsencrypt.org/docs/rate-limits/

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ DNS Not Configured                                      │
├─────────────────────────────────────────────────────────┤
│ • Point domain to server IP                             │
│ • Wait for DNS propagation (up to 48 hours)            │
│ • Use DNS checker tools                                 │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Port 80/443 Blocked                                     │
├─────────────────────────────────────────────────────────┤
│ • Check router port forwarding                          │
│ • Verify ISP doesn't block ports                        │
│ • Check firewall settings                               │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Rate Limit Exceeded                                     │
├─────────────────────────────────────────────────────────┤
│ • Wait for rate limit reset                             │
│ • Use staging environment for testing                   │
│ • Check certificate renewal schedule                    │
└─────────────────────────────────────────────────────────┘
```

### Monitoring Issues

#### Problem: Grafana Not Loading Dashboards
```
SYMPTOM: Grafana dashboards not loading or showing data

DIAGNOSTIC STEPS:
1. Check Grafana container status
   docker ps | grep grafana

2. Check data source connections
   - Go to Configuration → Data Sources
   - Test each data source

3. Check Prometheus connectivity
   curl http://prometheus:9090/api/v1/query?query=up

4. Check dashboard permissions
   - Verify user has access to dashboards

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ Data Source Issues                                      │
├─────────────────────────────────────────────────────────┤
│ • Check data source URLs                                │
│ • Verify network connectivity between containers        │
│ • Check authentication credentials                      │
│ • Restart data source containers                        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Permission Issues                                       │
├─────────────────────────────────────────────────────────┤
│ • Check user roles and permissions                      │
│ • Verify dashboard ownership                            │
│ • Check organization settings                           │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Query Issues                                            │
├─────────────────────────────────────────────────────────┤
│ • Test queries in Prometheus directly                   │
│ • Check query syntax and time ranges                    │
│ • Verify metrics exist in Prometheus                    │
└─────────────────────────────────────────────────────────┘
```

---

## Network Issues

### Connectivity Problems

#### Problem: Can't Connect to Server
```
SYMPTOM: Can't SSH or access web interfaces

DIAGNOSTIC FLOW:
┌─────────────────┐
│  CAN YOU PING   │
│  THE SERVER?    │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
   YES       NO
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ SSH     │ │ NETWORK │
│ PORT    │ │ CABLE   │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ SSH     │ │ CABLE   │
│ RUNNING?│ │ OKAY?   │
└─────────┘ └─────────┘
    │         │
┌───┴───┐ ┌───┴───┐
▼       ▼ ▼       ▼
YES     NO YES     NO
│       │ │       │
▼       ▼ ▼       ▼
┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
│CHECK│ │START│ │REPL │ │CHECK│
│FIREW│ │SSH  │ │CABLE│ │ROUT │
└─────┘ └─────┘ └─────┘ └─────┘

QUICK FIXES:
• Restart SSH: sudo systemctl restart ssh
• Check firewall: sudo ufw status
• Verify IP address: ip addr show
• Check router settings
```

#### Problem: Slow Network Performance
```
SYMPTOM: Slow file transfers or streaming

DIAGNOSTIC STEPS:
1. Check network speed
   speedtest-cli

2. Check bandwidth usage
   nethogs

3. Check for network congestion
   iperf3 -s (server)
   iperf3 -c server-ip (client)

4. Check WiFi signal strength
   iwconfig (Linux)
   netsh wlan show interfaces (Windows)

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ WiFi Issues                                             │
├─────────────────────────────────────────────────────────┤
│ • Move closer to router                                 │
│ • Change WiFi channel                                   │
│ • Upgrade to 5GHz if available                          │
│ • Use Ethernet cable instead                            │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Network Congestion                                      │
├─────────────────────────────────────────────────────────┤
│ • Check for other devices using bandwidth               │
│ • Schedule large transfers during off-peak hours        │
│ • Upgrade internet plan if needed                       │
│ • Use QoS settings on router                            │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Server Performance                                      │
├─────────────────────────────────────────────────────────┤
│ • Check server CPU/memory usage                         │
│ • Optimize disk I/O                                     │
│ • Check for background processes                        │
│ • Upgrade server hardware if needed                     │
└─────────────────────────────────────────────────────────┘
```

---

## Performance Problems

### High CPU Usage
```
SYMPTOM: Server running slowly, high CPU usage

DIAGNOSTIC FLOW:
┌─────────────────┐
│  CHECK CPU      │
│  USAGE          │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  WHICH PROCESS? │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│ DOCKER  │ │ SYSTEM  │
│ PROCESS │ │ PROCESS │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ CONTAIN │ │ PROCESS │
│ LOGS    │ │ DETAILS │
└─────────┘ └─────────┘

COMMON CAUSES & SOLUTIONS:

┌─────────────────────────────────────────────────────────┐
│ Jellyfin Transcoding                                    │
├─────────────────────────────────────────────────────────┤
│ • Reduce transcoding quality                            │
│ • Enable hardware acceleration                          │
│ • Limit concurrent streams                              │
│ • Use direct play when possible                         │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Backup Processes                                        │
├─────────────────────────────────────────────────────────┤
│ • Schedule backups during off-peak hours                │
│ • Use incremental backups                               │
│ • Limit backup bandwidth                                │
│ • Check for stuck backup processes                      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Monitoring Overhead                                     │
├─────────────────────────────────────────────────────────┤
│ • Reduce monitoring frequency                           │
│ • Limit metrics collection                              │
│ • Use sampling for high-frequency metrics               │
│ • Optimize Prometheus retention                         │
└─────────────────────────────────────────────────────────┘
```

### High Memory Usage
```
SYMPTOM: Server running out of memory, services crashing

DIAGNOSTIC STEPS:
1. Check memory usage
   free -h
   htop

2. Check swap usage
   swapon --show

3. Check for memory leaks
   docker stats

4. Check system logs
   dmesg | grep -i kill

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ Add Swap Space                                          │
├─────────────────────────────────────────────────────────┤
│ • Create swap file: sudo fallocate -l 4G /swapfile     │
│ • Enable swap: sudo swapon /swapfile                    │
│ • Make permanent: add to /etc/fstab                     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Limit Container Memory                                  │
├─────────────────────────────────────────────────────────┤
│ • Add memory limits to docker-compose.yml              │
│ • Restart containers with limits                        │
│ • Monitor memory usage                                  │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Optimize Applications                                   │
├─────────────────────────────────────────────────────────┤
│ • Reduce Jellyfin transcoding quality                   │
│ • Limit concurrent connections                          │
│ • Optimize database queries                             │
│ • Use caching where possible                            │
└─────────────────────────────────────────────────────────┘
```

### Disk Space Issues
```
SYMPTOM: Running out of disk space

DIAGNOSTIC FLOW:
┌─────────────────┐
│  CHECK DISK     │
│  USAGE          │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  WHICH FOLDER?  │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│ MEDIA   │ │ SYSTEM  │
│ FILES   │ │ FILES   │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ MEDIA   │ │ LOGS    │
│ SIZE    │ │ & TEMP  │
└─────────┘ └─────────┘

QUICK CLEANUP COMMANDS:
• Find large files: find / -type f -size +100M
• Clean Docker: docker system prune -a
• Clean logs: sudo journalctl --vacuum-time=7d
• Clean temp: sudo rm -rf /tmp/*
• Clean package cache: sudo apt clean
```

---

## Security Issues

### Unauthorized Access
```
SYMPTOM: Unknown logins or suspicious activity

DIAGNOSTIC STEPS:
1. Check failed login attempts
   sudo fail2ban-client status
   sudo journalctl -u ssh | grep "Failed password"

2. Check active connections
   netstat -tulpn
   ss -tulpn

3. Check for suspicious processes
   ps aux | grep -v grep

4. Check file modifications
   find / -mtime -1 -ls

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ Immediate Actions                                       │
├─────────────────────────────────────────────────────────┤
│ • Change all passwords                                  │
│ • Disable SSH key authentication temporarily            │
│ • Check for unauthorized SSH keys                       │
│ • Review and update firewall rules                      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Long-term Security                                      │
├─────────────────────────────────────────────────────────┤
│ • Enable two-factor authentication                      │
│ • Use SSH key authentication only                       │
│ • Implement IP whitelisting                             │
│ • Regular security audits                               │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Monitoring & Alerting                                   │
├─────────────────────────────────────────────────────────┤
│ • Set up intrusion detection                            │
│ • Configure security alerts                             │
│ • Monitor access logs                                   │
│ • Regular backup verification                           │
└─────────────────────────────────────────────────────────┘
```

### SSL/TLS Issues
```
SYMPTOM: SSL certificate errors or warnings

DIAGNOSTIC FLOW:
┌─────────────────┐
│  SSL ERROR      │
│  TYPE?          │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│ EXPIRED │ │ INVALID │
│ CERT    │ │ CERT    │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ RENEW   │ │ CHECK   │
│ CERT    │ │ DNS     │
└─────────┘ └─────────┘

SOLUTIONS:
┌─────────────────────────────────────────────────────────┐
│ Certificate Expired                                     │
├─────────────────────────────────────────────────────────┤
│ • Force certificate renewal: docker-compose restart traefik│
│ • Check Let's Encrypt rate limits                       │
│ • Verify domain DNS settings                            │
│ • Check Traefik logs for errors                         │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ DNS Issues                                              │
├─────────────────────────────────────────────────────────┤
│ • Verify domain points to correct IP                    │
│ • Wait for DNS propagation                              │
│ • Check for DNS caching issues                          │
│ • Use DNS checker tools                                 │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Configuration Issues                                    │
├─────────────────────────────────────────────────────────┤
│ • Check Traefik configuration                           │
│ • Verify certificate resolver settings                  │
│ • Check file permissions on acme.json                   │
│ • Review Traefik logs                                   │
└─────────────────────────────────────────────────────────┘
```

---

## Data Recovery

### Backup Recovery
```
SYMPTOM: Need to restore from backup

RECOVERY FLOW:
┌─────────────────┐
│  WHAT TYPE OF   │
│  RECOVERY?      │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│ FULL    │ │ PARTIAL │
│ SYSTEM  │ │ DATA    │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ STOP    │ │ IDENTIFY│
│ ALL     │ │ FILES   │
│ SERVICES│ │ NEEDED  │
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ RESTORE │ │ RESTORE │
│ BACKUP  │ │ FILES   │
└─────────┘ └─────────┘

RECOVERY PROCEDURES:

┌─────────────────────────────────────────────────────────┐
│ Full System Recovery                                    │
├─────────────────────────────────────────────────────────┤
│ 1. Stop all services: docker-compose down               │
│ 2. Backup current state (if possible)                   │
│ 3. Restore system backup                                │
│ 4. Restore configuration files                          │
│ 5. Restart services: docker-compose up -d               │
│ 6. Verify all services are running                      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Partial Data Recovery                                   │
├─────────────────────────────────────────────────────────┤
│ 1. Identify missing/corrupted files                     │
│ 2. Stop affected services                               │
│ 3. Restore specific files from backup                   │
│ 4. Verify file integrity                                │
│ 5. Restart services                                     │
│ 6. Test functionality                                   │
└─────────────────────────────────────────────────────────┘
```

### Database Recovery
```
SYMPTOM: Database corruption or data loss

DIAGNOSTIC STEPS:
1. Check database status
   docker logs container-name

2. Check database integrity
   docker exec -it container-name /bin/bash
   # Run database-specific integrity checks

3. Check backup availability
   ls -la /backup/database/

4. Check disk space
   df -h

RECOVERY PROCEDURES:

┌─────────────────────────────────────────────────────────┐
│ PostgreSQL Recovery                                     │
├─────────────────────────────────────────────────────────┤
│ 1. Stop PostgreSQL container                            │
│ 2. Backup current data directory                        │
│ 3. Restore from backup: pg_restore -d dbname backup.dump│
│ 4. Start container                                      │
│ 5. Verify data integrity                                │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ MySQL/MariaDB Recovery                                  │
├─────────────────────────────────────────────────────────┤
│ 1. Stop MySQL container                                 │
│ 2. Backup current data directory                        │
│ 3. Restore from backup: mysql -u user -p dbname < backup.sql│
│ 4. Start container                                      │
│ 5. Verify data integrity                                │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ SQLite Recovery                                         │
├─────────────────────────────────────────────────────────┤
│ 1. Stop service using SQLite                            │
│ 2. Backup current database file                         │
│ 3. Replace with backup copy                             │
│ 4. Start service                                        │
│ 5. Verify data integrity                                │
└─────────────────────────────────────────────────────────┘
```

---

## Emergency Procedures

### Complete System Failure
```
EMERGENCY RECOVERY FLOW:
┌─────────────────┐
│  SYSTEM DOWN    │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  CAN YOU ACCESS │
│  SERVER?        │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
   YES       NO
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ CHECK   │ │ CHECK   │
│ SERVICES│ │ HARDWARE│
└─────────┘ └─────────┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ RESTART │ │ REPLACE │
│ SERVICES│ │ HARDWARE│
└─────────┘ └─────────┘

EMERGENCY CONTACTS:
• Hardware vendor support
• Internet service provider
• Backup service provider
• Domain registrar
• SSL certificate provider

EMERGENCY PROCEDURES:
1. Document the failure
2. Contact relevant support
3. Implement temporary solutions
4. Plan full recovery
5. Test all services after recovery
```

### Data Breach Response
```
SECURITY INCIDENT RESPONSE:
┌─────────────────┐
│  SUSPECTED      │
│  BREACH         │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  IMMEDIATE      │
│  ACTIONS        │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  INVESTIGATION  │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  RECOVERY       │
└─────────────────┘

IMMEDIATE ACTIONS:
1. Disconnect from network
2. Document everything
3. Change all passwords
4. Notify relevant parties
5. Preserve evidence

INVESTIGATION STEPS:
1. Identify breach scope
2. Determine attack vector
3. Assess data exposure
4. Review access logs
5. Check for persistence

RECOVERY STEPS:
1. Patch vulnerabilities
2. Restore from clean backup
3. Implement additional security
4. Monitor for re-infection
5. Update incident response plan
```

---

## Conclusion

This enhanced troubleshooting guide provides comprehensive diagnostic flows and solutions for common homelab issues. Key points to remember:

1. **Always start with the basics** - Check power, network, and basic connectivity first
2. **Document everything** - Keep notes of what you've tried and what worked
3. **Have a backup plan** - Always have recovery procedures ready
4. **Test solutions** - Verify fixes work before considering the issue resolved
5. **Learn from issues** - Use problems as opportunities to improve your setup

The visual flowcharts and diagnostic trees help quickly identify the root cause of issues, while the detailed solutions provide step-by-step guidance for resolution. Remember to always backup your configuration before making significant changes, and test thoroughly in a safe environment when possible. 