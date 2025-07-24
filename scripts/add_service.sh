#!/bin/bash

# Ansible Homelab Service Integration Wizard
# Simple wrapper script for the Python wizard

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  🚀 ANSIBLE HOMELAB SERVICE WIZARD${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}This wizard will help you add new services to your homelab stack.${NC}"
echo -e "${YELLOW}It will generate complete Ansible roles with full integration.${NC}"
echo ""

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is required but not installed.${NC}"
    exit 1
fi

# Check if required Python packages are available
python3 -c "import yaml, requests" 2>/dev/null || {
    echo -e "${YELLOW}Installing required Python packages...${NC}"
    pip3 install pyyaml requests
}

# Check if we're in the right directory
if [[ ! -f "$PROJECT_ROOT/site.yml" ]] || [[ ! -d "$PROJECT_ROOT/roles" ]]; then
    echo -e "${RED}Error: This script must be run from the Ansible homelab project root.${NC}"
    echo -e "${YELLOW}Current directory: $(pwd)${NC}"
    echo -e "${YELLOW}Expected project root: $PROJECT_ROOT${NC}"
    exit 1
fi

# Run the wizard
echo -e "${GREEN}Starting service integration wizard...${NC}"
echo ""

cd "$PROJECT_ROOT"
python3 "$SCRIPT_DIR/service_wizard.py" --project-root "$PROJECT_ROOT"

echo ""
echo -e "${GREEN}Wizard completed!${NC}" 