#!/usr/bin/env python3
"""
Homepage Automation Script
==========================

A comprehensive Python script for automating Homepage configuration that provides:
- API Integration with Homepage's REST API
- Service Management (add, update, organize services)
- Widget Configuration (weather, system monitoring, custom widgets)
- Bookmark Management (organized bookmark categories)
- Theme & Layout Configuration
- Health Monitoring and Status Indicators

Author: Homelab Automation
Version: 1.0.0
"""

import os
import sys
import json
import yaml
import time
import logging
import requests
import argparse
import re
import html
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
from pathlib import Path
from urllib.parse import urljoin, urlparse
import concurrent.futures
from datetime import datetime, timedelta
import random

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('homepage_automation.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


class InputValidator:
    """Input validation and sanitization utilities"""
    
    @staticmethod
    def validate_url(url: str) -> bool:
        """Validate URL format and security"""
        try:
            parsed = urlparse(url)
            return all([parsed.scheme, parsed.netloc])
        except Exception:
            return False
    
    @staticmethod
    def sanitize_string(value: str) -> str:
        """Sanitize string input and strip dangerous URI schemes"""
        if not isinstance(value, str):
            raise ValueError("Input must be a string")
        # Remove dangerous URI schemes
        dangerous_schemes = ["javascript:", "data:"]
        sanitized = value.strip()
        for scheme in dangerous_schemes:
            sanitized = sanitized.replace(scheme, "")
        return html.escape(sanitized)
    
    @staticmethod
    def validate_email(email: str) -> bool:
        """Validate email format"""
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(pattern, email))
    
    @staticmethod
    def validate_username(username: str) -> bool:
        """Validate username format"""
        pattern = r'^[a-zA-Z0-9_-]{3,20}$'
        return bool(re.match(pattern, username))
    
    @staticmethod
    def validate_service_name(name: str) -> bool:
        """Validate service name format"""
        if not name or len(name) > 50:
            return False
        pattern = r'^[a-zA-Z0-9\s_-]+$'
        return bool(re.match(pattern, name))


class CircuitBreaker:
    """Circuit breaker pattern for API resilience"""
    
    def __init__(self, failure_threshold: int = 5, recovery_timeout: int = 60):
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.failure_count = 0
        self.last_failure_time = None
        self.state = "CLOSED"  # CLOSED, OPEN, HALF_OPEN
    
    def __call__(self, func):
        def wrapper(*args, **kwargs):
            return self.call(func, *args, **kwargs)
        return wrapper
    
    def call(self, func, *args, **kwargs):
        """Execute function with circuit breaker protection"""
        if self.state == "OPEN":
            if self._should_attempt_reset():
                self.state = "HALF_OPEN"
            else:
                raise Exception("Circuit breaker is OPEN - service unavailable")
        
        try:
            result = func(*args, **kwargs)
            self._on_success()
            return result
        except Exception as e:
            self._on_failure()
            raise e
    
    def _on_success(self):
        """Handle successful operation"""
        self.failure_count = 0
        self.state = "CLOSED"
    
    def _on_failure(self):
        """Handle failed operation"""
        self.failure_count += 1
        self.last_failure_time = time.time()
        
        if self.failure_count >= self.failure_threshold:
            self.state = "OPEN"
    
    def _should_attempt_reset(self) -> bool:
        """Check if circuit breaker should attempt reset"""
        if self.last_failure_time is None:
            return True
        return time.time() - self.last_failure_time >= self.recovery_timeout


class RetryStrategy:
    """Exponential backoff with jitter retry strategy"""
    
    def __init__(self, max_retries: int = 3, base_delay: float = 1.0, max_delay: float = 30.0):
        self.max_retries = max_retries
        self.base_delay = base_delay
        self.max_delay = max_delay
    
    def execute(self, func, *args, **kwargs):
        """Execute function with retry logic"""
        last_exception = None
        
        for attempt in range(self.max_retries):
            try:
                return func(*args, **kwargs)
            except Exception as e:
                last_exception = e
                
                if attempt == self.max_retries - 1:
                    break
                
                delay = self._calculate_delay(attempt)
                logger.warning(f"Attempt {attempt + 1} failed: {e}. Retrying in {delay:.2f}s")
                time.sleep(delay)
        
        raise last_exception
    
    def _calculate_delay(self, attempt: int) -> float:
        """Calculate delay with exponential backoff and jitter"""
        delay = min(self.base_delay * (2 ** attempt), self.max_delay)
        jitter = random.uniform(0, 0.1 * delay)
        return delay + jitter


