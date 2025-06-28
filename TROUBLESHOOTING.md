# 🔧 Troubleshooting Guide

This guide covers common issues and their solutions for the Ansible Homelab deployment.

## 📋 **Quick Diagnostic Commands**

### System Health Check
```bash
# Check system resources
htop
df -h
free -h

# Check Docker status
docker ps -a
docker system df

# Check service logs
docker logs <service-name>

# Check network connectivity
ping 8.8.8.8
nslookup your-domain.com
```

### Service Status Check
```bash
# Check all running services
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check specific service
docker ps | grep <service-name>

# Check service health
docker inspect <service-name> | grep -A 10 "Health"
```

## 🚨 **Common Issues & Solutions**

### Issue 1: Services Won't Start

#### Symptoms
- Services show "Exited" status
- Docker containers fail to start
- Error messages in logs

#### Solutions

**Check Docker Status:**
```bash
# Check Docker daemon
systemctl status docker

# Restart Docker if needed
sudo systemctl restart docker

# Check Docker logs
journalctl -u docker -f
```

**Check Resource Limits:**
```bash
# Check available memory
free -h

# Check available disk space
df -h

# Check CPU usage
top
```

**Check Port Conflicts:**
```bash
# Check what's using a port
sudo netstat -tulpn | grep :<port>

# Kill process using port (if needed)
sudo kill -9 <PID>
```

**Check Service Logs:**
```bash
# View service logs
docker logs <service-name>

# Follow logs in real-time
docker logs -f <service-name>

# Check logs for specific time
docker logs --since 1h <service-name>
```

### Issue 2: Domain Not Accessible

#### Symptoms
- Can't access services via domain
- SSL certificate errors
- DNS resolution issues

#### Solutions

**Check DNS Configuration:**
```bash
# Test DNS resolution
nslookup your-domain.com
dig your-domain.com

# Check if DNS is pointing to your server
nslookup traefik.your-domain.com
```

**Check Traefik Configuration:**
```bash
# Check Traefik logs
docker logs traefik

# Check Traefik configuration
docker exec traefik traefik version
docker exec traefik traefik healthcheck
```

**Check Firewall Settings:**
```bash
# Check UFW status
sudo ufw status

# Check if ports are open
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

**Check Cloudflare Settings:**
1. Ensure SSL/TLS is set to "Full" or "Full (strict)"
2. Check if DNS records are pointing to your server IP
3. Verify API token has correct permissions

### Issue 3: SSL Certificate Problems

#### Symptoms
- Browser shows SSL errors
- Certificate not trusted
- Mixed content warnings

#### Solutions

**Check Certificate Status:**
```bash
# Check certificate in Traefik
docker logs traefik | grep -i cert

# Check certificate expiration
openssl s_client -connect your-domain.com:443 -servername your-domain.com
```

**Verify Cloudflare Configuration:**
1. **SSL/TLS Mode**: Set to "Full" or "Full (strict)"
2. **Always Use HTTPS**: Enable
3. **Minimum TLS Version**: Set to 1.2 or higher

**Check Let's Encrypt Rate Limits:**
```bash
# Check certificate requests
docker logs traefik | grep -i "rate limit"

# Wait if rate limited (Let's Encrypt has limits)
# Try again after 1 hour
```

**Manual Certificate Check:**
```bash
# Test certificate chain
openssl s_client -connect your-domain.com:443 -servername your-domain.com -showcerts

# Check certificate details
echo | openssl s_client -servername your-domain.com -connect your-domain.com:443 2>/dev/null | openssl x509 -noout -dates
```

### Issue 4: Database Connection Errors

#### Symptoms
- Services can't connect to databases
- Database connection timeout
- Authentication failures

#### Solutions

**Check Database Status:**
```bash
# Check PostgreSQL
docker ps | grep postgres
docker logs postgresql

# Check Redis
docker ps | grep redis
docker logs redis

# Test database connections
docker exec postgresql pg_isready
docker exec redis redis-cli ping
```

**Check Database Credentials:**
```bash
# Test PostgreSQL connection
docker exec postgresql psql -U homelab -d homelab -c "SELECT version();"

# Test Redis connection
docker exec redis redis-cli -a <password> ping
```

**Check Network Connectivity:**
```bash
# Test inter-container communication
docker exec sonarr ping postgresql
docker exec sonarr ping redis

# Check Docker networks
docker network ls
docker network inspect homelab
```

### Issue 5: Authentication Issues

#### Symptoms
- Can't login to services
- Authentik not working
- Forward auth failures

#### Solutions

**Check Authentik Status:**
```bash
# Check Authentik logs
docker logs authentik

# Check Authentik health
curl -f http://localhost:9000/if/user/

# Check Authentik configuration
docker exec authentik authentik version
```

**Verify Authentik Configuration:**
1. Check admin credentials in vault
2. Verify database connection
3. Check application configuration

**Check Traefik Forward Auth:**
```bash
# Check Traefik logs for auth errors
docker logs traefik | grep -i auth

# Test forward auth endpoint
curl -I http://localhost:9000/outpost.goauthentik.io/auth/traefik
```

### Issue 6: Monitoring Not Working

#### Symptoms
- Grafana dashboards empty
- Prometheus targets down
- No metrics available

#### Solutions

**Check Prometheus:**
```bash
# Check Prometheus status
docker logs prometheus

# Check targets
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health}'

# Check Prometheus configuration
docker exec prometheus cat /etc/prometheus/prometheus.yml
```

**Check Grafana:**
```bash
# Check Grafana logs
docker logs grafana

# Check data sources
curl -s -u admin:<password> http://localhost:3000/api/datasources

