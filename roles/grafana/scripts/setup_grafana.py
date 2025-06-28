#!/usr/bin/env python3
"""
Grafana Configuration Script
Comprehensive automation for Grafana setup via REST API

This script configures:
- Data sources (Prometheus, Loki, PostgreSQL, Redis, etc.)
- Dashboard folders and dashboards
- Users and teams
- Alert rules and notification channels
- Theme and preferences
"""

import json
import requests
import time
import sys
import os
import argparse
from typing import Dict, List, Any, Optional
from dataclasses import dataclass
from pathlib import Path


@dataclass
class GrafanaConfig:
    """Configuration for Grafana connection"""
    url: str
    username: str
    password: str
    timeout: int = 30
    verify_ssl: bool = True


class GrafanaAPI:
    """Grafana REST API client"""
    
    def __init__(self, config: GrafanaConfig):
        self.config = config
        self.session = requests.Session()
        self.session.auth = (config.username, config.password)
        self.session.verify = config.verify_ssl
        self.session.timeout = config.timeout
        self.base_url = config.url.rstrip('/')
        
    def _make_request(self, method: str, endpoint: str, data: Optional[Dict] = None) -> Dict:
        """Make HTTP request to Grafana API"""
        url = f"{self.base_url}/api{endpoint}"
        headers = {'Content-Type': 'application/json'}
        
        try:
            if method.upper() == 'GET':
                response = self.session.get(url, headers=headers)
            elif method.upper() == 'POST':
                response = self.session.post(url, headers=headers, json=data)
            elif method.upper() == 'PUT':
                response = self.session.put(url, headers=headers, json=data)
            elif method.upper() == 'DELETE':
                response = self.session.delete(url, headers=headers)
            else:
                raise ValueError(f"Unsupported HTTP method: {method}")
            
            response.raise_for_status()
            return response.json() if response.content else {}
            
        except requests.exceptions.RequestException as e:
            print(f"API request failed: {e}")
            return {}
    
    def health_check(self) -> bool:
        """Check if Grafana is healthy"""
        try:
            response = self.session.get(f"{self.base_url}/api/health")
            return response.status_code == 200
        except:
            return False
    
    def get_data_sources(self) -> List[Dict]:
        """Get all data sources"""
        return self._make_request('GET', '/datasources')
    
    def create_data_source(self, datasource: Dict) -> Dict:
        """Create a new data source"""
        return self._make_request('POST', '/datasources', datasource)
    
    def update_data_source(self, datasource_id: int, datasource: Dict) -> Dict:
        """Update an existing data source"""
        return self._make_request('PUT', f'/datasources/{datasource_id}', datasource)
    
    def delete_data_source(self, datasource_id: int) -> bool:
        """Delete a data source"""
        result = self._make_request('DELETE', f'/datasources/{datasource_id}')
        return bool(result)
    
    def get_folders(self) -> List[Dict]:
        """Get all dashboard folders"""
        return self._make_request('GET', '/folders')
    
    def create_folder(self, folder: Dict) -> Dict:
        """Create a new dashboard folder"""
        return self._make_request('POST', '/folders', folder)
    
    def get_dashboards(self, folder_id: Optional[int] = None) -> List[Dict]:
        """Get all dashboards"""
        endpoint = '/search'
        if folder_id:
            endpoint += f'?folderIds={folder_id}'
        return self._make_request('GET', endpoint)
    
    def create_dashboard(self, dashboard: Dict) -> Dict:
        """Create a new dashboard"""
        return self._make_request('POST', '/dashboards/db', dashboard)
    
    def get_users(self) -> List[Dict]:
        """Get all users"""
        return self._make_request('GET', '/admin/users')
    
    def create_user(self, user: Dict) -> Dict:
        """Create a new user"""
        return self._make_request('POST', '/admin/users', user)
    
    def get_teams(self) -> List[Dict]:
        """Get all teams"""
        return self._make_request('GET', '/teams/search')
    
    def create_team(self, team: Dict) -> Dict:
        """Create a new team"""
        return self._make_request('POST', '/teams', team)
    
    def get_notification_channels(self) -> List[Dict]:
        """Get all notification channels"""
        return self._make_request('GET', '/alert-notifications')
    
    def create_notification_channel(self, channel: Dict) -> Dict:
        """Create a new notification channel"""
        return self._make_request('POST', '/alert-notifications', channel)
    
    def get_alert_rules(self) -> List[Dict]:
        """Get all alert rules"""
        return self._make_request('GET', '/alerts')
    
    def create_alert_rule(self, rule: Dict) -> Dict:
        """Create a new alert rule"""
        return self._make_request('POST', '/alerts', rule)


