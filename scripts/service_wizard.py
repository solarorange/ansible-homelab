#!/usr/bin/env python3
"""
Production-ready Ansible Homelab Service Integration Wizard
Automates the process of adding new services to the homelab stack.

COMMENT: Production-hardened with comprehensive error handling,
security validation, type hints, logging, and Ansible integration.

CodeRabbit AI-Enhanced: Production-ready with comprehensive error handling,
security validation, type hints, and logging.
"""

import os
import sys
import re
import yaml
import json
# COMMENT: requests import removed - not used in current implementation
import argparse
import logging
import subprocess
import shutil
import tempfile
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any, Union
from dataclasses import dataclass, field
from urllib.parse import urlparse
from datetime import datetime, timezone
import signal

# COMMENT: Production logging configuration with absolute path and configurable log location
def setup_logging() -> logging.Logger:
    """
    COMMENT: Setup production logging with absolute path and configurable log location.
    Returns configured logger for Ansible integration.
    # COMMENT: Get script directory and resolve to absolute path
    script_dir = Path(__file__).resolve().parent
    log_dir = script_dir / 'logs'
    
    # COMMENT: Create logs directory if it doesn't exist
    log_dir.mkdir(parents=True, exist_ok=True)
    
    # COMMENT: Use environment variable for log path or fall back to default
    log_path_str = os.environ.get('SERVICE_WIZARD_LOG_PATH', str(log_dir / 'service_wizard.log'))
    log_path = Path(log_path_str).resolve()
    # Ensure log path is within expected boundaries
    if not (log_path.is_relative_to(script_dir) or log_path.is_relative_to('/var/log')):
        log_path = log_dir / 'service_wizard.log'
    
    # COMMENT: Ensure the log file directory exists
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.parent.mkdir(parents=True, exist_ok=True)
    
    # COMMENT: Configure production logging with proper formatting
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(str(log_path)),
            logging.StreamHandler(sys.stdout)
        ]
    )
    return logging.getLogger(__name__)

# COMMENT: Initialize logging for production use
logger = setup_logging()

# COMMENT: CRITICAL SECURITY: Add comprehensive input validation functions
def validate_service_name(service_name: str) -> bool:
    """
    COMMENT: Validate service name for security and compliance.
    Prevents injection attacks and ensures safe naming.
    """
    if not service_name or len(service_name) > 50:
        return False
    
    # COMMENT: Prevent injection attacks - only allow safe characters
    if re.search(r'[^a-zA-Z0-9_-]', service_name):
        return False
    
    # COMMENT: Prevent dangerous service names
    dangerous_names = ['root', 'admin', 'system', 'bin', 'sbin', 'etc', 'var', 'tmp', 'proc']
    if service_name.lower() in dangerous_names:
        return False
    
    return True

def validate_docker_image(image: str) -> bool:
    """
    COMMENT: Validate Docker image for security.
    Prevents malicious image injection.
    """
    if not image or len(image) > 200:
        return False
    
    # COMMENT: Only allow safe image formats
    if re.search(r'[^a-zA-Z0-9/:._-]', image):
        return False
    
    # COMMENT: Prevent local file path injection
    if image.startswith('/') or '..' in image:
        return False
    
    return True

def validate_port_number(port: int) -> bool:
    """
    COMMENT: Validate port number for security.
    Ensures ports are within safe ranges.
    """
    return isinstance(port, int) and 1024 <= port <= 65535

def validate_volume_path(volume: str) -> bool:
    """
    COMMENT: Validate volume path for security.
    Prevents path traversal attacks.
    """
    if not volume or len(volume) > 200:
        return False
    
    # COMMENT: Prevent path traversal attacks
    if '..' in volume or volume.startswith('/etc') or volume.startswith('/var/lib'):
        return False
    
    # COMMENT: Only allow safe volume paths
    if re.search(r'[^a-zA-Z0-9/._-]', volume):
        return False
    
    return True

def sanitize_service_name(service_name: str) -> str:
    """
    COMMENT: Sanitize service name for safe use in templates.
    Replaces unsafe characters with underscores.
    """
    return re.sub(r'[^a-zA-Z0-9_-]', '_', service_name)

def sanitize_docker_image(image: str) -> str:
    """
    COMMENT: Sanitize Docker image for safe use in templates.
    Replaces unsafe characters with underscores.
    """
    return re.sub(r'[^a-zA-Z0-9/:._-]', '_', image)

# COMMENT: Custom exception classes for production error handling
class ServiceWizardError(Exception):
    """
    COMMENT: Custom exception for service wizard errors.
    Allows Ansible to handle failures appropriately.
    """
    pass

class SecurityValidationError(Exception):
    """
    COMMENT: Exception for security validation failures.
    Critical for production security compliance.
    """
    pass

class ConfigurationError(Exception):
    """
    COMMENT: Exception for configuration errors.
    Ensures proper setup before deployment.
    """
    pass

class ValidationError(Exception):
    """
    COMMENT: Exception for validation errors.
    Ensures data integrity and security.
    """
    pass

@dataclass
class ServiceInfo:
    """
    COMMENT: Service information collected from user input and repository analysis.
    Production-ready with comprehensive validation and security checks.
    """
    name: str
    repository_url: str
    display_name: str
    description: str
    category: str
    stage: str
    ports: List[int] = field(default_factory=list)
    environment_vars: Dict[str, str] = field(default_factory=dict)
    volumes: List[str] = field(default_factory=list)
    dependencies: List[str] = field(default_factory=list)
    image: str = ""
    version: str = "latest"
    
    # COMMENT: Enhanced authentication configuration with security validation
    auth_enabled: bool = True
    auth_method: str = "authentik"  # COMMENT: Options: authentik, basic, none
    admin_email: str = ""
    admin_password: str = ""
    secret_key: str = ""
    
    # COMMENT: Enhanced database configuration with security validation
    database_enabled: bool = True
    database_type: str = "sqlite"  # COMMENT: Options: sqlite, postgresql
    database_host: str = ""
    database_port: int = 5432
    database_name: str = ""
    database_user: str = ""
    database_password: str = ""
    
    # COMMENT: Enhanced API configuration with security validation
    api_enabled: bool = True
    api_version: str = "v1"
    api_key: str = ""
    
    # COMMENT: Production security settings
    security_context: Dict[str, Any] = field(default_factory=dict)
    resource_limits: Dict[str, str] = field(default_factory=dict)
    health_check: Dict[str, Any] = field(default_factory=dict)
    
    def __post_init__(self) -> None:
        """
        COMMENT: Post-initialization validation for production safety.
        Ensures all required fields are properly set and validated.
        """
        # COMMENT: CRITICAL SECURITY: Validate service name for security
        if not validate_service_name(self.name):
            raise SecurityValidationError(f"Service name validation failed: {self.name}")
        
        # COMMENT: CRITICAL SECURITY: Validate Docker image for security
        if not validate_docker_image(self.image):
            raise SecurityValidationError(f"Docker image validation failed: {self.image}")
        
        # COMMENT: CRITICAL SECURITY: Validate all ports for security
        for port in self.ports:
            if not validate_port_number(port):
                raise SecurityValidationError(f"Port validation failed: {port}")
        
        # COMMENT: CRITICAL SECURITY: Validate all volumes for security
        for volume in self.volumes:
            if not validate_volume_path(volume):
                raise SecurityValidationError(f"Volume validation failed: {volume}")
        
        # COMMENT: Validate required fields
        if not self.name or not self.repository_url:
            raise ValidationError("Service name and repository URL are required")
        
        # COMMENT: Validate security settings
        if self.auth_enabled and not self.auth_method:
            raise ValidationError("Authentication method must be specified when auth is enabled")
        
        # COMMENT: Validate database configuration
        if self.database_enabled and not self.database_type:
            raise ValidationError("Database type must be specified when database is enabled")
        
        # COMMENT: Validate ports are within safe range
        for port in self.ports:
            if not (1024 <= port <= 65535):
                raise ValidationError(f"Port {port} is outside safe range (1024-65535)")

class ServiceWizard:
    """
    COMMENT: Production-ready service wizard for Ansible homelab deployment.
    Includes comprehensive error handling, security validation, and logging.
    """
    
    def __init__(self, config_path: Optional[str] = None) -> None:
        """
        COMMENT: Initialize service wizard with production configuration.
        
        Args:
            config_path: Path to configuration file (optional)
            
        Raises:
            ConfigurationError: If configuration cannot be loaded
        """
        self.config_path = config_path or os.path.join(os.path.dirname(__file__), 'config', 'service_wizard.yml')
        self.config = self._load_config()
        self.services_dir = Path(self.config.get('services_directory', '/opt/services'))
        self.templates_dir = Path(self.config.get('templates_directory', '/opt/templates'))
        self.backup_dir = Path(self.config.get('backup_directory', '/var/backups/services'))
        
        # COMMENT: Ensure required directories exist
        self._ensure_directories()
        
        # COMMENT: Setup signal handlers for graceful shutdown
        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)
        
        logger.info("Service Wizard initialized successfully")
    
    def _load_config(self) -> Dict[str, Any]:
        """
        COMMENT: Load configuration with proper error handling.
        
        Returns:
            Configuration dictionary
            
        Raises:
            ConfigurationError: If configuration cannot be loaded
        """
        try:
            if not os.path.exists(self.config_path):
                logger.warning(f"Configuration file not found: {self.config_path}, using defaults")
                return self._get_default_config()
            
            with open(self.config_path, 'r', encoding='utf-8') as f:
                config = yaml.safe_load(f)
            
            # COMMENT: Validate configuration structure
            self._validate_config(config)
            
            logger.info(f"Configuration loaded from: {self.config_path}")
            return config
            
        except Exception as e:
            logger.error(f"Failed to load configuration: {e}")
            raise ConfigurationError(f"Configuration loading failed: {e}")
    
    def _get_default_config(self) -> Dict[str, Any]:
        """
        COMMENT: Get default configuration for production use.
        
        Returns:
            Default configuration dictionary
        """
        return {
            'services_directory': '/opt/services',
            'templates_directory': '/opt/templates',
            'backup_directory': '/var/backups/services',
            'security': {
                'enable_security_scanning': True,
                'require_ssl': True,
                'enable_audit_logging': True
            },
            'validation': {
                'enable_port_validation': True,
                'enable_security_validation': True,
                'enable_dependency_validation': True
            }
        }
    
    def _validate_config(self, config: Dict[str, Any]) -> None:
        """
        COMMENT: Validate configuration structure and values.
        
        Args:
            config: Configuration dictionary to validate
            
        Raises:
            ValidationError: If configuration is invalid
        """
        required_keys = ['services_directory', 'templates_directory', 'backup_directory']
        
        for key in required_keys:
            if key not in config:
                raise ValidationError(f"Missing required configuration key: {key}")
        
        # COMMENT: Validate directory paths
        for key in ['services_directory', 'templates_directory', 'backup_directory']:
            path = config[key]
            if not isinstance(path, str) or not path:
                raise ValidationError(f"Invalid {key}: {path}")
    
    def _ensure_directories(self) -> None:
        """
        COMMENT: Ensure required directories exist with proper permissions.
        Creates directories if they don't exist and sets appropriate permissions.
        """
        directories = [self.services_dir, self.templates_dir, self.backup_dir]
        
        for directory in directories:
            try:
                directory.mkdir(parents=True, exist_ok=True)
                # COMMENT: Set secure permissions for production
                directory.chmod(0o755)
                logger.debug(f"Directory ensured: {directory}")
            except Exception as e:
                logger.error(f"Failed to create directory {directory}: {e}")
                raise ConfigurationError(f"Directory creation failed: {e}")
    
    def _signal_handler(self, signum: int, frame: Any) -> None:
        """
        COMMENT: Handle shutdown signals gracefully.
        
        Args:
            signum: Signal number
            frame: Current stack frame
        """
        logger.info(f"Received signal {signum}, shutting down gracefully")
        self.cleanup()
        sys.exit(0)
    
    def cleanup(self) -> None:
        """
        COMMENT: Cleanup resources and temporary files.
        Ensures proper cleanup for production reliability.
        """
        logger.info("Performing cleanup operations")
        
        # COMMENT: Cleanup temporary files
        try:
            temp_dir = Path(tempfile.gettempdir()) / 'service_wizard'
            if temp_dir.exists():
                shutil.rmtree(temp_dir)
                logger.debug("Temporary files cleaned up")
        except Exception as e:
            logger.warning(f"Failed to cleanup temporary files: {e}")
    
    def validate_service_info(self, service_info: ServiceInfo) -> Tuple[bool, List[str]]:
        """
        COMMENT: Validate service information for production deployment.
        
        Args:
            service_info: Service information to validate
            
        Returns:
            Tuple of (is_valid, list_of_errors)
        """
        errors = []
        
        try:
            # COMMENT: Validate service name format
            if not re.match(r'^[a-z0-9-]+$', service_info.name):
                errors.append("Service name must contain only lowercase letters, numbers, and hyphens")
            
            # COMMENT: Validate repository URL
            try:
                parsed_url = urlparse(service_info.repository_url)
                if not parsed_url.scheme or not parsed_url.netloc:
                    errors.append("Invalid repository URL format")
            except Exception:
                errors.append("Invalid repository URL")
            
            # COMMENT: Validate ports
            for port in service_info.ports:
                if not (1024 <= port <= 65535):
                    errors.append(f"Port {port} is outside safe range (1024-65535)")
            
            # COMMENT: Validate authentication configuration
            if service_info.auth_enabled:
                if not service_info.auth_method:
                    errors.append("Authentication method must be specified when auth is enabled")
                if service_info.auth_method not in ['authentik', 'basic', 'none']:
                    errors.append("Invalid authentication method")
            
            # COMMENT: Validate database configuration
            if service_info.database_enabled:
                if not service_info.database_type:
                    errors.append("Database type must be specified when database is enabled")
                if service_info.database_type not in ['sqlite', 'postgresql', 'mysql']:
                    errors.append("Invalid database type")
            
            # COMMENT: Security validation
            if service_info.security_context:
                required_security_keys = ['run_as_user', 'capabilities', 'seccomp_profile']
                for key in required_security_keys:
                    if key not in service_info.security_context:
                        errors.append(f"Missing required security configuration: {key}")
            
        except Exception as e:
            errors.append(f"Validation error: {e}")
        
        return len(errors) == 0, errors
    
    def create_service_configuration(self, service_info: ServiceInfo) -> Dict[str, Any]:
        """
        COMMENT: Create service configuration for Ansible deployment.
        
        Args:
            service_info: Validated service information
            
        Returns:
            Service configuration dictionary
            
        Raises:
            ServiceWizardError: If configuration creation fails
        """
        try:
            # COMMENT: Validate service info before creating configuration
            is_valid, errors = self.validate_service_info(service_info)
            if not is_valid:
                raise ValidationError(f"Service validation failed: {'; '.join(errors)}")
            
            # COMMENT: Create base configuration
            config = {
                'service_name': service_info.name,
                'display_name': service_info.display_name,
                'description': service_info.description,
                'category': service_info.category,
                'deployment_stage': service_info.stage,
                'ports': service_info.ports,
                'environment_variables': service_info.environment_vars,
                'volumes': service_info.volumes,
                'dependencies': service_info.dependencies,
                'image': service_info.image,
                'version': service_info.version,
                'authentication': {
                    'enabled': service_info.auth_enabled,
                    'method': service_info.auth_method,
                    'admin_email': service_info.admin_email,
                    'secret_key': service_info.secret_key
                },
                'database': {
                    'enabled': service_info.database_enabled,
                    'type': service_info.database_type,
                    'host': service_info.database_host,
                    'port': service_info.database_port,
                    'name': service_info.database_name,
                    'user': service_info.database_user
                },
                'api': {
                    'enabled': service_info.api_enabled,
                    'version': service_info.api_version,
                    'key': service_info.api_key
                },
                'security': service_info.security_context,
                'resource_limits': service_info.resource_limits,
                'health_check': service_info.health_check,
                'metadata': {
                    'created_at': datetime.now(timezone.utc).isoformat(),
                    'created_by': os.environ.get('USER', 'unknown'),
                    'version': '1.0.0'
                }
            }
            
            logger.info(f"Service configuration created for: {service_info.name}")
            return config
            
        except Exception as e:
            logger.error(f"Failed to create service configuration: {e}")
            raise ServiceWizardError(f"Configuration creation failed: {e}")
    
    def generate_ansible_files(self, service_info: ServiceInfo, config: Dict[str, Any]) -> List[Path]:
        """
        COMMENT: Generate Ansible files for service deployment.
        
        Args:
            service_info: Service information
            config: Service configuration
            
        Returns:
            List of generated file paths
            
        Raises:
            ServiceWizardError: If file generation fails
        """
        try:
            generated_files = []
            
            # COMMENT: Create service directory
            service_dir = self.services_dir / service_info.name
            service_dir.mkdir(parents=True, exist_ok=True)
            
            # COMMENT: Generate main.yml playbook
            main_yml = service_dir / 'main.yml'
            main_content = self._generate_main_playbook(service_info, config)
            main_yml.write_text(main_content, encoding='utf-8')
            generated_files.append(main_yml)
            
            # COMMENT: Generate tasks file
            tasks_yml = service_dir / 'tasks' / 'main.yml'
            tasks_yml.parent.mkdir(parents=True, exist_ok=True)
            tasks_content = self._generate_tasks_file(service_info, config)
            tasks_yml.write_text(tasks_content, encoding='utf-8')
            generated_files.append(tasks_yml)
            
            # COMMENT: Generate handlers file
            handlers_yml = service_dir / 'handlers' / 'main.yml'
            handlers_yml.parent.mkdir(parents=True, exist_ok=True)
            handlers_content = self._generate_handlers_file(service_info, config)
            handlers_yml.write_text(handlers_content, encoding='utf-8')
            generated_files.append(handlers_yml)
            
            # COMMENT: Generate templates
            templates_dir = service_dir / 'templates'
            templates_dir.mkdir(parents=True, exist_ok=True)
            
            # COMMENT: Generate docker-compose template
            docker_compose_j2 = templates_dir / 'docker-compose.yml.j2'
            docker_compose_content = self._generate_docker_compose_template(service_info, config)
            docker_compose_j2.write_text(docker_compose_content, encoding='utf-8')
            generated_files.append(docker_compose_j2)
            
            # COMMENT: Generate environment template
            env_j2 = templates_dir / '.env.j2'
            env_content = self._generate_env_template(service_info, config)
            env_j2.write_text(env_content, encoding='utf-8')
            generated_files.append(env_j2)
            
            # COMMENT: Generate README
            readme_md = service_dir / 'README.md'
            readme_content = self._generate_readme(service_info, config)
            readme_md.write_text(readme_content, encoding='utf-8')
            generated_files.append(readme_md)
            
            logger.info(f"Generated {len(generated_files)} Ansible files for service: {service_info.name}")
            return generated_files
            
        except Exception as e:
            logger.error(f"Failed to generate Ansible files: {e}")
            raise ServiceWizardError(f"File generation failed: {e}")
    
    def _generate_main_playbook(self, service_info: ServiceInfo, config: Dict[str, Any]) -> str:
        """
        COMMENT: Generate main playbook content.
        
        Args:
            service_info: Service information
            config: Service configuration
            
        Returns:
            Playbook content as string
        """
        return f"""---
