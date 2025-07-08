#!/usr/bin/env python3
"""
Security Configuration for Homepage Dashboard

This module handles secure configuration management including API keys,
secrets, and security settings for the homepage dashboard.
"""

import os
import json
import yaml
import base64
import hashlib
import secrets
from pathlib import Path
from typing import Dict, Any, Optional
import logging
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

logger = logging.getLogger(__name__)

class SecurityConfig:
    """Security configuration manager"""
    
    def __init__(self, config_dir: str = "/app/config"):
        self.config_dir = Path(config_dir)
        self.secrets_file = self.config_dir / "secrets.yml"
        self.key_file = self.config_dir / ".key"
        self.fernet = None
        
        # Initialize encryption
        self._init_encryption()
    
    def _init_encryption(self) -> None:
        """Initialize encryption key"""
        try:
            if self.key_file.exists():
                with open(self.key_file, 'rb') as f:
                    key = f.read()
            else:
                # Generate new key
                key = Fernet.generate_key()
                with open(self.key_file, 'wb') as f:
                    f.write(key)
                # Set restrictive permissions
                os.chmod(self.key_file, 0o600)
            
            self.fernet = Fernet(key)
            logger.info("Encryption initialized successfully")
        
        except Exception as e:
            logger.error(f"Failed to initialize encryption: {e}")
            self.fernet = None
    
    def encrypt_value(self, value: str) -> str:
        """Encrypt a string value"""
        if not self.fernet:
            return value
        
        try:
            encrypted = self.fernet.encrypt(value.encode())
            return base64.b64encode(encrypted).decode()
        except Exception as e:
            logger.error(f"Failed to encrypt value: {e}")
            return value
    
    def decrypt_value(self, encrypted_value: str) -> str:
        """Decrypt a string value"""
        if not self.fernet:
            return encrypted_value
        
        try:
            encrypted = base64.b64decode(encrypted_value.encode())
            decrypted = self.fernet.decrypt(encrypted)
            return decrypted.decode()
        except Exception as e:
            logger.error(f"Failed to decrypt value: {e}")
            return encrypted_value
    
    def load_secrets(self) -> Dict[str, Any]:
        """Load secrets from file"""
        try:
            if self.secrets_file.exists():
                with open(self.secrets_file, 'r') as f:
                    secrets_data = yaml.safe_load(f) or {}
                
                # Decrypt sensitive values
                decrypted_secrets = {}
                for key, value in secrets_data.items():
                    if isinstance(value, str) and value.startswith('encrypted:'):
                        decrypted_value = self.decrypt_value(value[10:])  # Remove 'encrypted:' prefix
                        decrypted_secrets[key] = decrypted_value
                    else:
                        decrypted_secrets[key] = value
                
                return decrypted_secrets
            else:
                return {}
        
        except Exception as e:
            logger.error(f"Failed to load secrets: {e}")
            return {}
    
    def save_secrets(self, secrets_data: Dict[str, Any]) -> None:
        """Save secrets to file with encryption"""
        try:
            # Encrypt sensitive values
            encrypted_secrets = {}
            for key, value in secrets_data.items():
                if self._is_sensitive_key(key):
                    encrypted_value = self.encrypt_value(str(value))
                    encrypted_secrets[key] = f"encrypted:{encrypted_value}"
                else:
                    encrypted_secrets[key] = value
            
            # Save to file
            with open(self.secrets_file, 'w') as f:
                yaml.dump(encrypted_secrets, f, default_flow_style=False)
            
            # Set restrictive permissions
            os.chmod(self.secrets_file, 0o600)
            
            logger.info("Secrets saved successfully")
        
        except Exception as e:
            logger.error(f"Failed to save secrets: {e}")
    
    def _is_sensitive_key(self, key: str) -> bool:
        """Check if a key contains sensitive information"""
        sensitive_patterns = [
            'password', 'secret', 'key', 'token', 'api_key', 'auth',
            'credential', 'private', 'cert', 'ssl'
        ]
        
        key_lower = key.lower()
        return any(pattern in key_lower for pattern in sensitive_patterns)
    
    def generate_api_key(self, service_name: str) -> str:
        """Generate a secure API key for a service"""
        # Generate a secure random key
        key = secrets.token_urlsafe(32)
        
        # Add service prefix for identification
        return f"{service_name}_{key}"
    
    def validate_api_key(self, api_key: str) -> bool:
        """Validate API key format"""
        if not api_key:
            return False
        
        # Check minimum length
        if len(api_key) < 16:
            return False
        
        # Check for common patterns
        if api_key.count('_') < 1:
            return False
        
        return True
    
    def sanitize_config(self, config: Dict[str, Any]) -> Dict[str, Any]:
        """Sanitize configuration by removing sensitive data"""
        sanitized = config.copy()
        
        def _sanitize_dict(d: Dict[str, Any]) -> None:
            for key, value in d.items():
                if isinstance(value, dict):
                    _sanitize_dict(value)
                elif isinstance(value, str) and self._is_sensitive_key(key):
                    d[key] = "***REDACTED***"
        
        _sanitize_dict(sanitized)
        return sanitized
    
    def create_default_secrets(self) -> Dict[str, Any]:
        """Create default secrets template"""
        default_secrets = {
            'weather_api_key': 'your_openweathermap_api_key',
            'github_api_key': 'your_github_api_key',
            'traefik_api_key': 'your_traefik_api_key',
            'authentik_api_key': 'your_authentik_api_key',
            'portainer_api_key': 'your_portainer_api_key',
            'grafana_api_key': 'your_grafana_api_key',
            'sonarr_api_key': 'your_sonarr_api_key',
            'radarr_api_key': 'your_radarr_api_key',
            'jellyfin_api_key': 'your_jellyfin_api_key',
            'nextcloud_api_key': 'your_nextcloud_api_key',
            'pihole_api_key': 'your_pihole_api_key',
            'homeassistant_api_key': 'your_homeassistant_api_key',
            'overseerr_api_key': 'your_overseerr_api_key',
            'tautulli_api_key': 'your_tautulli_api_key',
            'sabnzbd_api_key': 'your_sabnzbd_api_key',
            'immich_api_key': 'your_immich_api_key',
            'paperless_api_key': 'your_paperless_api_key',
            'gitlab_api_key': 'your_gitlab_api_key',
            'google_client_id': 'your_google_client_id',
            'google_client_secret': 'your_google_client_secret',
            'google_refresh_token': 'your_google_refresh_token'
        }
        
        return default_secrets
    
    def setup_security(self) -> None:
        """Setup initial security configuration"""
        try:
            if not self.secrets_file.exists():
                default_secrets = self.create_default_secrets()
                self.save_secrets(default_secrets)
                logger.info("Created default secrets template")
            
            # Ensure proper file permissions
            if self.secrets_file.exists():
                os.chmod(self.secrets_file, 0o600)
            
            if self.key_file.exists():
                os.chmod(self.key_file, 0o600)
            
            logger.info("Security setup completed")
        
        except Exception as e:
            logger.error(f"Failed to setup security: {e}")

def main():
    """Main function for security setup"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Security configuration for homepage dashboard')
    parser.add_argument('--config-dir', default='/app/config', help='Configuration directory')
    parser.add_argument('--setup', action='store_true', help='Setup initial security configuration')
    parser.add_argument('--generate-key', help='Generate API key for service')
    
    args = parser.parse_args()
    
    security = SecurityConfig(args.config_dir)
    
    if args.setup:
        security.setup_security()
    elif args.generate_key:
        api_key = security.generate_api_key(args.generate_key)
        print(f"Generated API key for {args.generate_key}: {api_key}")
    else:
        print("Use --setup to initialize security configuration")
        print("Use --generate-key SERVICE_NAME to generate an API key")

if __name__ == "__main__":
    main() 