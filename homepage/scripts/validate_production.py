#!/usr/bin/env python3
"""
Production Validation Script for Homelab Homepage
================================================

This script performs comprehensive validation of the homepage implementation
to ensure it meets production readiness standards.

Features:
- Environment validation
- Configuration validation
- Security validation
- Deployment validation
- Performance validation
- Integration validation
"""

import sys
import os
import json
import yaml
import subprocess
import requests
import time
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from datetime import datetime
import logging
from logging_config import setup_logging, get_logger, log_function_call, log_execution_time, LogContext

# Setup centralized logging
LOG_DIR = os.environ.get('HOMEPAGE_LOG_DIR', './logs')
setup_logging(log_dir=LOG_DIR, log_level="INFO", json_output=True)
logger = get_logger("validate_production")

class ValidationError(Exception):
    """Custom exception for validation errors"""
    pass

class ProductionValidator:
    """Comprehensive production validation for homepage implementation"""
    
    def __init__(self, config_dir: str = "config", scripts_dir: str = "scripts"):
        self.config_dir = Path(config_dir)
        self.scripts_dir = Path(scripts_dir)
        self.results = {
            "timestamp": datetime.now().isoformat(),
            "environment": {},
            "configuration": {},
            "security": {},
            "deployment": {},
            "performance": {},
            "integration": {},
            "overall_status": "UNKNOWN"
        }
        
    def run_all_validations(self) -> Dict:
        """Run all validation checks"""
        with LogContext(logger, {"service": "validate_production", "action": "run_all_validations"}):
            logger.info("Starting comprehensive production validation...")
        
        try:
            self._validate_environment()
            self._validate_configuration()
            self._validate_security()
            self._validate_deployment()
            self._validate_performance()
            self._validate_integration()
            self._determine_overall_status()
            
        except Exception as e:
            with LogContext(logger, {"service": "validate_production", "action": "run_all_validations"}):
                logger.error(f"Validation failed: {e}", exc_info=True)
            self.results["overall_status"] = "FAILED"
            
        return self.results
    
    @log_function_call
    @log_execution_time
    def _validate_environment(self):
        """Validate Python environment and dependencies"""
        logger.info("Validating environment...")
        
        # Check Python version
        try:
            version = sys.version_info
            if version.major == 3 and version.minor >= 8:
                self.results["environment"]["python_version"] = "PASS"
                logger.info(f"✓ Python {version.major}.{version.minor}.{version.micro} OK")
            else:
                self.results["environment"]["python_version"] = "FAIL"
                logger.error(f"✗ Python {version.major}.{version.minor}.{version.micro} - requires 3.8+")
        except Exception as e:
            self.results["environment"]["python_version"] = "FAIL"
            logger.error(f"✗ Python version check failed: {e}")
        
        # Check required modules
        required_modules = ["yaml", "requests", "cryptography"]
        for module in required_modules:
            try:
                __import__(module)
                self.results["environment"][f"module_{module}"] = "PASS"
                logger.info(f"✓ {module} module OK")
            except ImportError:
                self.results["environment"][f"module_{module}"] = "FAIL"
                logger.error(f"✗ {module} module missing")
        
        # Check system dependencies
        system_deps = ["docker", "docker-compose", "curl", "jq", "yq"]
        for dep in system_deps:
            try:
                result = subprocess.run([dep, "--version"], 
                                      capture_output=True, text=True, timeout=10)
                if result.returncode == 0:
                    self.results["environment"][f"system_{dep}"] = "PASS"
                    logger.info(f"✓ {dep} OK")
                else:
                    self.results["environment"][f"system_{dep}"] = "FAIL"
                    logger.error(f"✗ {dep} not available")
            except (subprocess.TimeoutExpired, FileNotFoundError):
                self.results["environment"][f"system_{dep}"] = "FAIL"
                logger.error(f"✗ {dep} not found")
    
    @log_function_call
    @log_execution_time
    def _validate_configuration(self):
        """Validate configuration files"""
        logger.info("Validating configuration...")
        
        # Check configuration files exist
        config_files = ["services.yml", "widgets.yml", "config.yml"]
        for file in config_files:
            file_path = self.config_dir / file
            if file_path.exists():
                self.results["configuration"][f"file_{file}"] = "PASS"
                logger.info(f"✓ {file} exists")
                
                # Validate YAML syntax
                try:
                    with open(file_path, 'r') as f:
                        yaml.safe_load(f)
                    self.results["configuration"][f"yaml_{file}"] = "PASS"
                    logger.info(f"✓ {file} YAML syntax OK")
                except yaml.YAMLError as e:
                    self.results["configuration"][f"yaml_{file}"] = "FAIL"
                    logger.error(f"✗ {file} YAML syntax error: {e}")
            else:
                self.results["configuration"][f"file_{file}"] = "FAIL"
                logger.error(f"✗ {file} missing")
        
        # Check for placeholder values
        try:
            for file in config_files:
                file_path = self.config_dir / file
                if file_path.exists():
                    with open(file_path, 'r') as f:
                        content = f.read()
                        if "your_" in content and "api_key" in content:
                            self.results["configuration"]["placeholder_values"] = "WARNING"
                            logger.warning(f"⚠ Placeholder API keys found in {file}")
                        else:
                            self.results["configuration"]["placeholder_values"] = "PASS"
                            logger.info("✓ No placeholder values found")
        except Exception as e:
            self.results["configuration"]["placeholder_values"] = "FAIL"
            logger.error(f"✗ Placeholder check failed: {e}")
    
    @log_function_call
    @log_execution_time
    def _validate_security(self):
        """Validate security configuration"""
        logger.info("Validating security...")
        
        # Check file permissions
        sensitive_files = ["master.key", "api_keys.enc"]
        for file in sensitive_files:
            file_path = self.config_dir / file
            if file_path.exists():
                stat = file_path.stat()
                if stat.st_mode & 0o777 == 0o600:
                    self.results["security"][f"permissions_{file}"] = "PASS"
                    logger.info(f"✓ {file} permissions OK (600)")
                else:
                    self.results["security"][f"permissions_{file}"] = "FAIL"
                    logger.error(f"✗ {file} insecure permissions: {oct(stat.st_mode & 0o777)}")
            else:
                self.results["security"][f"permissions_{file}"] = "WARNING"
                logger.warning(f"⚠ {file} not found (may be first run)")
        
        # Test API key manager
        try:
            result = subprocess.run([sys.executable, "scripts/api_key_manager.py", "services"],
                                  capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                self.results["security"]["api_key_manager"] = "PASS"
                logger.info("✓ API key manager OK")
            else:
                self.results["security"]["api_key_manager"] = "FAIL"
                logger.error(f"✗ API key manager failed: {result.stderr}")
        except Exception as e:
            self.results["security"]["api_key_manager"] = "FAIL"
            logger.error(f"✗ API key manager test failed: {e}")
    
    @log_function_call
    @log_execution_time
    def _validate_deployment(self):
        """Validate deployment status"""
        logger.info("Validating deployment...")
        
        # Check Docker
        try:
            result = subprocess.run(["docker", "info"], 
                                  capture_output=True, text=True, timeout=10)
            if result.returncode == 0:
                self.results["deployment"]["docker"] = "PASS"
                logger.info("✓ Docker OK")
            else:
                self.results["deployment"]["docker"] = "FAIL"
                logger.error("✗ Docker not running")
        except Exception as e:
            self.results["deployment"]["docker"] = "FAIL"
            logger.error(f"✗ Docker check failed: {e}")
        
        # Check containers
        try:
            result = subprocess.run(["docker-compose", "ps"], 
                                  capture_output=True, text=True, timeout=10)
            if result.returncode == 0 and "Up" in result.stdout:
                self.results["deployment"]["containers"] = "PASS"
                logger.info("✓ Containers running")
            else:
                self.results["deployment"]["containers"] = "FAIL"
                logger.error("✗ Containers not running")
        except Exception as e:
            self.results["deployment"]["containers"] = "FAIL"
            logger.error(f"✗ Container check failed: {e}")
        
        # Check homepage accessibility
        try:
            response = requests.get("http://{{ ansible_default_ipv4.address }}:3000", timeout=10)
            if response.status_code == 200:
                self.results["deployment"]["homepage_access"] = "PASS"
                logger.info("✓ Homepage accessible")
            else:
                self.results["deployment"]["homepage_access"] = "FAIL"
                logger.error(f"✗ Homepage returned status {response.status_code}")
        except Exception as e:
            self.results["deployment"]["homepage_access"] = "FAIL"
            logger.error(f"✗ Homepage access failed: {e}")
    
    @log_function_call
    @log_execution_time
    def _validate_performance(self):
        """Validate performance metrics"""
        logger.info("Validating performance...")
        
        # Test response time
        try:
            start_time = time.time()
            response = requests.get("http://{{ ansible_default_ipv4.address }}:3000", timeout=10)
            response_time = time.time() - start_time
            
            if response_time < 2.0:
                self.results["performance"]["response_time"] = "PASS"
                logger.info(f"✓ Response time OK: {response_time:.2f}s")
            elif response_time < 5.0:
                self.results["performance"]["response_time"] = "WARNING"
                logger.warning(f"⚠ Response time slow: {response_time:.2f}s")
            else:
                self.results["performance"]["response_time"] = "FAIL"
                logger.error(f"✗ Response time too slow: {response_time:.2f}s")
        except Exception as e:
            self.results["performance"]["response_time"] = "FAIL"
            logger.error(f"✗ Response time test failed: {e}")
        
        # Check container resource usage
        try:
            result = subprocess.run(["docker", "stats", "--no-stream", "--format", "json"],
                                  capture_output=True, text=True, timeout=10)
            if result.returncode == 0:
                stats = json.loads(result.stdout)
                for container in stats:
                    if "homepage" in container.get("Name", ""):
                        mem_usage = container.get("MemUsage", "0B")
                        cpu_usage = container.get("CPUPerc", "0%")
                        
                        # Parse memory usage (e.g., "50.2MiB / 512MiB")
                        if "MiB" in mem_usage:
                            used_mem = float(mem_usage.split()[0].replace("MiB", ""))
                            if used_mem < 200:
                                self.results["performance"]["memory_usage"] = "PASS"
                                logger.info(f"✓ Memory usage OK: {mem_usage}")
                            else:
                                self.results["performance"]["memory_usage"] = "WARNING"
                                logger.warning(f"⚠ High memory usage: {mem_usage}")
                        
                        # Parse CPU usage (e.g., "2.5%")
                        if "%" in cpu_usage:
                            cpu_percent = float(cpu_usage.replace("%", ""))
                            if cpu_percent < 50:
                                self.results["performance"]["cpu_usage"] = "PASS"
                                logger.info(f"✓ CPU usage OK: {cpu_usage}")
                            else:
                                self.results["performance"]["cpu_usage"] = "WARNING"
                                logger.warning(f"⚠ High CPU usage: {cpu_usage}")
        except Exception as e:
            self.results["performance"]["resource_usage"] = "FAIL"
            logger.error(f"✗ Resource usage check failed: {e}")
    
    @log_function_call
    @log_execution_time
    def _validate_integration(self):
        """Validate service integration"""
        logger.info("Validating integration...")
        
        # Test API endpoints
        api_endpoints = [
            "http://{{ ansible_default_ipv4.address }}:3000/api/services",
            "http://{{ ansible_default_ipv4.address }}:3000/api/widgets"
        ]
        
        for endpoint in api_endpoints:
            try:
                response = requests.get(endpoint, timeout=10)
                if response.status_code == 200:
                    self.results["integration"][f"api_{endpoint.split('/')[-1]}"] = "PASS"
                    logger.info(f"✓ {endpoint} OK")
                else:
                    self.results["integration"][f"api_{endpoint.split('/')[-1]}"] = "FAIL"
                    logger.error(f"✗ {endpoint} failed: {response.status_code}")
            except Exception as e:
                self.results["integration"][f"api_{endpoint.split('/')[-1]}"] = "FAIL"
                logger.error(f"✗ {endpoint} error: {e}")
        
        # Test service connectivity
        services = ["traefik", "authentik", "portainer", "grafana"]
        for service in services:
            try:
                # Try to connect to service (this is a simplified test)
                # In a real environment, you'd have proper service discovery
                self.results["integration"][f"service_{service}"] = "WARNING"
                logger.warning(f"⚠ {service} connectivity not tested (requires network access)")
            except Exception as e:
                self.results["integration"][f"service_{service}"] = "FAIL"
                logger.error(f"✗ {service} connectivity failed: {e}")
    
    def _determine_overall_status(self):
        """Determine overall validation status"""
        logger.info("Determining overall status...")
        
        # Count results
        total_checks = 0
        passed_checks = 0
        failed_checks = 0
        warning_checks = 0
        
        for category in self.results.values():
            if isinstance(category, dict):
                for check, status in category.items():
                    total_checks += 1
                    if status == "PASS":
                        passed_checks += 1
                    elif status == "FAIL":
                        failed_checks += 1
                    elif status == "WARNING":
                        warning_checks += 1
        
        # Determine overall status
        if failed_checks == 0 and warning_checks == 0:
            self.results["overall_status"] = "PRODUCTION READY"
            logger.info("🎉 All checks passed - PRODUCTION READY!")
        elif failed_checks == 0:
            self.results["overall_status"] = "PRODUCTION READY (with warnings)"
            logger.info(f"✅ Production ready with {warning_checks} warnings")
        else:
            self.results["overall_status"] = "NEEDS FIXES"
            logger.error(f"❌ {failed_checks} checks failed - needs fixes")
        
        # Add summary
        self.results["summary"] = {
            "total_checks": total_checks,
            "passed": passed_checks,
            "failed": failed_checks,
            "warnings": warning_checks
        }
    
    def print_results(self):
        """Print validation results in a formatted way"""
        print("\n" + "="*60)
        print("PRODUCTION VALIDATION RESULTS")
        print("="*60)
        print(f"Timestamp: {self.results['timestamp']}")
        print(f"Overall Status: {self.results['overall_status']}")
        print()
        
        summary = self.results.get("summary", {})
        print(f"Summary: {summary.get('passed', 0)} passed, "
              f"{summary.get('failed', 0)} failed, "
              f"{summary.get('warnings', 0)} warnings")
        print()
        
        for category, checks in self.results.items():
            if isinstance(checks, dict) and category not in ["summary"]:
                print(f"{category.upper()}:")
                for check, status in checks.items():
                    status_icon = "✓" if status == "PASS" else "✗" if status == "FAIL" else "⚠"
                    print(f"  {status_icon} {check}: {status}")
                print()
        
        print("="*60)
    
    def save_results(self, filename: str = "validation_results.json"):
        """Save validation results to file"""
        try:
            with open(filename, 'w') as f:
                json.dump(self.results, f, indent=2)
            logger.info(f"Results saved to {filename}")
        except Exception as e:
            logger.error(f"Failed to save results: {e}")

def main():
    """Main function"""
    validator = ProductionValidator()
    results = validator.run_all_validations()
    validator.print_results()
    validator.save_results()
    
    # Exit with appropriate code
    if results["overall_status"] == "PRODUCTION READY":
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    main() 