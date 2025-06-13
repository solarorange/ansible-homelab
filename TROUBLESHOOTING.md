# Troubleshooting Guide

This guide provides solutions for common issues that may arise during deployment and operation of the homelab environment.

## Table of Contents
- [Common Issues](#common-issues)
- [Debugging Procedures](#debugging-procedures)
- [Log Analysis](#log-analysis)
- [Network Troubleshooting](#network-troubleshooting)
- [Service-Specific Issues](#service-specific-issues)
- [Recovery Procedures](#recovery-procedures)

## Common Issues

### Ansible Playbook Issues

1. **Playbook Syntax Errors**
   ```bash
   # Check playbook syntax
   ansible-playbook main.yml --syntax-check
   
   # Validate variable files
   ansible-playbook main.yml --check
   ```

2. **Connection Issues**
   ```bash
   # Test SSH connectivity
   ansible all -m ping
   
   # Check SSH configuration
   ansible all -m shell -a "cat /etc/ssh/sshd_config"
   
   # Verify SSH keys
   ansible all -m shell -a "ls -la ~/.ssh/"
   ```

3. **Permission Issues**
   ```bash
   # Check file permissions
   ansible all -m shell -a "ls -la /etc/ansible/"
   
   # Verify sudo access
   ansible all -m shell -a "sudo -l"
   ```

### Proxmox Issues

1. **API Connection Issues**
   ```bash
   # Test Proxmox API connection
   curl -k -s https://proxmox:8006/api2/json/cluster/status \
     -H "Authorization: PVEAPIToken=root@pam!tokenid=tokensecret"
   
   # Check API token validity
   pveum token list
   ```

2. **Resource Allocation Issues**
   ```bash
   # Check available resources
   pvesh get /cluster/resources
   
   # Verify storage space
   pvesh get /storage
   ```

3. **VM Deployment Issues**
   ```bash
   # Check VM status
   qm list
   
   # View VM configuration
   qm config <vmid>
   
   # Check VM logs
   tail -f /var/log/pve/tasks/<vmid>.log
   ```

### Docker Issues

1. **Container Startup Issues**
   ```bash
   # Check container status
   docker ps -a
   
   # View container logs
   docker logs <container_id>
   
   # Check container configuration
   docker inspect <container_id>
   ```

2. **Network Issues**
   ```bash
   # Check Docker network
   docker network ls
   docker network inspect bridge
   
   # Verify port mappings
   docker port <container_id>
   ```

3. **Volume Issues**
   ```bash
   # Check volume status
   docker volume ls
   docker volume inspect <volume_name>
   
   # Verify mount points
   mount | grep docker
   ```

## Debugging Procedures

### System Debugging

1. **Check System Resources**
   ```bash
   # CPU usage
   top -b -n 1
   
   # Memory usage
   free -h
   
   # Disk usage
   df -h
   
   # Network usage
   iftop
   ```

2. **Check System Logs**
   ```bash
   # System logs
   journalctl -xe
   
   # Kernel logs
   dmesg | tail
   
   # Service logs
   systemctl status <service_name>
   ```

3. **Check Network Configuration**
   ```bash
   # Network interfaces
   ip a
   
   # Routing table
   ip route
   
   # DNS configuration
   cat /etc/resolv.conf
   ```

### Service Debugging

1. **Check Service Status**
   ```bash
   # All services
   systemctl list-units --type=service --state=failed
   
   # Specific service
   systemctl status <service_name>
   ```

2. **Check Service Logs**
   ```bash
   # Service logs
   journalctl -u <service_name>
   
   # Application logs
   tail -f /var/log/<service_name>/error.log
   ```

3. **Check Service Configuration**
   ```bash
   # Service configuration
   systemctl cat <service_name>
   
   # Environment variables
   systemctl show <service_name>
   ```

## Log Analysis

### Ansible Logs

1. **Enable Verbose Logging**
   ```bash
   # Run playbook with verbose output
   ansible-playbook main.yml -vvv
   
   # Save output to log file
   ansible-playbook main.yml -vvv > ansible.log 2>&1
   ```

2. **Check Ansible Logs**
   ```bash
   # View Ansible log
   tail -f ansible.log
   
   # Search for errors
   grep -i "error" ansible.log
   ```

### System Logs

1. **Check System Logs**
   ```bash
   # View system log
   journalctl -xe
   
   # View kernel log
   dmesg | tail
   
   # View boot log
   journalctl -b
   ```

2. **Check Application Logs**
   ```bash
   # View application logs
   tail -f /var/log/<application>/error.log
   
   # Search for errors
   grep -i "error" /var/log/<application>/*.log
   ```

## Network Troubleshooting

### Basic Network Checks

1. **Check Network Connectivity**
   ```bash
   # Ping test
   ping -c 4 <host>
   
   # Traceroute
   traceroute <host>
   
   # DNS resolution
   dig <host>
   ```

2. **Check Port Availability**
   ```bash
   # Port scan
   nc -zv <host> <port>
   
   # Check listening ports
   netstat -tulpn
   ```

3. **Check Firewall Rules**
   ```bash
   # View iptables rules
   iptables -L -n -v
   
   # Check UFW status
   ufw status
   ```

### Advanced Network Debugging

1. **Packet Capture**
   ```bash
   # Capture packets
   tcpdump -i any -w capture.pcap
   
   # Analyze packets
   tcpdump -r capture.pcap -n
   ```

2. **Network Performance**
   ```bash
   # Bandwidth test
   iperf3 -c <server>
   
   # Network quality
   mtr <host>
   ```

## Service-Specific Issues

### Traefik Issues

1. **Check Traefik Status**
   ```bash
   # View Traefik status
   curl -k https://traefik.your-domain.com/api/rawdata
   
   # Check Traefik logs
   docker logs traefik
   ```

2. **Common Traefik Issues**
   - SSL certificate issues
   - Routing configuration problems
   - Middleware configuration errors

### Monitoring Stack Issues

1. **Prometheus Issues**
   ```bash
   # Check Prometheus status
   curl -k https://prometheus.your-domain.com/api/v1/status/config
   
   # Check target status
   curl -k https://prometheus.your-domain.com/api/v1/targets
   ```

2. **Grafana Issues**
   ```bash
   # Check Grafana status
   curl -k https://grafana.your-domain.com/api/health
   
   # Check dashboard status
   curl -k https://grafana.your-domain.com/api/dashboards
   ```

### Security Services Issues

1. **CrowdSec Issues**
   ```bash
   # Check CrowdSec status
   systemctl status crowdsec
   
   # View decisions
   curl -k https://crowdsec.your-domain.com/v1/decisions
   ```

2. **Vault Issues**
   ```bash
   # Check Vault status
   curl -k https://vault.your-domain.com/v1/sys/health
   
   # Check Vault logs
   journalctl -u vault
   ```

## Recovery Procedures

### System Recovery

1. **Restore from Backup**
   ```bash
   # Restore VM
   ansible-playbook main.yml --tags proxmox -e "vm_restore=true"
   
   # Restore service
   ansible-playbook main.yml --tags "{{ service_name }}" -e "restore=true"
   ```

2. **Reset Configuration**
   ```bash
   # Reset service configuration
   ansible-playbook main.yml --tags "{{ service_name }}" -e "reset=true"
   
   # Reset system configuration
   ansible-playbook main.yml --tags reset
   ```

### Data Recovery

1. **Restore Data**
   ```bash
   # Restore from backup
   ansible-playbook main.yml --tags backup -e "restore=true"
   
   # Verify data integrity
   ansible-playbook main.yml --tags backup -e "verify=true"
   ```

2. **Data Migration**
   ```bash
   # Migrate data
   ansible-playbook main.yml --tags migrate
   
   # Verify migration
   ansible-playbook main.yml --tags migrate -e "verify=true"
   ```

## Getting Help

If you encounter issues not covered in this guide:

1. Check the [GitHub Issues](https://github.com/yourusername/ansible_homelab/issues) page
2. Search the [Discussions](https://github.com/yourusername/ansible_homelab/discussions) forum
3. Join our [Discord Server](https://discord.gg/your-server) for real-time support
4. Submit a new issue with:
   - Detailed error message
   - Relevant logs
   - System information
   - Steps to reproduce 