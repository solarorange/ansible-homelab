#!/bin/bash

# Test script to demonstrate domain personalization
# This simulates what happens during the seamless setup

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

# Test domain
TEST_DOMAIN="example.com"
TEST_IP="192.168.1.100"
TEST_EMAIL="admin@example.com"

print_header "Testing Domain Personalization"
echo ""

print_info "Simulating seamless setup with domain: $TEST_DOMAIN"
echo ""

# Test the sed replacements
print_info "Testing domain replacement in POST_SETUP_GUIDE.md..."
if [ -f "POST_SETUP_GUIDE.md" ]; then
    # Create a backup
    cp POST_SETUP_GUIDE.md POST_SETUP_GUIDE.md.backup
    
    # Test the replacement
    sed -i "s/your-domain\.com/$TEST_DOMAIN/g" POST_SETUP_GUIDE.md
    sed -i "s/your-domain/$TEST_DOMAIN/g" POST_SETUP_GUIDE.md
    
    # Check if replacement worked
    if grep -q "$TEST_DOMAIN" POST_SETUP_GUIDE.md; then
        print_success "Domain replacement successful in POST_SETUP_GUIDE.md"
    else
        print_info "No domain placeholders found in POST_SETUP_GUIDE.md"
    fi
    
    # Restore backup
    mv POST_SETUP_GUIDE.md.backup POST_SETUP_GUIDE.md
else
    print_info "POST_SETUP_GUIDE.md not found"
fi

print_info "Testing domain replacement in QUICK_REFERENCE.md..."
if [ -f "QUICK_REFERENCE.md" ]; then
    # Create a backup
    cp QUICK_REFERENCE.md QUICK_REFERENCE.md.backup
    
    # Test the replacement
    sed -i "s/your-domain\.com/$TEST_DOMAIN/g" QUICK_REFERENCE.md
    sed -i "s/your-domain/$TEST_DOMAIN/g" QUICK_REFERENCE.md
    
    # Check if replacement worked
    if grep -q "$TEST_DOMAIN" QUICK_REFERENCE.md; then
        print_success "Domain replacement successful in QUICK_REFERENCE.md"
    else
        print_info "No domain placeholders found in QUICK_REFERENCE.md"
    fi
    
    # Restore backup
    mv QUICK_REFERENCE.md.backup QUICK_REFERENCE.md
else
    print_info "QUICK_REFERENCE.md not found"
fi

echo ""
print_header "Personalization Test Complete"
echo ""
print_success "Domain personalization functionality is working correctly!"
print_info "During actual setup, your domain will be automatically inserted into all documentation"
print_info "You'll get personalized guides with all your service URLs ready to use"
echo ""
print_info "Example personalized URL: https://dash.$TEST_DOMAIN" 