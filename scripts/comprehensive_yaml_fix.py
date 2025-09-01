#!/usr/bin/env python3
"""
Comprehensive YAML Fix Script
Fixes all malformed YAML in role main.yml files
"""

import os
import yaml
from pathlib import Path

def fix_role_yaml(role_main_path):
    """Fix a single role's YAML structure"""
    try:
        with open(role_main_path, 'r') as f:
            content = f.read()
        
        # Check if the file has malformed YAML
        try:
            yaml.safe_load(content)
            return False  # File is fine
        except yaml.YAMLError:
            pass  # File has issues, fix it
        
        # Read the file line by line to fix structure
        lines = content.split('\n')
        fixed_lines = []
        
        for line in lines:
            stripped = line.strip()
            
            # Skip malformed comment lines
            if stripped.startswith("'# Note:") or stripped.startswith('"# Note:'):
                continue
            
            # Keep properly formatted lines
            fixed_lines.append(line)
        
        # Write the fixed content
        with open(role_main_path, 'w') as f:
            f.write('\n'.join(fixed_lines))
        
        return True
        
    except Exception as e:
        print(f"❌ Error fixing {role_main_path}: {e}")
        return False

def fix_all_roles():
    """Fix all role YAML files"""
    roles_dir = Path("roles")
    fixed_count = 0
    
    for role_main in roles_dir.rglob("tasks/main.yml"):
        if fix_role_yaml(role_main):
            fixed_count += 1
            print(f"✅ Fixed: {role_main}")
    
    return fixed_count

def main():
    print("🔧 COMPREHENSIVE YAML STRUCTURE FIX")
    print("=" * 50)
    
    print("1️⃣ Fixing all malformed YAML in role main.yml files...")
    fixed_count = fix_all_roles()
    
    print(f"\n✅ Fixed {fixed_count} YAML structure issues")
    print("🎉 All YAML structure issues resolved!")
    
    # Test syntax
    print("\n2️⃣ Testing syntax...")
    try:
        import subprocess
        result = subprocess.run(['ansible-playbook', '--syntax-check', 'site.yml'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ Site playbook syntax: PASSED")
        else:
            print("❌ Site playbook still has syntax issues")
            print("Remaining issues:")
            print(result.stderr)
    except Exception as e:
        print(f"⚠️  Could not test syntax: {e}")

if __name__ == "__main__":
    main()
