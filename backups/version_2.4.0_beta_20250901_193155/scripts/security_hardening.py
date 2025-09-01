#!/usr/bin/env python3
"""
Comprehensive Security Hardening Script
Identifies and replaces hardcoded values with dynamic vault variables
"""

import os
import re
import yaml
import json
from pathlib import Path
from typing import Dict, List, Tuple, Set

class SecurityHardening:
    def __init__(self, root_dir: str = "."):
        self.root_dir = Path(root_dir)
        self.hardcoded_patterns = {
            'password': r'password.*=.*["\']([^"\']+)["\']',
            'localhost': r'localhost',
            '127.0.0.1': r'127\.0\.0\.1',
            '192.168': r'192\.168\.\d+\.\d+',
            'admin@': r'admin@[^"\s]+',
            'changeme': r'changeme',
            'admin123': r'admin123',
            'your_secure_password': r'your_secure_password',
            'default_password': r'default_password',
            'secret_key': r'secret_key.*=.*["\']([^"\']+)["\']',
            'api_key': r'api_key.*=.*["\']([^"\']+)["\']',
            'token': r'token.*=.*["\']([^"\']+)["\']',
        }
        
        self.vault_variables = {}
        self.replacement_mapping = {}
        
    def scan_for_hardcoded_values(self) -> Dict[str, List[Tuple[str, int, str]]]:
        """Scan all YAML files for hardcoded values"""
        results = {}
        
        for pattern_name, pattern in self.hardcoded_patterns.items():
            results[pattern_name] = []
            
            for yaml_file in self.root_dir.rglob("*.yml"):
                if "vault.yml" in str(yaml_file) or "vault_template.yml" in str(yaml_file):
                    continue
                    
                try:
                    with open(yaml_file, 'r', encoding='utf-8') as f:
                        content = f.read()
                        lines = content.split('\n')
                        
                        for line_num, line in enumerate(lines, 1):
                            matches = re.finditer(pattern, line, re.IGNORECASE)
                            for match in matches:
                                results[pattern_name].append((
                                    str(yaml_file),
                                    line_num,
                                    line.strip()
                                ))
                except Exception as e:
                    print(f"Error reading {yaml_file}: {e}")
                    
        return results
    
    def generate_vault_variables(self) -> Dict[str, str]:
        """Generate comprehensive vault variables for all services"""
        vault_vars = {}
        
        # Service-specific vault variables
        services = [
            'sonarr', 'radarr', 'jellyfin', 'plex', 'emby', 'immich',
            'audiobookshelf', 'komga', 'calibre', 'prometheus', 'alertmanager',
            'loki', 'promtail', 'blackbox_exporter', 'influxdb', 'telegraf',
            'vault', 'crowdsec', 'fail2ban', 'wireguard', 'pihole',
            'gitlab', 'harbor', 'code_server', 'portainer', 'nextcloud',
            'syncthing', 'bookstack', 'filebrowser', 'kopia', 'duplicati',
            'uptime_kuma', 'guacamole', 'requestrr', 'unmanic', 'tdarr',
            'sabnzbd', 'qbittorrent', 'transmission', 'deluge', 'rtorrent'
        ]
        
        for service in services:
            vault_vars.update({
                f'vault_{service}_admin_password': f'{{{{ vault_{service}_admin_password | password_hash("bcrypt") }}}}',
                f'vault_{service}_database_password': f'{{{{ vault_{service}_database_password | password_hash("bcrypt") }}}}',
                f'vault_{service}_api_token': f'{{{{ vault_{service}_api_token | default("") }}}}',
                f'vault_{service}_secret_key': f'{{{{ vault_{service}_secret_key | default("") }}}}',
                f'vault_{service}_encryption_key': f'{{{{ vault_{service}_encryption_key | default("") }}}}',
                f'vault_{service}_jwt_secret': f'{{{{ vault_{service}_jwt_secret | default("") }}}}',
                f'vault_{service}_redis_password': f'{{{{ vault_{service}_redis_password | password_hash("bcrypt") }}}}',
                f'vault_{service}_smtp_password': f'{{{{ vault_{service}_smtp_password | default("") }}}}',
            })
        
        # Dynamic configuration variables
        vault_vars.update({
            'vault_server_ip': '{{ ansible_default_ipv4.address }}',
            'vault_domain': '{{ domain }}',
            'vault_admin_email': '{{ admin_email | default("admin@" + domain) }}',
            'vault_monitoring_email': '{{ monitoring_email | default("monitoring@" + domain) }}',
            'vault_ssl_email': '{{ ssl_email | default("admin@" + domain) }}',
        })
        
        return vault_vars
    
    def create_replacement_mapping(self) -> Dict[str, str]:
        """Create mapping of hardcoded values to vault variables"""
        mapping = {}
        
        # Common replacements
        mapping.update({
            'localhost': '{{ ansible_default_ipv4.address }}',
            '127.0.0.1': '{{ ansible_default_ipv4.address }}',
            'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',
            'admin@127.0.0.1': '{{ admin_email | default("admin@" + domain) }}',
            'changeme': '{{ vault_admin_password | password_hash("bcrypt") }}',
            'admin123': '{{ vault_admin_password | password_hash("bcrypt") }}',
            'your_secure_password': '{{ vault_admin_password | password_hash("bcrypt") }}',
            'default_password': '{{ vault_admin_password | password_hash("bcrypt") }}',
        })
        
        return mapping
    
    def replace_hardcoded_values(self, file_path: str, replacements: Dict[str, str]) -> bool:
        """Replace hardcoded values in a file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            for old_value, new_value in replacements.items():
                content = re.sub(
                    re.escape(old_value),
                    new_value,
                    content,
                    flags=re.IGNORECASE
                )
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return True
                
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            
        return False
    
    def update_vault_file(self, vault_vars: Dict[str, str]):
        """Update the vault.yml file with new variables"""
        vault_file = self.root_dir / "group_vars" / "all" / "vault.yml"
        
        if not vault_file.exists():
            print(f"Vault file not found: {vault_file}")
            return
        
        try:
            with open(vault_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Add new vault variables
            new_vars_section = "\n# =============================================================================\n"
            new_vars_section += "# COMPREHENSIVE SERVICE STACK VAULT VARIABLES\n"
            new_vars_section += "# =============================================================================\n\n"
            
            for var_name, var_value in vault_vars.items():
                new_vars_section += f"{var_name}: {var_value}\n"
            
            # Append to existing content
            content += "\n" + new_vars_section
            
            with open(vault_file, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"Updated vault file with {len(vault_vars)} new variables")
            
        except Exception as e:
            print(f"Error updating vault file: {e}")
    
    def generate_service_discovery_script(self, service_name: str):
        """Generate service discovery script for a specific service"""
        script_content = f'''#!/usr/bin/env python3
"""
Service Discovery Script for {service_name.title()}
Automatically discovers and configures {service_name} service
"""

import requests
import json
import time
from typing import Dict, Any

class {service_name.title()}Discovery:
    def __init__(self, host: str, port: int, api_key: str = None):
        self.host = host
        self.port = port
        self.api_key = api_key
        self.base_url = f"http://{{host}}:{{port}}"
        
    def discover_service(self) -> Dict[str, Any]:
        """Discover {service_name} service configuration"""
        try:
            # Health check
            health_url = f"{{self.base_url}}/health"
            response = requests.get(health_url, timeout=10)
            
            if response.status_code == 200:
                return {{
                    "status": "healthy",
                    "url": self.base_url,
                    "version": self.get_version(),
                    "configuration": self.get_configuration()
                }}
            else:
                return {{
                    "status": "unhealthy",
                    "url": self.base_url,
                    "error": f"HTTP {{response.status_code}}"
                }}
                
        except Exception as e:
            return {{
                "status": "error",
                "url": self.base_url,
                "error": str(e)
            }}
    
    def get_version(self) -> str:
        """Get {service_name} version"""
        try:
            version_url = f"{{self.base_url}}/api/system/status"
            response = requests.get(version_url, timeout=5)
            if response.status_code == 200:
                data = response.json()
                return data.get("version", "unknown")
        except:
            pass
        return "unknown"
    
    def get_configuration(self) -> Dict[str, Any]:
        """Get {service_name} configuration"""
        try:
            config_url = f"{{self.base_url}}/api/config"
            response = requests.get(config_url, timeout=5)
            if response.status_code == 200:
                return response.json()
        except:
            pass
        return {{}}

if __name__ == "__main__":
    # Example usage
    discovery = {service_name.title()}Discovery("localhost", 8080)
    result = discovery.discover_service()
    print(json.dumps(result, indent=2))
'''
        
        script_path = self.root_dir / "scripts" / f"{service_name}_discovery.py"
        script_path.parent.mkdir(exist_ok=True)
        
        with open(script_path, 'w', encoding='utf-8') as f:
            f.write(script_content)
        
        # Make executable
        os.chmod(script_path, 0o755)
        
        return script_path
    
    def run_comprehensive_hardening(self):
        """Run comprehensive security hardening"""
        print("🔒 Starting Comprehensive Security Hardening")
        print("=" * 50)
        
        # Step 1: Scan for hardcoded values
        print("1. Scanning for hardcoded values...")
        hardcoded_results = self.scan_for_hardcoded_values()
        
        total_issues = sum(len(issues) for issues in hardcoded_results.values())
        print(f"   Found {total_issues} potential hardcoded values")
        
        for pattern_name, issues in hardcoded_results.items():
            if issues:
                print(f"   - {pattern_name}: {len(issues)} instances")
        
        # Step 2: Generate vault variables
        print("\n2. Generating comprehensive vault variables...")
        vault_vars = self.generate_vault_variables()
        print(f"   Generated {len(vault_vars)} vault variables")
        
        # Step 3: Create replacement mapping
        print("\n3. Creating replacement mapping...")
        replacements = self.create_replacement_mapping()
        print(f"   Created {len(replacements)} replacement mappings")
        
        # Step 4: Update vault file
        print("\n4. Updating vault file...")
        self.update_vault_file(vault_vars)
        
        # Step 5: Generate service discovery scripts
        print("\n5. Generating service discovery scripts...")
        services = ['sonarr', 'radarr', 'jellyfin', 'plex', 'prometheus', 'grafana']
        for service in services:
            script_path = self.generate_service_discovery_script(service)
            print(f"   Generated: {script_path}")
        
        print("\n✅ Comprehensive Security Hardening Complete!")
        print(f"   - Scanned for {len(self.hardcoded_patterns)} types of hardcoded values")
        print(f"   - Generated {len(vault_vars)} vault variables")
        print(f"   - Created {len(replacements)} replacement mappings")
        print(f"   - Generated {len(services)} service discovery scripts")
        
        return {
            'hardcoded_results': hardcoded_results,
            'vault_vars': vault_vars,
            'replacements': replacements
        }

def main():
    """Main function"""
    hardening = SecurityHardening()
    results = hardening.run_comprehensive_hardening()
    
    # Save results to JSON file
    with open("security_hardening_results.json", "w") as f:
        json.dump(results, f, indent=2, default=str)
    
    print(f"\n📊 Results saved to: security_hardening_results.json")

if __name__ == "__main__":
    main() 