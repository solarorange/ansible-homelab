#!/bin/bash

# External Server Integration Script for HomelabOS
# Simple wrapper script for integrating external servers
#
# Quick Usage:
#   ./scripts/integrate_server.sh                    # Interactive setup
#   ./scripts/integrate_server.sh --name synology --ip 192.168.1.100 --port 5000
#   ./scripts/integrate_server.sh --config my_servers.yml

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Log file
LOG_FILE="/var/log/homelab/external_integration.log"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Python 3 is available
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is required but not installed"
        exit 1
    fi
    
    # Check if required Python packages are installed
    python3 -c "import yaml, requests" 2>/dev/null || {
        print_error "Required Python packages not found. Installing..."
        pip3 install pyyaml requests
    }
    
    # Check if we're in the right directory
    if [[ ! -f "$PROJECT_DIR/group_vars/all/common.yml" ]]; then
        print_error "Not in a valid HomelabOS directory"
        print_error "Please run this script from your HomelabOS project root"
        exit 1
    fi
    
    # Load domain from configuration
    if [[ -f "$PROJECT_DIR/group_vars/all/common.yml" ]]; then
        DOMAIN=$(grep -E "^domain:" "$PROJECT_DIR/group_vars/all/common.yml" | awk '{print $2}' | tr -d '"' | tr -d "'" 2>/dev/null || echo "")
        if [[ -n "$DOMAIN" ]]; then
            export DOMAIN="$DOMAIN"
            print_status "Loaded domain: $DOMAIN"
        else
            print_warning "Domain not found in configuration, will prompt for it"
        fi
    fi
    
    # Create log directory
    mkdir -p "$(dirname "$LOG_FILE")"
    
    print_status "Prerequisites check passed"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -c, --config FILE     Use configuration file"
    echo "  -n, --name NAME       Server name"
    echo "  -i, --ip IP           Server IP address"
    echo "  -p, --port PORT       Server port"
    echo "  -s, --subdomain SUB   Subdomain (defaults to server name)"
    echo "  -d, --description DESC Server description"
    echo "  -a, --auth            Enable authentication"
    echo "  -m, --monitoring      Enable monitoring (default: true)"
    echo "  -b, --backup          Enable backup"
    echo "  -h, --help            Show this help"
    echo ""
    echo "Examples:"
    echo "  # Integrate a single server"
    echo "  $0 --name synology --ip 192.168.1.100 --port 5000"
    echo ""
    echo "  # Use configuration file"
    echo "  $0 --config config/external_servers.yml"
    echo ""
    echo "  # Integrate with custom subdomain"
    echo "  $0 --name nas --ip 192.168.1.100 --port 5000 --subdomain storage"
}

# Function to validate IP address
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [[ $octet -lt 0 || $octet -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Function to validate port
validate_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ ]] && [[ $port -ge 1 ]] && [[ $port -le 65535 ]]; then
        return 0
    else
        return 1
    fi
}

# Function to get user input
get_user_input() {
    local prompt="$1"
    local default="$2"
    local required="$3"
    
    while true; do
        if [[ -n "$default" ]]; then
            read -p "$prompt [$default]: " input
            input=${input:-$default}
        else
            read -p "$prompt: " input
        fi
        
        if [[ -n "$input" ]] || [[ "$required" != "true" ]]; then
            echo "$input"
            return 0
        else
            print_warning "This field is required"
        fi
    done
}

