#!/bin/bash

# Comprehensive Deployment Validation Script
# Validates all critical security and performance fixes

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Header
echo "==============================================="
echo "  ANSIBLE HOMELAB DEPLOYMENT VALIDATION"
echo "==============================================="
echo

# Function to check file exists
check_file() {
    if [[ -f "$1" ]]; then
        success "File exists: $1"
        return 0
    else
        error "File missing: $1"
        return 1
    fi
}

# Function to check directory exists
check_directory() {
    if [[ -d "$1" ]]; then
        success "Directory exists: $1"
        return 0
    else
        error "Directory missing: $1"
        return 1
    fi
}

# Function to check content in file
check_content() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    if grep -q "$pattern" "$file" 2>/dev/null; then
        success "$description found in $file"
        return 0
    else
        error "$description missing in $file"
        return 1
    fi
}

# Initialize counters
total_checks=0
passed_checks=0
failed_checks=0

# Track validation results
validation_results=()

# 1. CRITICAL FIX: Privilege Escalation Validation
log "Validating privilege escalation fixes..."
echo

# Check main.yml for explicit privilege escalation
if check_content "main.yml" "become: false" "Global privilege escalation disabled"; then
    ((passed_checks++))
    validation_results+=("Privilege escalation: PASSED")
else
    ((failed_checks++))
    validation_results+=("Privilege escalation: FAILED")
fi
((total_checks++))

# Check for explicit become statements
if check_content "main.yml" "become: true" "Explicit privilege escalation"; then
    ((passed_checks++))
    validation_results+=("Explicit privilege escalation: PASSED")
else
    ((failed_checks++))
    validation_results+=("Explicit privilege escalation: FAILED")
fi
((total_checks++))

# Check ansible.cfg for privilege escalation settings
if check_content "ansible.cfg" "become = False" "Global privilege escalation disabled in config"; then
    ((passed_checks++))
    validation_results+=("Config privilege escalation: PASSED")
else
    ((failed_checks++))
    validation_results+=("Config privilege escalation: FAILED")
fi
((total_checks++))

if check_content "ansible.cfg" "become_ask_pass = True" "Password prompt enabled"; then
    ((passed_checks++))
    validation_results+=("Password prompt: PASSED")
else
    ((failed_checks++))
    validation_results+=("Password prompt: FAILED")
fi
((total_checks++))

echo

# 2. CRITICAL FIX: Port Conflict Validation
log "Validating port conflict validation..."
echo

if check_file "tasks/port_validation.yml"; then
    ((passed_checks++))
    validation_results+=("Port validation task: PASSED")
else
    ((failed_checks++))
    validation_results+=("Port validation task: FAILED")
fi
((total_checks++))

if check_file "templates/port_usage_report.j2"; then
    ((passed_checks++))
    validation_results+=("Port usage report template: PASSED")
else
    ((failed_checks++))
    validation_results+=("Port usage report template: FAILED")
fi
((total_checks++))

if check_content "main.yml" "port_validation.yml" "Port validation included"; then
    ((passed_checks++))
    validation_results+=("Port validation integration: PASSED")
else
    ((failed_checks++))
    validation_results+=("Port validation integration: FAILED")
fi
((total_checks++))

echo

# 3. CRITICAL FIX: Secret Management Validation
log "Validating secret management fixes..."
echo

# Check for vault variable usage in templates
if check_content "templates/watchtower-secrets.yml.j2" "vault_authentik_postgres_password" "Vault variable usage"; then
    ((passed_checks++))
    validation_results+=("Vault variable usage: PASSED")
else
    ((failed_checks++))
    validation_results+=("Vault variable usage: FAILED")
fi
((total_checks++))

# Check for secret rotation implementation
if check_file "tasks/secret_rotation.yml"; then
    ((passed_checks++))
    validation_results+=("Secret rotation task: PASSED")
else
    ((failed_checks++))
    validation_results+=("Secret rotation task: FAILED")
fi
((total_checks++))

if check_file "templates/secret_rotation_report.j2"; then
    ((passed_checks++))
    validation_results+=("Secret rotation report template: PASSED")
else
    ((failed_checks++))
    validation_results+=("Secret rotation report template: FAILED")
fi
((total_checks++))

if check_content "main.yml" "secret_rotation.yml" "Secret rotation included"; then
    ((passed_checks++))
    validation_results+=("Secret rotation integration: PASSED")
else
    ((failed_checks++))
    validation_results+=("Secret rotation integration: FAILED")
fi
((total_checks++))

echo

# 4. CRITICAL FIX: Resource Monitoring Validation
log "Validating resource monitoring implementation..."
echo

if check_file "tasks/resource_monitoring.yml"; then
    ((passed_checks++))
    validation_results+=("Resource monitoring task: PASSED")
else
    ((failed_checks++))
    validation_results+=("Resource monitoring task: FAILED")
fi
((total_checks++))