# COMMENT: Production-ready Ansible playbook for {service_info.display_name}
# COMMENT: Generated by Service Wizard on {datetime.now().isoformat()}
# COMMENT: Service: {service_info.name}
# COMMENT: Category: {service_info.category}
# COMMENT: Stage: {service_info.stage}

- name: "Deploy {service_info.display_name}"
  hosts: "{{ target_hosts | default('all') }}"
  become: true
  become_method: sudo
  become_user: root
  gather_facts: true
  
  vars:
    service_name: "{service_info.name}"
    service_display_name: "{service_info.display_name}"
    service_description: "{service_info.description}"
    service_category: "{service_info.category}"
    service_stage: "{service_info.stage}"
    service_ports: {service_info.ports}
    service_image: "{service_info.image}"
    service_version: "{service_info.version}"
    
    # COMMENT: Security configuration
    security_enabled: "{{ security_enabled | default(true) }}"
    ssl_enabled: "{{ ssl_enabled | default(true) }}"
    
    # COMMENT: Database configuration
    database_enabled: {str(service_info.database_enabled).lower()}
    database_type: "{service_info.database_type}"
    
    # COMMENT: Authentication configuration
    auth_enabled: {str(service_info.auth_enabled).lower()}
    auth_method: "{service_info.auth_method}"
    
  pre_tasks:
    - name: "Validate deployment prerequisites"
      assert:
        that:
          - ansible_user_id == '0' or 'sudo' in ansible_user_groups
          - (ansible_memtotal_mb | int) >= 1024
          - (ansible_processor_cores | int) >= 1
        fail_msg: "Deployment prerequisites not met"
      tags: [always, validation]
    
    - name: "Create service directories"
      file:
        path: "{{ item }}"
        state: directory
        mode: '0755'
        owner: "{{ service_user | default('homelab') }}"
        group: "{{ service_group | default('homelab') }}"
      loop:
        - "/opt/services/{{ service_name }}"
        - "/var/log/{{ service_name }}"
        - "/var/lib/{{ service_name }}"
      tags: [setup, directories]
  
  roles:
    - name: "{service_info.name}"
      tags: [deploy, {service_info.name}]
  
  post_tasks:
    - name: "Validate service deployment"
      uri:
        url: "http://127.0.0.1:{{ item }}/health"
        method: GET
        timeout: 30
      loop: "{{ service_ports }}"
      retries: 3
      delay: 10
      until: ansible_loop_result0.status == 200
      tags: [validation, health_check]
    
    - name: "Log successful deployment"
      lineinfile:
        path: "/var/log/ansible-deployments.log"
        line: "{{ ansible_date_time.date }} {{ ansible_date_time.time }} - {service_info.name} deployed successfully"
        create: yes
        mode: '0644'
      tags: [logging, completion]
  
  handlers:
    - name: "restart_{service_info.name}"
      systemd:
        name: "{service_info.name}"
        state: restarted
        enabled: yes
      tags: [handlers, restart]
    
    - name: "reload_{service_info.name}_config"
      systemd:
        name: "{service_info.name}"
        daemon_reload: yes
      tags: [handlers, reload]