# Test data source connections
curl -s -u admin:<password> http://localhost:3000/api/datasources/1/health
```

**Check Exporters:**
```bash
# Check node exporter
curl -s http://localhost:9100/metrics | head -10

# Check postgres exporter
curl -s http://localhost:9187/metrics | head -10

# Check redis exporter
curl -s http://localhost:9121/metrics | head -10
```

### Issue 7: Backup Failures

#### Symptoms
- Backup jobs failing
- Backup files corrupted
- Backup storage full

#### Solutions

**Check Backup Scripts:**
```bash
# Check backup script permissions
ls -la /opt/scripts/backup/

# Test backup script manually
/opt/scripts/backup/backup.sh --test

# Check backup logs
tail -f /opt/logs/backup.log
```

**Check Storage Space:**
```bash
# Check backup directory space
df -h /opt/backup

# Check for old backups
ls -la /opt/backup/

# Clean up old backups if needed
find /opt/backup -name "*.tar.gz" -mtime +30 -delete
```

**Check Database Backups:**
```bash
# Test PostgreSQL backup
docker exec postgresql pg_dump -U homelab homelab > /tmp/test_backup.sql

# Test Redis backup
docker exec redis redis-cli --rdb /tmp/test_backup.rdb
```

### Issue 8: Performance Issues

#### Symptoms
- Slow service response
- High resource usage
- Timeout errors

#### Solutions

**Check Resource Usage:**
```bash
# Monitor system resources
htop
iotop
nload

# Check Docker resource usage
docker stats

# Check specific container resources
docker stats <service-name>
```

**Optimize Resource Limits:**
```bash
# Check current resource limits
docker inspect <service-name> | grep -A 10 "HostConfig"

# Update resource limits in docker-compose.yml
# Example:
# deploy:
#   resources:
#     limits:
#       memory: 1G
#       cpus: '0.5'
```

**Check for Resource Leaks:**
```bash
# Check for zombie processes
ps aux | grep defunct

# Check for memory leaks
free -h
cat /proc/meminfo

# Check disk I/O
iostat -x 1 5
```

## 🔍 **Advanced Diagnostics**

### Network Diagnostics
```bash
# Check Docker networks
docker network ls
docker network inspect homelab
docker network inspect monitoring

# Check routing
ip route show
ip addr show

# Check DNS resolution
cat /etc/resolv.conf
systemd-resolve --status
```

### Service Dependencies
```bash
# Check service dependencies
docker-compose -f /opt/docker/traefik/docker-compose.yml config

# Check service startup order
docker-compose -f /opt/docker/traefik/docker-compose.yml ps

# Check service health
docker-compose -f /opt/docker/traefik/docker-compose.yml exec traefik traefik healthcheck
```

### Log Analysis
```bash
# Search for errors in all logs
find /opt/logs -name "*.log" -exec grep -l "ERROR\|FATAL\|CRITICAL" {} \;

# Check recent errors
find /opt/logs -name "*.log" -exec grep -H "ERROR" {} \; | tail -20

# Monitor logs in real-time
tail -f /opt/logs/*.log | grep -E "(ERROR|WARN|FATAL)"
```

### Configuration Validation
```bash
# Validate Ansible configuration
ansible-playbook site.yml --syntax-check

# Validate Docker Compose files
docker-compose -f /opt/docker/*/docker-compose.yml config

# Check environment variables
env | grep -E "(DOMAIN|PASSWORD|TOKEN)"
```

## 🛠 **Recovery Procedures**

### Service Recovery
```bash
# Restart a specific service
docker-compose -f /opt/docker/<service>/docker-compose.yml restart

# Restart all services
docker-compose -f /opt/docker/*/docker-compose.yml restart

# Force recreate a service
docker-compose -f /opt/docker/<service>/docker-compose.yml up -d --force-recreate
```

### Database Recovery
```bash
# Restore PostgreSQL from backup
docker exec -i postgresql psql -U homelab -d homelab < /opt/backup/postgresql_backup.sql

# Restore Redis from backup
docker exec redis redis-cli --rdb /opt/backup/redis_backup.rdb
```

### Configuration Recovery
```bash
# Restore from backup
cp /opt/backup/config_backup.tar.gz /tmp/
cd /tmp && tar -xzf config_backup.tar.gz

# Restore specific configuration
cp /opt/backup/traefik.yml /opt/config/traefik/
```

## 📞 **Getting Help**

### Before Asking for Help
1. **Check this troubleshooting guide**
2. **Run diagnostic commands**
3. **Collect relevant logs**
4. **Note exact error messages**
5. **Document your environment**

### Information to Provide
- **OS and version**
- **Docker version**
- **Ansible version**
- **Error messages**
- **Service logs**
- **Configuration files**
- **Steps to reproduce**

### Support Channels
- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and help
- **Documentation**: Check the main README and guides
- **Community**: Join the community for support

## 🔄 **Prevention Tips**

### Regular Maintenance
```bash
# Weekly maintenance script
#!/bin/bash
# Update system packages
apt update && apt upgrade -y

# Update Docker images
docker-compose -f /opt/docker/*/docker-compose.yml pull

# Clean up Docker
docker system prune -f

# Check disk space
df -h

# Run health checks
ansible-playbook tasks/health_check.yml --ask-vault-pass
```

### Monitoring Setup
- Set up alerts for critical services
- Monitor disk space and memory usage
- Check SSL certificate expiration
- Monitor backup success/failure

### Backup Strategy
- Regular automated backups
- Test backup restoration
- Store backups in multiple locations
- Monitor backup storage space

---

**Remember**: Most issues can be resolved by checking logs and following the diagnostic steps above. When in doubt, start with the basic health checks and work your way through the troubleshooting process systematically. 