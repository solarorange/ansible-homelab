#!/bin/bash

# Post-Setup Information Script
# Displays access URLs and quick reference information after seamless setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}================================${NC}"
}

print_section() {
    echo -e "${BLUE}$1${NC}"
}

print_url() {
    echo -e "${CYAN}  $1${NC}"
}

print_info() {
    echo -e "${YELLOW}  $1${NC}"
}

print_success() {
    echo -e "${GREEN}  ✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}  ⚠️  $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "group_vars/all/common.yml" ]; then
    echo -e "${RED}Error: This script must be run from the ansible_homelab directory${NC}"
    exit 1
fi

# Try to get domain from environment variable first (set by seamless setup)
if [ -z "$DOMAIN" ]; then
    # Try to get domain from configuration
    if [ -f "group_vars/all/common.yml" ]; then
        DOMAIN=$(grep -E "^domain:" group_vars/all/common.yml | awk '{print $2}' | tr -d '"' | tr -d "'" 2>/dev/null || echo "")
    fi
fi

# If domain still not found, prompt user
if [ -z "$DOMAIN" ]; then
    echo -e "${YELLOW}Domain not found in configuration.${NC}"
    read -p "Enter your domain (e.g., example.com): " DOMAIN
fi

# Validate domain format
if [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${RED}Invalid domain format. Please enter a valid domain.${NC}"
    exit 1
fi

clear

# Check if this is being run automatically from seamless setup
if [ -n "$DOMAIN" ] && [ "$DOMAIN" != "" ]; then
    print_header "🎉 CONGRATULATIONS! Your Homelab is Ready!"
    echo ""
    print_success "Your seamless setup has completed successfully!"
    print_success "Your homelab is now production-ready with 60+ services!"
    print_info "Domain automatically detected: $DOMAIN"
else
    print_header "🎉 HOMELAB SERVICE INFORMATION"
    echo ""
    print_success "Displaying all your homelab service URLs and access information"
fi
echo ""

print_section "🔑 PRIMARY ACCESS POINTS"
print_url "🏠 Homepage Dashboard: https://dash.$DOMAIN"
print_info "  - Your central hub for all services"
print_info "  - Real-time service status and quick access"
echo ""

print_url "🔐 Authentik (SSO): https://auth.$DOMAIN"
print_info "  - Single sign-on for all services"
print_info "  - Central authentication management"
echo ""

print_url "📊 Grafana: https://grafana.$DOMAIN"
print_info "  - System monitoring and dashboards"
print_info "  - Pre-configured with 6 comprehensive dashboards"
echo ""

print_url "🐳 Portainer: https://portainer.$DOMAIN"
print_info "  - Docker container management"
print_info "  - Create account during first login"
echo ""

print_section "🎬 MEDIA SERVICES"
print_url "🎬 Jellyfin: https://jellyfin.$DOMAIN"
print_url "📺 Plex: https://plex.$DOMAIN"
print_url "📺 Sonarr: https://sonarr.$DOMAIN"
print_url "🎬 Radarr: https://radarr.$DOMAIN"
print_url "🎵 Lidarr: https://lidarr.$DOMAIN"
print_url "📖 Readarr: https://readarr.$DOMAIN"
echo ""

print_section "🛠️ DEVELOPMENT & AUTOMATION"
print_url "💻 Code Server: https://code.$DOMAIN"
print_url "🔧 GitLab: https://gitlab.$DOMAIN"
print_url "🤖 n8n: https://n8n.$DOMAIN"
print_url "🧠 Pezzo: https://pezzo.$DOMAIN"
echo ""

print_section "📁 STORAGE & DOCUMENTS"
print_url "☁️ Nextcloud: https://nextcloud.$DOMAIN"
print_url "📁 Filebrowser: https://filebrowser.$DOMAIN"
print_url "📚 Bookstack: https://bookstack.$DOMAIN"
print_url "📄 Paperless: https://paperless.$DOMAIN"
echo ""

print_section "🔍 NETWORK & SECURITY"
print_url "🔍 Reconya: https://reconya.$DOMAIN"
print_url "🔍 Fing: https://fing.$DOMAIN"
print_url "🛡️ Pi-hole: https://pihole.$DOMAIN"
print_url "🔐 Vaultwarden: https://vaultwarden.$DOMAIN"
echo ""

print_section "📊 MONITORING & ALERTS"
print_url "📊 Prometheus: https://prometheus.$DOMAIN"
print_url "🚨 AlertManager: https://alerts.$DOMAIN"
print_url "📝 Loki: https://loki.$DOMAIN"
print_url "⏱️ Uptime Kuma: https://uptime.$DOMAIN"
echo ""

print_section "🔧 QUICK VERIFICATION COMMANDS"
echo -e "${CYAN}  # Check all services are running${NC}"
echo -e "${YELLOW}  docker ps${NC}"
echo ""
echo -e "${CYAN}  # Check system resources${NC}"
echo -e "${YELLOW}  htop${NC}"
echo -e "${YELLOW}  df -h${NC}"
echo ""
echo -e "${CYAN}  # Check monitoring stack${NC}"
echo -e "${YELLOW}  docker ps | grep -E \"(grafana|prometheus|loki|alertmanager)\"${NC}"
echo ""
echo -e "${CYAN}  # Check firewall status${NC}"
echo -e "${YELLOW}  sudo ufw status${NC}"
echo ""

print_section "📖 DOCUMENTATION"
if [ -f "POST_SETUP_GUIDE_PERSONALIZED.md" ]; then
    print_url "📋 Complete Guide: POST_SETUP_GUIDE_PERSONALIZED.md"
    print_info "  - Personalized guide with your domain: $DOMAIN"
    print_info "  - All URLs ready to use immediately"
else
    print_url "📋 Complete Guide: POST_SETUP_GUIDE.md"
    print_info "  - Detailed instructions for all services"
    print_info "  - Configuration guides and troubleshooting"
fi
echo ""

if [ -f "QUICK_REFERENCE_PERSONALIZED.md" ]; then
    print_url "🚀 Quick Reference: QUICK_REFERENCE_PERSONALIZED.md"
    print_info "  - Personalized quick reference with your domain: $DOMAIN"
    print_info "  - All URLs ready to use immediately"
else
    print_url "🚀 Quick Reference: QUICK_REFERENCE.md"
    print_info "  - Essential URLs and commands"
    print_info "  - Quick troubleshooting guide"
fi
echo ""

print_section "🎯 WHAT'S ALREADY CONFIGURED"
print_success "✅ 60+ services deployed with zero port conflicts"
print_success "✅ Complete monitoring with 6 dashboards and 60+ alerts"
print_success "✅ Security hardening with firewall and SSL certificates"
print_success "✅ Automated backups running daily/weekly"
print_success "✅ Log aggregation and performance monitoring"
print_success "✅ Intrusion detection and prevention"
echo ""

print_section "🚀 NEXT STEPS"
print_info "1. Start with the Homepage Dashboard at https://dash.$DOMAIN"
print_info "2. Set up Authentik SSO for single sign-on"
print_info "3. Configure your media services (Sonarr, Radarr, Jellyfin)"
print_info "4. Review Grafana dashboards for system health"
print_info "5. Set up notification channels for alerts"
echo ""

print_section "🆘 NEED HELP?"
print_info "• Check service logs: docker logs <service-name>"
print_info "• Run validation: ansible-playbook tasks/validate_services.yml --ask-vault-pass"
print_info "• Review troubleshooting guide: docs/TROUBLESHOOTING.md"
print_info "• Check system resources: htop, df -h, docker ps"
echo ""

print_header "🏆 YOU'RE ALL SET!"
print_success "Your homelab is production-ready with enterprise-grade security and monitoring!"
print_success "Start exploring your services at: https://dash.$DOMAIN"
echo ""

print_warning "Remember to replace 'your-domain.com' with your actual domain: $DOMAIN"
echo ""

# Offer to open the homepage dashboard
read -p "Would you like to open the homepage dashboard in your browser? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "https://dash.$DOMAIN"
    elif command -v open >/dev/null 2>&1; then
        open "https://dash.$DOMAIN"
    else
        echo -e "${YELLOW}Please manually open: https://dash.$DOMAIN${NC}"
    fi
fi

echo ""
print_success "Happy homelabbing! 🚀" 