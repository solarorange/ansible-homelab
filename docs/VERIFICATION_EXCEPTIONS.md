## Verification Exceptions

This document records justified, temporary exceptions discovered during the final standards sweep. Each entry lists the rule, the file(s), and the rationale. All exceptions should be revisited and removed where feasible.

### 1) Secret-like environment variables without *_FILE

- Files:
  - `tasks/watchtower.yml` (some images still require direct envs: e.g., InfluxDB init vars; others migrated to file-based secrets where supported)

- Rationale:
  - Elasticsearch/Kibana inconsistencies addressed (normalized env names). Keystore migration remains a future enhancement.
  - The `watchtower` stack now uses file-based secrets for Grafana admin password/secret key and Authentik Postgres password. InfluxDB v2 init remains via env due to image constraints.

### 2) Presence of `deploy: resources` in Compose content

- Files:
  - `tasks/watchtower.yml`
  - `tasks/media_stack.yml`
  - `roles/automation/container_management/tasks/main.yml`
  - `homepage/config/docker.yml`

- Rationale:
  - These sections are retained for readability and guidance. Docker Compose (non‑Swarm) ignores `deploy.resources`. Where limits are needed, equivalent `mem_limit`/`cpus` are used in templates; remaining usages will be replaced in a future refactor.

### 3) Unconditional `ports:` in templates

- Files:
  - `templates/enhanced-docker-compose.yml.j2`
  - `templates/overseerr/docker-compose.yml.j2`
  - `templates/media/sonarr-docker-compose.yml.j2`
  - `templates/pihole/docker-compose.yml.j2` (required)
  - `templates/pulsarr/docker-compose.yml.j2`
  - `templates/bazarr/docker-compose.yml.j2`
  - `templates/tautulli/docker-compose.yml.j2`

- Rationale:
  - `pihole` requires host port exposure (DNS/DHCP) by design.
  - Media templates expose service ports for out‑of‑the‑box connectivity. Traefik labels are present; a future change will gate host mappings behind a toggle (e.g., `enable_host_ports`), defaulting to disabled.

### 4) Plaintext secrets in task‑generated content

- Files:
  - `tasks/alertmanager.yml` (SMTP password inside rendered `alertmanager.yml`)
  - `tasks/sabnzbd.yml` (inline config writes `password = {{ sabnzbd_password }}` and `api_key = {{ sabnzbd_api_key }}`)

- Rationale:
  - MariaDB/Nextcloud scripts now read from Docker secrets, eliminating plaintext usage in scripts.
  - Alertmanager requires credentials in its configuration file; the file is written with strict permissions. Alternative secret managers are under evaluation.
  - SABnzbd requires credentials in its app config; file is generated with controlled permissions. We will prefer templating from `/run/secrets` and/or app‑native secret handling where available.


