#!/bin/bash

# =============================================================================
# HOMEPAGE DASHBOARD DEPLOYMENT SCRIPT
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
BACKUP_DIR="$SCRIPT_DIR/backups"
LOG_DIR="$SCRIPT_DIR/logs"

# Create necessary directories
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# Source standardized logging utility
if [[ -f "$SCRIPT_DIR/../scripts/logging_utils.sh" ]]; then
    source "$SCRIPT_DIR/../scripts/logging_utils.sh"
else
    # Fallback logging functions if utility not available
    log_info() {
        echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] [INFO]${NC} $1" | tee -a "$LOG_DIR/deploy.log"
    }
    
    log_error() {
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR]${NC} $1" | tee -a "$LOG_DIR/deploy.log"
        exit 1
    }
    
    log_warning() {
        echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] [WARNING]${NC} $1" | tee -a "$LOG_DIR/deploy.log"
    }
    
    log_debug() {
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] [DEBUG]${NC} $1" | tee -a "$LOG_DIR/deploy.log"
    }
fi

# Function to check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed. Please install Docker Compose first."
    fi
    
    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running. Please start Docker first."
    fi
    
    # Check if config files exist
    if [[ ! -f "$CONFIG_DIR/config.yml" ]]; then
        log_error "Configuration file not found: $CONFIG_DIR/config.yml"
    fi
    
    if [[ ! -f "$CONFIG_DIR/services.yml" ]]; then
        log_error "Services configuration not found: $CONFIG_DIR/services.yml"
    fi
    
    log_info "Prerequisites check passed!"
}

# Function to backup existing configuration
backup_config() {
    if [[ -d "$CONFIG_DIR" ]]; then
        local backup_file
        backup_file="$BACKUP_DIR/homepage-config-$(date +%Y%m%d-%H%M%S).tar.gz"
        log_info "Creating backup of existing configuration..."
        tar -czf "$backup_file" -C "$SCRIPT_DIR" config/
        log_info "Backup created: $backup_file"
    fi
}

# Function to validate configuration
validate_config() {
    log_info "Validating configuration files..."
    
    # Check YAML syntax
    if command -v python3 &> /dev/null; then
        python3 -c "import yaml; yaml.safe_load(open('$CONFIG_DIR/config.yml'))" || log_error "Invalid YAML syntax in config.yml"
        python3 -c "import yaml; yaml.safe_load(open('$CONFIG_DIR/services.yml'))" || log_error "Invalid YAML syntax in services.yml"
        python3 -c "import yaml; yaml.safe_load(open('$CONFIG_DIR/bookmarks.yml'))" || log_error "Invalid YAML syntax in bookmarks.yml"
    elif command -v python &> /dev/null; then
        python -c "import yaml; yaml.safe_load(open('$CONFIG_DIR/config.yml'))" || log_error "Invalid YAML syntax in config.yml"
        python -c "import yaml; yaml.safe_load(open('$CONFIG_DIR/services.yml'))" || log_error "Invalid YAML syntax in services.yml"
        python -c "import yaml; yaml.safe_load(open('$CONFIG_DIR/bookmarks.yml'))" || log_error "Invalid YAML syntax in bookmarks.yml"
    else
        log_warning "Python not found, skipping YAML validation"
    fi
    
    log_info "Configuration validation passed!"
}

# Function to setup environment
setup_environment() {
    log_info "Setting up environment..."
    
    # Create .env file if it doesn't exist
    if [[ ! -f "$SCRIPT_DIR/.env" ]]; then
        cat > "$SCRIPT_DIR/.env" << EOF
# =============================================================================
# HOMEPAGE ENVIRONMENT CONFIGURATION
# =============================================================================

# Domain configuration
DOMAIN=yourdomain.com

# Weather API configuration
OPENWEATHER_API_KEY=your_openweathermap_api_key
WEATHER_LAT=40.7128
WEATHER_LON=-74.0060
WEATHER_UNITS=metric

# System configuration
TZ=America/New_York
PUID=1000
PGID=1000

# Security configuration
ADMIN_USERNAME=admin
ADMIN_PASSWORD={{ vault_homepage_admin_password }}

# Backup configuration
BACKUP_ENABLED=true
BACKUP_RETENTION_DAYS=30

# Monitoring configuration
HEALTH_CHECK_INTERVAL=30
LOG_LEVEL=info
EOF
        log_warning "Created .env file. Please edit it with your actual values before deployment."
    else
        log_info ".env file already exists"
    fi
}

