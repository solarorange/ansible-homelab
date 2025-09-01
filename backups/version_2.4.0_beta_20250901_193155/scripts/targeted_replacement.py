#!/usr/bin/env python3
"""
Targeted Replacement Script
Addresses remaining hardcoded values identified in validation
"""

import os
import re
import json
from pathlib import Path
from typing import Dict, List, Tuple

class TargetedReplacement:
    def __init__(self, root_dir: str = "."):
        self.root_dir = Path(root_dir)
        
        # Define targeted replacements for remaining issues
        self.targeted_replacements = {
            # admin@ references - replace with dynamic email
            r'{{ admin_email | default("admin@" + domain) }} ansible_default_ipv4.address }}': '{{ admin_email | default("admin@" + domain) }}',
            r'{{ admin_email | default("admin@" + domain) }} '{{ admin_email | default("admin@" + domain) }}',
            r'{{ admin_email | default("admin@" + domain) }} '{{ admin_email | default("admin@" + domain) }}',
            
            # {{ ansible_default_ipv4.address }} references - replace with dynamic IP
            r'127\.0\.0\.1': '{{ ansible_default_ipv4.address }}',
            
            # {{ ansible_default_ipv4.address }} in health checks - make configurable
            r'{{ ansible_default_ipv4.address }}:(\d+)': '{{ ansible_default_ipv4.address }}:\1',
            
            # Specific service references
            r'http://{{ ansible_default_ipv4.address }}:': 'http://{{ ansible_default_ipv4.address }}:',
            r'https://{{ ansible_default_ipv4.address }}:': 'https://{{ ansible_default_ipv4.address }}:',
        }
        
        # Files to skip
        self.skip_files = [
            'vault.yml',
            'vault_template.yml',
            'security_hardening_results.json',
            'systematic_replacement_results.json'
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
            
            for pattern, replacement in self.targeted_replacements.items():
                matches = len(re.findall(pattern, content, re.IGNORECASE))
                if matches > 0:
                    content = re.sub(pattern, replacement, content, flags=re.IGNORECASE)
                    replacements_made[pattern] = matches
            
            # Write back if changes were made
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return replacements_made
            
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
        
        return {}
    
    def run_targeted_replacement(self):
        """Run targeted replacement for remaining issues"""
        print("🎯 Starting Targeted Replacement")
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
        
        # Process all template files
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
        
        print(f"\n📊 Targeted Replacement Summary:")
        print(f"   - Files processed: {files_processed}")
        print(f"   - Files modified: {files_modified}")
        print(f"   - Total replacements: {total_replacements}")
        
        return {
            'files_processed': files_processed,
            'files_modified': files_modified,
            'total_replacements': total_replacements
        }
    
    def create_enhanced_validation_script(self):
        """Create an enhanced validation script with better reporting"""
        validation_script = '''#!/usr/bin/env python3
"""
Enhanced Validation Script for Hardcoded Values
Provides detailed reporting on remaining hardcoded values
"""

import re
import os
from pathlib import Path
from typing import Dict, List

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
    acceptable_files = []
    
    for yaml_file in root_dir.rglob("*.yml"):
        if "vault.yml" in str(yaml_file) or "vault_template.yml" in str(yaml_file):
            continue
            
        try:
            with open(yaml_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            file_issues = {}
            for pattern_name, pattern in patterns.items():
                matches = re.findall(pattern, content, re.IGNORECASE)
                if matches:
                    file_issues[pattern_name] = len(matches)
            
            if file_issues:
                # Check if these are acceptable (like vault template files)
                if "vault_template" in str(yaml_file) or "secret_rotation" in str(yaml_file):
                    acceptable_files.append({
                        'file': str(yaml_file),
                        'issues': file_issues,
                        'reason': 'Expected in template/rotation files'
                    })
                else:
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
        
        if acceptable_files:
            print("\n✅ Acceptable hardcoded values (expected):")
            for file_info in acceptable_files:
                print(f"   - {file_info['file']}: {file_info['reason']}")
        
        return False
    else:
        print("✅ No hardcoded values found!")
        return True

if __name__ == "__main__":
    validate_no_hardcoded_values()
'''
        
        validation_path = self.root_dir / "scripts" / "enhanced_validate_hardcoded.py"
        with open(validation_path, 'w') as f:
            f.write(validation_script)
        
        os.chmod(validation_path, 0o755)
        print(f"   Created enhanced validation script: {validation_path}")

def main():
    """Main function"""
    replacement = TargetedReplacement()
    results = replacement.run_targeted_replacement()
    
    # Create enhanced validation script
    replacement.create_enhanced_validation_script()
    
    # Save results
    with open("targeted_replacement_results.json", "w") as f:
        json.dump(results, f, indent=2)
    
    print(f"\n📊 Results saved to: targeted_replacement_results.json")
    print("\nNext steps:")
    print("1. Run enhanced validation: python3 scripts/enhanced_validate_hardcoded.py")
    print("2. Review modified files")
    print("3. Test deployment")
    print("4. Verify security implementation")

if __name__ == "__main__":
    main() 