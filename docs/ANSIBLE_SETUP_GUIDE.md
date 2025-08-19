# Ansible Setup Guide for HomelabOS

This guide covers the complete installation and configuration of Ansible and all necessary plugins for managing your HomelabOS service stack.

## 🚀 Quick Start

### Prerequisites
- Python 3.9+ installed
- pip3 available
- SSH access to target servers

### Installation

1. **Install Ansible Core:**
   ```bash
   pip3 install ansible
   ```

2. **Install Python Dependencies:**
   ```bash
   pip3 install docker kubernetes openshift jmespath netaddr dnspython \
     pymongo psycopg2-binary mysql-connector-python prometheus-client \
     influxdb-client elasticsearch requests-kerberos ldap3 paramiko \
     boto3 hvac passlib bcrypt cryptography
   ```

3. **Install Ansible Collections:**
   ```bash
   export PATH="$HOME/Library/Python/3.9/bin:$PATH"
   ansible-galaxy collection install community.docker
   ansible-galaxy collection install kubernetes.core
   ansible-galaxy collection install ansible.posix
   ansible-galaxy collection install ansible.utils
   ansible-galaxy collection install community.general
   ansible-galaxy collection install community.crypto
   ansible-galaxy collection install community.mysql
   ansible-galaxy collection install community.postgresql
   ansible-galaxy collection install community.aws
   ansible-galaxy collection install community.grafana
   ```

4. **Verify Installation:**
   ```bash
   ./scripts/verify_ansible_setup.sh
   ```

## 📦 Installed Components

### Core Ansible
- **Version:** 2.15.13
- **Location:** `~/Library/Python/3.9/bin/ansible`
- **Configuration:** `ansible.cfg`

### Python Dependencies
| Module | Purpose | Version |
|--------|---------|---------|
| `docker` | Docker container management | 7.1.0 |
| `kubernetes` | Kubernetes cluster management | 33.1.0 |
| `jmespath` | JSON query language | 1.0.1 |
| `netaddr` | Network address manipulation | 1.3.0 |
| `dnspython` | DNS toolkit | 2.7.0 |
| `pymongo` | MongoDB driver | 4.14.0 |
| `psycopg2` | PostgreSQL adapter | 2.9.9 |
| `mysql-connector-python` | MySQL connector | 9.4.0 |
| `prometheus_client` | Prometheus metrics | 0.22.1 |
| `influxdb_client` | InfluxDB client | 1.49.0 |
| `elasticsearch` | Elasticsearch client | 9.1.0 |
| `ldap3` | LDAP client | 2.9.1 |
| `paramiko` | SSH protocol | 4.0.0 |
| `boto3` | AWS SDK | 1.40.6 |
| `hvac` | HashiCorp Vault client | 2.3.0 |
| `passlib` | Password hashing | 1.7.4 |
| `bcrypt` | Password hashing | 4.3.0 |
| `cryptography` | Cryptographic recipes | 45.0.4 |

### Ansible Collections
| Collection | Purpose | Version |
|------------|---------|---------|
| `community.docker` | Docker container management | 3.4.11 |
| `kubernetes.core` | Kubernetes management | 2.4.0 |
| `ansible.posix` | POSIX system management | 1.5.4 |
| `ansible.utils` | Utility modules | 2.12.0 |
| `community.general` | General purpose modules | 7.5.2 |
| `community.crypto` | Cryptographic operations | 2.16.1 |
| `community.mysql` | MySQL database management | 3.8.0 |
| `community.postgresql` | PostgreSQL management | 2.4.3 |
| `community.aws` | AWS cloud management | 6.4.0 |
| `community.grafana` | Grafana monitoring | 1.6.1 |

## 🔧 Configuration

### Ansible Configuration (`ansible.cfg`)
The configuration file includes:
- **Performance optimizations:** Parallel execution, fact caching
- **Security settings:** SSH key management, privilege escalation controls
- **Output formatting:** YAML callback, colorized output
- **Module defaults:** Docker, file, and service defaults

### Key Settings
```ini
[defaults]
inventory = inventory
remote_user = homelab
private_key_file = ~/.ssh/homelab_key
forks = 20
gathering = smart
fact_caching = jsonfile

[privilege_escalation]
become = False
become_method = sudo
become_ask_pass = True
```

## 🎯 Service Stack Support