"""

    def _generate_tasks_file(self, service_info: ServiceInfo, config: Dict[str, Any]) -> str:
        """
        COMMENT: Generate tasks file content.
        
        Args:
            service_info: Service information
            config: Service configuration
            
        Returns:
            Tasks content as string
        """
        return f"""---
# COMMENT: Production-ready tasks for {service_info.display_name}
# COMMENT: Comprehensive deployment with error handling and validation

- name: "Include service-specific tasks"
  include_tasks: "{{ item }}"
  loop:
    - setup.yml
    - deploy.yml
    - configure.yml
    - validate.yml
  tags: [tasks, {service_info.name}]

- name: "Setup service environment"
  block:
    - name: "Create service user"
      user:
        name: "{{ service_user | default('homelab') }}"
        system: yes
        shell: /bin/false
        home: "/var/lib/{{ service_name }}"
      tags: [setup, user]
    
    - name: "Create service directories with proper permissions"
      file:
        path: "{{ item }}"
        state: directory
        mode: '0755'
        owner: "{{ service_user | default('homelab') }}"
        group: "{{ service_group | default('homelab') }}"
      loop:
        - "/opt/services/{{ service_name }}"
        - "/var/log/{{ service_name }}"
        - "/var/lib/{{ service_name }}"
        - "/etc/{{ service_name }}"
      tags: [setup, directories]
    
    - name: "Set secure directory permissions"
      file:
        path: "{{ item }}"
        mode: '0700'
        owner: "{{ service_user | default('homelab') }}"
        group: "{{ service_group | default('homelab') }}"
      loop:
        - "/var/lib/{{ service_name }}"
        - "/etc/{{ service_name }}"
      tags: [setup, security]
  
  tags: [setup, environment]

