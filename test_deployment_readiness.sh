#!/bin/bash
# Deployment Readiness Test Script
# Validates all critical components for real-world deployment

set -euo pipefail
IFS=$'\n\t'

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script configuration
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Resolve repository root - try git first, fall back to script directory parent
if command -v git >/dev/null 2>&1 && git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT="$(git rev-parse --show-toplevel)"
else
    # Fall back to parent directory of script directory if git not available
    REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)"
fi

LOG_FILE="${REPO_ROOT}/deployment_readiness_test.log"

# Test results tracking
declare -i TESTS_PASSED=0
declare -i TESTS_FAILED=0
declare -i TESTS_TOTAL=0

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [${level}] ${message}" | tee -a "${LOG_FILE}"
}

# Print header
print_header() {
    echo -e "${CYAN}"
    echo "================================================"
    echo "  🚀 DEPLOYMENT READINESS TEST"
    echo "  📋 Validating Real-World Deployment Capabilities"
    echo "  🔍 Comprehensive Component Testing"
    echo "================================================"
    echo -e "${NC}"
}

# Test result function
test_result() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    ((TESTS_TOTAL++))
    
    case "${status}" in
        "PASS")
            echo -e "${GREEN}✓ PASS${NC} $test_name: $message"
            ((TESTS_PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}✗ FAIL${NC} $test_name: $message"
            ((TESTS_FAILED++))
            ;;
        "WARN")
            echo -e "${YELLOW}⚠ WARN${NC} $test_name: $message"
            ;;
        *)
            echo -e "${BLUE}ℹ INFO${NC} $test_name: $message"
            ;;
    esac
}

# Test 1: Ansible Playbook Syntax
test_ansible_syntax() {
    echo -e "\n${BLUE}=== Testing Ansible Playbook Syntax ===${NC}"
    
    if command -v ansible-playbook >/dev/null 2>&1; then
        if [[ -f "main.yml" ]]; then
            if ansible-playbook --syntax-check main.yml >/dev/null 2>&1; then
                test_result "Ansible Syntax" "PASS" "Main playbook syntax is valid"
            else
                test_result "Ansible Syntax" "FAIL" "Main playbook has syntax errors"
            fi
        else
            test_result "Ansible Syntax" "FAIL" "main.yml not found"
        fi
    else
        test_result "Ansible Syntax" "FAIL" "ansible-playbook command not found"
    fi
}

# Test 2: Inventory Configuration
test_inventory_config() {
    echo -e "\n${BLUE}=== Testing Inventory Configuration ===${NC}"
    
    if [[ -f "inventory.ini" ]]; then
        if grep -q "ansible_host=" inventory.ini; then
            test_result "Inventory Config" "PASS" "Inventory file properly configured"
        else
            test_result "Inventory Config" "FAIL" "Inventory missing ansible_host configuration"
        fi
    else
        test_result "Inventory Config" "FAIL" "inventory.ini file not found"
    fi
    
    if [[ -f "group_vars/all/common.yml" ]]; then
        if grep -q "domain:" group_vars/all/common.yml; then
            test_result "Group Vars" "PASS" "Common variables properly configured"
        else
            test_result "Group Vars" "FAIL" "Common variables missing domain configuration"
        fi
    else
        test_result "Group Vars" "FAIL" "Common variables file not found"
    fi
}

# Test 3: Vault Configuration
test_vault_config() {
    echo -e "\n${BLUE}=== Testing Vault Configuration ===${NC}"
    
    if [[ -f ".vault_password" ]]; then
        test_result "Vault Password" "PASS" "Vault password file exists"
        
        if [[ -f "group_vars/all/vault.yml" ]]; then
            if ansible-vault view group_vars/all/vault.yml --vault-password-file .vault_password >/dev/null 2>&1; then
                test_result "Vault Access" "PASS" "Vault file accessible with password"
            else
                test_result "Vault Access" "FAIL" "Cannot access vault file with password"
            fi
        else
            test_result "Vault Access" "FAIL" "Vault file not found"
        fi
    else
        test_result "Vault Password" "FAIL" "Vault password file not found"
    fi
}

