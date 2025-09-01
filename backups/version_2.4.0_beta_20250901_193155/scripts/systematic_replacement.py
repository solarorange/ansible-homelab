#!/usr/bin/env python3
"""
Systematic Replacement Script
Methodically replaces hardcoded values with vault variables
"""

import os
import re
import json
from pathlib import Path
from typing import Dict, List, Tuple

class SystematicReplacement:
    def __init__(self, root_dir: str = "."):
        self.root_dir = Path(root_dir)
        
        # Define replacement patterns
        self.replacements = {
            # IP Addresses
            r'{{ ansible_default_ipv4.address }}': '{{ ansible_default_ipv4.address }}',
            r'127\.0\.0\.1': '{{ ansible_default_ipv4.address }}',
            
            # Email addresses
            r'{{ admin_email | default("admin@" + domain) }} ansible_default_ipv4.address }}': '{{ admin_email | default("admin@" + domain) }}',
            r'{{ admin_email | default("admin@" + domain) }} '{{ admin_email | default("admin@" + domain) }}',
            
            # Common passwords
            r'{{ vault_service_secret }}': '{{ vault_admin_password | password_hash("bcrypt") }}',
            r'{{ vault_service_admin_password | password_hash("bcrypt") }}': '{{ vault_admin_password | password_hash("bcrypt") }}',
            r'{{ vault_service_password | password_hash("bcrypt") }}': '{{ vault_admin_password | password_hash("bcrypt") }}',
            r'default_password': '{{ vault_admin_password | password_hash("bcrypt") }}',
            
            # Service-specific patterns
            r'password.*=.*["\']([^"\']+)["\']': 'password: "{{ vault_service_password }}"bcrypt") }}"',
            r'api_key.*=.*["\']([^"\']+)["\']': 'api_key: "{{ vault_{{ service }}_api_token | default("") }}"',
            r'secret_key.*=.*["\']([^"\']+)["\']': 'secret_key: "{{ vault_{{ service }}_secret_key | default("") }}"',
        }
        
        # Files to skip
        self.skip_files = [
            'vault.yml',
            'vault_template.yml',
            'security_hardening_results.json'
        ]
        
    def should_skip_file(self, file_path: str) -> bool:
        """Check if file should be skipped"""
        for skip_pattern in self.skip_files:
            if skip_pattern in file_path:
                return True
        return False
    
    def replace_in_file(self, file_path: str) -> Dict[str, int]:
        """Replace hardcoded values in a single file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            replacements_made = {}
            
            for pattern, replacement in self.replacements.items():
                # Handle service-specific replacements
                if '{{ service }}' in replacement:
                    # Extract service name from file path
                    service_match = re.search(r'roles/([^/]+)/', str(file_path))
                    if service_match:
                        service_name = service_match.group(1)
                        service_replacement = replacement.replace('{{ service }}', service_name)
                        
                        # Count matches
                        matches = len(re.findall(pattern, content, re.IGNORECASE))
                        if matches > 0:
                            content = re.sub(pattern, service_replacement, content, flags=re.IGNORECASE)
                            replacements_made[pattern] = matches
                else:
                    # Regular replacement
                    matches = len(re.findall(pattern, content, re.IGNORECASE))
                    if matches > 0:
                        content = re.sub(pattern, replacement, content, re.IGNORECASE)
                        replacements_made[pattern] = matches
            
            # Write back if changes were made
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return replacements_made
            
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
        
        return {}
    
    def run_systematic_replacement(self):
        """Run systematic replacement across all files"""
        print("🔄 Starting Systematic Replacement")
        print("=" * 40)
        
        total_replacements = 0
        files_processed = 0
        files_modified = 0
        
        # Process all YAML files
        for yaml_file in self.root_dir.rglob("*.yml"):
            if self.should_skip_file(str(yaml_file)):
                continue
            
            files_processed += 1
            replacements = self.replace_in_file(str(yaml_file))
            
            if replacements:
                files_modified += 1
                file_replacements = sum(replacements.values())
                total_replacements += file_replacements
                
                print(f"   Modified: {yaml_file}")
                for pattern, count in replacements.items():
                    print(f"     - {pattern}: {count} replacements")
        
        # Process all YAML files in templates
        for template_file in self.root_dir.rglob("*.j2"):
            if self.should_skip_file(str(template_file)):
                continue
            
            files_processed += 1
            replacements = self.replace_in_file(str(template_file))
            
            if replacements:
                files_modified += 1
                file_replacements = sum(replacements.values())
                total_replacements += file_replacements
                
                print(f"   Modified: {template_file}")
                for pattern, count in replacements.items():
                    print(f"     - {pattern}: {count} replacements")
        
        print(f"\n📊 Replacement Summary:")
        print(f"   - Files processed: {files_processed}")
        print(f"   - Files modified: {files_modified}")
        print(f"   - Total replacements: {total_replacements}")
        
        return {
            'files_processed': files_processed,
            'files_modified': files_modified,
            'total_replacements': total_replacements
        }
    
    def create_validation_script(self):
        """Create a validation script to check for remaining hardcoded values"""
        validation_script = '''#!/usr/bin/env python3
"""
Validation Script for Hardcoded Values
Checks for remaining hardcoded values after replacement
"""

import re
import os
from pathlib import Path

def validate_no_hardcoded_values():
    """Validate that no hardcoded values remain"""
    root_dir = Path(".")
    
    # Patterns to check for
    patterns = {
        'password': r'password.*=.*["\'][^"\']+["\']',
        '{{ ansible_default_ipv4.address }}': r'{{ ansible_default_ipv4.address }}',
        '{{ ansible_default_ipv4.address }}': r'127\.0\.0\.1',
        '{{ admin_email | default("admin@" + domain) }} r'{{ admin_email | default("admin@" + domain) }}"\s]+',
        '{{ vault_service_secret }}': r'{{ vault_service_secret }}',
        '{{ vault_service_admin_password | password_hash("bcrypt") }}': r'{{ vault_service_admin_password | password_hash("bcrypt") }}',
        '{{ vault_service_password | password_hash("bcrypt") }}': r'{{ vault_service_password | password_hash("bcrypt") }}',
    }
    
    issues_found = {}
    
    for yaml_file in root_dir.rglob("*.yml"):
        if "vault.yml" in str(yaml_file):
            continue
            
        try:
            with open(yaml_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            for pattern_name, pattern in patterns.items():
                matches = re.findall(pattern, content, re.IGNORECASE)
                if matches:
                    if pattern_name not in issues_found:
                        issues_found[pattern_name] = []
                    issues_found[pattern_name].append({
                        'file': str(yaml_file),
                        'matches': len(matches)
                    })
                    
        except Exception as e:
            print(f"Error reading {yaml_file}: {e}")
    
    if issues_found:
        print("❌ Hardcoded values found:")
        for pattern_name, files in issues_found.items():
            print(f"   {pattern_name}: {len(files)} files")
            for file_info in files:
                print(f"     - {file_info['file']}: {file_info['matches']} matches")
        return False
    else:
        print("✅ No hardcoded values found!")
        return True

if __name__ == "__main__":
    validate_no_hardcoded_values()
'''
        
        validation_path = self.root_dir / "scripts" / "validate_hardcoded.py"
        with open(validation_path, 'w') as f:
            f.write(validation_script)
        
        os.chmod(validation_path, 0o755)
        print(f"   Created validation script: {validation_path}")

def main():
    """Main function"""
    replacement = SystematicReplacement()
    results = replacement.run_systematic_replacement()
    
    # Create validation script
    replacement.create_validation_script()
    
    # Save results
    with open("systematic_replacement_results.json", "w") as f:
        json.dump(results, f, indent=2)
    
    print(f"\n📊 Results saved to: systematic_replacement_results.json")
    print("\nNext steps:")
    print("1. Run validation script: python3 scripts/validate_hardcoded.py")
    print("2. Review modified files")
    print("3. Test deployment")
    print("4. Verify security implementation")

if __name__ == "__main__":
    main() 