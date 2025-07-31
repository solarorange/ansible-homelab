#!/bin/bash

# Ansible Homelab Service Integration Script
# Wrapper for the service wizard

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Ansible Homelab Service Integration Wizard"
echo "=============================================="

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is required but not installed"
    exit 1
fi

# Check if required modules are available
if ! python3 -c "import yaml, requests, pathlib" &> /dev/null; then
    echo "❌ Error: Required Python modules not available"
    echo "Please install: pip3 install pyyaml requests"
    exit 1
fi

# Run the service wizard
echo "✅ Environment check passed"
echo ""

# Pass all arguments to the Python script
python3 "$SCRIPT_DIR/service_wizard.py" --project-root "$PROJECT_ROOT" "$@" 