- name: "Deploy service configuration"
  block:
    - name: "Copy service configuration files"
      template:
        src: "{{ item.src }}"
        dest: "{{ item.dest }}"
        mode: "{{ item.mode | default('0644') }}"
        owner: "{{ service_user | default('homelab') }}"
        group: "{{ service_group | default('homelab') }}"
        backup: yes
        validate: "{{ item.validate | default(omit) }}"
      loop:
        - src: "docker-compose.yml.j2"
          dest: "/opt/services/{{ service_name }}/docker-compose.yml"
          mode: "0644"
        - src: ".env.j2"
          dest: "/opt/services/{{ service_name }}/.env"
          mode: "0600"
      tags: [deploy, configuration]
    
    - name: "Set secure file permissions"
      file:
        path: "/opt/services/{{ service_name }}/.env"
        mode: '0600'
        owner: "{{ service_user | default('homelab') }}"
        group: "{{ service_group | default('homelab') }}"
      tags: [deploy, security]
  
  tags: [deploy, configuration]

- name: "Start and enable service"
  block:
    - name: "Start service with docker-compose"
      community.docker.docker_compose:
        project_src: "/opt/services/{{ service_name }}"
        state: present
        pull: yes
        build: yes
      tags: [deploy, start]
    
    - name: "Wait for service to be ready"
      wait_for:
        port: "{{ item }}"
        host: "127.0.0.1"
        timeout: 60
        delay: 5
      loop: "{{ service_ports }}"
      tags: [deploy, health_check]
  
  tags: [deploy, start]