### Container Management
- **Docker:** Container deployment, networking, volumes
- **Kubernetes:** Cluster management, deployments, services
- **Podman:** Alternative container runtime

### Database Management
- **MySQL:** Database creation, user management, replication
- **PostgreSQL:** Database setup, extensions, backup/restore
- **MongoDB:** Document database management
- **Redis:** In-memory data store

### Monitoring & Observability
- **Prometheus:** Metrics collection and alerting
- **Grafana:** Visualization and dashboards
- **InfluxDB:** Time-series database
- **Elasticsearch:** Log aggregation and search

### Security & Authentication
- **LDAP:** Directory services integration
- **Kerberos:** Enterprise authentication
- **Vault:** Secret management
- **SSL/TLS:** Certificate management

### Network & Infrastructure
- **AWS:** Cloud resource management
- **Nginx:** Web server and reverse proxy
- **DNS:** Domain name resolution
- **Firewall:** Network security

## 🚀 Usage Examples

### Test Connectivity
```bash
# Test all hosts
ansible all -m ping

# Test specific group
ansible webservers -m ping

# Test with verbose output
ansible all -m ping -v
```

### Gather System Facts
```bash
# Gather facts from all hosts
ansible all -m setup

# Save facts to file
ansible all -m setup --tree /tmp/facts
```

### Run Playbooks
```bash
# Run playbook
ansible-playbook playbooks/deploy.yml

# Run with extra variables
ansible-playbook playbooks/deploy.yml -e "version=2.0.0"

# Run in check mode
ansible-playbook playbooks/deploy.yml --check

# Run with verbose output
ansible-playbook playbooks/deploy.yml -v
```

### Docker Operations
```bash
# Deploy container
ansible-playbook playbooks/docker.yml -e "image=nginx:latest"

# Manage Docker networks
ansible-playbook playbooks/docker_network.yml

# Backup containers
ansible-playbook playbooks/docker_backup.yml
```

### Database Operations
```bash
# Setup MySQL database
ansible-playbook playbooks/mysql_setup.yml

# PostgreSQL backup
ansible-playbook playbooks/postgresql_backup.yml

# MongoDB replication
ansible-playbook playbooks/mongodb_replica.yml
```

## 🔍 Troubleshooting

### Common Issues

1. **SSH Connection Issues**
   ```bash
   # Test SSH manually
   ssh -i ~/.ssh/homelab_key homelab@your-server
   
   # Check SSH configuration
   ansible all -m ping -vvv
   ```

2. **Python Module Errors**
   ```bash
   # Reinstall specific module
   pip3 install --force-reinstall module_name
   
   # Check module availability
   python3 -c "import module_name"
   ```

3. **Collection Installation Issues**
   ```bash
   # Clear collection cache
   rm -rf ~/.ansible/collections
   
   # Reinstall collections
   ansible-galaxy collection install collection_name --force
   ```

4. **Permission Issues**
   ```bash
   # Fix SSH key permissions
   chmod 600 ~/.ssh/homelab_key
   
   # Check sudo access
   ansible all -m shell -a "whoami" --become
   ```

### Debug Commands
```bash
# Enable debug mode
export ANSIBLE_DEBUG=1

# Verbose output
ansible-playbook playbook.yml -vvvv

# Check syntax
ansible-playbook playbook.yml --syntax-check

# List tasks
ansible-playbook playbook.yml --list-tasks
```

## 📚 Additional Resources

### Documentation
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Collection Documentation](https://docs.ansible.com/ansible/latest/collections/)

### Useful Commands
```bash
# List all modules
ansible-doc -l

# Get module documentation
ansible-doc module_name

# List collections
ansible-galaxy collection list

# Search collections
ansible-galaxy collection search docker
```

### Best Practices
1. **Use version control** for all playbooks and configurations
2. **Test in staging** before production deployment
3. **Use vault** for sensitive information
4. **Implement idempotency** in all tasks
5. **Monitor execution** with proper logging
6. **Backup configurations** regularly

## 🎉 Next Steps

1. **Configure Inventory:** Set up your server inventory
2. **Setup SSH Keys:** Generate and distribute SSH keys
3. **Test Connectivity:** Verify all hosts are reachable
4. **Create Playbooks:** Start with simple deployment playbooks
5. **Implement CI/CD:** Integrate with your deployment pipeline

For more advanced configurations and customizations, refer to the individual service documentation in the `docs/` directory.
