#!/bin/bash
# DumbAssets Seamless Deployment Script
# Demonstrates zero-configuration deployment with optional customization

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to validate environment
validate_environment() {
    print_status "Validating deployment environment..."
    
    # Check if ansible-playbook is available
    if ! command_exists ansible-playbook; then
        print_error "ansible-playbook not found. Please install Ansible first."
        exit 1
    fi
    
    # Check if we're in the right directory
    if [[ ! -f "site.yml" ]]; then
        print_error "site.yml not found. Please run this script from the ansible_homelab root directory."
        exit 1
    fi
    
    print_success "Environment validation passed"
}

# Function to show usage
show_usage() {
    cat << EOF
DumbAssets Seamless Deployment Script

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -p, --pin PIN           Set custom PIN (default: 1234)
    -t, --title TITLE       Set site title (default: Asset Tracker)
    -c, --currency CODE     Set currency code (default: USD)
    -z, --timezone TZ       Set timezone (default: America/New_York)
    -n, --notifications URL Set Apprise notification URL
    -d, --demo              Enable demo mode
    --dry-run               Show what would be deployed without running
    --backup                Create backup before deployment
    --validate-only         Only validate configuration

EXAMPLES:
    # Zero-configuration deployment
    $0
    
    # Custom PIN only
    $0 -p 5678
    
    # Full custom configuration
    $0 -p secure123 -t "My Asset Tracker" -c EUR -z "Europe/Berlin"
    
    # With notifications
    $0 -p 5678 -n "discord://webhook_url"
    
    # Demo mode
    $0 -d -p demo123

EOF
}

# Function to generate secure PIN
generate_secure_pin() {
    if command_exists openssl; then
        openssl rand -base64 32 | tr -d "=+/" | cut -c1-8
    else
        # Fallback to /dev/urandom
        cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1
    fi
}

# Function to set environment variables
set_environment_vars() {
    local pin="${1:-}"
    local title="${2:-}"
    local currency="${3:-}"
    local timezone="${4:-}"
    local notifications="${5:-}"
    local demo="${6:-false}"
    
    # Set PIN (generate secure one if not provided)
    if [[ -n "$pin" ]]; then
        export DUMBASSETS_PIN="$pin"
        print_status "Using custom PIN: $pin"
    else
        local secure_pin=$(generate_secure_pin)
        export DUMBASSETS_PIN="$secure_pin"
        print_warning "Using generated secure PIN: $secure_pin"
        print_warning "Please save this PIN for future access!"
    fi
    
    # Set other variables if provided
    if [[ -n "$title" ]]; then
        export DUMBASSETS_SITE_TITLE="$title"
        print_status "Site title: $title"
    fi
    
    if [[ -n "$currency" ]]; then
        export DUMBASSETS_CURRENCY_CODE="$currency"
        print_status "Currency: $currency"
    fi
    
    if [[ -n "$timezone" ]]; then
        export DUMBASSETS_TIMEZONE="$timezone"
        print_status "Timezone: $timezone"
    fi
    
    if [[ -n "$notifications" ]]; then
        export DUMBASSETS_APPRISE_URL="$notifications"
        print_status "Notifications enabled"
    fi
    
    if [[ "$demo" == "true" ]]; then
        export DUMBASSETS_DEMO_MODE="true"
        print_status "Demo mode enabled"
    fi
}

# Function to run ansible playbook
run_ansible() {
    local dry_run="${1:-false}"
    local backup="${2:-false}"
    local validate_only="${3:-false}"
    
    local cmd="ansible-playbook site.yml --tags dumbassets"
    
    if [[ "$dry_run" == "true" ]]; then
        cmd="$cmd --check --diff"
        print_status "Running in dry-run mode..."
    fi
    
    if [[ "$backup" == "true" ]]; then
        cmd="$cmd --tags backup"
        print_status "Creating backup before deployment..."
    fi
    
    if [[ "$validate_only" == "true" ]]; then
        cmd="$cmd --tags validation"
        print_status "Running validation only..."
    fi
    
    print_status "Executing: $cmd"
    eval "$cmd"
}

# Function to show post-deployment info
show_post_deployment_info() {
    local pin="${1:-}"
    
    cat << EOF

${GREEN}🎉 DumbAssets Deployment Complete!${NC}

${BLUE}Access Information:${NC}
  • Local Access: http://localhost:3004
  • External Access: https://assets.yourdomain.com
  • PIN: ${pin:-$DUMBASSETS_PIN}

${BLUE}Management Commands:${NC}
  • Check status: docker ps dumbassets
  • View logs: docker logs dumbassets
  • Restart: docker restart dumbassets
  • Backup: docker exec dumbassets /app/scripts/backup.sh

${BLUE}Next Steps:${NC}
  1. Access the application using the PIN above
  2. Change the default PIN in the application settings
  3. Add your first asset
  4. Configure notifications (optional)

${YELLOW}Security Note:${NC}
  • The PIN shown above is your access credential
  • Change it immediately after first login
  • Store it securely for future access

${BLUE}Support:${NC}
  • Documentation: roles/dumbassets/README.md
  • Configuration: roles/dumbassets/CONFIGURATION.md
  • Issues: Check docker logs dumbassets

EOF
}

# Main script logic
main() {
    local pin=""
    local title=""
    local currency=""
    local timezone=""
    local notifications=""
    local demo=false
    local dry_run=false
    local backup=false
    local validate_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -p|--pin)
                pin="$2"
                shift 2
                ;;
            -t|--title)
                title="$2"
                shift 2
                ;;
            -c|--currency)
                currency="$2"
                shift 2
                ;;
            -z|--timezone)
                timezone="$2"
                shift 2
                ;;
            -n|--notifications)
                notifications="$2"
                shift 2
                ;;
            -d|--demo)
                demo=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --backup)
                backup=true
                shift
                ;;
            --validate-only)
                validate_only=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Validate environment
    validate_environment
    
    # Set environment variables
    set_environment_vars "$pin" "$title" "$currency" "$timezone" "$notifications" "$demo"
    
    # Run ansible playbook
    if run_ansible "$dry_run" "$backup" "$validate_only"; then
        if [[ "$dry_run" == "false" && "$validate_only" == "false" ]]; then
            show_post_deployment_info "$pin"
        fi
        print_success "Deployment completed successfully!"
    else
        print_error "Deployment failed. Check the output above for details."
        exit 1
    fi
}

# Run main function with all arguments
main "$@" 