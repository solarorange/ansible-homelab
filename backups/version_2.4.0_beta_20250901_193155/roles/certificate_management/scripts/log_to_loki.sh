#!/bin/bash

# Script to forward certificate logs to Loki
# This script formats and sends certificate logs to the Loki logging service

set -e

# Configuration
LOKI_URL="http://loki:3100"
CERT_DIR="/etc/traefik/certs"
LOG_DIR="{{ docker_dir }}/certificate_management/logs"
REPORT_DIR="{{ docker_dir }}/certificate_management/reports"

# Function to send logs to Loki
send_to_loki() {
    local log_type=$1
    local message=$2
    local level=${3:-"info"}
    local labels=$4
    
    # Create Loki log entry
    local timestamp=$(date +%s%N)
    local log_entry=$(cat <<EOF
{
  "streams": [
    {
      "stream": {
        "job": "certificate_management",
        "type": "$log_type",
        "level": "$level",
        $labels
      },
      "values": [
        ["$timestamp", "$message"]
      ]
    }
  ]
}
EOF
)
    
    # Send to Loki
    curl -s -X POST -H "Content-Type: application/json" \
        -d "$log_entry" "$LOKI_URL/loki/api/v1/push" > /dev/null
}

# Function to process certificate logs
process_cert_logs() {
    local log_file=$1
    local log_type=$2
    
    if [ -f "$log_file" ]; then
        while IFS= read -r line; do
            # Extract timestamp and message
            timestamp=$(echo "$line" | cut -d' ' -f1,2)
            message=$(echo "$line" | cut -d' ' -f4-)
            
            # Determine log level
            level="info"
            if [[ "$message" == *"ERROR"* ]]; then
                level="error"
            elif [[ "$message" == *"WARNING"* ]]; then
                level="warning"
            fi
            
            # Create labels
            labels="\"domain\": \"$(echo "$message" | grep -o 'Domain: [^ ]*' | cut -d' ' -f2)\","
            labels+="\"days_remaining\": \"$(echo "$message" | grep -o 'Days until expiration: [0-9]*' | cut -d' ' -f5)\""
            
            # Send to Loki
            send_to_loki "$log_type" "$message" "$level" "$labels"
        done < "$log_file"
    fi
}

# Function to process certificate reports
process_cert_reports() {
    local report_file=$1
    
    if [ -f "$report_file" ]; then
        # Extract certificate information
        while IFS= read -r domain; do
            expiry_date=$(jq -r ".Certificates[] | select(.Domain.Main == \"$domain\") | .Certificate.NotAfter" /etc/traefik/acme.json)
            days_remaining=$(jq -r ".monitoring.expiring_soon[] | select(.domain == \"$domain\") | .days_remaining" "$report_file")
            
            # Create log message
            message="Certificate status for $domain - Expires: $expiry_date, Days remaining: $days_remaining"
            
            # Create labels
            labels="\"domain\": \"$domain\","
            labels+="\"days_remaining\": \"$days_remaining\""
            
            # Send to Loki
            send_to_loki "certificate_report" "$message" "info" "$labels"
        done < <(jq -r '.Certificates[].Domain.Main' /etc/traefik/acme.json)
    fi
}

# Main process
main() {
    # Process automation logs
    process_cert_logs "$LOG_DIR/automation.log" "automation"
    
    # Process monitoring logs
    process_cert_logs "$LOG_DIR/cert_monitor.log" "monitoring"
    
    # Process notification logs
    process_cert_logs "$LOG_DIR/notifications.log" "notifications"
    
    # Process latest report
    latest_report=$(ls -t "$REPORT_DIR"/cert_report_*.json 2>/dev/null | head -n1)
    if [ -n "$latest_report" ]; then
        process_cert_reports "$latest_report"
    fi
}

# Run main process
main 