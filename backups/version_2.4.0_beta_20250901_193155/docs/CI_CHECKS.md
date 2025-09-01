### CI checks for secrets and compose deploy resources

This repository includes CI guardrails to prevent regressions around file-based secrets and unsupported Compose fields.

- **Secrets enforcement**: `scripts/ci/check_env_secret_files.sh`
  - Fails if any template sets environment keys matching `PASSWORD|SECRET|TOKEN|API` without using the `*_FILE` indirection.
  - Scope: `templates/**/*.j2`, `roles/**/templates/*.j2`.
  - Guidance: use `KEY_FILE=/run/secrets/KEY` and mount the secret file. See `docs/SECRETS_CONVENTIONS.md`.

- **Compose deploy resources ban**: `scripts/ci/check_compose_deploy_resources.sh`
  - Fails if a template contains `deploy:` with `resources:` (Swarm-only) which is ignored by Docker Compose v2.
  - Scope: `templates/**/*.j2`, `roles/**/templates/*.j2`.
  - Guidance: avoid `deploy.resources`; document desired limits in defaults or enforce via host-level limits.

Run locally:

```bash
bash scripts/ci/check_env_secret_files.sh
bash scripts/ci/check_compose_deploy_resources.sh
```

Integrate in CI:

```yaml
# example GitHub Actions step
- name: Secrets and Compose checks
  run: |
    bash scripts/ci/check_env_secret_files.sh
    bash scripts/ci/check_compose_deploy_resources.sh
```