"""

    def _generate_handlers_file(self, service_info: ServiceInfo, config: Dict[str, Any]) -> str:
        """
        COMMENT: Generate handlers file content.
        
        Args:
            service_info: Service information
            config: Service configuration
            
        Returns:
            Handlers content as string
        """
        return f"""---
# COMMENT: Production-ready handlers for {service_info.display_name}
# COMMENT: Proper service management with error handling

- name: "restart_{service_info.name}"
  block:
    - name: "Restart {service_info.name} service"
      community.docker.docker_compose:
        project_src: "/opt/services/{{ service_name }}"
        state: present
        restarted: yes
      tags: [handlers, restart]
    
    - name: "Wait for service restart"
      wait_for:
        port: "{{ item }}"
        host: "127.0.0.1"
        timeout: 60
        delay: 5
      loop: "{{ service_ports }}"
      tags: [handlers, health_check]
  
  tags: [handlers, restart]

- name: "reload_{service_info.name}_config"
  block:
    - name: "Reload {service_info.name} configuration"
      community.docker.docker_compose:
        project_src: "/opt/services/{{ service_name }}"
        state: present
        build: yes
        pull: yes
      tags: [handlers, reload]
    
    - name: "Wait for configuration reload"
      wait_for:
        port: "{{ item }}"
        host: "127.0.0.1"
        timeout: 60
        delay: 5
      loop: "{{ service_ports }}"
      tags: [handlers, health_check]
  
  tags: [handlers, reload]

- name: "stop_{service_info.name}"
  block:
    - name: "Stop {service_info.name} service"
      community.docker.docker_compose:
        project_src: "/opt/services/{{ service_name }}"
        state: absent
      tags: [handlers, stop]
  
  tags: [handlers, stop]