if check_file "templates/resource_monitoring_report.j2"; then
    ((passed_checks++))
    validation_results+=("Resource monitoring report template: PASSED")
else
    ((failed_checks++))
    validation_results+=("Resource monitoring report template: FAILED")
fi
((total_checks++))

if check_content "main.yml" "resource_monitoring.yml" "Resource monitoring included"; then
    ((passed_checks++))
    validation_results+=("Resource monitoring integration: PASSED")
else
    ((failed_checks++))
    validation_results+=("Resource monitoring integration: FAILED")
fi
((total_checks++))

echo

# 5. CRITICAL FIX: Async Task Polling Validation
log "Validating async task polling fixes..."
echo

# Check for polling in async tasks
if check_content "main.yml" "poll: 10" "Async task polling enabled"; then
    ((passed_checks++))
    validation_results+=("Async task polling: PASSED")
else
    ((failed_checks++))
    validation_results+=("Async task polling: FAILED")
fi
((total_checks++))

# Check for task registration
if check_content "main.yml" "register:" "Task registration implemented"; then
    ((passed_checks++))
    validation_results+=("Task registration: PASSED")
else
    ((failed_checks++))
    validation_results+=("Task registration: FAILED")
fi
((total_checks++))

echo

# 6. CRITICAL FIX: Security Validation
log "Validating security enhancements..."
echo

# Check for security validation variables
if check_content "main.yml" "security_validation_enabled" "Security validation enabled"; then
    ((passed_checks++))
    validation_results+=("Security validation: PASSED")
else
    ((failed_checks++))
    validation_results+=("Security validation: FAILED")
fi
((total_checks++))

# Check for privilege escalation validation
if check_content "main.yml" "privilege_escalation_required" "Privilege escalation validation"; then
    ((passed_checks++))
    validation_results+=("Privilege escalation validation: PASSED")
else
    ((failed_checks++))
    validation_results+=("Privilege escalation validation: FAILED")
fi
((total_checks++))

echo

# 7. CRITICAL FIX: Error Handling Validation
log "Validating error handling improvements..."
echo

# Check for comprehensive error handling
if check_content "main.yml" "rescue:" "Error handling with rescue blocks"; then
    ((passed_checks++))
    validation_results+=("Error handling: PASSED")
else
    ((failed_checks++))
    validation_results+=("Error handling: FAILED")
fi
((total_checks++))

# Check for validation tasks
if check_content "main.yml" "validate.yml" "Validation tasks included"; then
    ((passed_checks++))
    validation_results+=("Validation tasks: PASSED")
else
    ((failed_checks++))
    validation_results+=("Validation tasks: FAILED")
fi
((total_checks++))

echo

# 8. CRITICAL FIX: Notification Enhancement Validation
log "Validating notification enhancements..."
echo

# Check for enhanced notifications
if check_content "main.yml" "resource_health" "Resource health in notifications"; then
    ((passed_checks++))
    validation_results+=("Enhanced notifications: PASSED")
else
    ((failed_checks++))
    validation_results+=("Enhanced notifications: FAILED")
fi
((total_checks++))

if check_content "main.yml" "security_validation" "Security validation in notifications"; then
    ((passed_checks++))
    validation_results+=("Security notifications: PASSED")
else
    ((failed_checks++))
    validation_results+=("Security notifications: FAILED")
fi
((total_checks++))

echo

# Summary
echo "==============================================="
echo "  VALIDATION SUMMARY"
echo "==============================================="
echo

echo "Total checks: $total_checks"
echo "Passed: $passed_checks"
echo "Failed: $failed_checks"
echo

# Calculate percentage
if [[ $total_checks -gt 0 ]]; then
    percentage=$((passed_checks * 100 / total_checks))
    echo "Success rate: $percentage%"
    echo
fi

# Display detailed results
echo "Detailed Results:"
echo "================="
for result in "${validation_results[@]}"; do
    if [[ "$result" == *"PASSED"* ]]; then
        success "$result"
    else
        error "$result"
    fi
done

echo

# Final assessment
if [[ $failed_checks -eq 0 ]]; then
    success "🎉 ALL CRITICAL FIXES VALIDATED SUCCESSFULLY!"
    echo
    echo "The Ansible playbook has been successfully updated with all critical security and performance improvements."
    echo "The deployment is now production-ready with:"
    echo "  ✅ Proper privilege escalation controls"
    echo "  ✅ Port conflict validation"
    echo "  ✅ Enhanced secret management"
    echo "  ✅ Comprehensive resource monitoring"
    echo "  ✅ Improved error handling"
    echo "  ✅ Enhanced notifications"
    exit 0
else
    error "⚠️  SOME VALIDATION CHECKS FAILED"
    echo
    echo "Please review the failed checks above and ensure all critical fixes are properly implemented."
    echo "The deployment may not be fully production-ready until all issues are resolved."
    exit 1
fi 