# Test 4: Python Dependencies
test_python_deps() {
    echo -e "\n${BLUE}=== Testing Python Dependencies ===${NC}"
    
    # Test Jinja2
    if python3 -c "import jinja2; print('Jinja2:', jinja2.__version__)" >/dev/null 2>&1; then
        test_result "Jinja2" "PASS" "Jinja2 template engine available"
    else
        test_result "Jinja2" "FAIL" "Jinja2 not available"
    fi
    
    # Test PyYAML
    if python3 -c "import yaml; print('PyYAML:', yaml.__version__)" >/dev/null 2>&1; then
        test_result "PyYAML" "PASS" "PyYAML available for configuration"
    else
        test_result "PyYAML" "FAIL" "PyYAML not available"
    fi
    
    # Test Service Wizard
    if python3 -c "import importlib; importlib.import_module('scripts.service_wizard'); print('Service Wizard: OK')" >/dev/null 2>&1; then
        test_result "Service Wizard" "PASS" "Service wizard module loads successfully"
    else
        test_result "Service Wizard" "FAIL" "Service wizard module has import errors"
    fi
}

# Test 5: Shell Script Validation
test_shell_scripts() {
    echo -e "\n${BLUE}=== Testing Shell Scripts ===${NC}"
    
    if [[ -f "scripts/seamless_setup.sh" ]]; then
        if bash -n scripts/seamless_setup.sh >/dev/null 2>&1; then
            test_result "Seamless Setup" "PASS" "Seamless setup script syntax valid"
        else
            test_result "Seamless Setup" "FAIL" "Seamless setup script has syntax errors"
        fi
    else
        test_result "Seamless Setup" "FAIL" "Seamless setup script not found"
    fi
    
    if [[ -f "scripts/coderabbit_validation.sh" ]]; then
        if bash -n scripts/coderabbit_validation.sh >/dev/null 2>&1; then
            test_result "Validation Script" "PASS" "Validation script syntax valid"
        else
            test_result "Validation Script" "FAIL" "Validation script has syntax errors"
        fi
    else
        test_result "Validation Script" "FAIL" "Validation script not found"
    fi
}

# Test 6: Template Validation
test_templates() {
    echo -e "\n${BLUE}=== Testing Jinja Templates ===${NC}"
    
    local template_count=0
    local valid_templates=0
    
    while IFS= read -r -d '' template; do
        ((template_count++))
        if python3 -c "import jinja2; jinja2.Template(open('$template').read())" >/dev/null 2>&1; then
            ((valid_templates++))
        fi
    done < <(find . -name "*.j2" -type f -print0 2>/dev/null | grep -z -v backups | grep -z -v logs)
    
    if [[ $template_count -gt 0 ]]; then
        local success_rate=$(( (valid_templates * 100) / template_count ))
        if [[ $success_rate -ge 95 ]]; then
            test_result "Jinja Templates" "PASS" "${valid_templates}/${template_count} templates valid (${success_rate}%)"
        elif [[ $success_rate -ge 80 ]]; then
            test_result "Jinja Templates" "WARN" "${valid_templates}/${template_count} templates valid (${success_rate}%)"
        else
            test_result "Jinja Templates" "FAIL" "${valid_templates}/${template_count} templates valid (${success_rate}%)"
        fi
    else
        test_result "Jinja Templates" "WARN" "No Jinja templates found"
    fi
}

