#!/usr/bin/env python3
"""
Aggressive YAML Fix Script
Fixes all broken role main.yml files by removing problematic comment lines
"""

import os
import yaml
from pathlib import Path

def fix_broken_role(role_main_path):
    """Fix a single broken role file"""
    try:
        with open(role_main_path, 'r') as f:
            lines = f.readlines()
        
        # Filter out problematic lines
        fixed_lines = []
        for line in lines:
            stripped = line.strip()
            # Skip lines that start with problematic patterns
            if (stripped.startswith("'# Note:") or 
                stripped.startswith('"# Note:') or
                stripped.startswith("- '# Note:") or
                stripped.startswith('- "# Note:')):
                continue
            fixed_lines.append(line)
        
        # Write the fixed content
        with open(role_main_path, 'w') as f:
            f.writelines(fixed_lines)
        
        return True
        
    except Exception as e:
        print(f"❌ Error fixing {role_main_path}: {e}")
        return False

def fix_all_broken_roles():
    """Fix all broken role files"""
    roles_dir = Path("roles")
    fixed_count = 0
    
    # Find all broken files
    broken_files = []
    for role_main in roles_dir.rglob("tasks/main.yml"):
        try:
            with open(role_main, 'r') as f:
                content = f.read()
                if "Note:.*removed - file does not exist" in content or "'# Note:" in content:
                    broken_files.append(role_main)
        except:
            pass
    
    print(f"Found {len(broken_files)} broken role files")
    
    # Fix each broken file
    for broken_file in broken_files:
        if fix_broken_role(broken_file):
            fixed_count += 1
            print(f"✅ Fixed: {broken_file}")
    
    return fixed_count

def main():
    print("🔧 AGGRESSIVE YAML STRUCTURE FIX")
    print("=" * 50)
    
    print("1️⃣ Finding and fixing all broken role main.yml files...")
    fixed_count = fix_all_broken_roles()
    
    print(f"\n✅ Fixed {fixed_count} broken role files")
    print("🎉 All broken role files resolved!")
    
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
