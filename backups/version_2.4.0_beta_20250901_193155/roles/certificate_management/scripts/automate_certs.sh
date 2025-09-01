#!/bin/bash

# Automated Certificate Management Script
# This script handles certificate monitoring, renewal, and reporting

set -e

# Configuration
CERT_DIR="/etc/traefik/certs"
LOG_DIR="{{ docker_dir }}/certificate_management/logs"
REPORT_DIR="{{ docker_dir }}/certificate_management/reports"
NOTIFICATION_SCRIPT="{{ docker_dir }}/certificate_management/scripts/send_notification.sh"
MONITOR_SCRIPT="{{ docker_dir }}/certificate_management/scripts/monitor_certs.sh"
ROTATION_SCRIPT="{{ docker_dir }}/certificate_management/scripts/rotate_certs.sh"

# Create required directories
mkdir -p "$LOG_DIR" "$REPORT_DIR"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_DIR/automation.log"
}

# Function to generate certificate report
generate_report() {
    local report_file="$REPORT_DIR/cert_report_$(date +%Y%m%d).json"
    
    # Get certificate information
    docker exec traefik traefik cert info > "$report_file"
    
    # Add monitoring data
    {
        echo ","
        echo "\"monitoring\": {"
        echo "  \"last_check\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\","
        echo "  \"expiring_soon\": ["
        
        # Check for certificates expiring soon
        while IFS= read -r domain; do
            expiry_date=$(jq -r ".Certificates[] | select(.Domain.Main == \"$domain\") | .Certificate.NotAfter" /etc/traefik/acme.json)
            expiry_seconds=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$expiry_date" "+%s")
            current_seconds=$(date "+%s")
            days_remaining=$(( (expiry_seconds - current_seconds) / 86400 ))
            
            if [ $days_remaining -le 30 ]; then
                echo "    {"
                echo "      \"domain\": \"$domain\","
                echo "      \"days_remaining\": $days_remaining"
                echo "    },"
            fi
        done < <(jq -r '.Certificates[].Domain.Main' /etc/traefik/acme.json)
        
        echo "  ]"
        echo "}"
    } >> "$report_file"
    
    log "Generated certificate report: $report_file"
}

# Function to check certificate health
check_cert_health() {
    local health_status=0
    
    # Check OCSP stapling
    if ! openssl s_client -connect traefik.{{ domain }}:443 -status > /dev/null 2>&1; then
        log "WARNING: OCSP stapling check failed"
        health_status=1
    fi
    
    # Check certificate chain
    if ! openssl verify -CAfile "$CERT_DIR/ca.crt" "$CERT_DIR/traefik.crt" > /dev/null 2>&1; then
        log "ERROR: Certificate chain validation failed"
        health_status=1
    fi
    
    # Check mTLS configuration
    if ! curl -s --cert "$CERT_DIR/traefik.crt" --key "$CERT_DIR/traefik.key" \
        --cacert "$CERT_DIR/ca.crt" https://traefik.{{ domain }}:443 > /dev/null 2>&1; then
        log "ERROR: mTLS validation failed"
        health_status=1
    fi
    
    return $health_status
}

# Function to handle certificate renewal
handle_renewal() {
    local domain=$1
    local days_remaining=$2
    
    if [ $days_remaining -le 30 ]; then
        log "Initiating renewal for $domain (expires in $days_remaining days)"
        
        # Backup current certificates
        cp /etc/traefik/acme.json /etc/traefik/acme.json.bak
        
        # Trigger renewal
        if docker exec traefik traefik cert renew --domain "$domain"; then
            log "Successfully renewed certificate for $domain"
            "$NOTIFICATION_SCRIPT" "Certificate Renewed" "Successfully renewed certificate for $domain"
            
            # Update certificate pins if needed
            update_cert_pins
            
            # Verify the new certificate
            if check_cert_health; then
                log "New certificate verified successfully"
            else
                log "ERROR: New certificate verification failed, rolling back"
                cp /etc/traefik/acme.json.bak /etc/traefik/acme.json
                docker restart traefik
                "$NOTIFICATION_SCRIPT" "Certificate Renewal Failed" "Failed to verify new certificate for $domain, rolled back to previous version"
            fi
        else
            log "ERROR: Failed to renew certificate for $domain"
            "$NOTIFICATION_SCRIPT" "Certificate Renewal Failed" "Failed to renew certificate for $domain"
        fi
    fi
}

# Function to update certificate pins
update_cert_pins() {
    local new_pin=$(openssl x509 -in /etc/traefik/acme.json -pubkey -noout | \
        openssl pkey -pubin -outform der | \
        openssl dgst -sha256 -binary | \
        openssl enc -base64)
    
    # Update pinning configuration
    sed -i "s/pin-sha256=\"[^\"]*\"/pin-sha256=\"$new_pin\"/" \
        "{{ docker_dir }}/certificate_management/config/pinning.yml"
    
    log "Updated certificate pins"
}

# Main automation process
main() {
    log "Starting certificate automation process"
    
    # Generate daily report
    generate_report
    
    # Check certificate health
    if ! check_cert_health; then
        log "WARNING: Certificate health check failed"
        "$NOTIFICATION_SCRIPT" "Certificate Health Warning" "Certificate health check failed, check logs for details"
    fi
    
    # Monitor and handle renewals
    while IFS= read -r domain; do
        expiry_date=$(jq -r ".Certificates[] | select(.Domain.Main == \"$domain\") | .Certificate.NotAfter" /etc/traefik/acme.json)
        expiry_seconds=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$expiry_date" "+%s")
        current_seconds=$(date "+%s")
        days_remaining=$(( (expiry_seconds - current_seconds) / 86400 ))
        
        handle_renewal "$domain" "$days_remaining"
    done < <(jq -r '.Certificates[].Domain.Main' /etc/traefik/acme.json)
    
    # Clean up old reports (keep last 30 days)
    find "$REPORT_DIR" -name "cert_report_*.json" -mtime +30 -delete
    
    log "Completed certificate automation process"
}

# Run main process
main 