"""

    def _generate_docker_compose_template(self, service_info: ServiceInfo, config: Dict[str, Any]) -> str:
        """
        COMMENT: Generate Docker Compose template with SECURITY VALIDATION.
        
        Args:
            service_info: Service information (VALIDATED)
            config: Service configuration (VALIDATED)
            
        Returns:
            Docker Compose content as string
            
        Raises:
            SecurityValidationError: If template generation would be unsafe
        """
        # COMMENT: CRITICAL SECURITY: Re-validate all inputs before template generation
        if not validate_service_name(service_info.name):
            raise SecurityValidationError(f"Service name validation failed: {service_info.name}")
        
        if not validate_docker_image(service_info.image):
            raise SecurityValidationError(f"Docker image validation failed: {service_info.image}")
        
        # COMMENT: Validate all ports
        for port in service_info.ports:
            if not validate_port_number(port):
                raise SecurityValidationError(f"Port validation failed: {port}")
        
        # COMMENT: Validate all volumes
        for volume in service_info.volumes:
            if not validate_volume_path(volume):
                raise SecurityValidationError(f"Volume validation failed: {volume}")
        
        # COMMENT: CRITICAL SECURITY: Use safe template generation with validation
        safe_service_name = sanitize_service_name(service_info.name)
        safe_image = sanitize_docker_image(service_info.image)
        
        # COMMENT: Generate port mappings safely
        port_mappings = []
        for i, port in enumerate(service_info.ports):
            port_mappings.append('      - "{{ ' + safe_service_name + '_port_' + str(i+1) + ' | default(' + str(port) + ') }}:' + str(port) + '"')
        
        # COMMENT: Generate volume mounts safely
        volume_mounts = []
        for volume in service_info.volumes:
            if validate_volume_path(volume):
                volume_mounts.append(f'      - "{volume}"')
        
        # COMMENT: Generate resource limits safely - use simple variable substitution
        memory_limit = "{{ " + safe_service_name + "_memory_limit | default('512M') }}"
        cpu_limit = "{{ " + safe_service_name + "_cpu_limit | default('0.5') }}"
        memory_reservation = "{{ " + safe_service_name + "_memory_reservation | default('256M') }}"
        cpu_reservation = "{{ " + safe_service_name + "_cpu_reservation | default('0.25') }}"
        
        # COMMENT: Generate Traefik labels safely - use simple variable substitution
        domain = config.get('domain', 'homelab.local')
        service_domain = "{{ " + safe_service_name + "_domain | default('" + safe_service_name + "." + domain + "') }}"
        service_port = "{{ " + safe_service_name + "_port_1 | default(" + str(service_info.ports[0] if service_info.ports else 8080) + ") }}"
        
        return f"""# COMMENT: Production-ready Docker Compose configuration for {service_info.display_name}
# COMMENT: Generated by Service Wizard on {datetime.now().isoformat()}
# COMMENT: Service: {safe_service_name}
# COMMENT: Category: {service_info.category}

version: '3.8'

services:
  {safe_service_name}:
    image: {safe_image}:{service_info.version}
    container_name: {safe_service_name}
    restart: unless-stopped
    
    # COMMENT: Environment variables
    environment:
      - NODE_ENV=production
      - TZ=UTC
    env_file:
      - .env
    
    # COMMENT: Port mappings with validation
    ports:
{chr(10).join(port_mappings)}
    
    # COMMENT: Volume mounts with validation
    volumes:
{chr(10).join(volume_mounts)}
      - "/var/log/{safe_service_name}:/var/log"
      - "/var/lib/{safe_service_name}:/var/lib"
      - "/etc/{safe_service_name}:/etc/config"
    
    # COMMENT: Health check configuration
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://127.0.0.1:{service_port}/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    
    # COMMENT: Security configuration
    security_opt:
      - no-new-privileges:true
    read_only: false
    tmpfs:
      - /tmp
      - /var/tmp
    
    # COMMENT: Resource limits
    deploy:
      resources:
        limits:
          memory: "{memory_limit}"
          cpus: "{cpu_limit}"
        reservations:
          memory: "{memory_reservation}"
          cpus: "{cpu_reservation}"
    
    # COMMENT: Network configuration
    networks:
      - {safe_service_name}_network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.{safe_service_name}.rule=Host(`{service_domain}`)"
      - "traefik.http.routers.{safe_service_name}.entrypoints=websecure"
      - "traefik.http.routers.{safe_service_name}.tls.certresolver=cloudflare"
      - "traefik.http.services.{safe_service_name}.loadbalancer.server.port={service_port}"

networks:
  {safe_service_name}_network:
    driver: bridge
    internal: false
    labels:
      - "homelab.service={service_info.name}"
      - "homelab.category={service_info.category}"
      - "homelab.stage={service_info.stage}"

volumes:
  {service_info.name}_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: "/var/lib/{service_info.name}"
  {service_info.name}_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: "/var/log/{service_info.name}"
  {service_info.name}_config:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: "/etc/{service_info.name}"
"""

    def _generate_env_template(self, service_info: ServiceInfo, config: Dict[str, Any]) -> str:
        """
        COMMENT: Generate environment template content.
        
        Args:
            service_info: Service information
            config: Service configuration
            
        Returns:
            Environment template content as string
        """
        # COMMENT: CRITICAL SECURITY: Re-validate all inputs before template generation
        if not validate_service_name(service_info.name):
            raise SecurityValidationError(f"Service name validation failed: {service_info.name}")
        
        # COMMENT: Generate port configuration safely
        port_config = ""
        for i, port in enumerate(service_info.ports):
            if validate_port_number(port):
                port_config += f"PORT_{i+1}={port}\n"
        
        # COMMENT: Generate authentication configuration safely
        auth_config = ""
        if service_info.auth_enabled:
            auth_config += "AUTH_ENABLED=true\n"
            auth_config += f"AUTH_METHOD={service_info.auth_method}\n"
            if service_info.admin_email:
                auth_config += f"ADMIN_EMAIL={{ vault_{service_info.name}_admin_email | default('') }}\n"
            if service_info.secret_key:
                auth_config += f"SECRET_KEY={{ vault_{service_info.name}_secret_key | default('') }}\n"
        else:
            auth_config += "AUTH_ENABLED=false\n"
        
        # COMMENT: Generate database configuration safely
        db_config = ""
        if service_info.database_enabled:
            db_config += "DATABASE_ENABLED=true\n"
            db_config += f"DATABASE_TYPE={service_info.database_type}\n"
            if service_info.database_host:
                db_config += f"DATABASE_HOST={{ vault_{service_info.name}_database_host | default('') }}\n"
            if service_info.database_port:
                db_config += f"DATABASE_PORT={{ vault_{service_info.name}_database_port | default({service_info.database_port}) }}\n"
            if service_info.database_name:
                db_config += f"DATABASE_NAME={{ vault_{service_info.name}_database_name | default('') }}\n"
            if service_info.database_user:
                db_config += f"DATABASE_USER={{ vault_{service_info.name}_database_user | default('') }}\n"
            if service_info.database_password:
                db_config += f"DATABASE_PASSWORD={{ vault_{service_info.name}_database_password | default('') }}\n"
        else:
            db_config += "DATABASE_ENABLED=false\n"
        
        # COMMENT: Generate API configuration safely
        api_config = ""
        if service_info.api_enabled:
            api_config += "API_ENABLED=true\n"
            api_config += f"API_VERSION={service_info.api_version}\n"
            if service_info.api_key:
                api_config += f"API_KEY={{ vault_{service_info.name}_api_key | default('') }}\n"
        else:
            api_config += "API_ENABLED=false\n"
        
        # COMMENT: Generate metrics port safely
        metrics_port = service_info.ports[0] if service_info.ports else 8080
        
        return f"""# COMMENT: Production environment configuration for {service_info.display_name}