# Test 7: Service Configuration
test_service_config() {
    echo -e "\n${BLUE}=== Testing Service Configuration ===${NC}"
    
    # Check if key services are configured
    local services=("traefik" "docker" "monitoring" "backup")
    local configured_services=0
    
    for service in "${services[@]}"; do
        if grep -q "${service}" group_vars/all/common.yml 2>/dev/null; then
            ((configured_services++))
        fi
    done
    
    local service_rate=$(( (configured_services * 100) / ${#services[@]} ))
    if [[ $service_rate -ge 75 ]]; then
        test_result "Service Config" "PASS" "${configured_services}/${#services[@]} core services configured (${service_rate}%)"
    else
        test_result "Service Config" "FAIL" "${configured_services}/${#services[@]} core services configured (${service_rate}%)"
    fi
}

# Test 8: Network Configuration
test_network_config() {
    echo -e "\n${BLUE}=== Testing Network Configuration ===${NC}"
    
    if grep -q "domain:" group_vars/all/common.yml 2>/dev/null; then
        local domain=$(grep "domain:" group_vars/all/common.yml | head -1 | awk '{print $2}' | tr -d '"')
        if [[ -n "$domain" && "$domain" != "example.com" ]]; then
            test_result "Domain Config" "PASS" "Domain configured: $domain"
        else
            test_result "Domain Config" "FAIL" "Domain not properly configured"
        fi
    else
        test_result "Domain Config" "FAIL" "Domain configuration missing"
    fi
    
    if grep -q "cloudflare_enabled: true" group_vars/all/common.yml 2>/dev/null; then
        test_result "Cloudflare Config" "PASS" "Cloudflare DNS automation enabled"
    else
        test_result "Cloudflare Config" "WARN" "Cloudflare DNS automation not enabled"
    fi
}

# Test 9: Security Configuration
test_security_config() {
    echo -e "\n${BLUE}=== Testing Security Configuration ===${NC}"
    
    if grep -q "security_enabled: true" group_vars/all/common.yml 2>/dev/null; then
        test_result "Security Features" "PASS" "Security features enabled"
    else
        test_result "Security Features" "WARN" "Security features not explicitly enabled"
    fi
    
    if grep -q "fail2ban_enabled: true" group_vars/all/common.yml 2>/dev/null; then
        test_result "Fail2Ban" "PASS" "Fail2Ban protection enabled"
    else
        test_result "Fail2Ban" "WARN" "Fail2Ban protection not enabled"
    fi
}

# Test 10: Backup Configuration
test_backup_config() {
    echo -e "\n${BLUE}=== Testing Backup Configuration ===${NC}"
    
    if grep -q "backup_dir:" group_vars/all/common.yml 2>/dev/null; then
        test_result "Backup Directory" "PASS" "Backup directory configured"
    else
        test_result "Backup Directory" "FAIL" "Backup directory not configured"
    fi
    
    if grep -q "backup_retention_days:" group_vars/all/common.yml 2>/dev/null; then
        test_result "Backup Retention" "PASS" "Backup retention policy configured"
    else
        test_result "Backup Retention" "WARN" "Backup retention policy not configured"
    fi
}

# Generate summary report
generate_summary() {
    echo -e "\n${CYAN}================================================"
    echo "  📊 DEPLOYMENT READINESS SUMMARY"
    echo "================================================"
    echo -e "${NC}"
    
    local success_rate=0
    if [[ $TESTS_TOTAL -gt 0 ]]; then
        success_rate=$(( (TESTS_PASSED * 100) / TESTS_TOTAL ))
    fi
    
    echo -e "Total Tests: ${TESTS_TOTAL}"
    echo -e "Tests Passed: ${GREEN}${TESTS_PASSED}${NC}"
    echo -e "Tests Failed: ${RED}${TESTS_FAILED}${NC}"
    echo -e "Success Rate: ${BLUE}${success_rate}%${NC}"
    
    echo -e "\n${CYAN}=== DEPLOYMENT READINESS ASSESSMENT ===${NC}"
    
    if [[ $success_rate -ge 95 ]]; then
        echo -e "${GREEN}🎉 EXCELLENT - Ready for production deployment!${NC}"
        echo -e "All critical components are properly configured and validated."
    elif [[ $success_rate -ge 85 ]]; then
        echo -e "${GREEN}✅ GOOD - Ready for deployment with minor issues${NC}"
        echo -e "Most critical components are ready. Review warnings before deployment."
    elif [[ $success_rate -ge 70 ]]; then
        echo -e "${YELLOW}⚠️  FAIR - Deployment possible with fixes${NC}"
        echo -e "Several issues need resolution before deployment."
    else
        echo -e "${RED}❌ POOR - Not ready for deployment${NC}"
        echo -e "Multiple critical issues must be resolved before deployment."
    fi
    
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "\n${RED}=== CRITICAL ISSUES TO RESOLVE ===${NC}"
        echo -e "Review and fix all FAILED tests before deployment."
    fi
    
    if [[ $success_rate -ge 85 ]]; then
        echo -e "\n${GREEN}=== NEXT STEPS ===${NC}"
        echo -e "1. Review any WARNINGS for potential improvements"
        echo -e "2. Test deployment in staging environment"
        echo -e "3. Execute: ./scripts/seamless_setup.sh"
        echo -e "4. Monitor deployment logs and metrics"
    fi
}

# Main execution
main() {
    print_header
    
    # Create log file
    touch "${LOG_FILE}"
    log "INFO" "Starting deployment readiness test"
    
    # Run all tests
    test_ansible_syntax
    test_inventory_config
    test_vault_config
    test_python_deps
    test_shell_scripts
    test_templates
    test_service_config
    test_network_config
    test_security_config
    test_backup_config
    
    # Generate summary
    generate_summary
    
    log "INFO" "Deployment readiness test completed"
    
    # Exit with appropriate code
    if [[ $TESTS_FAILED -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# Execute main function
main "$@"
