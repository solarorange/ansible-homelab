#!/usr/bin/env python3
"""
Logging Configuration for Homepage Dashboard

This module provides comprehensive logging configuration for production use
including log rotation, formatting, and error handling.
"""

import os
import sys
import logging
import logging.handlers
from pathlib import Path
from typing import Optional
import json
from datetime import datetime

class StructuredFormatter(logging.Formatter):
    """Structured JSON formatter for production logging"""
    
    def format(self, record):
        log_entry = {
            'timestamp': datetime.utcnow().isoformat() + 'Z',
            'level': record.levelname,
            'logger': record.name,
            'message': record.getMessage(),
            'module': record.module,
            'function': record.funcName,
            'line': record.lineno
        }
        
        # Add exception info if present
        if record.exc_info:
            log_entry['exception'] = self.formatException(record.exc_info)
        
        # Add extra fields if present
        if hasattr(record, 'extra_fields'):
            log_entry.update(record.extra_fields)
        
        return json.dumps(log_entry)

class ColoredFormatter(logging.Formatter):
    """Colored formatter for console output"""
    
    COLORS = {
        'DEBUG': '\033[36m',    # Cyan
        'INFO': '\033[32m',     # Green
        'WARNING': '\033[33m',  # Yellow
        'ERROR': '\033[31m',    # Red
        'CRITICAL': '\033[35m', # Magenta
        'RESET': '\033[0m'      # Reset
    }
    
    def format(self, record):
        # Add color to level name
        levelname = record.levelname
        if levelname in self.COLORS:
            record.levelname = f"{self.COLORS[levelname]}{levelname}{self.COLORS['RESET']}"
        
        return super().format(record)

def setup_logging(
    log_dir: str = "/var/log/homepage",
    log_level: str = "INFO",
    max_bytes: int = 10 * 1024 * 1024,  # 10MB
    backup_count: int = 5,
    console_output: bool = True,
    json_output: bool = False
) -> None:
    """
    Setup comprehensive logging configuration
    
    Args:
        log_dir: Directory for log files
        log_level: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
        max_bytes: Maximum size of log file before rotation
        backup_count: Number of backup log files to keep
        console_output: Enable console output
        json_output: Use JSON formatting for file logs
    """
    
    # Create log directory if it doesn't exist
    log_path = Path(log_dir)
    log_path.mkdir(parents=True, exist_ok=True)
    
    # Set log level
    numeric_level = getattr(logging, log_level.upper(), logging.INFO)
    
    # Configure root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(numeric_level)
    
    # Clear existing handlers
    root_logger.handlers.clear()
    
    # Create formatters
    if json_output:
        file_formatter = StructuredFormatter()
        console_formatter = ColoredFormatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    else:
        file_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(module)s:%(funcName)s:%(lineno)d - %(message)s'
        )
        console_formatter = ColoredFormatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    
    # File handler with rotation
    file_handler = logging.handlers.RotatingFileHandler(
        log_path / "homepage.log",
        maxBytes=max_bytes,
        backupCount=backup_count,
        encoding='utf-8'
    )
    file_handler.setLevel(numeric_level)
    file_handler.setFormatter(file_formatter)
    root_logger.addHandler(file_handler)
    
    # Error file handler
    error_handler = logging.handlers.RotatingFileHandler(
        log_path / "homepage_error.log",
        maxBytes=max_bytes,
        backupCount=backup_count,
        encoding='utf-8'
    )
    error_handler.setLevel(logging.ERROR)
    error_handler.setFormatter(file_formatter)
    root_logger.addHandler(error_handler)
    
    # Console handler
    if console_output:
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setLevel(numeric_level)
        console_handler.setFormatter(console_formatter)
        root_logger.addHandler(console_handler)
    
    # Suppress noisy loggers
    logging.getLogger('urllib3').setLevel(logging.WARNING)
    logging.getLogger('docker').setLevel(logging.WARNING)
    logging.getLogger('requests').setLevel(logging.WARNING)

def get_logger(name: str) -> logging.Logger:
    """Get a logger with the specified name"""
    return logging.getLogger(name)

def log_function_call(func):
    """Decorator to log function calls"""
    def wrapper(*args, **kwargs):
        logger = get_logger(func.__module__)
        logger.debug(f"Calling {func.__name__} with args={args}, kwargs={kwargs}")
        try:
            result = func(*args, **kwargs)
            logger.debug(f"{func.__name__} returned {result}")
            return result
        except Exception as e:
            logger.error(f"{func.__name__} failed with error: {e}", exc_info=True)
            raise
    return wrapper

def log_execution_time(func):
    """Decorator to log function execution time"""
    def wrapper(*args, **kwargs):
        logger = get_logger(func.__module__)
        start_time = datetime.now()
        try:
            result = func(*args, **kwargs)
            execution_time = (datetime.now() - start_time).total_seconds()
            logger.info(f"{func.__name__} executed in {execution_time:.3f} seconds")
            return result
        except Exception as e:
            execution_time = (datetime.now() - start_time).total_seconds()
            logger.error(f"{func.__name__} failed after {execution_time:.3f} seconds: {e}", exc_info=True)
            raise
    return wrapper

class LogContext:
    """Context manager for logging with additional context"""
    
    def __init__(self, logger: logging.Logger, context: dict):
        self.logger = logger
        self.context = context
        self.old_extra = {}
    
    def __enter__(self):
        # Store old extra fields
        self.old_extra = getattr(self.logger, 'extra_fields', {})
        # Add new context
        self.logger.extra_fields = {**self.old_extra, **self.context}
        return self.logger
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        # Restore old extra fields
        self.logger.extra_fields = self.old_extra

def log_with_context(logger: logging.Logger, context: dict):
    """Create a log context manager"""
    return LogContext(logger, context)

# Example usage
if __name__ == "__main__":
    # Setup logging
    setup_logging(
        log_dir="/tmp/homepage_logs",
        log_level="DEBUG",
        console_output=True,
        json_output=True
    )
    
    logger = get_logger(__name__)
    
    # Test logging
    logger.info("Logging system initialized")
    logger.warning("This is a warning message")
    logger.error("This is an error message")
    
    # Test context logging
    with log_with_context(logger, {'user_id': '123', 'action': 'test'}):
        logger.info("This log entry has additional context")
    
    # Test function decorators
    @log_function_call
    @log_execution_time
    def test_function(x, y):
        import time
        time.sleep(0.1)
        return x + y
    
    result = test_function(1, 2)
    print(f"Function result: {result}") 