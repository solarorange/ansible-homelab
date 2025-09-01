#!/usr/bin/env python3
"""
Version Manager for Ansible Homelab
Comprehensive version management and fallback system
"""

import os
import sys
import json
import yaml
import subprocess
import argparse
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Any
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class VersionManager:
    """Comprehensive version management for Ansible Homelab"""
    
    def __init__(self, project_root: str = "."):
        self.project_root = Path(project_root)
        self.version_file = self.project_root / "VERSION"
        self.changelog_file = self.project_root / "CHANGELOG.md"
        self.version_history_file = self.project_root / "docs/version_history.json"
        self.backup_dir = self.project_root / "backups/versions"
        
    def get_current_version(self) -> str:
        """Get current project version"""
        try:
            with open(self.version_file, 'r') as f:
                return f.read().strip()
        except FileNotFoundError:
            logger.warning("VERSION file not found, using git describe")
            return self.get_git_version()
    
    def get_git_version(self) -> str:
        """Get version from git tags"""
        try:
            result = subprocess.run(
                ['git', 'describe', '--tags', '--always'],
                capture_output=True, text=True, cwd=self.project_root
            )
            if result.returncode == 0:
                return result.stdout.strip()
            else:
                return "0.0.0-dev"
        except Exception as e:
            logger.error(f"Error getting git version: {e}")
            return "0.0.0-dev"
    
    def get_git_commit_hash(self) -> str:
        """Get current git commit hash"""
        try:
            result = subprocess.run(
                ['git', 'rev-parse', '--short', 'HEAD'],
                capture_output=True, text=True, cwd=self.project_root
            )
            if result.returncode == 0:
                return result.stdout.strip()
            else:
                return "unknown"
        except Exception as e:
            logger.error(f"Error getting git commit: {e}")
            return "unknown"
    
    def get_service_versions(self) -> Dict[str, str]:
        """Get versions of all services"""
        versions = {}
        
        # Scan roles directory for version files
        roles_dir = self.project_root / "roles"
        if roles_dir.exists():
            for role_dir in roles_dir.iterdir():
                if role_dir.is_dir():
                    defaults_file = role_dir / "defaults" / "main.yml"
                    if defaults_file.exists():
                        try:
                            with open(defaults_file, 'r') as f:
                                content = yaml.safe_load(f)
                                if content and isinstance(content, dict):
                                    for key, value in content.items():
                                        if key.endswith('_version'):
                                            service_name = key.replace('_version', '')
                                            versions[service_name] = str(value)
                        except Exception as e:
                            logger.warning(f"Error reading {defaults_file}: {e}")
        
        return versions
    
    def create_version_backup(self, version: str) -> str:
        """Create a backup of current state for version"""
        backup_path = self.backup_dir / f"v{version}_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        backup_path.mkdir(parents=True, exist_ok=True)
        
        # Backup critical files
        critical_files = [
            "main.yml", "site.yml", "ansible.cfg", "requirements.yml",
            "group_vars/all/vars.yml", "group_vars/all/vault.yml",
            "inventory.yml", "VERSION"
        ]
        
        for file_path in critical_files:
            src = self.project_root / file_path
            if src.exists():
                dst = backup_path / file_path
                dst.parent.mkdir(parents=True, exist_ok=True)
                try:
                    import shutil
                    shutil.copy2(src, dst)
                    logger.info(f"Backed up {file_path}")
                except Exception as e:
                    logger.error(f"Error backing up {file_path}: {e}")
        
        # Backup service versions
        service_versions = self.get_service_versions()
        with open(backup_path / "service_versions.json", 'w') as f:
            json.dump(service_versions, f, indent=2)
        
        # Create backup metadata
        metadata = {
            "version": version,
            "timestamp": datetime.now().isoformat(),
            "git_commit": self.get_git_commit_hash(),
            "git_version": self.get_git_version(),
            "backup_path": str(backup_path)
        }
        
        with open(backup_path / "backup_metadata.json", 'w') as f:
            json.dump(metadata, f, indent=2)
        
        logger.info(f"Version backup created at: {backup_path}")
        return str(backup_path)
    
    def list_version_backups(self) -> List[Dict[str, Any]]:
        """List all available version backups"""
        backups = []
        
        if self.backup_dir.exists():
            for backup_dir in self.backup_dir.iterdir():
                if backup_dir.is_dir():
                    metadata_file = backup_dir / "backup_metadata.json"
                    if metadata_file.exists():
                        try:
                            with open(metadata_file, 'r') as f:
                                metadata = json.load(f)
                                backups.append(metadata)
                        except Exception as e:
                            logger.warning(f"Error reading metadata for {backup_dir}: {e}")
        
        return sorted(backups, key=lambda x: x.get('timestamp', ''), reverse=True)
    
    def restore_version_backup(self, backup_path: str) -> bool:
        """Restore from a version backup"""
        backup_dir = Path(backup_path)
        
        if not backup_dir.exists():
            logger.error(f"Backup directory not found: {backup_path}")
            return False
        
        metadata_file = backup_dir / "backup_metadata.json"
        if not metadata_file.exists():
            logger.error(f"Backup metadata not found: {metadata_file}")
            return False
        
        try:
            with open(metadata_file, 'r') as f:
                metadata = json.load(f)
            
            logger.info(f"Restoring version {metadata.get('version')} from {metadata.get('timestamp')}")
            
            # Restore critical files
            for file_path in backup_dir.rglob("*"):
                if file_path.is_file() and file_path.name not in ["backup_metadata.json", "service_versions.json"]:
                    relative_path = file_path.relative_to(backup_dir)
                    target_path = self.project_root / relative_path
                    
                    target_path.parent.mkdir(parents=True, exist_ok=True)
                    import shutil
                    shutil.copy2(file_path, target_path)
                    logger.info(f"Restored {relative_path}")
            
            logger.info("Version restore completed successfully")
            return True
            
        except Exception as e:
            logger.error(f"Error during restore: {e}")
            return False
    
    def create_git_tag(self, version: str, message: str = None) -> bool:
        """Create a git tag for the current version"""
        try:
            # Add all changes
            subprocess.run(['git', 'add', '.'], cwd=self.project_root, check=True)
            
            # Commit if there are changes
            result = subprocess.run(['git', 'status', '--porcelain'], capture_output=True, text=True, cwd=self.project_root)
            if result.stdout.strip():
                commit_msg = message or f"Release version {version}"
                subprocess.run(['git', 'commit', '-m', commit_msg], cwd=self.project_root, check=True)
            
            # Create tag
            tag_message = message or f"Release version {version}"
            subprocess.run(['git', 'tag', '-a', f'v{version}', '-m', tag_message], cwd=self.project_root, check=True)
            
            logger.info(f"Git tag v{version} created successfully")
            return True
            
        except subprocess.CalledProcessError as e:
            logger.error(f"Error creating git tag: {e}")
            return False
    
    def bump_version(self, bump_type: str = "patch") -> str:
        """Bump version number"""
        current_version = self.get_current_version()
        
        # Parse current version
        parts = current_version.split('.')
        if len(parts) != 3:
            logger.error(f"Invalid version format: {current_version}")
            return current_version
        
        major, minor, patch = int(parts[0]), int(parts[1]), int(parts[2])
        
        # Bump version
        if bump_type == "major":
            major += 1
            minor = 0
            patch = 0
        elif bump_type == "minor":
            minor += 1
            patch = 0
        elif bump_type == "patch":
            patch += 1
        else:
            logger.error(f"Invalid bump type: {bump_type}")
            return current_version
        
        new_version = f"{major}.{minor}.{patch}"
        
        # Update version file
        with open(self.version_file, 'w') as f:
            f.write(new_version + '\n')
        
        logger.info(f"Version bumped from {current_version} to {new_version}")
        return new_version
    
    def generate_version_report(self) -> Dict[str, Any]:
        """Generate comprehensive version report"""
        return {
            "project_version": self.get_current_version(),
            "git_version": self.get_git_version(),
            "git_commit": self.get_git_commit_hash(),
            "service_versions": self.get_service_versions(),
            "available_backups": len(self.list_version_backups()),
            "timestamp": datetime.now().isoformat()
        }
    
    def print_version_info(self):
        """Print current version information"""
        report = self.generate_version_report()
        
        print("=" * 60)
        print("🎯 ANSIBLE HOMELAB VERSION INFORMATION")
        print("=" * 60)
        print(f"📦 Project Version: {report['project_version']}")
        print(f"🔗 Git Version: {report['git_version']}")
        print(f"📝 Git Commit: {report['git_commit']}")
        print(f"💾 Available Backups: {report['available_backups']}")
        print(f"⏰ Report Time: {report['timestamp']}")
        print()
        
        if report['service_versions']:
            print("🔧 Service Versions:")
            for service, version in sorted(report['service_versions'].items()):
                print(f"  • {service}: {version}")
        print("=" * 60)

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="Ansible Homelab Version Manager")
    parser.add_argument("command", choices=[
        "info", "backup", "restore", "bump", "tag", "list-backups", "report"
    ], help="Command to execute")
    parser.add_argument("--version", help="Version for backup/restore operations")
    parser.add_argument("--bump-type", choices=["major", "minor", "patch"], 
                       default="patch", help="Version bump type")
    parser.add_argument("--message", help="Git tag message")
    parser.add_argument("--backup-path", help="Backup path for restore")
    
    args = parser.parse_args()
    
    vm = VersionManager()
    
    if args.command == "info":
        vm.print_version_info()
    
    elif args.command == "backup":
        if not args.version:
            args.version = vm.get_current_version()
        backup_path = vm.create_version_backup(args.version)
        print(f"✅ Version backup created: {backup_path}")
    
    elif args.command == "restore":
        if not args.backup_path:
            print("❌ Error: --backup-path required for restore")
            sys.exit(1)
        success = vm.restore_version_backup(args.backup_path)
        if success:
            print("✅ Version restore completed successfully")
        else:
            print("❌ Version restore failed")
            sys.exit(1)
    
    elif args.command == "bump":
        new_version = vm.bump_version(args.bump_type)
        print(f"✅ Version bumped to: {new_version}")
    
    elif args.command == "tag":
        version = vm.get_current_version()
        success = vm.create_git_tag(version, args.message)
        if success:
            print(f"✅ Git tag v{version} created successfully")
        else:
            print("❌ Git tag creation failed")
            sys.exit(1)
    
    elif args.command == "list-backups":
        backups = vm.list_version_backups()
        if backups:
            print("📦 Available Version Backups:")
            for backup in backups:
                print(f"  • {backup['backup_path']} (v{backup['version']}) - {backup['timestamp']}")
        else:
            print("📦 No version backups found")
    
    elif args.command == "report":
        report = vm.generate_version_report()
        print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main() 