#!/bin/bash
# logging_utils.sh - Standardized logging utility for Homelab shell scripts

# Use environment variables with defaults
LOG_DIR="${HOMELAB_LOG_DIR:-/var/log/homelab}"
LOG_FILE="${HOMELAB_LOG_FILE:-$LOG_DIR/homelab.log}"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Set default service name if not set by the script
: "${SERVICE_NAME:=homelab_script}"

# Log format: TIMESTAMP LEVEL SERVICE ACTION MESSAGE
log_msg() {
    local level="$1"
    local action="$2"
    local message="$3"
    local timestamp
    timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
    echo -e "$timestamp [$level] [$SERVICE_NAME] [$action] $message" | tee -a "$LOG_FILE"
}

log_info()    { log_msg "INFO"    "$1" "$2"; }
log_warning() { log_msg "WARNING" "$1" "$2"; }
log_error()   { log_msg "ERROR"   "$1" "$2"; }
log_success() { log_msg "SUCCESS" "$1" "$2"; }

# Usage in scripts:
#   export SERVICE_NAME="deploy"
#   export HOMELAB_LOG_DIR="/custom/log/path"
#   source ./scripts/logging_utils.sh
#   log_info "check_prerequisites" "Checking prerequisites..."
#   log_error "deploy_stage" "Stage 1 deployment failed" 