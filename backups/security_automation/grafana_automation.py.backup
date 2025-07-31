#!/usr/bin/env python3
"""
Comprehensive Grafana Automation Script
Advanced automation for Grafana configuration via REST API

This script provides:
- Complete API integration with retry logic and error handling
- Data source management (Prometheus, Loki, PostgreSQL, Redis, etc.)
- Dashboard management with import, creation, and organization
- User and team management with role-based permissions
- Alerting setup with rules and notification channels
- Folder organization and theme configuration
- Configuration validation and health checks
- Integration with external services (Authentik, SMTP, Discord, Slack)
"""

import json
import requests
import time
import sys
import os
import argparse
import logging
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass, field
from pathlib import Path
from urllib.parse import urljoin
import yaml
from datetime import datetime, timedelta

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('grafana_automation.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class GrafanaConfig:
    """Configuration for Grafana connection"""
    url: str
    username: str
    password: str
    timeout: int = 30
    verify_ssl: bool = True
    max_retries: int = 3
    retry_delay: int = 5

@dataclass
class DataSourceConfig:
    """Data source configuration"""
    name: str
    type: str
    url: str
    access: str = "proxy"
    is_default: bool = False
    json_data: Dict = field(default_factory=dict)
    secure_json_data: Dict = field(default_factory=dict)
    editable: bool = True
    version: int = 1

@dataclass
class DashboardConfig:
    """Dashboard configuration"""
    title: str
    folder_title: str = "General"
    tags: List[str] = field(default_factory=list)
    timezone: str = "browser"
    refresh: str = "30s"
    schema_version: int = 30
    version: int = 1
    panels: List[Dict] = field(default_factory=list)
    templating: Dict = field(default_factory=dict)
    time: Dict = field(default_factory=dict)
    timepicker: Dict = field(default_factory=dict)
    annotations: Dict = field(default_factory=dict)

class GrafanaAPI:
    """Enhanced Grafana REST API client with retry logic and comprehensive error handling"""
    
    def __init__(self, config: GrafanaConfig):
        self.config = config
        self.session = requests.Session()
        self.session.auth = (config.username, config.password)
        self.session.verify = config.verify_ssl
        self.session.timeout = config.timeout
        self.base_url = config.url.rstrip('/')
        self.api_base = f"{self.base_url}/api"
        
        # Set default headers
        self.session.headers.update({
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        })
        
    def _make_request(self, method: str, endpoint: str, data: Optional[Dict] = None, 
                     retries: Optional[int] = None) -> Tuple[bool, Dict]:
        """Make HTTP request to Grafana API with retry logic"""
        if retries is None:
            retries = self.config.max_retries
            
        url = f"{self.api_base}{endpoint}"
        
        for attempt in range(retries + 1):
            try:
                logger.debug(f"Making {method} request to {url} (attempt {attempt + 1})")
                
                if method.upper() == 'GET':
                    response = self.session.get(url)
                elif method.upper() == 'POST':
                    response = self.session.post(url, json=data)
                elif method.upper() == 'PUT':
                    response = self.session.put(url, json=data)
                elif method.upper() == 'DELETE':
                    response = self.session.delete(url)
                else:
                    raise ValueError(f"Unsupported HTTP method: {method}")
                
                response.raise_for_status()
                result = response.json() if response.content else {}
                return True, result
                
            except requests.exceptions.RequestException as e:
                logger.warning(f"Request failed (attempt {attempt + 1}): {e}")
                if attempt < retries:
                    time.sleep(self.config.retry_delay)
                else:
                    logger.error(f"Request failed after {retries + 1} attempts: {e}")
                    return False, {"error": str(e)}
    
    def health_check(self) -> bool:
        """Check if Grafana is healthy and ready"""
        try:
            response = self.session.get(f"{self.base_url}/api/health")
            if response.status_code == 200:
                health_data = response.json()
                return health_data.get('database', '') == 'ok'
            return False
        except Exception as e:
            logger.error(f"Health check failed: {e}")
            return False
    
    def get_version(self) -> Optional[str]:
        """Get Grafana version"""
        success, result = self._make_request('GET', '/frontend/settings')
        if success and 'buildInfo' in result:
            return result['buildInfo'].get('version')
        return None
    
    # Data Source Management
    def get_data_sources(self) -> List[Dict]:
        """Get all data sources"""
        success, result = self._make_request('GET', '/datasources')
        return result if success else []
    
    def get_data_source_by_name(self, name: str) -> Optional[Dict]:
        """Get data source by name"""
        success, result = self._make_request('GET', f'/datasources/name/{name}')
        return result if success else None
    
    def create_data_source(self, datasource: Dict) -> Tuple[bool, Dict]:
        """Create a new data source"""
        return self._make_request('POST', '/datasources', datasource)
    
    def update_data_source(self, datasource_id: int, datasource: Dict) -> Tuple[bool, Dict]:
        """Update an existing data source"""
        return self._make_request('PUT', f'/datasources/{datasource_id}', datasource)
    
    def delete_data_source(self, datasource_id: int) -> bool:
        """Delete a data source"""
        success, _ = self._make_request('DELETE', f'/datasources/{datasource_id}')
        return success
    
    def test_data_source(self, datasource: Dict) -> bool:
        """Test data source connection"""
        success, result = self._make_request('POST', '/datasources/test', datasource)
        if success:
            return result.get('status') == 'success'
        return False
    
    # Folder Management
    def get_folders(self) -> List[Dict]:
        """Get all dashboard folders"""
        success, result = self._make_request('GET', '/folders')
        return result if success else []
    
    def create_folder(self, folder: Dict) -> Tuple[bool, Dict]:
        """Create a new dashboard folder"""
        return self._make_request('POST', '/folders', folder)
    
    def update_folder(self, folder_id: int, folder: Dict) -> Tuple[bool, Dict]:
        """Update a folder"""
        return self._make_request('PUT', f'/folders/{folder_id}', folder)
    
    def delete_folder(self, folder_id: int) -> bool:
        """Delete a folder"""
        success, _ = self._make_request('DELETE', f'/folders/{folder_id}')
        return success
    
    # Dashboard Management
    def get_dashboards(self, folder_id: Optional[int] = None) -> List[Dict]:
        """Get all dashboards"""
        endpoint = '/search'
        if folder_id:
            endpoint += f'?folderIds={folder_id}'
        success, result = self._make_request('GET', endpoint)
        return result if success else []
    
    def get_dashboard_by_uid(self, uid: str) -> Optional[Dict]:
        """Get dashboard by UID"""
        success, result = self._make_request('GET', f'/dashboards/uid/{uid}')
        return result if success else None
    
    def create_dashboard(self, dashboard: Dict) -> Tuple[bool, Dict]:
        """Create a new dashboard"""
        return self._make_request('POST', '/dashboards/db', dashboard)
    
    def update_dashboard(self, dashboard: Dict) -> Tuple[bool, Dict]:
        """Update an existing dashboard"""
        return self._make_request('PUT', '/dashboards/db', dashboard)
    
    def delete_dashboard_by_uid(self, uid: str) -> bool:
        """Delete a dashboard by UID"""
        success, _ = self._make_request('DELETE', f'/dashboards/uid/{uid}')
        return success
    
    # User Management
    def get_users(self) -> List[Dict]:
        """Get all users"""
        success, result = self._make_request('GET', '/admin/users')
        return result if success else []
    
    def get_user_by_id(self, user_id: int) -> Optional[Dict]:
        """Get user by ID"""
        success, result = self._make_request('GET', f'/admin/users/{user_id}')
        return result if success else None
    
    def create_user(self, user: Dict) -> Tuple[bool, Dict]:
        """Create a new user"""
        return self._make_request('POST', '/admin/users', user)
    
    def update_user(self, user_id: int, user: Dict) -> Tuple[bool, Dict]:
        """Update a user"""
        return self._make_request('PUT', f'/admin/users/{user_id}', user)
    
    def delete_user(self, user_id: int) -> bool:
        """Delete a user"""
        success, _ = self._make_request('DELETE', f'/admin/users/{user_id}')
        return success
    
    def change_user_password(self, user_id: int, password: str) -> bool:
        """Change user password"""
        success, _ = self._make_request('PUT', f'/admin/users/{user_id}/password', 
                                      {'password': password})
        return success
    
    # Team Management
    def get_teams(self) -> List[Dict]:
        """Get all teams"""
        success, result = self._make_request('GET', '/teams/search')
        return result.get('teams', []) if success else []
    
    def create_team(self, team: Dict) -> Tuple[bool, Dict]:
        """Create a new team"""
        return self._make_request('POST', '/teams', team)
    
    def update_team(self, team_id: int, team: Dict) -> Tuple[bool, Dict]:
        """Update a team"""
        return self._make_request('PUT', f'/teams/{team_id}', team)
    
    def delete_team(self, team_id: int) -> bool:
        """Delete a team"""
        success, _ = self._make_request('DELETE', f'/teams/{team_id}')
        return success
    
    def add_team_member(self, team_id: int, user_id: int) -> bool:
        """Add user to team"""
        success, _ = self._make_request('POST', f'/teams/{team_id}/members', 
                                      {'userId': user_id})
        return success
    
    # Notification Channels
    def get_notification_channels(self) -> List[Dict]:
        """Get all notification channels"""
        success, result = self._make_request('GET', '/alert-notifications')
        return result if success else []
    
    def create_notification_channel(self, channel: Dict) -> Tuple[bool, Dict]:
        """Create a new notification channel"""
        return self._make_request('POST', '/alert-notifications', channel)
    
    def update_notification_channel(self, channel_id: int, channel: Dict) -> Tuple[bool, Dict]:
        """Update a notification channel"""
        return self._make_request('PUT', f'/alert-notifications/{channel_id}', channel)
    
    def delete_notification_channel(self, channel_id: int) -> bool:
        """Delete a notification channel"""
        success, _ = self._make_request('DELETE', f'/alert-notifications/{channel_id}')
        return success
    
    def test_notification_channel(self, channel: Dict) -> bool:
        """Test notification channel"""
        success, result = self._make_request('POST', '/alert-notifications/test', channel)
        if success:
            return result.get('status') == 'success'
        return False
    
    # Alert Rules
    def get_alert_rules(self) -> List[Dict]:
        """Get all alert rules"""
        success, result = self._make_request('GET', '/alerts')
        return result if success else []
    
    def create_alert_rule(self, rule: Dict) -> Tuple[bool, Dict]:
        """Create a new alert rule"""
        return self._make_request('POST', '/alerts', rule)
    
    def update_alert_rule(self, rule_id: int, rule: Dict) -> Tuple[bool, Dict]:
        """Update an alert rule"""
        return self._make_request('PUT', f'/alerts/{rule_id}', rule)
    
    def delete_alert_rule(self, rule_id: int) -> bool:
        """Delete an alert rule"""
        success, _ = self._make_request('DELETE', f'/alerts/{rule_id}')
        return success
    
    # Preferences and Settings
    def get_user_preferences(self, user_id: int) -> Optional[Dict]:
        """Get user preferences"""
        success, result = self._make_request('GET', f'/user/preferences')
        return result if success else None
    
    def update_user_preferences(self, preferences: Dict) -> bool:
        """Update user preferences"""
        success, _ = self._make_request('PUT', '/user/preferences', preferences)
        return success
    
    def get_org_preferences(self) -> Optional[Dict]:
        """Get organization preferences"""
        success, result = self._make_request('GET', '/org/preferences')
        return result if success else None
    
    def update_org_preferences(self, preferences: Dict) -> bool:
        """Update organization preferences"""
        success, _ = self._make_request('PUT', '/org/preferences', preferences)
        return success
    
    # API Keys
    def get_api_keys(self) -> List[Dict]:
        """Get all API keys"""
        success, result = self._make_request('GET', '/auth/keys')
        return result if success else []
    
    def create_api_key(self, key: Dict) -> Tuple[bool, Dict]:
        """Create a new API key"""
        return self._make_request('POST', '/auth/keys', key)
    
    def delete_api_key(self, key_id: int) -> bool:
        """Delete an API key"""
        success, _ = self._make_request('DELETE', f'/auth/keys/{key_id}')
        return success

class GrafanaAutomation:
    """Main Grafana automation class with comprehensive configuration management"""
    
    def __init__(self, config: GrafanaConfig, config_dir: str = "config"):
        self.api = GrafanaAPI(config)
        self.config_dir = Path(config_dir)
        self.config_dir.mkdir(exist_ok=True)
        
        # Create subdirectories
        (self.config_dir / "dashboards").mkdir(exist_ok=True)
        (self.config_dir / "datasources").mkdir(exist_ok=True)
        (self.config_dir / "alerts").mkdir(exist_ok=True)
        (self.config_dir / "users").mkdir(exist_ok=True)
        
    def wait_for_grafana(self, max_wait: int = 300) -> bool:
        """Wait for Grafana to be ready with detailed status reporting"""
        logger.info("Waiting for Grafana to be ready...")
        start_time = time.time()
        
        while time.time() - start_time < max_wait:
            if self.api.health_check():
                version = self.api.get_version()
                logger.info(f"Grafana is ready! Version: {version}")
                return True
            
            elapsed = int(time.time() - start_time)
            logger.info(f"Waiting for Grafana... ({elapsed}s elapsed)")
            time.sleep(5)
        
        logger.error(f"Timeout waiting for Grafana after {max_wait} seconds")
        return False
    
    def configure_data_sources(self, datasources: List[DataSourceConfig]) -> bool:
        """Configure data sources with validation and testing"""
        logger.info("Configuring data sources...")
        
        existing_ds = {ds['name']: ds for ds in self.api.get_data_sources()}
        
        for ds_config in datasources:
            name = ds_config.name
            logger.info(f"Processing data source: {name}")
            
            # Prepare data source configuration
            ds_data = {
                'name': ds_config.name,
                'type': ds_config.type,
                'url': ds_config.url,
                'access': ds_config.access,
                'isDefault': ds_config.is_default,
                'jsonData': ds_config.json_data,
                'secureJsonData': ds_config.secure_json_data,
                'editable': ds_config.editable,
                'version': ds_config.version
            }
            
            # Test connection before creating/updating
            logger.info(f"Testing connection to {name}...")
            if not self.api.test_data_source(ds_data):
                logger.error(f"Failed to test data source: {name}")
                return False
            
            if name in existing_ds:
                logger.info(f"Updating existing data source: {name}")
                success, result = self.api.update_data_source(existing_ds[name]['id'], ds_data)
            else:
                logger.info(f"Creating new data source: {name}")
                success, result = self.api.create_data_source(ds_data)
            
            if not success:
                logger.error(f"Failed to configure data source: {name}")
                return False
            
            logger.info(f"Successfully configured data source: {name}")
        
        logger.info("All data sources configured successfully")
        return True
    
    def configure_folders(self, folders: List[Dict]) -> Dict[str, int]:
        """Configure dashboard folders with organization"""
        logger.info("Configuring dashboard folders...")
        
        existing_folders = {f['title']: f for f in self.api.get_folders()}
        folder_ids = {}
        
        for folder_config in folders:
            title = folder_config['title']
            logger.info(f"Processing folder: {title}")
            
            if title in existing_folders:
                folder_ids[title] = existing_folders[title]['id']
                logger.info(f"Folder exists: {title}")
            else:
                success, result = self.api.create_folder(folder_config)
                if success and 'id' in result:
                    folder_ids[title] = result['id']
                    logger.info(f"Created folder: {title}")
                else:
                    logger.error(f"Failed to create folder: {title}")
                    return {}
        
        logger.info(f"Configured {len(folder_ids)} folders")
        return folder_ids
    
    def import_dashboards(self, dashboard_files: List[str], folder_ids: Dict[str, int]) -> bool:
        """Import dashboards from JSON files"""
        logger.info("Importing dashboards from files...")
        
        for file_path in dashboard_files:
            file_path = Path(file_path)
            if not file_path.exists():
                logger.error(f"Dashboard file not found: {file_path}")
                continue
            
            try:
                with open(file_path, 'r') as f:
                    dashboard_data = json.load(f)
                
                title = dashboard_data.get('dashboard', {}).get('title', 'Unknown')
                folder_title = dashboard_data.get('folderTitle', 'General')
                
                logger.info(f"Importing dashboard: {title}")
                
                # Set folder ID if specified
                if folder_title in folder_ids:
                    dashboard_data['folderId'] = folder_ids[folder_title]
                
                success, result = self.api.create_dashboard(dashboard_data)
                if success:
                    logger.info(f"Successfully imported dashboard: {title}")
                else:
                    logger.error(f"Failed to import dashboard: {title}")
                    return False
                    
            except Exception as e:
                logger.error(f"Error importing dashboard {file_path}: {e}")
                return False
        
        logger.info("Dashboard import completed")
        return True
    
    def create_custom_dashboards(self, dashboards: List[DashboardConfig], 
                                folder_ids: Dict[str, int]) -> bool:
        """Create custom dashboards programmatically"""
        logger.info("Creating custom dashboards...")
        
        for dashboard_config in dashboards:
            logger.info(f"Creating dashboard: {dashboard_config.title}")
            
            # Build dashboard structure
            dashboard_data = {
                'dashboard': {
                    'title': dashboard_config.title,
                    'tags': dashboard_config.tags,
                    'timezone': dashboard_config.timezone,
                    'refresh': dashboard_config.refresh,
                    'schemaVersion': dashboard_config.schema_version,
                    'version': dashboard_config.version,
                    'panels': dashboard_config.panels,
                    'templating': dashboard_config.templating,
                    'time': dashboard_config.time,
                    'timepicker': dashboard_config.timepicker,
                    'annotations': dashboard_config.annotations
                },
                'folderId': folder_ids.get(dashboard_config.folder_title, 0),
                'overwrite': True
            }
            
            success, result = self.api.create_dashboard(dashboard_data)
            if success:
                logger.info(f"Successfully created dashboard: {dashboard_config.title}")
            else:
                logger.error(f"Failed to create dashboard: {dashboard_config.title}")
                return False
        
        logger.info("Custom dashboard creation completed")
        return True
    
    def configure_users(self, users: List[Dict]) -> bool:
        """Configure users with role-based permissions"""
        logger.info("Configuring users...")
        
        existing_users = {u['login']: u for u in self.api.get_users()}
        
        for user_config in users:
            login = user_config['login']
            logger.info(f"Processing user: {login}")
            
            if login in existing_users:
                logger.info(f"User exists: {login}")
                # Update user if needed
                if 'update' in user_config:
                    success, _ = self.api.update_user(existing_users[login]['id'], user_config['update'])
                    if success:
                        logger.info(f"Updated user: {login}")
            else:
                success, result = self.api.create_user(user_config)
                if success:
                    logger.info(f"Created user: {login}")
                else:
                    logger.error(f"Failed to create user: {login}")
                    return False
        
        logger.info("User configuration completed")
        return True
    
    def configure_teams(self, teams: List[Dict]) -> bool:
        """Configure teams with member management"""
        logger.info("Configuring teams...")
        
        existing_teams = {t['name']: t for t in self.api.get_teams()}
        
        for team_config in teams:
            name = team_config['name']
            logger.info(f"Processing team: {name}")
            
            if name in existing_teams:
                logger.info(f"Team exists: {name}")
                team_id = existing_teams[name]['id']
            else:
                success, result = self.api.create_team(team_config)
                if success and 'id' in result:
                    team_id = result['id']
                    logger.info(f"Created team: {name}")
                else:
                    logger.error(f"Failed to create team: {name}")
                    return False
            
            # Add team members if specified
            if 'members' in team_config:
                for member in team_config['members']:
                    success = self.api.add_team_member(team_id, member['userId'])
                    if success:
                        logger.info(f"Added member {member['userId']} to team {name}")
                    else:
                        logger.warning(f"Failed to add member {member['userId']} to team {name}")
        
        logger.info("Team configuration completed")
        return True
    
    def configure_notification_channels(self, channels: List[Dict]) -> bool:
        """Configure notification channels with testing"""
        logger.info("Configuring notification channels...")
        
        existing_channels = {c['name']: c for c in self.api.get_notification_channels()}
        
        for channel_config in channels:
            name = channel_config['name']
            logger.info(f"Processing notification channel: {name}")
            
            # Test channel before creating/updating
            logger.info(f"Testing notification channel: {name}")
            if not self.api.test_notification_channel(channel_config):
                logger.error(f"Failed to test notification channel: {name}")
                return False
            
            if name in existing_channels:
                logger.info(f"Updating notification channel: {name}")
                success, _ = self.api.update_notification_channel(
                    existing_channels[name]['id'], channel_config)
            else:
                logger.info(f"Creating notification channel: {name}")
                success, _ = self.api.create_notification_channel(channel_config)
            
            if not success:
                logger.error(f"Failed to configure notification channel: {name}")
                return False
            
            logger.info(f"Successfully configured notification channel: {name}")
        
        logger.info("Notification channel configuration completed")
        return True
    
    def configure_alert_rules(self, rules: List[Dict]) -> bool:
        """Configure alert rules with validation"""
        logger.info("Configuring alert rules...")
        
        for rule_config in rules:
            name = rule_config.get('name', 'Unknown')
            logger.info(f"Processing alert rule: {name}")
            
            success, result = self.api.create_alert_rule(rule_config)
            if success:
                logger.info(f"Created alert rule: {name}")
            else:
                logger.error(f"Failed to create alert rule: {name}")
                return False
        
        logger.info("Alert rule configuration completed")
        return True
    
    def configure_theme_and_preferences(self, preferences: Dict) -> bool:
        """Configure theme and organization preferences"""
        logger.info("Configuring theme and preferences...")
        
        # Update organization preferences
        success = self.api.update_org_preferences(preferences)
        if success:
            logger.info("Organization preferences updated successfully")
        else:
            logger.error("Failed to update organization preferences")
            return False
        
        logger.info("Theme and preferences configuration completed")
        return True
    
    def validate_configuration(self) -> bool:
        """Validate the complete configuration"""
        logger.info("Validating configuration...")
        
        # Test data sources
        datasources = self.api.get_data_sources()
        for ds in datasources:
            logger.info(f"Testing data source: {ds['name']}")
            if not self.api.test_data_source(ds):
                logger.error(f"Data source test failed: {ds['name']}")
                return False
        
        # Test notification channels
        channels = self.api.get_notification_channels()
        for channel in channels:
            logger.info(f"Testing notification channel: {channel['name']}")
            if not self.api.test_notification_channel(channel):
                logger.error(f"Notification channel test failed: {channel['name']}")
                return False
        
        # Check dashboard accessibility
        dashboards = self.api.get_dashboards()
        logger.info(f"Found {len(dashboards)} dashboards")
        
        logger.info("Configuration validation completed successfully")
        return True
    
    def load_config_file(self, filename: str) -> Dict:
        """Load configuration from JSON or YAML file"""
        file_path = self.config_dir / filename
        
        if not file_path.exists():
            logger.warning(f"Configuration file not found: {file_path}")
            return {}
        
        try:
            with open(file_path, 'r') as f:
                if filename.endswith('.yaml') or filename.endswith('.yml'):
                    return yaml.safe_load(f)
                else:
                    return json.load(f)
        except Exception as e:
            logger.error(f"Error loading configuration file {file_path}: {e}")
            return {}
    
    def run_complete_setup(self, config_files: Dict[str, str]) -> bool:
        """Run complete Grafana setup with all configurations"""
        logger.info("Starting comprehensive Grafana setup...")
        
        # Wait for Grafana to be ready
        if not self.wait_for_grafana():
            return False
        
        # Load all configurations
        datasources = self.load_config_file(config_files.get('datasources', 'datasources.json'))
        folders = self.load_config_file(config_files.get('folders', 'folders.json'))
        dashboard_files = self.load_config_file(config_files.get('dashboard_files', 'dashboard_files.json'))
        users = self.load_config_file(config_files.get('users', 'users.json'))
        teams = self.load_config_file(config_files.get('teams', 'teams.json'))
        notification_channels = self.load_config_file(config_files.get('notification_channels', 'notification_channels.json'))
        alert_rules = self.load_config_file(config_files.get('alert_rules', 'alert_rules.json'))
        preferences = self.load_config_file(config_files.get('preferences', 'preferences.json'))
        
        # Setup components in order
        if datasources and not self.configure_data_sources(datasources):
            return False
        
        folder_ids = {}
        if folders:
            folder_ids = self.configure_folders(folders)
        
        if dashboard_files and not self.import_dashboards(dashboard_files, folder_ids):
            return False
        
        if users and not self.configure_users(users):
            return False
        
        if teams and not self.configure_teams(teams):
            return False
        
        if notification_channels and not self.configure_notification_channels(notification_channels):
            return False
        
        if alert_rules and not self.configure_alert_rules(alert_rules):
            return False
        
        if preferences and not self.configure_theme_and_preferences(preferences):
            return False
        
        # Validate configuration
        if not self.validate_configuration():
            return False
        
        logger.info("Comprehensive Grafana setup completed successfully!")
        return True

def create_sample_configurations():
    """Create sample configuration files"""
    config_dir = Path("config")
    config_dir.mkdir(exist_ok=True)
    
    # Sample data sources configuration
    datasources = [
        {
            "name": "Prometheus",
            "type": "prometheus",
            "url": "http://prometheus:9090",
            "access": "proxy",
            "isDefault": True,
            "jsonData": {
                "timeInterval": "15s",
                "queryTimeout": "60s",
                "httpMethod": "POST"
            }
        },
        {
            "name": "Loki",
            "type": "loki",
            "url": "http://loki:3100",
            "access": "proxy",
            "jsonData": {
                "maxLines": 1000
            }
        },
        {
            "name": "PostgreSQL",
            "type": "postgres",
            "url": "postgresql://user:pass@postgresql:5432/grafana",
            "access": "proxy",
            "jsonData": {
                "sslmode": "disable",
                "maxOpenConns": 100,
                "maxIdleConns": 100,
                "connMaxLifetime": 14400
            }
        },
        {
            "name": "Redis",
            "type": "redis-datasource",
            "url": "redis://redis:6379",
            "access": "proxy",
            "jsonData": {
                "poolSize": 5,
                "timeout": 5
            }
        }
    ]
    
    with open(config_dir / "datasources.json", 'w') as f:
        json.dump(datasources, f, indent=2)
    
    # Sample folders configuration
    folders = [
        {"title": "System Overview", "description": "System-level monitoring dashboards"},
        {"title": "Services", "description": "Service-specific dashboards"},
        {"title": "Security", "description": "Security monitoring dashboards"},
        {"title": "Media Stack", "description": "Media service dashboards"},
        {"title": "Network", "description": "Network infrastructure dashboards"},
        {"title": "Storage", "description": "Storage and backup dashboards"}
    ]
    
    with open(config_dir / "folders.json", 'w') as f:
        json.dump(folders, f, indent=2)
    
    # Sample users configuration
    users = [
        {
            "login": "admin",
            "email": "admin@example.com",
            "password": "admin123",
            "name": "Administrator"
        },
        {
            "login": "viewer",
            "email": "viewer@example.com",
            "password": "viewer123",
            "name": "Viewer User"
        }
    ]
    
    with open(config_dir / "users.json", 'w') as f:
        json.dump(users, f, indent=2)
    
    # Sample notification channels
    notification_channels = [
        {
            "name": "Email",
            "type": "email",
            "isDefault": True,
            "settings": {
                "addresses": "admin@example.com"
            }
        },
        {
            "name": "Discord",
            "type": "discord",
            "settings": {
                "url": "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"
            }
        },
        {
            "name": "Slack",
            "type": "slack",
            "settings": {
                "url": "https://hooks.slack.com/services/YOUR_WEBHOOK_URL"
            }
        }
    ]
    
    with open(config_dir / "notification_channels.json", 'w') as f:
        json.dump(notification_channels, f, indent=2)
    
    # Sample preferences
    preferences = {
        "theme": "dark",
        "homeDashboardId": 1,
        "timezone": "browser"
    }
    
    with open(config_dir / "preferences.json", 'w') as f:
        json.dump(preferences, f, indent=2)
    
    logger.info("Sample configuration files created in config/ directory")

def main():
    """Main function with comprehensive argument parsing"""
    parser = argparse.ArgumentParser(
        description='Comprehensive Grafana Automation Script',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Basic setup with configuration files
  python grafana_automation.py --url http://grafana:3000 --username admin --password admin

  # Setup with custom config directory
  python grafana_automation.py --url http://grafana:3000 --username admin --password admin --config-dir /path/to/config

  # Create sample configurations
  python grafana_automation.py --create-samples

  # Validate existing configuration
  python grafana_automation.py --url http://grafana:3000 --username admin --password admin --validate-only
        """
    )
    
    parser.add_argument('--url', help='Grafana URL')
    parser.add_argument('--username', help='Grafana admin username')
    parser.add_argument('--password', help='Grafana admin password')
    parser.add_argument('--config-dir', default='config', help='Configuration directory')
    parser.add_argument('--timeout', type=int, default=30, help='Request timeout')
    parser.add_argument('--max-retries', type=int, default=3, help='Maximum retry attempts')
    parser.add_argument('--retry-delay', type=int, default=5, help='Delay between retries')
    parser.add_argument('--no-verify-ssl', action='store_true', help='Disable SSL verification')
    parser.add_argument('--create-samples', action='store_true', help='Create sample configuration files')
    parser.add_argument('--validate-only', action='store_true', help='Only validate existing configuration')
    parser.add_argument('--log-level', choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'], 
                       default='INFO', help='Logging level')
    
    args = parser.parse_args()
    
    # Set log level
    logging.getLogger().setLevel(getattr(logging, args.log_level))
    
    # Create sample configurations if requested
    if args.create_samples:
        create_sample_configurations()
        return
    
    # Validate required arguments
    if not args.validate_only and (not args.url or not args.username or not args.password):
        parser.error("--url, --username, and --password are required for setup operations")
    
    # Create configuration
    config = GrafanaConfig(
        url=args.url or "http://localhost:3000",
        username=args.username or "admin",
        password=args.password or "admin",
        timeout=args.timeout,
        verify_ssl=not args.no_verify_ssl,
        max_retries=args.max_retries,
        retry_delay=args.retry_delay
    )
    
    # Create automation instance
    automation = GrafanaAutomation(config, args.config_dir)
    
    if args.validate_only:
        # Only validate configuration
        if automation.wait_for_grafana():
            if automation.validate_configuration():
                logger.info("Configuration validation passed")
                sys.exit(0)
            else:
                logger.error("Configuration validation failed")
                sys.exit(1)
        else:
            logger.error("Grafana is not accessible")
            sys.exit(1)
    else:
        # Run complete setup
        config_files = {
            'datasources': 'datasources.json',
            'folders': 'folders.json',
            'dashboard_files': 'dashboard_files.json',
            'users': 'users.json',
            'teams': 'teams.json',
            'notification_channels': 'notification_channels.json',
            'alert_rules': 'alert_rules.json',
            'preferences': 'preferences.json'
        }
        
        if automation.run_complete_setup(config_files):
            logger.info("Setup completed successfully")
            sys.exit(0)
        else:
            logger.error("Setup failed")
            sys.exit(1)

if __name__ == '__main__':
    main()
