#!/usr/bin/env python3
"""
Health Monitoring for Homepage Dashboard

This script monitors the health of all services in the homelab and provides
real-time status information for the homepage dashboard.
"""

import sys
import os
import json
import yaml
import requests
import asyncio
import aiohttp
import time
from pathlib import Path
from typing import Dict, List, Optional, Any
import logging
from datetime import datetime, timedelta
from dataclasses import dataclass, asdict
from enum import Enum
from logging_config import setup_logging, get_logger, log_function_call, log_execution_time, LogContext

# Setup centralized logging
LOG_DIR = os.environ.get('HOMEPAGE_LOG_DIR', './logs')
setup_logging(log_dir=LOG_DIR, log_level="INFO", json_output=True)
logger = get_logger("health_monitor")

class ServiceStatus(Enum):
    """Service status enumeration"""
    ONLINE = "online"
    OFFLINE = "offline"
    WARNING = "warning"
    UNKNOWN = "unknown"

@dataclass
class ServiceHealth:
    """Service health data class"""
    name: str
    status: ServiceStatus
    response_time: float
    last_check: datetime
    error_message: Optional[str] = None
    uptime: Optional[float] = None
    version: Optional[str] = None
    metrics: Optional[Dict[str, Any]] = None

class HealthMonitor:
    """Main health monitoring class"""
    
    def __init__(self, config_dir: str = "/app/config"):
        self.config_dir = Path(config_dir)
        self.services_file = self.config_dir / "services.yml"
        self.health_file = self.config_dir / "health_status.json"
        self.services = {}
        self.health_data = {}
        self.session = None
        
        # Load service configurations
        self.load_services()
    
    def load_services(self) -> None:
        """Load service configurations from services.yml"""
        try:
            if self.services_file.exists():
                with open(self.services_file, 'r') as f:
                    config = yaml.safe_load(f)
                
                for group in config:
                    group_name = group.get('group', 'Unknown')
                    items = group.get('items', [])
                    
                    for item in items:
                        for service_name, service_config in item.items():
                            self.services[service_name.lower()] = {
                                'name': service_name,
                                'group': group_name,
                                'className': group.get('className', 'default-stack'),
                                'config': service_config
                            }
                
                with LogContext(logger, {"service": "health_monitor", "action": "load_services"}):
                    logger.info(f"Loaded {len(self.services)} services")
            else:
                with LogContext(logger, {"service": "health_monitor", "action": "load_services"}):
                    logger.warning(f"Services file not found: {self.services_file}")
        
        except Exception as e:
            with LogContext(logger, {"service": "health_monitor", "action": "load_services"}):
                logger.error(f"Error loading services: {e}", exc_info=True)
    
    @log_function_call
    @log_execution_time
    async def check_service_health(self, service_name: str, service_config: Dict[str, Any]) -> ServiceHealth:
        """Check health of a single service"""
        start_time = time.time()
        
        try:
            # Get health check URL
            health_url = service_config.get('health', {}).get('url')
            if not health_url:
                return ServiceHealth(
                    name=service_name,
                    status=ServiceStatus.UNKNOWN,
                    response_time=0.0,
                    last_check=datetime.now(),
                    error_message="No health URL configured"
                )
            
            # Perform health check
            async with self.session.get(health_url, timeout=10) as response:
                response_time = time.time() - start_time
                
                if response.status == 200:
                    # Try to extract additional information
                    try:
                        data = await response.json()
                        uptime = data.get('uptime')
                        version = data.get('version')
                        metrics = data.get('metrics', {})
                    except:
                        uptime = None
                        version = None
                        metrics = {}
                    
                    return ServiceHealth(
                        name=service_name,
                        status=ServiceStatus.ONLINE,
                        response_time=response_time,
                        last_check=datetime.now(),
                        uptime=uptime,
                        version=version,
                        metrics=metrics
                    )
                elif response.status == 503:
                    return ServiceHealth(
                        name=service_name,
                        status=ServiceStatus.WARNING,
                        response_time=response_time,
                        last_check=datetime.now(),
                        error_message=f"Service unavailable (HTTP {response.status})"
                    )
                else:
                    return ServiceHealth(
                        name=service_name,
                        status=ServiceStatus.OFFLINE,
                        response_time=response_time,
                        last_check=datetime.now(),
                        error_message=f"HTTP {response.status}"
                    )
        
        except asyncio.TimeoutError:
            return ServiceHealth(
                name=service_name,
                status=ServiceStatus.OFFLINE,
                response_time=time.time() - start_time,
                last_check=datetime.now(),
                error_message="Timeout"
            )
        except Exception as e:
            return ServiceHealth(
                name=service_name,
                status=ServiceStatus.UNKNOWN,
                response_time=time.time() - start_time,
                last_check=datetime.now(),
                error_message=str(e)
            )
    
    async def check_all_services(self) -> Dict[str, ServiceHealth]:
        """Check health of all services concurrently"""
        if not self.session:
            self.session = aiohttp.ClientSession()
        
        tasks = []
        for service_name, service_data in self.services.items():
            service_config = service_data['config']
            task = self.check_service_health(service_name, service_config)
            tasks.append(task)
        
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        health_data = {}
        for i, result in enumerate(results):
            if isinstance(result, Exception):
                service_name = list(self.services.keys())[i]
                health_data[service_name] = ServiceHealth(
                    name=service_name,
                    status=ServiceStatus.UNKNOWN,
                    response_time=0.0,
                    last_check=datetime.now(),
                    error_message=str(result)
                )
            else:
                health_data[result.name] = result
        
        return health_data
    
    def save_health_data(self, health_data: Dict[str, ServiceHealth]) -> None:
        """Save health data to JSON file"""
        try:
            # Convert to serializable format
            serializable_data = {}
            for service_name, health in health_data.items():
                serializable_data[service_name] = {
                    'name': health.name,
                    'status': health.status.value,
                    'response_time': health.response_time,
                    'last_check': health.last_check.isoformat(),
                    'error_message': health.error_message,
                    'uptime': health.uptime,
                    'version': health.version,
                    'metrics': health.metrics
                }
            
            with open(self.health_file, 'w') as f:
                json.dump(serializable_data, f, indent=2)
            
            with LogContext(logger, {"service": "health_monitor", "action": "save_health_data"}):
                logger.info(f"Saved health data for {len(health_data)} services")
        
        except Exception as e:
            with LogContext(logger, {"service": "health_monitor", "action": "save_health_data"}):
                logger.error(f"Error saving health data: {e}", exc_info=True)
    
    def generate_health_summary(self, health_data: Dict[str, ServiceHealth]) -> Dict[str, Any]:
        """Generate a summary of service health"""
        total_services = len(health_data)
        online_services = sum(1 for h in health_data.values() if h.status == ServiceStatus.ONLINE)
        offline_services = sum(1 for h in health_data.values() if h.status == ServiceStatus.OFFLINE)
        warning_services = sum(1 for h in health_data.values() if h.status == ServiceStatus.WARNING)
        unknown_services = sum(1 for h in health_data.values() if h.status == ServiceStatus.UNKNOWN)
        
        # Calculate average response time
        response_times = [h.response_time for h in health_data.values() if h.response_time > 0]
        avg_response_time = sum(response_times) / len(response_times) if response_times else 0
        
        # Group by status
        by_status = {
            'online': [h.name for h in health_data.values() if h.status == ServiceStatus.ONLINE],
            'offline': [h.name for h in health_data.values() if h.status == ServiceStatus.OFFLINE],
            'warning': [h.name for h in health_data.values() if h.status == ServiceStatus.WARNING],
            'unknown': [h.name for h in health_data.values() if h.status == ServiceStatus.UNKNOWN]
        }
        
        # Group by service group
        by_group = {}
        for service_name, health in health_data.items():
            if service_name in self.services:
                group = self.services[service_name]['group']
                if group not in by_group:
                    by_group[group] = []
                by_group[group].append({
                    'name': health.name,
                    'status': health.status.value,
                    'response_time': health.response_time
                })
        
        return {
            'summary': {
                'total_services': total_services,
                'online_services': online_services,
                'offline_services': offline_services,
                'warning_services': warning_services,
                'unknown_services': unknown_services,
                'uptime_percentage': (online_services / total_services * 100) if total_services > 0 else 0,
                'average_response_time': avg_response_time,
                'last_updated': datetime.now().isoformat()
            },
            'by_status': by_status,
            'by_group': by_group,
            'services': {
                service_name: {
                    'name': health.name,
                    'status': health.status.value,
                    'response_time': health.response_time,
                    'last_check': health.last_check.isoformat(),
                    'error_message': health.error_message,
                    'uptime': health.uptime,
                    'version': health.version,
                    'group': self.services.get(service_name, {}).get('group', 'Unknown'),
                    'className': self.services.get(service_name, {}).get('className', 'default-stack')
                }
                for service_name, health in health_data.items()
            }
        }
    
    def save_health_summary(self, summary: Dict[str, Any]) -> None:
        """Save health summary to JSON file"""
        try:
            summary_file = self.config_dir / "health_summary.json"
            with open(summary_file, 'w') as f:
                json.dump(summary, f, indent=2)
            
            with LogContext(logger, {"service": "health_monitor", "action": "save_health_summary"}):
                logger.info("Saved health summary")
        
        except Exception as e:
            with LogContext(logger, {"service": "health_monitor", "action": "save_health_summary"}):
                logger.error(f"Error saving health summary: {e}", exc_info=True)
    
    @log_function_call
    @log_execution_time
    async def run_monitoring_cycle(self) -> None:
        """Run a single monitoring cycle"""
        with LogContext(logger, {"service": "health_monitor", "action": "run_monitoring_cycle"}):
            logger.info("Starting health monitoring cycle...")
        
        try:
            # Check all services
            health_data = await self.check_all_services()
            
            # Save detailed health data
            self.save_health_data(health_data)
            
            # Generate and save summary
            summary = self.generate_health_summary(health_data)
            self.save_health_summary(summary)
            
            # Log summary
            summary_data = summary['summary']
            with LogContext(logger, {"service": "health_monitor", "action": "run_monitoring_cycle"}):
                logger.info(
                    f"Health check completed: {summary_data['online_services']}/{summary_data['total_services']} "
                    f"services online ({summary_data['uptime_percentage']:.1f}% uptime)"
                )
            
            # Log offline services
            offline_services = summary['by_status']['offline']
            if offline_services:
                with LogContext(logger, {"service": "health_monitor", "action": "run_monitoring_cycle"}):
                    logger.warning(f"Offline services: {', '.join(offline_services)}")
            
            # Log warning services
            warning_services = summary['by_status']['warning']
            if warning_services:
                with LogContext(logger, {"service": "health_monitor", "action": "run_monitoring_cycle"}):
                    logger.warning(f"Warning services: {', '.join(warning_services)}")
        
        except Exception as e:
            with LogContext(logger, {"service": "health_monitor", "action": "run_monitoring_cycle"}):
                logger.error(f"Error in monitoring cycle: {e}", exc_info=True)
    
    async def run_continuous_monitoring(self, interval: int = 60) -> None:
        """Run continuous monitoring with specified interval"""
        with LogContext(logger, {"service": "health_monitor", "action": "run_continuous_monitoring"}):
            logger.info(f"Starting continuous monitoring with {interval}s interval...")
        
        try:
            while True:
                try:
                    await self.run_monitoring_cycle()
                    await asyncio.sleep(interval)
                except KeyboardInterrupt:
                    with LogContext(logger, {"service": "health_monitor", "action": "run_continuous_monitoring"}):
                        logger.info("Monitoring stopped by user")
                    break
                except Exception as e:
                    with LogContext(logger, {"service": "health_monitor", "action": "run_continuous_monitoring"}):
                        logger.error(f"Error in monitoring cycle: {e}", exc_info=True)
                    await asyncio.sleep(interval)
        finally:
            if self.session:
                await self.session.close()
                with LogContext(logger, {"service": "health_monitor", "action": "run_continuous_monitoring"}):
                    logger.info("Health monitoring session closed")

def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Health monitoring for homepage dashboard')
    parser.add_argument('--interval', type=int, default=60, help='Monitoring interval in seconds')
    parser.add_argument('--once', action='store_true', help='Run once and exit')
    parser.add_argument('--config-dir', default='/app/config', help='Configuration directory')
    
    args = parser.parse_args()
    
    monitor = HealthMonitor(args.config_dir)
    
    try:
        if args.once:
            asyncio.run(monitor.run_monitoring_cycle())
        else:
            asyncio.run(monitor.run_continuous_monitoring(args.interval))
    except Exception as e:
        logger.error(f"Critical error in health monitoring: {e}", exc_info=True)
        sys.exit(1)

if __name__ == "__main__":
    main() 