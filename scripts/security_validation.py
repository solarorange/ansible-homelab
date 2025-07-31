#!/usr/bin/env python3
"""
Comprehensive Security Validation Script
Validates security configuration across all services
"""

import requests
import json
import logging
import subprocess
from pathlib import Path
from typing import Dict, List, Any

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class SecurityValidator:
    def __init__(self):
        self.validation_results = {}
    
    def validate_ssl_configuration(self, service_url: str) -> Dict[str, Any]:
        """Validate SSL configuration for a service"""
        try:
            if service_url.startswith('https'):
                response = requests.get(service_url, timeout=10, verify=True)
                return {
                    'status': 'valid',
                    'ssl_enabled': True,
                    'certificate_valid': True
                }
            else:
                return {
                    'status': 'warning',
                    'ssl_enabled': False,
                    'message': 'HTTPS not enabled'
                }
        except Exception as e:
            return {
                'status': 'error',
                'ssl_enabled': False,
                'error': str(e)
            }
    
    def validate_password_strength(self, password: str) -> Dict[str, Any]:
        """Validate password strength"""
        score = 0
        issues = []
        
        if len(password) >= 12:
            score += 1
        else:
            issues.append('Password too short')
        
        if any(c.isupper() for c in password):
            score += 1
        else:
            issues.append('No uppercase letters')
        
        if any(c.islower() for c in password):
            score += 1
        else:
            issues.append('No lowercase letters')
        
        if any(c.isdigit() for c in password):
            score += 1
        else:
            issues.append('No numbers')
        
        if any(c in '!@#$%^&*()_+-=[]{}|;:,.<>?' for c in password):
            score += 1
        else:
            issues.append('No special characters')
        
        if score >= 4:
            return {'status': 'strong', 'score': score}
        elif score >= 3:
            return {'status': 'medium', 'score': score, 'issues': issues}
        else:
            return {'status': 'weak', 'score': score, 'issues': issues}
    
    def validate_vault_integration(self, file_path: str) -> Dict[str, Any]:
        """Validate vault integration in a file"""
        try:
            with open(file_path, 'r') as f:
                content = f.read()
            
            vault_patterns = [
                r'vault_.*_password',
                r'vault_.*_secret',
                r'vault_.*_token',
                r'vault_.*_key'
            ]
            
            vault_vars = []
            for pattern in vault_patterns:
                matches = re.findall(pattern, content)
                vault_vars.extend(matches)
            
            hardcoded_patterns = [
                r'password\s*=\s*["'][^"']*["']',
                r'localhost',
                r'admin@[^"\s]+',
                r'changeme'
            ]
            
            hardcoded_issues = []
            for pattern in hardcoded_patterns:
                matches = re.findall(pattern, content)
                if matches:
                    hardcoded_issues.extend(matches)
            
            return {
                'vault_variables': len(set(vault_vars)),
                'hardcoded_issues': len(hardcoded_issues),
                'status': 'valid' if not hardcoded_issues else 'issues_found'
            }
            
        except Exception as e:
            return {'status': 'error', 'error': str(e)}
    
    def run_comprehensive_validation(self) -> Dict[str, Any]:
        """Run comprehensive security validation"""
        results = {
            'ssl_validation': {},
            'password_validation': {},
            'vault_validation': {},
            'overall_status': 'unknown'
        }
        
        # Validate SSL for common services
        services = [
            'https://grafana.localhost',
            'https://prometheus.localhost',
            'https://sonarr.localhost',
            'https://radarr.localhost'
        ]
        
        for service in services:
            results['ssl_validation'][service] = self.validate_ssl_configuration(service)
        
        # Validate vault integration in key files
        key_files = [
            'group_vars/all/vault.yml',
            'roles/sonarr/defaults/main.yml',
            'roles/radarr/defaults/main.yml'
        ]
        
        for file_path in key_files:
            if Path(file_path).exists():
                results['vault_validation'][file_path] = self.validate_vault_integration(file_path)
        
        # Determine overall status
        all_valid = all(
            result.get('status') in ['valid', 'strong'] 
            for result in results['ssl_validation'].values()
        )
        
        results['overall_status'] = 'secure' if all_valid else 'needs_attention'
        
        return results

if __name__ == "__main__":
    validator = SecurityValidator()
    results = validator.run_comprehensive_validation()
    print(json.dumps(results, indent=2))
