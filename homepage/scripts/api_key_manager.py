#!/usr/bin/env python3
"""
API Key Manager for Homelab Homepage
====================================

This script manages API keys for all homelab services, providing secure storage,
validation, and configuration management for the homepage dashboard.

Features:
- Secure API key storage with encryption
- Automatic key validation and testing
- Configuration file generation
- Service health checking
- Backup and recovery
- Production-ready error handling and logging
"""

import sys
import os
import json
import base64
import hashlib
import argparse
import logging
import secrets
import tempfile
import shutil
from pathlib import Path
from typing import Dict, List, Optional, Any, Tuple
from datetime import datetime, timedelta
from urllib.parse import urlparse
import ssl
import socket

# Check for required dependencies
try:
    import yaml
except ImportError:
    print("ERROR: PyYAML is required. Install with: pip3 install PyYAML")
    sys.exit(1)

try:
    import requests
except ImportError:
    print("ERROR: Requests is required. Install with: pip3 install requests")
    sys.exit(1)

try:
    from cryptography.fernet import Fernet
except ImportError:
    print("ERROR: Cryptography is required. Install with: pip3 install cryptography")
    sys.exit(1)

from logging_config import setup_logging, get_logger, log_function_call, log_execution_time, LogContext

# Setup centralized logging
LOG_DIR = os.environ.get('HOMEPAGE_LOG_DIR', './logs')
setup_logging(log_dir=LOG_DIR, log_level="INFO", json_output=True)
logger = get_logger("api_key_manager")

class SecurityError(Exception):
    """Custom exception for security-related errors"""
    pass

class ValidationError(Exception):
    """Custom exception for validation errors"""
    pass