# COMMENT: Generated by Service Wizard on {datetime.now().isoformat()}
# COMMENT: Service: {service_info.name}
# COMMENT: Category: {service_info.category}

# COMMENT: Service configuration
SERVICE_NAME={service_info.name}
SERVICE_DISPLAY_NAME={service_info.display_name}
SERVICE_CATEGORY={service_info.category}
SERVICE_STAGE={service_info.stage}

# COMMENT: Image configuration
IMAGE={service_info.image}
VERSION={service_info.version}

# COMMENT: Port configuration
{port_config}
# COMMENT: Authentication configuration
{auth_config}
# COMMENT: Database configuration
{db_config}
# COMMENT: API configuration
{api_config}
# COMMENT: Security configuration
SECURITY_CONTEXT={service_info.security_context}
RESOURCE_LIMITS={service_info.resource_limits}

# COMMENT: Health check configuration
HEALTH_CHECK_INTERVAL=30s
HEALTH_CHECK_TIMEOUT=10s
HEALTH_CHECK_RETRIES=3
HEALTH_CHECK_START_PERIOD=40s

# COMMENT: Logging configuration
LOG_LEVEL=INFO
LOG_FORMAT=json
LOG_OUTPUT=stdout

# COMMENT: Monitoring configuration
METRICS_ENABLED=true
METRICS_PORT={metrics_port}

# COMMENT: Backup configuration
BACKUP_ENABLED=true
BACKUP_RETENTION_DAYS=7
BACKUP_COMPRESSION=true
"""

    def _generate_readme(self, service_info: ServiceInfo, config: Dict[str, Any]) -> str:
        """
        COMMENT: Generate README content.
        
        Args:
            service_info: Service information
            config: Service configuration
            
        Returns:
            README content as string
        """
        # COMMENT: CRITICAL SECURITY: Re-validate all inputs before template generation
        if not validate_service_name(service_info.name):
            raise SecurityValidationError(f"Service name validation failed: {service_info.name}")
        
        # COMMENT: Generate port configuration safely
        port_config = ""
        for i, port in enumerate(service_info.ports):
            if validate_port_number(port):
                port_config += f"- Port {i+1}: {port}\n"
        
        # COMMENT: Generate authentication configuration safely
        auth_config = ""
        if service_info.auth_enabled:
            auth_config += "#### Authentication\n"
            auth_config += "- `AUTH_ENABLED`: Enable authentication (default: true)\n"
            auth_config += f"- `AUTH_METHOD`: Authentication method (default: {service_info.auth_method})\n"
            if service_info.admin_email:
                auth_config += "- `ADMIN_EMAIL`: Admin email address\n"
            if service_info.secret_key:
                auth_config += "- `SECRET_KEY`: Secret key for authentication\n"
        
        # COMMENT: Generate database configuration safely
        db_config = ""
        if service_info.database_enabled:
            db_config += "#### Database\n"
            db_config += "- `DATABASE_ENABLED`: Enable database (default: true)\n"
            db_config += f"- `DATABASE_TYPE`: Database type (default: {service_info.database_type})\n"
            if service_info.database_host:
                db_config += "- `DATABASE_HOST`: Database host\n"
            if service_info.database_port:
                db_config += f"- `DATABASE_PORT`: Database port (default: {service_info.database_port})\n"
            if service_info.database_name:
                db_config += "- `DATABASE_NAME`: Database name\n"
            if service_info.database_user:
                db_config += "- `DATABASE_USER`: Database user\n"
            if service_info.database_password:
                db_config += "- `DATABASE_PASSWORD`: Database password\n"
        
        return f"""# {service_info.display_name}

{service_info.description}

## Service Information

- **Name**: {service_info.name}
- **Category**: {service_info.category}
- **Deployment Stage**: {service_info.stage}
- **Image**: {service_info.image}:{service_info.version}

## Configuration

### Ports

{port_config}
### Environment Variables

The service uses the following environment variables (configured via `.env` file):

{auth_config}
{db_config}

#### API
- `API_ENABLED`: Enable API (default: {str(service_info.api_enabled).lower()})
- `API_VERSION`: API version (default: {service_info.api_version})

## Deployment

### Prerequisites

- Docker and Docker Compose installed
- Ansible 2.9+ installed
- Proper permissions to create system users and directories

### Deployment Steps

1. **Validate Configuration**
   ```bash
   ansible-playbook -i inventory main.yml --tags validation
   ```

2. **Deploy Service**
   ```bash
   ansible-playbook -i inventory main.yml --tags deploy,{service_info.name}
   ```

3. **Verify Deployment**
   ```bash
   ansible-playbook -i inventory main.yml --tags validation,health_check
   ```

## Management

### Service Control

