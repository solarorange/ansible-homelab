---
# Turnkey Firewall Enforcement & Public Ports Validation

## What it is
A single-file, safe, idempotent playbook that enforces centralized UFW rules and validates that only approved public ports are exposed.

## What it does
- Applies centralized firewall configuration (honors `from`/`src` in `group_vars/all/firewall.yml`)
- Validates that only 80/tcp and 443/tcp (Traefik) are publicly open by default
- Allows environment-specific exceptions for non-HTTP ports when explicitly approved
- Fails fast if unexpected public exposure is detected

## Why it exists
- Guardrail against drift from manual/third-party changes without re-running the full seamless setup
- Lightweight and non-disruptive; preserves running services
- Easy to run post-deploy, in CI/CD, or on a schedule

## File
- `tasks/turnkey_firewall_enforce_validate.yml`

## Usage
```bash
ansible-playbook -b /Users/rob/Cursor/ansible_homelab/tasks/turnkey_firewall_enforce_validate.yml | cat
```

## Approving additional public ports (optional)
If you need to expose additional non-HTTP ports (e.g., WireGuard 51820/udp), set one of the following in your inventory/group vars:

```yaml
firewall_approved_public_ports_extra:
  - '51820/udp'
```

You can also override the full approved list if necessary:
```yaml
firewall_approved_public_ports:
  - '80/tcp'
  - '443/tcp'
  - '51820/udp'
```

## Notes
- The centralized firewall config lives in `group_vars/all/firewall.yml`.
- The enforcement task supports both `from:` and `src:` for LAN-restricted rules.
- Validation is IPv4/IPv6 aware and normalizes ports to `port/proto` format (default proto tcp).


