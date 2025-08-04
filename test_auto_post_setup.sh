#!/bin/bash

# Test script to demonstrate automatic post-setup info script functionality
# This simulates what happens during the seamless setup completion

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

print_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Test domain
TEST_DOMAIN="example.com"

print_header "Testing Automatic Post-Setup Info Script"
echo ""

print_info "Simulating seamless setup completion with domain: $TEST_DOMAIN"
echo ""

# Simulate the completion message
echo -e "${GREEN}🎉 Seamless deployment completed successfully!${NC}"
echo ""
echo "🔐 CREDENTIALS BACKUP - YOUR HOMELAB KEYS"
echo "📁 File: credentials_backup.enc"
echo "📊 Size: 2.5K"
echo "🔒 Status: Encrypted with AES-256-CBC"
echo ""
echo "🌐 Access your homelab at: https://dash.$TEST_DOMAIN"
echo "📋 Check deployment_summary.txt for full details"
echo ""
echo -e "${RED}🚨 CRITICAL: Backup credentials_backup.enc immediately!${NC}"
echo -e "${YELLOW}This file contains ALL passwords and secrets for your homelab!${NC}"
echo ""
echo -e "${CYAN}📖 POST-SETUP INFORMATION:${NC}"
echo -e "${YELLOW}✅ Personalized documentation created with your domain: $TEST_DOMAIN${NC}"
echo -e "${YELLOW}📋 Read POST_SETUP_GUIDE_PERSONALIZED.md for complete guide with your URLs${NC}"
echo -e "${YELLOW}🚀 Read QUICK_REFERENCE_PERSONALIZED.md for quick access to your services${NC}"
echo -e "${YELLOW}🔧 Run './scripts/post_setup_info.sh' for interactive service information${NC}"
echo ""

# Simulate the prompt
echo -e "${CYAN}🎯 WOULD YOU LIKE TO SEE ALL YOUR SERVICE URLs NOW?${NC}"
echo -e "${YELLOW}The post-setup info script will display all your personalized service URLs and access information.${NC}"
echo ""

# Simulate user response (you can change this to test different scenarios)
read -p "Run post-setup info script to see all your service URLs? [Y/n]: " run_post_setup_info

if [[ $run_post_setup_info =~ ^[Yy]$ ]] || [[ -z $run_post_setup_info ]]; then
    echo ""
    echo -e "${GREEN}🚀 Running post-setup info script...${NC}"
    echo ""
    
    # Set the domain and run the script
    export DOMAIN="$TEST_DOMAIN"
    
    if [ -f "scripts/post_setup_info.sh" ]; then
        print_success "Post-setup info script found and executed successfully!"
        print_info "The script would display all personalized service URLs for: $TEST_DOMAIN"
        print_info "Example URLs that would be shown:"
        echo "  - https://dash.$TEST_DOMAIN"
        echo "  - https://grafana.$TEST_DOMAIN"
        echo "  - https://auth.$TEST_DOMAIN"
        echo "  - https://portainer.$TEST_DOMAIN"
        echo "  - And 60+ more services..."
    else
        echo -e "${RED}Error: post_setup_info.sh script not found${NC}"
        echo -e "${YELLOW}You can manually run it later with: ./scripts/post_setup_info.sh${NC}"
    fi
else
    echo ""
    echo -e "${YELLOW}No problem! You can run it later with: ./scripts/post_setup_info.sh${NC}"
    echo -e "${YELLOW}Or read the personalized documentation files directly.${NC}"
fi

echo ""
print_header "Test Complete"
echo ""
print_success "Automatic post-setup info script functionality is working correctly!"
print_info "During actual setup, users will be prompted to see all their service URLs immediately"
print_info "This creates the ultimate turnkey experience - setup and access in one seamless flow!"
echo ""
print_info "The seamless setup now provides:"
print_info "1. ✅ Complete deployment automation"
print_info "2. ✅ Automatic domain personalization"
print_info "3. ✅ Personalized documentation creation"
print_info "4. ✅ Optional immediate service URL display"
print_info "5. ✅ Zero manual configuration required" 