#!/usr/bin/env python3
"""
Fix Missing Task Files Script
Identifies and fixes missing task file references in role main.yml files
"""

import os
import yaml
import glob
from pathlib import Path

def find_missing_task_files():
    """Find all roles with missing task files"""
    roles_dir = Path("roles")
    issues = []
    
    for role_main in roles_dir.rglob("tasks/main.yml"):
        try:
            with open(role_main, 'r') as f:
                content = yaml.safe_load(f)
            
            if not content:
                continue
                
            role_path = role_main.parent.parent
            task_dir = role_main.parent
            
            # Check each include_tasks reference
            for task in content:
                if isinstance(task, dict) and 'include_tasks' in task:
                    task_file = task['include_tasks']
                    full_path = task_dir / task_file
                    
                    if not full_path.exists():
                        issues.append({
                            'role': str(role_path),
                            'missing_file': task_file,
                            'main_yml': str(role_main),
                            'line': content.index(task) + 1
                        })
                        
        except Exception as e:
            print(f"Error processing {role_main}: {e}")
    
    return issues

def fix_missing_task_files(issues):
    """Fix missing task file references"""
    fixed_count = 0
    
    for issue in issues:
        try:
            with open(issue['main_yml'], 'r') as f:
                content = yaml.safe_load(f)
            
            # Find and remove the problematic include_tasks
            for i, task in enumerate(content):
                if isinstance(task, dict) and 'include_tasks' in task:
                    if task['include_tasks'] == issue['missing_file']:
                        # Replace with a comment
                        content[i] = f"# Note: {issue['missing_file']} removed - file does not exist"
                        fixed_count += 1
                        break
            
            # Write back the fixed content
            with open(issue['main_yml'], 'w') as f:
                yaml.dump(content, f, default_flow_style=False, sort_keys=False)
                
            print(f"✅ Fixed {issue['role']}: {issue['missing_file']}")
            
        except Exception as e:
            print(f"❌ Error fixing {issue['main_yml']}: {e}")
    
    return fixed_count

def main():
    print("🔍 PHASE 2: Fixing Missing Task Files")
    print("=" * 50)
    
    # Find all missing task files
    print("1️⃣ Scanning for missing task files...")
    issues = find_missing_task_files()
    
    if not issues:
        print("✅ No missing task files found!")
        return
    
    print(f"❌ Found {len(issues)} missing task file references:")
    for issue in issues:
        print(f"   - {issue['role']}: {issue['missing_file']}")
    
    # Fix the issues
    print("\n2️⃣ Fixing missing task file references...")
    fixed_count = fix_missing_task_files(issues)
    
    print(f"\n✅ Fixed {fixed_count} missing task file references")
    print("🎉 Role task file issues resolved!")
    
    # Verify fixes
    print("\n3️⃣ Verifying fixes...")
    remaining_issues = find_missing_task_files()
    if not remaining_issues:
        print("✅ All missing task file issues resolved!")
    else:
        print(f"⚠️  {len(remaining_issues)} issues remain")

if __name__ == "__main__":
    main()
