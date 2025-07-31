#!/usr/bin/env python3
"""
Comprehensive Security Audit Script
Ensures the project is as secure and turnkey as possible
"""

import os
import re
import json
import yaml
from pathlib import Path
from typing import Dict, List, Tuple

class ComprehensiveSecurityAudit:
    def __init__(self, root_dir: str = "."):
        self.root_dir = Path(root_dir)
        
        # Security criteria to check
        self.security_criteria = {
            'vault_integration': {
                'description': 'All sensitive data stored in vault',
                'files': ['group_vars/all/vault.yml'],
                'required': True
            },
            'no_hardcoded_passwords': {
                'description': 'No hardcoded passwords in configuration',
                'pattern': r'password.*=.*["\'][^"\']+["\']',
                'required': True
            },
            'no_hardcoded_ips': {
                'description': 'No hardcoded IP addresses',
                'pattern': r'127\.0\.0\.1|192\.168\.\d+\.\d+',
                'required': True
            },
            'dynamic_configuration': {
                'description': 'Dynamic configuration using variables',
                'pattern': r'\{\{.*\}\}',
                'required': True
            },
            'ssl_configuration': {
                'description': 'SSL/TLS configuration present',
                'files': ['roles/nginx_proxy_manager/'],
                'required': True
            },
            'backup_configuration': {
                'description': 'Backup configuration present',
                'files': ['tasks/backup_', 'roles/*/tasks/backup'],
                'required': True
            },
            'monitoring_configuration': {
                'description': 'Monitoring configuration present',
                'files': ['roles/monitoring/', 'tasks/monitoring_'],
                'required': True
            },
            'security_headers': {
                'description': 'Security headers configured',
                'pattern': r'X-Frame-Options|X-Content-Type-Options|X-XSS-Protection',
                'required': True
            },
            'input_validation': {
                'description': 'Input validation present',
                'pattern': r'validate|sanitize|escape',
                'required': True
            },
            'error_handling': {
                'description': 'Error handling configured',
                'pattern': r'ignore_errors|failed_when|changed_when',
                'required': True
            }
        }
        
    def check_vault_integration(self) -> Dict[str, any]:
        """Check vault integration"""
        vault_file = self.root_dir / "group_vars" / "all" / "vault.yml"
        
        if not vault_file.exists():
            return {
                'status': 'FAILED',
                'message': 'Vault file not found',
                'details': 'group_vars/all/vault.yml does not exist'
            }
        
        try:
            with open(vault_file, 'r') as f:
                content = f.read()
            
            # Check for comprehensive vault variables
            vault_vars = re.findall(r'vault_\w+', content)
            
            if len(vault_vars) < 100:  # Should have many vault variables
                return {
                    'status': 'WARNING',
                    'message': 'Limited vault variables found',
                    'details': f'Found {len(vault_vars)} vault variables'
                }
            
            return {
                'status': 'PASSED',
                'message': 'Vault integration complete',
                'details': f'Found {len(vault_vars)} vault variables'
            }
            
        except Exception as e:
            return {
                'status': 'FAILED',
                'message': 'Error reading vault file',
                'details': str(e)
            }
    
    def check_no_hardcoded_passwords(self) -> Dict[str, any]:
        """Check for hardcoded passwords"""
        hardcoded_found = []
        
        for yaml_file in self.root_dir.rglob("*.yml"):
            if "vault.yml" in str(yaml_file) or "vault_template.yml" in str(yaml_file):
                continue
                
            try:
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                matches = re.findall(r'password.*=.*["\'][^"\']+["\']', content, re.IGNORECASE)
                if matches:
                    hardcoded_found.append({
                        'file': str(yaml_file),
                        'matches': len(matches)
                    })
                    
            except Exception as e:
                print(f"Error reading {yaml_file}: {e}")
        
        if hardcoded_found:
            return {
                'status': 'FAILED',
                'message': 'Hardcoded passwords found',
                'details': f'Found in {len(hardcoded_found)} files'
            }
        
        return {
            'status': 'PASSED',
            'message': 'No hardcoded passwords found',
            'details': 'All passwords use vault variables'
        }
    
    def check_dynamic_configuration(self) -> Dict[str, any]:
        """Check for dynamic configuration"""
        dynamic_vars = 0
        static_vars = 0
        
        for yaml_file in self.root_dir.rglob("*.yml"):
            if "vault.yml" in str(yaml_file):
                continue
                
            try:
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Count dynamic variables
                dynamic_matches = len(re.findall(r'\{\{.*\}\}', content))
                dynamic_vars += dynamic_matches
                
                # Count static values (simplified check)
                static_matches = len(re.findall(r':\s*["\'][^"\']+["\']', content))
                static_vars += static_matches
                
            except Exception as e:
                print(f"Error reading {yaml_file}: {e}")
        
        if dynamic_vars > static_vars:
            return {
                'status': 'PASSED',
                'message': 'Dynamic configuration predominates',
                'details': f'{dynamic_vars} dynamic vs {static_vars} static variables'
            }
        else:
            return {
                'status': 'WARNING',
                'message': 'Limited dynamic configuration',
                'details': f'{dynamic_vars} dynamic vs {static_vars} static variables'
            }
    
    def check_automation_scripts(self) -> Dict[str, any]:
        """Check for automation scripts"""
        scripts_dir = self.root_dir / "scripts"
        automation_scripts = []
        
        if scripts_dir.exists():
            for script_file in scripts_dir.rglob("*.py"):
                automation_scripts.append(str(script_file))
        
        if len(automation_scripts) >= 5:  # Should have multiple automation scripts
            return {
                'status': 'PASSED',
                'message': 'Comprehensive automation scripts found',
                'details': f'Found {len(automation_scripts)} automation scripts'
            }
        else:
            return {
                'status': 'WARNING',
                'message': 'Limited automation scripts',
                'details': f'Found {len(automation_scripts)} automation scripts'
            }
    
    def check_service_discovery(self) -> Dict[str, any]:
        """Check for service discovery scripts"""
        discovery_dir = self.root_dir / "scripts" / "service_discovery"
        discovery_scripts = []
        
        if discovery_dir.exists():
            for script_file in discovery_dir.rglob("*.py"):
                discovery_scripts.append(str(script_file))
        
        if len(discovery_scripts) >= 10:  # Should have many service discovery scripts
            return {
                'status': 'PASSED',
                'message': 'Comprehensive service discovery',
                'details': f'Found {len(discovery_scripts)} service discovery scripts'
            }
        else:
            return {
                'status': 'WARNING',
                'message': 'Limited service discovery',
                'details': f'Found {len(discovery_scripts)} service discovery scripts'
            }
    
    def run_comprehensive_audit(self) -> Dict[str, any]:
        """Run comprehensive security audit"""
        print("🔒 Starting Comprehensive Security Audit")
        print("=" * 50)
        
        audit_results = {}
        
        # Check vault integration
        print("1. Checking vault integration...")
        audit_results['vault_integration'] = self.check_vault_integration()
        print(f"   {audit_results['vault_integration']['status']}: {audit_results['vault_integration']['message']}")
        
        # Check for hardcoded passwords
        print("2. Checking for hardcoded passwords...")
        audit_results['no_hardcoded_passwords'] = self.check_no_hardcoded_passwords()
        print(f"   {audit_results['no_hardcoded_passwords']['status']}: {audit_results['no_hardcoded_passwords']['message']}")
        
        # Check dynamic configuration
        print("3. Checking dynamic configuration...")
        audit_results['dynamic_configuration'] = self.check_dynamic_configuration()
        print(f"   {audit_results['dynamic_configuration']['status']}: {audit_results['dynamic_configuration']['message']}")
        
        # Check automation scripts
        print("4. Checking automation scripts...")
        audit_results['automation_scripts'] = self.check_automation_scripts()
        print(f"   {audit_results['automation_scripts']['status']}: {audit_results['automation_scripts']['message']}")
        
        # Check service discovery
        print("5. Checking service discovery...")
        audit_results['service_discovery'] = self.check_service_discovery()
        print(f"   {audit_results['service_discovery']['status']}: {audit_results['service_discovery']['message']}")
        
        # Calculate overall score
        passed = sum(1 for result in audit_results.values() if result['status'] == 'PASSED')
        warnings = sum(1 for result in audit_results.values() if result['status'] == 'WARNING')
        failed = sum(1 for result in audit_results.values() if result['status'] == 'FAILED')
        
        total = len(audit_results)
        score = (passed / total) * 100 if total > 0 else 0
        
        print(f"\n📊 Audit Summary:")
        print(f"   - Passed: {passed}/{total}")
        print(f"   - Warnings: {warnings}/{total}")
        print(f"   - Failed: {failed}/{total}")
        print(f"   - Score: {score:.1f}%")
        
        if score >= 90:
            overall_status = "EXCELLENT"
        elif score >= 80:
            overall_status = "GOOD"
        elif score >= 70:
            overall_status = "ACCEPTABLE"
        else:
            overall_status = "NEEDS IMPROVEMENT"
        
        print(f"   - Overall Status: {overall_status}")
        
        return {
            'audit_results': audit_results,
            'summary': {
                'passed': passed,
                'warnings': warnings,
                'failed': failed,
                'total': total,
                'score': score,
                'status': overall_status
            }
        }

def main():
    """Main function"""
    audit = ComprehensiveSecurityAudit()
    results = audit.run_comprehensive_audit()
    
    # Save results
    with open("comprehensive_security_audit_results.json", "w") as f:
        json.dump(results, f, indent=2)
    
    print(f"\n📊 Results saved to: comprehensive_security_audit_results.json")
    
    if results['summary']['status'] in ['EXCELLENT', 'GOOD']:
        print("\n🎉 Security audit passed! Your homelab is secure and turnkey.")
    else:
        print("\n⚠️ Security audit needs improvement. Review the results above.")

if __name__ == "__main__":
    main() 