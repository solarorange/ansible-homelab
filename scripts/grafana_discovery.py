#!/usr/bin/env python3
"""
Service Discovery Script for Grafana
Automatically discovers and configures grafana service
"""

import requests
import json
import time
from typing import Dict, Any

class GrafanaDiscovery:
    def __init__(self, host: str, port: int, api_key: str = None):
        self.host = host
        self.port = port
        self.api_key = api_key
        self.base_url = f"http://{host}:{port}"
        
    def discover_service(self) -> Dict[str, Any]:
        """Discover grafana service configuration"""
        try:
            # Health check
            health_url = f"{self.base_url}/health"
            response = requests.get(health_url, timeout=10)
            
            if response.status_code == 200:
                return {
                    "status": "healthy",
                    "url": self.base_url,
                    "version": self.get_version(),
                    "configuration": self.get_configuration()
                }
            else:
                return {
                    "status": "unhealthy",
                    "url": self.base_url,
                    "error": f"HTTP {response.status_code}"
                }
                
        except Exception as e:
            return {
                "status": "error",
                "url": self.base_url,
                "error": str(e)
            }
    
    def get_version(self) -> str:
        """Get grafana version"""
        try:
            version_url = f"{self.base_url}/api/system/status"
            response = requests.get(version_url, timeout=5)
            if response.status_code == 200:
                data = response.json()
                return data.get("version", "unknown")
        except:
            pass
        return "unknown"
    
    def get_configuration(self) -> Dict[str, Any]:
        """Get grafana configuration"""
        try:
            config_url = f"{self.base_url}/api/config"
            response = requests.get(config_url, timeout=5)
            if response.status_code == 200:
                return response.json()
        except:
            pass
        return {}

if __name__ == "__main__":
    # Example usage
    discovery = GrafanaDiscovery("{{ ansible_default_ipv4.address }}", 8080)
    result = discovery.discover_service()
    print(json.dumps(result, indent=2))
