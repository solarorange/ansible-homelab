### Post-deploy smoke tests

After a successful playbook run, perform quick smoke tests to verify ingress and service health.

- **Route-based health checks** (preferred)
  - Use the shared task `roles/automation/tasks/route_health_check.yml` which calls `ansible.builtin.uri` against HTTPS routes.
  - Typical usage from a role deploy: include with variables
    - `route_health_check_url`: e.g., `https://<subdomain>.<domain>/api/health`
    - `route_health_check_status_codes`: acceptable codes, defaults `[200, 302, 401]`
    - `route_health_check_timeout`, `route_health_check_retries`, `route_health_check_delay`

- **Direct port checks** (when direct expose enabled)
  - Use `ansible.builtin.uri` to `http://<host_ip>:<port>/health` where available.

- **Manual curl verification**
  ```bash
  curl -i https://<service>.<your-domain>/api/health || true
  ```

Recommended: roles should include a final route health check step similar to Grafana and Immich roles to ensure ingress works post-deploy.


