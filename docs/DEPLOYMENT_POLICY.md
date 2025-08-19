## Production Deployment Policy

This project enforces production-ready defaults:

- Least privilege: task-level `become`, container `user: PUID:PGID`, `read_only`, `cap_drop: [ALL]`, `security_opt: no-new-privileges:true` with documented exceptions.
- Secrets: All secrets stored in Ansible Vault and injected via mounted secret files; no secrets in repository or plaintext configs.
- Networking: Datastores (DB/Redis) are not exposed on host ports; services communicate over private Docker networks; public access via Traefik only.
- TLS: Verification enforced; self-signed allowed only via explicit allowlist.
- Firewall: Managed via `community.general.ufw` with centralized variables.
- Resource limits: Compose uses `mem_limit` and `cpus`. Kubernetes overlay recommended for requests/limits and probes.
- Observability: json-file log rotation (10m/3) and promtail->Loki forwarding; healthchecks standardized.
- CI/CD: Lint and config checks on every PR/commit.
- Rollback: Per-role pre-change snapshots and rescue steps to reapply last-known-good compose.