@dataclass
class ServiceConfig:
    """Service configuration data structure"""
    name: str
    url: str
    description: str
    icon: str
    category: str
    health_url: Optional[str] = None
    health_interval: int = 30
    auth_type: str = "none"
    auth_header: Optional[str] = None
    auth_token: Optional[str] = None
    widget_type: Optional[str] = None
    widget_url: Optional[str] = None
    widget_key: Optional[str] = None
    css: Optional[str] = None
    status: str = "unknown"
    last_check: Optional[datetime] = None
    response_time: Optional[float] = None


@dataclass
class WidgetConfig:
    """Widget configuration data structure"""
    type: str
    enabled: bool
    config: Dict[str, Any]
    update_interval: int = 300


@dataclass
class BookmarkConfig:
    """Bookmark configuration data structure"""
    category: str
    name: str
    url: str
    description: Optional[str] = None
    icon: Optional[str] = None


@dataclass
class ThemeConfig:
    """Theme configuration data structure"""
    theme: str = "dark"
    color_scheme: str = "auto"
    layout: str = "default"
    columns: int = 3
    background: Optional[str] = None
    background_blur: float = 0.5
    background_opacity: float = 0.3


class HomepageAPI:
    """Homepage API client for configuration management with enhanced error handling"""
    
    def __init__(self, base_url: str, api_key: Optional[str] = None, timeout: int = 30):
        """
        Initialize Homepage API client
        
        Args:
            base_url: Homepage base URL
            api_key: Optional API key for authentication
            timeout: Request timeout in seconds
        """
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key
        self.timeout = timeout
        self.session = requests.Session()
        
        # SECURITY FIX: Enable SSL verification
        self.session.verify = True
        
        if api_key:
            self.session.headers.update({'Authorization': f'Bearer {api_key}'})
        
        self.session.headers.update({
            'Content-Type': 'application/json',
            'User-Agent': 'HomepageAutomation/1.0.0'
        })
        
        # Initialize circuit breaker and retry strategy
        self.circuit_breaker = CircuitBreaker(failure_threshold=5, recovery_timeout=60)
        self.retry_strategy = RetryStrategy(max_retries=3, base_delay=1.0, max_delay=30.0)
        
        logger.info(f"Initialized Homepage API client for {base_url}")
    
    def wait_for_homepage(self, max_wait: int = 300, check_interval: int = 10) -> bool:
        """
        Wait for Homepage to be ready and accessible
        
        Args:
            max_wait: Maximum time to wait in seconds
            check_interval: Interval between checks in seconds
            
        Returns:
            True if Homepage is ready, False otherwise
        """
        logger.info("Waiting for Homepage to be ready...")
        start_time = time.time()
        
        while time.time() - start_time < max_wait:
            try:
                response = self.session.get(f"{self.base_url}/api/health", timeout=5)
                if response.status_code == 200:
                    logger.info("Homepage is ready!")
                    return True
            except requests.RequestException as e:
                logger.debug(f"Homepage not ready yet: {e}")
            
            time.sleep(check_interval)
        
        logger.error(f"Homepage not ready after {max_wait} seconds")
        return False
    
    def get_services(self) -> List[Dict[str, Any]]:
        """Get current services configuration with circuit breaker protection"""
        def _get_services():
            response = self.session.get(f"{self.base_url}/api/services", timeout=self.timeout)
            response.raise_for_status()
            return response.json()
        
        try:
            return self.circuit_breaker.call(_get_services)
        except Exception as e:
            logger.error(f"Failed to get services: {e}")
            return []
    
    def update_services(self, services: List[Dict[str, Any]]) -> bool:
        """Update services configuration with circuit breaker and retry protection"""
        def _update_services():
            response = self.session.post(
                f"{self.base_url}/api/services",
                json=services,
                timeout=self.timeout
            )
            response.raise_for_status()
            logger.info(f"Successfully updated {len(services)} services")
            return True
        
        try:
            return self.retry_strategy.execute(
                lambda: self.circuit_breaker.call(_update_services)
            )
        except Exception as e:
            logger.error(f"Failed to update services: {e}")
            return False
    
    def get_bookmarks(self) -> Dict[str, Any]:
        """Get current bookmarks configuration with circuit breaker protection"""
        def _get_bookmarks():
            response = self.session.get(f"{self.base_url}/api/bookmarks", timeout=self.timeout)
            response.raise_for_status()
            return response.json()
        
        try:
            return self.circuit_breaker.call(_get_bookmarks)
        except Exception as e:
            logger.error(f"Failed to get bookmarks: {e}")
            return {}
    
    def update_bookmarks(self, bookmarks: Dict[str, Any]) -> bool:
        """Update bookmarks configuration with circuit breaker and retry protection"""
        def _update_bookmarks():
            response = self.session.post(
                f"{self.base_url}/api/bookmarks",
                json=bookmarks,
                timeout=self.timeout
            )
            response.raise_for_status()
            logger.info("Successfully updated bookmarks")
            return True
        
        try:
            return self.retry_strategy.execute(
                lambda: self.circuit_breaker.call(_update_bookmarks)
            )
        except Exception as e:
            logger.error(f"Failed to update bookmarks: {e}")
            return False
    
    def get_settings(self) -> Dict[str, Any]:
        """Get current settings configuration with circuit breaker protection"""
        def _get_settings():
            response = self.session.get(f"{self.base_url}/api/settings", timeout=self.timeout)
            response.raise_for_status()
            return response.json()
        
        try:
            return self.circuit_breaker.call(_get_settings)
        except Exception as e:
            logger.error(f"Failed to get settings: {e}")
            return {}
    
    def update_settings(self, settings: Dict[str, Any]) -> bool:
        """Update settings configuration with circuit breaker and retry protection"""
        def _update_settings():
            response = self.session.post(
                f"{self.base_url}/api/settings",
                json=settings,
                timeout=self.timeout
            )
            response.raise_for_status()
            logger.info("Successfully updated settings")
            return True
        
        try:
            return self.retry_strategy.execute(
                lambda: self.circuit_breaker.call(_update_settings)
            )
        except Exception as e:
            logger.error(f"Failed to update settings: {e}")
            return False
    
    def health_check(self, url: str, timeout: int = 10) -> Dict[str, Any]:
        """
        Perform health check on a service with circuit breaker protection
        
        Args:
            url: Service URL to check
            timeout: Health check timeout
            
        Returns:
            Health check result
        """
        def _health_check():
            start_time = time.time()
            try:
                response = self.session.get(url, timeout=timeout)
                response_time = time.time() - start_time
                
                return {
                    'status': 'healthy' if response.status_code < 400 else 'unhealthy',
                    'status_code': response.status_code,
                    'response_time': response_time,
                    'last_check': datetime.now().isoformat()
                }
            except requests.RequestException as e:
                return {
                    'status': 'unhealthy',
                    'error': str(e),
                    'response_time': time.time() - start_time,
                    'last_check': datetime.now().isoformat()
                }
        
        try:
            return self.circuit_breaker.call(_health_check)
        except Exception as e:
            logger.error(f"Health check failed for {url}: {e}")
            return {
                'status': 'unhealthy',
                'error': str(e),
                'response_time': 0,
                'last_check': datetime.now().isoformat()
            }


