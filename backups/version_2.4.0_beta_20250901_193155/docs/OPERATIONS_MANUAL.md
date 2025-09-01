# Operations Manual: Day-to-Day Homelab Management

## Table of Contents

1. [Daily Operations](#daily-operations)
2. [Weekly Maintenance](#weekly-maintenance)
3. [Monthly Tasks](#monthly-tasks)
4. [Quarterly Reviews](#quarterly-reviews)
5. [Emergency Procedures](#emergency-procedures)
6. [Performance Monitoring](#performance-monitoring)
7. [Security Operations](#security-operations)
8. [Backup Operations](#backup-operations)

---

## Daily Operations

### Morning Health Check (5 minutes)

#### System Status Check
```bash
# Check overall system health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check critical services
curl -f http://localhost:3000/api/health || echo "Homepage down"
curl -f http://localhost:8096/health || echo "Jellyfin down"
curl -f http://localhost:3001/api/health || echo "Grafana down"

# Check disk usage
df -h | grep -E "(/$|/opt|/var)"

# Check memory usage
free -h

# Check network connectivity
ping -c 3 8.8.8.8
```

#### Quick Dashboard Review
1. **Homepage Dashboard**: Check all service status indicators
2. **Grafana**: Review key metrics (CPU, memory, disk, network)
3. **Pi-hole**: Check DNS queries and blocked requests
4. **Security Dashboard**: Review any security alerts

#### Automated Health Check Script
```bash
#!/bin/bash
# daily-health-check.sh

echo "=== Daily Health Check $(date) ==="

# Check Docker services
echo "Docker Services:"
docker ps --format "table {{.Names}}\t{{.Status}}" | grep -v "Up"

# Check disk usage
echo "Disk Usage:"
df -h | awk '$5 > "80%" {print $0}'

# Check memory usage
echo "Memory Usage:"
free -h | awk 'NR==2{printf "Memory Usage: %s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }'

# Check critical services
services=("homepage:3000" "jellyfin:8096" "grafana:3001" "traefik:8080")
for service in "${services[@]}"; do
    if curl -f "http://localhost:${service#*:}/health" >/dev/null 2>&1; then
        echo "✓ ${service%:*} is healthy"
    else
        echo "✗ ${service%:*} is down"
    fi
done
```

### Service Monitoring

#### Real-time Monitoring Commands
```bash
# Monitor Docker logs in real-time
docker logs -f --tail=50 container_name

# Monitor system resources
htop

# Monitor network traffic
iftop

# Monitor disk I/O
iotop

# Monitor Docker stats
docker stats --no-stream
```

#### Alert Monitoring
1. **Check Grafana Alerts**: Review any triggered alerts
2. **Check Email Notifications**: Review any system notifications
3. **Check Security Alerts**: Review CrowdSec and Fail2ban logs
4. **Check Backup Status**: Verify last backup completion

### User Support

#### Common User Issues
1. **"I can't access Jellyfin"**
   - Check if Jellyfin container is running
   - Verify network connectivity
   - Check authentication status

2. **"Downloads aren't working"**
   - Check Sonarr/Radarr status
   - Verify download client connectivity
   - Check disk space

3. **"Photos aren't syncing"**
   - Check Immich container status
   - Verify storage permissions
   - Check network connectivity

#### Support Procedures
```bash
# Quick service restart
docker restart service_name

# Check service logs
docker logs service_name --tail=100

# Check service configuration
docker exec service_name cat /config/config.yml

# Restart all services
docker-compose -f /opt/docker/docker-compose.yml restart
```

---

## Weekly Maintenance

### System Updates (Sunday 2:00 AM)

#### Automated Update Script
```bash
#!/bin/bash
# weekly-updates.sh

echo "=== Weekly System Updates $(date) ==="

# Update system packages
apt update && apt upgrade -y

# Update Docker images
docker images --format "{{.Repository}}:{{.Tag}}" | xargs -L1 docker pull

# Restart services with new images
cd /opt/docker
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

# Clean up old containers
docker container prune -f

# Clean up old volumes
docker volume prune -f

echo "Weekly updates completed"
```

#### Update Verification
```bash
# Verify all services are running
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

# Check for any failed services
docker ps -a --filter "status=exited"

# Test critical services
curl -f http://localhost:3000/api/health
curl -f http://localhost:8096/health
curl -f http://localhost:3001/api/health
```

### Performance Review

#### Performance Metrics Collection
```bash
#!/bin/bash
# weekly-performance-report.sh

echo "=== Weekly Performance Report $(date) ==="

# CPU usage over the week
echo "CPU Usage (7-day average):"
docker exec prometheus promtool query-range --start=$(date -d '7 days ago' +%s) \
    --end=$(date +%s) --step=1h 'avg(rate(container_cpu_usage_seconds_total[1h]))' \
    http://localhost:9090

# Memory usage over the week
echo "Memory Usage (7-day average):"
docker exec prometheus promtool query-range --start=$(date -d '7 days ago' +%s) \
    --end=$(date +%s) --step=1h 'avg(container_memory_usage_bytes)' \
    http://localhost:9090

# Disk usage
echo "Disk Usage:"
df -h

# Network usage
echo "Network Usage:"
docker exec prometheus promtool query-range --start=$(date -d '7 days ago' +%s) \
    --end=$(date +%s) --step=1h 'avg(rate(container_network_receive_bytes_total[1h]))' \
    http://localhost:9090
```

#### Performance Optimization
```bash
# Optimize Docker storage
docker system prune -f

# Optimize database performance
docker exec postgres psql -U postgres -c "VACUUM ANALYZE;"

# Clear old logs
find /var/log -name "*.log" -mtime +7 -delete
find /opt/docker/*/logs -name "*.log" -mtime +7 -delete
```

### Security Review

#### Security Scan
```bash
#!/bin/bash
# weekly-security-scan.sh

echo "=== Weekly Security Scan $(date) ==="

# Check for failed login attempts
echo "Failed login attempts:"
grep "Failed password" /var/log/auth.log | wc -l

# Check for suspicious IPs
echo "Suspicious IPs:"
docker logs crowdsec 2>&1 | grep "ban" | tail -10

# Check SSL certificate expiration
echo "SSL Certificate Status:"
for cert in /etc/letsencrypt/live/*/cert.pem; do
    if [ -f "$cert" ]; then
        echo "$(basename $(dirname $(dirname $cert))): $(openssl x509 -enddate -noout -in $cert)"
    fi
done

# Check for outdated packages
echo "Outdated packages:"
apt list --upgradable 2>/dev/null | wc -l

# Check Docker image vulnerabilities
echo "Docker image scan:"
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    aquasec/trivy image --severity HIGH,CRITICAL $(docker images --format "{{.Repository}}:{{.Tag}}")
```

#### Security Hardening
```bash
# Update firewall rules
ufw --force enable

# Check for unauthorized access
grep "Accepted password" /var/log/auth.log | tail -20

# Review security logs
docker logs fail2ban 2>&1 | tail -50
docker logs crowdsec 2>&1 | tail -50
```

---

## Monthly Tasks

### Comprehensive Backup Verification

#### Backup Test Script
```bash
#!/bin/bash
# monthly-backup-test.sh

echo "=== Monthly Backup Verification $(date) ==="

# Test database backup restoration
echo "Testing database backup restoration..."
docker exec postgres pg_restore -U postgres -d test_db /backup/latest.sql
if [ $? -eq 0 ]; then
    echo "✓ Database backup verification successful"
    docker exec postgres dropdb -U postgres test_db
else
    echo "✗ Database backup verification failed"
fi

# Test configuration backup
echo "Testing configuration backup..."
tar -tzf /backup/config-$(date +%Y%m).tar.gz >/dev/null
if [ $? -eq 0 ]; then
    echo "✓ Configuration backup verification successful"
else
    echo "✗ Configuration backup verification failed"
fi

# Test media backup
echo "Testing media backup..."
tar -tzf /backup/media-$(date +%Y%m).tar.gz >/dev/null
if [ $? -eq 0 ]; then
    echo "✓ Media backup verification successful"
else
    echo "✗ Media backup verification failed"
fi
```

### Capacity Planning

#### Capacity Analysis Script
```bash
#!/bin/bash
# monthly-capacity-analysis.sh

echo "=== Monthly Capacity Analysis $(date) ==="

# Storage growth analysis
echo "Storage Usage Growth:"
df -h | grep -E "(/$|/opt|/var)"

# Database size analysis
echo "Database Sizes:"
docker exec postgres psql -U postgres -c "
SELECT 
    datname as database_name,
    pg_size_pretty(pg_database_size(datname)) as size
FROM pg_database
ORDER BY pg_database_size(datname) DESC;
"

# Docker image usage
echo "Docker Image Usage:"
docker system df

# Log file sizes
echo "Log File Sizes:"
find /var/log -name "*.log" -exec du -h {} + | sort -hr | head -10
```

### User Access Review

#### Access Audit Script
```bash
#!/bin/bash
# monthly-access-audit.sh

echo "=== Monthly Access Audit $(date) ==="

# Review user accounts
echo "Active User Accounts:"
docker exec authentik ak user list

# Review service access logs
echo "Service Access Logs:"
docker logs traefik 2>&1 | grep "access" | tail -50

# Review failed authentication attempts
echo "Failed Authentication Attempts:"
docker logs authentik 2>&1 | grep "failed" | tail -20

# Review API usage
echo "API Usage Statistics:"
docker exec prometheus promtool query 'sum(rate(http_requests_total[30d]))' http://localhost:9090
```

### Performance Optimization

#### Performance Tuning Script
```bash
#!/bin/bash
# monthly-performance-tuning.sh

echo "=== Monthly Performance Tuning $(date) ==="

# Database optimization
echo "Optimizing database..."
docker exec postgres psql -U postgres -c "
VACUUM ANALYZE;
REINDEX DATABASE postgres;
"

# Docker optimization
echo "Optimizing Docker..."
docker system prune -f
docker image prune -f
docker volume prune -f

# System optimization
echo "Optimizing system..."
echo 3 > /proc/sys/vm/drop_caches
systemctl restart docker

# Service optimization
echo "Optimizing services..."
docker restart prometheus grafana loki
```

---

## Quarterly Reviews

### Security Assessment

#### Comprehensive Security Review
```bash
#!/bin/bash
# quarterly-security-assessment.sh

echo "=== Quarterly Security Assessment $(date) ==="

# Vulnerability scan
echo "Running vulnerability scan..."
nmap -sV -sC -p- localhost

# SSL/TLS configuration check
echo "Checking SSL/TLS configuration..."
for domain in $(cat /opt/docker/traefik/domains.txt); do
    echo "Testing $domain..."
    openssl s_client -connect $domain:443 -servername $domain < /dev/null 2>/dev/null | \
        openssl x509 -noout -text | grep -E "(Subject:|Issuer:|Not After:)"
done

# Access control review
echo "Reviewing access controls..."
docker exec authentik ak user list --format table
docker exec authentik ak group list --format table

# Security log analysis
echo "Analyzing security logs..."
echo "Failed login attempts (last 90 days):"
grep "Failed password" /var/log/auth.log | wc -l

echo "Banned IPs (last 90 days):"
docker logs crowdsec 2>&1 | grep "ban" | wc -l
```

### Disaster Recovery Testing

#### DR Test Script
```bash
#!/bin/bash
# quarterly-dr-test.sh

echo "=== Quarterly Disaster Recovery Test $(date) ==="

# Test backup restoration
echo "Testing backup restoration..."
mkdir -p /tmp/dr-test
cd /tmp/dr-test

# Restore configuration
tar -xzf /backup/config-$(date +%Y%m).tar.gz
if [ $? -eq 0 ]; then
    echo "✓ Configuration restoration successful"
else
    echo "✗ Configuration restoration failed"
fi

# Test service recovery
echo "Testing service recovery..."
docker-compose -f /opt/docker/docker-compose.yml down
docker-compose -f /opt/docker/docker-compose.yml up -d

# Verify services
sleep 30
for service in homepage jellyfin grafana; do
    if curl -f "http://localhost:$(docker port $service | cut -d: -f2)" >/dev/null 2>&1; then
        echo "✓ $service recovery successful"
    else
        echo "✗ $service recovery failed"
    fi
done

# Cleanup
cd /
rm -rf /tmp/dr-test
```

### Performance Benchmarking

#### Performance Benchmark Script
```bash
#!/bin/bash
# quarterly-performance-benchmark.sh

echo "=== Quarterly Performance Benchmark $(date) ==="

# CPU benchmark
echo "CPU Benchmark:"
sysbench cpu --cpu-max-prime=20000 run

# Memory benchmark
echo "Memory Benchmark:"
sysbench memory --memory-block-size=1K --memory-total-size=100G run

# Disk benchmark
echo "Disk Benchmark:"
sysbench fileio --file-test-mode=seqwr run

# Network benchmark
echo "Network Benchmark:"
iperf3 -c localhost -t 10

# Database benchmark
echo "Database Benchmark:"
docker exec postgres psql -U postgres -c "
SELECT 
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats
WHERE schemaname = 'public'
ORDER BY n_distinct DESC
LIMIT 10;
"
```

---

## Emergency Procedures

### Service Outage Response

#### Emergency Response Script
```bash
#!/bin/bash
# emergency-response.sh

echo "=== Emergency Response $(date) ==="

# Check critical services
critical_services=("traefik" "authentik" "postgres" "redis")
for service in "${critical_services[@]}"; do
    if ! docker ps | grep -q $service; then
        echo "CRITICAL: $service is down"
        docker start $service
        if [ $? -eq 0 ]; then
            echo "✓ $service restarted successfully"
        else
            echo "✗ Failed to restart $service"
        fi
    fi
done

# Check disk space
if [ $(df / | awk 'NR==2 {print $5}' | sed 's/%//') -gt 90 ]; then
    echo "CRITICAL: Disk space critical"
    docker system prune -f
    find /var/log -name "*.log" -mtime +1 -delete
fi

# Check memory usage
if [ $(free | awk 'NR==2{printf "%.0f", $3*100/$2}') -gt 90 ]; then
    echo "CRITICAL: Memory usage critical"
    docker restart $(docker ps --format "{{.Names}}" | head -5)
fi
```

### Data Recovery Procedures

#### Data Recovery Script
```bash
#!/bin/bash
# data-recovery.sh

echo "=== Data Recovery $(date) ==="

# Stop all services
echo "Stopping all services..."
docker-compose -f /opt/docker/docker-compose.yml down

# Restore from latest backup
echo "Restoring from backup..."
tar -xzf /backup/config-$(date +%Y%m).tar.gz -C /opt/docker/

# Restore database
echo "Restoring database..."
docker exec -i postgres pg_restore -U postgres -d postgres < /backup/db-$(date +%Y%m).sql

# Start services
echo "Starting services..."
docker-compose -f /opt/docker/docker-compose.yml up -d

# Verify recovery
echo "Verifying recovery..."
sleep 30
for service in homepage jellyfin grafana; do
    if curl -f "http://localhost:$(docker port $service | cut -d: -f2)" >/dev/null 2>&1; then
        echo "✓ $service recovered successfully"
    else
        echo "✗ $service recovery failed"
    fi
done
```

### Security Incident Response

#### Security Incident Script
```bash
#!/bin/bash
# security-incident-response.sh

echo "=== Security Incident Response $(date) ==="

# Isolate affected systems
echo "Isolating affected systems..."
docker network disconnect bridge $(docker ps --format "{{.Names}}")

# Collect evidence
echo "Collecting evidence..."
mkdir -p /var/log/incident-$(date +%Y%m%d-%H%M%S)
cp /var/log/auth.log /var/log/incident-$(date +%Y%m%d-%H%M%S)/
cp /var/log/syslog /var/log/incident-$(date +%Y%m%d-%H%M%S)/
docker logs --since 24h > /var/log/incident-$(date +%Y%m%d-%H%M%S)/docker.log

# Block suspicious IPs
echo "Blocking suspicious IPs..."
docker logs crowdsec 2>&1 | grep "ban" | awk '{print $NF}' | \
    xargs -I {} ufw deny from {}

# Reset compromised accounts
echo "Resetting compromised accounts..."
docker exec authentik ak user list | grep -E "(admin|root)" | \
    awk '{print $1}' | xargs -I {} docker exec authentik ak user reset-password {}

# Restore from clean backup
echo "Restoring from clean backup..."
tar -xzf /backup/config-$(date +%Y%m).tar.gz -C /opt/docker/
docker-compose -f /opt/docker/docker-compose.yml restart
```

---

## Performance Monitoring

### Real-time Performance Monitoring

#### Performance Monitor Script
```bash
#!/bin/bash
# performance-monitor.sh

echo "=== Performance Monitor $(date) ==="

# CPU monitoring
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1

# Memory monitoring
echo "Memory Usage:"
free | awk 'NR==2{printf "%.2f%%", $3*100/$2}'

# Disk monitoring
echo "Disk Usage:"
df -h | awk '$5 > "80%" {print $0}'

# Network monitoring
echo "Network Usage:"
docker exec prometheus promtool query 'rate(container_network_receive_bytes_total[5m])' http://localhost:9090

# Service response times
echo "Service Response Times:"
for service in homepage jellyfin grafana; do
    start_time=$(date +%s.%N)
    curl -f "http://localhost:$(docker port $service | cut -d: -f2)" >/dev/null 2>&1
    end_time=$(date +%s.%N)
    response_time=$(echo "$end_time - $start_time" | bc)
    echo "$service: ${response_time}s"
done
```

### Performance Alerting

#### Performance Alert Script
```bash
#!/bin/bash
# performance-alert.sh

# CPU alert
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo "ALERT: High CPU usage: ${cpu_usage}%"
    # Send notification
fi

# Memory alert
memory_usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ $memory_usage -gt 80 ]; then
    echo "ALERT: High memory usage: ${memory_usage}%"
    # Send notification
fi

# Disk alert
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $disk_usage -gt 80 ]; then
    echo "ALERT: High disk usage: ${disk_usage}%"
    # Send notification
fi

# Service response time alert
for service in homepage jellyfin grafana; do
    start_time=$(date +%s.%N)
    curl -f "http://localhost:$(docker port $service | cut -d: -f2)" >/dev/null 2>&1
    end_time=$(date +%s.%N)
    response_time=$(echo "$end_time - $start_time" | bc)
    if (( $(echo "$response_time > 2" | bc -l) )); then
        echo "ALERT: Slow response time for $service: ${response_time}s"
        # Send notification
    fi
done
```

---

## Security Operations

### Security Monitoring

#### Security Monitor Script
```bash
#!/bin/bash
# security-monitor.sh

echo "=== Security Monitor $(date) ==="

# Monitor failed login attempts
failed_logins=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "Failed login attempts (last hour): $failed_logins"

# Monitor suspicious IPs
suspicious_ips=$(docker logs crowdsec 2>&1 | grep "ban" | tail -10)
echo "Suspicious IPs:"
echo "$suspicious_ips"

# Monitor SSL certificate expiration
for cert in /etc/letsencrypt/live/*/cert.pem; do
    if [ -f "$cert" ]; then
        expiry=$(openssl x509 -enddate -noout -in $cert | cut -d= -f2)
        days_left=$(( ($(date -d "$expiry" +%s) - $(date +%s)) / 86400 ))
        if [ $days_left -lt 30 ]; then
            echo "WARNING: SSL certificate for $(basename $(dirname $(dirname $cert))) expires in $days_left days"
        fi
    fi
done

# Monitor unauthorized access attempts
unauthorized_access=$(grep "Unauthorized" /var/log/nginx/access.log | wc -l)
echo "Unauthorized access attempts (last hour): $unauthorized_access"
```

### Security Hardening

#### Security Hardening Script
```bash
#!/bin/bash
# security-hardening.sh

echo "=== Security Hardening $(date) ==="

# Update firewall rules
echo "Updating firewall rules..."
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp

# Secure SSH configuration
echo "Securing SSH configuration..."
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh

# Update security packages
echo "Updating security packages..."
apt update && apt upgrade -y

# Scan for vulnerabilities
echo "Scanning for vulnerabilities..."
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    aquasec/trivy image --severity HIGH,CRITICAL $(docker images --format "{{.Repository}}:{{.Tag}}")
```

---

## Backup Operations

### Automated Backup

#### Backup Script
```bash
#!/bin/bash
# automated-backup.sh

echo "=== Automated Backup $(date) ==="

# Create backup directory
backup_dir="/backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p $backup_dir

# Backup configuration files
echo "Backing up configuration files..."
tar -czf $backup_dir/config.tar.gz /opt/docker/config/

# Backup database
echo "Backing up database..."
docker exec postgres pg_dump -U postgres postgres > $backup_dir/database.sql

# Backup media files (incremental)
echo "Backing up media files..."
rsync -av --delete /media/ $backup_dir/media/

# Backup logs
echo "Backing up logs..."
tar -czf $backup_dir/logs.tar.gz /var/log/

# Create backup manifest
echo "Creating backup manifest..."
cat > $backup_dir/manifest.txt << EOF
Backup created: $(date)
Configuration: config.tar.gz
Database: database.sql
Media: media/
Logs: logs.tar.gz
EOF

# Clean up old backups (keep 7 days)
find /backup -type d -mtime +7 -exec rm -rf {} \;

echo "Backup completed: $backup_dir"
```

### Backup Verification

#### Backup Verification Script
```bash
#!/bin/bash
# backup-verification.sh

echo "=== Backup Verification $(date) ==="

# Verify configuration backup
echo "Verifying configuration backup..."
if tar -tzf /backup/latest/config.tar.gz >/dev/null 2>&1; then
    echo "✓ Configuration backup is valid"
else
    echo "✗ Configuration backup is corrupted"
fi

# Verify database backup
echo "Verifying database backup..."
if docker exec postgres pg_restore -U postgres -l /backup/latest/database.sql >/dev/null 2>&1; then
    echo "✓ Database backup is valid"
else
    echo "✗ Database backup is corrupted"
fi

# Verify media backup
echo "Verifying media backup..."
if [ -d "/backup/latest/media" ]; then
    echo "✓ Media backup is valid"
else
    echo "✗ Media backup is missing"
fi

# Test restoration
echo "Testing restoration..."
mkdir -p /tmp/backup-test
tar -xzf /backup/latest/config.tar.gz -C /tmp/backup-test/
if [ $? -eq 0 ]; then
    echo "✓ Restoration test successful"
else
    echo "✗ Restoration test failed"
fi
rm -rf /tmp/backup-test
```

This comprehensive operations manual provides detailed procedures for day-to-day management, maintenance, and emergency response for your homelab system. 