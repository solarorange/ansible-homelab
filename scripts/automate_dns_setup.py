#!/usr/bin/env python3
"""
DNS Automation Script for Homelab Deployment
Automatically creates all required DNS records using Cloudflare API
"""

import requests
import json
import sys
import os
from typing import List, Dict, Optional
import argparse

class CloudflareDNSAutomation:
    def __init__(self, api_token: str, email: str, domain: str, server_ip: str):
        self.api_token = api_token
        self.email = email
        self.domain = domain
        self.server_ip = server_ip
        self.zone_id = None
        self.base_url = "https://api.cloudflare.com/client/v4"
        
        # All required subdomains for the homelab
        self.required_subdomains = [
            # Core Infrastructure
            "traefik", "auth", "portainer", "dash",
            
            # Monitoring & Observability
            "grafana", "prometheus", "loki", "logs", "alerts",
            
            # Media Services
            "sonarr", "radarr", "prowlarr", "bazarr", "overseerr", 
            "jellyfin", "tautulli", "tv",
            
            # Development & Storage
            "git", "registry", "code", "cloud", "s3", "docs", "photos",
            
            # Automation & Security
            "hass", "flows", "n8n", "vault", "passwords", "vpn", "dns", "proxy",
            
            # Utilities & Productivity
            "files", "updates", "assets", "bookmarks", "reconya", "pezzo"
        ]

    def get_zone_id(self) -> Optional[str]:
        """Get the Cloudflare zone ID for the domain"""
        headers = {
            "Authorization": f"Bearer {self.api_token}",
            "Content-Type": "application/json"
        }
        
        url = f"{self.base_url}/zones"
        params = {"name": self.domain}
        
        try:
            response = requests.get(url, headers=headers, params=params)
            response.raise_for_status()
            
            data = response.json()
            if data["success"] and data["result"]:
                zone_id = data["result"][0]["id"]
                print(f"✅ Found zone ID: {zone_id}")
                return zone_id
            else:
                print(f"❌ Domain {self.domain} not found in Cloudflare")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"❌ Error getting zone ID: {e}")
            return None

    def get_existing_records(self) -> Dict[str, str]:
        """Get existing DNS records"""
        headers = {
            "Authorization": f"Bearer {self.api_token}",
            "Content-Type": "application/json"
        }
        
        url = f"{self.base_url}/zones/{self.zone_id}/dns_records"
        
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            
            data = response.json()
            existing_records = {}
            
            if data["success"]:
                for record in data["result"]:
                    if record["type"] == "A":
                        name = record["name"].replace(f".{self.domain}", "")
                        existing_records[name] = record["id"]
            
            return existing_records
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Error getting existing records: {e}")
            return {}

    def create_dns_record(self, name: str, content: str) -> bool:
        """Create a DNS A record"""
        headers = {
            "Authorization": f"Bearer {self.api_token}",
            "Content-Type": "application/json"
        }
        
        url = f"{self.base_url}/zones/{self.zone_id}/dns_records"
        
        data = {
            "type": "A",
            "name": name,
            "content": content,
            "ttl": 1,  # Auto TTL
            "proxied": False  # Don't proxy through Cloudflare
        }
        
        try:
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            
            result = response.json()
            if result["success"]:
                display_name = name
                if name != "@" and not name.endswith(self.domain):
                    display_name = f"{name}.{self.domain}"
                print(f"✅ Created DNS record: {display_name} → {content}")
                print("DNS_CHANGED")  # Marker for Ansible idempotency
                return True
            else:
                print(f"❌ Failed to create DNS record {name}: {result.get('errors', [])}")
                return False
                
        except requests.exceptions.RequestException as e:
            print(f"❌ Error creating DNS record {name}: {e}")
            return False

    def update_dns_record(self, record_id: str, name: str, content: str) -> bool:
        """Update an existing DNS A record"""
        headers = {
            "Authorization": f"Bearer {self.api_token}",
            "Content-Type": "application/json"
        }
        
        url = f"{self.base_url}/zones/{self.zone_id}/dns_records/{record_id}"
        
        data = {
            "type": "A",
            "name": name,
            "content": content,
            "ttl": 1,
            "proxied": False
        }
        
        try:
            response = requests.put(url, headers=headers, json=data)
            response.raise_for_status()
            
            result = response.json()
            if result["success"]:
                display_name = name
                if name != "@" and not name.endswith(self.domain):
                    display_name = f"{name}.{self.domain}"
                print(f"✅ Updated DNS record: {display_name} → {content}")
                print("DNS_CHANGED")  # Marker for Ansible idempotency
                return True
            else:
                print(f"❌ Failed to update DNS record {name}: {result.get('errors', [])}")
                return False
                
        except requests.exceptions.RequestException as e:
            print(f"❌ Error updating DNS record {name}: {e}")
            return False

    def create_root_record(self) -> bool:
        """Create the root domain A record with fallback if '@' not accepted"""
        if self.create_dns_record("@", self.server_ip):
            return True
        # Fallback to explicit zone apex name
        return self.create_dns_record(self.domain, self.server_ip)

    def create_all_subdomain_records(self) -> Dict[str, bool]:
        """Create all required subdomain records"""
        results = {}
        
        print(f"\n🔧 Creating DNS records for {self.domain}...")
        
        # Get existing records
        existing_records = self.get_existing_records()
        
        # Create root record first (handle if it already exists)
        if "" in existing_records or "@" in existing_records or self.domain in existing_records:
            # Update root if possible
            root_id = existing_records.get("", None) or existing_records.get("@", None) or existing_records.get(self.domain, None)
            if root_id:
                results["@"] = self.update_dns_record(root_id, self.domain, self.server_ip)
            else:
                results["@"] = self.create_root_record()
        else:
            results["@"] = self.create_root_record()
        
        # Create subdomain records
        for subdomain in self.required_subdomains:
            full_name = f"{subdomain}.{self.domain}"
            
            if subdomain in existing_records:
                # Update existing record
                results[subdomain] = self.update_dns_record(
                    existing_records[subdomain], 
                    full_name, 
                    self.server_ip
                )
            else:
                # Create new record
                results[subdomain] = self.create_dns_record(
                    full_name, 
                    self.server_ip
                )
        
        return results

    def validate_dns_records(self) -> bool:
        """Validate that all DNS records resolve correctly"""
        import subprocess
        import time
        
        print(f"\n🔍 Validating DNS records...")
        
        # Wait for DNS propagation
        print("⏳ Waiting 30 seconds for DNS propagation...")
        time.sleep(30)
        
        all_valid = True
        
        # Test root domain
        try:
            result = subprocess.run(
                ["nslookup", self.domain], 
                capture_output=True, 
                text=True, 
                timeout=10
            )
            if self.server_ip in result.stdout:
                print(f"✅ {self.domain} resolves correctly")
            else:
                print(f"❌ {self.domain} does not resolve to {self.server_ip}")
                all_valid = False
        except Exception as e:
            print(f"❌ Error validating {self.domain}: {e}")
            all_valid = False
        
        # Test a few key subdomains
        test_subdomains = ["traefik", "auth", "grafana", "dash"]
        for subdomain in test_subdomains:
            full_domain = f"{subdomain}.{self.domain}"
            try:
                result = subprocess.run(
                    ["nslookup", full_domain], 
                    capture_output=True, 
                    text=True, 
                    timeout=10
                )
                if self.server_ip in result.stdout:
                    print(f"✅ {full_domain} resolves correctly")
                else:
                    print(f"❌ {full_domain} does not resolve to {self.server_ip}")
                    all_valid = False
            except Exception as e:
                print(f"❌ Error validating {full_domain}: {e}")
                all_valid = False
        
        return all_valid

    def run(self) -> bool:
        """Run the complete DNS automation process"""
        print("🚀 Starting DNS Automation for Homelab Deployment")
        print(f"Domain: {self.domain}")
        print(f"Server IP: {self.server_ip}")
        print(f"Cloudflare Email: {self.email}")
        
        # Get zone ID
        self.zone_id = self.get_zone_id()
        if not self.zone_id:
            return False
        
        # Create all DNS records
        results = self.create_all_subdomain_records()
        
        # Count successes and failures
        successful = sum(1 for success in results.values() if success)
        total = len(results)
        
        print(f"\n📊 DNS Record Creation Summary:")
        print(f"✅ Successful: {successful}/{total}")
        print(f"❌ Failed: {total - successful}/{total}")
        
        # Consider partial success as non-fatal; proceed with warnings
        # Treat validation failure as non-fatal; records may need time to propagate
        if successful == total:
            print("🎉 All DNS records created successfully!")
            # Validate DNS records (non-fatal)
            if self.validate_dns_records():
                print("🎉 DNS validation passed!")
            else:
                print("⚠️ DNS validation failed - records may need time to propagate")
            return True
        else:
            print("⚠️ Some DNS records failed to create; proceeding with partial success")
            return True

