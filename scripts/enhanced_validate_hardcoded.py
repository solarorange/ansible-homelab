#!/usr/bin/env python3
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
