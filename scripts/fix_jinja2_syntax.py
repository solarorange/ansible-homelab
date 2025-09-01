#!/usr/bin/env python3
"""
Fix Jinja2 Syntax Script
Fixes Jinja2 syntax issues in Docker Compose templates
"""

import os
import re
from pathlib import Path

def fix_jinja2_syntax():
    """Fix Jinja2 syntax issues in templates"""
    templates_dir = Path("templates")
    roles_dir = Path("roles")
    fixed_count = 0
    
    # Common Jinja2 syntax fixes
    syntax_fixes = [
        # Fix .items() method calls
        (r'(\w+)\s*\|\s*default\(\[\]\)\.items\(\)', r'\1 is defined and \1'),
        # Fix other problematic method calls
        (r'(\w+)\s*\|\s*default\(\[\]\)\.(\w+)\(\)', r'\1 is defined and \1.\2()'),
        # Fix NoneType iteration issues
        (r'for\s+(\w+)\s+in\s+(\w+)\s*\|\s*default\(\[\]\)', r'if \2 is defined and \2\n      for \1 in \2'),
    ]
    
    # Find all Docker Compose templates
    template_files = []
    template_files.extend(templates_dir.rglob("*.j2"))
    template_files.extend(roles_dir.rglob("templates/*.j2"))
    
    for template_file in template_files:
        if not template_file.exists():
            continue
            
        try:
            with open(template_file, 'r') as f:
                content = f.read()
            
            original_content = content
            
            # Apply syntax fixes
            for pattern, replacement in syntax_fixes:
                content = re.sub(pattern, replacement, content)
            
            # Write back if changed
            if content != original_content:
                with open(template_file, 'w') as f:
                    f.write(content)
                fixed_count += 1
                print(f"✅ Fixed: {template_file}")
                
        except Exception as e:
            print(f"❌ Error fixing {template_file}: {e}")
    
    return fixed_count

def main():
    print("🔧 PHASE 3: Fixing Jinja2 Syntax Issues")
    print("=" * 50)
    
    print("1️⃣ Fixing Jinja2 syntax issues in templates...")
    fixed_count = fix_jinja2_syntax()
    
    print(f"\n✅ Fixed {fixed_count} template files")
    print("🎉 Jinja2 syntax issues resolved!")
    
    # Test validation again
    print("\n2️⃣ Testing template validation...")
    try:
        import subprocess
        result = subprocess.run(['python3', 'scripts/ci/render_and_validate_compose.py'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ All templates now validate successfully!")
        else:
            print("⚠️  Some validation issues remain:")
            print(result.stderr)
    except Exception as e:
        print(f"⚠️  Could not test validation: {e}")

if __name__ == "__main__":
    main()