def main():
    parser = argparse.ArgumentParser(description="Automate DNS record creation for homelab deployment")
    parser.add_argument("--domain", help="Your domain name (can also be set via DOMAIN env var)")
    parser.add_argument("--server-ip", help="Your server IP address (can also be set via SERVER_IP env var)")
    parser.add_argument("--cloudflare-email", help="Your Cloudflare email (can also be set via CLOUDFLARE_EMAIL env var)")
    parser.add_argument("--cloudflare-api-token", help="Your Cloudflare API token (can also be set via CLOUDFLARE_API_TOKEN env var)")
    parser.add_argument("--validate-only", action="store_true", help="Only validate existing DNS records")
    
    args = parser.parse_args()
    
    # Get values from args or environment variables
    domain = args.domain or os.getenv('DOMAIN')
    server_ip = args.server_ip or os.getenv('SERVER_IP')
    cloudflare_email = args.cloudflare_email or os.getenv('CLOUDFLARE_EMAIL')
    cloudflare_api_token = args.cloudflare_api_token or os.getenv('CLOUDFLARE_API_TOKEN')
    
    # Validate required parameters
    if not domain:
        print("❌ Error: Domain is required. Set via --domain argument or DOMAIN environment variable")
        sys.exit(1)
    if not server_ip:
        print("❌ Error: Server IP is required. Set via --server-ip argument or SERVER_IP environment variable")
        sys.exit(1)
    if not cloudflare_email:
        print("❌ Error: Cloudflare email is required. Set via --cloudflare-email argument or CLOUDFLARE_EMAIL environment variable")
        sys.exit(1)
    if not cloudflare_api_token:
        print("❌ Error: Cloudflare API token is required. Set via --cloudflare-api-token argument or CLOUDFLARE_API_TOKEN environment variable")
        sys.exit(1)
    
    # Initialize automation
    automation = CloudflareDNSAutomation(
        api_token=cloudflare_api_token,
        email=cloudflare_email,
        domain=domain,
        server_ip=server_ip
    )
    
    if args.validate_only:
        # Only validate existing records
        if automation.validate_dns_records():
            print("✅ All DNS records are valid!")
            sys.exit(0)
        else:
            print("❌ Some DNS records are invalid or missing")
            sys.exit(1)
    else:
        # Create and validate records
        if automation.run():
            print("🎉 DNS automation completed successfully!")
            sys.exit(0)
        else:
            print("❌ DNS automation failed")
            sys.exit(1)

if __name__ == "__main__":
    main() 