# Ansible Homelab Testing Framework

This testing framework provides comprehensive validation and testing for the Ansible Homelab deployment. It includes pre-flight checks, post-deployment health checks, service validation, and automated testing capabilities.

## Directory Structure

```
tests/
├── preflight/              # Pre-deployment validation tests
│   └── validate_prerequisites.yml
├── post_deployment/        # Post-deployment health checks
│   └── health_checks.yml
├── service_validation/     # Service-specific validation tests
│   └── service_tests.yml
├── automated/             # Automated test runner
│   └── test_runner.yml
└── test_results/         # Generated test results (created during execution)
```

## Test Components

### 1. Pre-flight Validation
- System requirements check (memory, disk space, CPU architecture)
- Network connectivity validation
- Required variables verification
- System services validation

### 2. Post-deployment Health Checks
- Docker container health verification
- Service endpoint accessibility
- Monitoring stack validation
- System resource usage monitoring

### 3. Service Validation
- Traefik configuration validation
- Monitoring stack functionality
- Media services API checks
- Backup service verification
- Security services validation

### 4. Automated Testing
- Orchestrates all test components
- Generates detailed test reports
- Provides test execution summary

## Usage

### Running All Tests
```bash
ansible-playbook tests/automated/test_runner.yml
```

### Running Individual Test Components
```bash
# Pre-flight validation
ansible-playbook tests/preflight/validate_prerequisites.yml

# Post-deployment health checks
ansible-playbook tests/post_deployment/health_checks.yml

# Service validation
ansible-playbook tests/service_validation/service_tests.yml
```

### Test Results
Test results are stored in the `test_results` directory with timestamps. Each test run generates:
- Pre-flight validation results
- Health check results
- Service test results
- Overall test summary

## Adding New Tests

1. Create a new test file in the appropriate directory
2. Follow the existing test structure
3. Use Ansible's built-in modules for assertions and validations
4. Add appropriate error handling and reporting

## Best Practices

1. Always include proper error messages in assertions
2. Use conditional execution based on enabled services
3. Implement proper error handling and reporting
4. Keep tests idempotent
5. Document any new test requirements

## Troubleshooting

If tests fail:
1. Check the detailed test results in the `test_results` directory
2. Verify all required variables are set
3. Ensure all required services are running
4. Check system resource availability
5. Verify network connectivity

## Contributing

When adding new tests:
1. Follow the existing test structure
2. Include proper documentation
3. Add appropriate error handling
4. Update this README if necessary 