class GrafanaSetup:
    """Main Grafana setup class"""
    
    def __init__(self, config: GrafanaConfig, config_dir: str = "config"):
        self.api = GrafanaAPI(config)
        self.config_dir = Path(config_dir)
        
    def wait_for_grafana(self, max_wait: int = 300) -> bool:
        """Wait for Grafana to be ready"""
        print("Waiting for Grafana to be ready...")
        start_time = time.time()
        
        while time.time() - start_time < max_wait:
            if self.api.health_check():
                print("Grafana is ready!")
                return True
            time.sleep(5)
        
        print("Timeout waiting for Grafana")
        return False
    
    def setup_data_sources(self, datasources: List[Dict]) -> bool:
        """Setup data sources"""
        print("Setting up data sources...")
        
        existing_ds = {ds['name']: ds for ds in self.api.get_data_sources()}
        
        for ds_config in datasources:
            name = ds_config['name']
            
            if name in existing_ds:
                print(f"Updating data source: {name}")
                result = self.api.update_data_source(existing_ds[name]['id'], ds_config)
            else:
                print(f"Creating data source: {name}")
                result = self.api.create_data_source(ds_config)
            
            if not result:
                print(f"Failed to configure data source: {name}")
                return False
        
        print("Data sources configured successfully")
        return True
    
    def setup_folders(self, folders: List[Dict]) -> Dict[str, int]:
        """Setup dashboard folders"""
        print("Setting up dashboard folders...")
        
        existing_folders = {f['title']: f for f in self.api.get_folders()}
        folder_ids = {}
        
        for folder_config in folders:
            title = folder_config['title']
            
            if title in existing_folders:
                folder_ids[title] = existing_folders[title]['id']
                print(f"Folder exists: {title}")
            else:
                result = self.api.create_folder(folder_config)
                if result and 'id' in result:
                    folder_ids[title] = result['id']
                    print(f"Created folder: {title}")
                else:
                    print(f"Failed to create folder: {title}")
        
        return folder_ids
    
    def setup_dashboards(self, dashboards: List[Dict], folder_ids: Dict[str, int]) -> bool:
        """Setup dashboards"""
        print("Setting up dashboards...")
        
        for dashboard_config in dashboards:
            title = dashboard_config['dashboard']['title']
            folder_title = dashboard_config.get('folderTitle', 'General')
            
            # Set folder ID if specified
            if folder_title in folder_ids:
                dashboard_config['folderId'] = folder_ids[folder_title]
            
            result = self.api.create_dashboard(dashboard_config)
            if result:
                print(f"Created dashboard: {title}")
            else:
                print(f"Failed to create dashboard: {title}")
                return False
        
        print("Dashboards configured successfully")
        return True
    
    def setup_users(self, users: List[Dict]) -> bool:
        """Setup users"""
        print("Setting up users...")
        
        existing_users = {u['login']: u for u in self.api.get_users()}
        
        for user_config in users:
            login = user_config['login']
            
            if login in existing_users:
                print(f"User exists: {login}")
            else:
                result = self.api.create_user(user_config)
                if result:
                    print(f"Created user: {login}")
                else:
                    print(f"Failed to create user: {login}")
                    return False
        
        print("Users configured successfully")
        return True
    
    def setup_teams(self, teams: List[Dict]) -> bool:
        """Setup teams"""
        print("Setting up teams...")
        
        existing_teams = {t['name']: t for t in self.api.get_teams()}
        
        for team_config in teams:
            name = team_config['name']
            
            if name in existing_teams:
                print(f"Team exists: {name}")
            else:
                result = self.api.create_team(team_config)
                if result:
                    print(f"Created team: {name}")
                else:
                    print(f"Failed to create team: {name}")
                    return False
        
        print("Teams configured successfully")
        return True
    
    def setup_notification_channels(self, channels: List[Dict]) -> bool:
        """Setup notification channels"""
        print("Setting up notification channels...")
        
        existing_channels = {c['name']: c for c in self.api.get_notification_channels()}
        
        for channel_config in channels:
            name = channel_config['name']
            
            if name in existing_channels:
                print(f"Notification channel exists: {name}")
            else:
                result = self.api.create_notification_channel(channel_config)
                if result:
                    print(f"Created notification channel: {name}")
                else:
                    print(f"Failed to create notification channel: {name}")
                    return False
        
        print("Notification channels configured successfully")
        return True
    
    def setup_alert_rules(self, rules: List[Dict]) -> bool:
        """Setup alert rules"""
        print("Setting up alert rules...")
        
        for rule_config in rules:
            name = rule_config['name']
            
            result = self.api.create_alert_rule(rule_config)
            if result:
                print(f"Created alert rule: {name}")
            else:
                print(f"Failed to create alert rule: {name}")
                return False
        
        print("Alert rules configured successfully")
        return True
    
    def load_config_file(self, filename: str) -> Dict:
        """Load configuration from JSON file"""
        file_path = self.config_dir / filename
        if file_path.exists():
            with open(file_path, 'r') as f:
                return json.load(f)
        return {}
    
    def run_setup(self) -> bool:
        """Run complete Grafana setup"""
        print("Starting Grafana setup...")
        
        # Wait for Grafana to be ready
        if not self.wait_for_grafana():
            return False
        
        # Load configurations
        datasources = self.load_config_file('datasources.json')
        folders = self.load_config_file('folders.json')
        dashboards = self.load_config_file('dashboards.json')
        users = self.load_config_file('users.json')
        teams = self.load_config_file('teams.json')
        notification_channels = self.load_config_file('notification_channels.json')
        alert_rules = self.load_config_file('alert_rules.json')
        
        # Setup components
        if datasources and not self.setup_data_sources(datasources):
            return False
        
        folder_ids = {}
        if folders:
            folder_ids = self.setup_folders(folders)
        
        if dashboards and not self.setup_dashboards(dashboards, folder_ids):
            return False
        
        if users and not self.setup_users(users):
            return False
        
        if teams and not self.setup_teams(teams):
            return False
        
        if notification_channels and not self.setup_notification_channels(notification_channels):
            return False
        
        if alert_rules and not self.setup_alert_rules(alert_rules):
            return False
        
        print("Grafana setup completed successfully!")
        return True


def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='Grafana Configuration Script')
    parser.add_argument('--url', required=True, help='Grafana URL')
    parser.add_argument('--username', required=True, help='Grafana admin username')
    parser.add_argument('--password', required=True, help='Grafana admin password')
    parser.add_argument('--config-dir', default='config', help='Configuration directory')
    parser.add_argument('--timeout', type=int, default=30, help='Request timeout')
    parser.add_argument('--no-verify-ssl', action='store_true', help='Disable SSL verification')
    
    args = parser.parse_args()
    
    config = GrafanaConfig(
        url=args.url,
        username=args.username,
        password=args.password,
        timeout=args.timeout,
        verify_ssl=not args.no_verify_ssl
    )
    
    setup = GrafanaSetup(config, args.config_dir)
    
    if setup.run_setup():
        print("Setup completed successfully")
        sys.exit(0)
    else:
        print("Setup failed")
        sys.exit(1)


if __name__ == '__main__':
    main() 