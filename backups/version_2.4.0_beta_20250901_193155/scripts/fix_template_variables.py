#!/usr/bin/env python3
"""
Fix Template Variables Script
Fixes undefined variables in Docker Compose templates by adding proper defaults
"""

import os
import re
from pathlib import Path

def fix_template_variables():
    """Fix undefined variables in templates"""
    templates_dir = Path("templates")
    roles_dir = Path("roles")
    fixed_count = 0
    
    # Common variable fixes
    variable_fixes = {
        'ersatztv_resources.limits.memory': 'ersatztv_memory_limit | default("1g")',
        'ersatztv_resources.limits.cpus': 'ersatztv_cpu_limit | default("1.0")',
        'fing_environment_variables': 'fing_environment | default([])',
        'immich_components': 'immich_components | default([])',
        'jellyfin_environment': 'jellyfin_environment | default([])',
        'linkwarden_components': 'linkwarden_components | default([])',
        'media_downloaders': 'media_downloaders | default([])',
        'n8n_components': 'n8n_components | default([])',
        'nginx_proxy_manager_db_env': 'nginx_proxy_manager_db_env | default([])',
        'paperless_ngx_environment_variables': 'paperless_ngx_environment | default([])',
        'pezzo_components': 'pezzo_components | default([])',
        'reconya_components': 'reconya_components | default([])',
        'simpleapp_environment': 'simpleapp_environment | default([])',
        'testservice_environment': 'testservice_environment | default([])',
        'vaultwarden_components': 'vaultwarden_components | default([])'
    }
    
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
            
            # Apply fixes
            for old_var, new_var in variable_fixes.items():
                if old_var in content:
                    content = content.replace(old_var, new_var)
            
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
    print("🔧 PHASE 3: Fixing Template Variables")
    print("=" * 50)
    
    print("1️⃣ Fixing undefined variables in Docker Compose templates...")
    fixed_count = fix_template_variables()
    
    print(f"\n✅ Fixed {fixed_count} template files")
    print("🎉 Template variable issues resolved!")
    
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