class APIKeyManager:
    """Manages API keys for homelab services with enhanced security"""
    
    def __init__(self, config_dir: str = "config", keys_file: str = "api_keys.enc"):
        self.config_dir = Path(config_dir)
        self.keys_file = self.config_dir / keys_file
        self.master_key_file = self.config_dir / "master.key"
        self.services_config = self.config_dir / "services.yml"
        self.widgets_config = self.config_dir / "widgets.yml"
        self.backup_dir = self.config_dir / "backups"
        
        # Ensure directories exist
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.backup_dir.mkdir(exist_ok=True)
        
        # Initialize encryption
        self._init_encryption()
        
        # Load service definitions
        self.services = self._load_service_definitions()
        
        # Security settings
        self.max_key_length = 1024
        self.allowed_key_chars = set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_=+")
        
    def _init_encryption(self):
        """Initialize encryption with enhanced security"""
        try:
            if not self.master_key_file.exists():
                # Generate new master key with proper entropy
                key = Fernet.generate_key()
                
                # Set secure file permissions
                with open(self.master_key_file, 'wb') as f:
                    f.write(key)
                
                # Set restrictive permissions (owner read/write only)
                os.chmod(self.master_key_file, 0o600)
                with LogContext(logger, {"service": "api_key_manager", "action": "_init_encryption"}):
                    logger.info("Generated new master encryption key with secure permissions")
            else:
                # Verify file permissions
                stat = os.stat(self.master_key_file)
                if stat.st_mode & 0o777 != 0o600:
                    with LogContext(logger, {"service": "api_key_manager", "action": "_init_encryption"}):
                        logger.warning("Master key file has insecure permissions, fixing...")
                    os.chmod(self.master_key_file, 0o600)
            
            # Load master key
            with open(self.master_key_file, 'rb') as f:
                key = f.read()
            
            self.cipher = Fernet(key)
            
        except Exception as e:
            with LogContext(logger, {"service": "api_key_manager", "action": "_init_encryption"}):
                logger.error(f"Failed to initialize encryption: {e}", exc_info=True)
            raise SecurityError(f"Encryption initialization failed: {e}")
        
    def _validate_api_key(self, service: str, api_key: str) -> bool:
        """Validate API key format and security"""
        if not api_key or not isinstance(api_key, str):
            return False
            
        if len(api_key) > self.max_key_length:
            logger.warning(f"API key for {service} exceeds maximum length")
            return False
            
        # Check for potentially dangerous characters
        if not all(c in self.allowed_key_chars for c in api_key):
            logger.warning(f"API key for {service} contains potentially dangerous characters")
            return False
            
        return True
        
    def _load_service_definitions(self) -> Dict[str, Dict]:
        """Load service definitions with API key requirements and enhanced validation"""
        return {
            # Infrastructure Services
            "traefik": {
                "name": "Traefik",
                "url": "http://traefik:8080",
                "api_endpoint": "/api/http/routers",
                "key_header": "Authorization",
                "key_format": "Bearer {key}",
                "test_endpoint": "/ping",
                "timeout": 10,
                "verify_ssl": False
            },
            "authentik": {
                "name": "Authentik",
                "url": "http://authentik:9000",
                "api_endpoint": "/api/v3/core/users/",
                "key_header": "Authorization",
                "key_format": "Bearer {key}",
                "test_endpoint": "/api/v3/core/health/",
                "timeout": 15,
                "verify_ssl": False
            },
            "portainer": {
                "name": "Portainer",
                "url": "http://portainer:9000",
                "api_endpoint": "/api/endpoints",
                "key_header": "X-API-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/status",
                "timeout": 10,
                "verify_ssl": False
            },
            
            # Monitoring Services
            "grafana": {
                "name": "Grafana",
                "url": "http://grafana:3000",
                "api_endpoint": "/api/dashboards",
                "key_header": "Authorization",
                "key_format": "Bearer {key}",
                "test_endpoint": "/api/health",
                "timeout": 10,
                "verify_ssl": False
            },
            "prometheus": {
                "name": "Prometheus",
                "url": "http://prometheus:9090",
                "api_endpoint": "/api/v1/targets",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/-/healthy",
                "timeout": 10,
                "verify_ssl": False
            },
            "alertmanager": {
                "name": "AlertManager",
                "url": "http://alertmanager:9093",
                "api_endpoint": "/api/v1/alerts",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/-/healthy",
                "timeout": 10,
                "verify_ssl": False
            },
            "loki": {
                "name": "Loki",
                "url": "http://loki:3100",
                "api_endpoint": "/loki/api/v1/labels",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/ready",
                "timeout": 10,
                "verify_ssl": False
            },
            "uptime_kuma": {
                "name": "Uptime Kuma",
                "url": "http://uptime-kuma:3001",
                "api_endpoint": "/api/status-page",
                "key_header": "Authorization",
                "key_format": "Bearer {key}",
                "test_endpoint": "/api/status",
                "timeout": 15,
                "verify_ssl": False
            },
            
            # Security Services
            "crowdsec": {
                "name": "CrowdSec",
                "url": "http://crowdsec:8080",
                "api_endpoint": "/v1/decisions",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/health",
                "timeout": 10,
                "verify_ssl": False
            },
            "fail2ban": {
                "name": "Fail2ban",
                "url": "http://fail2ban:8080",
                "api_endpoint": "/status",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/status",
                "timeout": 10,
                "verify_ssl": False
            },
            "pihole": {
                "name": "Pi-hole",
                "url": "http://pihole:80",
                "api_endpoint": "/admin/api.php",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/admin/api.php?status",
                "timeout": 10,
                "verify_ssl": False
            },
            
            # Database Services
            "postgresql": {
                "name": "PostgreSQL",
                "url": "http://postgresql:5432",
                "api_endpoint": None,
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/health",
                "timeout": 10,
                "verify_ssl": False
            },
            "mariadb": {
                "name": "MariaDB",
                "url": "http://mariadb:3306",
                "api_endpoint": None,
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/health",
                "timeout": 10,
                "verify_ssl": False
            },
            "redis": {
                "name": "Redis",
                "url": "http://redis:6379",
                "api_endpoint": None,
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/health",
                "timeout": 10,
                "verify_ssl": False
            },
            "elasticsearch": {
                "name": "Elasticsearch",
                "url": "http://elasticsearch:9200",
                "api_endpoint": "/_cluster/health",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/_cluster/health",
                "timeout": 15,
                "verify_ssl": False
            },
            
            # Media Services
            "jellyfin": {
                "name": "Jellyfin",
                "url": "http://jellyfin:8096",
                "api_endpoint": "/System/Info",
                "key_header": "X-Emby-Token",
                "key_format": "{key}",
                "test_endpoint": "/System/Info",
                "timeout": 15,
                "verify_ssl": False
            },
            "sonarr": {
                "name": "Sonarr",
                "url": "http://sonarr:8989",
                "api_endpoint": "/api/v3/series",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/v3/system/status",
                "timeout": 15,
                "verify_ssl": False
            },
            "radarr": {
                "name": "Radarr",
                "url": "http://radarr:7878",
                "api_endpoint": "/api/v3/movie",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/v3/system/status",
                "timeout": 15,
                "verify_ssl": False
            },
            "lidarr": {
                "name": "Lidarr",
                "url": "http://lidarr:8686",
                "api_endpoint": "/api/v1/artist",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/v1/system/status",
                "timeout": 15,
                "verify_ssl": False
            },
            "readarr": {
                "name": "Readarr",
                "url": "http://readarr:8787",
                "api_endpoint": "/api/v1/author",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/v1/system/status",
                "timeout": 15,
                "verify_ssl": False
            },
            "prowlarr": {
                "name": "Prowlarr",
                "url": "http://prowlarr:9696",
                "api_endpoint": "/api/v1/indexer",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/v1/system/status",
                "timeout": 15,
                "verify_ssl": False
            },
            "bazarr": {
                "name": "Bazarr",
                "url": "http://bazarr:6767",
                "api_endpoint": "/api/movies",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/health",
                "timeout": 15,
                "verify_ssl": False
            },
            "tautulli": {
                "name": "Tautulli",
                "url": "http://tautulli:8181",
                "api_endpoint": "/api/v2",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/api/v2?apikey={key}&cmd=status",
                "timeout": 15,
                "verify_ssl": False
            },
            "overseerr": {
                "name": "Overseerr",
                "url": "http://overseerr:5055",
                "api_endpoint": "/api/v1/request",
                "key_header": "X-Api-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/v1/status",
                "timeout": 15,
                "verify_ssl": False
            },
            "sabnzbd": {
                "name": "SABnzbd",
                "url": "http://sabnzbd:8080",
                "api_endpoint": "/api",
                "key_header": None,
                "key_format": None,
                "test_endpoint": "/api?mode=version&apikey={key}",
                "timeout": 15,
                "verify_ssl": False
            },
            "immich": {
                "name": "Immich",
                "url": "http://immich:3001",
                "api_endpoint": "/api/assets",
                "key_header": "X-API-Key",
                "key_format": "{key}",
                "test_endpoint": "/api/health",
                "timeout": 15,
                "verify_ssl": False
            },
            
            # Automation Services
            "homeassistant": {
                "name": "Home Assistant",
                "url": "http://homeassistant:8123",
                "api_endpoint": "/api/",
                "key_header": "Authorization",
                "key_format": "Bearer {key}",
                "test_endpoint": "/api/",
                "timeout": 15,
                "verify_ssl": False
            },
            
            # Storage Services
            "nextcloud": {
                "name": "Nextcloud",
                "url": "http://nextcloud:8080",
                "api_endpoint": "/ocs/v1.php/cloud/users",
                "key_header": "Authorization",
                "key_format": "Basic {key}",
                "test_endpoint": "/status.php",
                "timeout": 15,
                "verify_ssl": False
            },
            "paperless": {
                "name": "Paperless",
                "url": "http://paperless:8000",
                "api_endpoint": "/api/documents/",
                "key_header": "Authorization",
                "key_format": "Token {key}",
                "test_endpoint": "/api/health",
                "timeout": 15,
                "verify_ssl": False
            },
            
            # External Services
            "github": {
                "name": "GitHub",
                "url": "https://api.github.com",
                "api_endpoint": "/user",
                "key_header": "Authorization",
                "key_format": "Bearer {key}",
                "test_endpoint": "/rate_limit",
                "timeout": 30,
                "verify_ssl": True
            }
        }
        
    def _encrypt_data(self, data: str) -> bytes:
        """Encrypt data with error handling"""
        try:
            return self.cipher.encrypt(data.encode('utf-8'))
        except Exception as e:
            logger.error(f"Encryption failed: {e}")
            raise SecurityError(f"Failed to encrypt data: {e}")
            
    def _decrypt_data(self, encrypted_data: bytes) -> str:
        """Decrypt data with error handling"""
        try:
            return self.cipher.decrypt(encrypted_data).decode('utf-8')
        except Exception as e:
            logger.error(f"Decryption failed: {e}")
            raise SecurityError(f"Failed to decrypt data: {e}")
            
    def _test_connection(self, service: str, url: str, timeout: int = 10, verify_ssl: bool = True) -> bool:
        """Test basic connectivity to service"""
        try:
            parsed_url = urlparse(url)
            host = parsed_url.hostname
            port = parsed_url.port or (443 if parsed_url.scheme == 'https' else 80)
            
            # Test TCP connection
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(timeout)
            result = sock.connect_ex((host, port))
            sock.close()
            
            if result != 0:
                logger.warning(f"Cannot connect to {service} at {host}:{port}")
                return False
                
            return True
            
        except Exception as e:
            logger.warning(f"Connection test failed for {service}: {e}")
            return False
            
    def _make_api_request(self, service: str, url: str, api_key: str = None, 
                         headers: Dict = None, timeout: int = 10, verify_ssl: bool = True) -> Tuple[bool, str]:
        """Make API request with comprehensive error handling"""
        try:
            # Test basic connectivity first
            if not self._test_connection(service, url, timeout, verify_ssl):
                return False, "Connection failed"
            
            request_headers = headers or {}
            if api_key:
                service_config = self.services.get(service, {})
                key_header = service_config.get('key_header')
                key_format = service_config.get('key_format')
                
                if key_header and key_format:
                    formatted_key = key_format.format(key=api_key)
                    request_headers[key_header] = formatted_key
            
            response = requests.get(
                url,
                headers=request_headers,
                timeout=timeout,
                verify=verify_ssl,
                allow_redirects=False
            )
            
            if response.status_code == 200:
                return True, "Success"
            elif response.status_code == 401:
                return False, "Authentication failed"
            elif response.status_code == 403:
                return False, "Access forbidden"
            else:
                return False, f"HTTP {response.status_code}: {response.reason}"
                
        except requests.exceptions.Timeout:
            return False, "Request timeout"
        except requests.exceptions.ConnectionError:
            return False, "Connection error"
        except requests.exceptions.SSLError:
            return False, "SSL error"
        except Exception as e:
            return False, f"Request failed: {str(e)}"
            
    def load_keys(self) -> Dict[str, str]:
        """Load encrypted API keys with error handling"""
        try:
            if not self.keys_file.exists():
                logger.info("No encrypted keys file found, starting with empty keys")
                return {}
            
            with open(self.keys_file, 'rb') as f:
                encrypted_data = f.read()
            
            if not encrypted_data:
                return {}
            
            decrypted_data = self._decrypt_data(encrypted_data)
            keys = json.loads(decrypted_data)
            
            # Validate loaded keys
            for service, key in keys.items():
                if not self._validate_api_key(service, key):
                    logger.warning(f"Invalid API key format for {service}, removing")
                    keys[service] = ""
            
            logger.info(f"Loaded {len(keys)} API keys")
            return keys
            
        except Exception as e:
            logger.error(f"Failed to load API keys: {e}")
            raise SecurityError(f"Failed to load API keys: {e}")
            
    def save_keys(self, keys: Dict[str, str]):
        """Save API keys with encryption and error handling"""
        try:
            # Validate all keys before saving
            for service, key in keys.items():
                if key and not self._validate_api_key(service, key):
                    raise ValidationError(f"Invalid API key format for {service}")
            
            # Create temporary file for atomic write
            temp_file = self.keys_file.with_suffix('.tmp')
            
            json_data = json.dumps(keys, indent=2)
            encrypted_data = self._encrypt_data(json_data)
            
            with open(temp_file, 'wb') as f:
                f.write(encrypted_data)
            
            # Set secure permissions
            os.chmod(temp_file, 0o600)
            
            # Atomic move
            shutil.move(str(temp_file), str(self.keys_file))
            
            logger.info(f"Saved {len(keys)} API keys securely")
            
        except Exception as e:
            logger.error(f"Failed to save API keys: {e}")
            raise SecurityError(f"Failed to save API keys: {e}")
            
    @log_function_call
    @log_execution_time
    def add_key(self, service: str, api_key: str):
        """Add or update API key with validation"""
        try:
            if service not in self.services:
                raise ValidationError(f"Unknown service: {service}")
            
            if not self._validate_api_key(service, api_key):
                raise ValidationError(f"Invalid API key format for {service}")
            
            keys = self.load_keys()
            keys[service] = api_key
            self.save_keys(keys)
            
            logger.info(f"Added API key for {service}")
            
        except Exception as e:
            logger.error(f"Failed to add API key for {service}: {e}")
            raise
            
    @log_function_call
    @log_execution_time
    def remove_key(self, service: str):
        """Remove API key for service"""
        try:
            keys = self.load_keys()
            if service in keys:
                del keys[service]
                self.save_keys(keys)
                logger.info(f"Removed API key for {service}")
            else:
                logger.warning(f"No API key found for {service}")
                
        except Exception as e:
            logger.error(f"Failed to remove API key for {service}: {e}")
            raise
            
    @log_function_call
    @log_execution_time
    def test_key(self, service: str, api_key: str = None) -> bool:
        """Test API key with comprehensive validation"""
        try:
            if service not in self.services:
                logger.error(f"Unknown service: {service}")
                return False
            
            service_config = self.services[service]
            
            # Use provided key or load from storage
            if api_key is None:
                keys = self.load_keys()
                api_key = keys.get(service, "")
            
            if not api_key:
                logger.warning(f"No API key provided for {service}")
                return False
            
            # Validate key format
            if not self._validate_api_key(service, api_key):
                logger.error(f"Invalid API key format for {service}")
                return False
            
            # Test API endpoint
            test_endpoint = service_config['test_endpoint']
            if '{key}' in test_endpoint:
                test_url = f"{service_config['url']}{test_endpoint.format(key=api_key)}"
            else:
                test_url = f"{service_config['url']}{test_endpoint}"
            
            success, message = self._make_api_request(
                service,
                test_url,
                api_key,
                timeout=service_config.get('timeout', 10),
                verify_ssl=service_config.get('verify_ssl', True)
            )
            
            if success:
                logger.info(f"API key test successful for {service}")
                return True
            else:
                logger.warning(f"API key test failed for {service}: {message}")
                return False
                
        except Exception as e:
            logger.error(f"API key test failed for {service}: {e}")
            return False
            
    @log_function_call
    @log_execution_time
    def test_all_keys(self):
        """Test all stored API keys"""
        try:
            keys = self.load_keys()
            results = {}
            
            logger.info("Testing all API keys...")
            
            for service, api_key in keys.items():
                if api_key:
                    success = self.test_key(service, api_key)
                    results[service] = success
                    status = "✓" if success else "✗"
                    logger.info(f"{status} {service}: {'Valid' if success else 'Invalid'}")
                else:
                    results[service] = False
                    logger.info(f"- {service}: No key")
            
            # Summary
            valid_count = sum(1 for success in results.values() if success)
            total_count = len(results)
            
            logger.info(f"\nAPI Key Test Summary:")
            logger.info(f"Valid: {valid_count}/{total_count}")
            logger.info(f"Invalid: {total_count - valid_count}/{total_count}")
            
            return results
            
        except Exception as e:
            logger.error(f"Failed to test API keys: {e}")
            raise
            
    @log_function_call
    @log_execution_time
    def generate_config_files(self):
        """Generate configuration files with API keys"""
        try:
            keys = self.load_keys()
            
            # Generate services.yml with API keys
            if self.services_config.exists():
                with open(self.services_config, 'r') as f:
                    services_content = f.read()
                
                # Replace placeholder API keys with actual keys
                for service, api_key in keys.items():
                    placeholder = f"your_{service}_api_key"
                    replacement = f"{{{{ {service}_api_key | default('') }}}}"
                    services_content = services_content.replace(placeholder, replacement)
                
                # Backup original file
                backup_file = self.backup_dir / f"services_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.yml"
                shutil.copy2(self.services_config, backup_file)
                
                # Write updated content
                with open(self.services_config, 'w') as f:
                    f.write(services_content)
                
                logger.info(f"Updated {self.services_config} with API keys")
            
            # Generate widgets.yml with API keys
            if self.widgets_config.exists():
                with open(self.widgets_config, 'r') as f:
                    widgets_content = f.read()
                
                # Replace placeholder API keys with actual keys
                for service, api_key in keys.items():
                    placeholder = f"your_{service}_api_key"
                    replacement = f"{{{{ {service}_api_key | default('') }}}}"
                    widgets_content = widgets_content.replace(placeholder, replacement)
                
                # Backup original file
                backup_file = self.backup_dir / f"widgets_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.yml"
                shutil.copy2(self.widgets_config, backup_file)
                
                # Write updated content
                with open(self.widgets_config, 'w') as f:
                    f.write(widgets_content)
                
                logger.info(f"Updated {self.widgets_config} with API keys")
            
            logger.info("Configuration files generated successfully")
            
        except Exception as e:
            logger.error(f"Failed to generate configuration files: {e}")
            raise
            
    @log_function_call
    @log_execution_time
    def backup_keys(self, backup_file: str = None):
        """Create encrypted backup of API keys"""
        try:
            if not backup_file:
                timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                backup_file = self.backup_dir / f"api_keys_backup_{timestamp}.enc"
            
            keys = self.load_keys()
            
            # Create backup data with metadata
            backup_data = {
                "timestamp": datetime.now().isoformat(),
                "version": "1.0",
                "keys": keys,
                "checksum": hashlib.sha256(json.dumps(keys, sort_keys=True).encode()).hexdigest()
            }
            
            json_data = json.dumps(backup_data, indent=2)
            encrypted_data = self._encrypt_data(json_data)
            
            with open(backup_file, 'wb') as f:
                f.write(encrypted_data)
            
            # Set secure permissions
            os.chmod(backup_file, 0o600)
            
            logger.info(f"API keys backed up to: {backup_file}")
            
        except Exception as e:
            logger.error(f"Failed to backup API keys: {e}")
            raise SecurityError(f"Backup failed: {e}")
            
    @log_function_call
    @log_execution_time
    def restore_keys(self, backup_file: str):
        """Restore API keys from backup"""
        try:
            if not Path(backup_file).exists():
                raise FileNotFoundError(f"Backup file not found: {backup_file}")
            
            with open(backup_file, 'rb') as f:
                encrypted_data = f.read()
            
            decrypted_data = self._decrypt_data(encrypted_data)
            backup_data = json.loads(decrypted_data)
            
            # Validate backup data
            if 'keys' not in backup_data or 'checksum' not in backup_data:
                raise ValidationError("Invalid backup file format")
            
            # Verify checksum
            expected_checksum = backup_data['checksum']
            actual_checksum = hashlib.sha256(json.dumps(backup_data['keys'], sort_keys=True).encode()).hexdigest()
            
            if expected_checksum != actual_checksum:
                raise SecurityError("Backup file checksum verification failed")
            
            # Restore keys
            self.save_keys(backup_data['keys'])
            
            logger.info(f"API keys restored from: {backup_file}")
            logger.info(f"Backup timestamp: {backup_data.get('timestamp', 'Unknown')}")
            
        except Exception as e:
            logger.error(f"Failed to restore API keys: {e}")
            raise SecurityError(f"Restore failed: {e}")
            
    def list_services(self):
        """List all available services"""
        logger.info("Available services:")
        for service, config in self.services.items():
            logger.info(f"  - {service}: {config['name']}")
            
    def list_keys(self):
        """List all stored API keys (without showing the actual keys)"""
        try:
            keys = self.load_keys()
            logger.info("Stored API keys:")
            for service, api_key in keys.items():
                if api_key:
                    masked_key = api_key[:4] + "*" * (len(api_key) - 8) + api_key[-4:] if len(api_key) > 8 else "****"
                    logger.info(f"  - {service}: {masked_key}")
                else:
                    logger.info(f"  - {service}: No key")
                    
        except Exception as e:
            logger.error(f"Failed to list API keys: {e}")
            raise

