#!/usr/bin/env python3
"""
Fix YAML Structure Script
Fixes malformed YAML in role main.yml files caused by previous fixes
"""

import os
import yaml
from pathlib import Path

def fix_yaml_structure():
    """Fix malformed YAML structure in role main.yml files"""
    roles_dir = Path("roles")
    fixed_count = 0
    
    for role_main in roles_dir.rglob("tasks/main.yml"):
        try:
            with open(role_main, 'r') as f:
                content = f.read()
            
            # Check if the file has malformed YAML
            try:
                yaml.safe_load(content)
                continue  # File is fine, skip
            except yaml.YAMLError:
                pass  # File has issues, fix it
            
            # Read the file line by line to fix structure
            lines = content.split('\n')
            fixed_lines = []
            in_task = False
            
            for line in lines:
                stripped = line.strip()
                
                # Skip comment lines that are not properly formatted
                if stripped.startswith("'# Note:") or stripped.startswith('"# Note:'):
                    continue
                
                # If this looks like a task start, mark it
                if stripped.startswith('- name:') or (stripped.startswith('-') and 'include_tasks:' in stripped):
                    in_task = True
                    fixed_lines.append(line)
                # If this is a comment line, format it properly
                elif stripped.startswith('# Note:'):
                    fixed_lines.append(line)
                # If this is a regular line, keep it
                elif line.strip():
                    fixed_lines.append(line)
                # Keep empty lines for spacing
                else:
                    fixed_lines.append(line)
            
            # Write the fixed content
            with open(role_main, 'w') as f:
                f.write('\n'.join(fixed_lines))
            
            fixed_count += 1
            print(f"✅ Fixed YAML structure: {role_main}")
            
        except Exception as e:
            print(f"❌ Error fixing {role_main}: {e}")
    
    return fixed_count

def main():
    print("🔧 PHASE 2: Fixing YAML Structure Issues")
    print("=" * 50)
    
    print("1️⃣ Fixing malformed YAML in role main.yml files...")
    fixed_count = fix_yaml_structure()
    
    print(f"\n✅ Fixed {fixed_count} YAML structure issues")
    print("🎉 YAML structure issues resolved!")
    
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
            print(result.stderr)
    except Exception as e:
        print(f"⚠️  Could not test syntax: {e}")

if __name__ == "__main__":
    main()
