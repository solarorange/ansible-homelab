#!/usr/bin/env python3
"""
Healthcheck Standardization Script
Identifies remaining curl-based healthchecks that need to be updated to wget -qO- pattern
"""

import os
import re
import glob
from pathlib import Path

def find_curl_healthchecks():
    """Find all curl-based healthchecks in the codebase"""
    patterns = [
        r'test:\s*\["CMD",\s*"curl"',
        r'test:\s*\["CMD-SHELL",\s*"curl\s+-f',
        r'test:\s*\["CMD",\s*"curl",\s*"-f"',
        r'curl\s+-f\s+http://.*health',
        r'curl\s+-f\s+http://.*api/health',
        r'curl\s+-f\s+http://.*/health',
    ]
    
    files_to_check = []
    
    # Find all relevant files
    for ext in ['*.yml', '*.yaml', '*.j2']:
        files_to_check.extend(glob.glob(f'**/{ext}', recursive=True))
        files_to_check.extend(glob.glob(f'templates/**/{ext}', recursive=True))
        files_to_check.extend(glob.glob(f'roles/**/templates/**/{ext}', recursive=True))
    
    curl_healthchecks = []
    
    for file_path in files_to_check:
        if os.path.isfile(file_path):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                for pattern in patterns:
                    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
                    for match in matches:
                        line_num = content[:match.start()].count('\n') + 1
                        line_content = content.split('\n')[line_num - 1].strip()
                        curl_healthchecks.append({
                            'file': file_path,
                            'line': line_num,
                            'pattern': pattern,
                            'content': line_content
                        })
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
    
    return curl_healthchecks

def find_wget_spider_healthchecks():
    """Find all wget --spider healthchecks that should be updated"""
    patterns = [
        r'test:\s*\["CMD",\s*"wget",\s*"--no-verbose",\s*"--tries=1",\s*"--spider"',
        r'test:\s*\["CMD-SHELL",\s*"wget\s+--no-verbose\s+--tries=1\s+--spider"',
        r'wget\s+--no-verbose\s+--tries=1\s+--spider',
    ]
    
    files_to_check = []
    
    # Find all relevant files
    for ext in ['*.yml', '*.yaml', '*.j2']:
        files_to_check.extend(glob.glob(f'**/{ext}', recursive=True))
        files_to_check.extend(glob.glob(f'templates/**/{ext}', recursive=True))
        files_to_check.extend(glob.glob(f'roles/**/templates/**/{ext}', recursive=True))
    
    wget_spider_healthchecks = []
    
    for file_path in files_to_check:
        if os.path.isfile(file_path):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                for pattern in patterns:
                    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
                    for match in matches:
                        line_num = content[:match.start()].count('\n') + 1
                        line_content = content.split('\n')[line_num - 1].strip()
                        wget_spider_healthchecks.append({
                            'file': file_path,
                            'line': line_num,
                            'pattern': pattern,
                            'content': line_content
                        })
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
    
    return wget_spider_healthchecks

def find_standardized_healthchecks():
    """Find all already standardized wget -qO- healthchecks"""
    patterns = [
        r'test:\s*\["CMD-SHELL",\s*"wget\s+-qO-\s+http://127\.0\.0\.1:',
        r'wget\s+-qO-\s+http://127\.0\.0\.1:',
    ]
    
    files_to_check = []
    
    # Find all relevant files
    for ext in ['*.yml', '*.yaml', '*.j2']:
        files_to_check.extend(glob.glob(f'**/{ext}', recursive=True))
        files_to_check.extend(glob.glob(f'templates/**/{ext}', recursive=True))
        files_to_check.extend(glob.glob(f'roles/**/templates/**/{ext}', recursive=True))
    
    standardized_healthchecks = []
    
    for file_path in files_to_check:
        if os.path.isfile(file_path):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                for pattern in patterns:
                    matches = re.finditer(pattern, content, re.MULTILINE | re.IGNORECASE)
                    for match in matches:
                        line_num = content[:match.start()].count('\n') + 1
                        line_content = content.split('\n')[line_num - 1].strip()
                        standardized_healthchecks.append({
                            'file': file_path,
                            'line': line_num,
                            'pattern': pattern,
                            'content': line_content
                        })
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
    
    return standardized_healthchecks

def main():
    print("🔍 Healthcheck Standardization Analysis")
    print("=" * 50)
    
    # Find curl-based healthchecks
    print("\n📋 Finding curl-based healthchecks...")
    curl_healthchecks = find_curl_healthchecks()
    
    if curl_healthchecks:
        print(f"\n❌ Found {len(curl_healthchecks)} curl-based healthchecks that need updating:")
        for hc in curl_healthchecks:
            print(f"  📄 {hc['file']}:{hc['line']}")
            print(f"     {hc['content']}")
            print()
    else:
        print("✅ No curl-based healthchecks found!")
    
    # Find wget --spider healthchecks
    print("\n📋 Finding wget --spider healthchecks...")
    wget_spider_healthchecks = find_wget_spider_healthchecks()
    
    if wget_spider_healthchecks:
        print(f"\n⚠️  Found {len(wget_spider_healthchecks)} wget --spider healthchecks that should be updated:")
        for hc in wget_spider_healthchecks:
            print(f"  📄 {hc['file']}:{hc['line']}")
            print(f"     {hc['content']}")
            print()
    else:
        print("✅ No wget --spider healthchecks found!")
    
    # Find standardized healthchecks
    print("\n📋 Finding standardized wget -qO- healthchecks...")
    standardized_healthchecks = find_standardized_healthchecks()
    
    if standardized_healthchecks:
        print(f"\n✅ Found {len(standardized_healthchecks)} standardized healthchecks:")
        for hc in standardized_healthchecks:
            print(f"  📄 {hc['file']}:{hc['line']}")
            print(f"     {hc['content']}")
            print()
    
    # Summary
    print("\n📊 Summary:")
    print(f"  • Curl-based healthchecks: {len(curl_healthchecks)}")
    print(f"  • Wget --spider healthchecks: {len(wget_spider_healthchecks)}")
    print(f"  • Standardized healthchecks: {len(standardized_healthchecks)}")
    
    if curl_healthchecks or wget_spider_healthchecks:
        print(f"\n🔄 Total healthchecks needing updates: {len(curl_healthchecks) + len(wget_spider_healthchecks)}")
        print("\n💡 Standard pattern to use:")
        print('   test: ["CMD-SHELL", "wget -qO- http://127.0.0.1:<port>/health || exit 1"]')
    else:
        print("\n🎉 All healthchecks are already standardized!")

if __name__ == "__main__":
    main()
