# Security Audit Report
Generated: Tue Aug 12 13:30:08 EDT 2025

## Executive Summary
This report contains the results of a comprehensive security audit of the Ansible homelab deployment.

## Audit Results

### 1. Hardcoded Passwords
[0;32m✓[0m No hardcoded passwords found

### 2. Insecure Password Generation
[0;31m✗[0m Insecure password generation found with pattern: lookup.*password.*chars=ascii_letters,digits
[0;31m✗[0m Insecure password generation found with pattern: lookup.*password.*length=
[0;31m✗[0m Insecure password generation found with pattern: lookup.*password.*/dev/null

### 3. Non-Vault Variables
[0;31m✗[0m Non-vault variable found: {{ grafana_admin_password }}
[0;31m✗[0m Non-vault variable found: {{ nextcloud_admin_password }}
[0;31m✗[0m Non-vault variable found: {{ nextcloud_db_password }}
[0;31m✗[0m Non-vault variable found: {{ nextcloud_db_root_password }}
[0;31m✗[0m Non-vault variable found: {{ calibre_web_password }}
[0;31m✗[0m Non-vault variable found: {{ jellyfin_password }}
[0;31m✗[0m Non-vault variable found: {{ sabnzbd_password }}
[0;31m✗[0m Non-vault variable found: {{ audiobookshelf_password }}
[0;31m✗[0m Non-vault variable found: {{ postgres_password }}
[0;31m✗[0m Non-vault variable found: {{ redis_password }}
[0;31m✗[0m Non-vault variable found: {{ mariadb_root_password }}
[0;31m✗[0m Non-vault variable found: {{ fing_admin_password }}
[0;31m✗[0m Non-vault variable found: {{ pihole_admin_password }}

### 4. Missing Vault Variables
[0;31m✗[0m Missing vault variable: vault_mariadb_root_password
[0;31m✗[0m Missing vault variable: vault_ersatztv_api_key
[0;31m✗[0m Missing vault variable: vault_tautulli_api_key
[0;31m✗[0m Missing vault variable: vault_overseerr_api_key
[0;31m✗[0m Missing vault variable: vault_jellyfin_api_key
[0;31m✗[0m Missing vault variable: vault_emby_api_key
[0;31m✗[0m Missing vault variable: vault_homeassistant_admin_password
[0;31m✗[0m Missing vault variable: vault_mosquitto_admin_password
[0;31m✗[0m Missing vault variable: vault_zigbee2mqtt_mqtt_password
[0;31m✗[0m Missing vault variable: vault_nextcloud_db_password
[0;31m✗[0m Missing vault variable: vault_nextcloud_db_root_password
[0;31m✗[0m Missing vault variable: vault_syncthing_gui_password
[0;31m✗[0m Missing vault variable: vault_syncthing_apikey
[0;31m✗[0m Missing vault variable: vault_traefik_basic_auth_hash
[0;31m✗[0m Missing vault variable: vault_telegram_bot_token
[0;31m✗[0m Missing vault variable: vault_telegram_chat_id
[0;31m✗[0m Missing vault variable: vault_homepage_api_key
[0;31m✗[0m Missing vault variable: vault_traefik_api_key
[0;31m✗[0m Missing vault variable: vault_authentik_api_key
[0;31m✗[0m Missing vault variable: vault_portainer_api_key
[0;31m✗[0m Missing vault variable: vault_grafana_api_key
[0;31m✗[0m Missing vault variable: vault_paperless_api_key
[0;31m✗[0m Missing vault variable: vault_bookstack_api_key
[0;31m✗[0m Missing vault variable: vault_immich_api_key
[0;31m✗[0m Missing vault variable: vault_filebrowser_api_key
[0;31m✗[0m Missing vault variable: vault_minio_api_key
[0;31m✗[0m Missing vault variable: vault_kopia_api_key
[0;31m✗[0m Missing vault variable: vault_duplicati_api_key
[0;31m✗[0m Missing vault variable: vault_uptimekuma_api_key
[0;31m✗[0m Missing vault variable: vault_gitlab_api_key
[0;31m✗[0m Missing vault variable: vault_harbor_api_key
[0;31m✗[0m Missing vault variable: vault_guacamole_api_key
[0;31m✗[0m Missing vault variable: vault_homeassistant_api_key
[0;31m✗[0m Missing vault variable: vault_crowdsec_api_key
[0;31m✗[0m Missing vault variable: vault_fail2ban_api_key
[0;31m✗[0m Missing vault variable: vault_gitlab_root_password
[0;31m✗[0m Missing vault variable: vault_vaultwarden_admin_password
[0;31m✗[0m Missing vault variable: vault_wireguard_password
[0;31m✗[0m Missing vault variable: vault_codeserver_password
[0;31m✗[0m Missing vault variable: vault_vault_root_token
[0;31m✗[0m Missing vault variable: vault_vault_unseal_key
[0;31m✗[0m Missing vault variable: vault_openweather_api_key
[0;31m✗[0m Missing vault variable: vault_kubernetes_token
[0;31m✗[0m Missing vault variable: vault_google_refresh_token
[0;31m✗[0m Missing vault variable: vault_minio_access_key
[0;31m✗[0m Missing vault variable: vault_minio_secret_key
[0;31m✗[0m Missing vault variable: vault_vaultwarden_smtp_host
[0;31m✗[0m Missing vault variable: vault_vaultwarden_smtp_port
[0;31m✗[0m Missing vault variable: vault_vaulten_smtp_ssl
[0;31m✗[0m Missing vault variable: vault_vaultwarden_smtp_username
[0;31m✗[0m Missing vault variable: vault_vaultwarden_smtp_password
[0;31m✗[0m Missing vault variable: vault_plex_username
[0;31m✗[0m Missing vault variable: vault_plex_password
[0;31m✗[0m Missing vault variable: vault_jellyfin_username
[0;31m✗[0m Missing vault variable: vault_jellyfin_password
[0;31m✗[0m Missing vault variable: vault_immich_smtp_username
[0;31m✗[0m Missing vault variable: vault_plex_token
[0;31m✗[0m Missing vault variable: vault_webhook_token
[0;31m✗[0m Missing vault variable: vault_traefik_pilot_token
[0;31m✗[0m Missing vault variable: vault_immich_mapbox_key
[0;31m✗[0m Missing vault variable: vault_pagerduty_integration_key
[0;31m✗[0m Missing vault variable: vault_pagerduty_routing_key
[0;31m✗[0m Missing vault variable: vault_grafana_admin_user
[0;31m✗[0m Missing vault variable: vault_influxdb_admin_user
[0;31m✗[0m Missing vault variable: vault_influxdb_username
[0;31m✗[0m Missing vault variable: vault_media_jwt_secret
[0;31m✗[0m Missing vault variable: vault_redis_secret_key
[0;31m✗[0m Missing vault variable: vault_calibreweb_secret_key
[0;31m✗[0m Missing vault variable: vault_elasticsearch_password
[0;31m✗[0m Missing vault variable: vault_elasticsearch_secret_key
[0;31m✗[0m Missing vault variable: vault_kibana_password
[0;31m✗[0m Missing vault variable: vault_ersatztv_database_password
[0;31m✗[0m Missing vault variable: vault_grafana_db_password
[0;31m✗[0m Missing vault variable: vault_grafana_oauth_secret
[0;31m✗[0m Missing vault variable: vault_homepage_oauth_secret
[0;31m✗[0m Missing vault variable: vault_homepage_api_secret
[0;31m✗[0m Missing vault variable: vault_authentik_bootstrap_token
[0;31m✗[0m Missing vault variable: vault_postgresql_admin_password
[0;31m✗[0m Missing vault variable: vault_elasticsearch_elastic_password
[0;31m✗[0m Missing vault variable: vault_backup_smtp_password
[0;31m✗[0m Missing vault variable: vault_immich_oauth_client_secret
[0;31m✗[0m Missing vault variable: vault_immich_push_token
[0;31m✗[0m Missing vault variable: vault_immich_push_app_secret
[0;31m✗[0m Missing vault variable: vault_immich_telegram_bot_token
[0;31m✗[0m Missing vault variable: vault_ssl_cert_key
[0;31m✗[0m Missing vault variable: vault_jwt_secret
[0;31m✗[0m Missing vault variable: vault_encryption_key
[0;31m✗[0m Missing vault variable: vault_samba_password
[0;31m✗[0m Missing vault variable: vault_pihole_web_password
[0;31m✗[0m Missing vault variable: vault_admin_password
[0;31m✗[0m Missing vault variable: vault_db_password
[0;31m✗[0m Missing vault variable: vault_paperless_ngx_admin_password
[0;31m✗[0m Missing vault variable: vault_calibre_web_password
[0;31m✗[0m Missing vault variable: vault_jellyfin_password
[0;31m✗[0m Missing vault variable: vault_sabnzbd_password
[0;31m✗[0m Missing vault variable: vault_audiobookshelf_password
[0;31m✗[0m Missing vault variable: vault_grafana_admin_password_alt
[0;31m✗[0m Missing vault variable: vault_influxdb_admin_password_alt
[0;31m✗[0m Missing vault variable: vault_nextcloud_db_password_alt
[0;31m✗[0m Missing vault variable: vault_nextcloud_admin_password_alt
[0;31m✗[0m Missing vault variable: vault_nextcloud_db_root_password_alt

### 5. Vault File Encryption
[0;31m✗[0m Vault file is not encrypted! Run: ansible-vault encrypt group_vars/all/vault.yml

### 6. Seamless Setup Security
[0;32m✓[0m Seamless setup uses secure password generation

### 7. Credentials Backup
[1;33m⚠[0m No credentials backup found. Run the seamless setup script to generate one.

## Recommendations

1. **Immediate Actions Required:**
   - Fix any hardcoded passwords found
   - Replace insecure password generation
   - Add missing vault variables
   - Encrypt vault file if not already encrypted

2. **Security Best Practices:**
   - Always use vault variables for sensitive data
   - Use cryptographically secure password generation
   - Keep credentials backup in secure location
   - Regularly rotate passwords and secrets

3. **Monitoring:**
   - Run this audit script regularly
   - Monitor for new security issues
   - Keep dependencies updated

## Files Checked
- tasks/*.yml
- roles/*/tasks/*.yml
- roles/*/defaults/*.yml
- roles/*/vars/*.yml
- templates/*.j2
- scripts/*.sh
- group_vars/all/*.yml

## Log File
Full audit log: security_audit_20250812_133006.log

