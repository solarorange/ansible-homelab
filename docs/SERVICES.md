# Homelab Services Documentation

## Important: Risks of Manual Overrides (Ports, Certificates, Service Enablement)

Manual overrides—such as setting ports, certificates, or enabling/disabling services directly via extra-vars, inventory, or ad-hoc variable assignment—can introduce significant risks:
- **Port Conflicts:** Overriding default ports may cause services to fail or expose them unintentionally.
- **Certificate Issues:** Manually specifying certificates can result in expired, invalid, or insecure (self-signed) certificates, breaking HTTPS or exposing you to MITM attacks.
- **Service Enablement:** Enabling or disabling services outside the recommended configuration can break dependencies, monitoring, or security automation.

**Best Practice:**
- Always use `group_vars` or role defaults for configuration.
- Avoid manual overrides unless absolutely necessary and you fully understand the risks.
- Review the [Ansible pre-task warnings](../roles/automation/tasks/main.yml) and confirm you wish to proceed if overrides are detected.

> **Note:** The playbooks now include pre-tasks that detect manual overrides and require explicit user confirmation before proceeding. If you see a warning, review your configuration and only continue if you are certain.

## Core Infrastructure

### Traefik
- **Purpose**: Reverse proxy and load balancer
- **Ports**: 80, 443, 8080
- **Configuration**: `/etc/traefik/traefik.yml`
- **Health Check**: `http://localhost:8080/api/health`
- **Metrics**: `http://localhost:8080/metrics`
- **Documentation**: [Traefik Docs](https://doc.traefik.io/traefik/)

### Docker
- **Purpose**: Container runtime
- **Configuration**: `/etc/docker/daemon.json`
- **Health Check**: `docker info`
- **Logs**: `journalctl -u docker`
- **Documentation**: [Docker Docs](https://docs.docker.com/)

## Monitoring Stack

### Prometheus
- **Purpose**: Metrics collection
- **Port**: 9090
- **Configuration**: `/etc/prometheus/prometheus.yml`
- **Health Check**: `http://localhost:9090/-/healthy`
- **Metrics**: `http://localhost:9090/metrics`
- **Documentation**: [Prometheus Docs](https://prometheus.io/docs/)

### Grafana
- **Purpose**: Metrics visualization
- **Port**: 3000
- **Configuration**: `/etc/grafana/grafana.ini`
- **Health Check**: `http://localhost:3000/api/health`
- **Documentation**: [Grafana Docs](https://grafana.com/docs/)

### Alertmanager
- **Purpose**: Alert routing
- **Port**: 9093
- **Configuration**: `/etc/alertmanager/alertmanager.yml`
- **Health Check**: `http://localhost:9093/-/healthy`
- **Documentation**: [Alertmanager Docs](https://prometheus.io/docs/alerting/latest/alertmanager/)

## Security Services

### CrowdSec
- **Purpose**: Intrusion detection
- **Port**: 8080
- **Configuration**: `/etc/crowdsec/config.yaml`
- **Health Check**: `crowdsec status`
- **Logs**: `journalctl -u crowdsec`
- **Documentation**: [CrowdSec Docs](https://docs.crowdsec.net/)

### Fail2ban
- **Purpose**: Intrusion prevention
- **Configuration**: `/etc/fail2ban/jail.local`
- **Health Check**: `fail2ban-client status`
- **Logs**: `/var/log/fail2ban.log`
- **Documentation**: [Fail2ban Docs](https://www.fail2ban.org/wiki/index.php/Main_Page)

## Media Services

### Jellyfin
- **Purpose**: Media server
- **Port**: 8096
- **Configuration**: `/opt/jellyfin/config`
- **Health Check**: `http://localhost:8096/health`
- **Documentation**: [Jellyfin Docs](https://jellyfin.org/docs/)

### Sonarr
- **Purpose**: TV show management
- **Port**: 8989
- **Configuration**: `/opt/sonarr/config.xml`
- **Health Check**: `http://localhost:8989/health`
- **Documentation**: [Sonarr Docs](https://wiki.servarr.com/sonarr)

### Radarr
- **Purpose**: Movie management
- **Port**: 7878
- **Configuration**: `/opt/radarr/config.xml`
- **Health Check**: `http://localhost:7878/health`
- **Documentation**: [Radarr Docs](https://wiki.servarr.com/radarr)

## File Services

### Nextcloud
- **Purpose**: File sharing
- **Port**: 8080
- **Configuration**: `/var/www/nextcloud/config`
- **Health Check**: `http://localhost:8080/status.php`
- **Documentation**: [Nextcloud Docs](https://docs.nextcloud.com/)

### Samba
- **Purpose**: File sharing
- **Port**: 445
- **Configuration**: `/etc/samba/smb.conf`
- **Health Check**: `smbstatus`
- **Documentation**: [Samba Docs](https://www.samba.org/samba/docs/)

## Development Services

### GitLab
- **Purpose**: Code repository
- **Port**: 80, 443
- **Configuration**: `/etc/gitlab/gitlab.rb`
- **Health Check**: `gitlab-rake gitlab:check`
- **Documentation**: [GitLab Docs](https://docs.gitlab.com/)

### Harbor
- **Purpose**: Container registry
- **Port**: 443
- **Configuration**: `/etc/harbor/harbor.yml`
- **Health Check**: `curl -k https://localhost/api/v2.0/health`
- **Documentation**: [Harbor Docs](https://goharbor.io/docs/)

## Automation Services

### Home Assistant
- **Purpose**: Home automation
- **Port**: 8123
- **Configuration**: `/opt/homeassistant/configuration.yaml`
- **Health Check**: `http://localhost:8123/api/`
- **Documentation**: [Home Assistant Docs](https://www.home-assistant.io/docs/)

### Node-RED
- **Purpose**: Flow-based programming
- **Port**: 1880
- **Configuration**: `/opt/node-red/settings.js`
- **Health Check**: `http://localhost:1880/health`
- **Documentation**: [Node-RED Docs](https://nodered.org/docs/)

## Backup Services

### Kopia
- **Purpose**: Backup solution
- **Configuration**: `/etc/kopia/repository.config`
- **Health Check**: `kopia repository status`
- **Documentation**: [Kopia Docs](https://kopia.io/docs/)

## Service Dependencies

### Required Services
- Docker
- Traefik
- Monitoring Stack

### Optional Services
- Media Stack
- Security Stack
- Automation Stack

## Service Configuration

### Common Settings
- Log levels
- Resource limits
- Network settings
- Security policies

### Service-Specific Settings
- Database configuration
- API keys
- Authentication
- Storage paths

## Service Management

### Starting Services
```bash
ansible-playbook main.yml --tags start --limit service_name
```

### Stopping Services
```bash
ansible-playbook main.yml --tags stop --limit service_name
```

### Updating Services
```bash
ansible-playbook main.yml --tags update --limit service_name
```

### Monitoring Services
```bash
ansible-playbook main.yml --tags monitor --limit service_name
```

## Troubleshooting

### Common Issues
1. Service startup failures
2. Configuration errors
3. Resource constraints
4. Network connectivity

### Debugging Steps
1. Check service logs
2. Verify configuration
3. Test connectivity
4. Monitor resources

### Recovery Procedures
1. Service restart
2. Configuration restore
3. Data recovery
4. System rollback 