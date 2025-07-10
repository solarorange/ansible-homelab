#!/usr/bin/env python3
"""
Infrastructure Validation Script
Validates DNS records, firewall rules, and SSL certificates
Used by Ansible validation tasks for comprehensive infrastructure checks
"""

import argparse
import json
import socket
import ssl
import subprocess
import sys
import time
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
import urllib.request
import urllib.error


class ValidationError(Exception):
    """Custom exception for validation errors"""
    pass


class InfrastructureValidator:
    """Main validation class for infrastructure checks"""
    
    def __init__(self, domain: str, server_ip: str, verbose: bool = False):
        self.domain = domain
        self.server_ip = server_ip
        self.verbose = verbose
        self.errors = []
        self.warnings = []
        
        # Define domains to validate based on common homelab services
        self.domains_to_validate = [
            domain,
            f"traefik.{domain}",
            f"auth.{domain}",
            f"grafana.{domain}",
            f"pihole.{domain}",
            f"homepage.{domain}",
            f"portainer.{domain}",
            f"sonarr.{domain}",
            f"radarr.{domain}",
            f"jellyfin.{domain}",
            f"overseerr.{domain}",
            f"nextcloud.{domain}",
            f"git.{domain}",
            f"vault.{domain}",
            f"vpn.{domain}",
        ]
        
        # Expected firewall rules
        self.expected_firewall_rules = [
            {"port": "22", "protocol": "tcp", "description": "SSH"},
            {"port": "80", "protocol": "tcp", "description": "HTTP"},
            {"port": "443", "protocol": "tcp", "description": "HTTPS"},
            {"port": "53", "protocol": "tcp", "description": "DNS TCP"},
            {"port": "53", "protocol": "udp", "description": "DNS UDP"},
            {"port": "51820", "protocol": "udp", "description": "WireGuard VPN"},
        ]
        
        # Critical ports that should be blocked
        self.critical_ports_to_block = [
            "21",    # FTP
            "23",    # Telnet
            "25",    # SMTP
            "110",   # POP3
            "143",   # IMAP
            "3306",  # MySQL (if not needed externally)
            "5432",  # PostgreSQL (if not needed externally)
            "6379",  # Redis (if not needed externally)
            "27017", # MongoDB (if not needed externally)
        ]

    def log(self, message: str, level: str = "INFO"):
        """Log messages with timestamp"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {level}: {message}")

    def run_command(self, command: List[str], capture_output: bool = True) -> Tuple[int, str, str]:
        """Run a shell command and return results"""
        try:
            result = subprocess.run(
                command,
                capture_output=capture_output,
                text=True,
                timeout=30
            )
            return result.returncode, result.stdout, result.stderr
        except subprocess.TimeoutExpired:
            return -1, "", "Command timed out"
        except Exception as e:
            return -1, "", str(e)

    def validate_dns_records(self) -> bool:
        """Validate DNS records exist and resolve to correct IP"""
        self.log("Starting DNS record validation...")
        success = True
        
        for domain in self.domains_to_validate:
            try:
                # Use nslookup for DNS resolution
                rc, stdout, stderr = self.run_command(["nslookup", domain])
                
                if rc != 0:
                    self.errors.append(f"DNS resolution failed for {domain}: {stderr}")
                    success = False
                    continue
                
                # Extract IP address from nslookup output
                lines = stdout.split('\n')
                resolved_ip = None
                for line in lines:
                    if 'Address:' in line and not line.strip().startswith('#'):
                        parts = line.split('Address:')
                        if len(parts) > 1:
                            resolved_ip = parts[1].strip()
                            break
                
                if not resolved_ip:
                    self.errors.append(f"Could not extract IP address for {domain}")
                    success = False
                    continue
                
                if resolved_ip != self.server_ip:
                    self.errors.append(
                        f"DNS record for {domain} resolves to {resolved_ip}, expected {self.server_ip}"
                    )
                    success = False
                else:
                    self.log(f"✅ DNS record for {domain} resolves correctly to {resolved_ip}")
                    
            except Exception as e:
                self.errors.append(f"Error validating DNS for {domain}: {str(e)}")
                success = False
        
        return success

    def validate_firewall_rules(self) -> bool:
        """Validate firewall rules are properly configured"""
        self.log("Starting firewall rules validation...")
        success = True
        
        # Check if UFW is enabled
        rc, stdout, stderr = self.run_command(["ufw", "status", "numbered"])
        if rc != 0:
            self.errors.append("UFW is not enabled or accessible")
            return False
        
        if "Status: active" not in stdout:
            self.errors.append("UFW is not active")
            success = False
        
        # Check expected firewall rules
        for rule in self.expected_firewall_rules:
            pattern = f"{rule['port']}/{rule['protocol']}"
            if pattern not in stdout or "ALLOW" not in stdout:
                self.errors.append(
                    f"Required firewall rule for {rule['description']} "
                    f"({rule['port']}/{rule['protocol']}) is missing or not configured as ALLOW"
                )
                success = False
            else:
                self.log(f"✅ Firewall rule for {rule['description']} ({rule['port']}/{rule['protocol']}) is configured")
        
        # Check critical ports are blocked
        for port in self.critical_ports_to_block:
            pattern = f"{port}/"
            if pattern in stdout and "ALLOW" in stdout:
                self.warnings.append(f"Critical port {port} is open and should be blocked for security")
                # Don't fail the validation for warnings, but log them
        
        return success

    def validate_ssl_certificates(self) -> bool:
        """Validate SSL certificates for all domains"""
        self.log("Starting SSL certificate validation...")
        success = True
        
        for domain in self.domains_to_validate:
            try:
                # Create SSL context
                context = ssl.create_default_context()
                context.check_hostname = True
                context.verify_mode = ssl.CERT_REQUIRED
                
                # Connect and get certificate
                with socket.create_connection((domain, 443), timeout=10) as sock:
                    with context.wrap_socket(sock, server_hostname=domain) as ssock:
                        cert = ssock.getpeercert()
                        
                        # Check certificate expiration
                        not_after = datetime.strptime(cert['notAfter'], '%b %d %H:%M:%S %Y %Z')
                        days_until_expiry = (not_after - datetime.now()).days
                        
                        if days_until_expiry <= 0:
                            self.errors.append(f"SSL certificate for {domain} is expired")
                            success = False
                        elif days_until_expiry <= 30:
                            self.warnings.append(
                                f"SSL certificate for {domain} will expire in {days_until_expiry} days"
                            )
                        else:
                            self.log(f"✅ SSL certificate for {domain} is valid for {days_until_expiry} days")
                        
                        # Check certificate subject matches domain
                        subject = dict(x[0] for x in cert['subject'])
                        common_name = subject.get('commonName', '')
                        
                        if domain not in common_name and not any(
                            domain.endswith(cn) for cn in common_name.split('.')
                        ):
                            self.errors.append(
                                f"SSL certificate for {domain} does not match domain name. "
                                f"Certificate CN: {common_name}"
                            )
                            success = False
                        else:
                            self.log(f"✅ SSL certificate for {domain} matches domain name")
                            
            except ssl.SSLError as e:
                self.errors.append(f"SSL error for {domain}: {str(e)}")
                success = False
            except socket.gaierror:
                self.errors.append(f"Could not resolve {domain} for SSL validation")
                success = False
            except socket.timeout:
                self.errors.append(f"Timeout connecting to {domain} for SSL validation")
                success = False
            except Exception as e:
                self.errors.append(f"Error validating SSL for {domain}: {str(e)}")
                success = False
        
        return success

    def validate_traefik_status(self) -> bool:
        """Validate Traefik is running and properly configured"""
        self.log("Starting Traefik validation...")
        success = True
        
        # Check if Traefik container is running
        rc, stdout, stderr = self.run_command(["docker", "ps", "--filter", "name=traefik", "--format", "{{.Status}}"])
        if rc != 0 or "Up" not in stdout:
            self.errors.append("Traefik container is not running")
            success = False
        else:
            self.log("✅ Traefik container is running")
        
        # Check Traefik API health
        try:
            with urllib.request.urlopen("http://localhost:8080/api/health", timeout=10) as response:
                if response.getcode() == 200:
                    self.log("✅ Traefik API is responding")
                else:
                    self.errors.append(f"Traefik API returned status code {response.getcode()}")
                    success = False
        except Exception as e:
            self.errors.append(f"Traefik API is not accessible: {str(e)}")
            success = False
        
        # Check certificate resolvers
        try:
            with urllib.request.urlopen("http://localhost:8080/api/http/certresolvers", timeout=10) as response:
                if response.getcode() == 200:
                    data = json.loads(response.read().decode())
                    resolvers = list(data.keys())
                    if any(resolver in resolvers for resolver in ['cloudflare', 'letsencrypt']):
                        self.log("✅ Traefik certificate resolver is configured")
                    else:
                        self.errors.append("Traefik certificate resolver is not properly configured")
                        success = False
                else:
                    self.errors.append(f"Traefik cert resolvers API returned status code {response.getcode()}")
                    success = False
        except Exception as e:
            self.errors.append(f"Could not check Traefik certificate resolvers: {str(e)}")
            success = False
        
        return success

    def run_all_validations(self) -> bool:
        """Run all validation checks"""
        self.log("Starting comprehensive infrastructure validation...")
        
        validations = [
            ("DNS Records", self.validate_dns_records),
            ("Firewall Rules", self.validate_firewall_rules),
            ("SSL Certificates", self.validate_ssl_certificates),
            ("Traefik Status", self.validate_traefik_status),
        ]
        
        overall_success = True
        
        for name, validation_func in validations:
            try:
                if not validation_func():
                    overall_success = False
            except Exception as e:
                self.errors.append(f"Error during {name} validation: {str(e)}")
                overall_success = False
        
        return overall_success

    def print_summary(self):
        """Print validation summary"""
        print("\n" + "="*80)
        print("INFRASTRUCTURE VALIDATION SUMMARY")
        print("="*80)
        
        if self.errors:
            print("\n❌ ERRORS:")
            for error in self.errors:
                print(f"  • {error}")
        
        if self.warnings:
            print("\n⚠️  WARNINGS:")
            for warning in self.warnings:
                print(f"  • {warning}")
        
        if not self.errors and not self.warnings:
            print("\n✅ ALL VALIDATIONS PASSED")
            print("Infrastructure is properly configured and ready for deployment.")
        elif self.errors:
            print(f"\n❌ VALIDATION FAILED: {len(self.errors)} error(s) found")
            print("Please fix the issues above before proceeding with deployment.")
        else:
            print(f"\n⚠️  VALIDATION COMPLETED WITH WARNINGS: {len(self.warnings)} warning(s)")
            print("Deployment can proceed, but consider addressing the warnings.")
        
        print("="*80)


def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="Infrastructure validation script")
    parser.add_argument("--domain", required=True, help="Main domain name")
    parser.add_argument("--server-ip", required=True, help="Server IP address")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    parser.add_argument("--output", "-o", help="Output results to JSON file")
    
    args = parser.parse_args()
    
    validator = InfrastructureValidator(args.domain, args.server_ip, args.verbose)
    
    try:
        success = validator.run_all_validations()
        validator.print_summary()
        
        # Output to JSON if requested
        if args.output:
            result = {
                "timestamp": datetime.now().isoformat(),
                "domain": args.domain,
                "server_ip": args.server_ip,
                "success": success,
                "errors": validator.errors,
                "warnings": validator.warnings
            }
            
            with open(args.output, 'w') as f:
                json.dump(result, f, indent=2)
        
        # Exit with appropriate code
        sys.exit(0 if success else 1)
        
    except KeyboardInterrupt:
        print("\nValidation interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 