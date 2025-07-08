#!/usr/bin/env python3
"""
Backup Manager for Homepage Dashboard

This module provides comprehensive backup and recovery functionality for the
homepage dashboard configuration, data, and logs.
"""

import os
import sys
import json
import yaml
import shutil
import tarfile
import zipfile
import hashlib
import subprocess
from pathlib import Path
from typing import Dict, List, Optional, Any
from datetime import datetime, timedelta
import logging
from logging_config import setup_logging, get_logger, log_execution_time

class BackupManager:
    """Backup and recovery manager for homepage dashboard"""
    
    def __init__(self, config_dir: str = "/app/config", backup_dir: str = "/app/backups"):
        self.config_dir = Path(config_dir)
        self.backup_dir = Path(backup_dir)
        self.log_dir = Path("/var/log/homepage")
        
        # Create backup directory if it doesn't exist
        self.backup_dir.mkdir(parents=True, exist_ok=True)
        
        # Setup logging
        setup_logging()
        self.logger = get_logger(__name__)
        
        # Backup configuration
        self.backup_config = {
            'retention_days': 30,
            'max_backups': 10,
            'compress_backups': True,
            'encrypt_backups': False,
            'backup_logs': True,
            'backup_health_data': True,
            'backup_secrets': True
        }
        
        # Load backup configuration if exists
        self._load_backup_config()
    
    def _load_backup_config(self) -> None:
        """Load backup configuration from file"""
        config_file = self.config_dir / "backup_config.yml"
        if config_file.exists():
            try:
                with open(config_file, 'r') as f:
                    config = yaml.safe_load(f)
                    self.backup_config.update(config)
                self.logger.info("Loaded backup configuration")
            except Exception as e:
                self.logger.error(f"Failed to load backup configuration: {e}")
    
    def _save_backup_config(self) -> None:
        """Save backup configuration to file"""
        config_file = self.config_dir / "backup_config.yml"
        try:
            with open(config_file, 'w') as f:
                yaml.dump(self.backup_config, f, default_flow_style=False)
            self.logger.info("Saved backup configuration")
        except Exception as e:
            self.logger.error(f"Failed to save backup configuration: {e}")
    
    @log_execution_time
    def create_backup(self, backup_name: Optional[str] = None, include_logs: bool = True) -> str:
        """
        Create a comprehensive backup of the homepage dashboard
        
        Args:
            backup_name: Optional custom backup name
            include_logs: Include log files in backup
            
        Returns:
            Path to the created backup file
        """
        if not backup_name:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_name = f"homepage_backup_{timestamp}"
        
        backup_path = self.backup_dir / f"{backup_name}.tar.gz"
        
        try:
            self.logger.info(f"Creating backup: {backup_name}")
            
            # Create temporary directory for backup contents
            temp_dir = self.backup_dir / "temp_backup"
            if temp_dir.exists():
                shutil.rmtree(temp_dir)
            temp_dir.mkdir()
            
            # Backup configuration files
            self._backup_config_files(temp_dir)
            
            # Backup health data if enabled
            if self.backup_config['backup_health_data']:
                self._backup_health_data(temp_dir)
            
            # Backup logs if enabled
            if include_logs and self.backup_config['backup_logs']:
                self._backup_logs(temp_dir)
            
            # Create backup manifest
            self._create_backup_manifest(temp_dir, backup_name)
            
            # Create compressed archive
            self._create_archive(temp_dir, backup_path)
            
            # Clean up temporary directory
            shutil.rmtree(temp_dir)
            
            # Calculate backup size and hash
            backup_size = backup_path.stat().st_size
            backup_hash = self._calculate_file_hash(backup_path)
            
            self.logger.info(f"Backup created successfully: {backup_path}")
            self.logger.info(f"Backup size: {backup_size / (1024*1024):.2f} MB")
            self.logger.info(f"Backup hash: {backup_hash}")
            
            # Update backup index
            self._update_backup_index(backup_name, backup_path, backup_size, backup_hash)
            
            return str(backup_path)
        
        except Exception as e:
            self.logger.error(f"Failed to create backup: {e}")
            # Clean up on failure
            if temp_dir.exists():
                shutil.rmtree(temp_dir)
            if backup_path.exists():
                backup_path.unlink()
            raise
    
    def _backup_config_files(self, temp_dir: Path) -> None:
        """Backup configuration files"""
        config_backup_dir = temp_dir / "config"
        config_backup_dir.mkdir()
        
        # Copy configuration files
        config_files = [
            "config.yml",
            "services.yml",
            "bookmarks.yml",
            "custom.css"
        ]
        
        for file_name in config_files:
            file_path = self.config_dir / file_name
            if file_path.exists():
                shutil.copy2(file_path, config_backup_dir / file_name)
                self.logger.debug(f"Backed up config file: {file_name}")
        
        # Backup secrets if enabled
        if self.backup_config['backup_secrets']:
            secrets_file = self.config_dir / "secrets.yml"
            if secrets_file.exists():
                shutil.copy2(secrets_file, config_backup_dir / "secrets.yml")
                self.logger.debug("Backed up secrets file")
    
    def _backup_health_data(self, temp_dir: Path) -> None:
        """Backup health monitoring data"""
        health_backup_dir = temp_dir / "health_data"
        health_backup_dir.mkdir()
        
        health_files = [
            "health_data.json",
            "health_summary.json"
        ]
        
        for file_name in health_files:
            file_path = self.config_dir / file_name
            if file_path.exists():
                shutil.copy2(file_path, health_backup_dir / file_name)
                self.logger.debug(f"Backed up health data: {file_name}")
    
    def _backup_logs(self, temp_dir: Path) -> None:
        """Backup log files"""
        logs_backup_dir = temp_dir / "logs"
        logs_backup_dir.mkdir()
        
        if self.log_dir.exists():
            # Copy recent log files
            for log_file in self.log_dir.glob("*.log*"):
                if log_file.is_file():
                    shutil.copy2(log_file, logs_backup_dir / log_file.name)
                    self.logger.debug(f"Backed up log file: {log_file.name}")
    
    def _create_backup_manifest(self, temp_dir: Path, backup_name: str) -> None:
        """Create backup manifest with metadata"""
        manifest = {
            'backup_name': backup_name,
            'created_at': datetime.now().isoformat(),
            'version': '1.0',
            'config_dir': str(self.config_dir),
            'backup_config': self.backup_config,
            'files': []
        }
        
        # List all files in backup
        for file_path in temp_dir.rglob('*'):
            if file_path.is_file():
                relative_path = file_path.relative_to(temp_dir)
                file_stat = file_path.stat()
                manifest['files'].append({
                    'path': str(relative_path),
                    'size': file_stat.st_size,
                    'modified': datetime.fromtimestamp(file_stat.st_mtime).isoformat(),
                    'hash': self._calculate_file_hash(file_path)
                })
        
        # Save manifest
        manifest_file = temp_dir / "manifest.json"
        with open(manifest_file, 'w') as f:
            json.dump(manifest, f, indent=2)
    
    def _create_archive(self, source_dir: Path, archive_path: Path) -> None:
        """Create compressed archive from source directory"""
        with tarfile.open(archive_path, 'w:gz') as tar:
            tar.add(source_dir, arcname=source_dir.name)
    
    def _calculate_file_hash(self, file_path: Path) -> str:
        """Calculate SHA256 hash of a file"""
        hash_sha256 = hashlib.sha256()
        with open(file_path, 'rb') as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_sha256.update(chunk)
        return hash_sha256.hexdigest()
    
    def _update_backup_index(self, backup_name: str, backup_path: Path, size: int, file_hash: str) -> None:
        """Update backup index with new backup information"""
        index_file = self.backup_dir / "backup_index.json"
        
        if index_file.exists():
            with open(index_file, 'r') as f:
                index = json.load(f)
        else:
            index = {'backups': []}
        
        # Add new backup entry
        backup_entry = {
            'name': backup_name,
            'path': str(backup_path),
            'size': size,
            'hash': file_hash,
            'created_at': datetime.now().isoformat(),
            'status': 'completed'
        }
        
        index['backups'].append(backup_entry)
        
        # Save updated index
        with open(index_file, 'w') as f:
            json.dump(index, f, indent=2)
    
    @log_execution_time
    def restore_backup(self, backup_path: str, restore_config: bool = True, restore_health_data: bool = True) -> bool:
        """
        Restore from a backup file
        
        Args:
            backup_path: Path to the backup file
            restore_config: Restore configuration files
            restore_health_data: Restore health data
            
        Returns:
            True if restoration was successful
        """
        backup_file = Path(backup_path)
        
        if not backup_file.exists():
            self.logger.error(f"Backup file not found: {backup_path}")
            return False
        
        try:
            self.logger.info(f"Restoring from backup: {backup_path}")
            
            # Create temporary directory for extraction
            temp_dir = self.backup_dir / "temp_restore"
            if temp_dir.exists():
                shutil.rmtree(temp_dir)
            temp_dir.mkdir()
            
            # Extract backup
            with tarfile.open(backup_file, 'r:gz') as tar:
                tar.extractall(temp_dir)
            
            # Find extracted directory
            extracted_dir = next(temp_dir.iterdir())
            if not extracted_dir.is_dir():
                raise ValueError("Invalid backup format")
            
            # Verify backup manifest
            manifest_file = extracted_dir / "manifest.json"
            if not manifest_file.exists():
                raise ValueError("Backup manifest not found")
            
            with open(manifest_file, 'r') as f:
                manifest = json.load(f)
            
            self.logger.info(f"Restoring backup: {manifest['backup_name']}")
            
            # Restore configuration files
            if restore_config:
                self._restore_config_files(extracted_dir)
            
            # Restore health data
            if restore_health_data:
                self._restore_health_data(extracted_dir)
            
            # Clean up
            shutil.rmtree(temp_dir)
            
            self.logger.info("Backup restoration completed successfully")
            return True
        
        except Exception as e:
            self.logger.error(f"Failed to restore backup: {e}")
            if temp_dir.exists():
                shutil.rmtree(temp_dir)
            return False
    
    def _restore_config_files(self, extracted_dir: Path) -> None:
        """Restore configuration files"""
        config_backup_dir = extracted_dir / "config"
        if not config_backup_dir.exists():
            self.logger.warning("Config backup directory not found")
            return
        
        # Create backup of current config before restoring
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        current_backup_dir = self.config_dir / f"pre_restore_backup_{timestamp}"
        current_backup_dir.mkdir()
        
        # Backup current config files
        for config_file in self.config_dir.glob("*.yml"):
            if config_file.is_file():
                shutil.copy2(config_file, current_backup_dir / config_file.name)
        
        # Restore config files
        for config_file in config_backup_dir.glob("*.yml"):
            if config_file.is_file():
                target_file = self.config_dir / config_file.name
                shutil.copy2(config_file, target_file)
                self.logger.info(f"Restored config file: {config_file.name}")
        
        # Restore CSS file
        css_file = config_backup_dir / "custom.css"
        if css_file.exists():
            shutil.copy2(css_file, self.config_dir / "custom.css")
            self.logger.info("Restored custom CSS file")
    
    def _restore_health_data(self, extracted_dir: Path) -> None:
        """Restore health data"""
        health_backup_dir = extracted_dir / "health_data"
        if not health_backup_dir.exists():
            self.logger.warning("Health data backup directory not found")
            return
        
        for health_file in health_backup_dir.glob("*.json"):
            if health_file.is_file():
                target_file = self.config_dir / health_file.name
                shutil.copy2(health_file, target_file)
                self.logger.info(f"Restored health data: {health_file.name}")
    
    def list_backups(self) -> List[Dict[str, Any]]:
        """List all available backups"""
        index_file = self.backup_dir / "backup_index.json"
        
        if not index_file.exists():
            return []
        
        try:
            with open(index_file, 'r') as f:
                index = json.load(f)
            
            # Sort by creation date (newest first)
            backups = sorted(
                index['backups'],
                key=lambda x: x['created_at'],
                reverse=True
            )
            
            return backups
        
        except Exception as e:
            self.logger.error(f"Failed to list backups: {e}")
            return []
    
    def cleanup_old_backups(self) -> int:
        """Clean up old backups based on retention policy"""
        backups = self.list_backups()
        if not backups:
            return 0
        
        cutoff_date = datetime.now() - timedelta(days=self.backup_config['retention_days'])
        deleted_count = 0
        
        for backup in backups:
            backup_date = datetime.fromisoformat(backup['created_at'])
            if backup_date < cutoff_date:
                try:
                    backup_path = Path(backup['path'])
                    if backup_path.exists():
                        backup_path.unlink()
                        self.logger.info(f"Deleted old backup: {backup['name']}")
                        deleted_count += 1
                except Exception as e:
                    self.logger.error(f"Failed to delete backup {backup['name']}: {e}")
        
        # Clean up backup index
        self._cleanup_backup_index()
        
        return deleted_count
    
    def _cleanup_backup_index(self) -> None:
        """Clean up backup index by removing references to deleted backups"""
        index_file = self.backup_dir / "backup_index.json"
        
        if not index_file.exists():
            return
        
        try:
            with open(index_file, 'r') as f:
                index = json.load(f)
            
            # Filter out backups that no longer exist
            valid_backups = []
            for backup in index['backups']:
                backup_path = Path(backup['path'])
                if backup_path.exists():
                    valid_backups.append(backup)
                else:
                    self.logger.debug(f"Removing reference to deleted backup: {backup['name']}")
            
            index['backups'] = valid_backups
            
            # Save updated index
            with open(index_file, 'w') as f:
                json.dump(index, f, indent=2)
        
        except Exception as e:
            self.logger.error(f"Failed to cleanup backup index: {e}")
    
    def get_backup_stats(self) -> Dict[str, Any]:
        """Get backup statistics"""
        backups = self.list_backups()
        
        if not backups:
            return {
                'total_backups': 0,
                'total_size': 0,
                'oldest_backup': None,
                'newest_backup': None,
                'average_size': 0
            }
        
        total_size = sum(backup['size'] for backup in backups)
        oldest_backup = min(backups, key=lambda x: x['created_at'])
        newest_backup = max(backups, key=lambda x: x['created_at'])
        
        return {
            'total_backups': len(backups),
            'total_size': total_size,
            'total_size_mb': total_size / (1024 * 1024),
            'oldest_backup': oldest_backup['created_at'],
            'newest_backup': newest_backup['created_at'],
            'average_size': total_size / len(backups),
            'average_size_mb': (total_size / len(backups)) / (1024 * 1024)
        }