# Function to deploy Homepage
deploy_homepage() {
    log_info "Deploying Homepage dashboard..."
    
    # Pull latest images
    log_info "Pulling latest Docker images..."
    docker-compose pull
    
    # Start services
    log_info "Starting Homepage services..."
    docker-compose up -d
    
    # Wait for services to be ready
    log_info "Waiting for services to be ready..."
    sleep 10
    
    # Check service status
    if docker-compose ps | grep -q "Up"; then
        log_info "Homepage deployed successfully!"
    else
        log_error "Failed to deploy Homepage. Check logs with: docker-compose logs"
    fi
}

# Function to check service health
check_health() {
    log_info "Checking service health..."
    
    # Wait a bit for services to fully start
    sleep 5
    
    # Check if Homepage is responding
if curl -f -s "http://{{ ansible_default_ipv4.address }}:3000/health" &> /dev/null; then
        log_info "Homepage health check passed!"
    else
        log_warning "Homepage health check failed. Service may still be starting..."
    fi
    
    # Check container status
    log_info "Container status:"
    docker-compose ps
}

# Function to show deployment info
show_info() {
    log_info "Deployment completed successfully!"
    echo
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  HOMEPAGE DASHBOARD DEPLOYMENT INFO${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo
    echo -e "${BLUE}Dashboard URL:${NC} http://{{ ansible_default_ipv4.address }}:3000"
    echo -e "${BLUE}Configuration:${NC} $CONFIG_DIR"
    echo -e "${BLUE}Logs:${NC} $LOG_DIR"
    echo -e "${BLUE}Backups:${NC} $BACKUP_DIR"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Edit .env file with your actual values"
    echo "2. Update domain names in configuration files"
    echo "3. Add your API keys to services.yml"
    echo "4. Restart services: docker-compose restart"
    echo
    echo -e "${BLUE}Useful commands:${NC}"
    echo "  View logs: docker-compose logs -f"
    echo "  Stop services: docker-compose down"
    echo "  Update services: docker-compose pull && docker-compose up -d"
    echo "  Backup config: ./deploy.sh backup"
    echo
}

# Function to backup configuration
backup() {
    log "Creating configuration backup..."
    local backup_file
    backup_file="$BACKUP_DIR/homepage-config-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf "$backup_file" -C "$SCRIPT_DIR" config/ .env
    log "Backup created: $backup_file"
}

# Function to restore configuration
restore() {
    if [[ -z "$1" ]]; then
        error "Please specify backup file to restore"
    fi
    
    local backup_file
    backup_file="$1"
    if [[ ! -f "$backup_file" ]]; then
        error "Backup file not found: $backup_file"
    fi
    
    log "Restoring configuration from: $backup_file"
    
    # Stop services
    docker-compose down
    
    # Restore configuration
    tar -xzf "$backup_file" -C "$SCRIPT_DIR"
    
    # Start services
    docker-compose up -d
    
    log "Configuration restored successfully!"
}

# Function to update services
update() {
    log "Updating Homepage services..."
    
    # Pull latest images
    docker-compose pull
    
    # Restart services
    docker-compose down
    docker-compose up -d
    
    log "Services updated successfully!"
}

# Function to show logs
logs() {
    docker-compose logs -f
}

# Function to show status
status() {
    log "Service status:"
    docker-compose ps
    echo
    log "Recent logs:"
    docker-compose logs --tail=20
}

# Function to show help
show_help() {
    echo -e "${GREEN}Homepage Dashboard Deployment Script${NC}"
    echo
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  deploy     Deploy Homepage dashboard (default)"
    echo "  backup     Create configuration backup"
    echo "  restore    Restore configuration from backup"
    echo "  update     Update Homepage services"
    echo "  logs       Show service logs"
    echo "  status     Show service status"
    echo "  help       Show this help message"
    echo
    echo "Examples:"
    echo "  $0                    # Deploy Homepage"
    echo "  $0 backup             # Create backup"
    echo "  $0 restore backup.tar.gz  # Restore from backup"
    echo "  $0 update             # Update services"
    echo
}

# Main script logic
main() {
    case "${1:-deploy}" in
        "deploy")
            check_prerequisites
            backup_config
            validate_config
            setup_environment
            deploy_homepage
            check_health
            show_info
            ;;
        "backup")
            backup
            ;;
        "restore")
            restore "$2"
            ;;
        "update")
            update
            ;;
        "logs")
            logs
            ;;
        "status")
            status
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            error "Unknown command: $1. Use '$0 help' for usage information."
            ;;
    esac
}

# Run main function with all arguments
main "$@" 