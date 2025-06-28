#!/bin/bash

# Quick Setup Script
# Runs both notification and monitoring threshold setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Homelab Quick Setup Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if scripts exist
if [ ! -f "scripts/setup_notifications.sh" ]; then
    echo -e "${RED}Error: setup_notifications.sh not found${NC}"
    exit 1
fi

if [ ! -f "scripts/setup_monitoring_thresholds.sh" ]; then
    echo -e "${RED}Error: setup_monitoring_thresholds.sh not found${NC}"
    exit 1
fi

# Check if required files exist
if [ ! -f "group_vars/all/notifications.yml" ]; then
    echo -e "${RED}Error: notifications.yml not found${NC}"
    exit 1
fi

if [ ! -f "group_vars/all/monitoring_thresholds.yml" ]; then
    echo -e "${RED}Error: monitoring_thresholds.yml not found${NC}"
    exit 1
fi

echo -e "${YELLOW}This script will configure:${NC}"
echo "  1. Notification webhooks (Email, Slack, Discord, Telegram, PagerDuty)"
echo "  2. Monitoring thresholds (System, Services, Applications)"
echo "  3. Alert routing and timing"
echo ""

read -p "Continue with setup? (y/n): " continue_setup

if [[ ! $continue_setup =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Setup cancelled${NC}"
    exit 0
fi

echo ""

# Step 1: Setup Notifications
echo -e "${BLUE}Step 1: Setting up notifications...${NC}"
echo ""

./scripts/setup_notifications.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}Notification setup failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Notifications configured successfully${NC}"
echo ""

# Step 2: Setup Monitoring Thresholds
echo -e "${BLUE}Step 2: Setting up monitoring thresholds...${NC}"
echo ""

./scripts/setup_monitoring_thresholds.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}Monitoring thresholds setup failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Monitoring thresholds configured successfully${NC}"
echo ""

# Step 3: Validate Configuration
echo -e "${BLUE}Step 3: Validating configuration...${NC}"

# Check if vault file exists and has content
if [ -f "group_vars/all/vault.yml" ]; then
    vault_size=$(wc -l < "group_vars/all/vault.yml")
    if [ $vault_size -gt 0 ]; then
        echo -e "${GREEN}✓ Vault file configured${NC}"
    else
        echo -e "${YELLOW}⚠️  Vault file is empty${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Vault file not found${NC}"
fi

# Check if configuration files are valid YAML
if command -v yamllint &> /dev/null; then
    echo "Validating YAML files..."
    yamllint group_vars/all/notifications.yml && echo -e "${GREEN}✓ notifications.yml is valid${NC}"
    yamllint group_vars/all/monitoring_thresholds.yml && echo -e "${GREEN}✓ monitoring_thresholds.yml is valid${NC}"
else
    echo -e "${YELLOW}⚠️  yamllint not found, skipping YAML validation${NC}"
fi

echo ""

# Step 4: Generate Summary
echo -e "${BLUE}Step 4: Configuration Summary${NC}"
echo ""

echo -e "${YELLOW}Configuration Files:${NC}"
echo "  - group_vars/all/notifications.yml"
echo "  - group_vars/all/monitoring_thresholds.yml"
echo "  - group_vars/all/vault.yml"

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Review the configuration files"
echo "2. Encrypt the vault file:"
echo "   ansible-vault encrypt group_vars/all/vault.yml"
echo ""
echo "3. Deploy the configuration:"
echo "   ansible-playbook -i inventory.yml site.yml --ask-vault-pass"
echo ""
echo "4. Test notifications:"
echo "   ansible-playbook -i inventory.yml tasks/test_notifications.yml --ask-vault-pass"
echo ""

# Check if user wants to proceed with deployment
read -p "Proceed with vault encryption and deployment? (y/n): " proceed_deploy

if [[ $proceed_deploy =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}Encrypting vault file...${NC}"
    
    if [ -f "group_vars/all/vault.yml" ]; then
        ansible-vault encrypt group_vars/all/vault.yml
        echo -e "${GREEN}✓ Vault file encrypted${NC}"
    else
        echo -e "${RED}Error: vault file not found${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}Ready for deployment!${NC}"
    echo "Run: ansible-playbook -i inventory.yml site.yml --ask-vault-pass"
else
    echo ""
    echo -e "${YELLOW}Manual deployment required${NC}"
    echo "Remember to encrypt the vault file before deployment"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Quick Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo "" 