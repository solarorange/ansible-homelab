#!/usr/bin/env python3
"""
Port Conflict Detector for Homelab
==================================

This script detects and prevents port conflicts in the homelab infrastructure.
It validates port assignments against a centralized port management system
and provides recommendations for resolving conflicts.

Usage:
    python3 port_conflict_detector.py [--validate] [--fix] [--report]
"""

import yaml
import argparse
import sys
import os
from pathlib import Path
from typing import Dict, List, Tuple, Set
import subprocess
import json

class PortConflictDetector:
    def __init__(self, homelab_root: str = "."):
        self.homelab_root = Path(homelab_root)
        self.port_management_file = self.homelab_root / "group_vars" / "all" / "port_management.yml"
        self.conflicts = []
        self.warnings = []
        self.recommendations = []
        
    def load_port_management(self) -> Dict:
        """Load the centralized port management configuration."""
        try:
            with open(self.port_management_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            print(f"❌ Port management file not found: {self.port_management_file}")
            sys.exit(1)
        except yaml.YAMLError as e:
            print(f"❌ Error parsing port management file: {e}")
            sys.exit(1)
    
    def scan_service_configs(self) -> Dict[str, int]:
        """Scan all service configurations for port assignments."""
        service_ports = {}
        
        # Scan roles directory for port configurations
        roles_dir = self.homelab_root / "roles"
        if roles_dir.exists():
            for role_dir in roles_dir.iterdir():
                if role_dir.is_dir():
                    defaults_file = role_dir / "defaults" / "main.yml"
                    if defaults_file.exists():
                        try:
                            with open(defaults_file, 'r') as f:
                                config = yaml.safe_load(f)
                                if config:
                                    self._extract_ports_from_config(config, role_dir.name, service_ports)
                        except yaml.YAMLError:
                            continue
        
        # Scan group_vars for port configurations
        group_vars_dir = self.homelab_root / "group_vars" / "all"
        if group_vars_dir.exists():
            for yml_file in group_vars_dir.glob("*.yml"):
                try:
                    with open(yml_file, 'r') as f:
                        config = yaml.safe_load(f)
                        if config:
                            self._extract_ports_from_config(config, yml_file.stem, service_ports)
                except yaml.YAMLError:
                    continue
        
        return service_ports
    
    def _extract_ports_from_config(self, config: Dict, source: str, service_ports: Dict[str, int]):
        """Extract port assignments from a configuration dictionary."""
        def extract_ports(obj, prefix=""):
            if isinstance(obj, dict):
                for key, value in obj.items():
                    current_prefix = f"{prefix}.{key}" if prefix else key
                    if isinstance(value, (int, str)) and any(port_key in key.lower() for port_key in ['port', 'ports']):
                        try:
                            port = int(value)
                            if 1000 <= port <= 65535:  # Valid port range
                                service_ports[f"{source}.{current_prefix}"] = port
                        except (ValueError, TypeError):
                            pass
                    elif isinstance(value, (dict, list)):
                        extract_ports(value, current_prefix)
            elif isinstance(obj, list):
                for i, item in enumerate(obj):
                    extract_ports(item, f"{prefix}[{i}]")
        
        extract_ports(config)
    
    def detect_conflicts(self, service_ports: Dict[str, int]) -> List[Tuple[str, str, int]]:
        """Detect port conflicts between services."""
        port_usage = {}
        conflicts = []
        
        for service, port in service_ports.items():
            if port in port_usage:
                conflicts.append((service, port_usage[port], port))
            else:
                port_usage[port] = service
        
        return conflicts
    
    def validate_against_management(self, service_ports: Dict[str, int], port_mgmt: Dict) -> List[str]:
        """Validate port assignments against the centralized management system."""
        warnings = []
        
        # Check against reserved ports
        reserved_ports = set(port_mgmt.get('port_validation', {}).get('reserved_ports', []))
        
        for service, port in service_ports.items():
            if port in reserved_ports:
                warnings.append(f"⚠️  {service} uses reserved port {port}")
        
        # Check against documented assignments
        documented_services = port_mgmt.get('service_port_documentation', {})
        for service_name, doc in documented_services.items():
            expected_port = doc.get('port')
            if expected_port:
                # Find matching service in scanned ports
                matching_services = [s for s in service_ports.keys() if service_name in s.lower()]
                for service in matching_services:
                    if service_ports[service] != expected_port:
                        warnings.append(f"⚠️  {service} uses port {service_ports[service]}, expected {expected_port}")
        
        return warnings
    
    def generate_recommendations(self, conflicts: List[Tuple[str, str, int]], port_mgmt: Dict) -> List[str]:
        """Generate recommendations for resolving conflicts."""
        recommendations = []
        
        # Get available ports from management system
        used_ports = set()
        for conflict in conflicts:
            used_ports.add(conflict[2])
        
        # Find available ports in appropriate ranges
        available_ports = []
        for port_range in port_mgmt.get('port_validation', {}).get('valid_ranges', []):
            start = port_range.get('start', 1000)
            end = port_range.get('end', 65535)
            for port in range(start, end + 1):
                if port not in used_ports and port not in port_mgmt.get('port_validation', {}).get('reserved_ports', []):
                    available_ports.append(port)
                    if len(available_ports) >= 10:  # Limit recommendations
                        break
            if len(available_ports) >= 10:
                break
        
        for service1, service2, port in conflicts:
            if available_ports:
                new_port = available_ports.pop(0)
                recommendations.append(f"🔧 Resolve conflict: Move {service1} to port {new_port} (currently conflicts with {service2} on port {port})")
        
        return recommendations
    
    def check_running_services(self) -> Dict[str, int]:
        """Check currently running services and their ports."""
        running_services = {}
        
        try:
            # Use netstat to check listening ports
            result = subprocess.run(['netstat', '-tlnp'], capture_output=True, text=True)
            if result.returncode == 0:
                for line in result.stdout.split('\n'):
                    if 'LISTEN' in line:
                        parts = line.split()
                        if len(parts) >= 4:
                            address = parts[3]
                            if ':' in address:
                                port = int(address.split(':')[-1])
                                if 1000 <= port <= 65535:
                                    running_services[f"netstat-{port}"] = port
        except (subprocess.SubprocessError, FileNotFoundError):
            pass
        
        try:
            # Use ss command as alternative
            result = subprocess.run(['ss', '-tlnp'], capture_output=True, text=True)
            if result.returncode == 0:
                for line in result.stdout.split('\n'):
                    if 'LISTEN' in line:
                        parts = line.split()
                        if len(parts) >= 4:
                            address = parts[3]
                            if ':' in address:
                                port = int(address.split(':')[-1])
                                if 1000 <= port <= 65535:
                                    running_services[f"ss-{port}"] = port
        except (subprocess.SubprocessError, FileNotFoundError):
            pass
        
        return running_services
    
    def generate_report(self, service_ports: Dict[str, int], conflicts: List[Tuple[str, str, int]], 
                       warnings: List[str], recommendations: List[str], port_mgmt: Dict) -> str:
        """Generate a comprehensive port conflict report."""
        report = []
        report.append("=" * 80)
        report.append("HOMELAB PORT CONFLICT DETECTION REPORT")
        report.append("=" * 80)
        report.append("")
        
        # Summary
        report.append(f"📊 SUMMARY:")
        report.append(f"   • Services scanned: {len(service_ports)}")
        report.append(f"   • Port conflicts detected: {len(conflicts)}")
        report.append(f"   • Warnings: {len(warnings)}")
        report.append(f"   • Recommendations: {len(recommendations)}")
        report.append("")
        
        # Service Port Assignments
        report.append("🔍 SERVICE PORT ASSIGNMENTS:")
        for service, port in sorted(service_ports.items(), key=lambda x: x[1]):
            report.append(f"   • {service}: {port}")
        report.append("")
        
        # Conflicts
        if conflicts:
            report.append("❌ PORT CONFLICTS DETECTED:")
            for service1, service2, port in conflicts:
                report.append(f"   • {service1} ↔ {service2} (port {port})")
            report.append("")
        
        # Warnings
        if warnings:
            report.append("⚠️  WARNINGS:")
            for warning in warnings:
                report.append(f"   • {warning}")
            report.append("")
        
        # Recommendations
        if recommendations:
            report.append("🔧 RECOMMENDATIONS:")
            for rec in recommendations:
                report.append(f"   • {rec}")
            report.append("")
        
        # Port Management Status
        report.append("📋 PORT MANAGEMENT STATUS:")
        documented_services = port_mgmt.get('service_port_documentation', {})
        for service_name, doc in documented_services.items():
            port = doc.get('port')
            description = doc.get('description', '')
            report.append(f"   • {service_name}: {port} - {description}")
        report.append("")
        
        return "\n".join(report)
    
    def fix_conflicts(self, conflicts: List[Tuple[str, str, int]], port_mgmt: Dict) -> bool:
        """Automatically fix port conflicts by updating configuration files."""
        print("🔧 Attempting to fix port conflicts...")
        
        # This would require more sophisticated file parsing and editing
        # For now, just provide manual instructions
        print("⚠️  Automatic conflict resolution not implemented yet.")
        print("   Please manually update the following files:")
        
        for service1, service2, port in conflicts:
            print(f"   • Resolve conflict between {service1} and {service2} on port {port}")
        
        return False
    
    def run(self, validate: bool = False, fix: bool = False, report: bool = False):
        """Run the port conflict detection."""
        print("🔍 Scanning homelab for port conflicts...")
        
        # Load port management configuration
        port_mgmt = self.load_port_management()
        
        # Scan service configurations
        service_ports = self.scan_service_configs()
        
        # Detect conflicts
        conflicts = self.detect_conflicts(service_ports)
        
        # Validate against management system
        warnings = self.validate_against_management(service_ports, port_mgmt)
        
        # Generate recommendations
        recommendations = self.generate_recommendations(conflicts, port_mgmt)
        
        # Check running services
        running_services = self.check_running_services()
        
        # Generate report
        if report:
            report_content = self.generate_report(service_ports, conflicts, warnings, recommendations, port_mgmt)
            print(report_content)
            
            # Save report to file
            report_file = self.homelab_root / "logs" / "port_conflict_report.txt"
            report_file.parent.mkdir(exist_ok=True)
            with open(report_file, 'w') as f:
                f.write(report_content)
            print(f"📄 Report saved to: {report_file}")
        
        # Display results
        if conflicts:
            print(f"❌ Found {len(conflicts)} port conflicts:")
            for service1, service2, port in conflicts:
                print(f"   • {service1} ↔ {service2} (port {port})")
        else:
            print("✅ No port conflicts detected!")
        
        if warnings:
            print(f"⚠️  {len(warnings)} warnings:")
            for warning in warnings:
                print(f"   • {warning}")
        
        if recommendations:
            print(f"🔧 {len(recommendations)} recommendations:")
            for rec in recommendations:
                print(f"   • {rec}")
        
        # Attempt to fix conflicts
        if fix and conflicts:
            self.fix_conflicts(conflicts, port_mgmt)
        
        return len(conflicts) == 0

def main():
    parser = argparse.ArgumentParser(description="Detect and resolve port conflicts in homelab")
    parser.add_argument("--validate", action="store_true", help="Validate against port management system")
    parser.add_argument("--fix", action="store_true", help="Attempt to fix conflicts automatically")
    parser.add_argument("--report", action="store_true", help="Generate detailed report")
    parser.add_argument("--homelab-root", default=".", help="Path to homelab root directory")
    
    args = parser.parse_args()
    
    detector = PortConflictDetector(args.homelab_root)
    success = detector.run(validate=args.validate, fix=args.fix, report=args.report)
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main() 