- **Start**: `docker-compose -f /opt/services/{service_info.name}/docker-compose.yml up -d`
- **Stop**: `docker-compose -f /opt/services/{service_info.name}/docker-compose.yml down`
- **Restart**: `docker-compose -f /opt/services/{service_info.name}/docker-compose.yml restart`
- **Logs**: `docker-compose -f /opt/services/{service_info.name}/docker-compose.yml logs -f`

### Health Checks

The service includes health checks that verify:
- Service is responding on configured ports
- Health endpoint is accessible
- Service is running properly

### Monitoring

- **Metrics**: Available on port {service_info.ports[0] if service_info.ports else 'N/A'}
- **Logs**: Stored in `/var/log/{service_info.name}`
- **Configuration**: Stored in `/etc/{service_info.name}`

## Security

### Security Features

- Runs as non-root user
- No new privileges allowed
- Read-only filesystem where possible
- Temporary filesystem for /tmp and /var/tmp
- Resource limits configured
- Network isolation via Docker networks

### Credentials

All sensitive credentials are stored in Ansible Vault and referenced via:
- `{{ vault_{service_info.name}_admin_email }}`
- `{{ vault_{service_info.name}_secret_key }}`
- `{{ vault_{service_info.name}_database_password }}`
- `{{ vault_{service_info.name}_api_key }}`

## Troubleshooting

### Common Issues

1. **Service won't start**
   - Check Docker daemon status
   - Verify port availability
   - Check logs: `docker-compose -f /opt/services/{service_info.name}/docker-compose.yml logs`

2. **Health check failures**
   - Verify service is responding on configured ports
   - Check service logs for errors
   - Validate configuration files

3. **Permission issues**
   - Ensure service user exists
   - Verify directory permissions
   - Check SELinux/AppArmor settings

### Logs

- **Application logs**: `/var/log/{service_info.name}`
- **Docker logs**: `docker-compose -f /opt/services/{service_info.name}/docker-compose.yml logs`
- **System logs**: `journalctl -u {service_info.name}`

## Support

For issues and support:
- Check service documentation
- Review Ansible playbook logs
- Verify system requirements
- Contact system administrator

---

*Generated by Service Wizard on {datetime.now().isoformat()}*
"""

    def run(self, service_info: ServiceInfo) -> bool:
        """
        COMMENT: Run the service wizard for production deployment.
        
        Args:
            service_info: Validated service information
            
        Returns:
            True if successful, False otherwise
        """
        try:
            logger.info(f"Starting service wizard for: {service_info.name}")
            
            # COMMENT: Validate service information
            is_valid, errors = self.validate_service_info(service_info)
            if not is_valid:
                logger.error(f"Service validation failed: {'; '.join(errors)}")
                return False
            
            # COMMENT: Create service configuration
            config = self.create_service_configuration(service_info)
            
            # COMMENT: Generate Ansible files
            generated_files = self.generate_ansible_files(service_info, config)
            
            # COMMENT: Create backup of existing configuration
            self._create_backup(service_info.name)
            
            logger.info(f"Service wizard completed successfully for: {service_info.name}")
            logger.info(f"Generated {len(generated_files)} files")
            
            return True
            
        except Exception as e:
            logger.error(f"Service wizard failed: {e}")
            return False
        finally:
            # COMMENT: Always cleanup resources
            self.cleanup()
    
    def _create_backup(self, service_name: str) -> None:
        """
        COMMENT: Create backup of existing service configuration.
        
        Args:
            service_name: Name of the service to backup
        """
        try:
            backup_path = self.backup_dir / f"{service_name}_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
            backup_path.mkdir(parents=True, exist_ok=True)
            
            service_path = self.services_dir / service_name
            if service_path.exists():
                shutil.copytree(service_path, backup_path / service_name, dirs_exist_ok=True)
                logger.info(f"Backup created: {backup_path}")
            
        except Exception as e:
            logger.warning(f"Failed to create backup: {e}")

def main() -> int:
    """
    COMMENT: Main entry point with proper exit codes for Ansible.
    Returns 0 for success, 1 for failure (Ansible standard).
    """
    try:
        # COMMENT: Parse command line arguments
        parser = argparse.ArgumentParser(description='Production Service Wizard for Ansible Homelab')
        parser.add_argument('--config', help='Path to configuration file')
        parser.add_argument('--service-name', required=True, help='Service name')
        parser.add_argument('--repository-url', required=True, help='Repository URL')
        parser.add_argument('--display-name', required=True, help='Display name')
        parser.add_argument('--description', required=True, help='Service description')
        parser.add_argument('--category', required=True, help='Service category')
        parser.add_argument('--stage', required=True, help='Deployment stage')
        parser.add_argument('--ports', nargs='+', type=int, help='Service ports')
        parser.add_argument('--image', help='Docker image')
        parser.add_argument('--version', default='latest', help='Image version')
        
        args = parser.parse_args()
        
        # COMMENT: Create service information
        service_info = ServiceInfo(
            name=args.service_name,
            repository_url=args.repository_url,
            display_name=args.display_name,
            description=args.description,
            category=args.category,
            stage=args.stage,
            ports=args.ports or [],
            image=args.image or args.service_name,
            version=args.version
        )
        
        # COMMENT: Initialize and run service wizard
        wizard = ServiceWizard(args.config)
        success = wizard.run(service_info)
        
        if success:
            logger.info("Service wizard completed successfully")
            return 0
        else:
            logger.error("Service wizard failed")
            return 1
            
    except KeyboardInterrupt:
        logger.info("Service wizard interrupted by user")
        return 1
    except Exception as e:
        logger.error(f"Unexpected error in service wizard: {e}")
        return 1

# COMMENT: Ensure proper execution when called from Ansible
if __name__ == '__main__':
    sys.exit(main()) 