class HomepageAutomation:
    """Main Homepage automation class"""
    
    def __init__(self, config_path: str = "config", domain: str = "localhost"):
        """
        Initialize Homepage automation
        
        Args:
            config_path: Path to configuration files
            domain: Domain name for service URLs
        """
        self.config_path = Path(config_path)
        self.domain = domain
        self.api_client = None
        self.services_data = []
        self.bookmarks_data = {}
        self.settings_data = {}
        
        # Load configuration data
        self._load_configuration()
        
        logger.info(f"Initialized Homepage automation for domain: {domain}")
    
    def _load_configuration(self):
        """Load configuration from YAML files"""
        try:
            # Load services configuration
            services_file = self.config_path / "services.yml"
            if services_file.exists():
                with open(services_file, 'r') as f:
                    self.services_data = yaml.safe_load(f)
                logger.info(f"Loaded services configuration from {services_file}")
            
            # Load bookmarks configuration
            bookmarks_file = self.config_path / "bookmarks.yml"
            if bookmarks_file.exists():
                with open(bookmarks_file, 'r') as f:
                    self.bookmarks_data = yaml.safe_load(f)
                logger.info(f"Loaded bookmarks configuration from {bookmarks_file}")
            
            # Load settings configuration
            settings_file = self.config_path / "settings.yml"
            if settings_file.exists():
                with open(settings_file, 'r') as f:
                    self.settings_data = yaml.safe_load(f)
                logger.info(f"Loaded settings configuration from {settings_file}")
                
        except Exception as e:
            logger.error(f"Failed to load configuration: {e}")
    
    def connect(self, base_url: str, api_key: Optional[str] = None) -> bool:
        """
        Connect to Homepage API
        
        Args:
            base_url: Homepage base URL
            api_key: Optional API key
            
        Returns:
            True if connection successful
        """
        self.api_client = HomepageAPI(base_url, api_key)
        
        if not self.api_client.wait_for_homepage():
            logger.error("Failed to connect to Homepage")
            return False
        
        logger.info("Successfully connected to Homepage API")
        return True
    
    def configure_services(self, health_check: bool = True) -> bool:
        """
        Configure all services
        
        Args:
            health_check: Whether to perform health checks
            
        Returns:
            True if configuration successful
        """
        if not self.api_client:
            logger.error("Not connected to Homepage API")
            return False
        
        logger.info("Configuring services...")
        
        # Process services data
        processed_services = []
        
        for group in self.services_data:
            group_name = group.get('group', 'Uncategorized')
            group_icon = group.get('icon', 'default.png')
            group_class = group.get('className', '')
            
            group_config = {
                'group': group_name,
                'icon': group_icon,
                'className': group_class,
                'items': []
            }
            
            for service in group.get('items', []):
                for service_name, service_config in service.items():
                    processed_service = self._process_service_config(
                        service_name, service_config, health_check
                    )
                    if processed_service:
                        group_config['items'].append(processed_service)
            
            if group_config['items']:
                processed_services.append(group_config)
        
        # Update services via API
        return self.api_client.update_services(processed_services)
    
    def _process_service_config(self, name: str, config: Dict[str, Any], health_check: bool = True) -> Optional[Dict[str, Any]]:
        """Process individual service configuration with validation"""
        try:
            # SECURITY FIX: Validate and sanitize inputs
            if not name or not isinstance(name, str):
                raise ValueError("Invalid service name")
            
            if not InputValidator.validate_service_name(name):
                raise ValueError(f"Invalid service name format: {name}")
            
            name = InputValidator.sanitize_string(name)
            
            # Validate and sanitize URL
            href = config.get('href', '').replace('{{ domain }}', self.domain)
            if not InputValidator.validate_url(href):
                raise ValueError(f"Invalid URL for service {name}: {href}")
            
            # Sanitize description
            description = InputValidator.sanitize_string(config.get('description', ''))
            
            # Sanitize icon
            icon = InputValidator.sanitize_string(config.get('icon', 'default.png'))
            
            processed_service = {
                name: {
                    'icon': icon,
                    'href': href,
                    'description': description,
                }
            }
            
            # Add widget configuration with validation
            if 'widget' in config:
                processed_service[name]['widget'] = self._validate_widget_config(config['widget'])
            
            # Add health check configuration with validation
            if 'health' in config:
                processed_service[name]['health'] = self._validate_health_config(config['health'])
                
                # Perform health check if requested
                if health_check and self.api_client:
                    health_url = config['health'].get('url', '').replace('{{ domain }}', self.domain)
                    if health_url and InputValidator.validate_url(health_url):
                        health_result = self.api_client.health_check(health_url)
                        processed_service[name]['health'].update(health_result)
            
            # Add authentication configuration with validation
            if 'auth' in config:
                processed_service[name]['auth'] = self._validate_auth_config(config['auth'])
            
            # Add custom CSS with validation
            if 'css' in config:
                processed_service[name]['css'] = InputValidator.sanitize_string(config['css'])
            
            return processed_service
            
        except Exception as e:
            logger.error(f"Failed to process service {name}: {e}")
            return None
    
    def _validate_widget_config(self, widget_config: Dict[str, Any]) -> Dict[str, Any]:
        """Validate widget configuration"""
        validated_config = {}
        
        if 'type' in widget_config:
            validated_config['type'] = InputValidator.sanitize_string(widget_config['type'])
        
        if 'url' in widget_config:
            url = widget_config['url'].replace('{{ domain }}', self.domain)
            if InputValidator.validate_url(url):
                validated_config['url'] = url
        
        if 'key' in widget_config:
            validated_config['key'] = InputValidator.sanitize_string(widget_config['key'])
        
        return validated_config
    
    def _validate_health_config(self, health_config: Dict[str, Any]) -> Dict[str, Any]:
        """Validate health check configuration"""
        validated_config = {}
        
        if 'url' in health_config:
            url = health_config['url'].replace('{{ domain }}', self.domain)
            if InputValidator.validate_url(url):
                validated_config['url'] = url
        
        if 'interval' in health_config:
            try:
                interval = int(health_config['interval'])
                if 10 <= interval <= 3600:  # Between 10 seconds and 1 hour
                    validated_config['interval'] = interval
            except (ValueError, TypeError):
                validated_config['interval'] = 30  # Default value
        
        return validated_config
    
    def _validate_auth_config(self, auth_config: Dict[str, Any]) -> Dict[str, Any]:
        """Validate authentication configuration"""
        validated_config = {}
        
        if 'type' in auth_config:
            auth_type = InputValidator.sanitize_string(auth_config['type'])
            if auth_type in ['none', 'api_key', 'session', 'oauth']:
                validated_config['type'] = auth_type
        
        if 'header' in auth_config:
            validated_config['header'] = InputValidator.sanitize_string(auth_config['header'])
        
        if 'token' in auth_config:
            validated_config['token'] = InputValidator.sanitize_string(auth_config['token'])
        
        return validated_config
    
    def configure_widgets(self) -> bool:
        """Configure widgets (weather, system monitoring, etc.)"""
        if not self.api_client:
            logger.error("Not connected to Homepage API")
            return False
        
        logger.info("Configuring widgets...")
        
        # Get current settings
        current_settings = self.api_client.get_settings()
        
        # Update widget configuration
        if 'widgets' in self.settings_data:
            current_settings['widgets'] = self.settings_data['widgets']
        
        return self.api_client.update_settings(current_settings)
    
    def configure_bookmarks(self) -> bool:
        """Configure bookmarks"""
        if not self.api_client:
            logger.error("Not connected to Homepage API")
            return False
        
        logger.info("Configuring bookmarks...")
        
        # Process bookmarks data
        processed_bookmarks = {}
        
        for category, items in self.bookmarks_data.items():
            processed_bookmarks[category] = []
            
            for item in items:
                if isinstance(item, dict):
                    for subcategory, links in item.items():
                        subcategory_data = {
                            'name': subcategory,
                            'links': []
                        }
                        
                        for link in links:
                            if isinstance(link, str):
                                # Simple link format
                                subcategory_data['links'].append(link)
                            elif isinstance(link, dict):
                                # Detailed link format
                                subcategory_data['links'].append(link)
                        
                        processed_bookmarks[category].append(subcategory_data)
        
        return self.api_client.update_bookmarks(processed_bookmarks)
    
    def configure_theme(self) -> bool:
        """Configure theme and layout preferences"""
        if not self.api_client:
            logger.error("Not connected to Homepage API")
            return False
        
        logger.info("Configuring theme and layout...")
        
        # Get current settings
        current_settings = self.api_client.get_settings()
        
        # Update display settings
        if 'display' in self.settings_data:
            current_settings['display'] = self.settings_data['display']
        
        return self.api_client.update_settings(current_settings)
    
    def configure_health_checks(self) -> bool:
        """Configure service health monitoring"""
        if not self.api_client:
            logger.error("Not connected to Homepage API")
            return False
        
        logger.info("Configuring health checks...")
        
        # Get current settings
        current_settings = self.api_client.get_settings()
        
        # Update health check settings
        if 'services' in self.settings_data and 'health' in self.settings_data['services']:
            if 'services' not in current_settings:
                current_settings['services'] = {}
            current_settings['services']['health'] = self.settings_data['services']['health']
        
        return self.api_client.update_settings(current_settings)
    
    def validate_configuration(self) -> Dict[str, Any]:
        """
        Validate the current configuration
        
        Returns:
            Validation results
        """
        if not self.api_client:
            return {'status': 'error', 'message': 'Not connected to Homepage API'}
        
        logger.info("Validating configuration...")
        
        validation_results = {
            'status': 'success',
            'services': {'total': 0, 'healthy': 0, 'unhealthy': 0, 'errors': []},
            'widgets': {'status': 'unknown', 'errors': []},
            'bookmarks': {'status': 'unknown', 'errors': []},
            'theme': {'status': 'unknown', 'errors': []}
        }
        
        # Validate services
        try:
            services = self.api_client.get_services()
            validation_results['services']['total'] = len(services)
            
            for group in services:
                for service in group.get('items', []):
                    for service_name, service_config in service.items():
                        if 'health' in service_config:
                            health_url = service_config['health'].get('url')
                            if health_url:
                                health_result = self.api_client.health_check(health_url)
                                if health_result['status'] == 'healthy':
                                    validation_results['services']['healthy'] += 1
                                else:
                                    validation_results['services']['unhealthy'] += 1
                                    validation_results['services']['errors'].append({
                                        'service': service_name,
                                        'error': health_result.get('error', 'Unknown error')
                                    })
        except Exception as e:
            validation_results['services']['errors'].append(str(e))
        
        # Validate widgets
        try:
            settings = self.api_client.get_settings()
            if 'widgets' in settings:
                validation_results['widgets']['status'] = 'configured'
            else:
                validation_results['widgets']['status'] = 'not_configured'
        except Exception as e:
            validation_results['widgets']['errors'].append(str(e))
        
        # Validate bookmarks
        try:
            bookmarks = self.api_client.get_bookmarks()
            if bookmarks:
                validation_results['bookmarks']['status'] = 'configured'
            else:
                validation_results['bookmarks']['status'] = 'not_configured'
        except Exception as e:
            validation_results['bookmarks']['errors'].append(str(e))
        
        # Validate theme
        try:
            settings = self.api_client.get_settings()
            if 'display' in settings:
                validation_results['theme']['status'] = 'configured'
            else:
                validation_results['theme']['status'] = 'not_configured'
        except Exception as e:
            validation_results['theme']['errors'].append(str(e))
        
        return validation_results
    
    def run_full_configuration(self, health_check: bool = True) -> bool:
        """
        Run full configuration process
        
        Args:
            health_check: Whether to perform health checks
            
        Returns:
            True if all configurations successful
        """
        logger.info("Starting full Homepage configuration...")
        
        success = True
        
        # Configure services
        if not self.configure_services(health_check):
            logger.error("Failed to configure services")
            success = False
        
        # Configure widgets
        if not self.configure_widgets():
            logger.error("Failed to configure widgets")
            success = False
        
        # Configure bookmarks
        if not self.configure_bookmarks():
            logger.error("Failed to configure bookmarks")
            success = False
        
        # Configure theme
        if not self.configure_theme():
            logger.error("Failed to configure theme")
            success = False
        
        # Configure health checks
        if not self.configure_health_checks():
            logger.error("Failed to configure health checks")
            success = False
        
        if success:
            logger.info("Full configuration completed successfully")
        else:
            logger.error("Configuration completed with errors")
        
        return success


