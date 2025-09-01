## Secrets conventions

This stack avoids plaintext secrets in generated configs. Use environment variable indirection with the *_FILE pattern and mount secret files under /run/secrets.

- General rules
  - Never embed values like passwords, tokens, secrets, or private keys in templates or copy content.
  - For any env key matching (PASSWORD|TOKEN|SECRET|KEY), set KEY_FILE=/run/secrets/KEY and mount a file with that exact name.
  - Services should read secrets at runtime from /run/secrets, not from the rendered files.

- Shared automation
  - The shared tasks at roles/automation/tasks/secrets.yml can write secret files with mode 0600 into <service>/secrets/.
  - Use <role>_manage_secret_files and <role>_required_secrets to opt-in and validate presence.

- Standard filenames (examples)
  - Grafana: GF_SECURITY_ADMIN_PASSWORD, GF_DATABASE_PASSWORD, GF_SMTP_PASSWORD
  - MariaDB: mariadb_root_password → env MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb_root_password
  - Redis: redis_password → set REDIS_PASSWORD_FILE=/run/secrets/redis_password
  - Fing: FING_DB_PASSWORD, FING_ADMIN_PASSWORD, FING_API_KEY, FING_SMTP_PASSWORD
  - Authentik: AUTHENTIK_SECRET_KEY, POSTGRES_PASSWORD
  - Wireguard: WG_PRIVATE_KEY (read in entrypoint, not embedded in config)

- Compose patterns
  - environment:
    - KEY_FILE=/run/secrets/KEY
  - volumes:
    - <service>/secrets/KEY:/run/secrets/KEY:ro

- Optional extended configs
  - Use per-role flags like <role>_custom_config_enabled: false to gate any extended config rendering. These files must remain secrets-free.

- Validation
  - Prefer runtime validation via health checks. For templates that render env files, ensure secret-like keys render with KEY_FILE and never with the raw value.