def main():
    """Main function for backup management"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Backup manager for homepage dashboard')
    parser.add_argument('--config-dir', default='/app/config', help='Configuration directory')
    parser.add_argument('--backup-dir', default='/app/backups', help='Backup directory')
    parser.add_argument('--create', action='store_true', help='Create a new backup')
    parser.add_argument('--restore', help='Restore from backup file')
    parser.add_argument('--list', action='store_true', help='List all backups')
    parser.add_argument('--cleanup', action='store_true', help='Clean up old backups')
    parser.add_argument('--stats', action='store_true', help='Show backup statistics')
    parser.add_argument('--name', help='Custom backup name')
    
    args = parser.parse_args()
    
    backup_manager = BackupManager(args.config_dir, args.backup_dir)
    
    if args.create:
        backup_path = backup_manager.create_backup(args.name)
        print(f"Backup created: {backup_path}")
    elif args.restore:
        success = backup_manager.restore_backup(args.restore)
        if success:
            print("Backup restored successfully")
        else:
            print("Backup restoration failed")
            sys.exit(1)
    elif args.list:
        backups = backup_manager.list_backups()
        if backups:
            print("Available backups:")
            for backup in backups:
                size_mb = backup['size'] / (1024 * 1024)
                print(f"  {backup['name']} ({size_mb:.2f} MB) - {backup['created_at']}")
        else:
            print("No backups found")
    elif args.cleanup:
        deleted_count = backup_manager.cleanup_old_backups()
        print(f"Deleted {deleted_count} old backups")
    elif args.stats:
        stats = backup_manager.get_backup_stats()
        print("Backup statistics:")
        print(f"  Total backups: {stats['total_backups']}")
        print(f"  Total size: {stats['total_size_mb']:.2f} MB")
        print(f"  Average size: {stats['average_size_mb']:.2f} MB")
        if stats['oldest_backup']:
            print(f"  Oldest backup: {stats['oldest_backup']}")
            print(f"  Newest backup: {stats['newest_backup']}")
    else:
        parser.print_help()

if __name__ == "__main__":
    main() 