def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='Homepage Automation Script')
    parser.add_argument('--url', required=True, help='Homepage base URL')
    parser.add_argument('--api-key', help='API key for authentication')
    parser.add_argument('--config-path', default='config', help='Path to configuration files')
    parser.add_argument('--domain', default='localhost', help='Domain name for service URLs')
    parser.add_argument('--no-health-check', action='store_true', help='Skip health checks')
    parser.add_argument('--validate-only', action='store_true', help='Only validate configuration')
    parser.add_argument('--services-only', action='store_true', help='Configure services only')
    parser.add_argument('--widgets-only', action='store_true', help='Configure widgets only')
    parser.add_argument('--bookmarks-only', action='store_true', help='Configure bookmarks only')
    parser.add_argument('--theme-only', action='store_true', help='Configure theme only')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose logging')
    
    args = parser.parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    # Initialize automation
    automation = HomepageAutomation(args.config_path, args.domain)
    
    # Connect to Homepage
    if not automation.connect(args.url, args.api_key):
        sys.exit(1)
    
    # Run configuration based on arguments
    if args.validate_only:
        results = automation.validate_configuration()
        print(json.dumps(results, indent=2))
        return
    
    success = True
    
    if args.services_only:
        success = automation.configure_services(not args.no_health_check)
    elif args.widgets_only:
        success = automation.configure_widgets()
    elif args.bookmarks_only:
        success = automation.configure_bookmarks()
    elif args.theme_only:
        success = automation.configure_theme()
    else:
        success = automation.run_full_configuration(not args.no_health_check)
    
    if success:
        logger.info("Configuration completed successfully")
        sys.exit(0)
    else:
        logger.error("Configuration failed")
        sys.exit(1)


if __name__ == '__main__':
    main() 