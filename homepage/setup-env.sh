#!/bin/bash

# =============================================================================
# HOMEPAGE ENVIRONMENT SETUP SCRIPT
# =============================================================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  HOMEPAGE ENVIRONMENT SETUP${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Check if .env already exists
if [[ -f ".env" ]]; then
    echo -e "${YELLOW}Warning: .env file already exists!${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Copy example file
if [[ -f "env.example" ]]; then
    cp env.example .env
    echo -e "${GREEN}✓ Created .env file from env.example${NC}"
else
    echo -e "${YELLOW}Warning: env.example not found${NC}"
    exit 1
fi

echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Edit .env file with your actual values:"
echo "   nano .env"
echo
echo "2. Update these key values:"
echo "   - DOMAIN=yourdomain.com"
echo "   - OPENWEATHER_API_KEY=your_api_key"
echo "   - ADMIN_PASSWORD={{ vault_homepage_admin_password }}"
echo
echo "3. Add your service API keys"
echo
echo -e "${GREEN}Environment setup completed!${NC}" 