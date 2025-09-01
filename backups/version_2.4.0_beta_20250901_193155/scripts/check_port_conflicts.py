#!/usr/bin/env python3
"""
check_port_conflicts.py
Checks for duplicate host port assignments among all enabled services in the Ansible homelab.
- Scans group_vars, role defaults, and docker-compose templates for port assignments.
- Prints any conflicts and exits with code 1 if found, 0 if all ports are unique.
- Requires: PyYAML (pip install pyyaml)
"""
import os
import sys
import yaml
import re
from collections import defaultdict
from glob import glob

# Helper to load YAML safely

def load_yaml(path):
    with open(path, 'r') as f:
        return yaml.safe_load(f)

# Find all relevant variable files and docker-compose templates

def find_files():
    var_files = glob('group_vars/all/*.yml')
    var_files += glob('roles/*/defaults/main.yml')
    var_files += glob('roles/*/vars/main.yml')
    var_files += glob('inventory.yml')
    compose_templates = glob('roles/*/templates/docker-compose.yml.j2')
    compose_templates += glob('templates/*/docker-compose.yml.j2')
    return var_files, compose_templates

# Extract enabled services from vars

def get_enabled_services(var_files):
    enabled = set()
    for vf in var_files:
        try:
            data = load_yaml(vf)
            if not data:
                continue
            if 'enabled_services' in data:
                enabled.update(data['enabled_services'])
        except Exception:
            continue
    return enabled

# Extract port assignments from variable files

def get_ports_from_vars(var_files, enabled_services):
    service_ports = defaultdict(list)
    for vf in var_files:
        try:
            data = load_yaml(vf)
            if not data:
                continue
            for key, value in data.items():
                # Match keys like <service>_port or <service>_ports
                m = re.match(r'(\w+)_port(s?)$', key)
                if m:
                    service = m.group(1)
                    if service in enabled_services:
                        if isinstance(value, dict):
                            for k, v in value.items():
                                service_ports[service].append(str(v))
                        elif isinstance(value, list):
                            for v in value:
                                service_ports[service].append(str(v))
                        else:
                            service_ports[service].append(str(value))
                # Also check for dicts of services with port fields
                if isinstance(value, dict):
                    for subk, subv in value.items():
                        if subk in enabled_services and isinstance(subv, dict):
                            if 'port' in subv:
                                service_ports[subk].append(str(subv['port']))
                            if 'ports' in subv and isinstance(subv['ports'], list):
                                for v in subv['ports']:
                                    service_ports[subk].append(str(v))
        except Exception:
            continue
    return service_ports

# Extract port assignments from docker-compose templates (simple regex, not full Jinja2 rendering)

def get_ports_from_compose(compose_templates, enabled_services):
    service_ports = defaultdict(list)
    port_pattern = re.compile(r'\s*-\s*"?(\d+):(\d+)(/\w+)?"?')
    service_pattern = re.compile(r'^\s*([\w-]+):\s*$')
    for ct in compose_templates:
        try:
            with open(ct, 'r') as f:
                lines = f.readlines()
            current_service = None
            for line in lines:
                m = service_pattern.match(line)
                if m:
                    current_service = m.group(1)
                if 'ports:' in line:
                    # Next lines may be port mappings
                    idx = lines.index(line)
                    for l in lines[idx+1:idx+10]:
                        pm = port_pattern.search(l)
                        if pm and current_service:
                            host_port = pm.group(1)
                            if current_service in enabled_services:
                                service_ports[current_service].append(host_port)
                        if l.strip() == '' or not l.startswith(' '):
                            break
        except Exception:
            continue
    return service_ports

# Main logic

def main():
    var_files, compose_templates = find_files()
    enabled_services = get_enabled_services(var_files)
    if not enabled_services:
        print('No enabled services found.')
        sys.exit(0)
    ports_from_vars = get_ports_from_vars(var_files, enabled_services)
    ports_from_compose = get_ports_from_compose(compose_templates, enabled_services)
    # Merge
    all_ports = defaultdict(list)
    for svc, ports in ports_from_vars.items():
        for p in ports:
            all_ports[p].append(svc)
    for svc, ports in ports_from_compose.items():
        for p in ports:
            all_ports[p].append(svc)
    # Find conflicts
    conflicts = {p: svcs for p, svcs in all_ports.items() if len(set(svcs)) > 1}
    if conflicts:
        print('Port conflicts detected:')
        for port, svcs in conflicts.items():
            print(f'  Port {port} is used by: {", ".join(set(svcs))}')
        sys.exit(1)
    else:
        print('No port conflicts detected.')
        sys.exit(0)

if __name__ == '__main__':
    main() 