def main():
    """Main function with comprehensive argument parsing and error handling"""
    # Validate environment first
    # This function is no longer needed as logging_config.py handles setup
    # if not validate_environment():
    #     sys.exit(1)
    
    parser = argparse.ArgumentParser(
        description="API Key Manager for Homelab Homepage",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s add sonarr your_sonarr_api_key
  %(prog)s test --all
  %(prog)s generate
  %(prog)s backup
  %(prog)s restore backup_file.enc
        """
    )
    
    parser.add_argument('command', choices=[
        'add', 'remove', 'test', 'list', 'services', 'generate', 'backup', 'restore'
    ], help='Command to execute')
    
    parser.add_argument('service', nargs='?', help='Service name')
    parser.add_argument('api_key', nargs='?', help='API key')
    parser.add_argument('--all', action='store_true', help='Apply to all services')
    parser.add_argument('--backup-file', help='Backup file path')
    parser.add_argument('--config-dir', default='config', help='Configuration directory')
    parser.add_argument('--log-level', default='INFO', choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
                       help='Logging level')
    parser.add_argument('--log-file', default='api_key_manager.log', help='Log file name')
    
    args = parser.parse_args()
    
    # Setup logging with provided arguments
    # This function is no longer needed as logging_config.py handles setup
    # global logger
    # logger = setup_logging(args.log_level, args.log_file)
    
    try:
        manager = APIKeyManager(config_dir=args.config_dir)
        
        if args.command == 'add':
            if not args.service or not args.api_key:
                parser.error("add command requires service and api_key arguments")
            manager.add_key(args.service, args.api_key)
            
        elif args.command == 'remove':
            if not args.service:
                parser.error("remove command requires service argument")
            manager.remove_key(args.service)
            
        elif args.command == 'test':
            if args.all:
                manager.test_all_keys()
            elif args.service:
                success = manager.test_key(args.service, args.api_key)
                if success:
                    logger.info(f"API key test successful for {args.service}")
                else:
                    logger.error(f"API key test failed for {args.service}")
            else:
                parser.error("test command requires --all or service argument")
                
        elif args.command == 'list':
            manager.list_keys()
            
        elif args.command == 'services':
            manager.list_services()
            
        elif args.command == 'generate':
            manager.generate_config_files()
            
        elif args.command == 'backup':
            manager.backup_keys(args.backup_file)
            
        elif args.command == 'restore':
            if not args.backup_file:
                parser.error("restore command requires backup file path")
            manager.restore_keys(args.backup_file)
            
    except KeyboardInterrupt:
        logger.info("Operation cancelled by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Operation failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 