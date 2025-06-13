# Homelab Troubleshooting Guide

This guide provides solutions for common issues that may arise during the deployment and operation of your homelab environment.

## Table of Contents
1. [General Troubleshooting](#general-troubleshooting)
2. [SSH and Access Issues](#ssh-and-access-issues)
3. [Docker and Container Issues](#docker-and-container-issues)
4. [Network and Connectivity](#network-and-connectivity)
5. [Security and Authentication](#security-and-authentication)
6. [Backup and Recovery](#backup-and-recovery)
7. [Monitoring and Logging](#monitoring-and-logging)
8. [Performance Issues](#performance-issues)

## General Troubleshooting

### Playbook Execution Issues

#### Playbook Fails to Start
```bash
# Check Ansible version
ansible --version

# Verify inventory file
ansible-inventory --list

# Test connectivity
ansible all -m ping
```

#### Variable Validation Errors
```bash
# Check variable definitions
cat group_vars/all.yml

# Verify variable syntax
ansible-playbook main.yml --syntax-check

# Debug specific variable
ansible-playbook main.yml -vvv --tags debug
```

### System Requirements

#### Insufficient Resources
```bash
# Check available memory
free -h

# Check disk space
df -h

# Check CPU usage
top
```

#### Missing Dependencies
```bash
# Update package lists
apt update

# Install missing packages
apt install -y <package-name>

# Verify Python version
python3 --version
```

## SSH and Access Issues

### SSH Connection Problems

#### Connection Refused
```bash
# Check SSH service status
systemctl status sshd

# Verify SSH configuration
cat /etc/ssh/sshd_config

# Check SSH logs
tail -f /var/log/auth.log
```

#### Authentication Failures
```bash
# Verify SSH key permissions
ls -la ~/.ssh/

# Check authorized_keys
cat ~/.ssh/authorized_keys

# Test SSH connection with verbose output
ssh -vvv user@host
```

### Permission Issues

#### File Permission Errors
```bash
# Check file permissions
ls -la /path/to/file

# Fix permissions
chmod 644 /path/to/file
chown user:group /path/to/file

# Verify directory permissions
find /path/to/dir -type d -exec chmod 755 {} \;
```

## Docker and Container Issues

### Container Startup Problems

#### Container Fails to Start
```bash
# Check container logs
docker logs <container-name>

# Verify container configuration
docker inspect <container-name>

# Check Docker service status
systemctl status docker
```

#### Port Conflicts
```bash
# Check port usage
netstat -tulpn | grep LISTEN

# Verify port mappings
docker port <container-name>

# Check container network
docker network inspect bridge
```

### Docker Compose Issues

#### Compose File Errors
```bash
# Validate compose file
docker-compose config

# Check compose version
docker-compose version

# Debug compose execution
docker-compose up -d --verbose
```

#### Service Dependencies
```bash
# Check service status
docker-compose ps

# View service logs
docker-compose logs

# Restart specific service
docker-compose restart <service-name>
```

## Network and Connectivity

### DNS Resolution

#### DNS Lookup Failures
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
nslookup example.com

# Verify DNS service
systemctl status systemd-resolved
```

#### Reverse Proxy Issues
```bash
# Check Nginx configuration
nginx -t

# Verify proxy settings
cat /etc/nginx/sites-available/*

# Check Nginx logs
tail -f /var/log/nginx/error.log
```

### Firewall Problems

#### UFW Configuration
```bash
# Check firewall status
ufw status

# Verify rules
ufw show added

# Check firewall logs
tail -f /var/log/ufw.log
```

#### Port Blocking
```bash
# Test port connectivity
nc -zv host port

# Check port status
netstat -tulpn | grep <port>

# Verify service binding
ss -tulpn | grep <port>
```

## Security and Authentication

### Fail2Ban Issues

#### False Positives
```bash
# Check Fail2Ban status
fail2ban-client status

# View banned IPs
fail2ban-client status sshd

# Unban IP
fail2ban-client unban <ip>
```

#### Configuration Problems
```bash
# Verify Fail2Ban config
fail2ban-client -t

# Check jail configuration
cat /etc/fail2ban/jail.local

# View Fail2Ban logs
tail -f /var/log/fail2ban.log
```

### SSL/TLS Issues

#### Certificate Problems
```bash
# Check certificate validity
openssl x509 -in cert.pem -text -noout

# Verify certificate chain
openssl verify -CAfile ca.pem cert.pem

# Check SSL configuration
openssl s_client -connect host:443
```

#### Let's Encrypt Issues
```bash
# Check certbot status
certbot certificates

# Verify renewal configuration
cat /etc/letsencrypt/renewal/*.conf

# Test renewal
certbot renew --dry-run
```

## Backup and Recovery

### Backup Failures

#### Backup Script Issues
```bash
# Check backup logs
tail -f /var/log/backup.log

# Verify backup configuration
cat /etc/backup.conf

# Test backup script
./backup.sh --test
```

#### Storage Problems
```bash
# Check backup storage
df -h /backup

# Verify backup integrity
./verify-backup.sh

# Check backup permissions
ls -la /backup
```

### Recovery Issues

#### Restore Failures
```bash
# Check restore logs
tail -f /var/log/restore.log

# Verify backup files
ls -la /backup/restore

# Test restore process
./restore.sh --test
```

#### Data Corruption
```bash
# Verify backup checksums
md5sum /backup/*

# Check file integrity
./verify-integrity.sh

# Test backup extraction
tar -tvf backup.tar.gz
```

## Monitoring and Logging

### Log Management

#### Log Rotation Issues
```bash
# Check logrotate configuration
cat /etc/logrotate.conf

# Verify log rotation
logrotate -d /etc/logrotate.d/*

# Check log directory
ls -la /var/log
```

#### Log Analysis
```bash
# Search logs
grep "error" /var/log/*.log

# Monitor logs in real-time
tail -f /var/log/*.log

# Check log size
du -sh /var/log/*
```

### Monitoring Alerts

#### False Alerts
```bash
# Check alert configuration
cat /etc/monitoring/alerts.conf

# Verify alert thresholds
./check-thresholds.sh

# Test alert system
./test-alerts.sh
```

#### Missing Alerts
```bash
# Check monitoring service
systemctl status monitoring

# Verify alert delivery
./check-alerts.sh

# Test notification system
./test-notifications.sh
```

## Performance Issues

### Resource Usage

#### High CPU Usage
```bash
# Check CPU usage
top -c

# Identify resource-intensive processes
ps aux --sort=-%cpu

# Monitor system resources
htop
```

#### Memory Problems
```bash
# Check memory usage
free -h

# Monitor swap usage
swapon --show

# Check memory pressure
cat /proc/pressure/memory
```

### Network Performance

#### Slow Network
```bash
# Check network speed
speedtest-cli

# Monitor network usage
iftop

# Check network latency
ping -c 10 host
```

#### Bandwidth Issues
```bash
# Check bandwidth usage
nethogs

# Monitor network traffic
tcpdump -i any

# Check network configuration
ip a
```

## Getting Help

If you're unable to resolve an issue using this guide:

1. Check the [GitHub Issues](https://github.com/your-repo/issues) for similar problems
2. Review the [Documentation](https://github.com/your-repo/docs)
3. Join our [Discord Community](https://discord.gg/your-server)
4. Submit a new issue with:
   - Detailed error messages
   - Relevant logs
   - System information
   - Steps to reproduce

## Contributing

If you've found a solution to a problem not covered in this guide, please:

1. Fork the repository
2. Add your solution to this guide
3. Submit a pull request

Your contributions help improve the homelab experience for everyone! 