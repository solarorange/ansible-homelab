#!/usr/bin/env python3
"""
Test script to verify logging infrastructure across all components.
Tests log generation, Loki scraping, and log format consistency.
"""

import os
import sys
import json
import time
import subprocess
import requests
from datetime import datetime, timedelta
from pathlib import Path

# Add the homepage scripts directory to the path
sys.path.append(str(Path(__file__).parent.parent / 'homepage' / 'scripts'))

from logging_config import setup_logging, get_logger

class LoggingInfrastructureTester:
    def __init__(self):
        setup_logging(log_dir="./logs")
        self.logger = get_logger('logging_test')
        self.test_results = {
            'python_scripts': [],
            'shell_scripts': [],
            'ansible_tasks': [],
            'docker_compose': [],
            'loki_scraping': [],
            'promtail_config': []
        }
        
    def test_python_script_logging(self):
        """Test Python script logging functionality."""
        self.logger.info("Testing Python script logging infrastructure")
        
        test_scripts = [
            'homepage/scripts/health_monitor.py',
            'homepage/scripts/service_discovery.py',
            'homepage/scripts/validate_production.py',
            'homepage/scripts/api_key_manager.py'
        ]
        
        for script_path in test_scripts:
            if os.path.exists(script_path):
                try:
                    # Test script import and logging setup
                    result = subprocess.run([
                        'python3', '-c', 
                        f'import sys; sys.path.append("homepage/scripts"); import {script_path.split("/")[-1].replace(".py", "")}'
                    ], capture_output=True, text=True, timeout=30)
                    
                    if result.returncode == 0:
                        self.test_results['python_scripts'].append({
                            'script': script_path,
                            'status': 'PASS',
                            'message': 'Script imports and logging setup successful'
                        })
                    else:
                        self.test_results['python_scripts'].append({
                            'script': script_path,
                            'status': 'FAIL',
                            'message': f'Import failed: {result.stderr}'
                        })
                except Exception as e:
                    self.test_results['python_scripts'].append({
                        'script': script_path,
                        'status': 'ERROR',
                        'message': str(e)
                    })
            else:
                self.test_results['python_scripts'].append({
                    'script': script_path,
                    'status': 'SKIP',
                    'message': 'Script not found'
                })
    
    def test_shell_script_logging(self):
        """Test shell script logging functionality."""
        self.logger.info("Testing shell script logging infrastructure")
        
        test_scripts = [
            'homepage/deploy.sh',
            'scripts/deploy.sh'
        ]
        
        for script_path in test_scripts:
            if os.path.exists(script_path):
                try:
                    # Test if script has logging functions
                    with open(script_path, 'r') as f:
                        content = f.read()
                    
                    has_logging = any(func in content for func in [
                        'log_info', 'log_error', 'log_warning', 'log_debug'
                    ])
                    
                    if has_logging:
                        self.test_results['shell_scripts'].append({
                            'script': script_path,
                            'status': 'PASS',
                            'message': 'Script contains logging functions'
                        })
                    else:
                        self.test_results['shell_scripts'].append({
                            'script': script_path,
                            'status': 'FAIL',
                            'message': 'Script missing logging functions'
                        })
                except Exception as e:
                    self.test_results['shell_scripts'].append({
                        'script': script_path,
                        'status': 'ERROR',
                        'message': str(e)
                    })
            else:
                self.test_results['shell_scripts'].append({
                    'script': script_path,
                    'status': 'SKIP',
                    'message': 'Script not found'
                })
    
    def test_ansible_task_logging(self):
        """Test Ansible task logging functionality."""
        self.logger.info("Testing Ansible task logging infrastructure")
        
        test_tasks = [
            'roles/homepage/tasks/deploy.yml',
            'roles/grafana/tasks/deploy.yml',
            'roles/logging/tasks/main.yml'
        ]
        
        for task_path in test_tasks:
            if os.path.exists(task_path):
                try:
                    with open(task_path, 'r') as f:
                        content = f.read()
                    
                    has_logging = any(pattern in content for pattern in [
                        'log_error.yml', 'ansible.builtin.debug', 'msg:'
                    ])
                    
                    if has_logging:
                        self.test_results['ansible_tasks'].append({
                            'task': task_path,
                            'status': 'PASS',
                            'message': 'Task contains logging functionality'
                        })
                    else:
                        self.test_results['ansible_tasks'].append({
                            'task': task_path,
                            'status': 'FAIL',
                            'message': 'Task missing logging functionality'
                        })
                except Exception as e:
                    self.test_results['ansible_tasks'].append({
                        'task': task_path,
                        'status': 'ERROR',
                        'message': str(e)
                    })
            else:
                self.test_results['ansible_tasks'].append({
                    'task': task_path,
                    'status': 'SKIP',
                    'message': 'Task file not found'
                })
    
    def test_docker_compose_logging_labels(self):
        """Test Docker Compose files for Loki scraping labels."""
        self.logger.info("Testing Docker Compose logging labels")
        
        compose_files = [
            'templates/homepage/docker-compose.yml.j2',
            'templates/bazarr/docker-compose.yml.j2',
            'templates/immich/docker-compose.yml.j2',
            'templates/pihole/docker-compose.yml.j2',
            'templates/overseerr/docker-compose.yml.j2',
            'templates/tautulli/docker-compose.yml.j2',
            'templates/pulsarr/docker-compose.yml.j2',
            'templates/paperless_ngx/docker-compose.yml.j2'
        ]
        
        for compose_path in compose_files:
            if os.path.exists(compose_path):
                try:
                    with open(compose_path, 'r') as f:
                        content = f.read()
                    
                    has_loki_labels = all(label in content for label in [
                        'logging=promtail',
                        'promtail-job=',
                        'promtail-service='
                    ])
                    
                    if has_loki_labels:
                        self.test_results['docker_compose'].append({
                            'file': compose_path,
                            'status': 'PASS',
                            'message': 'Contains Loki scraping labels'
                        })
                    else:
                        self.test_results['docker_compose'].append({
                            'file': compose_path,
                            'status': 'FAIL',
                            'message': 'Missing Loki scraping labels'
                        })
                except Exception as e:
                    self.test_results['docker_compose'].append({
                        'file': compose_path,
                        'status': 'ERROR',
                        'message': str(e)
                    })
            else:
                self.test_results['docker_compose'].append({
                    'file': compose_path,
                    'status': 'SKIP',
                    'message': 'File not found'
                })
    
    def test_promtail_configuration(self):
        """Test Promtail configuration for comprehensive log scraping."""
        self.logger.info("Testing Promtail configuration")
        
        promtail_config = 'templates/promtail-config.yml.j2'
        
        if os.path.exists(promtail_config):
            try:
                with open(promtail_config, 'r') as f:
                    content = f.read()
                
                # Check for comprehensive log sources
                required_sources = [
                    'system_logs',
                    'docker_logs',
                    'journal_logs',
                    'web_services',
                    'security_logs',
                    'database_logs',
                    'monitoring_logs',
                    'media_logs',
                    'storage_logs',
                    'automation_logs',
                    'utility_logs',
                    'application_logs',
                    'ansible_logs',
                    'backup_logs',
                    'performance_logs',
                    'error_logs'
                ]
                
                missing_sources = []
                for source in required_sources:
                    if source not in content:
                        missing_sources.append(source)
                
                if not missing_sources:
                    self.test_results['promtail_config'].append({
                        'config': promtail_config,
                        'status': 'PASS',
                        'message': 'All required log sources configured'
                    })
                else:
                    self.test_results['promtail_config'].append({
                        'config': promtail_config,
                        'status': 'FAIL',
                        'message': f'Missing log sources: {", ".join(missing_sources)}'
                    })
            except Exception as e:
                self.test_results['promtail_config'].append({
                    'config': promtail_config,
                    'status': 'ERROR',
                    'message': str(e)
                })
        else:
            self.test_results['promtail_config'].append({
                'config': promtail_config,
                'status': 'SKIP',
                'message': 'Config file not found'
            })
    
    def test_loki_scraping(self):
        """Test Loki scraping functionality (if Loki is running)."""
        self.logger.info("Testing Loki scraping functionality")
        
        try:
            # Test if Loki is accessible
            response = requests.get('http://localhost:3100/ready', timeout=5)
            if response.status_code == 200:
                self.test_results['loki_scraping'].append({
                    'component': 'Loki',
                    'status': 'PASS',
                    'message': 'Loki is running and accessible'
                })
                
                # Test log query
                query_response = requests.get(
                    'http://localhost:3100/loki/api/v1/query_range',
                    params={
                        'query': '{job="system_logs"}',
                        'start': int((datetime.now() - timedelta(hours=1)).timestamp()),
                        'end': int(datetime.now().timestamp())
                    },
                    timeout=10
                )
                
                if query_response.status_code == 200:
                    self.test_results['loki_scraping'].append({
                        'component': 'Log Query',
                        'status': 'PASS',
                        'message': 'Log query successful'
                    })
                else:
                    self.test_results['loki_scraping'].append({
                        'component': 'Log Query',
                        'status': 'FAIL',
                        'message': f'Log query failed: {query_response.status_code}'
                    })
            else:
                self.test_results['loki_scraping'].append({
                    'component': 'Loki',
                    'status': 'FAIL',
                    'message': f'Loki not ready: {response.status_code}'
                })
        except requests.exceptions.RequestException as e:
            self.test_results['loki_scraping'].append({
                'component': 'Loki',
                'status': 'SKIP',
                'message': f'Loki not accessible: {str(e)}'
            })
    
    def generate_test_report(self):
        """Generate a comprehensive test report."""
        self.logger.info("Generating test report")
        
        report = {
            'timestamp': datetime.now().isoformat(),
            'summary': {
                'total_tests': 0,
                'passed': 0,
                'failed': 0,
                'errors': 0,
                'skipped': 0
            },
            'results': self.test_results
        }
        
        # Calculate summary statistics
        for category, tests in self.test_results.items():
            for test in tests:
                report['summary']['total_tests'] += 1
                if test['status'] == 'PASS':
                    report['summary']['passed'] += 1
                elif test['status'] == 'FAIL':
                    report['summary']['failed'] += 1
                elif test['status'] == 'ERROR':
                    report['summary']['errors'] += 1
                elif test['status'] == 'SKIP':
                    report['summary']['skipped'] += 1
        
        # Save report to file
        report_file = 'test_logging_infrastructure_report.json'
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        # Print summary
        print("\n" + "="*60)
        print("LOGGING INFRASTRUCTURE TEST REPORT")
        print("="*60)
        print(f"Timestamp: {report['timestamp']}")
        print(f"Total Tests: {report['summary']['total_tests']}")
        print(f"Passed: {report['summary']['passed']}")
        print(f"Failed: {report['summary']['failed']}")
        print(f"Errors: {report['summary']['errors']}")
        print(f"Skipped: {report['summary']['skipped']}")
        print("="*60)
        
        # Print detailed results
        for category, tests in self.test_results.items():
            print(f"\n{category.upper().replace('_', ' ')}:")
            print("-" * 40)
            for test in tests:
                status_icon = {
                    'PASS': '✅',
                    'FAIL': '❌',
                    'ERROR': '⚠️',
                    'SKIP': '⏭️'
                }.get(test['status'], '❓')
                
                print(f"{status_icon} {test.get('script', test.get('task', test.get('file', test.get('component', 'Unknown'))))}")
                print(f"   Status: {test['status']}")
                print(f"   Message: {test['message']}")
        
        print(f"\nDetailed report saved to: {report_file}")
        
        return report
    
    def run_all_tests(self):
        """Run all logging infrastructure tests."""
        self.logger.info("Starting comprehensive logging infrastructure test")
        
        self.test_python_script_logging()
        self.test_shell_script_logging()
        self.test_ansible_task_logging()
        self.test_docker_compose_logging_labels()
        self.test_promtail_configuration()
        self.test_loki_scraping()
        
        return self.generate_test_report()

def main():
    """Main function to run the logging infrastructure test."""
    tester = LoggingInfrastructureTester()
    report = tester.run_all_tests()
    
    # Exit with appropriate code based on test results
    if report['summary']['failed'] > 0 or report['summary']['errors'] > 0:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == '__main__':
    main() 