# Function to interactive setup
interactive_setup() {
    print_header "External Server Integration Setup"
    
    echo "This script will integrate an external server into your HomelabOS ecosystem."
    echo "It will configure SSL certificates, DNS records, monitoring, and more."
    echo ""
    
    # Get server details with better defaults
    server_name=$(get_user_input "Enter server name (e.g., synology, nas, server)" "" "true")
    
    # Validate and get IP address
    while true; do
        server_ip=$(get_user_input "Enter server IP address" "" "true")
        if validate_ip "$server_ip"; then
            break
        else
            print_error "Invalid IP address format. Please enter a valid IP (e.g., 192.168.1.100)"
        fi
    done
    
    # Get port with validation
    while true; do
        server_port=$(get_user_input "Enter server port" "80" "true")
        if validate_port "$server_port"; then
            break
        else
            print_error "Invalid port number. Please enter a port between 1-65535"
        fi
    done
    
    # Get subdomain with smart default
    default_subdomain=$(echo "$server_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
    subdomain=$(get_user_input "Enter subdomain" "$default_subdomain" "false")
    
    # Get description with smart default
    default_description="$server_name external server"
    description=$(get_user_input "Enter server description" "$default_description" "false")
    
    # Get optional settings with better prompts
    echo ""
    print_header "Configuration Options"
    echo "Configure additional settings for your external server:"
    echo ""
    
    auth_enabled=$(get_user_input "Enable authentication (SSO/Login)? (y/N)" "N" "false")
    monitoring_enabled=$(get_user_input "Enable monitoring (Grafana dashboards)? (Y/n)" "Y" "false")
    backup_enabled=$(get_user_input "Enable automated backups? (y/N)" "N" "false")
    ssl_enabled=$(get_user_input "Enable SSL certificate (HTTPS)? (Y/n)" "Y" "false")
    
    # Convert to boolean
    auth_enabled=$([[ "$auth_enabled" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    monitoring_enabled=$([[ "$monitoring_enabled" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    backup_enabled=$([[ "$backup_enabled" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    ssl_enabled=$([[ "$ssl_enabled" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    
    # Build command
    cmd_args=(
        "--server-name" "$server_name"
        "--ip" "$server_ip"
        "--port" "$server_port"
    )
    
    if [[ -n "$subdomain" ]]; then
        cmd_args+=("--subdomain" "$subdomain")
    fi
    
    if [[ -n "$description" ]]; then
        cmd_args+=("--description" "$description")
    fi
    
    if [[ "$auth_enabled" == "true" ]]; then
        cmd_args+=("--auth-enabled")
    fi
    
    if [[ "$monitoring_enabled" == "true" ]]; then
        cmd_args+=("--monitoring-enabled")
    fi
    
    if [[ "$backup_enabled" == "true" ]]; then
        cmd_args+=("--backup-enabled")
    fi
    
    if [[ "$ssl_enabled" == "true" ]]; then
        cmd_args+=("--ssl-enabled")
    fi
    
    # Show summary with better formatting
    echo ""
    print_header "Integration Summary"
    echo "📋 Server Configuration:"
    echo "   • Name: $server_name"
    echo "   • IP Address: $server_ip"
    echo "   • Port: $server_port"
    echo "   • Subdomain: ${subdomain:-$server_name}.$DOMAIN"
    echo "   • Description: ${description:-N/A}"
    echo ""
    echo "🔧 Features to be enabled:"
    echo "   • Authentication: $auth_enabled"
    echo "   • Monitoring: $monitoring_enabled"
    echo "   • Backup: $backup_enabled"
    echo "   • SSL Certificate: $ssl_enabled"
    echo ""
    echo "🌐 Your server will be accessible at:"
    echo "   https://${subdomain:-$server_name}.$DOMAIN"
    echo ""
    
    # Confirm with better prompt
    read -p "🚀 Proceed with integration? (Y/n): " confirm
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        print_status "Integration cancelled"
        exit 0
    fi
    
    # Run integration
    run_integration "${cmd_args[@]}"
}

# Function to run integration
run_integration() {
    print_status "Starting integration..."
    
    # Change to project directory
    cd "$PROJECT_DIR"
    
    # Run the Python script
    if python3 "$SCRIPT_DIR/integrate_external_server.py" "$@"; then
        print_status "Integration completed successfully!"
        echo ""
        print_header "✅ Integration Complete!"
        echo ""
        echo "📋 What was configured:"
        echo "   • DNS record created for ${subdomain:-$server_name}.$DOMAIN"
        echo "   • SSL certificate generated (if enabled)"
        echo "   • Traefik reverse proxy configured"
        echo "   • Grafana monitoring dashboard added (if enabled)"
        echo "   • Health checks configured"
        echo "   • Backup automation set up (if enabled)"
        echo "   • Homepage dashboard updated"
        echo ""
        echo "🔍 Next Steps:"
        echo "1. Test access: https://${subdomain:-$server_name}.$DOMAIN"
        echo "2. Check Grafana: https://grafana.$DOMAIN"
        echo "3. View Homepage: https://dash.$DOMAIN"
        echo "4. Review logs: logs/external_servers/"
        echo ""
        echo "🎉 Your external server is now fully integrated into HomelabOS!"
    else
        print_error "Integration failed. Check logs for details."
        echo ""
        echo "🔧 Troubleshooting:"
        echo "1. Check logs: logs/external_servers/"
        echo "2. Verify network connectivity to $server_ip:$server_port"
        echo "3. Ensure DNS is properly configured"
        echo "4. Check SSL certificate status"
        exit 1
    fi
}

# Function to show configuration template
show_config_template() {
    print_header "Configuration File Template"
    echo "You can create a configuration file to integrate multiple servers at once."
    echo ""
    echo "Example configuration file (config/external_servers.yml):"
    echo ""
    cat << 'EOF'
servers:
  - name: "synology"
    ip_address: "192.168.1.100"
    port: 5000
    subdomain: "nas"
    description: "Synology NAS - File Storage"
    ssl_enabled: true
    auth_enabled: true
    monitoring_enabled: true
    backup_enabled: true

  - name: "unraid"
    ip_address: "192.168.1.101"
    port: 80
    subdomain: "unraid"
    description: "Unraid Server"
    ssl_enabled: true
    auth_enabled: true
    monitoring_enabled: true
    backup_enabled: false
EOF
    echo ""
    echo "Then run: $0 --config config/external_servers.yml"
}

# Main script
main() {
    # Parse command line arguments
    CONFIG_FILE=""
    SERVER_NAME=""
    SERVER_IP=""
    SERVER_PORT=""
    SUBDOMAIN=""
    DESCRIPTION=""
    AUTH_ENABLED=false
    MONITORING_ENABLED=true
    BACKUP_ENABLED=false
    SSL_ENABLED=true
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -n|--name)
                SERVER_NAME="$2"
                shift 2
                ;;
            -i|--ip)
                SERVER_IP="$2"
                shift 2
                ;;
            -p|--port)
                SERVER_PORT="$2"
                shift 2
                ;;
            -s|--subdomain)
                SUBDOMAIN="$2"
                shift 2
                ;;
            -d|--description)
                DESCRIPTION="$2"
                shift 2
                ;;
            -a|--auth)
                AUTH_ENABLED=true
                shift
                ;;
            -m|--monitoring)
                MONITORING_ENABLED=true
                shift
                ;;
            -b|--backup)
                BACKUP_ENABLED=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            --template)
                show_config_template
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check prerequisites
    check_prerequisites
    
    # If no arguments provided, run interactive setup
    if [[ -z "$CONFIG_FILE" ]] && [[ -z "$SERVER_NAME" ]]; then
        interactive_setup
        exit 0
    fi
    
    # Build command arguments
    cmd_args=()
    
    if [[ -n "$CONFIG_FILE" ]]; then
        cmd_args+=("--config" "$CONFIG_FILE")
    else
        if [[ -z "$SERVER_NAME" ]] || [[ -z "$SERVER_IP" ]] || [[ -z "$SERVER_PORT" ]]; then
            print_error "Server name, IP, and port are required"
            show_usage
            exit 1
        fi
        
        cmd_args+=("--server-name" "$SERVER_NAME")
        cmd_args+=("--ip" "$SERVER_IP")
        cmd_args+=("--port" "$SERVER_PORT")
        
        if [[ -n "$SUBDOMAIN" ]]; then
            cmd_args+=("--subdomain" "$SUBDOMAIN")
        fi
        
        if [[ -n "$DESCRIPTION" ]]; then
            cmd_args+=("--description" "$DESCRIPTION")
        fi
        
        if [[ "$AUTH_ENABLED" == "true" ]]; then
            cmd_args+=("--auth-enabled")
        fi
        
        if [[ "$MONITORING_ENABLED" == "true" ]]; then
            cmd_args+=("--monitoring-enabled")
        fi
        
        if [[ "$BACKUP_ENABLED" == "true" ]]; then
            cmd_args+=("--backup-enabled")
        fi
        
        if [[ "$SSL_ENABLED" == "true" ]]; then
            cmd_args+=("--ssl-enabled")
        fi
    fi
    
    # Run integration
    run_integration "${cmd_args[@]}"
}

# Run main function
main "$@" 