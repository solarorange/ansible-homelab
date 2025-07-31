
==================================================
Security Scan Report
==================================================
# Security Hardening Scan Report
Generated: /Users/rob/Cursor/ansible_homelab

## Summary
- Files scanned: 234
- Total issues found: 2441

## Issues by Category
### Localhost (818 issues)

**File:** security_hardening_results.json
**Line:** 7
**Match:** `localhost`
**Line Content:** `"mongodump --uri=\"mongodb://{{ item.user }}:{{ item.password }}@{{ item.host | default('localhost') }}:{{ item.port | default('27017') }}/{{ item.name }}\" --gzip --archive={{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.archive"`

**File:** security_hardening_results.json
**Line:** 102
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT version();\""`

**File:** security_hardening_results.json
**Line:** 107
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT 1;\" &"`

**File:** security_hardening_results.json
**Line:** 112
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user | default('homelab') }} -d homelab -c \"SELECT pg_sleep(1);\" &"`

**File:** security_hardening_results.json
**Line:** 120
**Match:** `localhost`
**Line Content:** `"localhost": [`

**File:** security_hardening_results.json
**Line:** 124
**Match:** `localhost`
**Line Content:** `"url: \"{{ service_health_url | default('http://localhost:8080/health') }}\""`

**File:** security_hardening_results.json
**Line:** 129
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 134
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/settings/services\""`

**File:** security_hardening_results.json
**Line:** 139
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/settings/notifications\""`

**File:** security_hardening_results.json
**Line:** 144
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/user\""`

**File:** security_hardening_results.json
**Line:** 149
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/settings/permissions\""`

**File:** security_hardening_results.json
**Line:** 154
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/settings/webhooks\""`

**File:** security_hardening_results.json
**Line:** 159
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5055/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 164
**Match:** `localhost`
**Line Content:** `"nmap -sT -O localhost | grep -E \"^[0-9]+|^Host\""`

**File:** security_hardening_results.json
**Line:** 169
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000\""`

**File:** security_hardening_results.json
**Line:** 174
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:8096/System/Info/Public"`

**File:** security_hardening_results.json
**Line:** 179
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:8096/System/Info/Public > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 184
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s http://localhost:8096/System/Info/Public | jq -r .ServerName)"`

**File:** security_hardening_results.json
**Line:** 189
**Match:** `localhost`
**Line Content:** `"destemail = {{ username }}@localhost  # Alert recipient"`

**File:** security_hardening_results.json
**Line:** 194
**Match:** `localhost`
**Line Content:** `"job: \"/usr/bin/aide --check 2>&1 | mail -s 'AIDE Report' {{ username }}@localhost\""`

**File:** security_hardening_results.json
**Line:** 199
**Match:** `localhost`
**Line Content:** `"mail -s \"SECURITY INCIDENT\" {{ username }}@localhost 2>/dev/null || true"`

**File:** security_hardening_results.json
**Line:** 204
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:7878/api/v3/health > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 209
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s http://localhost:7878/api/v3/health | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 214
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:8686/api/v1/health"`

**File:** security_hardening_results.json
**Line:** 219
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:8686/api/v1/health > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 224
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s http://localhost:8686/api/v1/health | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 229
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 234
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 239
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 244
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 249
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 254
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 259
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 264
**Match:** `localhost`
**Line Content:** `"if ! nc -z localhost 1883; then"`

**File:** security_hardening_results.json
**Line:** 269
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:9000/api/status > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 274
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:9115/-/healthy"`

**File:** security_hardening_results.json
**Line:** 279
**Match:** `localhost`
**Line Content:** `"curl -s \"http://localhost:9115/probe?target=$2&module=https_2xx\" | grep -E \"(probe_success|probe_duration_seconds)\""`

**File:** security_hardening_results.json
**Line:** 284
**Match:** `localhost`
**Line Content:** `"curl -s \"http://localhost:9115/probe?target=$2&module=https_2xx\" | grep -E \"(probe_ssl_earliest_cert_expiry|probe_ssl_validation_success)\""`

**File:** security_hardening_results.json
**Line:** 289
**Match:** `localhost`
**Line Content:** `"curl -s \"http://localhost:9115/probe?target=$2&module=dns_udp_53\" | grep -E \"(probe_success|probe_duration_seconds)\""`

**File:** security_hardening_results.json
**Line:** 294
**Match:** `localhost`
**Line Content:** `"curl -s \"http://localhost:9115/probe?target=$2&module=icmp\" | grep -E \"(probe_success|probe_duration_seconds)\""`

**File:** security_hardening_results.json
**Line:** 299
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9115/-/healthy > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 304
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9115/metrics > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 309
**Match:** `localhost`
**Line Content:** `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 309
**Match:** `localhost`
**Line Content:** `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 314
**Match:** `localhost`
**Line Content:** `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 314
**Match:** `localhost`
**Line Content:** `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 319
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost:3000/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 324
**Match:** `localhost`
**Line Content:** `"domain = localhost"`

**File:** security_hardening_results.json
**Line:** 329
**Match:** `localhost`
**Line Content:** `"ehlo_identity = localhost"`

**File:** security_hardening_results.json
**Line:** 334
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:3000/api/health"`

**File:** security_hardening_results.json
**Line:** 339
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:3000/api/health | grep -q \"ok\"; then"`

**File:** security_hardening_results.json
**Line:** 344
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:80 > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 349
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api?mode=version\"]"`

**File:** security_hardening_results.json
**Line:** 354
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8080/api?mode=version | grep -q \"version\"; then"`

**File:** security_hardening_results.json
**Line:** 359
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/health\""`

**File:** security_hardening_results.json
**Line:** 364
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/config/plex\""`

**File:** security_hardening_results.json
**Line:** 369
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/config/sonarr\""`

**File:** security_hardening_results.json
**Line:** 374
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/config/radarr\""`

**File:** security_hardening_results.json
**Line:** 379
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/config/notifications\""`

**File:** security_hardening_results.json
**Line:** 384
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/health\""`

**File:** security_hardening_results.json
**Line:** 389
**Match:** `localhost`
**Line Content:** `"-m {{ username }}@localhost \\"`

**File:** security_hardening_results.json
**Line:** 394
**Match:** `localhost`
**Line Content:** `"mail -s \"Storage Alert\" {{ username }}@localhost 2>/dev/null || true"`

**File:** security_hardening_results.json
**Line:** 399
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:8787/api/v1/health"`

**File:** security_hardening_results.json
**Line:** 404
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:8787/api/v1/health > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 409
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s http://localhost:8787/api/v1/health | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 414
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:3100/ready"`

**File:** security_hardening_results.json
**Line:** 419
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:3100/ready > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 424
**Match:** `localhost`
**Line Content:** `"if ! curl -s \"http://localhost:3100/loki/api/v1/query?query={}\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 429
**Match:** `localhost`
**Line Content:** `"Local URL: http://localhost:{{ linkwarden_port | default(3000) }}"`

**File:** security_hardening_results.json
**Line:** 434
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 439
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9696/health | grep -q \"ok\"; then"`

**File:** security_hardening_results.json
**Line:** 444
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:13378 | grep -q \"Audiobookshelf\"; then"`

**File:** security_hardening_results.json
**Line:** 449
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/health\""`

**File:** security_hardening_results.json
**Line:** 454
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/sonarr\""`

**File:** security_hardening_results.json
**Line:** 459
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/radarr\""`

**File:** security_hardening_results.json
**Line:** 464
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/providers\""`

**File:** security_hardening_results.json
**Line:** 469
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/languages\""`

**File:** security_hardening_results.json
**Line:** 474
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/notifications\""`

**File:** security_hardening_results.json
**Line:** 479
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:6767/api/health\""`

**File:** security_hardening_results.json
**Line:** 484
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api/v2/app/version\"]"`

**File:** security_hardening_results.json
**Line:** 489
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8080/api/v2/app/version | grep -q \"version\"; then"`

**File:** security_hardening_results.json
**Line:** 494
**Match:** `LocalHost`
**Line Content:** `"WebUI\\LocalHostAuth=true"`

**File:** security_hardening_results.json
**Line:** 499
**Match:** `localhost`
**Line Content:** `"curl -s -k https://localhost:5601/api/status | jq ."`

**File:** security_hardening_results.json
**Line:** 504
**Match:** `localhost`
**Line Content:** `"curl -s -k https://localhost:5601/api/status | jq ."`

**File:** security_hardening_results.json
**Line:** 509
**Match:** `localhost`
**Line Content:** `"if ! curl -s -k -f https://localhost:5601/api/status > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 514
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s -k https://localhost:5601/api/status | jq -r .status.overall.level)"`

**File:** security_hardening_results.json
**Line:** 519
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/system/status\""`

**File:** security_hardening_results.json
**Line:** 524
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/downloadclient\""`

**File:** security_hardening_results.json
**Line:** 529
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/indexer\""`

**File:** security_hardening_results.json
**Line:** 534
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/qualityprofile\""`

**File:** security_hardening_results.json
**Line:** 539
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/metadataprofile\""`

**File:** security_hardening_results.json
**Line:** 544
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/rootfolder\""`

**File:** security_hardening_results.json
**Line:** 549
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/notification\""`

**File:** security_hardening_results.json
**Line:** 554
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/connection\""`

**File:** security_hardening_results.json
**Line:** 559
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/autotagging\""`

**File:** security_hardening_results.json
**Line:** 564
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/ui\""`

**File:** security_hardening_results.json
**Line:** 569
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/backup\""`

**File:** security_hardening_results.json
**Line:** 574
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/update\""`

**File:** security_hardening_results.json
**Line:** 579
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/security\""`

**File:** security_hardening_results.json
**Line:** 584
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/ssl\""`

**File:** security_hardening_results.json
**Line:** 589
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/proxy\""`

**File:** security_hardening_results.json
**Line:** 594
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/analytics\""`

**File:** security_hardening_results.json
**Line:** 599
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/instance\""`

**File:** security_hardening_results.json
**Line:** 604
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/system/status\""`

**File:** security_hardening_results.json
**Line:** 609
**Match:** `localhost`
**Line Content:** `"pg_dump -U {{ item.user }} -h {{ item.host | default('localhost') }} -p {{ item.port | default('5432') }} {{ item.name }} | gzip > {{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.sql.gz"`

**File:** security_hardening_results.json
**Line:** 614
**Match:** `localhost`
**Line Content:** `"mysqldump -u {{ item.user }} -p{{ item.password }} -h {{ item.host | default('localhost') }} -P {{ item.port | default('3306') }} {{ item.name }} | gzip > {{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.sql.gz"`

**File:** security_hardening_results.json
**Line:** 619
**Match:** `localhost`
**Line Content:** `"mongodump --uri=\"mongodb://{{ item.user }}:{{ item.password }}@{{ item.host | default('localhost') }}:{{ item.port | default('27017') }}/{{ item.name }}\" --gzip --archive={{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.archive"`

**File:** security_hardening_results.json
**Line:** 624
**Match:** `localhost`
**Line Content:** `"redis-cli -h {{ item.host | default('localhost') }} -p {{ item.port | default('6379') }} -a {{ item.password }} SAVE && cp {{ item.rdb_path | default('/var/lib/redis/dump.rdb') }} {{ backup_root_dir | default('/var/backups') }}/databases/redis-{{ ansible_date_time.iso8601_basic_short }}.rdb"`

**File:** security_hardening_results.json
**Line:** 629
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8086/health\"]"`

**File:** security_hardening_results.json
**Line:** 634
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost:9090/-/healthy\"]"`

**File:** security_hardening_results.json
**Line:** 639
**Match:** `localhost`
**Line Content:** `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3000/api/health || exit 1\"]"`

**File:** security_hardening_results.json
**Line:** 644
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8080 | grep -q \"Komga\"; then"`

**File:** security_hardening_results.json
**Line:** 649
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api?mode=version\"]"`

**File:** security_hardening_results.json
**Line:** 654
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api/v2/app/version\"]"`

**File:** security_hardening_results.json
**Line:** 659
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9696/health\"]"`

**File:** security_hardening_results.json
**Line:** 664
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8989/health\"]"`

**File:** security_hardening_results.json
**Line:** 669
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:7878/health\"]"`

**File:** security_hardening_results.json
**Line:** 674
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8686/health\"]"`

**File:** security_hardening_results.json
**Line:** 679
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8787/health\"]"`

**File:** security_hardening_results.json
**Line:** 684
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:6767/health\"]"`

**File:** security_hardening_results.json
**Line:** 689
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8088/health\"]"`

**File:** security_hardening_results.json
**Line:** 694
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8096/health\"]"`

**File:** security_hardening_results.json
**Line:** 699
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 704
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`

**File:** security_hardening_results.json
**Line:** 709
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3003/health\"]"`

**File:** security_hardening_results.json
**Line:** 714
**Match:** `localhost`
**Line Content:** `"if curl -f -s \"http://localhost:$port$path\" >/dev/null 2>&1; then"`

**File:** security_hardening_results.json
**Line:** 719
**Match:** `localhost`
**Line Content:** `"local speed=$(docker-compose exec -T \"$service\" curl -s \"http://localhost:8080/api?mode=diskspace\" | jq -r '.diskspace[].speed' 2>/dev/null || echo \"0\")"`

**File:** security_hardening_results.json
**Line:** 724
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.port }}{{ item.path }}\""`

**File:** security_hardening_results.json
**Line:** 729
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/ping\"]"`

**File:** security_hardening_results.json
**Line:** 734
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9000/health\"]"`

**File:** security_hardening_results.json
**Line:** 739
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 744
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9090/-/healthy\"]"`

**File:** security_hardening_results.json
**Line:** 749
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8086/health\"]"`

**File:** security_hardening_results.json
**Line:** 754
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/health\"]"`

**File:** security_hardening_results.json
**Line:** 759
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8096/health\"]"`

**File:** security_hardening_results.json
**Line:** 764
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8989/health\"]"`

**File:** security_hardening_results.json
**Line:** 769
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:7878/health\"]"`

**File:** security_hardening_results.json
**Line:** 774
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`

**File:** security_hardening_results.json
**Line:** 779
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8096 | grep -q \"Jellyfin\"; then"`

**File:** security_hardening_results.json
**Line:** 784
**Match:** `localhost`
**Line Content:** `"url: \"{{ notifications.email.smtp_url | default('smtp://localhost:587') }}\""`

**File:** security_hardening_results.json
**Line:** 789
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9093/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 794
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9093/api/v1/alerts\""`

**File:** security_hardening_results.json
**Line:** 799
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/status/config\""`

**File:** security_hardening_results.json
**Line:** 804
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/rules\""`

**File:** security_hardening_results.json
**Line:** 809
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/alerts\""`

**File:** security_hardening_results.json
**Line:** 814
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 819
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 824
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 829
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 834
**Match:** `localhost`
**Line Content:** `"delegate_to: localhost"`

**File:** security_hardening_results.json
**Line:** 839
**Match:** `localhost`
**Line Content:** `"until curl -s http://localhost:8086/health > /dev/null 2>&1; do"`

**File:** security_hardening_results.json
**Line:** 844
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8086/health > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 849
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8086/health\"]"`

**File:** security_hardening_results.json
**Line:** 854
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=get_server_info\""`

**File:** security_hardening_results.json
**Line:** 859
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=update_plex_server\""`

**File:** security_hardening_results.json
**Line:** 864
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=update_notification_config\""`

**File:** security_hardening_results.json
**Line:** 869
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=backup_config\""`

**File:** security_hardening_results.json
**Line:** 874
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=get_server_info\""`

**File:** security_hardening_results.json
**Line:** 879
**Match:** `localhost`
**Line Content:** `"curl -X PUT \"localhost:9200/_snapshot/backup\" -H 'Content-Type: application/json' -d'"`

**File:** security_hardening_results.json
**Line:** 884
**Match:** `localhost`
**Line Content:** `"curl -X PUT \"localhost:9200/_snapshot/backup/$SNAPSHOT_NAME?wait_for_completion=true\""`

**File:** security_hardening_results.json
**Line:** 889
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f \"localhost:9200/_snapshot/backup/$SNAPSHOT_NAME\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 894
**Match:** `localhost`
**Line Content:** `"curl -X POST \"localhost:9200/_snapshot/backup/$SNAPSHOT_NAME/_restore?wait_for_completion=true\""`

**File:** security_hardening_results.json
**Line:** 899
**Match:** `localhost`
**Line Content:** `"curl -s localhost:9200/_cluster/health | jq ."`

**File:** security_hardening_results.json
**Line:** 904
**Match:** `localhost`
**Line Content:** `"curl -s localhost:9200/_cluster/health | jq ."`

**File:** security_hardening_results.json
**Line:** 909
**Match:** `localhost`
**Line Content:** `"curl -s localhost:9200/_cat/indices?v"`

**File:** security_hardening_results.json
**Line:** 914
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:9200/_cluster/health > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 919
**Match:** `localhost`
**Line Content:** `"HEALTH=$(curl -s http://localhost:9200/_cluster/health | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 924
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:9093/-/healthy"`

**File:** security_hardening_results.json
**Line:** 929
**Match:** `localhost`
**Line Content:** `"curl -X POST http://localhost:9093/-/reload"`

**File:** security_hardening_results.json
**Line:** 934
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:9093/api/v2/alerts | jq '.'"`

**File:** security_hardening_results.json
**Line:** 939
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:9093/api/v2/silences | jq '.'"`

**File:** security_hardening_results.json
**Line:** 944
**Match:** `localhost`
**Line Content:** `"curl -X POST http://localhost:9093/api/v2/alerts \\"`

**File:** security_hardening_results.json
**Line:** 949
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9093/-/healthy > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 954
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9093/api/v2/status > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 959
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9093/api/v2/status | jq -e '.config' > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 964
**Match:** `localhost`
**Line Content:** `"- localhost"`

**File:** security_hardening_results.json
**Line:** 969
**Match:** `localhost`
**Line Content:** `"- localhost"`

**File:** security_hardening_results.json
**Line:** 974
**Match:** `localhost`
**Line Content:** `"- localhost"`

**File:** security_hardening_results.json
**Line:** 979
**Match:** `localhost`
**Line Content:** `"- localhost"`

**File:** security_hardening_results.json
**Line:** 984
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:9080/ready"`

**File:** security_hardening_results.json
**Line:** 989
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9080/ready > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 994
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9080/metrics > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 999
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost:9090/-/healthy\"]"`

**File:** security_hardening_results.json
**Line:** 1004
**Match:** `localhost`
**Line Content:** `"- targets: ['localhost:9090']"`

**File:** security_hardening_results.json
**Line:** 1009
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9090/-/healthy > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 1014
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:9090/api/v1/query?query=up > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 1019
**Match:** `localhost`
**Line Content:** `"target_count=$(curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets | length')"`

**File:** security_hardening_results.json
**Line:** 1024
**Match:** `localhost`
**Line Content:** `"rule_count=$(curl -s http://localhost:9090/api/v1/rules | jq '.data.groups | length')"`

**File:** security_hardening_results.json
**Line:** 1029
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:9090/-/healthy"`

**File:** security_hardening_results.json
**Line:** 1034
**Match:** `localhost`
**Line Content:** `"curl -X POST http://localhost:9090/-/reload"`

**File:** security_hardening_results.json
**Line:** 1039
**Match:** `localhost`
**Line Content:** `"- targets: ['localhost:9090']"`

**File:** security_hardening_results.json
**Line:** 1044
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.port }}{{ item.endpoint | default('/health') }}\""`

**File:** security_hardening_results.json
**Line:** 1049
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT version();\""`

**File:** security_hardening_results.json
**Line:** 1054
**Match:** `localhost`
**Line Content:** `"redis-cli -h localhost -p 6379 -a {{ vault_redis_password }} ping"`

**File:** security_hardening_results.json
**Line:** 1059
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1064
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 1069
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/http/routers\""`

**File:** security_hardening_results.json
**Line:** 1074
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9000/if/user/\""`

**File:** security_hardening_results.json
**Line:** 1079
**Match:** `localhost`
**Line Content:** `"if ! nc -z localhost 445; then"`

**File:** security_hardening_results.json
**Line:** 1084
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8265/api/v2/status | grep -q \"status\"; then"`

**File:** security_hardening_results.json
**Line:** 1089
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8083 | grep -q \"Calibre-Web\"; then"`

**File:** security_hardening_results.json
**Line:** 1094
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:8989/api/v3/health"`

**File:** security_hardening_results.json
**Line:** 1099
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f http://localhost:8989/api/v3/health > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 1104
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s http://localhost:8989/api/v3/health | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 1109
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/health\""`

**File:** security_hardening_results.json
**Line:** 1114
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/health\""`

**File:** security_hardening_results.json
**Line:** 1119
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/metrics\""`

**File:** security_hardening_results.json
**Line:** 1124
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/http/routers\""`

**File:** security_hardening_results.json
**Line:** 1129
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 1134
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/rawdata\""`

**File:** security_hardening_results.json
**Line:** 1139
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:80/admin/api.php?status\""`

**File:** security_hardening_results.json
**Line:** 1144
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:80/admin/api.php?summaryRaw\""`

**File:** security_hardening_results.json
**Line:** 1149
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9200/_cluster/health\""`

**File:** security_hardening_results.json
**Line:** 1154
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5601/api/status\""`

**File:** security_hardening_results.json
**Line:** 1159
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1164
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 1169
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3100/loki/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1174
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9093/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 1179
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/query?query=up\""`

**File:** security_hardening_results.json
**Line:** 1184
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5432/health\""`

**File:** security_hardening_results.json
**Line:** 1189
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`

**File:** security_hardening_results.json
**Line:** 1194
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`

**File:** security_hardening_results.json
**Line:** 1199
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/health\"]"`

**File:** security_hardening_results.json
**Line:** 1204
**Match:** `localhost`
**Line Content:** `"url: http://localhost:3001"`

**File:** security_hardening_results.json
**Line:** 1209
**Match:** `localhost`
**Line Content:** `"url: http://localhost:9000"`

**File:** security_hardening_results.json
**Line:** 1214
**Match:** `localhost`
**Line Content:** `"url: http://localhost:8080"`

**File:** security_hardening_results.json
**Line:** 1219
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`

**File:** security_hardening_results.json
**Line:** 1224
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:5432\""`

**File:** security_hardening_results.json
**Line:** 1229
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1234
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8989/api/v3/health\""`

**File:** security_hardening_results.json
**Line:** 1239
**Match:** `localhost`
**Line Content:** `"curl -f http://localhost:6767/api/v1/health"`

**File:** security_hardening_results.json
**Line:** 1244
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1249
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/http/services\""`

**File:** security_hardening_results.json
**Line:** 1254
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9000/if/user/\""`

**File:** security_hardening_results.json
**Line:** 1259
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9093/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 1264
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/rules\""`

**File:** security_hardening_results.json
**Line:** 1269
**Match:** `localhost`
**Line Content:** `"curl -X POST http://localhost:9093/api/v1/alerts \\"`

**File:** security_hardening_results.json
**Line:** 1274
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/http/services\""`

**File:** security_hardening_results.json
**Line:** 1279
**Match:** `localhost`
**Line Content:** `"host: localhost"`

**File:** security_hardening_results.json
**Line:** 1284
**Match:** `localhost`
**Line Content:** `"host: localhost"`

**File:** security_hardening_results.json
**Line:** 1289
**Match:** `localhost`
**Line Content:** `"host: localhost"`

**File:** security_hardening_results.json
**Line:** 1294
**Match:** `localhost`
**Line Content:** `"url: http://localhost:9090/-/healthy"`

**File:** security_hardening_results.json
**Line:** 1299
**Match:** `localhost`
**Line Content:** `"url: http://localhost:3000/api/health"`

**File:** security_hardening_results.json
**Line:** 1304
**Match:** `localhost`
**Line Content:** `"url: http://localhost:3100/ready"`

**File:** security_hardening_results.json
**Line:** 1309
**Match:** `localhost`
**Line Content:** `"ab -n 200 -c 5 -r http://localhost:8989/api/v3/health"`

**File:** security_hardening_results.json
**Line:** 1314
**Match:** `localhost`
**Line Content:** `"ab -n 1000 -c 10 -r http://localhost:9090/api/v1/query?query=up"`

**File:** security_hardening_results.json
**Line:** 1319
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \""`

**File:** security_hardening_results.json
**Line:** 1324
**Match:** `localhost`
**Line Content:** `"redis-benchmark -h localhost -p 6379 -a {{ vault_redis_password }} -n 10000 -c 10"`

**File:** security_hardening_results.json
**Line:** 1329
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT 1;\" &"`

**File:** security_hardening_results.json
**Line:** 1334
**Match:** `localhost`
**Line Content:** `"time curl -s \"http://localhost:9090/api/v1/query?query=up\" | jq '.data.result | length'"`

**File:** security_hardening_results.json
**Line:** 1339
**Match:** `localhost`
**Line Content:** `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\""`

**File:** security_hardening_results.json
**Line:** 1344
**Match:** `localhost`
**Line Content:** `"time curl -s \"http://localhost:9090/api/v1/rules\" | jq '.data.groups | length'"`

**File:** security_hardening_results.json
**Line:** 1349
**Match:** `localhost`
**Line Content:** `"siege -c 10 -t 30S http://localhost:8989/api/v3/health"`

**File:** security_hardening_results.json
**Line:** 1354
**Match:** `localhost`
**Line Content:** `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user | default('homelab') }} -d homelab -c \"SELECT pg_sleep(1);\" &"`

**File:** security_hardening_results.json
**Line:** 1359
**Match:** `localhost`
**Line Content:** `"curl -X POST \"http://localhost:9091/metrics/job/redis/instance/{{ ansible_hostname }}\" \\"`

**File:** security_hardening_results.json
**Line:** 1364
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/status/config\""`

**File:** security_hardening_results.json
**Line:** 1369
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/health\""`

**File:** security_hardening_results.json
**Line:** 1374
**Match:** `localhost`
**Line Content:** `"- Prometheus: http://localhost:9090"`

**File:** security_hardening_results.json
**Line:** 1379
**Match:** `localhost`
**Line Content:** `"- Grafana: http://localhost:3000"`

**File:** security_hardening_results.json
**Line:** 1384
**Match:** `localhost`
**Line Content:** `"- AlertManager: http://localhost:9093"`

**File:** security_hardening_results.json
**Line:** 1389
**Match:** `localhost`
**Line Content:** `"curl -X PUT \"localhost:{{ elasticsearch_port }}/_snapshot/backup\" -H 'Content-Type: application/json' -d'"`

**File:** security_hardening_results.json
**Line:** 1394
**Match:** `localhost`
**Line Content:** `"curl -X PUT \"localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME?wait_for_completion=true\""`

**File:** security_hardening_results.json
**Line:** 1399
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f \"localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME\" > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 1404
**Match:** `localhost`
**Line Content:** `"curl -X POST \"localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME/_restore?wait_for_completion=true\""`

**File:** security_hardening_results.json
**Line:** 1409
**Match:** `localhost`
**Line Content:** `"curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq ."`

**File:** security_hardening_results.json
**Line:** 1414
**Match:** `localhost`
**Line Content:** `"curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq ."`

**File:** security_hardening_results.json
**Line:** 1419
**Match:** `localhost`
**Line Content:** `"curl -s \"localhost:{{ elasticsearch_port }}/_cat/indices?v\" | jq ."`

**File:** security_hardening_results.json
**Line:** 1424
**Match:** `localhost`
**Line Content:** `"if ! curl -s -f \"localhost:{{ elasticsearch_port }}/_cluster/health\" > /dev/null 2>&1; then"`

**File:** security_hardening_results.json
**Line:** 1429
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 1434
**Match:** `localhost`
**Line Content:** `"curl -s -k https://localhost:{{ kibana_port }}/api/status | jq ."`

**File:** security_hardening_results.json
**Line:** 1439
**Match:** `localhost`
**Line Content:** `"curl -s -k https://localhost:{{ kibana_port }}/api/status | jq ."`

**File:** security_hardening_results.json
**Line:** 1444
**Match:** `localhost`
**Line Content:** `"if ! curl -s -k -f https://localhost:{{ kibana_port }}/api/status > /dev/null 2>&1; then"`

**File:** security_hardening_results.json
**Line:** 1449
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s -k https://localhost:{{ kibana_port }}/api/status | jq -r .status.overall.level)"`

**File:** security_hardening_results.json
**Line:** 1454
**Match:** `localhost`
**Line Content:** `"HEALTH=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .status)"`

**File:** security_hardening_results.json
**Line:** 1459
**Match:** `localhost`
**Line Content:** `"NODES=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .number_of_nodes)"`

**File:** security_hardening_results.json
**Line:** 1464
**Match:** `localhost`
**Line Content:** `"INDICES=$(curl -s \"localhost:{{ elasticsearch_port }}/_cat/indices?v\" | wc -l)"`

**File:** security_hardening_results.json
**Line:** 1469
**Match:** `localhost`
**Line Content:** `"UNASSIGNED_SHARDS=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .unassigned_shards)"`

**File:** security_hardening_results.json
**Line:** 1474
**Match:** `localhost`
**Line Content:** `"HEALTH=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\")"`

**File:** security_hardening_results.json
**Line:** 1479
**Match:** `localhost`
**Line Content:** `"NODE_STATS=$(curl -s \"localhost:{{ elasticsearch_port }}/_nodes/stats\")"`

**File:** security_hardening_results.json
**Line:** 1484
**Match:** `localhost`
**Line Content:** `"curl -X POST \"http://localhost:9091/metrics/job/elasticsearch/instance/{{ ansible_hostname }}\" \\"`

**File:** security_hardening_results.json
**Line:** 1489
**Match:** `localhost`
**Line Content:** `"STATUS=$(curl -s -k \"https://localhost:{{ kibana_port }}/api/status\")"`

**File:** security_hardening_results.json
**Line:** 1494
**Match:** `localhost`
**Line Content:** `"curl -X POST \"http://localhost:9091/metrics/job/kibana/instance/{{ ansible_hostname }}\" \\"`

**File:** security_hardening_results.json
**Line:** 1499
**Match:** `localhost`
**Line Content:** `"url: http://localhost:9090/api/v1/rules"`

**File:** security_hardening_results.json
**Line:** 1504
**Match:** `localhost`
**Line Content:** `"url: http://localhost:9093/api/v1/status"`

**File:** security_hardening_results.json
**Line:** 1509
**Match:** `localhost`
**Line Content:** `"- targets: ['localhost:9090']"`

**File:** security_hardening_results.json
**Line:** 1514
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-s\", \"-k\", \"https://localhost:{{ kibana_web_port }}/api/status\"]"`

**File:** security_hardening_results.json
**Line:** 1519
**Match:** `localhost`
**Line Content:** `"ansible.builtin.command: docker exec {{ kibana_container_name }} curl -s -k https://localhost:{{ kibana_web_port }}/api/status"`

**File:** security_hardening_results.json
**Line:** 1524
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-s\", \"-k\", \"https://localhost:{{ elasticsearch_web_port }}/_cluster/health\"]"`

**File:** security_hardening_results.json
**Line:** 1529
**Match:** `localhost`
**Line Content:** `"ansible.builtin.command: docker exec {{ elasticsearch_container_name }} curl -s -k https://localhost:{{ elasticsearch_web_port }}/_cluster/health"`

**File:** security_hardening_results.json
**Line:** 1534
**Match:** `localhost`
**Line Content:** `"databases_smtp_host: \"{{ smtp_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 1539
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 1544
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ homepage_port }}/api/services\""`

**File:** security_hardening_results.json
**Line:** 1549
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ homepage_port }}/api/bookmarks\""`

**File:** security_hardening_results.json
**Line:** 1554
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ homepage_port }}/api/widgets\""`

**File:** security_hardening_results.json
**Line:** 1559
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/metrics\""`

**File:** security_hardening_results.json
**Line:** 1564
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/auth/status\""`

**File:** security_hardening_results.json
**Line:** 1569
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 1574
**Match:** `localhost`
**Line Content:** `"HOMEPAGE_URL: \"http://localhost:{{ homepage_port }}\""`

**File:** security_hardening_results.json
**Line:** 1579
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/services\""`

**File:** security_hardening_results.json
**Line:** 1584
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/bookmarks\""`

**File:** security_hardening_results.json
**Line:** 1589
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/weather\""`

**File:** security_hardening_results.json
**Line:** 1594
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 1599
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/services\""`

**File:** security_hardening_results.json
**Line:** 1604
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 1609
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 1614
**Match:** `localhost`
**Line Content:** `"Local URL: http://localhost:{{ homepage_port }}"`

**File:** security_hardening_results.json
**Line:** 1619
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ jellyfin_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 1624
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ jellyfin_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 1629
**Match:** `localhost`
**Line Content:** `"jellyfin_domain: \"jellyfin.{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 1634
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/rawdata\""`

**File:** security_hardening_results.json
**Line:** 1639
**Match:** `localhost`
**Line Content:** `"curl -s http://localhost:8080/api/rawdata"`

**File:** security_hardening_results.json
**Line:** 1644
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:8080/api/rawdata > /dev/null; then"`

**File:** security_hardening_results.json
**Line:** 1649
**Match:** `localhost`
**Line Content:** `"metrics) curl -s http://localhost:6060/metrics;;"`

**File:** security_hardening_results.json
**Line:** 1654
**Match:** `localhost`
**Line Content:** `"if ! curl -s http://localhost:6060/metrics > /dev/null; then echo \"CrowdSec metrics are not accessible\"; exit 1; fi"`

**File:** security_hardening_results.json
**Line:** 1659
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:80/admin/api.php?status\""`

**File:** security_hardening_results.json
**Line:** 1664
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:80/admin/api.php\""`

**File:** security_hardening_results.json
**Line:** 1669
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:80/admin/api.php\""`

**File:** security_hardening_results.json
**Line:** 1674
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:80/admin/api.php?update\""`

**File:** security_hardening_results.json
**Line:** 1679
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/-/reload\""`

**File:** security_hardening_results.json
**Line:** 1684
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/rawdata\""`

**File:** security_hardening_results.json
**Line:** 1689
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1694
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`

**File:** security_hardening_results.json
**Line:** 1699
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/groups/\""`

**File:** security_hardening_results.json
**Line:** 1704
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1709
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ security_authentik.port }}/api/v3/policies/user/\""`

**File:** security_hardening_results.json
**Line:** 1714
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/tokens/\""`

**File:** security_hardening_results.json
**Line:** 1719
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`

**File:** security_hardening_results.json
**Line:** 1724
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/groups/\""`

**File:** security_hardening_results.json
**Line:** 1729
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1734
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/policies/user/\""`

**File:** security_hardening_results.json
**Line:** 1739
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/metrics\""`

**File:** security_hardening_results.json
**Line:** 1744
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 1749
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1754
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1759
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`

**File:** security_hardening_results.json
**Line:** 1764
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1769
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`

**File:** security_hardening_results.json
**Line:** 1774
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/groups/\""`

**File:** security_hardening_results.json
**Line:** 1779
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/policies/\""`

**File:** security_hardening_results.json
**Line:** 1784
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 1789
**Match:** `localhost`
**Line Content:** `"3. API Health Check: curl -v http://localhost:{{ security_authentik.port }}/api/v3/core/applications/"`

**File:** security_hardening_results.json
**Line:** 1794
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9000/if/user/\""`

**File:** security_hardening_results.json
**Line:** 1799
**Match:** `localhost`
**Line Content:** `"AUTHENTIK_URL: \"http://localhost:9000\""`

**File:** security_hardening_results.json
**Line:** 1804
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 1809
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3003/health\"]"`

**File:** security_hardening_results.json
**Line:** 1814
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3005/health\"]"`

**File:** security_hardening_results.json
**Line:** 1819
**Match:** `localhost`
**Line Content:** `"immich_smtp_host: \"{{ smtp_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 1824
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 1829
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/services\""`

**File:** security_hardening_results.json
**Line:** 1834
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 1839
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}/security/health\""`

**File:** security_hardening_results.json
**Line:** 1844
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}/auth/login\""`

**File:** security_hardening_results.json
**Line:** 1849
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}/api/test\""`

**File:** security_hardening_results.json
**Line:** 1854
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 1859
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_api_port }}/api/{{ fing_api_version }}/health\""`

**File:** security_hardening_results.json
**Line:** 1864
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_metrics_port }}/metrics\""`

**File:** security_hardening_results.json
**Line:** 1869
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}/auth/login\""`

**File:** security_hardening_results.json
**Line:** 1874
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1879
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/services\""`

**File:** security_hardening_results.json
**Line:** 1884
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 1889
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 1894
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 1899
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 1904
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 1909
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 1914
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_metrics_port }}/metrics\""`

**File:** security_hardening_results.json
**Line:** 1919
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 1924
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ fing_api_port }}/api/{{ fing_api_version }}/health\""`

**File:** security_hardening_results.json
**Line:** 1929
**Match:** `localhost`
**Line Content:** `"fing_database_host: \"{{ postgresql_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 1934
**Match:** `localhost`
**Line Content:** `"fing_smtp_host: \"{{ smtp_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 1939
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ dumbassets_port }}\""`

**File:** security_hardening_results.json
**Line:** 1944
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ dumbassets_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 1949
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 1954
**Match:** `localhost`
**Line Content:** `"- Local: http://localhost:{{ dumbassets_port }}"`

**File:** security_hardening_results.json
**Line:** 1959
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ dumbassets_port }}\""`

**File:** security_hardening_results.json
**Line:** 1964
**Match:** `localhost`
**Line Content:** `"- Local URL: http://localhost:{{ dumbassets_port }}"`

**File:** security_hardening_results.json
**Line:** 1969
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ testservice_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 1974
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ testservice_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 1979
**Match:** `localhost`
**Line Content:** `"testservice_domain: \"testservice.{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 1984
**Match:** `localhost`
**Line Content:** `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3001/api/healthz\"]"`

**File:** security_hardening_results.json
**Line:** 1989
**Match:** `localhost`
**Line Content:** `"test: [\"CMD-SHELL\", \"curl -f http://localhost:8080/health\"]"`

**File:** security_hardening_results.json
**Line:** 1994
**Match:** `localhost`
**Line Content:** `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3002/health\"]"`

**File:** security_hardening_results.json
**Line:** 1999
**Match:** `localhost`
**Line Content:** `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3567/hello\"]"`

**File:** security_hardening_results.json
**Line:** 2004
**Match:** `localhost`
**Line Content:** `"test: [\"CMD-SHELL\", \"curl -f http://localhost:9981/health\"]"`

**File:** security_hardening_results.json
**Line:** 2009
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2014
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/dashboards/db/homelab-overview\""`

**File:** security_hardening_results.json
**Line:** 2019
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/v1/provisioning/alert-rules\""`

**File:** security_hardening_results.json
**Line:** 2024
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/v1/provisioning/notification-policies\""`

**File:** security_hardening_results.json
**Line:** 2029
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2034
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/user\""`

**File:** security_hardening_results.json
**Line:** 2039
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 2044
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/search\""`

**File:** security_hardening_results.json
**Line:** 2049
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/folders\""`

**File:** security_hardening_results.json
**Line:** 2054
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/alert-notifications\""`

**File:** security_hardening_results.json
**Line:** 2059
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/admin/users\""`

**File:** security_hardening_results.json
**Line:** 2064
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/teams/search\""`

**File:** security_hardening_results.json
**Line:** 2069
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources/{{ item.key }}/health\""`

**File:** security_hardening_results.json
**Line:** 2074
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2079
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ grafana_port }}/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 2084
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ grafana_port }}/api/dashboards\""`

**File:** security_hardening_results.json
**Line:** 2089
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ grafana_port }}/api/folders\""`

**File:** security_hardening_results.json
**Line:** 2094
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ grafana_port }}/api/alerting/alertmanager/grafana/config\""`

**File:** security_hardening_results.json
**Line:** 2099
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 2104
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/search\""`

**File:** security_hardening_results.json
**Line:** 2109
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/alerting/alertmanager/grafana/config\""`

**File:** security_hardening_results.json
**Line:** 2114
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/admin/settings\""`

**File:** security_hardening_results.json
**Line:** 2119
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2124
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/admin/users\""`

**File:** security_hardening_results.json
**Line:** 2129
**Match:** `localhost`
**Line Content:** `"--url http://localhost:{{ grafana_port }}"`

**File:** security_hardening_results.json
**Line:** 2134
**Match:** `localhost`
**Line Content:** `"--url http://localhost:{{ grafana_port }}"`

**File:** security_hardening_results.json
**Line:** 2139
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/admin/users\""`

**File:** security_hardening_results.json
**Line:** 2144
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/teams/search\""`

**File:** security_hardening_results.json
**Line:** 2149
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2154
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/admin/users/1/password\""`

**File:** security_hardening_results.json
**Line:** 2159
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 2164
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/search\""`

**File:** security_hardening_results.json
**Line:** 2169
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/v1/provisioning/alert-rules\""`

**File:** security_hardening_results.json
**Line:** 2174
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2179
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2184
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/search\""`

**File:** security_hardening_results.json
**Line:** 2189
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/v1/provisioning/alert-rules\""`

**File:** security_hardening_results.json
**Line:** 2194
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/v1/provisioning/notification-policies\""`

**File:** security_hardening_results.json
**Line:** 2199
**Match:** `localhost`
**Line Content:** `"- Grafana Dashboard: http://localhost:{{ grafana_port }}"`

**File:** security_hardening_results.json
**Line:** 2204
**Match:** `localhost`
**Line Content:** `"- Alertmanager: http://localhost:9093"`

**File:** security_hardening_results.json
**Line:** 2209
**Match:** `localhost`
**Line Content:** `"- Prometheus: http://localhost:9090"`

**File:** security_hardening_results.json
**Line:** 2214
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2219
**Match:** `localhost`
**Line Content:** `"- URL: http://localhost:{{ grafana_port }}"`

**File:** security_hardening_results.json
**Line:** 2224
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/alert-notifications\""`

**File:** security_hardening_results.json
**Line:** 2229
**Match:** `localhost`
**Line Content:** `"--url http://localhost:{{ grafana_port }}"`

**File:** security_hardening_results.json
**Line:** 2234
**Match:** `localhost`
**Line Content:** `"--url http://localhost:{{ grafana_port }}"`

**File:** security_hardening_results.json
**Line:** 2239
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/alert-notifications\""`

**File:** security_hardening_results.json
**Line:** 2244
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/alerts\""`

**File:** security_hardening_results.json
**Line:** 2249
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 2254
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources/{{ item.key }}\""`

**File:** security_hardening_results.json
**Line:** 2259
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources/{{ item.key }}/health\""`

**File:** security_hardening_results.json
**Line:** 2264
**Match:** `localhost`
**Line Content:** `"grafana_domain: \"grafana.{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2269
**Match:** `localhost`
**Line Content:** `"grafana_database_host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 2274
**Match:** `localhost`
**Line Content:** `"email: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2279
**Match:** `localhost`
**Line Content:** `"email: \"viewer@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2284
**Match:** `localhost`
**Line Content:** `"email: \"editor@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2289
**Match:** `localhost`
**Line Content:** `"email: \"admins@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2294
**Match:** `localhost`
**Line Content:** `"email: \"viewers@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2299
**Match:** `localhost`
**Line Content:** `"email: \"editors@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2304
**Match:** `localhost`
**Line Content:** `"addresses: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2309
**Match:** `localhost`
**Line Content:** `"-m {{ username }}@localhost \\"`

**File:** security_hardening_results.json
**Line:** 2314
**Match:** `localhost`
**Line Content:** `"if ! nc -z localhost 445; then"`

**File:** security_hardening_results.json
**Line:** 2319
**Match:** `localhost`
**Line Content:** `"prometheus_pushgateway: http://localhost:9091"`

**File:** security_hardening_results.json
**Line:** 2324
**Match:** `localhost`
**Line Content:** `"ansible.builtin.command: smbclient -L //localhost"`

**File:** security_hardening_results.json
**Line:** 2329
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8384/rest/system/status\""`

**File:** security_hardening_results.json
**Line:** 2334
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/status.php\""`

**File:** security_hardening_results.json
**Line:** 2339
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ portainer_port }}\""`

**File:** security_hardening_results.json
**Line:** 2344
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ tdarr_port }}\""`

**File:** security_hardening_results.json
**Line:** 2349
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ tautulli_port }}\""`

**File:** security_hardening_results.json
**Line:** 2354
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000\""`

**File:** security_hardening_results.json
**Line:** 2359
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/status/config\""`

**File:** security_hardening_results.json
**Line:** 2364
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/health\""`

**File:** security_hardening_results.json
**Line:** 2369
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000\""`

**File:** security_hardening_results.json
**Line:** 2374
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=get_server_info\""`

**File:** security_hardening_results.json
**Line:** 2379
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/services\""`

**File:** security_hardening_results.json
**Line:** 2384
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ n8n_port }}/healthz\""`

**File:** security_hardening_results.json
**Line:** 2389
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ n8n_port }}\""`

**File:** security_hardening_results.json
**Line:** 2394
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ n8n_port }}/metrics\""`

**File:** security_hardening_results.json
**Line:** 2399
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/services\""`

**File:** security_hardening_results.json
**Line:** 2404
**Match:** `localhost`
**Line Content:** `"- Local URL: http://localhost:{{ n8n_port }}"`

**File:** security_hardening_results.json
**Line:** 2409
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ n8n_port }}/healthz\""`

**File:** security_hardening_results.json
**Line:** 2414
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ n8n_port }}/healthz\""`

**File:** security_hardening_results.json
**Line:** 2419
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ n8n_port }}/metrics\""`

**File:** security_hardening_results.json
**Line:** 2424
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9093/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 2429
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/rules\""`

**File:** security_hardening_results.json
**Line:** 2434
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:5678/healthz\"]"`

**File:** security_hardening_results.json
**Line:** 2439
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ reconya_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2444
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ reconya_port }}/api/devices\""`

**File:** security_hardening_results.json
**Line:** 2449
**Match:** `localhost`
**Line Content:** `"- \"Local: http://localhost:{{ reconya_port }}\""`

**File:** security_hardening_results.json
**Line:** 2454
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3008/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 2459
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ testservice2_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 2464
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ testservice2_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 2469
**Match:** `localhost`
**Line Content:** `"testservice2_domain: \"testservice2.{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2474
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ romm_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 2479
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ romm_external_port }}\""`

**File:** security_hardening_results.json
**Line:** 2484
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ romm_external_port }}/api/v1/auth/register\""`

**File:** security_hardening_results.json
**Line:** 2489
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ romm_external_port }}/api/v1/auth/api-key\""`

**File:** security_hardening_results.json
**Line:** 2494
**Match:** `localhost`
**Line Content:** `"romm_domain: \"romm.{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2499
**Match:** `localhost`
**Line Content:** `"romm_database_host: \"{{ postgresql_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2504
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/services\""`

**File:** security_hardening_results.json
**Line:** 2509
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ vaultwarden_port }}/alive\""`

**File:** security_hardening_results.json
**Line:** 2514
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ vaultwarden_port }}/alive\""`

**File:** security_hardening_results.json
**Line:** 2519
**Match:** `localhost`
**Line Content:** `"Local URL: http://localhost:{{ vaultwarden_port }}"`

**File:** security_hardening_results.json
**Line:** 2524
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ prometheus_port }}/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 2529
**Match:** `localhost`
**Line Content:** `"- \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2534
**Match:** `localhost`
**Line Content:** `"- URL: http://localhost:{{ vaultwarden_port }}/alive"`

**File:** security_hardening_results.json
**Line:** 2539
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ alertmanager_port }}/api/v1/alerts\""`

**File:** security_hardening_results.json
**Line:** 2544
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:80/alive\"]"`

**File:** security_hardening_results.json
**Line:** 2549
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ home_assistant_port }}\""`

**File:** security_hardening_results.json
**Line:** 2554
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ zigbee2mqtt_port }}\""`

**File:** security_hardening_results.json
**Line:** 2559
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ node_red_port }}\""`

**File:** security_hardening_results.json
**Line:** 2564
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ n8n_port }}\""`

**File:** security_hardening_results.json
**Line:** 2569
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 2574
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/services\""`

**File:** security_hardening_results.json
**Line:** 2579
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ node_red_port }}\""`

**File:** security_hardening_results.json
**Line:** 2584
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ n8n_port }}\""`

**File:** security_hardening_results.json
**Line:** 2589
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/services\""`

**File:** security_hardening_results.json
**Line:** 2594
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9090/api/v1/status/config\""`

**File:** security_hardening_results.json
**Line:** 2599
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3000/api/health\""`

**File:** security_hardening_results.json
**Line:** 2604
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/ping\"]"`

**File:** security_hardening_results.json
**Line:** 2609
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/reload\""`

**File:** security_hardening_results.json
**Line:** 2614
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ linkwarden_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2619
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ linkwarden_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2624
**Match:** `localhost`
**Line Content:** `"Local URL: http://localhost:{{ linkwarden_port }}"`

**File:** security_hardening_results.json
**Line:** 2629
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3002/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 2634
**Match:** `localhost`
**Line Content:** `"url: \"http://loki.{{ domain | default('localhost') }}:3100\""`

**File:** security_hardening_results.json
**Line:** 2639
**Match:** `localhost`
**Line Content:** `"url: \"http://grafana.{{ domain | default('localhost') }}:3000/explore\""`

**File:** security_hardening_results.json
**Line:** 2644
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:3100/ready\""`

**File:** security_hardening_results.json
**Line:** 2649
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:9080/ready\""`

**File:** security_hardening_results.json
**Line:** 2654
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}\""`

**File:** security_hardening_results.json
**Line:** 2659
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 2664
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/\""`

**File:** security_hardening_results.json
**Line:** 2669
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/health/\""`

**File:** security_hardening_results.json
**Line:** 2674
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/health/\""`

**File:** security_hardening_results.json
**Line:** 2679
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ alertmanager_port | default(9093) }}/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 2684
**Match:** `localhost`
**Line Content:** `"- { host: \"{{ influxdb_host | default('localhost') }}\", port: \"{{ influxdb_port | default(8086) }}\" }"`

**File:** security_hardening_results.json
**Line:** 2689
**Match:** `localhost`
**Line Content:** `"- { host: \"{{ prometheus_host | default('localhost') }}\", port: \"{{ prometheus_port | default(9090) }}\" }"`

**File:** security_hardening_results.json
**Line:** 2694
**Match:** `localhost`
**Line Content:** `"- { host: \"{{ loki_host | default('localhost') }}\", port: \"{{ loki_port | default(3100) }}\" }"`

**File:** security_hardening_results.json
**Line:** 2699
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 2704
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 2709
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/users/\""`

**File:** security_hardening_results.json
**Line:** 2714
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/users/\""`

**File:** security_hardening_results.json
**Line:** 2719
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/\""`

**File:** security_hardening_results.json
**Line:** 2724
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/\""`

**File:** security_hardening_results.json
**Line:** 2729
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/\""`

**File:** security_hardening_results.json
**Line:** 2734
**Match:** `localhost`
**Line Content:** `"host: \"localhost\""`

**File:** security_hardening_results.json
**Line:** 2739
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 2744
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`

**File:** security_hardening_results.json
**Line:** 2749
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/health/\""`

**File:** security_hardening_results.json
**Line:** 2754
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ alertmanager_port | default(9093) }}/api/v1/status\""`

**File:** security_hardening_results.json
**Line:** 2759
**Match:** `localhost`
**Line Content:** `"paperless_ngx_smtp_host: \"{{ smtp_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2764
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}{{ item.value.healthcheck.test[2] }}\""`

**File:** security_hardening_results.json
**Line:** 2769
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2774
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2779
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ prometheus_port | default(9090) }}/api/v1/targets\""`

**File:** security_hardening_results.json
**Line:** 2784
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ loki_port | default(3100) }}/ready\""`

**File:** security_hardening_results.json
**Line:** 2789
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ prometheus_port | default(9090) }}/api/v1/query?query=up\""`

**File:** security_hardening_results.json
**Line:** 2794
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_players.jellyfin.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2799
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_players.immich.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2804
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2809
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_ports.sabnzbd }}/api?mode=version\""`

**File:** security_hardening_results.json
**Line:** 2814
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_ports.qbittorrent }}/api/v2/app/version\""`

**File:** security_hardening_results.json
**Line:** 2819
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_players.jellyfin.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2824
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}{{ item.value.healthcheck.test[2] }}\""`

**File:** security_hardening_results.json
**Line:** 2829
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_players.jellyfin.port }}/System/Info\""`

**File:** security_hardening_results.json
**Line:** 2834
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_players.immich.port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2839
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2844
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_downloaders.sabnzbd.port }}/api?mode=version\""`

**File:** security_hardening_results.json
**Line:** 2849
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_downloaders.qbittorrent.port }}/api/v2/app/version\""`

**File:** security_hardening_results.json
**Line:** 2854
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_downloaders.sabnzbd.port }}/api\""`

**File:** security_hardening_results.json
**Line:** 2859
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ media_downloaders.qbittorrent.port }}/api/v2/app/version\""`

**File:** security_hardening_results.json
**Line:** 2864
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}{{ item.value.healthcheck.test[2] }}\""`

**File:** security_hardening_results.json
**Line:** 2869
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api?mode=version\"]"`

**File:** security_hardening_results.json
**Line:** 2874
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8081/api/v2/app/version\"]"`

**File:** security_hardening_results.json
**Line:** 2879
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9696/health\"]"`

**File:** security_hardening_results.json
**Line:** 2884
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8989/health\"]"`

**File:** security_hardening_results.json
**Line:** 2889
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:7878/health\"]"`

**File:** security_hardening_results.json
**Line:** 2894
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8686/health\"]"`

**File:** security_hardening_results.json
**Line:** 2899
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8787/health\"]"`

**File:** security_hardening_results.json
**Line:** 2904
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:6767/health\"]"`

**File:** security_hardening_results.json
**Line:** 2909
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8088/health\"]"`

**File:** security_hardening_results.json
**Line:** 2914
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8096/health\"]"`

**File:** security_hardening_results.json
**Line:** 2919
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/api/health\"]"`

**File:** security_hardening_results.json
**Line:** 2924
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`

**File:** security_hardening_results.json
**Line:** 2929
**Match:** `localhost`
**Line Content:** `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3003/health\"]"`

**File:** security_hardening_results.json
**Line:** 2934
**Match:** `localhost`
**Line Content:** `"media_smtp_host: \"{{ smtp_host | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2939
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2944
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/api/v3/system/status\""`

**File:** security_hardening_results.json
**Line:** 2949
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ item.value.port }}/health\""`

**File:** security_hardening_results.json
**Line:** 2954
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:8080/api/health\""`

**File:** security_hardening_results.json
**Line:** 2959
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ authentik_port }}/api/v3/core/applications/\""`

**File:** security_hardening_results.json
**Line:** 2964
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2969
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2974
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`

**File:** security_hardening_results.json
**Line:** 2979
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ homepage_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2984
**Match:** `localhost`
**Line Content:** `"url: \"http://localhost:{{ grafana_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 2989
**Match:** `localhost`
**Line Content:** `"- Homepage API: http://localhost:{{ homepage_port }}/api"`

**File:** security_hardening_results.json
**Line:** 2994
**Match:** `localhost`
**Line Content:** `"- Grafana API: http://localhost:{{ grafana_port }}/api"`

**File:** security_hardening_results.json
**Line:** 3350
**Match:** `localhost`
**Line Content:** `"email: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 3355
**Match:** `localhost`
**Line Content:** `"addresses: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 3820
**Match:** `localhost`
**Line Content:** `"localhost": "{{ ansible_default_ipv4.address }}",`

**File:** security_hardening_results.json
**Line:** 3822
**Match:** `localhost`
**Line Content:** `"admin@localhost": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** security_hardening_results.json
**Line:** 2997
**Match:** `127.0.0.1`
**Line Content:** `"127.0.0.1": [`

**File:** security_hardening_results.json
**Line:** 3001
**Match:** `127.0.0.1`
**Line Content:** `"host    all            all             127.0.0.1/32           md5"`

**File:** security_hardening_results.json
**Line:** 3006
**Match:** `127.0.0.1`
**Line Content:** `"\"metrics-addr\": \"127.0.0.1:9323\","`

**File:** security_hardening_results.json
**Line:** 3011
**Match:** `127.0.0.1`
**Line Content:** `"host: 127.0.0.1"`

**File:** security_hardening_results.json
**Line:** 3016
**Match:** `127.0.0.1`
**Line Content:** `"dig @127.0.0.1 google.com +short"`

**File:** security_hardening_results.json
**Line:** 3021
**Match:** `127.0.0.1`
**Line Content:** `"- \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3026
**Match:** `127.0.0.1`
**Line Content:** `"host    all            all             127.0.0.1/32           md5"`

**File:** security_hardening_results.json
**Line:** 3031
**Match:** `127.0.0.1`
**Line Content:** `"listen_uri: 127.0.0.1:8080"`

**File:** security_hardening_results.json
**Line:** 3036
**Match:** `127.0.0.1`
**Line Content:** `"listen_addr: 127.0.0.1"`

**File:** security_hardening_results.json
**Line:** 3041
**Match:** `127.0.0.1`
**Line Content:** `"- url: \"http://127.0.0.1:{{ immich_ports.server }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 3046
**Match:** `127.0.0.1`
**Line Content:** `"- url: \"http://127.0.0.1:{{ immich_ports.web }}/health\""`

**File:** security_hardening_results.json
**Line:** 3051
**Match:** `127.0.0.1`
**Line Content:** `"- url: \"http://127.0.0.1:{{ immich_ports.machine_learning }}/health\""`

**File:** security_hardening_results.json
**Line:** 3056
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3061
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3066
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ immich_ports.server }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 3071
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ immich_ports.server }}/api/auth/admin-sign-up\""`

**File:** security_hardening_results.json
**Line:** 3076
**Match:** `127.0.0.1`
**Line Content:** `"loop: \"{{ server_ips | default(['127.0.0.1']) }}\""`

**File:** security_hardening_results.json
**Line:** 3081
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3086
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ item.port }}{{ item.path }}\""`

**File:** security_hardening_results.json
**Line:** 3091
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:3567/hello\""`

**File:** security_hardening_results.json
**Line:** 3096
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:9981/health\""`

**File:** security_hardening_results.json
**Line:** 3101
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3106
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3111
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ item.port }}{{ item.path }}\""`

**File:** security_hardening_results.json
**Line:** 3116
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3121
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ ersatztv_port }}\""`

**File:** security_hardening_results.json
**Line:** 3126
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ ersatztv_port }}/api/health\""`

**File:** security_hardening_results.json
**Line:** 3131
**Match:** `127.0.0.1`
**Line Content:** `"ansible.builtin.shell: \"curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:{{ ersatztv_port }}/api/streams\""`

**File:** security_hardening_results.json
**Line:** 3136
**Match:** `127.0.0.1`
**Line Content:** `"ansible.builtin.shell: \"curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:{{ ersatztv_port }}{{ ersatztv_prometheus_path }}\""`

**File:** security_hardening_results.json
**Line:** 3141
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3146
**Match:** `127.0.0.1`
**Line Content:** `"url: \"http://127.0.0.1:{{ ersatztv_port }}\""`

**File:** security_hardening_results.json
**Line:** 3151
**Match:** `127.0.0.1`
**Line Content:** `"- URL: http://127.0.0.1:{{ ersatztv_port }}"`

**File:** security_hardening_results.json
**Line:** 3156
**Match:** `127.0.0.1`
**Line Content:** `"- Web Interface: http://127.0.0.1:{{ ersatztv_port }}"`

**File:** security_hardening_results.json
**Line:** 3161
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3166
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3171
**Match:** `127.0.0.1`
**Line Content:** `"host: \"127.0.0.1\""`

**File:** security_hardening_results.json
**Line:** 3176
**Match:** `127.0.0.1`
**Line Content:** `"docker exec crowdsec cscli decisions list --ip 127.0.0.1"`

**File:** security_hardening_results.json
**Line:** 3821
**Match:** `127.0.0.1`
**Line Content:** `"127.0.0.1": "{{ ansible_default_ipv4.address }}",`

**File:** security_hardening_results.json
**Line:** 3823
**Match:** `127.0.0.1`
**Line Content:** `"admin@127.0.0.1": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** test_logging_infrastructure_report.json
**Line:** 108
**Match:** `localhost`
**Line Content:** `"message": "Loki not accessible: HTTPConnectionPool(host='localhost', port=3100): Max retries exceeded with url: /ready (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x101c35100>: Failed to establish a new connection: [Errno 61] Connection refused'))"`

**File:** tasks/security.yml
**Line:** 524
**Match:** `localhost`
**Line Content:** `mail -s "SECURITY INCIDENT" {{ username }}@localhost 2>/dev/null || true`

**File:** tasks/proxmox.yml
**Line:** 59
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/proxmox.yml
**Line:** 76
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/proxmox.yml
**Line:** 94
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/proxmox.yml
**Line:** 108
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/proxmox.yml
**Line:** 118
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/blackbox_exporter.yml
**Line:** 219
**Match:** `localhost`
**Line Content:** `if ! curl -s "http://{{ ansible_default_ipv4.address }}:/probe?target=localhost&module=http_2xx" > /dev/null; then`

**File:** tasks/grafana.yml
**Line:** 140
**Match:** `localhost`
**Line Content:** `ehlo_identity = localhost`

**File:** tasks/grafana.yml
**Line:** 73
**Match:** `0.0.0.0`
**Line Content:** `http_addr = 0.0.0.0`

**File:** tasks/postgresql.yml
**Line:** 106
**Match:** `0.0.0.0`
**Line Content:** `host    all            all             0.0.0.0/0              md5`

**File:** tasks/sabnzbd.yml
**Line:** 92
**Match:** `0.0.0.0`
**Line Content:** `host = 0.0.0.0`

**File:** tasks/redis.yml
**Line:** 24
**Match:** `0.0.0.0`
**Line Content:** `bind 0.0.0.0`

**File:** tasks/audiobookshelf.yml
**Line:** 23
**Match:** `0.0.0.0`
**Line Content:** `"host": "0.0.0.0",`

**File:** tasks/qbittorrent.yml
**Line:** 110
**Match:** `LocalHost`
**Line Content:** `WebUI\LocalHostAuth=true`

**File:** tasks/kibana.yml
**Line:** 24
**Match:** `0.0.0.0`
**Line Content:** `server.host: "0.0.0.0"`

**File:** tasks/vault.yml
**Line:** 34
**Match:** `0.0.0.0`
**Line Content:** `address = "0.0.0.0:8200"`

**File:** tasks/backup_databases.yml
**Line:** 20
**Match:** `localhost`
**Line Content:** `mongodump --uri="mongodb://{{ item.user }}:{{ item.password }}@{{ item.host | default('localhost') }}:{{ item.port | default('27017') }}/{{ item.name }}" --gzip --archive={{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.archive`

**File:** tasks/backup_databases.yml
**Line:** 26
**Match:** `localhost`
**Line Content:** `redis-cli -h {{ item.host | default('localhost') }} -p {{ item.port | default('6379') }} -a {{ item.password }} SAVE && cp {{ item.rdb_path | default('/var/lib/redis/dump.rdb') }} {{ backup_root_dir | default('/var/backups') }}/databases/redis-{{ ansible_date_time.iso8601_basic_short }}.rdb`

**File:** tasks/watchtower.yml
**Line:** 411
**Match:** `0.0.0.0`
**Line Content:** `- VAULT_ADDR=http://0.0.0.0:8200`

**File:** tasks/watchtower.yml
**Line:** 412
**Match:** `0.0.0.0`
**Line Content:** `- VAULT_API_ADDR=http://0.0.0.0:8200`

**File:** tasks/watchtower.yml
**Line:** 710
**Match:** `0.0.0.0`
**Line Content:** `unauthorized_access=$(docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -E "0.0.0.0:[0-9]+" | grep -v "traefik\|authentik")`

**File:** tasks/test_notifications.yml
**Line:** 285
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/test_notifications.yml
**Line:** 302
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/test_notifications.yml
**Line:** 319
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/test_notifications.yml
**Line:** 329
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/test_notifications.yml
**Line:** 340
**Match:** `localhost`
**Line Content:** `delegate_to: localhost`

**File:** tasks/docker-compose.yml
**Line:** 85
**Match:** `0.0.0.0`
**Line Content:** `- serverIP=0.0.0.0`

**File:** tasks/elasticsearch.yml
**Line:** 31
**Match:** `0.0.0.0`
**Line Content:** `network.host: 0.0.0.0`

**File:** tasks/promtail.yml
**Line:** 60
**Match:** `localhost`
**Line Content:** `- localhost`

**File:** tasks/promtail.yml
**Line:** 69
**Match:** `localhost`
**Line Content:** `- localhost`

**File:** tasks/validate_services.yml
**Line:** 97
**Match:** `localhost`
**Line Content:** `redis-cli -h localhost -p 6379 -a {{ vault_redis_password }} ping`

**File:** tasks/tdarr.yml
**Line:** 23
**Match:** `0.0.0.0`
**Line Content:** `"serverIP": "0.0.0.0",`

**File:** tasks/tdarr.yml
**Line:** 27
**Match:** `0.0.0.0`
**Line Content:** `"nodeIP": "0.0.0.0",`

**File:** tasks/validate/watchtower.yml
**Line:** 31
**Match:** `0.0.0.0`
**Line Content:** `docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -E "0.0.0.0:[0-9]+" | grep -v "traefik\|authentik" | wc -l`

**File:** homepage/deploy_enhanced.sh
**Line:** 791
**Match:** `localhost`
**Line Content:** `log "Access your dashboard at: http://localhost:$HOMEPAGE_PORT"`

**File:** homepage/deploy_enhanced.sh
**Line:** 826
**Match:** `localhost`
**Line Content:** `if curl -s "http://localhost:$HOMEPAGE_PORT" >/dev/null; then`

**File:** homepage/deploy_enhanced.sh
**Line:** 827
**Match:** `localhost`
**Line Content:** `echo -e "${GREEN}✅ Homepage is accessible at http://localhost:$HOMEPAGE_PORT${NC}"`

**File:** homepage/deploy.sh
**Line:** 184
**Match:** `localhost`
**Line Content:** `if curl -f -s http://localhost:3000/health &> /dev/null; then`

**File:** homepage/deploy.sh
**Line:** 203
**Match:** `localhost`
**Line Content:** `echo -e "${BLUE}Dashboard URL:${NC} http://localhost:3000"`

**File:** homepage/scripts/validate_production.py
**Line:** 240
**Match:** `localhost`
**Line Content:** `response = requests.get("http://localhost:3000", timeout=10)`

**File:** homepage/scripts/validate_production.py
**Line:** 260
**Match:** `localhost`
**Line Content:** `response = requests.get("http://localhost:3000", timeout=10)`

**File:** homepage/scripts/validate_production.py
**Line:** 318
**Match:** `localhost`
**Line Content:** `"http://localhost:3000/api/services",`

**File:** homepage/scripts/validate_production.py
**Line:** 319
**Match:** `localhost`
**Line Content:** `"http://localhost:3000/api/widgets"`

**File:** homepage/scripts/service_discovery.py
**Line:** 525
**Match:** `localhost`
**Line Content:** `# Scan localhost for services`

**File:** homepage/scripts/service_discovery.py
**Line:** 528
**Match:** `localhost`
**Line Content:** `response = requests.get(f"http://localhost:{port}", timeout=2)`

**File:** homepage/scripts/service_discovery.py
**Line:** 539
**Match:** `localhost`
**Line Content:** `'ip': 'localhost',`

**File:** tests/integration/test_deployment.yml
**Line:** 174
**Match:** `localhost`
**Line Content:** `host: localhost`

**File:** tests/performance/load_test.yml
**Line:** 101
**Match:** `localhost`
**Line Content:** `PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c "`

**File:** tests/performance/load_test.yml
**Line:** 117
**Match:** `localhost`
**Line Content:** `redis-benchmark -h localhost -p 6379 -a {{ vault_redis_password }} -n 10000 -c 10`

**File:** tests/performance/load_test.yml
**Line:** 125
**Match:** `localhost`
**Line Content:** `PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c "SELECT 1;" &`

**File:** tests/performance/load_test.yml
**Line:** 236
**Match:** `localhost`
**Line Content:** `PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user | default('homelab') }} -d homelab -c "SELECT pg_sleep(1);" &`

**File:** roles/databases/tasks/relational.yml
**Line:** 108
**Match:** `0.0.0.0`
**Line Content:** `host    all            all             0.0.0.0/0              md5`

**File:** roles/databases/tasks/cache.yml
**Line:** 26
**Match:** `0.0.0.0`
**Line Content:** `bind 0.0.0.0`

**File:** roles/databases/tasks/cache.yml
**Line:** 289
**Match:** `0.0.0.0`
**Line Content:** `bind 0.0.0.0`

**File:** roles/databases/tasks/search.yml
**Line:** 180
**Match:** `localhost`
**Line Content:** `if ! curl -s -f "localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME" > /dev/null; then`

**File:** roles/databases/tasks/search.yml
**Line:** 186
**Match:** `localhost`
**Line Content:** `curl -X POST "localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME/_restore?wait_for_completion=true"`

**File:** roles/databases/tasks/search.yml
**Line:** 219
**Match:** `localhost`
**Line Content:** `curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq .`

**File:** roles/databases/tasks/search.yml
**Line:** 234
**Match:** `localhost`
**Line Content:** `curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq .`

**File:** roles/databases/tasks/search.yml
**Line:** 237
**Match:** `localhost`
**Line Content:** `curl -s "localhost:{{ elasticsearch_port }}/_cat/indices?v" | jq .`

**File:** roles/databases/tasks/search.yml
**Line:** 260
**Match:** `localhost`
**Line Content:** `if ! curl -s -f "localhost:{{ elasticsearch_port }}/_cluster/health" > /dev/null 2>&1; then`

**File:** roles/databases/tasks/search.yml
**Line:** 266
**Match:** `localhost`
**Line Content:** `STATUS=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .status)`

**File:** roles/databases/tasks/search.yml
**Line:** 606
**Match:** `localhost`
**Line Content:** `HEALTH=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .status)`

**File:** roles/databases/tasks/search.yml
**Line:** 609
**Match:** `localhost`
**Line Content:** `NODES=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .number_of_nodes)`

**File:** roles/databases/tasks/search.yml
**Line:** 612
**Match:** `localhost`
**Line Content:** `INDICES=$(curl -s "localhost:{{ elasticsearch_port }}/_cat/indices?v" | wc -l)`

**File:** roles/databases/tasks/search.yml
**Line:** 615
**Match:** `localhost`
**Line Content:** `UNASSIGNED_SHARDS=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .unassigned_shards)`

**File:** roles/databases/tasks/search.yml
**Line:** 658
**Match:** `localhost`
**Line Content:** `HEALTH=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health")`

**File:** roles/databases/tasks/search.yml
**Line:** 668
**Match:** `localhost`
**Line Content:** `NODE_STATS=$(curl -s "localhost:{{ elasticsearch_port }}/_nodes/stats")`

**File:** roles/databases/tasks/search.yml
**Line:** 33
**Match:** `0.0.0.0`
**Line Content:** `network.host: 0.0.0.0`

**File:** roles/databases/tasks/search.yml
**Line:** 343
**Match:** `0.0.0.0`
**Line Content:** `server.host: "0.0.0.0"`

**File:** roles/databases/defaults/main.yml
**Line:** 200
**Match:** `0.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 203
**Match:** `0.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 206
**Match:** `0.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 209
**Match:** `0.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 212
**Match:** `0.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/security/vpn/tasks/deploy.yml
**Line:** 53
**Match:** `0.0.0.0`
**Line Content:** `AllowedIPs = 0.0.0.0/0`

**File:** roles/fing/tasks/validate_deployment.yml
**Line:** 278
**Match:** `localhost`
**Line Content:** `host: "localhost"`

**File:** roles/fing/tasks/deploy.yml
**Line:** 190
**Match:** `localhost`
**Line Content:** `host: "localhost"`

**File:** roles/fing/defaults/main.yml
**Line:** 44
**Match:** `0.0.0.0`
**Line Content:** `- "10.0.0.0/8"`

**File:** roles/fing/defaults/main.yml
**Line:** 224
**Match:** `0.0.0.0`
**Line Content:** `fing_debug_host: "0.0.0.0"`

**File:** roles/dumbassets/deploy.sh
**Line:** 186
**Match:** `localhost`
**Line Content:** `• Local Access: http://localhost:3004`

**File:** roles/grafana/defaults/main.yml
**Line:** 183
**Match:** `localhost`
**Line Content:** `email: "admin@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 188
**Match:** `localhost`
**Line Content:** `email: "viewer@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 193
**Match:** `localhost`
**Line Content:** `email: "editor@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 202
**Match:** `localhost`
**Line Content:** `email: "admins@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 206
**Match:** `localhost`
**Line Content:** `email: "viewers@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 210
**Match:** `localhost`
**Line Content:** `email: "editors@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 231
**Match:** `localhost`
**Line Content:** `addresses: "admin@{{ domain | default('localhost') }}"`

**File:** roles/grafana/scripts/grafana_automation.py
**Line:** 946
**Match:** `localhost`
**Line Content:** `url=args.url or "http://localhost:3000",`

**File:** roles/vaultwarden/defaults/main.yml
**Line:** 49
**Match:** `0.0.0.0`
**Line Content:** `- WEBSOCKET_ADDRESS=0.0.0.0`

**File:** roles/vaultwarden/defaults/main.yml
**Line:** 58
**Match:** `0.0.0.0`
**Line Content:** `- ROCKET_ADDRESS=0.0.0.0`

**File:** roles/paperless_ngx/tasks/validate.yml
**Line:** 134
**Match:** `localhost`
**Line Content:** `- { host: "{{ loki_host | default('localhost') }}", port: "{{ loki_port | default(3100) }}" }`

**File:** roles/paperless_ngx/tasks/deploy.yml
**Line:** 205
**Match:** `localhost`
**Line Content:** `host: "localhost"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 246
**Match:** `0.0.0.0`
**Line Content:** `paperless_ngx_debug_host: "0.0.0.0"`

**File:** roles/media/defaults/main.yml
**Line:** 567
**Match:** `localhost`
**Line Content:** `media_smtp_host: "{{ smtp_host | default('localhost') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 608
**Match:** `0.0.0.0`
**Line Content:** `media_debug_host: "0.0.0.0"`

**File:** scripts/comprehensive_automation.py
**Line:** 138
**Match:** `localhost`
**Line Content:** `discovery = {service_name.title()}Discovery("localhost", 8080)`

**File:** scripts/jellyfin_discovery.py
**Line:** 72
**Match:** `localhost`
**Line Content:** `discovery = JellyfinDiscovery("localhost", 8080)`

**File:** scripts/test_automation_improvements.py
**Line:** 27
**Match:** `localhost`
**Line Content:** `self.assertTrue(InputValidator.validate_url("http://localhost:3000"))`

**File:** scripts/security_hardening.py
**Line:** 32
**Match:** `localhost`
**Line Content:** `'localhost': [`

**File:** scripts/security_hardening.py
**Line:** 33
**Match:** `localhost`
**Line Content:** `r'localhost',`

**File:** scripts/security_hardening.py
**Line:** 220
**Match:** `localhost`
**Line Content:** `elif category == 'localhost':`

**File:** scripts/service_wizard.py
**Line:** 427
**Match:** `localhost`
**Line Content:** `database_host = input(f"Database host [localhost]: ") or "localhost"`

**File:** scripts/service_wizard.py
**Line:** 427
**Match:** `localhost`
**Line Content:** `database_host = input(f"Database host [localhost]: ") or "localhost"`

**File:** scripts/service_wizard.py
**Line:** 950
**Match:** `localhost`
**Line Content:** `{service_info.name}_domain: "{service_info.name}.{{{{ domain | default('localhost') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 969
**Match:** `localhost`
**Line Content:** `{service_info.name}_database_host: "{{{{ postgresql_host | default('localhost') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1266
**Match:** `localhost`
**Line Content:** `url: "http://localhost:{{{{ {service_info.name}_external_port }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1548
**Match:** `localhost`
**Line Content:** `url: "http://localhost:{{{{ homepage_port | default(3000) }}}}/api/reload"`

**File:** scripts/service_wizard.py
**Line:** 1612
**Match:** `localhost`
**Line Content:** `test: ["CMD-SHELL", "curl -f http://localhost:{{{{ {service_name}_internal_port }}}}/ || exit 1"]`

**File:** scripts/service_wizard.py
**Line:** 1674
**Match:** `localhost`
**Line Content:** `- targets: ['localhost:{{{{ {service_info.name}_external_port }}}}']`

**File:** scripts/service_wizard.py
**Line:** 2223
**Match:** `localhost`
**Line Content:** `return common_config.get('domain', 'localhost')`

**File:** scripts/service_wizard.py
**Line:** 2225
**Match:** `localhost`
**Line Content:** `return 'localhost'`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 19
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 19
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 20
**Match:** `127.0.0.1`
**Line Content:** `'127.0.0.1': r'127\.0\.0\.1',`

**File:** scripts/enhanced_health_check.sh
**Line:** 272
**Match:** `localhost`
**Line Content:** `["traefik"]="http://localhost:8080/api/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 273
**Match:** `localhost`
**Line Content:** `["authentik"]="http://localhost:9000/if/user/"`

**File:** scripts/enhanced_health_check.sh
**Line:** 274
**Match:** `localhost`
**Line Content:** `["grafana"]="http://localhost:3000/api/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 275
**Match:** `localhost`
**Line Content:** `["prometheus"]="http://localhost:9090/-/healthy"`

**File:** scripts/enhanced_health_check.sh
**Line:** 276
**Match:** `localhost`
**Line Content:** `["influxdb"]="http://localhost:8086/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 277
**Match:** `localhost`
**Line Content:** `["loki"]="http://localhost:3100/ready"`

**File:** scripts/enhanced_health_check.sh
**Line:** 278
**Match:** `localhost`
**Line Content:** `["alertmanager"]="http://localhost:9093/-/healthy"`

**File:** scripts/enhanced_health_check.sh
**Line:** 279
**Match:** `localhost`
**Line Content:** `["postgresql"]="localhost:5432"`

**File:** scripts/enhanced_health_check.sh
**Line:** 280
**Match:** `localhost`
**Line Content:** `["redis"]="localhost:6379"`

**File:** scripts/enhanced_health_check.sh
**Line:** 281
**Match:** `localhost`
**Line Content:** `["sonarr"]="http://localhost:8989/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 282
**Match:** `localhost`
**Line Content:** `["radarr"]="http://localhost:7878/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 283
**Match:** `localhost`
**Line Content:** `["jellyfin"]="http://localhost:8096/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 284
**Match:** `localhost`
**Line Content:** `["nextcloud"]="http://localhost:8080/status.php"`

**File:** scripts/enhanced_health_check.sh
**Line:** 285
**Match:** `localhost`
**Line Content:** `["paperless"]="http://localhost:8010/health"`

**File:** scripts/enhanced_health_check.sh
**Line:** 286
**Match:** `localhost`
**Line Content:** `["fing"]="http://localhost:8080/health"`

**File:** scripts/prometheus_discovery.py
**Line:** 72
**Match:** `localhost`
**Line Content:** `discovery = PrometheusDiscovery("localhost", 8080)`

**File:** scripts/targeted_replacement.py
**Line:** 20
**Match:** `localhost`
**Line Content:** `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/targeted_replacement.py
**Line:** 27
**Match:** `localhost`
**Line Content:** `# localhost in health checks - make configurable`

**File:** scripts/targeted_replacement.py
**Line:** 28
**Match:** `localhost`
**Line Content:** `r'localhost:(\d+)': '{{ ansible_default_ipv4.address }}:\1',`

**File:** scripts/targeted_replacement.py
**Line:** 31
**Match:** `localhost`
**Line Content:** `r'http://localhost:': 'http://{{ ansible_default_ipv4.address }}:',`

**File:** scripts/targeted_replacement.py
**Line:** 32
**Match:** `localhost`
**Line Content:** `r'https://localhost:': 'https://{{ ansible_default_ipv4.address }}:',`

**File:** scripts/targeted_replacement.py
**Line:** 150
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/targeted_replacement.py
**Line:** 150
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/targeted_replacement.py
**Line:** 24
**Match:** `127.0.0.1`
**Line Content:** `# 127.0.0.1 references - replace with dynamic IP`

**File:** scripts/targeted_replacement.py
**Line:** 151
**Match:** `127.0.0.1`
**Line Content:** `'127.0.0.1': r'127\.0\.0\.1',`

**File:** scripts/plex_discovery.py
**Line:** 72
**Match:** `localhost`
**Line Content:** `discovery = PlexDiscovery("localhost", 8080)`

**File:** scripts/test_logging_infrastructure.py
**Line:** 288
**Match:** `localhost`
**Line Content:** `response = requests.get('http://localhost:3100/ready', timeout=5)`

**File:** scripts/test_logging_infrastructure.py
**Line:** 298
**Match:** `localhost`
**Line Content:** `'http://localhost:3100/loki/api/v1/query_range',`

**File:** scripts/radarr_discovery.py
**Line:** 72
**Match:** `localhost`
**Line Content:** `discovery = RadarrDiscovery("localhost", 8080)`

**File:** scripts/test_deployment.sh
**Line:** 231
**Match:** `localhost`
**Line Content:** `if timeout 10 bash -c "</dev/tcp/localhost/5432" 2>/dev/null; then`

**File:** scripts/test_deployment.sh
**Line:** 242
**Match:** `localhost`
**Line Content:** `if timeout 10 bash -c "</dev/tcp/localhost/6379" 2>/dev/null; then`

**File:** scripts/test_deployment.sh
**Line:** 253
**Match:** `localhost`
**Line Content:** `if timeout 10 bash -c "</dev/tcp/localhost/3306" 2>/dev/null; then`

**File:** scripts/test_deployment.sh
**Line:** 273
**Match:** `localhost`
**Line Content:** `test_http_endpoint "Prometheus" "http://localhost:9090/-/healthy" "200"`

**File:** scripts/test_deployment.sh
**Line:** 278
**Match:** `localhost`
**Line Content:** `test_http_endpoint "Grafana" "http://localhost:3000/api/health" "200"`

**File:** scripts/test_deployment.sh
**Line:** 283
**Match:** `localhost`
**Line Content:** `test_http_endpoint "Loki" "http://localhost:3100/ready" "200"`

**File:** scripts/test_deployment.sh
**Line:** 288
**Match:** `localhost`
**Line Content:** `test_http_endpoint "AlertManager" "http://localhost:9093/-/healthy" "200"`

**File:** scripts/validate_hardcoded.py
**Line:** 18
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/validate_hardcoded.py
**Line:** 18
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/validate_hardcoded.py
**Line:** 19
**Match:** `127.0.0.1`
**Line Content:** `'127.0.0.1': r'127\.0\.0\.1',`

**File:** scripts/validate_infrastructure.py
**Line:** 254
**Match:** `localhost`
**Line Content:** `with urllib.request.urlopen("http://localhost:8080/api/health", timeout=10) as response:`

**File:** scripts/validate_infrastructure.py
**Line:** 266
**Match:** `localhost`
**Line Content:** `with urllib.request.urlopen("http://localhost:8080/api/http/certresolvers", timeout=10) as response:`

**File:** scripts/grafana_discovery.py
**Line:** 72
**Match:** `localhost`
**Line Content:** `discovery = GrafanaDiscovery("localhost", 8080)`

**File:** scripts/fix_vault_variables.sh
**Line:** 289
**Match:** `localhost`
**Line Content:** `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 290
**Match:** `localhost`
**Line Content:** `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`

**File:** scripts/sonarr_discovery.py
**Line:** 72
**Match:** `localhost`
**Line Content:** `discovery = SonarrDiscovery("localhost", 8080)`

**File:** scripts/systematic_replacement.py
**Line:** 20
**Match:** `localhost`
**Line Content:** `r'localhost': '{{ ansible_default_ipv4.address }}',`

**File:** scripts/systematic_replacement.py
**Line:** 24
**Match:** `localhost`
**Line Content:** `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/systematic_replacement.py
**Line:** 167
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/systematic_replacement.py
**Line:** 167
**Match:** `localhost`
**Line Content:** `'localhost': r'localhost',`

**File:** scripts/systematic_replacement.py
**Line:** 168
**Match:** `127.0.0.1`
**Line Content:** `'127.0.0.1': r'127\.0\.0\.1',`

**File:** scripts/homepage_automation.py
**Line:** 438
**Match:** `localhost`
**Line Content:** `def __init__(self, config_path: str = "config", domain: str = "localhost"):`

**File:** scripts/homepage_automation.py
**Line:** 878
**Match:** `localhost`
**Line Content:** `parser.add_argument('--domain', default='localhost', help='Domain name for service URLs')`

**File:** scripts/service_discovery/harbor_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = HarborDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/code_server_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = Code_ServerDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/crowdsec_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = CrowdsecDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/immich_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = ImmichDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/jellyfin_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = JellyfinDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/vault_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = VaultDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/blackbox_exporter_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = Blackbox_ExporterDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/prometheus_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = PrometheusDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/plex_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = PlexDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/portainer_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = PortainerDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/promtail_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = PromtailDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/radarr_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = RadarrDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/emby_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = EmbyDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/pihole_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = PiholeDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/alertmanager_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = AlertmanagerDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/loki_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = LokiDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/telegraf_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = TelegrafDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/komga_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = KomgaDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/fail2ban_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = Fail2BanDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/calibre_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = CalibreDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/nextcloud_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = NextcloudDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/sonarr_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = SonarrDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/audiobookshelf_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = AudiobookshelfDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/gitlab_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = GitlabDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/wireguard_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = WireguardDiscovery("localhost", 8080)`

**File:** scripts/service_discovery/influxdb_discovery.py
**Line:** 71
**Match:** `localhost`
**Line Content:** `discovery = InfluxdbDiscovery("localhost", 8080)`

### Admin (95 issues)

**File:** security_hardening_results.json
**Line:** 2274
**Match:** `admin@{{`
**Line Content:** `"email: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 2304
**Match:** `admin@{{`
**Line Content:** `"addresses: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 3300
**Match:** `admin@'`
**Line Content:** `"- Username: {{ vault_npm_admin_username | default('admin@' + domain) }}"`

**File:** security_hardening_results.json
**Line:** 3305
**Match:** `admin@'`
**Line Content:** `"admin_email: \"{{ lookup('env', 'ADMIN_EMAIL') | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3310
**Match:** `admin@'`
**Line Content:** `"ssl_email: \"{{ lookup('env', 'SSL_EMAIL') | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3315
**Match:** `admin@'`
**Line Content:** `"from_address: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3320
**Match:** `admin@'`
**Line Content:** `"- \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3325
**Match:** `admin@yourdomain.com`
**Line Content:** `"to: admin@yourdomain.com"`

**File:** security_hardening_results.json
**Line:** 3330
**Match:** `admin@{{`
**Line Content:** `"notification_recipient: \"admin@{{ domain }}\""`

**File:** security_hardening_results.json
**Line:** 3335
**Match:** `admin@'`
**Line Content:** `"immich_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3340
**Match:** `admin@'`
**Line Content:** `"fing_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3345
**Match:** `admin@'`
**Line Content:** `"pezzo_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3350
**Match:** `admin@{{`
**Line Content:** `"email: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 3355
**Match:** `admin@{{`
**Line Content:** `"addresses: \"admin@{{ domain | default('localhost') }}\""`

**File:** security_hardening_results.json
**Line:** 3360
**Match:** `admin@'`
**Line Content:** `"ersatztv_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3365
**Match:** `admin@'`
**Line Content:** `"n8n_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3370
**Match:** `admin@'`
**Line Content:** `"romm_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3375
**Match:** `admin@'`
**Line Content:** `"vaultwarden_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3380
**Match:** `admin@'`
**Line Content:** `"linkwarden_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3385
**Match:** `admin@'`
**Line Content:** `"paperless_ngx_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3390
**Match:** `admin@'`
**Line Content:** `"media_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3395
**Match:** `admin@'`
**Line Content:** `"nginx_proxy_manager_api_username: \"{{ vault_npm_admin_username | default('admin@' + domain) }}\""`

**File:** security_hardening_results.json
**Line:** 3815
**Match:** `admin@\`
**Line Content:** `"vault_admin_email": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** security_hardening_results.json
**Line:** 3817
**Match:** `admin@\`
**Line Content:** `"vault_ssl_email": "{{ ssl_email | default(\"admin@\" + domain) }}"`

**File:** security_hardening_results.json
**Line:** 3822
**Match:** `admin@localhost`
**Line Content:** `"admin@localhost": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** security_hardening_results.json
**Line:** 3822
**Match:** `admin@\`
**Line Content:** `"admin@localhost": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** security_hardening_results.json
**Line:** 3823
**Match:** `admin@127.0.0.1`
**Line Content:** `"admin@127.0.0.1": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** security_hardening_results.json
**Line:** 3823
**Match:** `admin@\`
**Line Content:** `"admin@127.0.0.1": "{{ admin_email | default(\"admin@\" + domain) }}",`

**File:** security_hardening_results.json
**Line:** 1339
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}\"`
**Line Content:** `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\""`

**File:** tasks/nginx_proxy_manager.yml
**Line:** 67
**Match:** `admin@'`
**Line Content:** `- Username: {{ vault_npm_admin_username | default('admin@' + domain) }}`

**File:** tasks/validate_services.yml
**Line:** 136
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}"`
**Line Content:** `Authorization: "Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}"`

**File:** group_vars/all/vars.yml
**Line:** 753
**Match:** `admin@'`
**Line Content:** `admin_email: "{{ lookup('env', 'ADMIN_EMAIL') | default('admin@' + domain) }}"`

**File:** group_vars/all/vars.yml
**Line:** 992
**Match:** `admin@'`
**Line Content:** `ssl_email: "{{ lookup('env', 'SSL_EMAIL') | default('admin@' + domain) }}"`

**File:** group_vars/all/notifications.yml
**Line:** 16
**Match:** `admin@'`
**Line Content:** `from_address: "{{ admin_email | default('admin@' + domain) }}"`

**File:** group_vars/all/notifications.yml
**Line:** 18
**Match:** `admin@'`
**Line Content:** `- "{{ admin_email | default('admin@' + domain) }}"`

**File:** group_vars/all/vault.yml
**Line:** 15
**Match:** `admin@'`
**Line Content:** `authentik_admin_email: "{{ vault_authentik_admin_email | default('admin@' + domain) }}"`

**File:** group_vars/all/vault.yml
**Line:** 34
**Match:** `admin@'`
**Line Content:** `admin_email: "{{ vault_admin_email | default('admin@' + domain) }}"`

**File:** group_vars/all/vault.yml
**Line:** 196
**Match:** `admin@'`
**Line Content:** `vault_authentik_admin_email: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_EMAIL') | default('admin@' + domain) }}"`

**File:** group_vars/all/vault.yml
**Line:** 213
**Match:** `admin@{{`
**Line Content:** `vault_npm_admin_username: "admin@{{ domain }}"`

**File:** group_vars/all/vault.yml
**Line:** 218
**Match:** `admin@'`
**Line Content:** `vault_letsencrypt_email: "{{ vault_letsencrypt_email | default('admin@' + domain) }}"`

**File:** group_vars/all/vault.yml.template
**Line:** 67
**Match:** `admin@yourdomain.com`
**Line Content:** `vault_authentik_admin_email: "admin@yourdomain.com"`

**File:** tests/performance/load_test.yml
**Line:** 177
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}"`
**Line Content:** `time curl -s "http://{{ ansible_default_ipv4.address }}:/api/dashboards" -H "Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}"`

**File:** roles/certificate_management/vars/main.yml
**Line:** 25
**Match:** `admin@{{`
**Line Content:** `notification_recipient: "admin@{{ domain }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 26
**Match:** `admin@'`
**Line Content:** `fing_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 26
**Match:** `admin@'`
**Line Content:** `pezzo_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 183
**Match:** `admin@{{`
**Line Content:** `email: "admin@{{ domain | default('localhost') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 231
**Match:** `admin@{{`
**Line Content:** `addresses: "admin@{{ domain | default('localhost') }}"`

**File:** roles/grafana/scripts/grafana_automation.py
**Line:** 840
**Match:** `admin@example.com`
**Line Content:** `"email": "admin@example.com",`

**File:** roles/grafana/scripts/grafana_automation.py
**Line:** 862
**Match:** `admin@example.com`
**Line Content:** `"addresses": "admin@example.com"`

**File:** roles/grafana/scripts/config/notification_channels.json
**Line:** 9
**Match:** `admin@homelab.local`
**Line Content:** `"addresses": "admin@homelab.local"`

**File:** roles/radarr/defaults/main.yml
**Line:** 49
**Match:** `admin@'`
**Line Content:** `radarr_ssl_email: "{{ vault_ssl_email | default('admin@' + domain) }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 126
**Match:** `admin@'`
**Line Content:** `radarr_smtp_from: "{{ radarr_admin_email | default('admin@' + domain) }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 127
**Match:** `admin@'`
**Line Content:** `radarr_smtp_to: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 270
**Match:** `admin@'`
**Line Content:** `radarr_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/ersatztv/defaults/main.yml
**Line:** 50
**Match:** `admin@'`
**Line Content:** `ersatztv_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/n8n/defaults/main.yml
**Line:** 24
**Match:** `admin@'`
**Line Content:** `n8n_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 33
**Match:** `admin@'`
**Line Content:** `romm_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/vaultwarden/defaults/main.yml
**Line:** 24
**Match:** `admin@'`
**Line Content:** `vaultwarden_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/linkwarden/defaults/main.yml
**Line:** 24
**Match:** `admin@'`
**Line Content:** `linkwarden_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 49
**Match:** `admin@'`
**Line Content:** `sonarr_ssl_email: "{{ vault_ssl_email | default('admin@' + domain) }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 126
**Match:** `admin@'`
**Line Content:** `sonarr_smtp_from: "{{ sonarr_admin_email | default('admin@' + domain) }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 127
**Match:** `admin@'`
**Line Content:** `sonarr_smtp_to: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 270
**Match:** `admin@'`
**Line Content:** `sonarr_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 26
**Match:** `admin@'`
**Line Content:** `paperless_ngx_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/media/defaults/main.yml
**Line:** 58
**Match:** `admin@'`
**Line Content:** `media_admin_email: "{{ admin_email | default('admin@' + domain) }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 61
**Match:** `admin@'`
**Line Content:** `nginx_proxy_manager_api_username: "{{ vault_npm_admin_username | default('admin@' + domain) }}"`

**File:** scripts/setup_vault_env.sh
**Line:** 100
**Match:** `admin@zorg.media):`
**Line Content:** `read -p "Enter admin email address (default: admin@zorg.media): " admin_email`

**File:** scripts/setup_vault_env.sh
**Line:** 101
**Match:** `admin@zorg.media}`
**Line Content:** `admin_email=${admin_email:-admin@zorg.media}`

**File:** scripts/security_hardening.py
**Line:** 38
**Match:** `admin@[^`
**Line Content:** `r'admin@[^"\s]+',`

**File:** scripts/security_hardening.py
**Line:** 225
**Match:** `admin@'`
**Line Content:** `suggestions.append("Example: `admin: \"{{ admin_email | default('admin@' + domain) }}\"`")`

**File:** scripts/service_wizard.py
**Line:** 411
**Match:** `admin@{domain}]:`
**Line Content:** `admin_email = input(f"Admin email for {display_name} [admin@{domain}]: ") or f"admin@{domain}"`

**File:** scripts/service_wizard.py
**Line:** 411
**Match:** `admin@{domain}`
**Line Content:** `admin_email = input(f"Admin email for {display_name} [admin@{domain}]: ") or f"admin@{domain}"`

**File:** scripts/service_wizard.py
**Line:** 959
**Match:** `admin@'`
**Line Content:** `{service_info.name}_admin_email: "{{{{ admin_email | default('admin@' + domain) }}}}"`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 21
**Match:** `admin@':`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 21
**Match:** `admin@[^`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/setup_monitoring_env.sh
**Line:** 21
**Match:** `admin@zorg.media`
**Line Content:** `ADMIN_EMAIL=$(prompt_with_default "ADMIN_EMAIL" "admin@zorg.media" "Enter admin email address")`

**File:** scripts/targeted_replacement.py
**Line:** 20
**Match:** `admin@localhost':`
**Line Content:** `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/targeted_replacement.py
**Line:** 21
**Match:** `admin@127\.0\.0\.1':`
**Line Content:** `r'admin@127\.0\.0\.1': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/targeted_replacement.py
**Line:** 22
**Match:** `admin@yourdomain\.com':`
**Line Content:** `r'admin@yourdomain\.com': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/targeted_replacement.py
**Line:** 152
**Match:** `admin@':`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/targeted_replacement.py
**Line:** 152
**Match:** `admin@[^`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/validate_hardcoded.py
**Line:** 20
**Match:** `admin@':`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/validate_hardcoded.py
**Line:** 20
**Match:** `admin@[^`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/fix_vault_variables.sh
**Line:** 289
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}\"`
**Line Content:** `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 290
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}\"`
**Line Content:** `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 295
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}\"`
**Line Content:** `"Authorization: \"Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 296
**Match:** `admin:' + vault_grafana_admin_password) | b64encode }}\"`
**Line Content:** `"Authorization: \"Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`

**File:** scripts/systematic_replacement.py
**Line:** 24
**Match:** `admin@localhost':`
**Line Content:** `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/systematic_replacement.py
**Line:** 25
**Match:** `admin@127\.0\.0\.1':`
**Line Content:** `r'admin@127\.0\.0\.1': '{{ admin_email | default("admin@" + domain) }}',`

**File:** scripts/systematic_replacement.py
**Line:** 169
**Match:** `admin@':`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/systematic_replacement.py
**Line:** 169
**Match:** `admin@[^`
**Line Content:** `'admin@': r'admin@[^"\s]+',`

**File:** scripts/setup_notifications.sh
**Line:** 73
**Match:** `admin@$(hostname`
**Line Content:** `admin_email=$(prompt_with_default "Admin Email" "admin@$(hostname -d)" "admin_email")`

**File:** scripts/seamless_setup.sh
**Line:** 239
**Match:** `admin@$domain):`
**Line Content:** `read -p "Enter admin email address (default: admin@$domain): " admin_email`

**File:** scripts/seamless_setup.sh
**Line:** 240
**Match:** `admin@$domain}`
**Line Content:** `admin_email=${admin_email:-admin@$domain}`

**File:** scripts/seamless_setup.sh
**Line:** 2044
**Match:** `admin@$domain`
**Line Content:** `- Nginx Proxy Manager: admin@$domain / (see credentials backup)`

### Changeme (34 issues)

**File:** security_hardening_results.json
**Line:** 3398
**Match:** `changeme`
**Line Content:** `"changeme": [],`

**File:** security_hardening_results.json
**Line:** 3824
**Match:** `changeme`
**Line Content:** `"changeme": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`

**File:** security_hardening_results.json
**Line:** 3398
**Match:** `changeme`
**Line Content:** `"changeme": [],`

**File:** security_hardening_results.json
**Line:** 3824
**Match:** `changeme`
**Line Content:** `"changeme": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`

**File:** scripts/security_hardening.py
**Line:** 42
**Match:** `changeme`
**Line Content:** `'changeme': [`

**File:** scripts/security_hardening.py
**Line:** 43
**Match:** `changeme`
**Line Content:** `r'changeme',`

**File:** scripts/security_hardening.py
**Line:** 44
**Match:** `CHANGEME`
**Line Content:** `r'CHANGEME',`

**File:** scripts/security_hardening.py
**Line:** 226
**Match:** `changeme`
**Line Content:** `elif category == 'changeme':`

**File:** scripts/security_hardening.py
**Line:** 42
**Match:** `changeme`
**Line Content:** `'changeme': [`

**File:** scripts/security_hardening.py
**Line:** 43
**Match:** `changeme`
**Line Content:** `r'changeme',`

**File:** scripts/security_hardening.py
**Line:** 44
**Match:** `CHANGEME`
**Line Content:** `r'CHANGEME',`

**File:** scripts/security_hardening.py
**Line:** 226
**Match:** `changeme`
**Line Content:** `elif category == 'changeme':`

**File:** scripts/security_hardening.py
**Line:** 45
**Match:** `change_me`
**Line Content:** `r'change_me',`

**File:** scripts/security_hardening.py
**Line:** 46
**Match:** `CHANGE_ME`
**Line Content:** `r'CHANGE_ME',`

**File:** scripts/security_hardening.py
**Line:** 45
**Match:** `change_me`
**Line Content:** `r'change_me',`

**File:** scripts/security_hardening.py
**Line:** 46
**Match:** `CHANGE_ME`
**Line Content:** `r'CHANGE_ME',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 22
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 22
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 22
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 22
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/targeted_replacement.py
**Line:** 153
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/targeted_replacement.py
**Line:** 153
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/targeted_replacement.py
**Line:** 153
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/targeted_replacement.py
**Line:** 153
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/validate_hardcoded.py
**Line:** 21
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/validate_hardcoded.py
**Line:** 21
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/validate_hardcoded.py
**Line:** 21
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/validate_hardcoded.py
**Line:** 21
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/systematic_replacement.py
**Line:** 28
**Match:** `changeme`
**Line Content:** `r'changeme': '{{ vault_admin_password | password_hash("bcrypt") }}',`

**File:** scripts/systematic_replacement.py
**Line:** 170
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/systematic_replacement.py
**Line:** 170
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/systematic_replacement.py
**Line:** 28
**Match:** `changeme`
**Line Content:** `r'changeme': '{{ vault_admin_password | password_hash("bcrypt") }}',`

**File:** scripts/systematic_replacement.py
**Line:** 170
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

**File:** scripts/systematic_replacement.py
**Line:** 170
**Match:** `changeme`
**Line Content:** `'changeme': r'changeme',`

### Admin123 (36 issues)

**File:** security_hardening_results.json
**Line:** 3399
**Match:** `admin123`
**Line Content:** `"admin123": [],`

**File:** security_hardening_results.json
**Line:** 3825
**Match:** `admin123`
**Line Content:** `"admin123": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`

**File:** security_hardening_results.json
**Line:** 3399
**Match:** `admin123`
**Line Content:** `"admin123": [],`

**File:** security_hardening_results.json
**Line:** 3825
**Match:** `admin123`
**Line Content:** `"admin123": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`

**File:** roles/grafana/scripts/grafana_automation.py
**Line:** 841
**Match:** `admin123`
**Line Content:** `"password": "admin123",`

**File:** roles/grafana/scripts/grafana_automation.py
**Line:** 841
**Match:** `admin123`
**Line Content:** `"password": "admin123",`

**File:** scripts/security_hardening.py
**Line:** 48
**Match:** `admin123`
**Line Content:** `'admin123': [`

**File:** scripts/security_hardening.py
**Line:** 49
**Match:** `admin123`
**Line Content:** `r'admin123',`

**File:** scripts/security_hardening.py
**Line:** 50
**Match:** `ADMIN123`
**Line Content:** `r'ADMIN123',`

**File:** scripts/security_hardening.py
**Line:** 229
**Match:** `admin123`
**Line Content:** `elif category == 'admin123':`

**File:** scripts/security_hardening.py
**Line:** 48
**Match:** `admin123`
**Line Content:** `'admin123': [`

**File:** scripts/security_hardening.py
**Line:** 49
**Match:** `admin123`
**Line Content:** `r'admin123',`

**File:** scripts/security_hardening.py
**Line:** 50
**Match:** `ADMIN123`
**Line Content:** `r'ADMIN123',`

**File:** scripts/security_hardening.py
**Line:** 229
**Match:** `admin123`
**Line Content:** `elif category == 'admin123':`

**File:** scripts/security_hardening.py
**Line:** 51
**Match:** `password123`
**Line Content:** `r'password123',`

**File:** scripts/security_hardening.py
**Line:** 52
**Match:** `PASSWORD123`
**Line Content:** `r'PASSWORD123',`

**File:** scripts/security_hardening.py
**Line:** 51
**Match:** `password123`
**Line Content:** `r'password123',`

**File:** scripts/security_hardening.py
**Line:** 52
**Match:** `PASSWORD123`
**Line Content:** `r'PASSWORD123',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 23
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 23
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 23
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 23
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/targeted_replacement.py
**Line:** 154
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/targeted_replacement.py
**Line:** 154
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/targeted_replacement.py
**Line:** 154
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/targeted_replacement.py
**Line:** 154
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/validate_hardcoded.py
**Line:** 22
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/validate_hardcoded.py
**Line:** 22
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/validate_hardcoded.py
**Line:** 22
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/validate_hardcoded.py
**Line:** 22
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/systematic_replacement.py
**Line:** 29
**Match:** `admin123`
**Line Content:** `r'admin123': '{{ vault_admin_password | password_hash("bcrypt") }}',`

**File:** scripts/systematic_replacement.py
**Line:** 171
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/systematic_replacement.py
**Line:** 171
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/systematic_replacement.py
**Line:** 29
**Match:** `admin123`
**Line Content:** `r'admin123': '{{ vault_admin_password | password_hash("bcrypt") }}',`

**File:** scripts/systematic_replacement.py
**Line:** 171
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

**File:** scripts/systematic_replacement.py
**Line:** 171
**Match:** `admin123`
**Line Content:** `'admin123': r'admin123',`

### Your_Secure_Password (36 issues)

**File:** security_hardening_results.json
**Line:** 3400
**Match:** `your_secure_password`
**Line Content:** `"your_secure_password": [],`

**File:** security_hardening_results.json
**Line:** 3826
**Match:** `your_secure_password`
**Line Content:** `"your_secure_password": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`

**File:** security_hardening_results.json
**Line:** 3400
**Match:** `your_secure_password`
**Line Content:** `"your_secure_password": [],`

**File:** security_hardening_results.json
**Line:** 3826
**Match:** `your_secure_password`
**Line Content:** `"your_secure_password": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`

**File:** group_vars/all/vault.yml
**Line:** 6
**Match:** `your_password`
**Line Content:** `# Generate with: htpasswd -nb admin your_password`

**File:** group_vars/all/vault.yml
**Line:** 6
**Match:** `your_password`
**Line Content:** `# Generate with: htpasswd -nb admin your_password`

**File:** scripts/security_hardening.py
**Line:** 54
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': [`

**File:** scripts/security_hardening.py
**Line:** 55
**Match:** `your_secure_password`
**Line Content:** `r'your_secure_password',`

**File:** scripts/security_hardening.py
**Line:** 56
**Match:** `YOUR_SECURE_PASSWORD`
**Line Content:** `r'YOUR_SECURE_PASSWORD',`

**File:** scripts/security_hardening.py
**Line:** 232
**Match:** `your_secure_password`
**Line Content:** `elif category == 'your_secure_password':`

**File:** scripts/security_hardening.py
**Line:** 54
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': [`

**File:** scripts/security_hardening.py
**Line:** 55
**Match:** `your_secure_password`
**Line Content:** `r'your_secure_password',`

**File:** scripts/security_hardening.py
**Line:** 56
**Match:** `YOUR_SECURE_PASSWORD`
**Line Content:** `r'YOUR_SECURE_PASSWORD',`

**File:** scripts/security_hardening.py
**Line:** 232
**Match:** `your_secure_password`
**Line Content:** `elif category == 'your_secure_password':`

**File:** scripts/security_hardening.py
**Line:** 57
**Match:** `your_password`
**Line Content:** `r'your_password',`

**File:** scripts/security_hardening.py
**Line:** 58
**Match:** `YOUR_PASSWORD`
**Line Content:** `r'YOUR_PASSWORD',`

**File:** scripts/security_hardening.py
**Line:** 57
**Match:** `your_password`
**Line Content:** `r'your_password',`

**File:** scripts/security_hardening.py
**Line:** 58
**Match:** `YOUR_PASSWORD`
**Line Content:** `r'YOUR_PASSWORD',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 24
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 24
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 24
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/enhanced_validate_hardcoded.py
**Line:** 24
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/targeted_replacement.py
**Line:** 155
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/targeted_replacement.py
**Line:** 155
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/targeted_replacement.py
**Line:** 155
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/targeted_replacement.py
**Line:** 155
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/validate_hardcoded.py
**Line:** 23
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/validate_hardcoded.py
**Line:** 23
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/validate_hardcoded.py
**Line:** 23
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/validate_hardcoded.py
**Line:** 23
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/systematic_replacement.py
**Line:** 30
**Match:** `your_secure_password`
**Line Content:** `r'your_secure_password': '{{ vault_admin_password | password_hash("bcrypt") }}',`

**File:** scripts/systematic_replacement.py
**Line:** 172
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/systematic_replacement.py
**Line:** 172
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/systematic_replacement.py
**Line:** 30
**Match:** `your_secure_password`
**Line Content:** `r'your_secure_password': '{{ vault_admin_password | password_hash("bcrypt") }}',`

**File:** scripts/systematic_replacement.py
**Line:** 172
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

**File:** scripts/systematic_replacement.py
**Line:** 172
**Match:** `your_secure_password`
**Line Content:** `'your_secure_password': r'your_secure_password',`

### 192.168 (126 issues)

**File:** security_hardening_results.json
**Line:** 3183
**Match:** `192.168.1.100`
**Line Content:** `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}\""`

**File:** security_hardening_results.json
**Line:** 3188
**Match:** `192.168.1.101`
**Line Content:** `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}\""`

**File:** security_hardening_results.json
**Line:** 3193
**Match:** `192.168.1.102`
**Line Content:** `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}\""`

**File:** security_hardening_results.json
**Line:** 3198
**Match:** `192.168.1.103`
**Line Content:** `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}\""`

**File:** security_hardening_results.json
**Line:** 3203
**Match:** `192.168.1.99`
**Line Content:** `"ansible_host: \"{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}\""`

**File:** security_hardening_results.json
**Line:** 3208
**Match:** `192.168.1.0`
**Line Content:** `"subnet: \"{{ lookup('env', 'HOMELAB_SUBNET') | default('192.168.1.0/24') }}\""`

**File:** security_hardening_results.json
**Line:** 3213
**Match:** `192.168.1.1`
**Line Content:** `"gateway: \"{{ lookup('env', 'HOMELAB_GATEWAY') | default('192.168.1.1') }}\""`

**File:** security_hardening_results.json
**Line:** 3218
**Match:** `192.168.1.41`
**Line Content:** `"- url: \"http://192.168.1.41:32400\""`

**File:** security_hardening_results.json
**Line:** 3223
**Match:** `192.168.1.99`
**Line Content:** `"ansible_server_ip: \"{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}\""`

**File:** security_hardening_results.json
**Line:** 3228
**Match:** `192.168.1.100`
**Line Content:** `"- \"{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}\""`

**File:** security_hardening_results.json
**Line:** 3233
**Match:** `192.168.1.101`
**Line Content:** `"- \"{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}\""`

**File:** security_hardening_results.json
**Line:** 3238
**Match:** `192.168.1.102`
**Line Content:** `"- \"{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}\""`

**File:** security_hardening_results.json
**Line:** 3243
**Match:** `192.168.1.103`
**Line Content:** `"- \"{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}\""`

**File:** security_hardening_results.json
**Line:** 3248
**Match:** `192.168.1.0`
**Line Content:** `"reconya_network_range: \"{{ lookup('env', 'RECONYA_NETWORK_RANGE') | default('192.168.1.0/24') }}\""`

**File:** security_hardening_results.json
**Line:** 3253
**Match:** `192.168.1.100`
**Line Content:** `"vm_ip: \"{{ vm_ip | default('192.168.1.100') }}\""`

**File:** security_hardening_results.json
**Line:** 3258
**Match:** `192.168.1.1`
**Line Content:** `"gateway: \"{{ network_config.gateway | default('192.168.1.1') }}\""`

**File:** security_hardening_results.json
**Line:** 3263
**Match:** `192.168.1.100`
**Line Content:** `"ip_address: \"{{ lookup('env', 'HOMELAB_IP_ADDRESS') | default('192.168.1.100') }}\""`

**File:** security_hardening_results.json
**Line:** 3268
**Match:** `192.168.1.41`
**Line Content:** `"plex_server_ip: \"{{ lookup('env', 'PLEX_SERVER_IP') | default('192.168.1.41') }}\"           # IP address of your existing Plex server"`

**File:** security_hardening_results.json
**Line:** 3273
**Match:** `192.168.1.0`
**Line Content:** `"- \"192.168.1.0/24\""`

**File:** security_hardening_results.json
**Line:** 3278
**Match:** `192.168.1.0`
**Line Content:** `"- \"192.168.1.0/24\""`

**File:** security_hardening_results.json
**Line:** 3283
**Match:** `192.168.1.0`
**Line Content:** `"fail_msg: \"Invalid network range format. Expected format: 192.168.1.0/24\""`

**File:** security_hardening_results.json
**Line:** 3288
**Match:** `192.168.1.0`
**Line Content:** `"reconya_network_range: \"192.168.1.0/24\""`

**File:** security_hardening_results.json
**Line:** 3293
**Match:** `192.168.1.0`
**Line Content:** `"reconya_network_ranges: [\"192.168.1.0/24\"]"`

**File:** inventory.yml
**Line:** 10
**Match:** `192.168.1.100`
**Line Content:** `ansible_host: "{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}"`

**File:** inventory.yml
**Line:** 13
**Match:** `192.168.1.101`
**Line Content:** `ansible_host: "{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}"`

**File:** inventory.yml
**Line:** 16
**Match:** `192.168.1.102`
**Line Content:** `ansible_host: "{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}"`

**File:** inventory.yml
**Line:** 19
**Match:** `192.168.1.103`
**Line Content:** `ansible_host: "{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}"`

**File:** inventory.yml
**Line:** 36
**Match:** `192.168.1.99`
**Line Content:** `ansible_host: "{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}"`

**File:** inventory.yml
**Line:** 44
**Match:** `192.168.1.0`
**Line Content:** `subnet: "{{ lookup('env', 'HOMELAB_SUBNET') | default('192.168.1.0/24') }}"`

**File:** inventory.yml
**Line:** 45
**Match:** `192.168.1.1`
**Line Content:** `gateway: "{{ lookup('env', 'HOMELAB_GATEWAY') | default('192.168.1.1') }}"`

**File:** tasks/network.yml
**Line:** 133
**Match:** `172.17.0.0`
**Line Content:** `- "172.17.0.0/16"`

**File:** tasks/network.yml
**Line:** 134
**Match:** `172.18.0.0`
**Line Content:** `- "172.18.0.0/16"`

**File:** tasks/network.yml
**Line:** 135
**Match:** `172.19.0.0`
**Line Content:** `- "172.19.0.0/16"`

**File:** tasks/network.yml
**Line:** 136
**Match:** `172.20.0.0`
**Line Content:** `- "172.20.0.0/14"`

**File:** tasks/network.yml
**Line:** 427
**Match:** `172.20.0.0`
**Line Content:** `-A DOCKER-USER -s 172.20.0.0/16 -d 172.20.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 427
**Match:** `172.20.0.0`
**Line Content:** `-A DOCKER-USER -s 172.20.0.0/16 -d 172.20.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 428
**Match:** `172.21.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.21.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 428
**Match:** `172.21.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.21.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 429
**Match:** `172.22.0.0`
**Line Content:** `-A DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 429
**Match:** `172.22.0.0`
**Line Content:** `-A DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 432
**Match:** `172.20.0.0`
**Line Content:** `-A DOCKER-USER -s 172.20.0.0/16 -d 172.21.0.0/16 -j DROP`

**File:** tasks/network.yml
**Line:** 432
**Match:** `172.21.0.0`
**Line Content:** `-A DOCKER-USER -s 172.20.0.0/16 -d 172.21.0.0/16 -j DROP`

**File:** tasks/network.yml
**Line:** 433
**Match:** `172.20.0.0`
**Line Content:** `-A DOCKER-USER -s 172.20.0.0/16 -d 172.22.0.0/16 -j DROP`

**File:** tasks/network.yml
**Line:** 433
**Match:** `172.22.0.0`
**Line Content:** `-A DOCKER-USER -s 172.20.0.0/16 -d 172.22.0.0/16 -j DROP`

**File:** tasks/network.yml
**Line:** 434
**Match:** `172.21.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j DROP`

**File:** tasks/network.yml
**Line:** 434
**Match:** `172.22.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j DROP`

**File:** tasks/network.yml
**Line:** 437
**Match:** `172.21.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.20.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 437
**Match:** `172.20.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.20.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 438
**Match:** `172.21.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j ACCEPT`

**File:** tasks/network.yml
**Line:** 438
**Match:** `172.22.0.0`
**Line Content:** `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j ACCEPT`

**File:** tasks/plex.yml
**Line:** 26
**Match:** `192.168.1.41`
**Line Content:** `- url: "http://192.168.1.41:32400"`

**File:** tasks/docker.yml
**Line:** 140
**Match:** `172.17.0.0`
**Line Content:** `"base": "172.17.0.0/16",`

**File:** tasks/docker.yml
**Line:** 144
**Match:** `172.18.0.0`
**Line Content:** `"base": "172.18.0.0/16",`

**File:** tasks/docker.yml
**Line:** 148
**Match:** `172.19.0.0`
**Line Content:** `"base": "172.19.0.0/16",`

**File:** tasks/docker.yml
**Line:** 152
**Match:** `172.20.0.0`
**Line Content:** `"base": "172.20.0.0/14",`

**File:** tasks/docker.yml
**Line:** 157
**Match:** `172.17.0.1`
**Line Content:** `"bip": "172.17.0.1/16",`

**File:** tasks/docker.yml
**Line:** 158
**Match:** `172.17.0.0`
**Line Content:** `"fixed-cidr": "172.17.0.0/16"`

**File:** group_vars/all/common.yml
**Line:** 7
**Match:** `192.168.1.99`
**Line Content:** `ansible_server_ip: "{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}"`

**File:** group_vars/all/common.yml
**Line:** 9
**Match:** `192.168.1.100`
**Line Content:** `- "{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}"`

**File:** group_vars/all/common.yml
**Line:** 10
**Match:** `192.168.1.101`
**Line Content:** `- "{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}"`

**File:** group_vars/all/common.yml
**Line:** 11
**Match:** `192.168.1.102`
**Line Content:** `- "{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}"`

**File:** group_vars/all/common.yml
**Line:** 12
**Match:** `192.168.1.103`
**Line Content:** `- "{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}"`

**File:** group_vars/all/common.yml
**Line:** 118
**Match:** `192.168.1.0`
**Line Content:** `reconya_network_range: "{{ lookup('env', 'RECONYA_NETWORK_RANGE') | default('192.168.1.0/24') }}"`

**File:** group_vars/all/common.yml
**Line:** 36
**Match:** `172.20.0.0`
**Line Content:** `- subnet: "172.20.0.0/24"`

**File:** group_vars/all/common.yml
**Line:** 37
**Match:** `172.20.0.1`
**Line Content:** `gateway: "172.20.0.1"`

**File:** group_vars/all/common.yml
**Line:** 42
**Match:** `172.21.0.0`
**Line Content:** `- subnet: "172.21.0.0/24"`

**File:** group_vars/all/common.yml
**Line:** 43
**Match:** `172.21.0.1`
**Line Content:** `gateway: "172.21.0.1"`

**File:** group_vars/all/common.yml
**Line:** 48
**Match:** `172.22.0.0`
**Line Content:** `- subnet: "172.22.0.0/24"`

**File:** group_vars/all/common.yml
**Line:** 49
**Match:** `172.22.0.1`
**Line Content:** `gateway: "172.22.0.1"`

**File:** group_vars/all/common.yml
**Line:** 54
**Match:** `172.23.0.0`
**Line Content:** `- subnet: "172.23.0.0/24"`

**File:** group_vars/all/common.yml
**Line:** 55
**Match:** `172.23.0.1`
**Line Content:** `gateway: "172.23.0.1"`

**File:** group_vars/all/common.yml
**Line:** 60
**Match:** `172.24.0.0`
**Line Content:** `- subnet: "172.24.0.0/24"`

**File:** group_vars/all/common.yml
**Line:** 61
**Match:** `172.24.0.1`
**Line Content:** `gateway: "172.24.0.1"`

**File:** group_vars/all/common.yml
**Line:** 66
**Match:** `172.25.0.0`
**Line Content:** `- subnet: "172.25.0.0/24"`

**File:** group_vars/all/common.yml
**Line:** 67
**Match:** `172.25.0.1`
**Line Content:** `gateway: "172.25.0.1"`

**File:** group_vars/all/proxmox.yml
**Line:** 26
**Match:** `192.168.1.100`
**Line Content:** `vm_ip: "{{ vm_ip | default('192.168.1.100') }}"`

**File:** group_vars/all/proxmox.yml
**Line:** 45
**Match:** `192.168.1.1`
**Line Content:** `gateway: "{{ network_config.gateway | default('192.168.1.1') }}"`

**File:** group_vars/all/vars.yml
**Line:** 13
**Match:** `192.168.1.100`
**Line Content:** `ip_address: "{{ lookup('env', 'HOMELAB_IP_ADDRESS') | default('192.168.1.100') }}"`

**File:** group_vars/all/vars.yml
**Line:** 17
**Match:** `192.168.1.41`
**Line Content:** `plex_server_ip: "{{ lookup('env', 'PLEX_SERVER_IP') | default('192.168.1.41') }}"           # IP address of your existing Plex server`

**File:** group_vars/all/vars.yml
**Line:** 588
**Match:** `192.168.1.0`
**Line Content:** `- "192.168.1.0/24"`

**File:** group_vars/all/vars.yml
**Line:** 254
**Match:** `172.20.0.0`
**Line Content:** `- subnet: "172.20.0.0/16"`

**File:** group_vars/all/vars.yml
**Line:** 255
**Match:** `172.20.0.1`
**Line Content:** `gateway: "172.20.0.1"`

**File:** group_vars/all/vars.yml
**Line:** 261
**Match:** `172.21.0.0`
**Line Content:** `- subnet: "172.21.0.0/16"`

**File:** group_vars/all/vars.yml
**Line:** 262
**Match:** `172.21.0.1`
**Line Content:** `gateway: "172.21.0.1"`

**File:** group_vars/all/vars.yml
**Line:** 267
**Match:** `172.22.0.0`
**Line Content:** `- subnet: "172.22.0.0/16"`

**File:** group_vars/all/vars.yml
**Line:** 268
**Match:** `172.22.0.1`
**Line Content:** `gateway: "172.22.0.1"`

**File:** roles/databases/tasks/prerequisites.yml
**Line:** 60
**Match:** `172.20.0.0`
**Line Content:** `- subnet: "{{ databases_network_subnet | default('172.20.0.0/16') }}"`

**File:** roles/databases/tasks/prerequisites.yml
**Line:** 68
**Match:** `172.18.0.0`
**Line Content:** `- subnet: "{{ databases_traefik_network_subnet | default('172.18.0.0/16') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 200
**Match:** `10.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 203
**Match:** `10.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 206
**Match:** `10.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 209
**Match:** `10.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/databases/defaults/main.yml
**Line:** 212
**Match:** `10.0.0.0`
**Line Content:** `source: "10.0.0.0/8"`

**File:** roles/security/vpn/tasks/deploy.yml
**Line:** 30
**Match:** `10.0.0.1`
**Line Content:** `Address = 10.0.0.1/24`

**File:** roles/fing/tasks/deploy.yml
**Line:** 57
**Match:** `172.20.0.0`
**Line Content:** `- subnet: "172.20.0.0/16"`

**File:** roles/fing/defaults/main.yml
**Line:** 43
**Match:** `192.168.1.0`
**Line Content:** `- "192.168.1.0/24"`

**File:** roles/fing/defaults/main.yml
**Line:** 44
**Match:** `10.0.0.0`
**Line Content:** `- "10.0.0.0/8"`

**File:** roles/fing/defaults/main.yml
**Line:** 45
**Match:** `172.16.0.0`
**Line Content:** `- "172.16.0.0/12"`

**File:** roles/pezzo/tasks/prerequisites.yml
**Line:** 60
**Match:** `172.20.0.0`
**Line Content:** `- subnet: "{{ pezzo_network_subnet | default('172.20.0.0/16') }}"`

**File:** roles/ersatztv/tasks/prerequisites.yml
**Line:** 72
**Match:** `172.23.0.0`
**Line Content:** `- subnet: "172.23.0.0/16"`

**File:** roles/ersatztv/tasks/prerequisites.yml
**Line:** 73
**Match:** `172.23.0.1`
**Line Content:** `gateway: "172.23.0.1"`

**File:** roles/reconya/tasks/validate.yml
**Line:** 20
**Match:** `192.168.1.0`
**Line Content:** `fail_msg: "Invalid network range format. Expected format: 192.168.1.0/24"`

**File:** roles/reconya/defaults/main.yml
**Line:** 33
**Match:** `192.168.1.0`
**Line Content:** `reconya_network_range: "192.168.1.0/24"`

**File:** roles/reconya/defaults/main.yml
**Line:** 38
**Match:** `192.168.1.0`
**Line Content:** `reconya_network_ranges: ["192.168.1.0/24"]`

**File:** scripts/setup.sh
**Line:** 100
**Match:** `192.168.40.0`
**Line Content:** `network_subnet=${network_subnet:-192.168.40.0/24}`

**File:** scripts/setup.sh
**Line:** 101
**Match:** `192.168.40.1`
**Line Content:** `gateway_ip=${gateway_ip:-192.168.40.1}`

**File:** scripts/enhanced_health_check.sh
**Line:** 233
**Match:** `192.168.1.1`
**Line Content:** `if ! ping -c 3 192.168.1.1 >/dev/null 2>&1; then`

**File:** scripts/setup_environment_variables.sh
**Line:** 89
**Match:** `192.168.1.0`
**Line Content:** `prompt_with_default "HOMELAB_SUBNET" "192.168.1.0/24" "Enter your network subnet:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 90
**Match:** `192.168.1.1`
**Line Content:** `prompt_with_default "HOMELAB_GATEWAY" "192.168.1.1" "Enter your gateway IP:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 91
**Match:** `192.168.1.100`
**Line Content:** `prompt_with_default "HOMELAB_IP_1" "192.168.1.100" "Enter IP for core1:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 92
**Match:** `192.168.1.101`
**Line Content:** `prompt_with_default "HOMELAB_IP_2" "192.168.1.101" "Enter IP for core2:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 93
**Match:** `192.168.1.102`
**Line Content:** `prompt_with_default "HOMELAB_IP_3" "192.168.1.102" "Enter IP for core3:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 94
**Match:** `192.168.1.103`
**Line Content:** `prompt_with_default "HOMELAB_IP_4" "192.168.1.103" "Enter IP for core4:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 95
**Match:** `192.168.1.99`
**Line Content:** `prompt_with_default "ANSIBLE_SERVER_IP" "192.168.1.99" "Enter Ansible control server IP:"`

**File:** scripts/setup_environment_variables.sh
**Line:** 96
**Match:** `192.168.1.41`
**Line Content:** `prompt_with_default "PLEX_SERVER_IP" "192.168.1.41" "Enter your Plex server IP (if different):"`

**File:** scripts/setup_environment.sh
**Line:** 146
**Match:** `192.168.1.1`
**Line Content:** `GATEWAY_IP=$(get_user_input "Enter your gateway IP address" "validate_ip" "192.168.1.1")`

**File:** scripts/setup_environment.sh
**Line:** 152
**Match:** `192.168.1.0`
**Line Content:** `INTERNAL_SUBNET=$(get_user_input "Enter internal subnet (e.g., 192.168.1.0/24)" "" "192.168.1.0/24")`

**File:** scripts/setup_environment.sh
**Line:** 152
**Match:** `192.168.1.0`
**Line Content:** `INTERNAL_SUBNET=$(get_user_input "Enter internal subnet (e.g., 192.168.1.0/24)" "" "192.168.1.0/24")`

**File:** scripts/seamless_setup.sh
**Line:** 373
**Match:** `192.168.1.0`
**Line Content:** `read -p "Internal subnet (default: 192.168.1.0/24): " internal_subnet`

**File:** scripts/seamless_setup.sh
**Line:** 374
**Match:** `192.168.1.0`
**Line Content:** `internal_subnet=${internal_subnet:-192.168.1.0/24}`

**File:** scripts/seamless_setup.sh
**Line:** 1606
**Match:** `172.20.0.0`
**Line Content:** `- subnet: "172.20.0.0/16"`

**File:** scripts/seamless_setup.sh
**Line:** 1607
**Match:** `172.20.0.1`
**Line Content:** `gateway: "172.20.0.1"`

**File:** scripts/seamless_setup.sh
**Line:** 1612
**Match:** `172.21.0.0`
**Line Content:** `- subnet: "172.21.0.0/16"`

**File:** scripts/seamless_setup.sh
**Line:** 1613
**Match:** `172.21.0.1`
**Line Content:** `gateway: "172.21.0.1"`

**File:** scripts/seamless_setup.sh
**Line:** 1617
**Match:** `172.22.0.0`
**Line Content:** `- subnet: "172.22.0.0/16"`

**File:** scripts/seamless_setup.sh
**Line:** 1618
**Match:** `172.22.0.1`
**Line Content:** `gateway: "172.22.0.1"`

### Default_Credentials (364 issues)

**File:** inventory.yml
**Line:** 11
**Match:** `user: "{{ lookup('`
**Line Content:** `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`

**File:** inventory.yml
**Line:** 14
**Match:** `user: "{{ lookup('`
**Line Content:** `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`

**File:** inventory.yml
**Line:** 17
**Match:** `user: "{{ lookup('`
**Line Content:** `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`

**File:** inventory.yml
**Line:** 20
**Match:** `user: "{{ lookup('`
**Line Content:** `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`

**File:** inventory.yml
**Line:** 37
**Match:** `user: "{{ lookup('`
**Line Content:** `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`

**File:** tasks/telegraf.yml
**Line:** 210
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/network.yml
**Line:** 359
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/network.yml
**Line:** 416
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/network.yml
**Line:** 96
**Match:** `default: "{{ item.default }}"`
**Line Content:** `default: "{{ item.default }}"`

**File:** tasks/homepage.yml
**Line:** 35
**Match:** `user: "{{ username }}"`
**Line Content:** `become_user: "{{ username }}"`

**File:** tasks/emby.yml
**Line:** 437
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/emby.yml
**Line:** 445
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/security.yml
**Line:** 579
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/mariadb.yml
**Line:** 270
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/mariadb.yml
**Line:** 278
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/mariadb.yml
**Line:** 286
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/radarr.yml
**Line:** 151
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/radarr.yml
**Line:** 159
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/lidarr.yml
**Line:** 210
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/lidarr.yml
**Line:** 218
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/proxmox.yml
**Line:** 8
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/proxmox.yml
**Line:** 20
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/proxmox.yml
**Line:** 43
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/proxmox.yml
**Line:** 65
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/proxmox.yml
**Line:** 82
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/proxmox.yml
**Line:** 100
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/portainer.yml
**Line:** 152
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/portainer.yml
**Line:** 160
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/blackbox_exporter.yml
**Line:** 253
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/grafana.yml
**Line:** 653
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/postgresql.yml
**Line:** 260
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/postgresql.yml
**Line:** 268
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/postgresql.yml
**Line:** 276
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/nginx.yml
**Line:** 228
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/sabnzbd.yml
**Line:** 85
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/sabnzbd.yml
**Line:** 194
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/sabnzbd.yml
**Line:** 202
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/redis.yml
**Line:** 246
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/redis.yml
**Line:** 254
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/storage.yml
**Line:** 316
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/storage.yml
**Line:** 325
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/storage.yml
**Line:** 334
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/storage.yml
**Line:** 391
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/readarr.yml
**Line:** 210
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/readarr.yml
**Line:** 218
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/loki.yml
**Line:** 187
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/setup.yml
**Line:** 47
**Match:** `user: "{{ proxmox_user | default('`
**Line Content:** `proxmox_user: "{{ proxmox_user | default('root@pam') }}"`

**File:** tasks/setup.yml
**Line:** 60
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `api_user: "{{ proxmox_user }}"`

**File:** tasks/setup.yml
**Line:** 79
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `proxmox_user: "{{ proxmox_user }}"`

**File:** tasks/prowlarr.yml
**Line:** 157
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/prowlarr.yml
**Line:** 165
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/audiobookshelf.yml
**Line:** 140
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/audiobookshelf.yml
**Line:** 148
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/nextcloud.yml
**Line:** 108
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 11
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 20
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 29
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 38
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 47
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 56
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 65
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 74
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 83
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 92
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 101
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 110
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 119
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 128
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 137
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 146
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 155
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 164
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 173
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 182
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 191
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 200
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 209
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 218
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 227
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 236
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 245
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 254
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 263
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 272
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 281
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 290
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 299
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/update_backup_schedules.yml
**Line:** 308
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/qbittorrent.yml
**Line:** 96
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/qbittorrent.yml
**Line:** 208
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/kibana.yml
**Line:** 194
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/vault.yml
**Line:** 263
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/vault.yml
**Line:** 271
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/cleanup.yml
**Line:** 555
**Match:** `user: "{{ username }}"`
**Line Content:** `become_user: "{{ username }}"`

**File:** tasks/cleanup.yml
**Line:** 587
**Match:** `user: "{{ username }}"`
**Line Content:** `become_user: "{{ username }}"`

**File:** tasks/komga.yml
**Line:** 148
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/komga.yml
**Line:** 156
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/media_stack.yml
**Line:** 1080
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/media_stack.yml
**Line:** 1088
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/watchtower.yml
**Line:** 45
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 89
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 139
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 172
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 203
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 251
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 299
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 348
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 393
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 442
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 490
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 537
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 585
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** tasks/watchtower.yml
**Line:** 638
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/watchtower.yml
**Line:** 754
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/jellyfin.yml
**Line:** 415
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/jellyfin.yml
**Line:** 423
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/essential.yml
**Line:** 284
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/backup.yml
**Line:** 542
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/backup.yml
**Line:** 551
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/influxdb.yml
**Line:** 177
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/influxdb.yml
**Line:** 185
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/elasticsearch.yml
**Line:** 298
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/elasticsearch.yml
**Line:** 306
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/alertmanager.yml
**Line:** 495
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/promtail.yml
**Line:** 165
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/prometheus.yml
**Line:** 599
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/prometheus.yml
**Line:** 750
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/tdarr.yml
**Line:** 163
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/tdarr.yml
**Line:** 171
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/calibre-web.yml
**Line:** 139
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/calibre-web.yml
**Line:** 147
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/sonarr.yml
**Line:** 210
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** tasks/sonarr.yml
**Line:** 218
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** group_vars/all/common.yml
**Line:** 25
**Match:** `root: "{{ lookup('`
**Line Content:** `docker_root: "{{ lookup('env', 'DOCKER_ROOT') | default('/opt/docker') }}"`

**File:** group_vars/all/common.yml
**Line:** 26
**Match:** `root: "{{ docker_root }}/data"`
**Line Content:** `docker_data_root: "{{ docker_root }}/data"`

**File:** group_vars/all/common.yml
**Line:** 27
**Match:** `root: "{{ docker_root }}/config"`
**Line Content:** `docker_config_root: "{{ docker_root }}/config"`

**File:** group_vars/all/common.yml
**Line:** 28
**Match:** `root: "{{ docker_root }}/logs"`
**Line Content:** `docker_logs_root: "{{ docker_root }}/logs"`

**File:** group_vars/all/proxmox.yml
**Line:** 7
**Match:** `user: "{{ proxmox_user }}"`
**Line Content:** `proxmox_user: "{{ proxmox_user }}"`

**File:** group_vars/all/vars.yml
**Line:** 835
**Match:** `root: "{{ lookup('`
**Line Content:** `docker_data_root: "{{ lookup('env', 'DOCKER_DATA_ROOT') | default('/var/lib/docker') }}"`

**File:** group_vars/all/vars.yml
**Line:** 126
**Match:** `user: "admin"`
**Line Content:** `influxdb_admin_user: "admin"`

**File:** group_vars/all/vars.yml
**Line:** 136
**Match:** `user: "admin"`
**Line Content:** `grafana_admin_user: "admin"`

**File:** group_vars/all/vars.yml
**Line:** 584
**Match:** `user: "admin"`
**Line Content:** `homeassistant_admin_user: "admin"`

**File:** group_vars/all/vars.yml
**Line:** 591
**Match:** `user: "admin"`
**Line Content:** `mosquitto_admin_user: "admin"`

**File:** group_vars/all/vars.yml
**Line:** 599
**Match:** `user: "zigbee2mqtt"`
**Line Content:** `zigbee2mqtt_mqtt_user: "zigbee2mqtt"`

**File:** group_vars/all/vars.yml
**Line:** 610
**Match:** `user: "admin"`
**Line Content:** `nextcloud_admin_user: "admin"`

**File:** group_vars/all/vars.yml
**Line:** 642
**Match:** `user: "admin"`
**Line Content:** `syncthing_gui_user: "admin"`

**File:** group_vars/all/vars.yml
**Line:** 960
**Match:** `user: "{{ lookup('`
**Line Content:** `vault_postgresql_user: "{{ lookup('env', 'POSTGRESQL_USER') | default('homelab') }}"`

**File:** group_vars/all/vault.yml
**Line:** 56
**Match:** `user: "{{ lookup('`
**Line Content:** `vault_n8n_smtp_user: "{{ lookup('env', 'VAULT_N8N_SMTP_USER') | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 342
**Match:** `user: "admin"`
**Line Content:** `vault_authentik_admin_user: "admin"`

**File:** group_vars/all/vault.yml
**Line:** 378
**Match:** `user: "{{ vault_postgresql_user | default('`
**Line Content:** `vault_postgresql_user: "{{ vault_postgresql_user | default('homelab') }}"`

**File:** roles/databases/relational/tasks/mariadb.yml
**Line:** 87
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/relational/tasks/postgresql.yml
**Line:** 67
**Match:** `USER: "{{ postgresql_admin_user }}"`
**Line Content:** `POSTGRES_USER: "{{ postgresql_admin_user }}"`

**File:** roles/databases/relational/tasks/postgresql.yml
**Line:** 96
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/relational.yml
**Line:** 269
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/relational.yml
**Line:** 277
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/relational.yml
**Line:** 286
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/relational.yml
**Line:** 558
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/relational.yml
**Line:** 566
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/relational.yml
**Line:** 575
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/cache.yml
**Line:** 255
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/cache.yml
**Line:** 263
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/cache.yml
**Line:** 272
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/cache.yml
**Line:** 359
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/cache.yml
**Line:** 411
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/monitoring.yml
**Line:** 307
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/monitoring.yml
**Line:** 323
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 51
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 61
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 71
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 80
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 101
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 131
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 140
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 162
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/backup.yml
**Line:** 179
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 300
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 308
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 317
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 517
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 642
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 723
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/search.yml
**Line:** 730
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/tasks/alerts.yml
**Line:** 43
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/cache/tasks/redis.yml
**Line:** 88
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/search/tasks/elasticsearch.yml
**Line:** 93
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 38
**Match:** `user: "postgres"`
**Line Content:** `postgresql_admin_user: "postgres"`

**File:** roles/databases/defaults/main.yml
**Line:** 479
**Match:** `user: "postgres"`
**Line Content:** `postgresql_database_user: "postgres"`

**File:** roles/databases/defaults/main.yml
**Line:** 491
**Match:** `user: "root"`
**Line Content:** `mariadb_root_user: "root"`

**File:** roles/databases/defaults/main.yml
**Line:** 498
**Match:** `user: "root"`
**Line Content:** `mariadb_database_user: "root"`

**File:** roles/databases/defaults/main.yml
**Line:** 521
**Match:** `user: "elastic"`
**Line Content:** `elasticsearch_user: "elastic"`

**File:** roles/databases/defaults/main.yml
**Line:** 534
**Match:** `user: "elastic"`
**Line Content:** `kibana_user: "elastic"`

**File:** roles/homepage/tasks/configure.yml
**Line:** 75
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/homepage/tasks/configure.yml
**Line:** 85
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/tasks/backup.yml
**Line:** 18
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/proxy/tasks/deploy.yml
**Line:** 341
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/vpn/tasks/deploy.yml
**Line:** 188
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/firewall/tasks/deploy.yml
**Line:** 168
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/firewall/tasks/deploy.yml
**Line:** 288
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/firewall/tasks/deploy.yml
**Line:** 296
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/security/defaults/main.yml
**Line:** 37
**Match:** `user: "admin"`
**Line Content:** `automation_admin_user: "admin"`

**File:** roles/security/authentication/tasks/deploy.yml
**Line:** 294
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/immich/tasks/homepage.yml
**Line:** 40
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/homepage.yml
**Line:** 78
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/security.yml
**Line:** 64
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/security.yml
**Line:** 112
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/monitoring.yml
**Line:** 61
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/monitoring.yml
**Line:** 87
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/backup.yml
**Line:** 43
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/backup.yml
**Line:** 77
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/backup.yml
**Line:** 95
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/backup.yml
**Line:** 112
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/alerts.yml
**Line:** 40
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/alerts.yml
**Line:** 78
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/immich/tasks/alerts.yml
**Line:** 149
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/fing/tasks/security.yml
**Line:** 112
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/security.yml
**Line:** 120
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/security.yml
**Line:** 128
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/security.yml
**Line:** 136
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/security.yml
**Line:** 144
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/security.yml
**Line:** 152
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/monitoring.yml
**Line:** 138
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/monitoring.yml
**Line:** 146
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/monitoring.yml
**Line:** 154
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/monitoring.yml
**Line:** 162
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/monitoring.yml
**Line:** 170
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/monitoring.yml
**Line:** 178
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/backup.yml
**Line:** 54
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/backup.yml
**Line:** 65
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/backup.yml
**Line:** 74
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/backup.yml
**Line:** 81
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/alerts.yml
**Line:** 74
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/alerts.yml
**Line:** 82
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/alerts.yml
**Line:** 90
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/alerts.yml
**Line:** 98
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/alerts.yml
**Line:** 105
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/prerequisites.yml
**Line:** 250
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/tasks/prerequisites.yml
**Line:** 262
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 34
**Match:** `user: "fing"`
**Line Content:** `fing_database_user: "fing"`

**File:** roles/dumbassets/tasks/backup.yml
**Line:** 41
**Match:** `user: "{{ username | default('`
**Line Content:** `user: "{{ username | default('homelab') }}"`

**File:** roles/pezzo/tasks/homepage.yml
**Line:** 75
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/security.yml
**Line:** 87
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/security.yml
**Line:** 97
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/monitoring.yml
**Line:** 77
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/monitoring.yml
**Line:** 113
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/backup.yml
**Line:** 79
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/backup.yml
**Line:** 89
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/backup.yml
**Line:** 117
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/backup.yml
**Line:** 145
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/tasks/alerts.yml
**Line:** 75
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 33
**Match:** `user: "postgres"`
**Line Content:** `pezzo_database_user: "postgres"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 45
**Match:** `user: "default"`
**Line Content:** `pezzo_clickhouse_user: "default"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 163
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 174
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 185
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 259
**Match:** `user: "{{ grafana_user | default('`
**Line Content:** `user: "{{ grafana_user | default('grafana') }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 24
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 36
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 48
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 60
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 72
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 84
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 96
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 108
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 9
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 50
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 62
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 103
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 134
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 160
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/monitoring.yml
**Line:** 37
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/grafana/tasks/monitoring.yml
**Line:** 45
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/grafana/tasks/monitoring.yml
**Line:** 53
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/grafana/tasks/backup.yml
**Line:** 38
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 9
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 50
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 62
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 40
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 55
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 69
**Match:** `user: "{{ grafana_admin_user }}"`
**Line Content:** `user: "{{ grafana_admin_user }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 14
**Match:** `user: "{{ vault_grafana_admin_user }}"`
**Line Content:** `grafana_admin_user: "{{ vault_grafana_admin_user }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 23
**Match:** `user: "grafana"`
**Line Content:** `grafana_database_user: "grafana"`

**File:** roles/grafana/defaults/main.yml
**Line:** 392
**Match:** `USER: "{{ grafana_admin_user }}"`
**Line Content:** `GF_SECURITY_ADMIN_USER: "{{ grafana_admin_user }}"`

**File:** roles/ersatztv/tasks/security.yml
**Line:** 458
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/security.yml
**Line:** 467
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/monitoring.yml
**Line:** 349
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/monitoring.yml
**Line:** 358
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/monitoring.yml
**Line:** 367
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/backup.yml
**Line:** 59
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/backup.yml
**Line:** 69
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/tasks/alerts.yml
**Line:** 67
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/ersatztv/defaults/main.yml
**Line:** 57
**Match:** `user: "ersatztv"`
**Line Content:** `ersatztv_database_user: "ersatztv"`

**File:** roles/storage/defaults/main.yml
**Line:** 15
**Match:** `root: "{{ docker_data_root | default('`
**Line Content:** `docker_data_root: "{{ docker_data_root | default('/srv/docker') }}"`

**File:** roles/storage/defaults/main.yml
**Line:** 16
**Match:** `root: "{{ backup_dir | default('`
**Line Content:** `backup_root: "{{ backup_dir | default('/srv/backup') }}"`

**File:** roles/utilities/tasks/security.yml
**Line:** 62
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/tasks/monitoring.yml
**Line:** 53
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/tasks/backup.yml
**Line:** 42
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/tasks/backup.yml
**Line:** 50
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/tasks/backup.yml
**Line:** 58
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/container_management/tasks/main.yml
**Line:** 46
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/container_management/tasks/main.yml
**Line:** 54
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/media_processing/tasks/main.yml
**Line:** 55
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/media_processing/tasks/main.yml
**Line:** 63
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/utilities/dashboards/tasks/main.yml
**Line:** 35
**Match:** `user: "{{ username }}"`
**Line Content:** `become_user: "{{ username }}"`

**File:** roles/n8n/tasks/monitoring.yml
**Line:** 60
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/n8n/tasks/backup.yml
**Line:** 34
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/n8n/tasks/backup.yml
**Line:** 54
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/n8n/defaults/main.yml
**Line:** 31
**Match:** `user: "{{ n8n_database_user | default('`
**Line Content:** `n8n_database_user: "{{ n8n_database_user | default('postgres') }}"`

**File:** roles/n8n/defaults/main.yml
**Line:** 226
**Match:** `user: "{{ vault_n8n_smtp_user | default('`
**Line Content:** `n8n_smtp_user: "{{ vault_n8n_smtp_user | default('') }}"`

**File:** roles/reconya/tasks/monitoring.yml
**Line:** 60
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/reconya/tasks/backup.yml
**Line:** 52
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/reconya/tasks/backup.yml
**Line:** 61
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/reconya/tasks/backup.yml
**Line:** 104
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/reconya/tasks/alerts.yml
**Line:** 102
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 46
**Match:** `user: "romm"`
**Line Content:** `romm_database_user: "romm"`

**File:** roles/romm/defaults/main.yml
**Line:** 144
**Match:** `USER: "{{ romm_database_user }}"`
**Line Content:** `ROMM_DATABASE_USER: "{{ romm_database_user }}"`

**File:** roles/vaultwarden/tasks/backup.yml
**Line:** 37
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/vaultwarden/defaults/main.yml
**Line:** 31
**Match:** `user: "postgres"`
**Line Content:** `vaultwarden_database_user: "postgres"`

**File:** roles/automation/tasks/security.yml
**Line:** 35
**Match:** `user: "{{ automation_username }}"`
**Line Content:** `user: "{{ automation_username }}"`

**File:** roles/automation/tasks/monitoring.yml
**Line:** 53
**Match:** `user: "{{ automation_username }}"`
**Line Content:** `user: "{{ automation_username }}"`

**File:** roles/automation/tasks/backup.yml
**Line:** 29
**Match:** `user: "{{ automation_username }}"`
**Line Content:** `user: "{{ automation_username }}"`

**File:** roles/automation/container_management/tasks/main.yml
**Line:** 33
**Match:** `user: "{{ automation_username }}"`
**Line Content:** `user: "{{ automation_username }}"`

**File:** roles/automation/container_management/tasks/main.yml
**Line:** 77
**Match:** `user: "{{ puid }}:{{ pgid }}"`
**Line Content:** `user: "{{ puid }}:{{ pgid }}"`

**File:** roles/linkwarden/defaults/main.yml
**Line:** 31
**Match:** `user: "postgres"`
**Line Content:** `linkwarden_database_user: "postgres"`

**File:** roles/sonarr/tasks/deploy.yml
**Line:** 186
**Match:** `user: "{{ ansible_user }}"`
**Line Content:** `user: "{{ ansible_user }}"`

**File:** roles/paperless_ngx/tasks/security.yml
**Line:** 217
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/monitoring.yml
**Line:** 167
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/monitoring.yml
**Line:** 176
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 41
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 51
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 61
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 70
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 91
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 112
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 134
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 156
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/backup.yml
**Line:** 176
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/alerts.yml
**Line:** 140
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 106
**Match:** `user: "{{ postgresql_admin_user | default('`
**Line Content:** `login_user: "{{ postgresql_admin_user | default('postgres') }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 119
**Match:** `user: "{{ postgresql_admin_user | default('`
**Line Content:** `login_user: "{{ postgresql_admin_user | default('postgres') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 35
**Match:** `user: "paperless"`
**Line Content:** `paperless_ngx_database_user: "paperless"`

**File:** roles/media/tasks/monitoring.yml
**Line:** 97
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/media/tasks/monitoring.yml
**Line:** 104
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/media/tasks/monitoring.yml
**Line:** 184
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/media/tasks/backup.yml
**Line:** 33
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/media/tasks/prerequisites.yml
**Line:** 172
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/media/tasks/prerequisites.yml
**Line:** 180
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/media/defaults/main.yml
**Line:** 65
**Match:** `user: "media"`
**Line Content:** `media_database_user: "media"`

**File:** roles/nginx_proxy_manager/tasks/automation.yml
**Line:** 215
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/nginx_proxy_manager/tasks/automation.yml
**Line:** 228
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/nginx_proxy_manager/tasks/automation.yml
**Line:** 240
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/nginx_proxy_manager/tasks/automation.yml
**Line:** 253
**Match:** `user: "{{ username }}"`
**Line Content:** `user: "{{ username }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 43
**Match:** `USER: "npm"`
**Line Content:** `MYSQL_USER: "npm"`

**File:** scripts/setup.sh
**Line:** 109
**Match:** `user: "$proxmox_user"`
**Line Content:** `proxmox_user: "$proxmox_user"`

**File:** scripts/setup.sh
**Line:** 143
**Match:** `user: "$proxmox_user"`
**Line Content:** `proxmox_user: "$proxmox_user"`

**File:** scripts/service_wizard.py
**Line:** 972
**Match:** `user: "{service_info.database_user}"`
**Line Content:** `{service_info.name}_database_user: "{service_info.database_user}"`

**File:** scripts/service_wizard.py
**Line:** 1077
**Match:** `USER: "{{{{ {service_info.name}_database_user }}}}"`
**Line Content:** `{service_info.name.upper()}_DATABASE_USER: "{{{{ {service_info.name}_database_user }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1365
**Match:** `user: "{{{{ {service_info.name}_database_user }}}}"`
**Line Content:** `user: "{{{{ {service_info.name}_database_user }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1490
**Match:** `user: "{{{{ ansible_user }}}}"`
**Line Content:** `user: "{{{{ ansible_user }}}}"`

**File:** scripts/setup_environment_variables.sh
**Line:** 83
**Match:** `user:"
prompt_with_default "`
**Line Content:** `prompt_with_default "HOMELAB_USERNAME" "homelab" "Enter the username for the homelab user:"`

**File:** scripts/seamless_setup.sh
**Line:** 1532
**Match:** `root: "$docker_root"`
**Line Content:** `docker_root: "$docker_root"`

**File:** scripts/seamless_setup.sh
**Line:** 914
**Match:** `user: "$grafana_admin_user"`
**Line Content:** `vault_grafana_admin_user: "$grafana_admin_user"`

**File:** scripts/seamless_setup.sh
**Line:** 915
**Match:** `user: "$influxdb_admin_user"`
**Line Content:** `vault_influxdb_admin_user: "$influxdb_admin_user"`

**File:** scripts/seamless_setup.sh
**Line:** 919
**Match:** `user: "$postgresql_user"`
**Line Content:** `vault_postgresql_user: "$postgresql_user"`

**File:** scripts/seamless_setup.sh
**Line:** 2127
**Match:** `user:"
            echo "`
**Line Content:** `echo "Please run the deployment as the homelab user:"`

### Password (932 issues)

**File:** tasks/security.yml
**Line:** 780
**Match:** `password: "{{ vault_fail2ban_secret_key }}"`
**Line Content:** `admin_password: "{{ vault_fail2ban_secret_key }}"`

**File:** tasks/security.yml
**Line:** 781
**Match:** `password: "{{ vault_pihole_database_password }}"`
**Line Content:** `database_password: "{{ vault_pihole_database_password }}"`

**File:** tasks/security.yml
**Line:** 780
**Match:** `password: "{{ vault_fail2ban_secret_key }}"`
**Line Content:** `admin_password: "{{ vault_fail2ban_secret_key }}"`

**File:** tasks/security.yml
**Line:** 781
**Match:** `password: "{{ vault_pihole_database_password }}"`
**Line Content:** `database_password: "{{ vault_pihole_database_password }}"`

**File:** tasks/proxmox.yml
**Line:** 9
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 21
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 44
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 66
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 83
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 101
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 9
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 21
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 44
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 66
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 83
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/proxmox.yml
**Line:** 101
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/setup.yml
**Line:** 48
**Match:** `password: "{{ proxmox_password | default('`
**Line Content:** `proxmox_password: "{{ proxmox_password | default('') }}"`

**File:** tasks/setup.yml
**Line:** 61
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/setup.yml
**Line:** 80
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `proxmox_password: "{{ proxmox_password }}"`

**File:** tasks/setup.yml
**Line:** 48
**Match:** `password: "{{ proxmox_password | default('`
**Line Content:** `proxmox_password: "{{ proxmox_password | default('') }}"`

**File:** tasks/setup.yml
**Line:** 61
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `api_password: "{{ proxmox_password }}"`

**File:** tasks/setup.yml
**Line:** 80
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `proxmox_password: "{{ proxmox_password }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 40
**Match:** `password: ""`
**Line Content:** `password: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 51
**Match:** `password: "{{ vault_qbittorrent_password }}"`
**Line Content:** `password: "{{ vault_qbittorrent_password }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 83
**Match:** `password: ""`
**Line Content:** `password: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 310
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `password: "{{ vault_smtp_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 342
**Match:** `password: "{{ vault_plex_password | default('`
**Line Content:** `password: "{{ vault_plex_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 355
**Match:** `password: "{{ vault_jellyfin_password | default('`
**Line Content:** `password: "{{ vault_jellyfin_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 465
**Match:** `password: "{{ vault_lidarr_password | default('`
**Line Content:** `password: "{{ vault_lidarr_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 480
**Match:** `Password: ""`
**Line Content:** `certPassword: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 497
**Match:** `password: ""`
**Line Content:** `password: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 40
**Match:** `password: ""`
**Line Content:** `password: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 51
**Match:** `password: "{{ vault_qbittorrent_password }}"`
**Line Content:** `password: "{{ vault_qbittorrent_password }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 83
**Match:** `password: ""`
**Line Content:** `password: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 310
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `password: "{{ vault_smtp_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 342
**Match:** `password: "{{ vault_plex_password | default('`
**Line Content:** `password: "{{ vault_plex_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 355
**Match:** `password: "{{ vault_jellyfin_password | default('`
**Line Content:** `password: "{{ vault_jellyfin_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 465
**Match:** `password: "{{ vault_lidarr_password | default('`
**Line Content:** `password: "{{ vault_lidarr_password | default('') }}"`

**File:** tasks/configure_lidarr.yml
**Line:** 480
**Match:** `Password: ""`
**Line Content:** `certPassword: ""`

**File:** tasks/configure_lidarr.yml
**Line:** 497
**Match:** `password: ""`
**Line Content:** `password: ""`

**File:** tasks/backup_databases.yml
**Line:** 9
**Match:** `PASSWORD: "{{ item.password }}"`
**Line Content:** `PGPASSWORD: "{{ item.password }}"`

**File:** tasks/backup_databases.yml
**Line:** 9
**Match:** `PASSWORD: "{{ item.password }}"`
**Line Content:** `PGPASSWORD: "{{ item.password }}"`

**File:** tasks/secret_rotation.yml
**Line:** 100
**Match:** `password: "Db{{ lookup('`
**Line Content:** `new_vault_postgresql_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 101
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_redis_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 102
**Match:** `password: "Db{{ lookup('`
**Line Content:** `new_vault_media_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 103
**Match:** `password: "Db{{ lookup('`
**Line Content:** `new_vault_paperless_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 108
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_grafana_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 109
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_authentik_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 110
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_portainer_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 111
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_gitlab_root_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 100
**Match:** `password: "Db{{ lookup('`
**Line Content:** `new_vault_postgresql_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 101
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_redis_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 102
**Match:** `password: "Db{{ lookup('`
**Line Content:** `new_vault_media_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 103
**Match:** `password: "Db{{ lookup('`
**Line Content:** `new_vault_paperless_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 108
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_grafana_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 109
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_authentik_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 110
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_portainer_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/secret_rotation.yml
**Line:** 111
**Match:** `password: "{{ lookup('`
**Line Content:** `new_vault_gitlab_root_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`

**File:** tasks/influxdb.yml
**Line:** 201
**Match:** `PASSWORD: "{{ influxdb_admin_password }}"`
**Line Content:** `DOCKER_INFLUXDB_INIT_PASSWORD: "{{ influxdb_admin_password }}"`

**File:** tasks/influxdb.yml
**Line:** 201
**Match:** `PASSWORD: "{{ influxdb_admin_password }}"`
**Line Content:** `DOCKER_INFLUXDB_INIT_PASSWORD: "{{ influxdb_admin_password }}"`

**File:** tasks/alertmanager.yml
**Line:** 29
**Match:** `password: '{{ smtp_password | default("`
**Line Content:** `smtp_auth_password: '{{ smtp_password | default("") }}'`

**File:** tasks/alertmanager.yml
**Line:** 29
**Match:** `password: '{{ smtp_password | default("`
**Line Content:** `smtp_auth_password: '{{ smtp_password | default("") }}'`

**File:** tasks/notify_backup.yml
**Line:** 10
**Match:** `password: "{{ vault_backup_smtp_password }}"`
**Line Content:** `password: "{{ vault_backup_smtp_password }}"`

**File:** tasks/notify_backup.yml
**Line:** 10
**Match:** `password: "{{ vault_backup_smtp_password }}"`
**Line Content:** `password: "{{ vault_backup_smtp_password }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 10
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 11
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 14
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 15
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 16
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 17
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_database_password: "{{ lookup('env', 'VAULT_N8N_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 18
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_linkwarden_database_password: "{{ lookup('env', 'VAULT_LINKWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 19
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pezzo_database_password: "{{ lookup('env', 'VAULT_PEZZO_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 20
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pezzo_redis_password: "{{ lookup('env', 'VAULT_PEZZO_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 21
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pezzo_clickhouse_password: "{{ lookup('env', 'VAULT_PEZZO_CLICKHOUSE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 22
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_vaultwarden_database_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 23
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_reconya_database_password: "{{ lookup('env', 'VAULT_RECONYA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 24
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_database_password: "{{ lookup('env', 'VAULT_IMMICH_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 25
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 28
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_nextcloud_db_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 29
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_nextcloud_db_root_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 30
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_nextcloud_admin_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 37
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 38
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 39
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_portainer_admin_password: "{{ lookup('env', 'VAULT_PORTAINER_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 42
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 43
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 44
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 45
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_reconya_admin_password: "{{ lookup('env', 'VAULT_RECONYA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 46
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_admin_password: "{{ lookup('env', 'VAULT_IMMICH_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 47
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_vaultwarden_admin_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 50
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_jellyfin_password: "{{ lookup('env', 'VAULT_JELLYFIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 51
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_calibre_web_password: "{{ lookup('env', 'VAULT_CALIBRE_WEB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 52
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_audiobookshelf_password: "{{ lookup('env', 'VAULT_AUDIOBOOKSHELF_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 53
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_sabnzbd_password: "{{ lookup('env', 'VAULT_SABNZBD_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 54
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_tdarr_password: "{{ lookup('env', 'VAULT_TDARR_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 55
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_qbittorrent_password: "{{ lookup('env', 'VAULT_QBITTORRENT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 58
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 59
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_mariadb_root_password: "{{ lookup('env', 'VAULT_MARIADB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 60
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_proxmox_password: "{{ lookup('env', 'VAULT_PROXMOX_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 61
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 142
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 148
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_smtp_password: "{{ lookup('env', 'VAULT_IMMICH_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 149
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_vaultwarden_smtp_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 150
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_smtp_password: "{{ lookup('env', 'VAULT_FING_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 153
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_ldap_password: "{{ lookup('env', 'VAULT_AUTHENTIK_LDAP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 156
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_zigbee2mqtt_mqtt_password: "{{ lookup('env', 'VAULT_ZIGBEE2MQTT_MQTT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 10
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 11
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 14
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 15
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 16
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 17
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_database_password: "{{ lookup('env', 'VAULT_N8N_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 18
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_linkwarden_database_password: "{{ lookup('env', 'VAULT_LINKWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 19
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pezzo_database_password: "{{ lookup('env', 'VAULT_PEZZO_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 20
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pezzo_redis_password: "{{ lookup('env', 'VAULT_PEZZO_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 21
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pezzo_clickhouse_password: "{{ lookup('env', 'VAULT_PEZZO_CLICKHOUSE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 22
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_vaultwarden_database_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 23
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_reconya_database_password: "{{ lookup('env', 'VAULT_RECONYA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 24
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_database_password: "{{ lookup('env', 'VAULT_IMMICH_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 25
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 28
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_nextcloud_db_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 29
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_nextcloud_db_root_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 30
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_nextcloud_admin_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 37
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 38
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 39
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_portainer_admin_password: "{{ lookup('env', 'VAULT_PORTAINER_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 42
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 43
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 44
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 45
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_reconya_admin_password: "{{ lookup('env', 'VAULT_RECONYA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 46
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_admin_password: "{{ lookup('env', 'VAULT_IMMICH_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 47
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_vaultwarden_admin_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 50
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_jellyfin_password: "{{ lookup('env', 'VAULT_JELLYFIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 51
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_calibre_web_password: "{{ lookup('env', 'VAULT_CALIBRE_WEB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 52
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_audiobookshelf_password: "{{ lookup('env', 'VAULT_AUDIOBOOKSHELF_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 53
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_sabnzbd_password: "{{ lookup('env', 'VAULT_SABNZBD_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 54
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_tdarr_password: "{{ lookup('env', 'VAULT_TDARR_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 55
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_qbittorrent_password: "{{ lookup('env', 'VAULT_QBITTORRENT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 58
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 59
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_mariadb_root_password: "{{ lookup('env', 'VAULT_MARIADB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 60
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_proxmox_password: "{{ lookup('env', 'VAULT_PROXMOX_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 61
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 142
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 148
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_smtp_password: "{{ lookup('env', 'VAULT_IMMICH_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 149
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_vaultwarden_smtp_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 150
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_smtp_password: "{{ lookup('env', 'VAULT_FING_SMTP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 153
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_ldap_password: "{{ lookup('env', 'VAULT_AUTHENTIK_LDAP_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault_template.yml
**Line:** 156
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_zigbee2mqtt_mqtt_password: "{{ lookup('env', 'VAULT_ZIGBEE2MQTT_MQTT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`

**File:** group_vars/all/proxmox.yml
**Line:** 8
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `proxmox_password: "{{ proxmox_password }}"`

**File:** group_vars/all/proxmox.yml
**Line:** 8
**Match:** `password: "{{ proxmox_password }}"`
**Line Content:** `proxmox_password: "{{ proxmox_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 99
**Match:** `password: "{{ vault_authentik_postgres_password }}"`
**Line Content:** `authentik_postgres_password: "{{ vault_authentik_postgres_password }}" # Database password`

**File:** group_vars/all/vars.yml
**Line:** 101
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `authentik_admin_password: "{{ vault_authentik_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 104
**Match:** `password: "{{ vault_wireguard_password | default('`
**Line Content:** `wireguard_password: "{{ vault_wireguard_password | default('') }}"`

**File:** group_vars/all/vars.yml
**Line:** 105
**Match:** `password: "{{ vault_codeserver_password | default('`
**Line Content:** `codeserver_password: "{{ vault_codeserver_password | default('') }}"`

**File:** group_vars/all/vars.yml
**Line:** 106
**Match:** `password: "{{ vault_gitlab_root_password | default('`
**Line Content:** `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`

**File:** group_vars/all/vars.yml
**Line:** 127
**Match:** `password: "{{ vault_influxdb_admin_password }}"`
**Line Content:** `influxdb_admin_password: "{{ vault_influxdb_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 132
**Match:** `password: "{{ vault_influxdb_admin_password }}"`
**Line Content:** `influxdb_password: "{{ vault_influxdb_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 137
**Match:** `password: "{{ vault_grafana_admin_password }}"`
**Line Content:** `grafana_admin_password: "{{ vault_grafana_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 298
**Match:** `password: "{{ vault_postgresql_password }}"`
**Line Content:** `postgres_password: "{{ vault_postgresql_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 299
**Match:** `password: "{{ vault_redis_password }}"`
**Line Content:** `redis_password: "{{ vault_redis_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 300
**Match:** `password: "{{ vault_mariadb_root_password }}"`
**Line Content:** `mysql_root_password: "{{ vault_mariadb_root_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 585
**Match:** `password: "{{ vault_homeassistant_admin_password }}"`
**Line Content:** `homeassistant_admin_password: "{{ vault_homeassistant_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 592
**Match:** `password: "{{ vault_mosquitto_admin_password }}"`
**Line Content:** `mosquitto_admin_password: "{{ vault_mosquitto_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 600
**Match:** `password: "{{ vault_zigbee2mqtt_mqtt_password }}"`
**Line Content:** `zigbee2mqtt_mqtt_password: "{{ vault_zigbee2mqtt_mqtt_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 611
**Match:** `password: "{{ vault_nextcloud_admin_password }}"`
**Line Content:** `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 612
**Match:** `password: "{{ vault_nextcloud_db_password }}"`
**Line Content:** `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 613
**Match:** `password: "{{ vault_nextcloud_db_root_password }}"`
**Line Content:** `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 643
**Match:** `password: "{{ vault_syncthing_gui_password }}"`
**Line Content:** `syncthing_gui_password: "{{ vault_syncthing_gui_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 759
**Match:** `password: "{{ vault_smtp_password }}"`
**Line Content:** `smtp_password: "{{ vault_smtp_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 945
**Match:** `password: "{{ vault_pihole_admin_password }}"`
**Line Content:** `pihole_web_password: "{{ vault_pihole_admin_password }}"  # Web interface password`

**File:** group_vars/all/vars.yml
**Line:** 961
**Match:** `password: "{{ vault_postgresql_password }}"`
**Line Content:** `vault_postgresql_password: "{{ vault_postgresql_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 962
**Match:** `password: "{{ vault_mariadb_root_password }}"`
**Line Content:** `vault_mariadb_root_password: "{{ vault_mariadb_root_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 963
**Match:** `password: "{{ vault_redis_password }}"`
**Line Content:** `vault_redis_password: "{{ vault_redis_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 99
**Match:** `password: "{{ vault_authentik_postgres_password }}"`
**Line Content:** `authentik_postgres_password: "{{ vault_authentik_postgres_password }}" # Database password`

**File:** group_vars/all/vars.yml
**Line:** 101
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `authentik_admin_password: "{{ vault_authentik_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 104
**Match:** `password: "{{ vault_wireguard_password | default('`
**Line Content:** `wireguard_password: "{{ vault_wireguard_password | default('') }}"`

**File:** group_vars/all/vars.yml
**Line:** 105
**Match:** `password: "{{ vault_codeserver_password | default('`
**Line Content:** `codeserver_password: "{{ vault_codeserver_password | default('') }}"`

**File:** group_vars/all/vars.yml
**Line:** 106
**Match:** `password: "{{ vault_gitlab_root_password | default('`
**Line Content:** `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`

**File:** group_vars/all/vars.yml
**Line:** 127
**Match:** `password: "{{ vault_influxdb_admin_password }}"`
**Line Content:** `influxdb_admin_password: "{{ vault_influxdb_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 132
**Match:** `password: "{{ vault_influxdb_admin_password }}"`
**Line Content:** `influxdb_password: "{{ vault_influxdb_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 137
**Match:** `password: "{{ vault_grafana_admin_password }}"`
**Line Content:** `grafana_admin_password: "{{ vault_grafana_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 298
**Match:** `password: "{{ vault_postgresql_password }}"`
**Line Content:** `postgres_password: "{{ vault_postgresql_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 299
**Match:** `password: "{{ vault_redis_password }}"`
**Line Content:** `redis_password: "{{ vault_redis_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 300
**Match:** `password: "{{ vault_mariadb_root_password }}"`
**Line Content:** `mysql_root_password: "{{ vault_mariadb_root_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 585
**Match:** `password: "{{ vault_homeassistant_admin_password }}"`
**Line Content:** `homeassistant_admin_password: "{{ vault_homeassistant_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 592
**Match:** `password: "{{ vault_mosquitto_admin_password }}"`
**Line Content:** `mosquitto_admin_password: "{{ vault_mosquitto_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 600
**Match:** `password: "{{ vault_zigbee2mqtt_mqtt_password }}"`
**Line Content:** `zigbee2mqtt_mqtt_password: "{{ vault_zigbee2mqtt_mqtt_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 611
**Match:** `password: "{{ vault_nextcloud_admin_password }}"`
**Line Content:** `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 612
**Match:** `password: "{{ vault_nextcloud_db_password }}"`
**Line Content:** `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 613
**Match:** `password: "{{ vault_nextcloud_db_root_password }}"`
**Line Content:** `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 643
**Match:** `password: "{{ vault_syncthing_gui_password }}"`
**Line Content:** `syncthing_gui_password: "{{ vault_syncthing_gui_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 759
**Match:** `password: "{{ vault_smtp_password }}"`
**Line Content:** `smtp_password: "{{ vault_smtp_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 945
**Match:** `password: "{{ vault_pihole_admin_password }}"`
**Line Content:** `pihole_web_password: "{{ vault_pihole_admin_password }}"  # Web interface password`

**File:** group_vars/all/vars.yml
**Line:** 961
**Match:** `password: "{{ vault_postgresql_password }}"`
**Line Content:** `vault_postgresql_password: "{{ vault_postgresql_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 962
**Match:** `password: "{{ vault_mariadb_root_password }}"`
**Line Content:** `vault_mariadb_root_password: "{{ vault_mariadb_root_password }}"`

**File:** group_vars/all/vars.yml
**Line:** 963
**Match:** `password: "{{ vault_redis_password }}"`
**Line Content:** `vault_redis_password: "{{ vault_redis_password }}"`

**File:** group_vars/all/notifications.yml
**Line:** 13
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** group_vars/all/notifications.yml
**Line:** 13
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 14
**Match:** `password: "{{ vault_authentik_postgres_password }}"`
**Line Content:** `authentik_postgres_password: "{{ vault_authentik_postgres_password }}"`

**File:** group_vars/all/vault.yml
**Line:** 16
**Match:** `password: "{{ vault_authentik_admin_password | default('`
**Line Content:** `authentik_admin_password: "{{ vault_authentik_admin_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 19
**Match:** `password: "{{ vault_wireguard_password | default('`
**Line Content:** `wireguard_password: "{{ vault_wireguard_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 20
**Match:** `password: "{{ vault_codeserver_password | default('`
**Line Content:** `codeserver_password: "{{ vault_codeserver_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 21
**Match:** `password: "{{ vault_gitlab_root_password | default('`
**Line Content:** `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 32
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 37
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 38
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 39
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 40
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 41
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 44
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 46
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 51
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 53
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_postgres_password: "{{ lookup('env', 'VAULT_N8N_POSTGRES_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 92
**Match:** `password: "{{ vault_pihole_web_password | default('`
**Line Content:** `pihole_web_password: "{{ vault_pihole_web_password | default('') }}"  # Web interface password`

**File:** group_vars/all/vault.yml
**Line:** 100
**Match:** `password: "{{ vault_admin_password | default('`
**Line Content:** `admin_password: "{{ vault_admin_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 101
**Match:** `password: "{{ vault_db_password | default('`
**Line Content:** `database_password: "{{ vault_db_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 167
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 177
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 179
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 184
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 185
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 187
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 190
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_db_password: "{{ lookup('env', 'VAULT_IMMICH_DB_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 191
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_postgres_password: "{{ lookup('env', 'VAULT_IMMICH_POSTGRES_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 192
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 198
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 199
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 209
**Match:** `password: "{{ vault_npm_db_root_password | password_hash('`
**Line Content:** `vault_npm_db_root_password: "{{ vault_npm_db_root_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 210
**Match:** `password: "{{ vault_npm_db_password | password_hash('`
**Line Content:** `vault_npm_db_password: "{{ vault_npm_db_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 214
**Match:** `password: "{{ vault_npm_admin_password | password_hash('`
**Line Content:** `vault_npm_admin_password: "{{ vault_npm_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 341
**Match:** `password: "{{ vault_authentik_admin_password | password_hash('`
**Line Content:** `vault_authentik_admin_password: "{{ vault_authentik_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 344
**Match:** `password: "{{ vault_authentik_database_password | password_hash('`
**Line Content:** `vault_authentik_database_password: "{{ vault_authentik_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 345
**Match:** `password: "{{ vault_authentik_redis_password | password_hash('`
**Line Content:** `vault_authentik_redis_password: "{{ vault_authentik_redis_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 349
**Match:** `password: "{{ vault_user_password | password_hash('`
**Line Content:** `vault_user_password: "{{ vault_user_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 350
**Match:** `password: "{{ vault_user1_password | password_hash('`
**Line Content:** `vault_user1_password: "{{ vault_user1_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 351
**Match:** `password: "{{ vault_user2_password | password_hash('`
**Line Content:** `vault_user2_password: "{{ vault_user2_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 357
**Match:** `password: "{{ vault_grafana_admin_password | password_hash('`
**Line Content:** `vault_grafana_admin_password: "{{ vault_grafana_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 358
**Match:** `password: "{{ vault_grafana_security_admin_password | password_hash('`
**Line Content:** `vault_grafana_security_admin_password: "{{ vault_grafana_security_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 359
**Match:** `password: "{{ vault_grafana_database_password | password_hash('`
**Line Content:** `vault_grafana_database_password: "{{ vault_grafana_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 362
**Match:** `password: "{{ vault_grafana_viewer_password | password_hash('`
**Line Content:** `vault_grafana_viewer_password: "{{ vault_grafana_viewer_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 363
**Match:** `password: "{{ vault_grafana_editor_password | password_hash('`
**Line Content:** `vault_grafana_editor_password: "{{ vault_grafana_editor_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 364
**Match:** `password: "{{ vault_grafana_family_password | password_hash('`
**Line Content:** `vault_grafana_family_password: "{{ vault_grafana_family_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 365
**Match:** `password: "{{ vault_grafana_guest_password | password_hash('`
**Line Content:** `vault_grafana_guest_password: "{{ vault_grafana_guest_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 366
**Match:** `password: "{{ vault_grafana_developer_password | password_hash('`
**Line Content:** `vault_grafana_developer_password: "{{ vault_grafana_developer_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 367
**Match:** `password: "{{ vault_grafana_security_password | password_hash('`
**Line Content:** `vault_grafana_security_password: "{{ vault_grafana_security_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 368
**Match:** `password: "{{ vault_grafana_media_password | password_hash('`
**Line Content:** `vault_grafana_media_password: "{{ vault_grafana_media_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 369
**Match:** `password: "{{ vault_grafana_backup_password | password_hash('`
**Line Content:** `vault_grafana_backup_password: "{{ vault_grafana_backup_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 370
**Match:** `password: "{{ vault_grafana_monitoring_password | password_hash('`
**Line Content:** `vault_grafana_monitoring_password: "{{ vault_grafana_monitoring_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 377
**Match:** `password: "{{ vault_postgresql_password | password_hash('`
**Line Content:** `vault_postgresql_password: "{{ vault_postgresql_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 381
**Match:** `password: "{{ vault_mysql_root_password | password_hash('`
**Line Content:** `vault_mysql_root_password: "{{ vault_mysql_root_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 382
**Match:** `password: "{{ vault_mysql_password | password_hash('`
**Line Content:** `vault_mysql_password: "{{ vault_mysql_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 385
**Match:** `password: "{{ vault_redis_password | password_hash('`
**Line Content:** `vault_redis_password: "{{ vault_redis_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 392
**Match:** `password: "{{ vault_jellyfin_admin_password | password_hash('`
**Line Content:** `vault_jellyfin_admin_password: "{{ vault_jellyfin_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 409
**Match:** `password: "{{ vault_lidarr_password | password_hash('`
**Line Content:** `vault_lidarr_password: "{{ vault_lidarr_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 421
**Match:** `password: "{{ vault_qbittorrent_password | password_hash('`
**Line Content:** `vault_qbittorrent_password: "{{ vault_qbittorrent_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 440
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `vault_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 452
**Match:** `password: "{{ vault_homepage_admin_password | password_hash('`
**Line Content:** `vault_homepage_admin_password: "{{ vault_homepage_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 453
**Match:** `password: "{{ vault_homepage_user_password | password_hash('`
**Line Content:** `vault_homepage_user_password: "{{ vault_homepage_user_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 474
**Match:** `password: "{{ vault_paperless_admin_password | password_hash('`
**Line Content:** `vault_paperless_admin_password: "{{ vault_paperless_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 476
**Match:** `password: "{{ vault_paperless_database_password | password_hash('`
**Line Content:** `vault_paperless_database_password: "{{ vault_paperless_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 483
**Match:** `password: "{{ vault_reconya_admin_password | password_hash('`
**Line Content:** `vault_reconya_admin_password: "{{ vault_reconya_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 490
**Match:** `password: "{{ vault_romm_admin_password | password_hash('`
**Line Content:** `vault_romm_admin_password: "{{ vault_romm_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 492
**Match:** `password: "{{ vault_romm_database_password | password_hash('`
**Line Content:** `vault_romm_database_password: "{{ vault_romm_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 500
**Match:** `password: "{{ vault_vaultwarden_postgres_password | password_hash('`
**Line Content:** `vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 506
**Match:** `password: "{{ vault_linkwarden_postgres_password | password_hash('`
**Line Content:** `vault_linkwarden_postgres_password: "{{ vault_linkwarden_postgres_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 513
**Match:** `password: "{{ vault_pezzo_postgres_password | password_hash('`
**Line Content:** `vault_pezzo_postgres_password: "{{ vault_pezzo_postgres_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 514
**Match:** `password: "{{ vault_pezzo_redis_password | password_hash('`
**Line Content:** `vault_pezzo_redis_password: "{{ vault_pezzo_redis_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 515
**Match:** `password: "{{ vault_pezzo_clickhouse_password | password_hash('`
**Line Content:** `vault_pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 534
**Match:** `password: "{{ vault_udm_pro_admin_password | password_hash('`
**Line Content:** `vault_udm_pro_admin_password: "{{ vault_udm_pro_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 542
**Match:** `password: "{{ vault_prometheus_admin_password | password_hash('`
**Line Content:** `vault_prometheus_admin_password: "{{ vault_prometheus_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 545
**Match:** `password: "{{ vault_alertmanager_admin_password | password_hash('`
**Line Content:** `vault_alertmanager_admin_password: "{{ vault_alertmanager_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 581
**Match:** `password: "{{ vault_dev_database_password | password_hash('`
**Line Content:** `vault_dev_database_password: "{{ vault_dev_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 589
**Match:** `password: "{{ vault_test_database_password | password_hash('`
**Line Content:** `vault_test_database_password: "{{ vault_test_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 597
**Match:** `password: "{{ vault_prod_database_password | password_hash('`
**Line Content:** `vault_prod_database_password: "{{ vault_prod_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 14
**Match:** `password: "{{ vault_authentik_postgres_password }}"`
**Line Content:** `authentik_postgres_password: "{{ vault_authentik_postgres_password }}"`

**File:** group_vars/all/vault.yml
**Line:** 16
**Match:** `password: "{{ vault_authentik_admin_password | default('`
**Line Content:** `authentik_admin_password: "{{ vault_authentik_admin_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 19
**Match:** `password: "{{ vault_wireguard_password | default('`
**Line Content:** `wireguard_password: "{{ vault_wireguard_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 20
**Match:** `password: "{{ vault_codeserver_password | default('`
**Line Content:** `codeserver_password: "{{ vault_codeserver_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 21
**Match:** `password: "{{ vault_gitlab_root_password | default('`
**Line Content:** `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 32
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 37
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 38
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 39
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 40
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 41
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 44
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 46
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 51
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 53
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_n8n_postgres_password: "{{ lookup('env', 'VAULT_N8N_POSTGRES_PASSWORD') | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 92
**Match:** `password: "{{ vault_pihole_web_password | default('`
**Line Content:** `pihole_web_password: "{{ vault_pihole_web_password | default('') }}"  # Web interface password`

**File:** group_vars/all/vault.yml
**Line:** 100
**Match:** `password: "{{ vault_admin_password | default('`
**Line Content:** `admin_password: "{{ vault_admin_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 101
**Match:** `password: "{{ vault_db_password | default('`
**Line Content:** `database_password: "{{ vault_db_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 167
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 177
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 179
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 184
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 185
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 187
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 190
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_db_password: "{{ lookup('env', 'VAULT_IMMICH_DB_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 191
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_postgres_password: "{{ lookup('env', 'VAULT_IMMICH_POSTGRES_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 192
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 198
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 199
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`

**File:** group_vars/all/vault.yml
**Line:** 209
**Match:** `password: "{{ vault_npm_db_root_password | password_hash('`
**Line Content:** `vault_npm_db_root_password: "{{ vault_npm_db_root_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 210
**Match:** `password: "{{ vault_npm_db_password | password_hash('`
**Line Content:** `vault_npm_db_password: "{{ vault_npm_db_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 214
**Match:** `password: "{{ vault_npm_admin_password | password_hash('`
**Line Content:** `vault_npm_admin_password: "{{ vault_npm_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 341
**Match:** `password: "{{ vault_authentik_admin_password | password_hash('`
**Line Content:** `vault_authentik_admin_password: "{{ vault_authentik_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 344
**Match:** `password: "{{ vault_authentik_database_password | password_hash('`
**Line Content:** `vault_authentik_database_password: "{{ vault_authentik_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 345
**Match:** `password: "{{ vault_authentik_redis_password | password_hash('`
**Line Content:** `vault_authentik_redis_password: "{{ vault_authentik_redis_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 349
**Match:** `password: "{{ vault_user_password | password_hash('`
**Line Content:** `vault_user_password: "{{ vault_user_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 350
**Match:** `password: "{{ vault_user1_password | password_hash('`
**Line Content:** `vault_user1_password: "{{ vault_user1_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 351
**Match:** `password: "{{ vault_user2_password | password_hash('`
**Line Content:** `vault_user2_password: "{{ vault_user2_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 357
**Match:** `password: "{{ vault_grafana_admin_password | password_hash('`
**Line Content:** `vault_grafana_admin_password: "{{ vault_grafana_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 358
**Match:** `password: "{{ vault_grafana_security_admin_password | password_hash('`
**Line Content:** `vault_grafana_security_admin_password: "{{ vault_grafana_security_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 359
**Match:** `password: "{{ vault_grafana_database_password | password_hash('`
**Line Content:** `vault_grafana_database_password: "{{ vault_grafana_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 362
**Match:** `password: "{{ vault_grafana_viewer_password | password_hash('`
**Line Content:** `vault_grafana_viewer_password: "{{ vault_grafana_viewer_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 363
**Match:** `password: "{{ vault_grafana_editor_password | password_hash('`
**Line Content:** `vault_grafana_editor_password: "{{ vault_grafana_editor_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 364
**Match:** `password: "{{ vault_grafana_family_password | password_hash('`
**Line Content:** `vault_grafana_family_password: "{{ vault_grafana_family_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 365
**Match:** `password: "{{ vault_grafana_guest_password | password_hash('`
**Line Content:** `vault_grafana_guest_password: "{{ vault_grafana_guest_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 366
**Match:** `password: "{{ vault_grafana_developer_password | password_hash('`
**Line Content:** `vault_grafana_developer_password: "{{ vault_grafana_developer_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 367
**Match:** `password: "{{ vault_grafana_security_password | password_hash('`
**Line Content:** `vault_grafana_security_password: "{{ vault_grafana_security_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 368
**Match:** `password: "{{ vault_grafana_media_password | password_hash('`
**Line Content:** `vault_grafana_media_password: "{{ vault_grafana_media_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 369
**Match:** `password: "{{ vault_grafana_backup_password | password_hash('`
**Line Content:** `vault_grafana_backup_password: "{{ vault_grafana_backup_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 370
**Match:** `password: "{{ vault_grafana_monitoring_password | password_hash('`
**Line Content:** `vault_grafana_monitoring_password: "{{ vault_grafana_monitoring_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 377
**Match:** `password: "{{ vault_postgresql_password | password_hash('`
**Line Content:** `vault_postgresql_password: "{{ vault_postgresql_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 381
**Match:** `password: "{{ vault_mysql_root_password | password_hash('`
**Line Content:** `vault_mysql_root_password: "{{ vault_mysql_root_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 382
**Match:** `password: "{{ vault_mysql_password | password_hash('`
**Line Content:** `vault_mysql_password: "{{ vault_mysql_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 385
**Match:** `password: "{{ vault_redis_password | password_hash('`
**Line Content:** `vault_redis_password: "{{ vault_redis_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 392
**Match:** `password: "{{ vault_jellyfin_admin_password | password_hash('`
**Line Content:** `vault_jellyfin_admin_password: "{{ vault_jellyfin_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 409
**Match:** `password: "{{ vault_lidarr_password | password_hash('`
**Line Content:** `vault_lidarr_password: "{{ vault_lidarr_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 421
**Match:** `password: "{{ vault_qbittorrent_password | password_hash('`
**Line Content:** `vault_qbittorrent_password: "{{ vault_qbittorrent_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 440
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `vault_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** group_vars/all/vault.yml
**Line:** 452
**Match:** `password: "{{ vault_homepage_admin_password | password_hash('`
**Line Content:** `vault_homepage_admin_password: "{{ vault_homepage_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 453
**Match:** `password: "{{ vault_homepage_user_password | password_hash('`
**Line Content:** `vault_homepage_user_password: "{{ vault_homepage_user_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 474
**Match:** `password: "{{ vault_paperless_admin_password | password_hash('`
**Line Content:** `vault_paperless_admin_password: "{{ vault_paperless_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 476
**Match:** `password: "{{ vault_paperless_database_password | password_hash('`
**Line Content:** `vault_paperless_database_password: "{{ vault_paperless_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 483
**Match:** `password: "{{ vault_reconya_admin_password | password_hash('`
**Line Content:** `vault_reconya_admin_password: "{{ vault_reconya_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 490
**Match:** `password: "{{ vault_romm_admin_password | password_hash('`
**Line Content:** `vault_romm_admin_password: "{{ vault_romm_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 492
**Match:** `password: "{{ vault_romm_database_password | password_hash('`
**Line Content:** `vault_romm_database_password: "{{ vault_romm_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 500
**Match:** `password: "{{ vault_vaultwarden_postgres_password | password_hash('`
**Line Content:** `vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 506
**Match:** `password: "{{ vault_linkwarden_postgres_password | password_hash('`
**Line Content:** `vault_linkwarden_postgres_password: "{{ vault_linkwarden_postgres_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 513
**Match:** `password: "{{ vault_pezzo_postgres_password | password_hash('`
**Line Content:** `vault_pezzo_postgres_password: "{{ vault_pezzo_postgres_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 514
**Match:** `password: "{{ vault_pezzo_redis_password | password_hash('`
**Line Content:** `vault_pezzo_redis_password: "{{ vault_pezzo_redis_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 515
**Match:** `password: "{{ vault_pezzo_clickhouse_password | password_hash('`
**Line Content:** `vault_pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 534
**Match:** `password: "{{ vault_udm_pro_admin_password | password_hash('`
**Line Content:** `vault_udm_pro_admin_password: "{{ vault_udm_pro_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 542
**Match:** `password: "{{ vault_prometheus_admin_password | password_hash('`
**Line Content:** `vault_prometheus_admin_password: "{{ vault_prometheus_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 545
**Match:** `password: "{{ vault_alertmanager_admin_password | password_hash('`
**Line Content:** `vault_alertmanager_admin_password: "{{ vault_alertmanager_admin_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 581
**Match:** `password: "{{ vault_dev_database_password | password_hash('`
**Line Content:** `vault_dev_database_password: "{{ vault_dev_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 589
**Match:** `password: "{{ vault_test_database_password | password_hash('`
**Line Content:** `vault_test_database_password: "{{ vault_test_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml
**Line:** 597
**Match:** `password: "{{ vault_prod_database_password | password_hash('`
**Line Content:** `vault_prod_database_password: "{{ vault_prod_database_password | password_hash('bcrypt') }}"`

**File:** group_vars/all/vault.yml.template
**Line:** 6
**Match:** `password: "your_secure_postgresql_password"`
**Line Content:** `vault_postgresql_password: "your_secure_postgresql_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 7
**Match:** `password: "your_secure_media_db_password"`
**Line Content:** `vault_media_database_password: "your_secure_media_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 8
**Match:** `password: "your_secure_paperless_db_password"`
**Line Content:** `vault_paperless_database_password: "your_secure_paperless_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 9
**Match:** `password: "your_secure_fing_db_password"`
**Line Content:** `vault_fing_database_password: "your_secure_fing_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 10
**Match:** `password: "your_secure_redis_password"`
**Line Content:** `vault_redis_password: "your_secure_redis_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 11
**Match:** `password: "your_secure_mariadb_root_password"`
**Line Content:** `vault_mariadb_root_password: "your_secure_mariadb_root_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 14
**Match:** `password: "your_secure_romm_admin_password"`
**Line Content:** `vault_romm_admin_password: "your_secure_romm_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 16
**Match:** `password: "your_secure_romm_database_password"`
**Line Content:** `vault_romm_database_password: "your_secure_romm_database_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 20
**Match:** `password: "your_secure_influxdb_admin_password"`
**Line Content:** `vault_influxdb_admin_password: "your_secure_influxdb_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 24
**Match:** `password: "your_secure_paperless_admin_password"`
**Line Content:** `vault_paperless_admin_password: "your_secure_paperless_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 26
**Match:** `password: "your_secure_fing_admin_password"`
**Line Content:** `vault_fing_admin_password: "your_secure_fing_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 41
**Match:** `password: "your_secure_lidarr_password"`
**Line Content:** `vault_lidarr_password: "your_secure_lidarr_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 43
**Match:** `password: "your_secure_qbittorrent_password"`
**Line Content:** `vault_qbittorrent_password: "your_secure_qbittorrent_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 46
**Match:** `password: "your_secure_homeassistant_admin_password"`
**Line Content:** `vault_homeassistant_admin_password: "your_secure_homeassistant_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 47
**Match:** `password: "your_secure_mosquitto_admin_password"`
**Line Content:** `vault_mosquitto_admin_password: "your_secure_mosquitto_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 48
**Match:** `password: "your_secure_zigbee2mqtt_mqtt_password"`
**Line Content:** `vault_zigbee2mqtt_mqtt_password: "your_secure_zigbee2mqtt_mqtt_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 51
**Match:** `password: "your_secure_nextcloud_admin_password"`
**Line Content:** `vault_nextcloud_admin_password: "your_secure_nextcloud_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 52
**Match:** `password: "your_secure_nextcloud_db_password"`
**Line Content:** `vault_nextcloud_db_password: "your_secure_nextcloud_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 53
**Match:** `password: "your_secure_nextcloud_db_root_password"`
**Line Content:** `vault_nextcloud_db_root_password: "your_secure_nextcloud_db_root_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 54
**Match:** `password: "your_secure_syncthing_gui_password"`
**Line Content:** `vault_syncthing_gui_password: "your_secure_syncthing_gui_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 61
**Match:** `password: "your_secure_grafana_admin_password"`
**Line Content:** `vault_grafana_admin_password: "your_secure_grafana_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 66
**Match:** `password: "your_secure_authentik_postgres_password"`
**Line Content:** `vault_authentik_postgres_password: "your_secure_authentik_postgres_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 68
**Match:** `password: "your_secure_authentik_admin_password"`
**Line Content:** `vault_authentik_admin_password: "your_secure_authentik_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 74
**Match:** `password: "your_secure_immich_db_password"`
**Line Content:** `vault_immich_db_password: "your_secure_immich_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 75
**Match:** `password: "your_secure_immich_redis_password"`
**Line Content:** `vault_immich_redis_password: "your_secure_immich_redis_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 77
**Match:** `password: "your_secure_immich_postgres_password"`
**Line Content:** `vault_immich_postgres_password: "your_secure_immich_postgres_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 81
**Match:** `password: "your_smtp_password"`
**Line Content:** `vault_smtp_password: "your_smtp_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 6
**Match:** `password: "your_secure_postgresql_password"`
**Line Content:** `vault_postgresql_password: "your_secure_postgresql_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 7
**Match:** `password: "your_secure_media_db_password"`
**Line Content:** `vault_media_database_password: "your_secure_media_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 8
**Match:** `password: "your_secure_paperless_db_password"`
**Line Content:** `vault_paperless_database_password: "your_secure_paperless_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 9
**Match:** `password: "your_secure_fing_db_password"`
**Line Content:** `vault_fing_database_password: "your_secure_fing_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 10
**Match:** `password: "your_secure_redis_password"`
**Line Content:** `vault_redis_password: "your_secure_redis_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 11
**Match:** `password: "your_secure_mariadb_root_password"`
**Line Content:** `vault_mariadb_root_password: "your_secure_mariadb_root_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 14
**Match:** `password: "your_secure_romm_admin_password"`
**Line Content:** `vault_romm_admin_password: "your_secure_romm_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 16
**Match:** `password: "your_secure_romm_database_password"`
**Line Content:** `vault_romm_database_password: "your_secure_romm_database_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 20
**Match:** `password: "your_secure_influxdb_admin_password"`
**Line Content:** `vault_influxdb_admin_password: "your_secure_influxdb_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 24
**Match:** `password: "your_secure_paperless_admin_password"`
**Line Content:** `vault_paperless_admin_password: "your_secure_paperless_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 26
**Match:** `password: "your_secure_fing_admin_password"`
**Line Content:** `vault_fing_admin_password: "your_secure_fing_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 41
**Match:** `password: "your_secure_lidarr_password"`
**Line Content:** `vault_lidarr_password: "your_secure_lidarr_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 43
**Match:** `password: "your_secure_qbittorrent_password"`
**Line Content:** `vault_qbittorrent_password: "your_secure_qbittorrent_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 46
**Match:** `password: "your_secure_homeassistant_admin_password"`
**Line Content:** `vault_homeassistant_admin_password: "your_secure_homeassistant_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 47
**Match:** `password: "your_secure_mosquitto_admin_password"`
**Line Content:** `vault_mosquitto_admin_password: "your_secure_mosquitto_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 48
**Match:** `password: "your_secure_zigbee2mqtt_mqtt_password"`
**Line Content:** `vault_zigbee2mqtt_mqtt_password: "your_secure_zigbee2mqtt_mqtt_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 51
**Match:** `password: "your_secure_nextcloud_admin_password"`
**Line Content:** `vault_nextcloud_admin_password: "your_secure_nextcloud_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 52
**Match:** `password: "your_secure_nextcloud_db_password"`
**Line Content:** `vault_nextcloud_db_password: "your_secure_nextcloud_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 53
**Match:** `password: "your_secure_nextcloud_db_root_password"`
**Line Content:** `vault_nextcloud_db_root_password: "your_secure_nextcloud_db_root_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 54
**Match:** `password: "your_secure_syncthing_gui_password"`
**Line Content:** `vault_syncthing_gui_password: "your_secure_syncthing_gui_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 61
**Match:** `password: "your_secure_grafana_admin_password"`
**Line Content:** `vault_grafana_admin_password: "your_secure_grafana_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 66
**Match:** `password: "your_secure_authentik_postgres_password"`
**Line Content:** `vault_authentik_postgres_password: "your_secure_authentik_postgres_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 68
**Match:** `password: "your_secure_authentik_admin_password"`
**Line Content:** `vault_authentik_admin_password: "your_secure_authentik_admin_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 74
**Match:** `password: "your_secure_immich_db_password"`
**Line Content:** `vault_immich_db_password: "your_secure_immich_db_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 75
**Match:** `password: "your_secure_immich_redis_password"`
**Line Content:** `vault_immich_redis_password: "your_secure_immich_redis_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 77
**Match:** `password: "your_secure_immich_postgres_password"`
**Line Content:** `vault_immich_postgres_password: "your_secure_immich_postgres_password"`

**File:** group_vars/all/vault.yml.template
**Line:** 81
**Match:** `password: "your_smtp_password"`
**Line Content:** `vault_smtp_password: "your_smtp_password"`

**File:** group_vars/all/roles.yml
**Line:** 49
**Match:** `password: '{{ vault_redis_password }}'`
**Line Content:** `redis_password: '{{ vault_redis_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 51
**Match:** `password: '{{ vault_postgresql_password }}'`
**Line Content:** `postgresql_password: '{{ vault_postgresql_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 53
**Match:** `password: '{{ vault_mariadb_root_password }}'`
**Line Content:** `mariadb_root_password: '{{ vault_mariadb_root_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 62
**Match:** `password: '{{ vault_samba_password }}'`
**Line Content:** `samba_password: '{{ vault_samba_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 67
**Match:** `password: '{{ vault_nextcloud_admin_password }}'`
**Line Content:** `nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 113
**Match:** `password: '{{ vault_paperless_ngx_admin_password }}'`
**Line Content:** `paperless_ngx_admin_password: '{{ vault_paperless_ngx_admin_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 49
**Match:** `password: '{{ vault_redis_password }}'`
**Line Content:** `redis_password: '{{ vault_redis_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 51
**Match:** `password: '{{ vault_postgresql_password }}'`
**Line Content:** `postgresql_password: '{{ vault_postgresql_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 53
**Match:** `password: '{{ vault_mariadb_root_password }}'`
**Line Content:** `mariadb_root_password: '{{ vault_mariadb_root_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 62
**Match:** `password: '{{ vault_samba_password }}'`
**Line Content:** `samba_password: '{{ vault_samba_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 67
**Match:** `password: '{{ vault_nextcloud_admin_password }}'`
**Line Content:** `nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'`

**File:** group_vars/all/roles.yml
**Line:** 113
**Match:** `password: '{{ vault_paperless_ngx_admin_password }}'`
**Line Content:** `paperless_ngx_admin_password: '{{ vault_paperless_ngx_admin_password }}'`

**File:** homepage/config/settings.yml
**Line:** 140
**Match:** `password: "{{ vault_smtp_password }}"`
**Line Content:** `password: "{{ vault_smtp_password }}"`

**File:** homepage/config/settings.yml
**Line:** 184
**Match:** `password: "{{ vault_homepage_admin_password }}"`
**Line Content:** `password: "{{ vault_homepage_admin_password }}"`

**File:** homepage/config/settings.yml
**Line:** 187
**Match:** `password: "{{ vault_homepage_user_password }}"`
**Line Content:** `password: "{{ vault_homepage_user_password }}"`

**File:** homepage/config/settings.yml
**Line:** 140
**Match:** `password: "{{ vault_smtp_password }}"`
**Line Content:** `password: "{{ vault_smtp_password }}"`

**File:** homepage/config/settings.yml
**Line:** 184
**Match:** `password: "{{ vault_homepage_admin_password }}"`
**Line Content:** `password: "{{ vault_homepage_admin_password }}"`

**File:** homepage/config/settings.yml
**Line:** 187
**Match:** `password: "{{ vault_homepage_user_password }}"`
**Line Content:** `password: "{{ vault_homepage_user_password }}"`

**File:** roles/databases/vars/main.yml
**Line:** 5
**Match:** `password: ""`
**Line Content:** `vault_postgresql_admin_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 6
**Match:** `password: ""`
**Line Content:** `vault_mariadb_root_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 7
**Match:** `password: ""`
**Line Content:** `vault_redis_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 8
**Match:** `password: ""`
**Line Content:** `vault_elasticsearch_elastic_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 5
**Match:** `password: ""`
**Line Content:** `vault_postgresql_admin_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 6
**Match:** `password: ""`
**Line Content:** `vault_mariadb_root_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 7
**Match:** `password: ""`
**Line Content:** `vault_redis_password: ""`

**File:** roles/databases/vars/main.yml
**Line:** 8
**Match:** `password: ""`
**Line Content:** `vault_elasticsearch_elastic_password: ""`

**File:** roles/databases/relational/tasks/mariadb.yml
**Line:** 59
**Match:** `PASSWORD: "{{ mariadb_root_password }}"`
**Line Content:** `MARIADB_ROOT_PASSWORD: "{{ mariadb_root_password }}"`

**File:** roles/databases/relational/tasks/mariadb.yml
**Line:** 59
**Match:** `PASSWORD: "{{ mariadb_root_password }}"`
**Line Content:** `MARIADB_ROOT_PASSWORD: "{{ mariadb_root_password }}"`

**File:** roles/databases/relational/tasks/postgresql.yml
**Line:** 68
**Match:** `PASSWORD: "{{ postgresql_admin_password }}"`
**Line Content:** `POSTGRES_PASSWORD: "{{ postgresql_admin_password }}"`

**File:** roles/databases/relational/tasks/postgresql.yml
**Line:** 68
**Match:** `PASSWORD: "{{ postgresql_admin_password }}"`
**Line Content:** `POSTGRES_PASSWORD: "{{ postgresql_admin_password }}"`

**File:** roles/databases/cache/tasks/redis.yml
**Line:** 59
**Match:** `PASSWORD: "{{ redis_password }}"`
**Line Content:** `REDIS_PASSWORD: "{{ redis_password }}"`

**File:** roles/databases/cache/tasks/redis.yml
**Line:** 59
**Match:** `PASSWORD: "{{ redis_password }}"`
**Line Content:** `REDIS_PASSWORD: "{{ redis_password }}"`

**File:** roles/databases/search/tasks/kibana.yml
**Line:** 44
**Match:** `PASSWORD: "{{ elasticsearch_elastic_password }}"`
**Line Content:** `ELASTICSEARCH_PASSWORD: "{{ elasticsearch_elastic_password }}"`

**File:** roles/databases/search/tasks/kibana.yml
**Line:** 44
**Match:** `PASSWORD: "{{ elasticsearch_elastic_password }}"`
**Line Content:** `ELASTICSEARCH_PASSWORD: "{{ elasticsearch_elastic_password }}"`

**File:** roles/databases/search/tasks/elasticsearch.yml
**Line:** 62
**Match:** `PASSWORD: "{{ elasticsearch_elastic_password }}"`
**Line Content:** `ELASTIC_PASSWORD: "{{ elasticsearch_elastic_password }}"`

**File:** roles/databases/search/tasks/elasticsearch.yml
**Line:** 62
**Match:** `PASSWORD: "{{ elasticsearch_elastic_password }}"`
**Line Content:** `ELASTIC_PASSWORD: "{{ elasticsearch_elastic_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 39
**Match:** `password: "{{ vault_postgresql_admin_password }}"`
**Line Content:** `postgresql_admin_password: "{{ vault_postgresql_admin_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 69
**Match:** `password: "{{ vault_mariadb_root_password }}"`
**Line Content:** `mariadb_root_password: "{{ vault_mariadb_root_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 102
**Match:** `password: "{{ vault_redis_password }}"`
**Line Content:** `redis_password: "{{ vault_redis_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 156
**Match:** `password: "{{ vault_elasticsearch_elastic_password }}"`
**Line Content:** `elasticsearch_elastic_password: "{{ vault_elasticsearch_elastic_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 421
**Match:** `password: "{{ smtp_password | default('`
**Line Content:** `databases_smtp_password: "{{ smtp_password | default('') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 480
**Match:** `password: "{{ lookup('`
**Line Content:** `postgresql_database_password: "{{ lookup('vault', 'postgresql_database_password') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 499
**Match:** `password: "{{ lookup('`
**Line Content:** `mariadb_database_password: "{{ lookup('vault', 'mariadb_database_password') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 522
**Match:** `password: "{{ vault_elasticsearch_password }}"`
**Line Content:** `elasticsearch_password: "{{ vault_elasticsearch_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 535
**Match:** `password: "{{ vault_kibana_password }}"`
**Line Content:** `kibana_password: "{{ vault_kibana_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 39
**Match:** `password: "{{ vault_postgresql_admin_password }}"`
**Line Content:** `postgresql_admin_password: "{{ vault_postgresql_admin_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 69
**Match:** `password: "{{ vault_mariadb_root_password }}"`
**Line Content:** `mariadb_root_password: "{{ vault_mariadb_root_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 102
**Match:** `password: "{{ vault_redis_password }}"`
**Line Content:** `redis_password: "{{ vault_redis_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 156
**Match:** `password: "{{ vault_elasticsearch_elastic_password }}"`
**Line Content:** `elasticsearch_elastic_password: "{{ vault_elasticsearch_elastic_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 421
**Match:** `password: "{{ smtp_password | default('`
**Line Content:** `databases_smtp_password: "{{ smtp_password | default('') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 480
**Match:** `password: "{{ lookup('`
**Line Content:** `postgresql_database_password: "{{ lookup('vault', 'postgresql_database_password') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 499
**Match:** `password: "{{ lookup('`
**Line Content:** `mariadb_database_password: "{{ lookup('vault', 'mariadb_database_password') }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 522
**Match:** `password: "{{ vault_elasticsearch_password }}"`
**Line Content:** `elasticsearch_password: "{{ vault_elasticsearch_password }}"`

**File:** roles/databases/defaults/main.yml
**Line:** 535
**Match:** `password: "{{ vault_kibana_password }}"`
**Line Content:** `kibana_password: "{{ vault_kibana_password }}"`

**File:** roles/homepage/vars/main.yml
**Line:** 66
**Match:** `password: ""`
**Line Content:** `basic_auth_password: ""`

**File:** roles/homepage/vars/main.yml
**Line:** 66
**Match:** `password: ""`
**Line Content:** `basic_auth_password: ""`

**File:** roles/security/vars/main.yml
**Line:** 5
**Match:** `password: ""`
**Line Content:** `vault_authentik_admin_password: ""`

**File:** roles/security/vars/main.yml
**Line:** 7
**Match:** `password: ""`
**Line Content:** `vault_pihole_web_password: ""`

**File:** roles/security/vars/main.yml
**Line:** 5
**Match:** `password: ""`
**Line Content:** `vault_authentik_admin_password: ""`

**File:** roles/security/vars/main.yml
**Line:** 7
**Match:** `password: ""`
**Line Content:** `vault_pihole_web_password: ""`

**File:** roles/security/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_authentik_postgres_password }}"`
**Line Content:** `postgres_password: "{{ vault_authentik_postgres_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `admin_password: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 39
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `automation_admin_password: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 64
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `password: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 100
**Match:** `password: "{{ vault_pihole_admin_password }}"`
**Line Content:** `admin_password: "{{ vault_pihole_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_authentik_postgres_password }}"`
**Line Content:** `postgres_password: "{{ vault_authentik_postgres_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `admin_password: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 39
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `automation_admin_password: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 64
**Match:** `password: "{{ vault_authentik_admin_password }}"`
**Line Content:** `password: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/defaults/main.yml
**Line:** 100
**Match:** `password: "{{ vault_pihole_admin_password }}"`
**Line Content:** `admin_password: "{{ vault_pihole_admin_password }}"`

**File:** roles/security/authentication/tasks/automation_integration.yml
**Line:** 105
**Match:** `password: "{{ security_authentik.automation_admin_password }}"`
**Line Content:** `password: "{{ security_authentik.automation_admin_password }}"`

**File:** roles/security/authentication/tasks/automation_integration.yml
**Line:** 105
**Match:** `password: "{{ security_authentik.automation_admin_password }}"`
**Line Content:** `password: "{{ security_authentik.automation_admin_password }}"`

**File:** roles/security/authentication/tasks/deploy.yml
**Line:** 423
**Match:** `PASSWORD: "{{ vault_authentik_admin_password }}"`
**Line Content:** `AUTHENTIK_ADMIN_PASSWORD: "{{ vault_authentik_admin_password }}"`

**File:** roles/security/authentication/tasks/deploy.yml
**Line:** 423
**Match:** `PASSWORD: "{{ vault_authentik_admin_password }}"`
**Line Content:** `AUTHENTIK_ADMIN_PASSWORD: "{{ vault_authentik_admin_password }}"`

**File:** roles/immich/tasks/deploy.yml
**Line:** 92
**Match:** `password: "{{ vault_immich_admin_password }}"`
**Line Content:** `password: "{{ vault_immich_admin_password }}"`

**File:** roles/immich/tasks/deploy.yml
**Line:** 92
**Match:** `password: "{{ vault_immich_admin_password }}"`
**Line Content:** `password: "{{ vault_immich_admin_password }}"`

**File:** roles/fing/tasks/prerequisites.yml
**Line:** 274
**Match:** `password: "{{ fing_admin_password }}"`
**Line Content:** `admin_password: "{{ fing_admin_password }}"`

**File:** roles/fing/tasks/prerequisites.yml
**Line:** 275
**Match:** `password: "{{ fing_database_password }}"`
**Line Content:** `database_password: "{{ fing_database_password }}"`

**File:** roles/fing/tasks/prerequisites.yml
**Line:** 274
**Match:** `password: "{{ fing_admin_password }}"`
**Line Content:** `admin_password: "{{ fing_admin_password }}"`

**File:** roles/fing/tasks/prerequisites.yml
**Line:** 275
**Match:** `password: "{{ fing_database_password }}"`
**Line Content:** `database_password: "{{ fing_database_password }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 27
**Match:** `password: "{{ vault_fing_admin_password | default('`
**Line Content:** `fing_admin_password: "{{ vault_fing_admin_password | default('') }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 35
**Match:** `password: "{{ vault_fing_database_password | default('`
**Line Content:** `fing_database_password: "{{ vault_fing_database_password | default('') }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 186
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `fing_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 27
**Match:** `password: "{{ vault_fing_admin_password | default('`
**Line Content:** `fing_admin_password: "{{ vault_fing_admin_password | default('') }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 35
**Match:** `password: "{{ vault_fing_database_password | default('`
**Line Content:** `fing_database_password: "{{ vault_fing_database_password | default('') }}"`

**File:** roles/fing/defaults/main.yml
**Line:** 186
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `fing_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_pezzo_postgres_password | default('`
**Line Content:** `pezzo_database_password: "{{ vault_pezzo_postgres_password | default('') }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 39
**Match:** `password: "{{ vault_pezzo_redis_password | default('`
**Line Content:** `pezzo_redis_password: "{{ vault_pezzo_redis_password | default('') }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 46
**Match:** `password: "{{ vault_pezzo_clickhouse_password | default('`
**Line Content:** `pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | default('') }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_pezzo_postgres_password | default('`
**Line Content:** `pezzo_database_password: "{{ vault_pezzo_postgres_password | default('') }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 39
**Match:** `password: "{{ vault_pezzo_redis_password | default('`
**Line Content:** `pezzo_redis_password: "{{ vault_pezzo_redis_password | default('') }}"`

**File:** roles/pezzo/defaults/main.yml
**Line:** 46
**Match:** `password: "{{ vault_pezzo_clickhouse_password | default('`
**Line Content:** `pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | default('') }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 164
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 175
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 186
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 164
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 175
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/deploy-dashboards.yml
**Line:** 186
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 25
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 37
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 49
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 61
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 73
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 85
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 97
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 109
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 25
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 37
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 49
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 61
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 73
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 85
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 97
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/validation.yml
**Line:** 109
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 10
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 51
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 63
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 10
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 51
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/users.yml
**Line:** 63
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/automation_integration.yml
**Line:** 106
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/automation_integration.yml
**Line:** 106
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 104
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 135
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 161
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 104
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 135
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/dashboards.yml
**Line:** 161
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 10
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 51
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 63
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 10
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 51
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/alerts.yml
**Line:** 63
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 41
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 56
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 70
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 41
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 56
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/tasks/datasources.yml
**Line:** 70
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 15
**Match:** `password: "{{ vault_grafana_admin_password }}"`
**Line Content:** `grafana_admin_password: "{{ vault_grafana_admin_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 24
**Match:** `password: "{{ vault_grafana_db_password | default('`
**Line Content:** `grafana_database_password: "{{ vault_grafana_db_password | default('grafana') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 83
**Match:** `password: "{{ grafana_database_password }}"`
**Line Content:** `password: "{{ grafana_database_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 184
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 189
**Match:** `password: "{{ vault_grafana_viewer_password | default('`
**Line Content:** `password: "{{ vault_grafana_viewer_password | default('viewer') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 194
**Match:** `password: "{{ vault_grafana_editor_password | default('`
**Line Content:** `password: "{{ vault_grafana_editor_password | default('editor') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 393
**Match:** `PASSWORD: "{{ grafana_admin_password }}"`
**Line Content:** `GF_SECURITY_ADMIN_PASSWORD: "{{ grafana_admin_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 15
**Match:** `password: "{{ vault_grafana_admin_password }}"`
**Line Content:** `grafana_admin_password: "{{ vault_grafana_admin_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 24
**Match:** `password: "{{ vault_grafana_db_password | default('`
**Line Content:** `grafana_database_password: "{{ vault_grafana_db_password | default('grafana') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 83
**Match:** `password: "{{ grafana_database_password }}"`
**Line Content:** `password: "{{ grafana_database_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 184
**Match:** `password: "{{ grafana_admin_password }}"`
**Line Content:** `password: "{{ grafana_admin_password }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 189
**Match:** `password: "{{ vault_grafana_viewer_password | default('`
**Line Content:** `password: "{{ vault_grafana_viewer_password | default('viewer') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 194
**Match:** `password: "{{ vault_grafana_editor_password | default('`
**Line Content:** `password: "{{ vault_grafana_editor_password | default('editor') }}"`

**File:** roles/grafana/defaults/main.yml
**Line:** 393
**Match:** `PASSWORD: "{{ grafana_admin_password }}"`
**Line Content:** `GF_SECURITY_ADMIN_PASSWORD: "{{ grafana_admin_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_radarr_admin_password }}"`
**Line Content:** `radarr_admin_password: "{{ vault_radarr_admin_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 61
**Match:** `password: "{{ vault_radarr_database_password }}"`
**Line Content:** `radarr_database_password: "{{ vault_radarr_database_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 67
**Match:** `password: "{{ vault_radarr_redis_password }}"`
**Line Content:** `radarr_redis_password: "{{ vault_radarr_redis_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 125
**Match:** `password: "{{ vault_radarr_smtp_password }}"`
**Line Content:** `radarr_smtp_password: "{{ vault_radarr_smtp_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 161
**Match:** `password: "{{ vault_qbittorrent_password }}"`
**Line Content:** `password: "{{ vault_qbittorrent_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_radarr_admin_password }}"`
**Line Content:** `radarr_admin_password: "{{ vault_radarr_admin_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 61
**Match:** `password: "{{ vault_radarr_database_password }}"`
**Line Content:** `radarr_database_password: "{{ vault_radarr_database_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 67
**Match:** `password: "{{ vault_radarr_redis_password }}"`
**Line Content:** `radarr_redis_password: "{{ vault_radarr_redis_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 125
**Match:** `password: "{{ vault_radarr_smtp_password }}"`
**Line Content:** `radarr_smtp_password: "{{ vault_radarr_smtp_password }}"`

**File:** roles/radarr/defaults/main.yml
**Line:** 161
**Match:** `password: "{{ vault_qbittorrent_password }}"`
**Line Content:** `password: "{{ vault_qbittorrent_password }}"`

**File:** roles/ersatztv/defaults/main.yml
**Line:** 58
**Match:** `password: "{{ vault_ersatztv_database_password | default('`
**Line Content:** `ersatztv_database_password: "{{ vault_ersatztv_database_password | default('') }}"`

**File:** roles/ersatztv/defaults/main.yml
**Line:** 58
**Match:** `password: "{{ vault_ersatztv_database_password | default('`
**Line Content:** `ersatztv_database_password: "{{ vault_ersatztv_database_password | default('') }}"`

**File:** roles/storage/vars/main.yml
**Line:** 5
**Match:** `password: ""`
**Line Content:** `vault_nextcloud_admin_password: ""`

**File:** roles/storage/vars/main.yml
**Line:** 6
**Match:** `password: ""`
**Line Content:** `vault_nextcloud_db_password: ""`

**File:** roles/storage/vars/main.yml
**Line:** 7
**Match:** `password: ""`
**Line Content:** `vault_nextcloud_db_root_password: ""`

**File:** roles/storage/vars/main.yml
**Line:** 5
**Match:** `password: ""`
**Line Content:** `vault_nextcloud_admin_password: ""`

**File:** roles/storage/vars/main.yml
**Line:** 6
**Match:** `password: ""`
**Line Content:** `vault_nextcloud_db_password: ""`

**File:** roles/storage/vars/main.yml
**Line:** 7
**Match:** `password: ""`
**Line Content:** `vault_nextcloud_db_root_password: ""`

**File:** roles/storage/defaults/main.yml
**Line:** 48
**Match:** `password: "{{ vault_nextcloud_admin_password }}"`
**Line Content:** `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`

**File:** roles/storage/defaults/main.yml
**Line:** 49
**Match:** `password: "{{ vault_nextcloud_db_password }}"`
**Line Content:** `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`

**File:** roles/storage/defaults/main.yml
**Line:** 50
**Match:** `password: "{{ vault_nextcloud_db_root_password }}"`
**Line Content:** `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`

**File:** roles/storage/defaults/main.yml
**Line:** 48
**Match:** `password: "{{ vault_nextcloud_admin_password }}"`
**Line Content:** `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`

**File:** roles/storage/defaults/main.yml
**Line:** 49
**Match:** `password: "{{ vault_nextcloud_db_password }}"`
**Line Content:** `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`

**File:** roles/storage/defaults/main.yml
**Line:** 50
**Match:** `password: "{{ vault_nextcloud_db_root_password }}"`
**Line Content:** `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`

**File:** roles/n8n/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_n8n_postgres_password | default('`
**Line Content:** `n8n_database_password: "{{ vault_n8n_postgres_password | default('') }}"`

**File:** roles/n8n/defaults/main.yml
**Line:** 53
**Match:** `password: "{{ vault_n8n_admin_password | password_hash("`
**Line Content:** `- N8N_BASIC_AUTH_password: "{{ vault_n8n_admin_password | password_hash("bcrypt") }}"true' if n8n_auth_method == 'authentik' else 'false' }}`

**File:** roles/n8n/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_n8n_postgres_password | default('`
**Line Content:** `n8n_database_password: "{{ vault_n8n_postgres_password | default('') }}"`

**File:** roles/n8n/defaults/main.yml
**Line:** 53
**Match:** `password: "{{ vault_n8n_admin_password | password_hash("`
**Line Content:** `- N8N_BASIC_AUTH_password: "{{ vault_n8n_admin_password | password_hash("bcrypt") }}"true' if n8n_auth_method == 'authentik' else 'false' }}`

**File:** roles/reconya/defaults/main.yml
**Line:** 25
**Match:** `password: "{{ vault_reconya_admin_password | default('`
**Line Content:** `reconya_admin_password: "{{ vault_reconya_admin_password | default('') }}"`

**File:** roles/reconya/defaults/main.yml
**Line:** 25
**Match:** `password: "{{ vault_reconya_admin_password | default('`
**Line Content:** `reconya_admin_password: "{{ vault_reconya_admin_password | default('') }}"`

**File:** roles/romm/tasks/deploy.yml
**Line:** 63
**Match:** `password: "{{ vault_romm_admin_password }}"`
**Line Content:** `password: "{{ vault_romm_admin_password }}"`

**File:** roles/romm/tasks/deploy.yml
**Line:** 63
**Match:** `password: "{{ vault_romm_admin_password }}"`
**Line Content:** `password: "{{ vault_romm_admin_password }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_romm_admin_password | default('`
**Line Content:** `romm_admin_password: "{{ vault_romm_admin_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 47
**Match:** `password: "{{ vault_romm_database_password | default('`
**Line Content:** `romm_database_password: "{{ vault_romm_database_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 138
**Match:** `PASSWORD: "{{ vault_romm_admin_password | default('`
**Line Content:** `ROMM_ADMIN_PASSWORD: "{{ vault_romm_admin_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 145
**Match:** `PASSWORD: "{{ vault_romm_database_password | default('`
**Line Content:** `ROMM_DATABASE_PASSWORD: "{{ vault_romm_database_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 218
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `romm_email_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_romm_admin_password | default('`
**Line Content:** `romm_admin_password: "{{ vault_romm_admin_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 47
**Match:** `password: "{{ vault_romm_database_password | default('`
**Line Content:** `romm_database_password: "{{ vault_romm_database_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 138
**Match:** `PASSWORD: "{{ vault_romm_admin_password | default('`
**Line Content:** `ROMM_ADMIN_PASSWORD: "{{ vault_romm_admin_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 145
**Match:** `PASSWORD: "{{ vault_romm_database_password | default('`
**Line Content:** `ROMM_DATABASE_PASSWORD: "{{ vault_romm_database_password | default('') }}"`

**File:** roles/romm/defaults/main.yml
**Line:** 218
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `romm_email_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 17
**Match:** `password: "{{ vault_vaultwarden_postgres_password | default('`
**Line Content:** `vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 18
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `when: vaultwarden_database_type == 'postgresql' and (vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vault_vaultwarden_postgres_password }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 19
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_smtp_host is defined and vaultwarden_smtp_host != '' }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 29
**Match:** `password: "{{ vaultwarden_smtp_password | default('`
**Line Content:** `vaultwarden_smtp_password: "{{ vaultwarden_smtp_password | default('') }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 40
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `vaultwarden_database_url: "{{ 'postgresql://' + vaultwarden_database_user + ':' + vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_backup_include_attachments | default(true) }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 159
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_config_dir }}/secrets/homepage_api_key.txt"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 17
**Match:** `password: "{{ vault_vaultwarden_postgres_password | default('`
**Line Content:** `vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 18
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `when: vaultwarden_database_type == 'postgresql' and (vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vault_vaultwarden_postgres_password }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 19
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_smtp_host is defined and vaultwarden_smtp_host != '' }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 29
**Match:** `password: "{{ vaultwarden_smtp_password | default('`
**Line Content:** `vaultwarden_smtp_password: "{{ vaultwarden_smtp_password | default('') }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 40
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `vaultwarden_database_url: "{{ 'postgresql://' + vaultwarden_database_user + ':' + vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_backup_include_attachments | default(true) }}"`

**File:** roles/vaultwarden/tasks/configure.yml
**Line:** 159
**Match:** `password: "{{ vault_vaultwarden_admin_password | password_hash("`
**Line Content:** `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_config_dir }}/secrets/homepage_api_key.txt"`

**File:** roles/vaultwarden/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_vaultwarden_postgres_password | default('`
**Line Content:** `vaultwarden_database_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`

**File:** roles/vaultwarden/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_vaultwarden_postgres_password | default('`
**Line Content:** `vaultwarden_database_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`

**File:** roles/automation/home_automation/tasks/main.yml
**Line:** 95
**Match:** `password: "{{ zigbee2mqtt_mqtt_password }}"`
**Line Content:** `password: "{{ zigbee2mqtt_mqtt_password }}"`

**File:** roles/automation/home_automation/tasks/main.yml
**Line:** 95
**Match:** `password: "{{ zigbee2mqtt_mqtt_password }}"`
**Line Content:** `password: "{{ zigbee2mqtt_mqtt_password }}"`

**File:** roles/linkwarden/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_linkwarden_postgres_password | default('`
**Line Content:** `linkwarden_database_password: "{{ vault_linkwarden_postgres_password | default('') }}"`

**File:** roles/linkwarden/defaults/main.yml
**Line:** 32
**Match:** `password: "{{ vault_linkwarden_postgres_password | default('`
**Line Content:** `linkwarden_database_password: "{{ vault_linkwarden_postgres_password | default('') }}"`

**File:** roles/sonarr/tasks/deploy.yml
**Line:** 137
**Match:** `password: "{{ sonarr_admin_password }}"`
**Line Content:** `password: "{{ sonarr_admin_password }}"`

**File:** roles/sonarr/tasks/deploy.yml
**Line:** 137
**Match:** `password: "{{ sonarr_admin_password }}"`
**Line Content:** `password: "{{ sonarr_admin_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_sonarr_admin_password }}"`
**Line Content:** `sonarr_admin_password: "{{ vault_sonarr_admin_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 61
**Match:** `password: "{{ vault_sonarr_database_password }}"`
**Line Content:** `sonarr_database_password: "{{ vault_sonarr_database_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 67
**Match:** `password: "{{ vault_sonarr_redis_password }}"`
**Line Content:** `sonarr_redis_password: "{{ vault_sonarr_redis_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 125
**Match:** `password: "{{ vault_sonarr_smtp_password }}"`
**Line Content:** `sonarr_smtp_password: "{{ vault_sonarr_smtp_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 161
**Match:** `password: "{{ vault_qbittorrent_password }}"`
**Line Content:** `password: "{{ vault_qbittorrent_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 34
**Match:** `password: "{{ vault_sonarr_admin_password }}"`
**Line Content:** `sonarr_admin_password: "{{ vault_sonarr_admin_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 61
**Match:** `password: "{{ vault_sonarr_database_password }}"`
**Line Content:** `sonarr_database_password: "{{ vault_sonarr_database_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 67
**Match:** `password: "{{ vault_sonarr_redis_password }}"`
**Line Content:** `sonarr_redis_password: "{{ vault_sonarr_redis_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 125
**Match:** `password: "{{ vault_sonarr_smtp_password }}"`
**Line Content:** `sonarr_smtp_password: "{{ vault_sonarr_smtp_password }}"`

**File:** roles/sonarr/defaults/main.yml
**Line:** 161
**Match:** `password: "{{ vault_qbittorrent_password }}"`
**Line Content:** `password: "{{ vault_qbittorrent_password }}"`

**File:** roles/paperless_ngx/tasks/deploy.yml
**Line:** 97
**Match:** `password: "{{ paperless_ngx_admin_password }}"`
**Line Content:** `password: "{{ paperless_ngx_admin_password }}"`

**File:** roles/paperless_ngx/tasks/deploy.yml
**Line:** 110
**Match:** `password: "{{ vault_paperless_ngx_admin_password | password_hash("`
**Line Content:** `- paperless_ngx_admin_password: "{{ vault_paperless_ngx_admin_password | password_hash("bcrypt") }}"http://{{ ansible_default_ipv4.address }}:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/"`

**File:** roles/paperless_ngx/tasks/deploy.yml
**Line:** 97
**Match:** `password: "{{ paperless_ngx_admin_password }}"`
**Line Content:** `password: "{{ paperless_ngx_admin_password }}"`

**File:** roles/paperless_ngx/tasks/deploy.yml
**Line:** 110
**Match:** `password: "{{ vault_paperless_ngx_admin_password | password_hash("`
**Line Content:** `- paperless_ngx_admin_password: "{{ vault_paperless_ngx_admin_password | password_hash("bcrypt") }}"http://{{ ansible_default_ipv4.address }}:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 107
**Match:** `password: "{{ postgresql_admin_password | default('`
**Line Content:** `login_password: "{{ postgresql_admin_password | default('') }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 116
**Match:** `password: "{{ paperless_ngx_database_password }}"`
**Line Content:** `password: "{{ paperless_ngx_database_password }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 120
**Match:** `password: "{{ postgresql_admin_password | default('`
**Line Content:** `login_password: "{{ postgresql_admin_password | default('') }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 107
**Match:** `password: "{{ postgresql_admin_password | default('`
**Line Content:** `login_password: "{{ postgresql_admin_password | default('') }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 116
**Match:** `password: "{{ paperless_ngx_database_password }}"`
**Line Content:** `password: "{{ paperless_ngx_database_password }}"`

**File:** roles/paperless_ngx/tasks/prerequisites.yml
**Line:** 120
**Match:** `password: "{{ postgresql_admin_password | default('`
**Line Content:** `login_password: "{{ postgresql_admin_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 27
**Match:** `password: "{{ vault_paperless_admin_password | default('`
**Line Content:** `paperless_ngx_admin_password: "{{ vault_paperless_admin_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 36
**Match:** `password: "{{ vault_paperless_database_password | default('`
**Line Content:** `paperless_ngx_database_password: "{{ vault_paperless_database_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 41
**Match:** `password: "{{ vault_redis_password | default('`
**Line Content:** `paperless_ngx_redis_password: "{{ vault_redis_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 208
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `paperless_ngx_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 27
**Match:** `password: "{{ vault_paperless_admin_password | default('`
**Line Content:** `paperless_ngx_admin_password: "{{ vault_paperless_admin_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 36
**Match:** `password: "{{ vault_paperless_database_password | default('`
**Line Content:** `paperless_ngx_database_password: "{{ vault_paperless_database_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 41
**Match:** `password: "{{ vault_redis_password | default('`
**Line Content:** `paperless_ngx_redis_password: "{{ vault_redis_password | default('') }}"`

**File:** roles/paperless_ngx/defaults/main.yml
**Line:** 208
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `paperless_ngx_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 66
**Match:** `password: "{{ vault_media_database_password | default('`
**Line Content:** `media_database_password: "{{ vault_media_database_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 71
**Match:** `password: "{{ vault_redis_password | default('`
**Line Content:** `media_redis_password: "{{ vault_redis_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 570
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `media_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 704
**Match:** `password: "{{ vault_lidarr_password | default('`
**Line Content:** `media_lidarr_password: "{{ vault_lidarr_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 707
**Match:** `password: "{{ vault_qbittorrent_password | default('`
**Line Content:** `media_qbittorrent_password: "{{ vault_qbittorrent_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 66
**Match:** `password: "{{ vault_media_database_password | default('`
**Line Content:** `media_database_password: "{{ vault_media_database_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 71
**Match:** `password: "{{ vault_redis_password | default('`
**Line Content:** `media_redis_password: "{{ vault_redis_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 570
**Match:** `password: "{{ vault_smtp_password | default('`
**Line Content:** `media_smtp_password: "{{ vault_smtp_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 704
**Match:** `password: "{{ vault_lidarr_password | default('`
**Line Content:** `media_lidarr_password: "{{ vault_lidarr_password | default('') }}"`

**File:** roles/media/defaults/main.yml
**Line:** 707
**Match:** `password: "{{ vault_qbittorrent_password | default('`
**Line Content:** `media_qbittorrent_password: "{{ vault_qbittorrent_password | default('') }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 41
**Match:** `PASSWORD: "{{ vault_npm_db_root_password }}"`
**Line Content:** `MYSQL_ROOT_PASSWORD: "{{ vault_npm_db_root_password }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 44
**Match:** `PASSWORD: "{{ vault_npm_db_password }}"`
**Line Content:** `MYSQL_PASSWORD: "{{ vault_npm_db_password }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 62
**Match:** `password: "{{ vault_npm_admin_password }}"`
**Line Content:** `nginx_proxy_manager_api_password: "{{ vault_npm_admin_password }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 41
**Match:** `PASSWORD: "{{ vault_npm_db_root_password }}"`
**Line Content:** `MYSQL_ROOT_PASSWORD: "{{ vault_npm_db_root_password }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 44
**Match:** `PASSWORD: "{{ vault_npm_db_password }}"`
**Line Content:** `MYSQL_PASSWORD: "{{ vault_npm_db_password }}"`

**File:** roles/nginx_proxy_manager/defaults/main.yml
**Line:** 62
**Match:** `password: "{{ vault_npm_admin_password }}"`
**Line Content:** `nginx_proxy_manager_api_password: "{{ vault_npm_admin_password }}"`

**File:** scripts/setup.sh
**Line:** 95
**Match:** `password: " proxmox_password
echo

# Network Configuration
domain_name="`
**Line Content:** `read -sp "Enter Proxmox password: " proxmox_password`

**File:** scripts/setup.sh
**Line:** 110
**Match:** `password: "$proxmox_password"`
**Line Content:** `proxmox_password: "$proxmox_password"`

**File:** scripts/setup.sh
**Line:** 95
**Match:** `password: " proxmox_password
echo

# Network Configuration
domain_name="`
**Line Content:** `read -sp "Enter Proxmox password: " proxmox_password`

**File:** scripts/setup.sh
**Line:** 110
**Match:** `password: "$proxmox_password"`
**Line Content:** `proxmox_password: "$proxmox_password"`

**File:** scripts/setup_vault_env.sh
**Line:** 153
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_POSTGRESQL_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 154
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MEDIA_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 155
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PAPERLESS_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 156
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_FING_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 157
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_ROMM_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 158
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_REDIS_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 159
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 160
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_INFLUXDB_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 161
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_IMMICH_DB_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 162
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_IMMICH_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 163
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_NEXTCLOUD_DB_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 164
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_NEXTCLOUD_DB_ROOT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 165
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_LINKWARDEN_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 166
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_N8N_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 167
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PEZZO_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 168
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_AUTHENTIK_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 169
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_VAULTWARDEN_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 172
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_AUTHENTIK_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 173
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_GRAFANA_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 174
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PAPERLESS_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 175
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_FING_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 176
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_ROMM_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 177
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_HOMEASSISTANT_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 178
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MOSQUITTO_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 179
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_NEXTCLOUD_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 180
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_SYNCTHING_GUI_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 181
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PIHOLE_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 182
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 183
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PROXMOX_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 186
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_JELLYFIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 187
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_CALIBRE_WEB_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 188
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_AUDIOBOOKSHELF_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 189
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_SABNZBD_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 190
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_TDARR_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 191
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_QBITTORRENT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 283
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 289
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_IMMICH_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 290
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_VAULTWARDEN_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 291
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_FING_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 294
**Match:** `PASSWORD=""`
**Line Content:** `export VAULT_AUTHENTIK_LDAP_PASSWORD=""`

**File:** scripts/setup_vault_env.sh
**Line:** 297
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_ZIGBEE2MQTT_MQTT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 118
**Match:** `Password: " smtp_password
echo

# Get Cloudflare configuration (optional)
print_status "`
**Line Content:** `read -s -p "SMTP Password: " smtp_password`

**File:** scripts/setup_vault_env.sh
**Line:** 153
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_POSTGRESQL_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 154
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MEDIA_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 155
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PAPERLESS_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 156
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_FING_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 157
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_ROMM_DATABASE_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 158
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_REDIS_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 159
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 160
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_INFLUXDB_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 161
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_IMMICH_DB_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 162
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_IMMICH_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 163
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_NEXTCLOUD_DB_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 164
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_NEXTCLOUD_DB_ROOT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 165
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_LINKWARDEN_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 166
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_N8N_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 167
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PEZZO_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 168
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_AUTHENTIK_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 169
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_VAULTWARDEN_POSTGRES_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 172
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_AUTHENTIK_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 173
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_GRAFANA_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 174
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PAPERLESS_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 175
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_FING_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 176
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_ROMM_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 177
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_HOMEASSISTANT_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 178
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MOSQUITTO_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 179
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_NEXTCLOUD_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 180
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_SYNCTHING_GUI_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 181
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PIHOLE_ADMIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 182
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 183
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_PROXMOX_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 186
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_JELLYFIN_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 187
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_CALIBRE_WEB_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 188
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_AUDIOBOOKSHELF_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 189
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_SABNZBD_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 190
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_TDARR_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 191
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_QBITTORRENT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 283
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 289
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_IMMICH_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 290
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_VAULTWARDEN_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 291
**Match:** `PASSWORD="${smtp_password:-}"`
**Line Content:** `export VAULT_FING_SMTP_PASSWORD="${smtp_password:-}"`

**File:** scripts/setup_vault_env.sh
**Line:** 294
**Match:** `PASSWORD=""`
**Line Content:** `export VAULT_AUTHENTIK_LDAP_PASSWORD=""`

**File:** scripts/setup_vault_env.sh
**Line:** 297
**Match:** `PASSWORD="$(generate_password)"`
**Line Content:** `export VAULT_ZIGBEE2MQTT_MQTT_PASSWORD="$(generate_password)"`

**File:** scripts/setup_vault_env.sh
**Line:** 118
**Match:** `Password: " smtp_password
echo

# Get Cloudflare configuration (optional)
print_status "`
**Line Content:** `read -s -p "SMTP Password: " smtp_password`

**File:** scripts/service_wizard.py
**Line:** 960
**Match:** `password: "{{{{ vault_{service_info.name}_admin_password | default('`
**Line Content:** `{service_info.name}_admin_password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 973
**Match:** `password: "{{{{ vault_{service_info.name}_database_password | default('`
**Line Content:** `{service_info.name}_database_password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1068
**Match:** `PASSWORD: "{{{{ vault_{service_info.name}_admin_password | default('`
**Line Content:** `{service_info.name.upper()}_ADMIN_PASSWORD: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1078
**Match:** `PASSWORD: "{{{{ vault_{service_info.name}_database_password | default('`
**Line Content:** `{service_info.name.upper()}_DATABASE_PASSWORD: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1166
**Match:** `password: "{{{{ vault_smtp_password | default('`
**Line Content:** `{service_info.name}_email_password: "{{{{ vault_smtp_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1317
**Match:** `password: "{{{{ vault_{service_info.name}_admin_password | default('`
**Line Content:** `password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1366
**Match:** `password: "{{{{ vault_{service_info.name}_database_password | default('`
**Line Content:** `password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 960
**Match:** `password: "{{{{ vault_{service_info.name}_admin_password | default('`
**Line Content:** `{service_info.name}_admin_password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 973
**Match:** `password: "{{{{ vault_{service_info.name}_database_password | default('`
**Line Content:** `{service_info.name}_database_password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1068
**Match:** `PASSWORD: "{{{{ vault_{service_info.name}_admin_password | default('`
**Line Content:** `{service_info.name.upper()}_ADMIN_PASSWORD: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1078
**Match:** `PASSWORD: "{{{{ vault_{service_info.name}_database_password | default('`
**Line Content:** `{service_info.name.upper()}_DATABASE_PASSWORD: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1166
**Match:** `password: "{{{{ vault_smtp_password | default('`
**Line Content:** `{service_info.name}_email_password: "{{{{ vault_smtp_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1317
**Match:** `password: "{{{{ vault_{service_info.name}_admin_password | default('`
**Line Content:** `password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`

**File:** scripts/service_wizard.py
**Line:** 1366
**Match:** `password: "{{{{ vault_{service_info.name}_database_password | default('`
**Line Content:** `password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`

**File:** scripts/fix_vault_variables.sh
**Line:** 276
**Match:** `password: '{{ vault_nextcloud_admin_password }}'`
**Line Content:** `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 277
**Match:** `password: '{{ vault_nextcloud_admin_password }}'`
**Line Content:** `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 276
**Match:** `password: '{{ vault_nextcloud_admin_password }}'`
**Line Content:** `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`

**File:** scripts/fix_vault_variables.sh
**Line:** 277
**Match:** `password: '{{ vault_nextcloud_admin_password }}'`
**Line Content:** `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`

**File:** scripts/setup_environment.sh
**Line:** 203
**Match:** `PASSWORD=""`
**Line Content:** `SMTP_PASSWORD=""`

**File:** scripts/setup_environment.sh
**Line:** 363
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_postgresql_password: "{{ lookup('env', 'POSTGRESQL_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 364
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_redis_password: "{{ lookup('env', 'REDIS_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 367
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_grafana_admin_password: "{{ lookup('env', 'GRAFANA_ADMIN_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 368
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'AUTHENTIK_ADMIN_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 383
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_smtp_password: "{{ lookup('env', 'SMTP_PASSWORD', default='') }}"`

**File:** scripts/setup_environment.sh
**Line:** 203
**Match:** `PASSWORD=""`
**Line Content:** `SMTP_PASSWORD=""`

**File:** scripts/setup_environment.sh
**Line:** 363
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_postgresql_password: "{{ lookup('env', 'POSTGRESQL_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 364
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_redis_password: "{{ lookup('env', 'REDIS_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 367
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_grafana_admin_password: "{{ lookup('env', 'GRAFANA_ADMIN_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 368
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_authentik_admin_password: "{{ lookup('env', 'AUTHENTIK_ADMIN_PASSWORD') }}"`

**File:** scripts/setup_environment.sh
**Line:** 383
**Match:** `password: "{{ lookup('`
**Line Content:** `vault_smtp_password: "{{ lookup('env', 'SMTP_PASSWORD', default='') }}"`

**File:** scripts/systematic_replacement.py
**Line:** 34
**Match:** `password: "{{ vault_{{ service }}_admin_password | password_hash("`
**Line Content:** `r'password.*=.*["\']([^"\']+)["\']': 'password: "{{ vault_{{ service }}_admin_password | password_hash("bcrypt") }}"',`

**File:** scripts/systematic_replacement.py
**Line:** 34
**Match:** `password: "{{ vault_{{ service }}_admin_password | password_hash("`
**Line Content:** `r'password.*=.*["\']([^"\']+)["\']': 'password: "{{ vault_{{ service }}_admin_password | password_hash("bcrypt") }}"',`

**File:** scripts/seamless_setup.sh
**Line:** 602
**Match:** `password="${smtp_password:-}"`
**Line Content:** `local vaultwarden_smtp_password="${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 668
**Match:** `password="${smtp_password:-}"`
**Line Content:** `local backup_smtp_password="${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 687
**Match:** `password="${smtp_password:-}"`
**Line Content:** `local immich_smtp_password="${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 332
**Match:** `Password: " smtp_password
        echo
        read -p "`
**Line Content:** `read -sp "SMTP Password: " smtp_password`

**File:** scripts/seamless_setup.sh
**Line:** 712
**Match:** `password: "$postgresql_password"`
**Line Content:** `vault_postgresql_password: "$postgresql_password"`

**File:** scripts/seamless_setup.sh
**Line:** 713
**Match:** `password: "$media_database_password"`
**Line Content:** `vault_media_database_password: "$media_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 714
**Match:** `password: "$paperless_database_password"`
**Line Content:** `vault_paperless_database_password: "$paperless_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 715
**Match:** `password: "$fing_database_password"`
**Line Content:** `vault_fing_database_password: "$fing_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 716
**Match:** `password: "$redis_password"`
**Line Content:** `vault_redis_password: "$redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 717
**Match:** `password: "$mariadb_root_password"`
**Line Content:** `vault_mariadb_root_password: "$mariadb_root_password"`

**File:** scripts/seamless_setup.sh
**Line:** 720
**Match:** `password: "$influxdb_admin_password"`
**Line Content:** `vault_influxdb_admin_password: "$influxdb_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 724
**Match:** `password: "$paperless_admin_password"`
**Line Content:** `vault_paperless_admin_password: "$paperless_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 726
**Match:** `password: "$fing_admin_password"`
**Line Content:** `vault_fing_admin_password: "$fing_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 746
**Match:** `password: "$lidarr_password"`
**Line Content:** `vault_lidarr_password: "$lidarr_password"`

**File:** scripts/seamless_setup.sh
**Line:** 748
**Match:** `password: "$qbittorrent_password"`
**Line Content:** `vault_qbittorrent_password: "$qbittorrent_password"`

**File:** scripts/seamless_setup.sh
**Line:** 751
**Match:** `password: "$homeassistant_admin_password"`
**Line Content:** `vault_homeassistant_admin_password: "$homeassistant_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 752
**Match:** `password: "$(generate_secure_password 32 '`
**Line Content:** `vault_mosquitto_admin_password: "$(generate_secure_password 32 'alphanumeric')"`

**File:** scripts/seamless_setup.sh
**Line:** 753
**Match:** `password: "$(generate_secure_password 32 '`
**Line Content:** `vault_zigbee2mqtt_mqtt_password: "$(generate_secure_password 32 'alphanumeric')"`

**File:** scripts/seamless_setup.sh
**Line:** 756
**Match:** `password: "$nextcloud_admin_password"`
**Line Content:** `vault_nextcloud_admin_password: "$nextcloud_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 757
**Match:** `password: "$nextcloud_db_password"`
**Line Content:** `vault_nextcloud_db_password: "$nextcloud_db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 758
**Match:** `password: "$nextcloud_db_root_password"`
**Line Content:** `vault_nextcloud_db_root_password: "$nextcloud_db_root_password"`

**File:** scripts/seamless_setup.sh
**Line:** 759
**Match:** `password: "$(generate_secure_password 32 '`
**Line Content:** `vault_syncthing_gui_password: "$(generate_secure_password 32 'full')"`

**File:** scripts/seamless_setup.sh
**Line:** 766
**Match:** `password: "$grafana_admin_password"`
**Line Content:** `vault_grafana_admin_password: "$grafana_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 771
**Match:** `password: "$authentik_postgres_password"`
**Line Content:** `vault_authentik_postgres_password: "$authentik_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 773
**Match:** `password: "$authentik_admin_password"`
**Line Content:** `vault_authentik_admin_password: "$authentik_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 774
**Match:** `password: "$authentik_redis_password"`
**Line Content:** `vault_authentik_redis_password: "$authentik_redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 780
**Match:** `password: "$immich_db_password"`
**Line Content:** `vault_immich_db_password: "$immich_db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 781
**Match:** `password: "$immich_redis_password"`
**Line Content:** `vault_immich_redis_password: "$immich_redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 783
**Match:** `password: "$immich_postgres_password"`
**Line Content:** `vault_immich_postgres_password: "$immich_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 786
**Match:** `password: "$linkwarden_postgres_password"`
**Line Content:** `vault_linkwarden_postgres_password: "$linkwarden_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 791
**Match:** `password: "${smtp_password:-}"`
**Line Content:** `vault_smtp_password: "${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 803
**Match:** `password: "$pihole_admin_password"`
**Line Content:** `vault_pihole_admin_password: "$pihole_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 806
**Match:** `password: "$reconya_admin_password"`
**Line Content:** `vault_reconya_admin_password: "$reconya_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 810
**Match:** `password: "$n8n_admin_password"`
**Line Content:** `vault_n8n_admin_password: "$n8n_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 812
**Match:** `password: "$n8n_postgres_password"`
**Line Content:** `vault_n8n_postgres_password: "$n8n_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 815
**Match:** `password: "$pezzo_postgres_password"`
**Line Content:** `vault_pezzo_postgres_password: "$pezzo_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 816
**Match:** `password: "$pezzo_redis_password"`
**Line Content:** `vault_pezzo_redis_password: "$pezzo_redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 817
**Match:** `password: "$pezzo_clickhouse_password"`
**Line Content:** `vault_pezzo_clickhouse_password: "$pezzo_clickhouse_password"`

**File:** scripts/seamless_setup.sh
**Line:** 842
**Match:** `password: "$gitlab_root_password"`
**Line Content:** `vault_gitlab_root_password: "$gitlab_root_password"`

**File:** scripts/seamless_setup.sh
**Line:** 843
**Match:** `password: "$portainer_admin_password"`
**Line Content:** `vault_portainer_admin_password: "$portainer_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 844
**Match:** `password: "$vaultwarden_admin_password"`
**Line Content:** `vault_vaultwarden_admin_password: "$vaultwarden_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 845
**Match:** `password: "$homepage_admin_password"`
**Line Content:** `vault_homepage_admin_password: "$homepage_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 848
**Match:** `password: "$wireguard_password"`
**Line Content:** `vault_wireguard_password: "$wireguard_password"`

**File:** scripts/seamless_setup.sh
**Line:** 849
**Match:** `password: "$codeserver_password"`
**Line Content:** `vault_codeserver_password: "$codeserver_password"`

**File:** scripts/seamless_setup.sh
**Line:** 865
**Match:** `password: "$vaultwarden_postgres_password"`
**Line Content:** `vault_vaultwarden_postgres_password: "$vaultwarden_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 870
**Match:** `password: "$vaultwarden_smtp_password"`
**Line Content:** `vault_vaultwarden_smtp_password: "$vaultwarden_smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 902
**Match:** `password: "$lidarr_password"`
**Line Content:** `vault_lidarr_password: "$lidarr_password"`

**File:** scripts/seamless_setup.sh
**Line:** 904
**Match:** `password: "$plex_password"`
**Line Content:** `vault_plex_password: "$plex_password"`

**File:** scripts/seamless_setup.sh
**Line:** 906
**Match:** `password: "$jellyfin_password"`
**Line Content:** `vault_jellyfin_password: "$jellyfin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 921
**Match:** `password: "$elasticsearch_password"`
**Line Content:** `vault_elasticsearch_password: "$elasticsearch_password"`

**File:** scripts/seamless_setup.sh
**Line:** 923
**Match:** `password: "$kibana_password"`
**Line Content:** `vault_kibana_password: "$kibana_password"`

**File:** scripts/seamless_setup.sh
**Line:** 929
**Match:** `password: "$ersatztv_database_password"`
**Line Content:** `vault_ersatztv_database_password: "$ersatztv_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 932
**Match:** `password: "$grafana_db_password"`
**Line Content:** `vault_grafana_db_password: "$grafana_db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 933
**Match:** `password: "$grafana_viewer_password"`
**Line Content:** `vault_grafana_viewer_password: "$grafana_viewer_password"`

**File:** scripts/seamless_setup.sh
**Line:** 934
**Match:** `password: "$grafana_editor_password"`
**Line Content:** `vault_grafana_editor_password: "$grafana_editor_password"`

**File:** scripts/seamless_setup.sh
**Line:** 948
**Match:** `password: "$postgresql_admin_password"`
**Line Content:** `vault_postgresql_admin_password: "$postgresql_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 949
**Match:** `password: "$elasticsearch_elastic_password"`
**Line Content:** `vault_elasticsearch_elastic_password: "$elasticsearch_elastic_password"`

**File:** scripts/seamless_setup.sh
**Line:** 952
**Match:** `password: "$backup_smtp_password"`
**Line Content:** `vault_backup_smtp_password: "$backup_smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 955
**Match:** `password: "$immich_admin_password"`
**Line Content:** `vault_immich_admin_password: "$immich_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 957
**Match:** `password: "$immich_smtp_password"`
**Line Content:** `vault_immich_smtp_password: "$immich_smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 966
**Match:** `password: "$pihole_database_password"`
**Line Content:** `vault_pihole_database_password: "$pihole_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 977
**Match:** `password: "$samba_password"`
**Line Content:** `vault_samba_password: "$samba_password"`

**File:** scripts/seamless_setup.sh
**Line:** 978
**Match:** `password: "$pihole_web_password"`
**Line Content:** `vault_pihole_web_password: "$pihole_web_password"`

**File:** scripts/seamless_setup.sh
**Line:** 979
**Match:** `password: "$admin_password"`
**Line Content:** `vault_admin_password: "$admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 980
**Match:** `password: "$db_password"`
**Line Content:** `vault_db_password: "$db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 981
**Match:** `password: "$paperless_ngx_admin_password"`
**Line Content:** `vault_paperless_ngx_admin_password: "$paperless_ngx_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 982
**Match:** `password: "$homepage_user_password"`
**Line Content:** `vault_homepage_user_password: "$homepage_user_password"`

**File:** scripts/seamless_setup.sh
**Line:** 987
**Match:** `password: "$calibre_web_password"`
**Line Content:** `vault_calibre_web_password: "$calibre_web_password"`

**File:** scripts/seamless_setup.sh
**Line:** 988
**Match:** `password: "$jellyfin_password"`
**Line Content:** `vault_jellyfin_password: "$jellyfin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 989
**Match:** `password: "$sabnzbd_password"`
**Line Content:** `vault_sabnzbd_password: "$sabnzbd_password"`

**File:** scripts/seamless_setup.sh
**Line:** 990
**Match:** `password: "$audiobookshelf_password"`
**Line Content:** `vault_audiobookshelf_password: "$audiobookshelf_password"`

**File:** scripts/seamless_setup.sh
**Line:** 991
**Match:** `password: "$authentik_postgres_password"`
**Line Content:** `vault_authentik_postgres_password: "$authentik_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 1332
**Match:** `password: "$smtp_password"`
**Line Content:** `password: "$smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 1518
**Match:** `password: "${smtp_password:-}"`
**Line Content:** `smtp_password: "${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 602
**Match:** `password="${smtp_password:-}"`
**Line Content:** `local vaultwarden_smtp_password="${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 668
**Match:** `password="${smtp_password:-}"`
**Line Content:** `local backup_smtp_password="${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 687
**Match:** `password="${smtp_password:-}"`
**Line Content:** `local immich_smtp_password="${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 332
**Match:** `Password: " smtp_password
        echo
        read -p "`
**Line Content:** `read -sp "SMTP Password: " smtp_password`

**File:** scripts/seamless_setup.sh
**Line:** 712
**Match:** `password: "$postgresql_password"`
**Line Content:** `vault_postgresql_password: "$postgresql_password"`

**File:** scripts/seamless_setup.sh
**Line:** 713
**Match:** `password: "$media_database_password"`
**Line Content:** `vault_media_database_password: "$media_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 714
**Match:** `password: "$paperless_database_password"`
**Line Content:** `vault_paperless_database_password: "$paperless_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 715
**Match:** `password: "$fing_database_password"`
**Line Content:** `vault_fing_database_password: "$fing_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 716
**Match:** `password: "$redis_password"`
**Line Content:** `vault_redis_password: "$redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 717
**Match:** `password: "$mariadb_root_password"`
**Line Content:** `vault_mariadb_root_password: "$mariadb_root_password"`

**File:** scripts/seamless_setup.sh
**Line:** 720
**Match:** `password: "$influxdb_admin_password"`
**Line Content:** `vault_influxdb_admin_password: "$influxdb_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 724
**Match:** `password: "$paperless_admin_password"`
**Line Content:** `vault_paperless_admin_password: "$paperless_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 726
**Match:** `password: "$fing_admin_password"`
**Line Content:** `vault_fing_admin_password: "$fing_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 746
**Match:** `password: "$lidarr_password"`
**Line Content:** `vault_lidarr_password: "$lidarr_password"`

**File:** scripts/seamless_setup.sh
**Line:** 748
**Match:** `password: "$qbittorrent_password"`
**Line Content:** `vault_qbittorrent_password: "$qbittorrent_password"`

**File:** scripts/seamless_setup.sh
**Line:** 751
**Match:** `password: "$homeassistant_admin_password"`
**Line Content:** `vault_homeassistant_admin_password: "$homeassistant_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 752
**Match:** `password: "$(generate_secure_password 32 '`
**Line Content:** `vault_mosquitto_admin_password: "$(generate_secure_password 32 'alphanumeric')"`

**File:** scripts/seamless_setup.sh
**Line:** 753
**Match:** `password: "$(generate_secure_password 32 '`
**Line Content:** `vault_zigbee2mqtt_mqtt_password: "$(generate_secure_password 32 'alphanumeric')"`

**File:** scripts/seamless_setup.sh
**Line:** 756
**Match:** `password: "$nextcloud_admin_password"`
**Line Content:** `vault_nextcloud_admin_password: "$nextcloud_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 757
**Match:** `password: "$nextcloud_db_password"`
**Line Content:** `vault_nextcloud_db_password: "$nextcloud_db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 758
**Match:** `password: "$nextcloud_db_root_password"`
**Line Content:** `vault_nextcloud_db_root_password: "$nextcloud_db_root_password"`

**File:** scripts/seamless_setup.sh
**Line:** 759
**Match:** `password: "$(generate_secure_password 32 '`
**Line Content:** `vault_syncthing_gui_password: "$(generate_secure_password 32 'full')"`

**File:** scripts/seamless_setup.sh
**Line:** 766
**Match:** `password: "$grafana_admin_password"`
**Line Content:** `vault_grafana_admin_password: "$grafana_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 771
**Match:** `password: "$authentik_postgres_password"`
**Line Content:** `vault_authentik_postgres_password: "$authentik_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 773
**Match:** `password: "$authentik_admin_password"`
**Line Content:** `vault_authentik_admin_password: "$authentik_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 774
**Match:** `password: "$authentik_redis_password"`
**Line Content:** `vault_authentik_redis_password: "$authentik_redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 780
**Match:** `password: "$immich_db_password"`
**Line Content:** `vault_immich_db_password: "$immich_db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 781
**Match:** `password: "$immich_redis_password"`
**Line Content:** `vault_immich_redis_password: "$immich_redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 783
**Match:** `password: "$immich_postgres_password"`
**Line Content:** `vault_immich_postgres_password: "$immich_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 786
**Match:** `password: "$linkwarden_postgres_password"`
**Line Content:** `vault_linkwarden_postgres_password: "$linkwarden_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 791
**Match:** `password: "${smtp_password:-}"`
**Line Content:** `vault_smtp_password: "${smtp_password:-}"`

**File:** scripts/seamless_setup.sh
**Line:** 803
**Match:** `password: "$pihole_admin_password"`
**Line Content:** `vault_pihole_admin_password: "$pihole_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 806
**Match:** `password: "$reconya_admin_password"`
**Line Content:** `vault_reconya_admin_password: "$reconya_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 810
**Match:** `password: "$n8n_admin_password"`
**Line Content:** `vault_n8n_admin_password: "$n8n_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 812
**Match:** `password: "$n8n_postgres_password"`
**Line Content:** `vault_n8n_postgres_password: "$n8n_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 815
**Match:** `password: "$pezzo_postgres_password"`
**Line Content:** `vault_pezzo_postgres_password: "$pezzo_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 816
**Match:** `password: "$pezzo_redis_password"`
**Line Content:** `vault_pezzo_redis_password: "$pezzo_redis_password"`

**File:** scripts/seamless_setup.sh
**Line:** 817
**Match:** `password: "$pezzo_clickhouse_password"`
**Line Content:** `vault_pezzo_clickhouse_password: "$pezzo_clickhouse_password"`

**File:** scripts/seamless_setup.sh
**Line:** 842
**Match:** `password: "$gitlab_root_password"`
**Line Content:** `vault_gitlab_root_password: "$gitlab_root_password"`

**File:** scripts/seamless_setup.sh
**Line:** 843
**Match:** `password: "$portainer_admin_password"`
**Line Content:** `vault_portainer_admin_password: "$portainer_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 844
**Match:** `password: "$vaultwarden_admin_password"`
**Line Content:** `vault_vaultwarden_admin_password: "$vaultwarden_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 845
**Match:** `password: "$homepage_admin_password"`
**Line Content:** `vault_homepage_admin_password: "$homepage_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 848
**Match:** `password: "$wireguard_password"`
**Line Content:** `vault_wireguard_password: "$wireguard_password"`

**File:** scripts/seamless_setup.sh
**Line:** 849
**Match:** `password: "$codeserver_password"`
**Line Content:** `vault_codeserver_password: "$codeserver_password"`

**File:** scripts/seamless_setup.sh
**Line:** 865
**Match:** `password: "$vaultwarden_postgres_password"`
**Line Content:** `vault_vaultwarden_postgres_password: "$vaultwarden_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 870
**Match:** `password: "$vaultwarden_smtp_password"`
**Line Content:** `vault_vaultwarden_smtp_password: "$vaultwarden_smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 902
**Match:** `password: "$lidarr_password"`
**Line Content:** `vault_lidarr_password: "$lidarr_password"`

**File:** scripts/seamless_setup.sh
**Line:** 904
**Match:** `password: "$plex_password"`
**Line Content:** `vault_plex_password: "$plex_password"`

**File:** scripts/seamless_setup.sh
**Line:** 906
**Match:** `password: "$jellyfin_password"`
**Line Content:** `vault_jellyfin_password: "$jellyfin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 921
**Match:** `password: "$elasticsearch_password"`
**Line Content:** `vault_elasticsearch_password: "$elasticsearch_password"`

**File:** scripts/seamless_setup.sh
**Line:** 923
**Match:** `password: "$kibana_password"`
**Line Content:** `vault_kibana_password: "$kibana_password"`

**File:** scripts/seamless_setup.sh
**Line:** 929
**Match:** `password: "$ersatztv_database_password"`
**Line Content:** `vault_ersatztv_database_password: "$ersatztv_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 932
**Match:** `password: "$grafana_db_password"`
**Line Content:** `vault_grafana_db_password: "$grafana_db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 933
**Match:** `password: "$grafana_viewer_password"`
**Line Content:** `vault_grafana_viewer_password: "$grafana_viewer_password"`

**File:** scripts/seamless_setup.sh
**Line:** 934
**Match:** `password: "$grafana_editor_password"`
**Line Content:** `vault_grafana_editor_password: "$grafana_editor_password"`

**File:** scripts/seamless_setup.sh
**Line:** 948
**Match:** `password: "$postgresql_admin_password"`
**Line Content:** `vault_postgresql_admin_password: "$postgresql_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 949
**Match:** `password: "$elasticsearch_elastic_password"`
**Line Content:** `vault_elasticsearch_elastic_password: "$elasticsearch_elastic_password"`

**File:** scripts/seamless_setup.sh
**Line:** 952
**Match:** `password: "$backup_smtp_password"`
**Line Content:** `vault_backup_smtp_password: "$backup_smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 955
**Match:** `password: "$immich_admin_password"`
**Line Content:** `vault_immich_admin_password: "$immich_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 957
**Match:** `password: "$immich_smtp_password"`
**Line Content:** `vault_immich_smtp_password: "$immich_smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 966
**Match:** `password: "$pihole_database_password"`
**Line Content:** `vault_pihole_database_password: "$pihole_database_password"`

**File:** scripts/seamless_setup.sh
**Line:** 977
**Match:** `password: "$samba_password"`
**Line Content:** `vault_samba_password: "$samba_password"`

**File:** scripts/seamless_setup.sh
**Line:** 978
**Match:** `password: "$pihole_web_password"`
**Line Content:** `vault_pihole_web_password: "$pihole_web_password"`

**File:** scripts/seamless_setup.sh
**Line:** 979
**Match:** `password: "$admin_password"`
**Line Content:** `vault_admin_password: "$admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 980
**Match:** `password: "$db_password"`
**Line Content:** `vault_db_password: "$db_password"`

**File:** scripts/seamless_setup.sh
**Line:** 981
**Match:** `password: "$paperless_ngx_admin_password"`
**Line Content:** `vault_paperless_ngx_admin_password: "$paperless_ngx_admin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 982
**Match:** `password: "$homepage_user_password"`
**Line Content:** `vault_homepage_user_password: "$homepage_user_password"`

**File:** scripts/seamless_setup.sh
**Line:** 987
**Match:** `password: "$calibre_web_password"`
**Line Content:** `vault_calibre_web_password: "$calibre_web_password"`

**File:** scripts/seamless_setup.sh
**Line:** 988
**Match:** `password: "$jellyfin_password"`
**Line Content:** `vault_jellyfin_password: "$jellyfin_password"`

**File:** scripts/seamless_setup.sh
**Line:** 989
**Match:** `password: "$sabnzbd_password"`
**Line Content:** `vault_sabnzbd_password: "$sabnzbd_password"`

**File:** scripts/seamless_setup.sh
**Line:** 990
**Match:** `password: "$audiobookshelf_password"`
**Line Content:** `vault_audiobookshelf_password: "$audiobookshelf_password"`

**File:** scripts/seamless_setup.sh
**Line:** 991
**Match:** `password: "$authentik_postgres_password"`
**Line Content:** `vault_authentik_postgres_password: "$authentik_postgres_password"`

**File:** scripts/seamless_setup.sh
**Line:** 1332
**Match:** `password: "$smtp_password"`
**Line Content:** `password: "$smtp_password"`

**File:** scripts/seamless_setup.sh
**Line:** 1518
**Match:** `password: "${smtp_password:-}"`
**Line Content:** `smtp_password: "${smtp_password:-}"`


==================================================
Fix Suggestions
==================================================
# Security Hardening Fix Suggestions

## security_hardening_results.json

### Localhost Issues

**Line 7:**
Current: `"mongodump --uri=\"mongodb://{{ item.user }}:{{ item.password }}@{{ item.host | default('localhost') }}:{{ item.port | default('27017') }}/{{ item.name }}\" --gzip --archive={{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.archive"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 102:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT version();\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 107:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT 1;\" &"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 112:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user | default('homelab') }} -d homelab -c \"SELECT pg_sleep(1);\" &"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 120:**
Current: `"localhost": [`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 124:**
Current: `"url: \"{{ service_health_url | default('http://localhost:8080/health') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 129:**
Current: `"url: \"http://localhost:5055/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 134:**
Current: `"url: \"http://localhost:5055/api/v1/settings/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 139:**
Current: `"url: \"http://localhost:5055/api/v1/settings/notifications\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 144:**
Current: `"url: \"http://localhost:5055/api/v1/user\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 149:**
Current: `"url: \"http://localhost:5055/api/v1/settings/permissions\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 154:**
Current: `"url: \"http://localhost:5055/api/v1/settings/webhooks\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 159:**
Current: `"url: \"http://localhost:5055/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 164:**
Current: `"nmap -sT -O localhost | grep -E \"^[0-9]+|^Host\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 169:**
Current: `"url: \"http://localhost:3000\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 174:**
Current: `"curl -s http://localhost:8096/System/Info/Public"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 179:**
Current: `"if ! curl -s -f http://localhost:8096/System/Info/Public > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 184:**
Current: `"STATUS=$(curl -s http://localhost:8096/System/Info/Public | jq -r .ServerName)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 189:**
Current: `"destemail = {{ username }}@localhost  # Alert recipient"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 194:**
Current: `"job: \"/usr/bin/aide --check 2>&1 | mail -s 'AIDE Report' {{ username }}@localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 199:**
Current: `"mail -s \"SECURITY INCIDENT\" {{ username }}@localhost 2>/dev/null || true"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 204:**
Current: `"if ! curl -s -f http://localhost:7878/api/v3/health > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 209:**
Current: `"STATUS=$(curl -s http://localhost:7878/api/v3/health | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 214:**
Current: `"curl -s http://localhost:8686/api/v1/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 219:**
Current: `"if ! curl -s -f http://localhost:8686/api/v1/health > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 224:**
Current: `"STATUS=$(curl -s http://localhost:8686/api/v1/health | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 229:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 234:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 239:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 244:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 249:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 254:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 259:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 264:**
Current: `"if ! nc -z localhost 1883; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 269:**
Current: `"if ! curl -s -f http://localhost:9000/api/status > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 274:**
Current: `"curl -s http://localhost:9115/-/healthy"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 279:**
Current: `"curl -s \"http://localhost:9115/probe?target=$2&module=https_2xx\" | grep -E \"(probe_success|probe_duration_seconds)\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 284:**
Current: `"curl -s \"http://localhost:9115/probe?target=$2&module=https_2xx\" | grep -E \"(probe_ssl_earliest_cert_expiry|probe_ssl_validation_success)\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 289:**
Current: `"curl -s \"http://localhost:9115/probe?target=$2&module=dns_udp_53\" | grep -E \"(probe_success|probe_duration_seconds)\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 294:**
Current: `"curl -s \"http://localhost:9115/probe?target=$2&module=icmp\" | grep -E \"(probe_success|probe_duration_seconds)\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 299:**
Current: `"if ! curl -s http://localhost:9115/-/healthy > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 304:**
Current: `"if ! curl -s http://localhost:9115/metrics > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 309:**
Current: `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 309:**
Current: `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 314:**
Current: `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 314:**
Current: `"if ! curl -s \"http://localhost:9115/probe?target=localhost&module=http_2xx\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 319:**
Current: `"test: [\"CMD\", \"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost:3000/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 324:**
Current: `"domain = localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 329:**
Current: `"ehlo_identity = localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 334:**
Current: `"curl -s http://localhost:3000/api/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 339:**
Current: `"if ! curl -s http://localhost:3000/api/health | grep -q \"ok\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 344:**
Current: `"if ! curl -s -f http://localhost:80 > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 349:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api?mode=version\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 354:**
Current: `"if ! curl -s http://localhost:8080/api?mode=version | grep -q \"version\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 359:**
Current: `"url: \"http://localhost:8080/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 364:**
Current: `"url: \"http://localhost:8080/api/config/plex\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 369:**
Current: `"url: \"http://localhost:8080/api/config/sonarr\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 374:**
Current: `"url: \"http://localhost:8080/api/config/radarr\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 379:**
Current: `"url: \"http://localhost:8080/api/config/notifications\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 384:**
Current: `"url: \"http://localhost:8080/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 389:**
Current: `"-m {{ username }}@localhost \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 394:**
Current: `"mail -s \"Storage Alert\" {{ username }}@localhost 2>/dev/null || true"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 399:**
Current: `"curl -s http://localhost:8787/api/v1/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 404:**
Current: `"if ! curl -s -f http://localhost:8787/api/v1/health > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 409:**
Current: `"STATUS=$(curl -s http://localhost:8787/api/v1/health | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 414:**
Current: `"curl -s http://localhost:3100/ready"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 419:**
Current: `"if ! curl -s http://localhost:3100/ready > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 424:**
Current: `"if ! curl -s \"http://localhost:3100/loki/api/v1/query?query={}\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 429:**
Current: `"Local URL: http://localhost:{{ linkwarden_port | default(3000) }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 434:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 439:**
Current: `"if ! curl -s http://localhost:9696/health | grep -q \"ok\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 444:**
Current: `"if ! curl -s http://localhost:13378 | grep -q \"Audiobookshelf\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 449:**
Current: `"url: \"http://localhost:6767/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 454:**
Current: `"url: \"http://localhost:6767/api/sonarr\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 459:**
Current: `"url: \"http://localhost:6767/api/radarr\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 464:**
Current: `"url: \"http://localhost:6767/api/providers\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 469:**
Current: `"url: \"http://localhost:6767/api/languages\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 474:**
Current: `"url: \"http://localhost:6767/api/notifications\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 479:**
Current: `"url: \"http://localhost:6767/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 484:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api/v2/app/version\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 489:**
Current: `"if ! curl -s http://localhost:8080/api/v2/app/version | grep -q \"version\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 494:**
Current: `"WebUI\\LocalHostAuth=true"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 499:**
Current: `"curl -s -k https://localhost:5601/api/status | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 504:**
Current: `"curl -s -k https://localhost:5601/api/status | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 509:**
Current: `"if ! curl -s -k -f https://localhost:5601/api/status > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 514:**
Current: `"STATUS=$(curl -s -k https://localhost:5601/api/status | jq -r .status.overall.level)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 519:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/system/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 524:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/downloadclient\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 529:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/indexer\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 534:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/qualityprofile\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 539:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/metadataprofile\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 544:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/rootfolder\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 549:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/notification\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 554:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/connection\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 559:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/autotagging\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 564:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/ui\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 569:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/backup\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 574:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/update\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 579:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/security\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 584:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/ssl\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 589:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/proxy\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 594:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/analytics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 599:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/config/instance\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 604:**
Current: `"url: \"http://localhost:{{ media_lidarr_port | default(8686) }}/api/v1/system/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 609:**
Current: `"pg_dump -U {{ item.user }} -h {{ item.host | default('localhost') }} -p {{ item.port | default('5432') }} {{ item.name }} | gzip > {{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.sql.gz"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 614:**
Current: `"mysqldump -u {{ item.user }} -p{{ item.password }} -h {{ item.host | default('localhost') }} -P {{ item.port | default('3306') }} {{ item.name }} | gzip > {{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.sql.gz"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 619:**
Current: `"mongodump --uri=\"mongodb://{{ item.user }}:{{ item.password }}@{{ item.host | default('localhost') }}:{{ item.port | default('27017') }}/{{ item.name }}\" --gzip --archive={{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.archive"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 624:**
Current: `"redis-cli -h {{ item.host | default('localhost') }} -p {{ item.port | default('6379') }} -a {{ item.password }} SAVE && cp {{ item.rdb_path | default('/var/lib/redis/dump.rdb') }} {{ backup_root_dir | default('/var/backups') }}/databases/redis-{{ ansible_date_time.iso8601_basic_short }}.rdb"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 629:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8086/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 634:**
Current: `"test: [\"CMD\", \"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost:9090/-/healthy\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 639:**
Current: `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3000/api/health || exit 1\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 644:**
Current: `"if ! curl -s http://localhost:8080 | grep -q \"Komga\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 649:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api?mode=version\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 654:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api/v2/app/version\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 659:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9696/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 664:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8989/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 669:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:7878/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 674:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8686/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 679:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8787/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 684:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:6767/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 689:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8088/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 694:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8096/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 699:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 704:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 709:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3003/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 714:**
Current: `"if curl -f -s \"http://localhost:$port$path\" >/dev/null 2>&1; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 719:**
Current: `"local speed=$(docker-compose exec -T \"$service\" curl -s \"http://localhost:8080/api?mode=diskspace\" | jq -r '.diskspace[].speed' 2>/dev/null || echo \"0\")"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 724:**
Current: `"url: \"http://localhost:{{ item.port }}{{ item.path }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 729:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/ping\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 734:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 739:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 744:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9090/-/healthy\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 749:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8086/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 754:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 759:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8096/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 764:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8989/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 769:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:7878/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 774:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 779:**
Current: `"if ! curl -s http://localhost:8096 | grep -q \"Jellyfin\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 784:**
Current: `"url: \"{{ notifications.email.smtp_url | default('smtp://localhost:587') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 789:**
Current: `"url: \"http://localhost:9093/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 794:**
Current: `"url: \"http://localhost:9093/api/v1/alerts\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 799:**
Current: `"url: \"http://localhost:9090/api/v1/status/config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 804:**
Current: `"url: \"http://localhost:9090/api/v1/rules\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 809:**
Current: `"url: \"http://localhost:9090/api/v1/alerts\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 814:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 819:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 824:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 829:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 834:**
Current: `"delegate_to: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 839:**
Current: `"until curl -s http://localhost:8086/health > /dev/null 2>&1; do"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 844:**
Current: `"if ! curl -s http://localhost:8086/health > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 849:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8086/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 854:**
Current: `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=get_server_info\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 859:**
Current: `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=update_plex_server\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 864:**
Current: `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=update_notification_config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 869:**
Current: `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=backup_config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 874:**
Current: `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=get_server_info\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 879:**
Current: `"curl -X PUT \"localhost:9200/_snapshot/backup\" -H 'Content-Type: application/json' -d'"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 884:**
Current: `"curl -X PUT \"localhost:9200/_snapshot/backup/$SNAPSHOT_NAME?wait_for_completion=true\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 889:**
Current: `"if ! curl -s -f \"localhost:9200/_snapshot/backup/$SNAPSHOT_NAME\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 894:**
Current: `"curl -X POST \"localhost:9200/_snapshot/backup/$SNAPSHOT_NAME/_restore?wait_for_completion=true\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 899:**
Current: `"curl -s localhost:9200/_cluster/health | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 904:**
Current: `"curl -s localhost:9200/_cluster/health | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 909:**
Current: `"curl -s localhost:9200/_cat/indices?v"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 914:**
Current: `"if ! curl -s -f http://localhost:9200/_cluster/health > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 919:**
Current: `"HEALTH=$(curl -s http://localhost:9200/_cluster/health | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 924:**
Current: `"curl -s http://localhost:9093/-/healthy"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 929:**
Current: `"curl -X POST http://localhost:9093/-/reload"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 934:**
Current: `"curl -s http://localhost:9093/api/v2/alerts | jq '.'"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 939:**
Current: `"curl -s http://localhost:9093/api/v2/silences | jq '.'"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 944:**
Current: `"curl -X POST http://localhost:9093/api/v2/alerts \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 949:**
Current: `"if ! curl -s http://localhost:9093/-/healthy > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 954:**
Current: `"if ! curl -s http://localhost:9093/api/v2/status > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 959:**
Current: `"if ! curl -s http://localhost:9093/api/v2/status | jq -e '.config' > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 964:**
Current: `"- localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 969:**
Current: `"- localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 974:**
Current: `"- localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 979:**
Current: `"- localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 984:**
Current: `"curl -s http://localhost:9080/ready"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 989:**
Current: `"if ! curl -s http://localhost:9080/ready > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 994:**
Current: `"if ! curl -s http://localhost:9080/metrics > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 999:**
Current: `"test: [\"CMD\", \"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost:9090/-/healthy\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1004:**
Current: `"- targets: ['localhost:9090']"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1009:**
Current: `"if ! curl -s http://localhost:9090/-/healthy > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1014:**
Current: `"if ! curl -s http://localhost:9090/api/v1/query?query=up > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1019:**
Current: `"target_count=$(curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets | length')"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1024:**
Current: `"rule_count=$(curl -s http://localhost:9090/api/v1/rules | jq '.data.groups | length')"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1029:**
Current: `"curl -s http://localhost:9090/-/healthy"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1034:**
Current: `"curl -X POST http://localhost:9090/-/reload"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1039:**
Current: `"- targets: ['localhost:9090']"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1044:**
Current: `"url: \"http://localhost:{{ item.port }}{{ item.endpoint | default('/health') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1049:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT version();\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1054:**
Current: `"redis-cli -h localhost -p 6379 -a {{ vault_redis_password }} ping"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1059:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1064:**
Current: `"url: \"http://localhost:3000/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1069:**
Current: `"url: \"http://localhost:8080/api/http/routers\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1074:**
Current: `"url: \"http://localhost:9000/if/user/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1079:**
Current: `"if ! nc -z localhost 445; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1084:**
Current: `"if ! curl -s http://localhost:8265/api/v2/status | grep -q \"status\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1089:**
Current: `"if ! curl -s http://localhost:8083 | grep -q \"Calibre-Web\"; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1094:**
Current: `"curl -s http://localhost:8989/api/v3/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1099:**
Current: `"if ! curl -s -f http://localhost:8989/api/v3/health > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1104:**
Current: `"STATUS=$(curl -s http://localhost:8989/api/v3/health | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1109:**
Current: `"url: \"http://localhost:8080/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1114:**
Current: `"url: \"http://localhost:8080/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1119:**
Current: `"url: \"http://localhost:8080/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1124:**
Current: `"url: \"http://localhost:8080/api/http/routers\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1129:**
Current: `"url: \"http://localhost:{{ item.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1134:**
Current: `"url: \"http://localhost:8080/api/rawdata\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1139:**
Current: `"url: \"http://localhost:80/admin/api.php?status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1144:**
Current: `"url: \"http://localhost:80/admin/api.php?summaryRaw\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1149:**
Current: `"url: \"http://localhost:9200/_cluster/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1154:**
Current: `"url: \"http://localhost:5601/api/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1159:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1164:**
Current: `"url: \"http://localhost:3000/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1169:**
Current: `"url: \"http://localhost:3100/loki/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1174:**
Current: `"url: \"http://localhost:9093/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1179:**
Current: `"url: \"http://localhost:9090/api/v1/query?query=up\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1184:**
Current: `"url: \"http://localhost:5432/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1189:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1194:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1199:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1204:**
Current: `"url: http://localhost:3001"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1209:**
Current: `"url: http://localhost:9000"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1214:**
Current: `"url: http://localhost:8080"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1219:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1224:**
Current: `"url: \"http://localhost:5432\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1229:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1234:**
Current: `"url: \"http://localhost:8989/api/v3/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1239:**
Current: `"curl -f http://localhost:6767/api/v1/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1244:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1249:**
Current: `"url: \"http://localhost:8080/api/http/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1254:**
Current: `"url: \"http://localhost:9000/if/user/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1259:**
Current: `"url: \"http://localhost:9093/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1264:**
Current: `"url: \"http://localhost:9090/api/v1/rules\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1269:**
Current: `"curl -X POST http://localhost:9093/api/v1/alerts \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1274:**
Current: `"url: \"http://localhost:8080/api/http/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1279:**
Current: `"host: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1284:**
Current: `"host: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1289:**
Current: `"host: localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1294:**
Current: `"url: http://localhost:9090/-/healthy"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1299:**
Current: `"url: http://localhost:3000/api/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1304:**
Current: `"url: http://localhost:3100/ready"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1309:**
Current: `"ab -n 200 -c 5 -r http://localhost:8989/api/v3/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1314:**
Current: `"ab -n 1000 -c 10 -r http://localhost:9090/api/v1/query?query=up"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1319:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1324:**
Current: `"redis-benchmark -h localhost -p 6379 -a {{ vault_redis_password }} -n 10000 -c 10"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1329:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c \"SELECT 1;\" &"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1334:**
Current: `"time curl -s \"http://localhost:9090/api/v1/query?query=up\" | jq '.data.result | length'"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1339:**
Current: `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1344:**
Current: `"time curl -s \"http://localhost:9090/api/v1/rules\" | jq '.data.groups | length'"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1349:**
Current: `"siege -c 10 -t 30S http://localhost:8989/api/v3/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1354:**
Current: `"PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user | default('homelab') }} -d homelab -c \"SELECT pg_sleep(1);\" &"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1359:**
Current: `"curl -X POST \"http://localhost:9091/metrics/job/redis/instance/{{ ansible_hostname }}\" \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1364:**
Current: `"url: \"http://localhost:9090/api/v1/status/config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1369:**
Current: `"url: \"http://localhost:3000/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1374:**
Current: `"- Prometheus: http://localhost:9090"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1379:**
Current: `"- Grafana: http://localhost:3000"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1384:**
Current: `"- AlertManager: http://localhost:9093"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1389:**
Current: `"curl -X PUT \"localhost:{{ elasticsearch_port }}/_snapshot/backup\" -H 'Content-Type: application/json' -d'"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1394:**
Current: `"curl -X PUT \"localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME?wait_for_completion=true\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1399:**
Current: `"if ! curl -s -f \"localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME\" > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1404:**
Current: `"curl -X POST \"localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME/_restore?wait_for_completion=true\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1409:**
Current: `"curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1414:**
Current: `"curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1419:**
Current: `"curl -s \"localhost:{{ elasticsearch_port }}/_cat/indices?v\" | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1424:**
Current: `"if ! curl -s -f \"localhost:{{ elasticsearch_port }}/_cluster/health\" > /dev/null 2>&1; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1429:**
Current: `"STATUS=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1434:**
Current: `"curl -s -k https://localhost:{{ kibana_port }}/api/status | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1439:**
Current: `"curl -s -k https://localhost:{{ kibana_port }}/api/status | jq ."`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1444:**
Current: `"if ! curl -s -k -f https://localhost:{{ kibana_port }}/api/status > /dev/null 2>&1; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1449:**
Current: `"STATUS=$(curl -s -k https://localhost:{{ kibana_port }}/api/status | jq -r .status.overall.level)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1454:**
Current: `"HEALTH=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .status)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1459:**
Current: `"NODES=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .number_of_nodes)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1464:**
Current: `"INDICES=$(curl -s \"localhost:{{ elasticsearch_port }}/_cat/indices?v\" | wc -l)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1469:**
Current: `"UNASSIGNED_SHARDS=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\" | jq -r .unassigned_shards)"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1474:**
Current: `"HEALTH=$(curl -s \"localhost:{{ elasticsearch_port }}/_cluster/health\")"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1479:**
Current: `"NODE_STATS=$(curl -s \"localhost:{{ elasticsearch_port }}/_nodes/stats\")"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1484:**
Current: `"curl -X POST \"http://localhost:9091/metrics/job/elasticsearch/instance/{{ ansible_hostname }}\" \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1489:**
Current: `"STATUS=$(curl -s -k \"https://localhost:{{ kibana_port }}/api/status\")"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1494:**
Current: `"curl -X POST \"http://localhost:9091/metrics/job/kibana/instance/{{ ansible_hostname }}\" \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1499:**
Current: `"url: http://localhost:9090/api/v1/rules"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1504:**
Current: `"url: http://localhost:9093/api/v1/status"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1509:**
Current: `"- targets: ['localhost:9090']"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1514:**
Current: `"test: [\"CMD\", \"curl\", \"-s\", \"-k\", \"https://localhost:{{ kibana_web_port }}/api/status\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1519:**
Current: `"ansible.builtin.command: docker exec {{ kibana_container_name }} curl -s -k https://localhost:{{ kibana_web_port }}/api/status"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1524:**
Current: `"test: [\"CMD\", \"curl\", \"-s\", \"-k\", \"https://localhost:{{ elasticsearch_web_port }}/_cluster/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1529:**
Current: `"ansible.builtin.command: docker exec {{ elasticsearch_container_name }} curl -s -k https://localhost:{{ elasticsearch_web_port }}/_cluster/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1534:**
Current: `"databases_smtp_host: \"{{ smtp_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1539:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1544:**
Current: `"- \"http://localhost:{{ homepage_port }}/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1549:**
Current: `"- \"http://localhost:{{ homepage_port }}/api/bookmarks\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1554:**
Current: `"- \"http://localhost:{{ homepage_port }}/api/widgets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1559:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1564:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/auth/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1569:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1574:**
Current: `"HOMEPAGE_URL: \"http://localhost:{{ homepage_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1579:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1584:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/bookmarks\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1589:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/weather\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1594:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1599:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1604:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1609:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1614:**
Current: `"Local URL: http://localhost:{{ homepage_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1619:**
Current: `"url: \"http://localhost:{{ jellyfin_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1624:**
Current: `"url: \"http://localhost:{{ jellyfin_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1629:**
Current: `"jellyfin_domain: \"jellyfin.{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1634:**
Current: `"url: \"http://localhost:8080/api/rawdata\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1639:**
Current: `"curl -s http://localhost:8080/api/rawdata"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1644:**
Current: `"if ! curl -s http://localhost:8080/api/rawdata > /dev/null; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1649:**
Current: `"metrics) curl -s http://localhost:6060/metrics;;"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1654:**
Current: `"if ! curl -s http://localhost:6060/metrics > /dev/null; then echo \"CrowdSec metrics are not accessible\"; exit 1; fi"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1659:**
Current: `"url: \"http://localhost:80/admin/api.php?status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1664:**
Current: `"url: \"http://localhost:80/admin/api.php\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1669:**
Current: `"url: \"http://localhost:80/admin/api.php\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1674:**
Current: `"url: \"http://localhost:80/admin/api.php?update\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1679:**
Current: `"url: \"http://localhost:9090/-/reload\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1684:**
Current: `"url: \"http://localhost:8080/api/rawdata\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1689:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1694:**
Current: `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1699:**
Current: `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/groups/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1704:**
Current: `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1709:**
Current: `"- \"http://localhost:{{ security_authentik.port }}/api/v3/policies/user/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1714:**
Current: `"- \"http://localhost:{{ security_authentik.port }}/api/v3/core/tokens/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1719:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1724:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/groups/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1729:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1734:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/policies/user/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1739:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1744:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1749:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1754:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1759:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1764:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1769:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/users/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1774:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/groups/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1779:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/policies/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1784:**
Current: `"url: \"http://localhost:{{ security_authentik.port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1789:**
Current: `"3. API Health Check: curl -v http://localhost:{{ security_authentik.port }}/api/v3/core/applications/"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1794:**
Current: `"url: \"http://localhost:9000/if/user/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1799:**
Current: `"AUTHENTIK_URL: \"http://localhost:9000\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1804:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1809:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3003/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1814:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3005/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1819:**
Current: `"immich_smtp_host: \"{{ smtp_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1824:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1829:**
Current: `"url: \"http://localhost:3000/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1834:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1839:**
Current: `"url: \"http://localhost:{{ fing_web_port }}/security/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1844:**
Current: `"url: \"http://localhost:{{ fing_web_port }}/auth/login\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1849:**
Current: `"url: \"http://localhost:{{ fing_web_port }}/api/test\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1854:**
Current: `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1859:**
Current: `"url: \"http://localhost:{{ fing_api_port }}/api/{{ fing_api_version }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1864:**
Current: `"url: \"http://localhost:{{ fing_metrics_port }}/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1869:**
Current: `"url: \"http://localhost:{{ fing_web_port }}/auth/login\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1874:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1879:**
Current: `"url: \"http://localhost:3000/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1884:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1889:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1894:**
Current: `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1899:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1904:**
Current: `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1909:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1914:**
Current: `"url: \"http://localhost:{{ fing_metrics_port }}/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1919:**
Current: `"url: \"http://localhost:{{ fing_web_port }}{{ fing_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1924:**
Current: `"url: \"http://localhost:{{ fing_api_port }}/api/{{ fing_api_version }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1929:**
Current: `"fing_database_host: \"{{ postgresql_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1934:**
Current: `"fing_smtp_host: \"{{ smtp_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1939:**
Current: `"url: \"http://localhost:{{ dumbassets_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1944:**
Current: `"url: \"http://localhost:{{ dumbassets_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1949:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1954:**
Current: `"- Local: http://localhost:{{ dumbassets_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1959:**
Current: `"url: \"http://localhost:{{ dumbassets_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1964:**
Current: `"- Local URL: http://localhost:{{ dumbassets_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1969:**
Current: `"url: \"http://localhost:{{ testservice_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1974:**
Current: `"url: \"http://localhost:{{ testservice_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1979:**
Current: `"testservice_domain: \"testservice.{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1984:**
Current: `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3001/api/healthz\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1989:**
Current: `"test: [\"CMD-SHELL\", \"curl -f http://localhost:8080/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1994:**
Current: `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3002/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1999:**
Current: `"test: [\"CMD-SHELL\", \"curl -f http://localhost:3567/hello\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2004:**
Current: `"test: [\"CMD-SHELL\", \"curl -f http://localhost:9981/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2009:**
Current: `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2014:**
Current: `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/dashboards/db/homelab-overview\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2019:**
Current: `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/v1/provisioning/alert-rules\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2024:**
Current: `"url: \"http://localhost:{{ grafana_port | default(3000) }}/api/v1/provisioning/notification-policies\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2029:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2034:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/user\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2039:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2044:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/search\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2049:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/folders\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2054:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/alert-notifications\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2059:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/admin/users\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2064:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/teams/search\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2069:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources/{{ item.key }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2074:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2079:**
Current: `"- \"http://localhost:{{ grafana_port }}/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2084:**
Current: `"- \"http://localhost:{{ grafana_port }}/api/dashboards\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2089:**
Current: `"- \"http://localhost:{{ grafana_port }}/api/folders\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2094:**
Current: `"- \"http://localhost:{{ grafana_port }}/api/alerting/alertmanager/grafana/config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2099:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2104:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/search\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2109:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/alerting/alertmanager/grafana/config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2114:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/admin/settings\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2119:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2124:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/admin/users\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2129:**
Current: `"--url http://localhost:{{ grafana_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2134:**
Current: `"--url http://localhost:{{ grafana_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2139:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/admin/users\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2144:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/teams/search\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2149:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2154:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/admin/users/1/password\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2159:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2164:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/search\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2169:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/v1/provisioning/alert-rules\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2174:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2179:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2184:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/search\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2189:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/v1/provisioning/alert-rules\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2194:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/v1/provisioning/notification-policies\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2199:**
Current: `"- Grafana Dashboard: http://localhost:{{ grafana_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2204:**
Current: `"- Alertmanager: http://localhost:9093"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2209:**
Current: `"- Prometheus: http://localhost:9090"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2214:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2219:**
Current: `"- URL: http://localhost:{{ grafana_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2224:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/alert-notifications\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2229:**
Current: `"--url http://localhost:{{ grafana_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2234:**
Current: `"--url http://localhost:{{ grafana_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2239:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/alert-notifications\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2244:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/alerts\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2249:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2254:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources/{{ item.key }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2259:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources/{{ item.key }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2264:**
Current: `"grafana_domain: \"grafana.{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2269:**
Current: `"grafana_database_host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2274:**
Current: `"email: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2279:**
Current: `"email: \"viewer@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2284:**
Current: `"email: \"editor@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2289:**
Current: `"email: \"admins@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2294:**
Current: `"email: \"viewers@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2299:**
Current: `"email: \"editors@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2304:**
Current: `"addresses: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2309:**
Current: `"-m {{ username }}@localhost \\"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2314:**
Current: `"if ! nc -z localhost 445; then"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2319:**
Current: `"prometheus_pushgateway: http://localhost:9091"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2324:**
Current: `"ansible.builtin.command: smbclient -L //localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2329:**
Current: `"url: \"http://localhost:8384/rest/system/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2334:**
Current: `"url: \"http://localhost:8080/status.php\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2339:**
Current: `"url: \"http://localhost:{{ portainer_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2344:**
Current: `"url: \"http://localhost:{{ tdarr_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2349:**
Current: `"url: \"http://localhost:{{ tautulli_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2354:**
Current: `"url: \"http://localhost:3000\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2359:**
Current: `"url: \"http://localhost:9090/api/v1/status/config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2364:**
Current: `"url: \"http://localhost:3000/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2369:**
Current: `"url: \"http://localhost:3000\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2374:**
Current: `"url: \"http://localhost:8181/api/v2?apikey={{ tautulli_api_key }}&cmd=get_server_info\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2379:**
Current: `"url: \"http://localhost:3000/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2384:**
Current: `"url: \"http://localhost:{{ n8n_port }}/healthz\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2389:**
Current: `"url: \"http://localhost:{{ n8n_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2394:**
Current: `"url: \"http://localhost:{{ n8n_port }}/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2399:**
Current: `"url: \"http://localhost:3000/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2404:**
Current: `"- Local URL: http://localhost:{{ n8n_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2409:**
Current: `"url: \"http://localhost:{{ n8n_port }}/healthz\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2414:**
Current: `"- \"http://localhost:{{ n8n_port }}/healthz\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2419:**
Current: `"- \"http://localhost:{{ n8n_port }}/metrics\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2424:**
Current: `"url: \"http://localhost:9093/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2429:**
Current: `"url: \"http://localhost:9090/api/v1/rules\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2434:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:5678/healthz\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2439:**
Current: `"url: \"http://localhost:{{ reconya_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2444:**
Current: `"url: \"http://localhost:{{ reconya_port }}/api/devices\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2449:**
Current: `"- \"Local: http://localhost:{{ reconya_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2454:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3008/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2459:**
Current: `"url: \"http://localhost:{{ testservice2_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2464:**
Current: `"url: \"http://localhost:{{ testservice2_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2469:**
Current: `"testservice2_domain: \"testservice2.{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2474:**
Current: `"url: \"http://localhost:{{ romm_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2479:**
Current: `"url: \"http://localhost:{{ romm_external_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2484:**
Current: `"url: \"http://localhost:{{ romm_external_port }}/api/v1/auth/register\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2489:**
Current: `"url: \"http://localhost:{{ romm_external_port }}/api/v1/auth/api-key\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2494:**
Current: `"romm_domain: \"romm.{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2499:**
Current: `"romm_database_host: \"{{ postgresql_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2504:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2509:**
Current: `"url: \"http://localhost:{{ vaultwarden_port }}/alive\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2514:**
Current: `"url: \"http://localhost:{{ vaultwarden_port }}/alive\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2519:**
Current: `"Local URL: http://localhost:{{ vaultwarden_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2524:**
Current: `"- \"http://localhost:{{ prometheus_port }}/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2529:**
Current: `"- \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2534:**
Current: `"- URL: http://localhost:{{ vaultwarden_port }}/alive"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2539:**
Current: `"url: \"http://localhost:{{ alertmanager_port }}/api/v1/alerts\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2544:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:80/alive\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2549:**
Current: `"url: \"http://localhost:{{ home_assistant_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2554:**
Current: `"url: \"http://localhost:{{ zigbee2mqtt_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2559:**
Current: `"url: \"http://localhost:{{ node_red_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2564:**
Current: `"url: \"http://localhost:{{ n8n_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2569:**
Current: `"url: \"http://localhost:9090/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2574:**
Current: `"url: \"http://localhost:3000/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2579:**
Current: `"url: \"http://localhost:{{ node_red_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2584:**
Current: `"url: \"http://localhost:{{ n8n_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2589:**
Current: `"url: \"http://localhost:3000/api/services\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2594:**
Current: `"url: \"http://localhost:9090/api/v1/status/config\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2599:**
Current: `"url: \"http://localhost:3000/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2604:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/ping\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2609:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/reload\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2614:**
Current: `"url: \"http://localhost:{{ linkwarden_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2619:**
Current: `"url: \"http://localhost:{{ linkwarden_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2624:**
Current: `"Local URL: http://localhost:{{ linkwarden_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2629:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3002/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2634:**
Current: `"url: \"http://loki.{{ domain | default('localhost') }}:3100\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2639:**
Current: `"url: \"http://grafana.{{ domain | default('localhost') }}:3000/explore\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2644:**
Current: `"url: \"http://localhost:3100/ready\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2649:**
Current: `"url: \"http://localhost:9080/ready\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2654:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2659:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2664:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2669:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/health/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2674:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/health/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2679:**
Current: `"url: \"http://localhost:{{ alertmanager_port | default(9093) }}/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2684:**
Current: `"- { host: \"{{ influxdb_host | default('localhost') }}\", port: \"{{ influxdb_port | default(8086) }}\" }"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2689:**
Current: `"- { host: \"{{ prometheus_host | default('localhost') }}\", port: \"{{ prometheus_port | default(9090) }}\" }"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2694:**
Current: `"- { host: \"{{ loki_host | default('localhost') }}\", port: \"{{ loki_port | default(3100) }}\" }"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2699:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2704:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2709:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/users/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2714:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/users/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2719:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2724:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2729:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2734:**
Current: `"host: \"localhost\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2739:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2744:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}{{ paperless_ngx_health_check_url }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2749:**
Current: `"url: \"http://localhost:{{ paperless_ngx_web_port }}/api/health/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2754:**
Current: `"url: \"http://localhost:{{ alertmanager_port | default(9093) }}/api/v1/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2759:**
Current: `"paperless_ngx_smtp_host: \"{{ smtp_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2764:**
Current: `"url: \"http://localhost:{{ item.value.port }}{{ item.value.healthcheck.test[2] }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2769:**
Current: `"url: \"http://localhost:{{ item.value.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2774:**
Current: `"url: \"http://localhost:{{ item.value.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2779:**
Current: `"url: \"http://localhost:{{ prometheus_port | default(9090) }}/api/v1/targets\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2784:**
Current: `"url: \"http://localhost:{{ loki_port | default(3100) }}/ready\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2789:**
Current: `"url: \"http://localhost:{{ prometheus_port | default(9090) }}/api/v1/query?query=up\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2794:**
Current: `"url: \"http://localhost:{{ media_players.jellyfin.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2799:**
Current: `"url: \"http://localhost:{{ media_players.immich.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2804:**
Current: `"url: \"http://localhost:{{ item.value.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2809:**
Current: `"url: \"http://localhost:{{ media_ports.sabnzbd }}/api?mode=version\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2814:**
Current: `"url: \"http://localhost:{{ media_ports.qbittorrent }}/api/v2/app/version\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2819:**
Current: `"url: \"http://localhost:{{ media_players.jellyfin.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2824:**
Current: `"url: \"http://localhost:{{ item.value.port }}{{ item.value.healthcheck.test[2] }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2829:**
Current: `"url: \"http://localhost:{{ media_players.jellyfin.port }}/System/Info\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2834:**
Current: `"url: \"http://localhost:{{ media_players.immich.port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2839:**
Current: `"url: \"http://localhost:{{ item.value.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2844:**
Current: `"url: \"http://localhost:{{ media_downloaders.sabnzbd.port }}/api?mode=version\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2849:**
Current: `"url: \"http://localhost:{{ media_downloaders.qbittorrent.port }}/api/v2/app/version\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2854:**
Current: `"url: \"http://localhost:{{ media_downloaders.sabnzbd.port }}/api\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2859:**
Current: `"url: \"http://localhost:{{ media_downloaders.qbittorrent.port }}/api/v2/app/version\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2864:**
Current: `"url: \"http://localhost:{{ item.value.port }}{{ item.value.healthcheck.test[2] }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2869:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8080/api?mode=version\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2874:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8081/api/v2/app/version\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2879:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:9696/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2884:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8989/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2889:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:7878/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2894:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8686/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2899:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8787/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2904:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:6767/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2909:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8088/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2914:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:8096/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2919:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3001/api/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2924:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3000/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2929:**
Current: `"test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:3003/health\"]"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2934:**
Current: `"media_smtp_host: \"{{ smtp_host | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2939:**
Current: `"url: \"http://localhost:{{ item.value.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2944:**
Current: `"url: \"http://localhost:{{ item.value.port }}/api/v3/system/status\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2949:**
Current: `"url: \"http://localhost:{{ item.value.port }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2954:**
Current: `"url: \"http://localhost:8080/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2959:**
Current: `"url: \"http://localhost:{{ authentik_port }}/api/v3/core/applications/\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2964:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2969:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2974:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/datasources\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2979:**
Current: `"url: \"http://localhost:{{ homepage_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2984:**
Current: `"url: \"http://localhost:{{ grafana_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2989:**
Current: `"- Homepage API: http://localhost:{{ homepage_port }}/api"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2994:**
Current: `"- Grafana API: http://localhost:{{ grafana_port }}/api"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3350:**
Current: `"email: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3355:**
Current: `"addresses: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3820:**
Current: `"localhost": "{{ ansible_default_ipv4.address }}",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3822:**
Current: `"admin@localhost": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2997:**
Current: `"127.0.0.1": [`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3001:**
Current: `"host    all            all             127.0.0.1/32           md5"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3006:**
Current: `"\"metrics-addr\": \"127.0.0.1:9323\","`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3011:**
Current: `"host: 127.0.0.1"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3016:**
Current: `"dig @127.0.0.1 google.com +short"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3021:**
Current: `"- \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3026:**
Current: `"host    all            all             127.0.0.1/32           md5"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3031:**
Current: `"listen_uri: 127.0.0.1:8080"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3036:**
Current: `"listen_addr: 127.0.0.1"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3041:**
Current: `"- url: \"http://127.0.0.1:{{ immich_ports.server }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3046:**
Current: `"- url: \"http://127.0.0.1:{{ immich_ports.web }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3051:**
Current: `"- url: \"http://127.0.0.1:{{ immich_ports.machine_learning }}/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3056:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3061:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3066:**
Current: `"url: \"http://127.0.0.1:{{ immich_ports.server }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3071:**
Current: `"url: \"http://127.0.0.1:{{ immich_ports.server }}/api/auth/admin-sign-up\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3076:**
Current: `"loop: \"{{ server_ips | default(['127.0.0.1']) }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3081:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3086:**
Current: `"url: \"http://127.0.0.1:{{ item.port }}{{ item.path }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3091:**
Current: `"url: \"http://127.0.0.1:3567/hello\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3096:**
Current: `"url: \"http://127.0.0.1:9981/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3101:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3106:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3111:**
Current: `"url: \"http://127.0.0.1:{{ item.port }}{{ item.path }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3116:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3121:**
Current: `"url: \"http://127.0.0.1:{{ ersatztv_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3126:**
Current: `"url: \"http://127.0.0.1:{{ ersatztv_port }}/api/health\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3131:**
Current: `"ansible.builtin.shell: \"curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:{{ ersatztv_port }}/api/streams\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3136:**
Current: `"ansible.builtin.shell: \"curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:{{ ersatztv_port }}{{ ersatztv_prometheus_path }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3141:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3146:**
Current: `"url: \"http://127.0.0.1:{{ ersatztv_port }}\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3151:**
Current: `"- URL: http://127.0.0.1:{{ ersatztv_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3156:**
Current: `"- Web Interface: http://127.0.0.1:{{ ersatztv_port }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3161:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3166:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3171:**
Current: `"host: \"127.0.0.1\""`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3176:**
Current: `"docker exec crowdsec cscli decisions list --ip 127.0.0.1"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3821:**
Current: `"127.0.0.1": "{{ ansible_default_ipv4.address }}",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 3823:**
Current: `"admin@127.0.0.1": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 2274:**
Current: `"email: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 2304:**
Current: `"addresses: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3300:**
Current: `"- Username: {{ vault_npm_admin_username | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3305:**
Current: `"admin_email: \"{{ lookup('env', 'ADMIN_EMAIL') | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3310:**
Current: `"ssl_email: \"{{ lookup('env', 'SSL_EMAIL') | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3315:**
Current: `"from_address: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3320:**
Current: `"- \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3325:**
Current: `"to: admin@yourdomain.com"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3330:**
Current: `"notification_recipient: \"admin@{{ domain }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3335:**
Current: `"immich_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3340:**
Current: `"fing_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3345:**
Current: `"pezzo_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3350:**
Current: `"email: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3355:**
Current: `"addresses: \"admin@{{ domain | default('localhost') }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3360:**
Current: `"ersatztv_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3365:**
Current: `"n8n_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3370:**
Current: `"romm_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3375:**
Current: `"vaultwarden_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3380:**
Current: `"linkwarden_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3385:**
Current: `"paperless_ngx_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3390:**
Current: `"media_admin_email: \"{{ admin_email | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3395:**
Current: `"nginx_proxy_manager_api_username: \"{{ vault_npm_admin_username | default('admin@' + domain) }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3815:**
Current: `"vault_admin_email": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3817:**
Current: `"vault_ssl_email": "{{ ssl_email | default(\"admin@\" + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3822:**
Current: `"admin@localhost": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3822:**
Current: `"admin@localhost": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3823:**
Current: `"admin@127.0.0.1": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 3823:**
Current: `"admin@127.0.0.1": "{{ admin_email | default(\"admin@\" + domain) }}",`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 1339:**
Current: `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\""`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Changeme Issues

**Line 3398:**
Current: `"changeme": [],`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 3824:**
Current: `"changeme": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 3398:**
Current: `"changeme": [],`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 3824:**
Current: `"changeme": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

### Admin123 Issues

**Line 3399:**
Current: `"admin123": [],`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 3825:**
Current: `"admin123": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 3399:**
Current: `"admin123": [],`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 3825:**
Current: `"admin123": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Your_Secure_Password Issues

**Line 3400:**
Current: `"your_secure_password": [],`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 3826:**
Current: `"your_secure_password": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 3400:**
Current: `"your_secure_password": [],`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 3826:**
Current: `"your_secure_password": "{{ vault_admin_password | password_hash(\"bcrypt\") }}",`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### 192.168 Issues

**Line 3183:**
Current: `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3188:**
Current: `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3193:**
Current: `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3198:**
Current: `"ansible_host: \"{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3203:**
Current: `"ansible_host: \"{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3208:**
Current: `"subnet: \"{{ lookup('env', 'HOMELAB_SUBNET') | default('192.168.1.0/24') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3213:**
Current: `"gateway: \"{{ lookup('env', 'HOMELAB_GATEWAY') | default('192.168.1.1') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3218:**
Current: `"- url: \"http://192.168.1.41:32400\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3223:**
Current: `"ansible_server_ip: \"{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3228:**
Current: `"- \"{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3233:**
Current: `"- \"{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3238:**
Current: `"- \"{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3243:**
Current: `"- \"{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3248:**
Current: `"reconya_network_range: \"{{ lookup('env', 'RECONYA_NETWORK_RANGE') | default('192.168.1.0/24') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3253:**
Current: `"vm_ip: \"{{ vm_ip | default('192.168.1.100') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3258:**
Current: `"gateway: \"{{ network_config.gateway | default('192.168.1.1') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3263:**
Current: `"ip_address: \"{{ lookup('env', 'HOMELAB_IP_ADDRESS') | default('192.168.1.100') }}\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3268:**
Current: `"plex_server_ip: \"{{ lookup('env', 'PLEX_SERVER_IP') | default('192.168.1.41') }}\"           # IP address of your existing Plex server"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3273:**
Current: `"- \"192.168.1.0/24\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3278:**
Current: `"- \"192.168.1.0/24\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3283:**
Current: `"fail_msg: \"Invalid network range format. Expected format: 192.168.1.0/24\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3288:**
Current: `"reconya_network_range: \"192.168.1.0/24\""`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 3293:**
Current: `"reconya_network_ranges: [\"192.168.1.0/24\"]"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## test_logging_infrastructure_report.json

### Localhost Issues

**Line 108:**
Current: `"message": "Loki not accessible: HTTPConnectionPool(host='localhost', port=3100): Max retries exceeded with url: /ready (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x101c35100>: Failed to establish a new connection: [Errno 61] Connection refused'))"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## inventory.yml

### 192.168 Issues

**Line 10:**
Current: `ansible_host: "{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 13:**
Current: `ansible_host: "{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 16:**
Current: `ansible_host: "{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 19:**
Current: `ansible_host: "{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 36:**
Current: `ansible_host: "{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 44:**
Current: `subnet: "{{ lookup('env', 'HOMELAB_SUBNET') | default('192.168.1.0/24') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 45:**
Current: `gateway: "{{ lookup('env', 'HOMELAB_GATEWAY') | default('192.168.1.1') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 11:**
Current: `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 14:**
Current: `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 17:**
Current: `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 20:**
Current: `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 37:**
Current: `ansible_user: "{{ lookup('env', 'HOMELAB_USERNAME') | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/telegraf.yml

### Default_Credentials Issues

**Line 210:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/network.yml

### 192.168 Issues

**Line 133:**
Current: `- "172.17.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 134:**
Current: `- "172.18.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 135:**
Current: `- "172.19.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 136:**
Current: `- "172.20.0.0/14"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 427:**
Current: `-A DOCKER-USER -s 172.20.0.0/16 -d 172.20.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 427:**
Current: `-A DOCKER-USER -s 172.20.0.0/16 -d 172.20.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 428:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.21.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 428:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.21.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 429:**
Current: `-A DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 429:**
Current: `-A DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 432:**
Current: `-A DOCKER-USER -s 172.20.0.0/16 -d 172.21.0.0/16 -j DROP`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 432:**
Current: `-A DOCKER-USER -s 172.20.0.0/16 -d 172.21.0.0/16 -j DROP`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 433:**
Current: `-A DOCKER-USER -s 172.20.0.0/16 -d 172.22.0.0/16 -j DROP`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 433:**
Current: `-A DOCKER-USER -s 172.20.0.0/16 -d 172.22.0.0/16 -j DROP`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 434:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j DROP`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 434:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j DROP`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 437:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.20.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 437:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.20.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 438:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 438:**
Current: `-A DOCKER-USER -s 172.21.0.0/16 -d 172.22.0.0/16 -j ACCEPT`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 359:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 416:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 96:**
Current: `default: "{{ item.default }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/homepage.yml

### Default_Credentials Issues

**Line 35:**
Current: `become_user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/emby.yml

### Default_Credentials Issues

**Line 437:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 445:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/security.yml

### Password Issues

**Line 780:**
Current: `admin_password: "{{ vault_fail2ban_secret_key }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 781:**
Current: `database_password: "{{ vault_pihole_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 780:**
Current: `admin_password: "{{ vault_fail2ban_secret_key }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 781:**
Current: `database_password: "{{ vault_pihole_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 524:**
Current: `mail -s "SECURITY INCIDENT" {{ username }}@localhost 2>/dev/null || true`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 579:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/mariadb.yml

### Default_Credentials Issues

**Line 270:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 278:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 286:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/radarr.yml

### Default_Credentials Issues

**Line 151:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 159:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/lidarr.yml

### Default_Credentials Issues

**Line 210:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 218:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/proxmox.yml

### Password Issues

**Line 9:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 21:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 66:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 83:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 9:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 21:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 66:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 83:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 59:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 76:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 94:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 108:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 118:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 8:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 20:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 43:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 65:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 82:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 100:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/portainer.yml

### Default_Credentials Issues

**Line 152:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 160:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/blackbox_exporter.yml

### Localhost Issues

**Line 219:**
Current: `if ! curl -s "http://{{ ansible_default_ipv4.address }}:/probe?target=localhost&module=http_2xx" > /dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 253:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/grafana.yml

### Localhost Issues

**Line 140:**
Current: `ehlo_identity = localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 73:**
Current: `http_addr = 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 653:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/postgresql.yml

### Localhost Issues

**Line 106:**
Current: `host    all            all             0.0.0.0/0              md5`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 260:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 268:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 276:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/nginx_proxy_manager.yml

### Admin Issues

**Line 67:**
Current: `- Username: {{ vault_npm_admin_username | default('admin@' + domain) }}`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## tasks/nginx.yml

### Default_Credentials Issues

**Line 228:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/sabnzbd.yml

### Localhost Issues

**Line 92:**
Current: `host = 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 85:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 194:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 202:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/redis.yml

### Localhost Issues

**Line 24:**
Current: `bind 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 246:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 254:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/storage.yml

### Default_Credentials Issues

**Line 316:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 325:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 334:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 391:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/readarr.yml

### Default_Credentials Issues

**Line 210:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 218:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/loki.yml

### Default_Credentials Issues

**Line 187:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/setup.yml

### Password Issues

**Line 48:**
Current: `proxmox_password: "{{ proxmox_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 80:**
Current: `proxmox_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 48:**
Current: `proxmox_password: "{{ proxmox_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `api_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 80:**
Current: `proxmox_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 47:**
Current: `proxmox_user: "{{ proxmox_user | default('root@pam') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 60:**
Current: `api_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 79:**
Current: `proxmox_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/prowlarr.yml

### Default_Credentials Issues

**Line 157:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 165:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/audiobookshelf.yml

### Localhost Issues

**Line 23:**
Current: `"host": "0.0.0.0",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 140:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 148:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/nextcloud.yml

### Default_Credentials Issues

**Line 108:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/update_backup_schedules.yml

### Default_Credentials Issues

**Line 11:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 20:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 29:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 38:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 47:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 56:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 65:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 74:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 83:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 92:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 101:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 110:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 119:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 128:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 137:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 146:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 155:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 164:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 173:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 182:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 191:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 200:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 209:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 218:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 227:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 236:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 245:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 254:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 263:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 272:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 281:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 290:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 299:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 308:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/qbittorrent.yml

### Localhost Issues

**Line 110:**
Current: `WebUI\LocalHostAuth=true`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 96:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 208:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/kibana.yml

### Localhost Issues

**Line 24:**
Current: `server.host: "0.0.0.0"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 194:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/configure_lidarr.yml

### Password Issues

**Line 40:**
Current: `password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `password: "{{ vault_qbittorrent_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 83:**
Current: `password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 310:**
Current: `password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 342:**
Current: `password: "{{ vault_plex_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 355:**
Current: `password: "{{ vault_jellyfin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 465:**
Current: `password: "{{ vault_lidarr_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 480:**
Current: `certPassword: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 497:**
Current: `password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 40:**
Current: `password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `password: "{{ vault_qbittorrent_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 83:**
Current: `password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 310:**
Current: `password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 342:**
Current: `password: "{{ vault_plex_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 355:**
Current: `password: "{{ vault_jellyfin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 465:**
Current: `password: "{{ vault_lidarr_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 480:**
Current: `certPassword: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 497:**
Current: `password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## tasks/vault.yml

### Localhost Issues

**Line 34:**
Current: `address = "0.0.0.0:8200"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 263:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 271:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/backup_databases.yml

### Password Issues

**Line 9:**
Current: `PGPASSWORD: "{{ item.password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 9:**
Current: `PGPASSWORD: "{{ item.password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 20:**
Current: `mongodump --uri="mongodb://{{ item.user }}:{{ item.password }}@{{ item.host | default('localhost') }}:{{ item.port | default('27017') }}/{{ item.name }}" --gzip --archive={{ backup_root_dir | default('/var/backups') }}/databases/{{ item.name }}-{{ ansible_date_time.iso8601_basic_short }}.archive`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 26:**
Current: `redis-cli -h {{ item.host | default('localhost') }} -p {{ item.port | default('6379') }} -a {{ item.password }} SAVE && cp {{ item.rdb_path | default('/var/lib/redis/dump.rdb') }} {{ backup_root_dir | default('/var/backups') }}/databases/redis-{{ ansible_date_time.iso8601_basic_short }}.rdb`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## tasks/secret_rotation.yml

### Password Issues

**Line 100:**
Current: `new_vault_postgresql_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `new_vault_redis_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 102:**
Current: `new_vault_media_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 103:**
Current: `new_vault_paperless_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 108:**
Current: `new_vault_grafana_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 109:**
Current: `new_vault_authentik_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 110:**
Current: `new_vault_portainer_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 111:**
Current: `new_vault_gitlab_root_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 100:**
Current: `new_vault_postgresql_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `new_vault_redis_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 102:**
Current: `new_vault_media_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 103:**
Current: `new_vault_paperless_database_password: "Db{{ lookup('password', '/dev/null chars=ascii_letters,digits length=30') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 108:**
Current: `new_vault_grafana_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 109:**
Current: `new_vault_authentik_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 110:**
Current: `new_vault_portainer_admin_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 111:**
Current: `new_vault_gitlab_root_password: "{{ lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## tasks/cleanup.yml

### Default_Credentials Issues

**Line 555:**
Current: `become_user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 587:**
Current: `become_user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/komga.yml

### Default_Credentials Issues

**Line 148:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 156:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/media_stack.yml

### Default_Credentials Issues

**Line 1080:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 1088:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/watchtower.yml

### Localhost Issues

**Line 411:**
Current: `- VAULT_ADDR=http://0.0.0.0:8200`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 412:**
Current: `- VAULT_API_ADDR=http://0.0.0.0:8200`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 710:**
Current: `unauthorized_access=$(docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -E "0.0.0.0:[0-9]+" | grep -v "traefik\|authentik")`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 45:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 89:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 139:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 172:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 203:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 251:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 299:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 348:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 393:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 442:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 490:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 537:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 585:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 638:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 754:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/jellyfin.yml

### Default_Credentials Issues

**Line 415:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 423:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/essential.yml

### Default_Credentials Issues

**Line 284:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/test_notifications.yml

### Localhost Issues

**Line 285:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 302:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 319:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 329:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 340:**
Current: `delegate_to: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## tasks/backup.yml

### Default_Credentials Issues

**Line 542:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 551:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/plex.yml

### 192.168 Issues

**Line 26:**
Current: `- url: "http://192.168.1.41:32400"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## tasks/docker-compose.yml

### Localhost Issues

**Line 85:**
Current: `- serverIP=0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## tasks/influxdb.yml

### Password Issues

**Line 201:**
Current: `DOCKER_INFLUXDB_INIT_PASSWORD: "{{ influxdb_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 201:**
Current: `DOCKER_INFLUXDB_INIT_PASSWORD: "{{ influxdb_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 177:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 185:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/elasticsearch.yml

### Localhost Issues

**Line 31:**
Current: `network.host: 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 298:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 306:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/alertmanager.yml

### Password Issues

**Line 29:**
Current: `smtp_auth_password: '{{ smtp_password | default("") }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 29:**
Current: `smtp_auth_password: '{{ smtp_password | default("") }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 495:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/promtail.yml

### Localhost Issues

**Line 60:**
Current: `- localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 69:**
Current: `- localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 165:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/notify_backup.yml

### Password Issues

**Line 10:**
Current: `password: "{{ vault_backup_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 10:**
Current: `password: "{{ vault_backup_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## tasks/docker.yml

### 192.168 Issues

**Line 140:**
Current: `"base": "172.17.0.0/16",`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 144:**
Current: `"base": "172.18.0.0/16",`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 148:**
Current: `"base": "172.19.0.0/16",`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 152:**
Current: `"base": "172.20.0.0/14",`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 157:**
Current: `"bip": "172.17.0.1/16",`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 158:**
Current: `"fixed-cidr": "172.17.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## tasks/prometheus.yml

### Default_Credentials Issues

**Line 599:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 750:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/validate_services.yml

### Localhost Issues

**Line 97:**
Current: `redis-cli -h localhost -p 6379 -a {{ vault_redis_password }} ping`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 136:**
Current: `Authorization: "Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## tasks/tdarr.yml

### Localhost Issues

**Line 23:**
Current: `"serverIP": "0.0.0.0",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 27:**
Current: `"nodeIP": "0.0.0.0",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 163:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 171:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/calibre-web.yml

### Default_Credentials Issues

**Line 139:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 147:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/sonarr.yml

### Default_Credentials Issues

**Line 210:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 218:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## tasks/validate/watchtower.yml

### Localhost Issues

**Line 31:**
Current: `docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -E "0.0.0.0:[0-9]+" | grep -v "traefik\|authentik" | wc -l`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## group_vars/all/common.yml

### 192.168 Issues

**Line 7:**
Current: `ansible_server_ip: "{{ lookup('env', 'ANSIBLE_SERVER_IP') | default('192.168.1.99') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 9:**
Current: `- "{{ lookup('env', 'HOMELAB_IP_1') | default('192.168.1.100') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 10:**
Current: `- "{{ lookup('env', 'HOMELAB_IP_2') | default('192.168.1.101') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 11:**
Current: `- "{{ lookup('env', 'HOMELAB_IP_3') | default('192.168.1.102') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 12:**
Current: `- "{{ lookup('env', 'HOMELAB_IP_4') | default('192.168.1.103') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 118:**
Current: `reconya_network_range: "{{ lookup('env', 'RECONYA_NETWORK_RANGE') | default('192.168.1.0/24') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 36:**
Current: `- subnet: "172.20.0.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 37:**
Current: `gateway: "172.20.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 42:**
Current: `- subnet: "172.21.0.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 43:**
Current: `gateway: "172.21.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 48:**
Current: `- subnet: "172.22.0.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 49:**
Current: `gateway: "172.22.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 54:**
Current: `- subnet: "172.23.0.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 55:**
Current: `gateway: "172.23.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 60:**
Current: `- subnet: "172.24.0.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 61:**
Current: `gateway: "172.24.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 66:**
Current: `- subnet: "172.25.0.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 67:**
Current: `gateway: "172.25.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 25:**
Current: `docker_root: "{{ lookup('env', 'DOCKER_ROOT') | default('/opt/docker') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 26:**
Current: `docker_data_root: "{{ docker_root }}/data"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 27:**
Current: `docker_config_root: "{{ docker_root }}/config"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 28:**
Current: `docker_logs_root: "{{ docker_root }}/logs"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## group_vars/all/vault_template.yml

### Password Issues

**Line 10:**
Current: `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 11:**
Current: `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 14:**
Current: `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 15:**
Current: `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 16:**
Current: `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 17:**
Current: `vault_n8n_database_password: "{{ lookup('env', 'VAULT_N8N_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 18:**
Current: `vault_linkwarden_database_password: "{{ lookup('env', 'VAULT_LINKWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 19:**
Current: `vault_pezzo_database_password: "{{ lookup('env', 'VAULT_PEZZO_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 20:**
Current: `vault_pezzo_redis_password: "{{ lookup('env', 'VAULT_PEZZO_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 21:**
Current: `vault_pezzo_clickhouse_password: "{{ lookup('env', 'VAULT_PEZZO_CLICKHOUSE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 22:**
Current: `vault_vaultwarden_database_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `vault_reconya_database_password: "{{ lookup('env', 'VAULT_RECONYA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `vault_immich_database_password: "{{ lookup('env', 'VAULT_IMMICH_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 25:**
Current: `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 28:**
Current: `vault_nextcloud_db_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 29:**
Current: `vault_nextcloud_db_root_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 30:**
Current: `vault_nextcloud_admin_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 37:**
Current: `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 38:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `vault_portainer_admin_password: "{{ lookup('env', 'VAULT_PORTAINER_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 42:**
Current: `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 43:**
Current: `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 45:**
Current: `vault_reconya_admin_password: "{{ lookup('env', 'VAULT_RECONYA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `vault_immich_admin_password: "{{ lookup('env', 'VAULT_IMMICH_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 47:**
Current: `vault_vaultwarden_admin_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 50:**
Current: `vault_jellyfin_password: "{{ lookup('env', 'VAULT_JELLYFIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `vault_calibre_web_password: "{{ lookup('env', 'VAULT_CALIBRE_WEB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 52:**
Current: `vault_audiobookshelf_password: "{{ lookup('env', 'VAULT_AUDIOBOOKSHELF_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `vault_sabnzbd_password: "{{ lookup('env', 'VAULT_SABNZBD_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 54:**
Current: `vault_tdarr_password: "{{ lookup('env', 'VAULT_TDARR_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 55:**
Current: `vault_qbittorrent_password: "{{ lookup('env', 'VAULT_QBITTORRENT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 58:**
Current: `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 59:**
Current: `vault_mariadb_root_password: "{{ lookup('env', 'VAULT_MARIADB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 60:**
Current: `vault_proxmox_password: "{{ lookup('env', 'VAULT_PROXMOX_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 142:**
Current: `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 148:**
Current: `vault_immich_smtp_password: "{{ lookup('env', 'VAULT_IMMICH_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 149:**
Current: `vault_vaultwarden_smtp_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 150:**
Current: `vault_fing_smtp_password: "{{ lookup('env', 'VAULT_FING_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 153:**
Current: `vault_authentik_ldap_password: "{{ lookup('env', 'VAULT_AUTHENTIK_LDAP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 156:**
Current: `vault_zigbee2mqtt_mqtt_password: "{{ lookup('env', 'VAULT_ZIGBEE2MQTT_MQTT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 10:**
Current: `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 11:**
Current: `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 14:**
Current: `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 15:**
Current: `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 16:**
Current: `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 17:**
Current: `vault_n8n_database_password: "{{ lookup('env', 'VAULT_N8N_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 18:**
Current: `vault_linkwarden_database_password: "{{ lookup('env', 'VAULT_LINKWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 19:**
Current: `vault_pezzo_database_password: "{{ lookup('env', 'VAULT_PEZZO_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 20:**
Current: `vault_pezzo_redis_password: "{{ lookup('env', 'VAULT_PEZZO_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 21:**
Current: `vault_pezzo_clickhouse_password: "{{ lookup('env', 'VAULT_PEZZO_CLICKHOUSE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 22:**
Current: `vault_vaultwarden_database_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `vault_reconya_database_password: "{{ lookup('env', 'VAULT_RECONYA_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `vault_immich_database_password: "{{ lookup('env', 'VAULT_IMMICH_DATABASE_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 25:**
Current: `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 28:**
Current: `vault_nextcloud_db_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 29:**
Current: `vault_nextcloud_db_root_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_DB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 30:**
Current: `vault_nextcloud_admin_password: "{{ lookup('env', 'VAULT_NEXTCLOUD_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 37:**
Current: `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 38:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `vault_portainer_admin_password: "{{ lookup('env', 'VAULT_PORTAINER_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits,punctuation length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 42:**
Current: `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 43:**
Current: `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 45:**
Current: `vault_reconya_admin_password: "{{ lookup('env', 'VAULT_RECONYA_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `vault_immich_admin_password: "{{ lookup('env', 'VAULT_IMMICH_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 47:**
Current: `vault_vaultwarden_admin_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 50:**
Current: `vault_jellyfin_password: "{{ lookup('env', 'VAULT_JELLYFIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `vault_calibre_web_password: "{{ lookup('env', 'VAULT_CALIBRE_WEB_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 52:**
Current: `vault_audiobookshelf_password: "{{ lookup('env', 'VAULT_AUDIOBOOKSHELF_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `vault_sabnzbd_password: "{{ lookup('env', 'VAULT_SABNZBD_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 54:**
Current: `vault_tdarr_password: "{{ lookup('env', 'VAULT_TDARR_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 55:**
Current: `vault_qbittorrent_password: "{{ lookup('env', 'VAULT_QBITTORRENT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 58:**
Current: `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 59:**
Current: `vault_mariadb_root_password: "{{ lookup('env', 'VAULT_MARIADB_ROOT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 60:**
Current: `vault_proxmox_password: "{{ lookup('env', 'VAULT_PROXMOX_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 142:**
Current: `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 148:**
Current: `vault_immich_smtp_password: "{{ lookup('env', 'VAULT_IMMICH_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 149:**
Current: `vault_vaultwarden_smtp_password: "{{ lookup('env', 'VAULT_VAULTWARDEN_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 150:**
Current: `vault_fing_smtp_password: "{{ lookup('env', 'VAULT_FING_SMTP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 153:**
Current: `vault_authentik_ldap_password: "{{ lookup('env', 'VAULT_AUTHENTIK_LDAP_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 156:**
Current: `vault_zigbee2mqtt_mqtt_password: "{{ lookup('env', 'VAULT_ZIGBEE2MQTT_MQTT_PASSWORD') | default(lookup('password', '/dev/null chars=ascii_letters,digits length=32')) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## group_vars/all/proxmox.yml

### Password Issues

**Line 8:**
Current: `proxmox_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 8:**
Current: `proxmox_password: "{{ proxmox_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### 192.168 Issues

**Line 26:**
Current: `vm_ip: "{{ vm_ip | default('192.168.1.100') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 45:**
Current: `gateway: "{{ network_config.gateway | default('192.168.1.1') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 7:**
Current: `proxmox_user: "{{ proxmox_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## group_vars/all/vars.yml

### Password Issues

**Line 99:**
Current: `authentik_postgres_password: "{{ vault_authentik_postgres_password }}" # Database password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `authentik_admin_password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 104:**
Current: `wireguard_password: "{{ vault_wireguard_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 105:**
Current: `codeserver_password: "{{ vault_codeserver_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 106:**
Current: `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 127:**
Current: `influxdb_admin_password: "{{ vault_influxdb_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 132:**
Current: `influxdb_password: "{{ vault_influxdb_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 137:**
Current: `grafana_admin_password: "{{ vault_grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 298:**
Current: `postgres_password: "{{ vault_postgresql_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 299:**
Current: `redis_password: "{{ vault_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 300:**
Current: `mysql_root_password: "{{ vault_mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 585:**
Current: `homeassistant_admin_password: "{{ vault_homeassistant_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 592:**
Current: `mosquitto_admin_password: "{{ vault_mosquitto_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 600:**
Current: `zigbee2mqtt_mqtt_password: "{{ vault_zigbee2mqtt_mqtt_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 611:**
Current: `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 612:**
Current: `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 613:**
Current: `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 643:**
Current: `syncthing_gui_password: "{{ vault_syncthing_gui_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 759:**
Current: `smtp_password: "{{ vault_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 945:**
Current: `pihole_web_password: "{{ vault_pihole_admin_password }}"  # Web interface password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 961:**
Current: `vault_postgresql_password: "{{ vault_postgresql_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 962:**
Current: `vault_mariadb_root_password: "{{ vault_mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 963:**
Current: `vault_redis_password: "{{ vault_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 99:**
Current: `authentik_postgres_password: "{{ vault_authentik_postgres_password }}" # Database password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `authentik_admin_password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 104:**
Current: `wireguard_password: "{{ vault_wireguard_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 105:**
Current: `codeserver_password: "{{ vault_codeserver_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 106:**
Current: `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 127:**
Current: `influxdb_admin_password: "{{ vault_influxdb_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 132:**
Current: `influxdb_password: "{{ vault_influxdb_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 137:**
Current: `grafana_admin_password: "{{ vault_grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 298:**
Current: `postgres_password: "{{ vault_postgresql_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 299:**
Current: `redis_password: "{{ vault_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 300:**
Current: `mysql_root_password: "{{ vault_mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 585:**
Current: `homeassistant_admin_password: "{{ vault_homeassistant_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 592:**
Current: `mosquitto_admin_password: "{{ vault_mosquitto_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 600:**
Current: `zigbee2mqtt_mqtt_password: "{{ vault_zigbee2mqtt_mqtt_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 611:**
Current: `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 612:**
Current: `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 613:**
Current: `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 643:**
Current: `syncthing_gui_password: "{{ vault_syncthing_gui_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 759:**
Current: `smtp_password: "{{ vault_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 945:**
Current: `pihole_web_password: "{{ vault_pihole_admin_password }}"  # Web interface password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 961:**
Current: `vault_postgresql_password: "{{ vault_postgresql_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 962:**
Current: `vault_mariadb_root_password: "{{ vault_mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 963:**
Current: `vault_redis_password: "{{ vault_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 753:**
Current: `admin_email: "{{ lookup('env', 'ADMIN_EMAIL') | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 992:**
Current: `ssl_email: "{{ lookup('env', 'SSL_EMAIL') | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### 192.168 Issues

**Line 13:**
Current: `ip_address: "{{ lookup('env', 'HOMELAB_IP_ADDRESS') | default('192.168.1.100') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 17:**
Current: `plex_server_ip: "{{ lookup('env', 'PLEX_SERVER_IP') | default('192.168.1.41') }}"           # IP address of your existing Plex server`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 588:**
Current: `- "192.168.1.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 254:**
Current: `- subnet: "172.20.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 255:**
Current: `gateway: "172.20.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 261:**
Current: `- subnet: "172.21.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 262:**
Current: `gateway: "172.21.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 267:**
Current: `- subnet: "172.22.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 268:**
Current: `gateway: "172.22.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 835:**
Current: `docker_data_root: "{{ lookup('env', 'DOCKER_DATA_ROOT') | default('/var/lib/docker') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 126:**
Current: `influxdb_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 136:**
Current: `grafana_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 584:**
Current: `homeassistant_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 591:**
Current: `mosquitto_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 599:**
Current: `zigbee2mqtt_mqtt_user: "zigbee2mqtt"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 610:**
Current: `nextcloud_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 642:**
Current: `syncthing_gui_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 960:**
Current: `vault_postgresql_user: "{{ lookup('env', 'POSTGRESQL_USER') | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## group_vars/all/notifications.yml

### Password Issues

**Line 13:**
Current: `smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 13:**
Current: `smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 16:**
Current: `from_address: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 18:**
Current: `- "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## group_vars/all/vault.yml

### Password Issues

**Line 14:**
Current: `authentik_postgres_password: "{{ vault_authentik_postgres_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 16:**
Current: `authentik_admin_password: "{{ vault_authentik_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 19:**
Current: `wireguard_password: "{{ vault_wireguard_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 20:**
Current: `codeserver_password: "{{ vault_codeserver_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 21:**
Current: `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 32:**
Current: `smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 37:**
Current: `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 38:**
Current: `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 40:**
Current: `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `vault_n8n_postgres_password: "{{ lookup('env', 'VAULT_N8N_POSTGRES_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 92:**
Current: `pihole_web_password: "{{ vault_pihole_web_password | default('') }}"  # Web interface password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 100:**
Current: `admin_password: "{{ vault_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `database_password: "{{ vault_db_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 167:**
Current: `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 177:**
Current: `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 179:**
Current: `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 184:**
Current: `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 185:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 187:**
Current: `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 190:**
Current: `vault_immich_db_password: "{{ lookup('env', 'VAULT_IMMICH_DB_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 191:**
Current: `vault_immich_postgres_password: "{{ lookup('env', 'VAULT_IMMICH_POSTGRES_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 192:**
Current: `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 198:**
Current: `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 199:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 209:**
Current: `vault_npm_db_root_password: "{{ vault_npm_db_root_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 210:**
Current: `vault_npm_db_password: "{{ vault_npm_db_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 214:**
Current: `vault_npm_admin_password: "{{ vault_npm_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 341:**
Current: `vault_authentik_admin_password: "{{ vault_authentik_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 344:**
Current: `vault_authentik_database_password: "{{ vault_authentik_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 345:**
Current: `vault_authentik_redis_password: "{{ vault_authentik_redis_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 349:**
Current: `vault_user_password: "{{ vault_user_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 350:**
Current: `vault_user1_password: "{{ vault_user1_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 351:**
Current: `vault_user2_password: "{{ vault_user2_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 357:**
Current: `vault_grafana_admin_password: "{{ vault_grafana_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 358:**
Current: `vault_grafana_security_admin_password: "{{ vault_grafana_security_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 359:**
Current: `vault_grafana_database_password: "{{ vault_grafana_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 362:**
Current: `vault_grafana_viewer_password: "{{ vault_grafana_viewer_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 363:**
Current: `vault_grafana_editor_password: "{{ vault_grafana_editor_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 364:**
Current: `vault_grafana_family_password: "{{ vault_grafana_family_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 365:**
Current: `vault_grafana_guest_password: "{{ vault_grafana_guest_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 366:**
Current: `vault_grafana_developer_password: "{{ vault_grafana_developer_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 367:**
Current: `vault_grafana_security_password: "{{ vault_grafana_security_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 368:**
Current: `vault_grafana_media_password: "{{ vault_grafana_media_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 369:**
Current: `vault_grafana_backup_password: "{{ vault_grafana_backup_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 370:**
Current: `vault_grafana_monitoring_password: "{{ vault_grafana_monitoring_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 377:**
Current: `vault_postgresql_password: "{{ vault_postgresql_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 381:**
Current: `vault_mysql_root_password: "{{ vault_mysql_root_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 382:**
Current: `vault_mysql_password: "{{ vault_mysql_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 385:**
Current: `vault_redis_password: "{{ vault_redis_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 392:**
Current: `vault_jellyfin_admin_password: "{{ vault_jellyfin_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 409:**
Current: `vault_lidarr_password: "{{ vault_lidarr_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 421:**
Current: `vault_qbittorrent_password: "{{ vault_qbittorrent_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 440:**
Current: `vault_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 452:**
Current: `vault_homepage_admin_password: "{{ vault_homepage_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 453:**
Current: `vault_homepage_user_password: "{{ vault_homepage_user_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 474:**
Current: `vault_paperless_admin_password: "{{ vault_paperless_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 476:**
Current: `vault_paperless_database_password: "{{ vault_paperless_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 483:**
Current: `vault_reconya_admin_password: "{{ vault_reconya_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 490:**
Current: `vault_romm_admin_password: "{{ vault_romm_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 492:**
Current: `vault_romm_database_password: "{{ vault_romm_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 500:**
Current: `vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 506:**
Current: `vault_linkwarden_postgres_password: "{{ vault_linkwarden_postgres_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 513:**
Current: `vault_pezzo_postgres_password: "{{ vault_pezzo_postgres_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 514:**
Current: `vault_pezzo_redis_password: "{{ vault_pezzo_redis_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 515:**
Current: `vault_pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 534:**
Current: `vault_udm_pro_admin_password: "{{ vault_udm_pro_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 542:**
Current: `vault_prometheus_admin_password: "{{ vault_prometheus_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 545:**
Current: `vault_alertmanager_admin_password: "{{ vault_alertmanager_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 581:**
Current: `vault_dev_database_password: "{{ vault_dev_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 589:**
Current: `vault_test_database_password: "{{ vault_test_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 597:**
Current: `vault_prod_database_password: "{{ vault_prod_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 14:**
Current: `authentik_postgres_password: "{{ vault_authentik_postgres_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 16:**
Current: `authentik_admin_password: "{{ vault_authentik_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 19:**
Current: `wireguard_password: "{{ vault_wireguard_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 20:**
Current: `codeserver_password: "{{ vault_codeserver_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 21:**
Current: `gitlab_root_password: "{{ vault_gitlab_root_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 32:**
Current: `smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 37:**
Current: `vault_postgresql_password: "{{ lookup('env', 'VAULT_POSTGRESQL_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 38:**
Current: `vault_media_database_password: "{{ lookup('env', 'VAULT_MEDIA_DATABASE_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `vault_paperless_database_password: "{{ lookup('env', 'VAULT_PAPERLESS_DATABASE_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 40:**
Current: `vault_fing_database_password: "{{ lookup('env', 'VAULT_FING_DATABASE_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `vault_redis_password: "{{ lookup('env', 'VAULT_REDIS_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `vault_paperless_admin_password: "{{ lookup('env', 'VAULT_PAPERLESS_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `vault_fing_admin_password: "{{ lookup('env', 'VAULT_FING_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `vault_n8n_admin_password: "{{ lookup('env', 'VAULT_N8N_ADMIN_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `vault_n8n_postgres_password: "{{ lookup('env', 'VAULT_N8N_POSTGRES_PASSWORD') | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 92:**
Current: `pihole_web_password: "{{ vault_pihole_web_password | default('') }}"  # Web interface password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 100:**
Current: `admin_password: "{{ vault_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 101:**
Current: `database_password: "{{ vault_db_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 167:**
Current: `vault_smtp_password: "{{ lookup('env', 'VAULT_SMTP_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 177:**
Current: `vault_influxdb_admin_password: "{{ lookup('env', 'VAULT_INFLUXDB_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 179:**
Current: `vault_grafana_admin_password: "{{ lookup('env', 'VAULT_GRAFANA_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 184:**
Current: `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 185:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 187:**
Current: `vault_pihole_admin_password: "{{ lookup('env', 'VAULT_PIHOLE_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 190:**
Current: `vault_immich_db_password: "{{ lookup('env', 'VAULT_IMMICH_DB_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 191:**
Current: `vault_immich_postgres_password: "{{ lookup('env', 'VAULT_IMMICH_POSTGRES_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 192:**
Current: `vault_immich_redis_password: "{{ lookup('env', 'VAULT_IMMICH_REDIS_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 198:**
Current: `vault_authentik_postgres_password: "{{ lookup('env', 'VAULT_AUTHENTIK_POSTGRES_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 199:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 209:**
Current: `vault_npm_db_root_password: "{{ vault_npm_db_root_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 210:**
Current: `vault_npm_db_password: "{{ vault_npm_db_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 214:**
Current: `vault_npm_admin_password: "{{ vault_npm_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 341:**
Current: `vault_authentik_admin_password: "{{ vault_authentik_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 344:**
Current: `vault_authentik_database_password: "{{ vault_authentik_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 345:**
Current: `vault_authentik_redis_password: "{{ vault_authentik_redis_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 349:**
Current: `vault_user_password: "{{ vault_user_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 350:**
Current: `vault_user1_password: "{{ vault_user1_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 351:**
Current: `vault_user2_password: "{{ vault_user2_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 357:**
Current: `vault_grafana_admin_password: "{{ vault_grafana_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 358:**
Current: `vault_grafana_security_admin_password: "{{ vault_grafana_security_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 359:**
Current: `vault_grafana_database_password: "{{ vault_grafana_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 362:**
Current: `vault_grafana_viewer_password: "{{ vault_grafana_viewer_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 363:**
Current: `vault_grafana_editor_password: "{{ vault_grafana_editor_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 364:**
Current: `vault_grafana_family_password: "{{ vault_grafana_family_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 365:**
Current: `vault_grafana_guest_password: "{{ vault_grafana_guest_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 366:**
Current: `vault_grafana_developer_password: "{{ vault_grafana_developer_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 367:**
Current: `vault_grafana_security_password: "{{ vault_grafana_security_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 368:**
Current: `vault_grafana_media_password: "{{ vault_grafana_media_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 369:**
Current: `vault_grafana_backup_password: "{{ vault_grafana_backup_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 370:**
Current: `vault_grafana_monitoring_password: "{{ vault_grafana_monitoring_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 377:**
Current: `vault_postgresql_password: "{{ vault_postgresql_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 381:**
Current: `vault_mysql_root_password: "{{ vault_mysql_root_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 382:**
Current: `vault_mysql_password: "{{ vault_mysql_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 385:**
Current: `vault_redis_password: "{{ vault_redis_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 392:**
Current: `vault_jellyfin_admin_password: "{{ vault_jellyfin_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 409:**
Current: `vault_lidarr_password: "{{ vault_lidarr_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 421:**
Current: `vault_qbittorrent_password: "{{ vault_qbittorrent_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 440:**
Current: `vault_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 452:**
Current: `vault_homepage_admin_password: "{{ vault_homepage_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 453:**
Current: `vault_homepage_user_password: "{{ vault_homepage_user_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 474:**
Current: `vault_paperless_admin_password: "{{ vault_paperless_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 476:**
Current: `vault_paperless_database_password: "{{ vault_paperless_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 483:**
Current: `vault_reconya_admin_password: "{{ vault_reconya_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 490:**
Current: `vault_romm_admin_password: "{{ vault_romm_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 492:**
Current: `vault_romm_database_password: "{{ vault_romm_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 500:**
Current: `vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 506:**
Current: `vault_linkwarden_postgres_password: "{{ vault_linkwarden_postgres_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 513:**
Current: `vault_pezzo_postgres_password: "{{ vault_pezzo_postgres_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 514:**
Current: `vault_pezzo_redis_password: "{{ vault_pezzo_redis_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 515:**
Current: `vault_pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 534:**
Current: `vault_udm_pro_admin_password: "{{ vault_udm_pro_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 542:**
Current: `vault_prometheus_admin_password: "{{ vault_prometheus_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 545:**
Current: `vault_alertmanager_admin_password: "{{ vault_alertmanager_admin_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 581:**
Current: `vault_dev_database_password: "{{ vault_dev_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 589:**
Current: `vault_test_database_password: "{{ vault_test_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 597:**
Current: `vault_prod_database_password: "{{ vault_prod_database_password | password_hash('bcrypt') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 15:**
Current: `authentik_admin_email: "{{ vault_authentik_admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 34:**
Current: `admin_email: "{{ vault_admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 196:**
Current: `vault_authentik_admin_email: "{{ lookup('env', 'VAULT_AUTHENTIK_ADMIN_EMAIL') | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 213:**
Current: `vault_npm_admin_username: "admin@{{ domain }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 218:**
Current: `vault_letsencrypt_email: "{{ vault_letsencrypt_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Your_Secure_Password Issues

**Line 6:**
Current: `# Generate with: htpasswd -nb admin your_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 6:**
Current: `# Generate with: htpasswd -nb admin your_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 56:**
Current: `vault_n8n_smtp_user: "{{ lookup('env', 'VAULT_N8N_SMTP_USER') | default('') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 342:**
Current: `vault_authentik_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 378:**
Current: `vault_postgresql_user: "{{ vault_postgresql_user | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## group_vars/all/vault.yml.template

### Password Issues

**Line 6:**
Current: `vault_postgresql_password: "your_secure_postgresql_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_media_database_password: "your_secure_media_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 8:**
Current: `vault_paperless_database_password: "your_secure_paperless_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 9:**
Current: `vault_fing_database_password: "your_secure_fing_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 10:**
Current: `vault_redis_password: "your_secure_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 11:**
Current: `vault_mariadb_root_password: "your_secure_mariadb_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 14:**
Current: `vault_romm_admin_password: "your_secure_romm_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 16:**
Current: `vault_romm_database_password: "your_secure_romm_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 20:**
Current: `vault_influxdb_admin_password: "your_secure_influxdb_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `vault_paperless_admin_password: "your_secure_paperless_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 26:**
Current: `vault_fing_admin_password: "your_secure_fing_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `vault_lidarr_password: "your_secure_lidarr_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 43:**
Current: `vault_qbittorrent_password: "your_secure_qbittorrent_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `vault_homeassistant_admin_password: "your_secure_homeassistant_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 47:**
Current: `vault_mosquitto_admin_password: "your_secure_mosquitto_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 48:**
Current: `vault_zigbee2mqtt_mqtt_password: "your_secure_zigbee2mqtt_mqtt_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `vault_nextcloud_admin_password: "your_secure_nextcloud_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 52:**
Current: `vault_nextcloud_db_password: "your_secure_nextcloud_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `vault_nextcloud_db_root_password: "your_secure_nextcloud_db_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 54:**
Current: `vault_syncthing_gui_password: "your_secure_syncthing_gui_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `vault_grafana_admin_password: "your_secure_grafana_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 66:**
Current: `vault_authentik_postgres_password: "your_secure_authentik_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 68:**
Current: `vault_authentik_admin_password: "your_secure_authentik_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 74:**
Current: `vault_immich_db_password: "your_secure_immich_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 75:**
Current: `vault_immich_redis_password: "your_secure_immich_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 77:**
Current: `vault_immich_postgres_password: "your_secure_immich_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 81:**
Current: `vault_smtp_password: "your_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 6:**
Current: `vault_postgresql_password: "your_secure_postgresql_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_media_database_password: "your_secure_media_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 8:**
Current: `vault_paperless_database_password: "your_secure_paperless_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 9:**
Current: `vault_fing_database_password: "your_secure_fing_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 10:**
Current: `vault_redis_password: "your_secure_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 11:**
Current: `vault_mariadb_root_password: "your_secure_mariadb_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 14:**
Current: `vault_romm_admin_password: "your_secure_romm_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 16:**
Current: `vault_romm_database_password: "your_secure_romm_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 20:**
Current: `vault_influxdb_admin_password: "your_secure_influxdb_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `vault_paperless_admin_password: "your_secure_paperless_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 26:**
Current: `vault_fing_admin_password: "your_secure_fing_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `vault_lidarr_password: "your_secure_lidarr_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 43:**
Current: `vault_qbittorrent_password: "your_secure_qbittorrent_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `vault_homeassistant_admin_password: "your_secure_homeassistant_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 47:**
Current: `vault_mosquitto_admin_password: "your_secure_mosquitto_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 48:**
Current: `vault_zigbee2mqtt_mqtt_password: "your_secure_zigbee2mqtt_mqtt_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `vault_nextcloud_admin_password: "your_secure_nextcloud_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 52:**
Current: `vault_nextcloud_db_password: "your_secure_nextcloud_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `vault_nextcloud_db_root_password: "your_secure_nextcloud_db_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 54:**
Current: `vault_syncthing_gui_password: "your_secure_syncthing_gui_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `vault_grafana_admin_password: "your_secure_grafana_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 66:**
Current: `vault_authentik_postgres_password: "your_secure_authentik_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 68:**
Current: `vault_authentik_admin_password: "your_secure_authentik_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 74:**
Current: `vault_immich_db_password: "your_secure_immich_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 75:**
Current: `vault_immich_redis_password: "your_secure_immich_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 77:**
Current: `vault_immich_postgres_password: "your_secure_immich_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 81:**
Current: `vault_smtp_password: "your_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 67:**
Current: `vault_authentik_admin_email: "admin@yourdomain.com"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## group_vars/all/roles.yml

### Password Issues

**Line 49:**
Current: `redis_password: '{{ vault_redis_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `postgresql_password: '{{ vault_postgresql_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `mariadb_root_password: '{{ vault_mariadb_root_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 62:**
Current: `samba_password: '{{ vault_samba_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 67:**
Current: `nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 113:**
Current: `paperless_ngx_admin_password: '{{ vault_paperless_ngx_admin_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `redis_password: '{{ vault_redis_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `postgresql_password: '{{ vault_postgresql_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `mariadb_root_password: '{{ vault_mariadb_root_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 62:**
Current: `samba_password: '{{ vault_samba_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 67:**
Current: `nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 113:**
Current: `paperless_ngx_admin_password: '{{ vault_paperless_ngx_admin_password }}'`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## homepage/deploy_enhanced.sh

### Localhost Issues

**Line 791:**
Current: `log "Access your dashboard at: http://localhost:$HOMEPAGE_PORT"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 826:**
Current: `if curl -s "http://localhost:$HOMEPAGE_PORT" >/dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 827:**
Current: `echo -e "${GREEN}✅ Homepage is accessible at http://localhost:$HOMEPAGE_PORT${NC}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## homepage/deploy.sh

### Localhost Issues

**Line 184:**
Current: `if curl -f -s http://localhost:3000/health &> /dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 203:**
Current: `echo -e "${BLUE}Dashboard URL:${NC} http://localhost:3000"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## homepage/config/settings.yml

### Password Issues

**Line 140:**
Current: `password: "{{ vault_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 184:**
Current: `password: "{{ vault_homepage_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 187:**
Current: `password: "{{ vault_homepage_user_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 140:**
Current: `password: "{{ vault_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 184:**
Current: `password: "{{ vault_homepage_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 187:**
Current: `password: "{{ vault_homepage_user_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## homepage/scripts/validate_production.py

### Localhost Issues

**Line 240:**
Current: `response = requests.get("http://localhost:3000", timeout=10)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 260:**
Current: `response = requests.get("http://localhost:3000", timeout=10)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 318:**
Current: `"http://localhost:3000/api/services",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 319:**
Current: `"http://localhost:3000/api/widgets"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## homepage/scripts/service_discovery.py

### Localhost Issues

**Line 525:**
Current: `# Scan localhost for services`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 528:**
Current: `response = requests.get(f"http://localhost:{port}", timeout=2)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 539:**
Current: `'ip': 'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## tests/integration/test_deployment.yml

### Localhost Issues

**Line 174:**
Current: `host: localhost`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## tests/performance/load_test.yml

### Localhost Issues

**Line 101:**
Current: `PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c "`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 117:**
Current: `redis-benchmark -h localhost -p 6379 -a {{ vault_redis_password }} -n 10000 -c 10`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 125:**
Current: `PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user }} -d homelab -c "SELECT 1;" &`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 236:**
Current: `PGPASSWORD={{ vault_postgresql_password }} psql -h localhost -U {{ vault_postgresql_user | default('homelab') }} -d homelab -c "SELECT pg_sleep(1);" &`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 177:**
Current: `time curl -s "http://{{ ansible_default_ipv4.address }}:/api/dashboards" -H "Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## roles/certificate_management/vars/main.yml

### Admin Issues

**Line 25:**
Current: `notification_recipient: "admin@{{ domain }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## roles/databases/vars/main.yml

### Password Issues

**Line 5:**
Current: `vault_postgresql_admin_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 6:**
Current: `vault_mariadb_root_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_redis_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 8:**
Current: `vault_elasticsearch_elastic_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 5:**
Current: `vault_postgresql_admin_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 6:**
Current: `vault_mariadb_root_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_redis_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 8:**
Current: `vault_elasticsearch_elastic_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/databases/relational/tasks/mariadb.yml

### Password Issues

**Line 59:**
Current: `MARIADB_ROOT_PASSWORD: "{{ mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 59:**
Current: `MARIADB_ROOT_PASSWORD: "{{ mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 87:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/relational/tasks/postgresql.yml

### Password Issues

**Line 68:**
Current: `POSTGRES_PASSWORD: "{{ postgresql_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 68:**
Current: `POSTGRES_PASSWORD: "{{ postgresql_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 67:**
Current: `POSTGRES_USER: "{{ postgresql_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 96:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/relational.yml

### Localhost Issues

**Line 108:**
Current: `host    all            all             0.0.0.0/0              md5`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 269:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 277:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 286:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 558:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 566:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 575:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/cache.yml

### Localhost Issues

**Line 26:**
Current: `bind 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 289:**
Current: `bind 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 255:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 263:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 272:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 359:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 411:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/monitoring.yml

### Default_Credentials Issues

**Line 307:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 323:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/backup.yml

### Default_Credentials Issues

**Line 51:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 61:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 71:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 80:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 101:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 131:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 140:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 162:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 179:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/search.yml

### Localhost Issues

**Line 180:**
Current: `if ! curl -s -f "localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME" > /dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 186:**
Current: `curl -X POST "localhost:{{ elasticsearch_port }}/_snapshot/backup/$SNAPSHOT_NAME/_restore?wait_for_completion=true"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 219:**
Current: `curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq .`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 234:**
Current: `curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq .`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 237:**
Current: `curl -s "localhost:{{ elasticsearch_port }}/_cat/indices?v" | jq .`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 260:**
Current: `if ! curl -s -f "localhost:{{ elasticsearch_port }}/_cluster/health" > /dev/null 2>&1; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 266:**
Current: `STATUS=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .status)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 606:**
Current: `HEALTH=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .status)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 609:**
Current: `NODES=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .number_of_nodes)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 612:**
Current: `INDICES=$(curl -s "localhost:{{ elasticsearch_port }}/_cat/indices?v" | wc -l)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 615:**
Current: `UNASSIGNED_SHARDS=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health" | jq -r .unassigned_shards)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 658:**
Current: `HEALTH=$(curl -s "localhost:{{ elasticsearch_port }}/_cluster/health")`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 668:**
Current: `NODE_STATS=$(curl -s "localhost:{{ elasticsearch_port }}/_nodes/stats")`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 33:**
Current: `network.host: 0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 343:**
Current: `server.host: "0.0.0.0"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 300:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 308:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 317:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 517:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 642:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 723:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 730:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/alerts.yml

### Default_Credentials Issues

**Line 43:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/tasks/prerequisites.yml

### 192.168 Issues

**Line 60:**
Current: `- subnet: "{{ databases_network_subnet | default('172.20.0.0/16') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 68:**
Current: `- subnet: "{{ databases_traefik_network_subnet | default('172.18.0.0/16') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## roles/databases/cache/tasks/redis.yml

### Password Issues

**Line 59:**
Current: `REDIS_PASSWORD: "{{ redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 59:**
Current: `REDIS_PASSWORD: "{{ redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 88:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/search/tasks/kibana.yml

### Password Issues

**Line 44:**
Current: `ELASTICSEARCH_PASSWORD: "{{ elasticsearch_elastic_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `ELASTICSEARCH_PASSWORD: "{{ elasticsearch_elastic_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/databases/search/tasks/elasticsearch.yml

### Password Issues

**Line 62:**
Current: `ELASTIC_PASSWORD: "{{ elasticsearch_elastic_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 62:**
Current: `ELASTIC_PASSWORD: "{{ elasticsearch_elastic_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 93:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/databases/defaults/main.yml

### Password Issues

**Line 39:**
Current: `postgresql_admin_password: "{{ vault_postgresql_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 69:**
Current: `mariadb_root_password: "{{ vault_mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 102:**
Current: `redis_password: "{{ vault_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 156:**
Current: `elasticsearch_elastic_password: "{{ vault_elasticsearch_elastic_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 421:**
Current: `databases_smtp_password: "{{ smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 480:**
Current: `postgresql_database_password: "{{ lookup('vault', 'postgresql_database_password') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 499:**
Current: `mariadb_database_password: "{{ lookup('vault', 'mariadb_database_password') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 522:**
Current: `elasticsearch_password: "{{ vault_elasticsearch_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 535:**
Current: `kibana_password: "{{ vault_kibana_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `postgresql_admin_password: "{{ vault_postgresql_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 69:**
Current: `mariadb_root_password: "{{ vault_mariadb_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 102:**
Current: `redis_password: "{{ vault_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 156:**
Current: `elasticsearch_elastic_password: "{{ vault_elasticsearch_elastic_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 421:**
Current: `databases_smtp_password: "{{ smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 480:**
Current: `postgresql_database_password: "{{ lookup('vault', 'postgresql_database_password') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 499:**
Current: `mariadb_database_password: "{{ lookup('vault', 'mariadb_database_password') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 522:**
Current: `elasticsearch_password: "{{ vault_elasticsearch_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 535:**
Current: `kibana_password: "{{ vault_kibana_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 200:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 203:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 206:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 209:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 212:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### 192.168 Issues

**Line 200:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 203:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 206:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 209:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 212:**
Current: `source: "10.0.0.0/8"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 38:**
Current: `postgresql_admin_user: "postgres"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 479:**
Current: `postgresql_database_user: "postgres"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 491:**
Current: `mariadb_root_user: "root"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 498:**
Current: `mariadb_database_user: "root"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 521:**
Current: `elasticsearch_user: "elastic"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 534:**
Current: `kibana_user: "elastic"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/homepage/vars/main.yml

### Password Issues

**Line 66:**
Current: `basic_auth_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 66:**
Current: `basic_auth_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/homepage/tasks/configure.yml

### Default_Credentials Issues

**Line 75:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 85:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/security/vars/main.yml

### Password Issues

**Line 5:**
Current: `vault_authentik_admin_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_pihole_web_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 5:**
Current: `vault_authentik_admin_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_pihole_web_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/security/tasks/backup.yml

### Default_Credentials Issues

**Line 18:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/security/proxy/tasks/deploy.yml

### Default_Credentials Issues

**Line 341:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/security/vpn/tasks/deploy.yml

### Localhost Issues

**Line 53:**
Current: `AllowedIPs = 0.0.0.0/0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### 192.168 Issues

**Line 30:**
Current: `Address = 10.0.0.1/24`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 188:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/security/firewall/tasks/deploy.yml

### Default_Credentials Issues

**Line 168:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 288:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 296:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/security/defaults/main.yml

### Password Issues

**Line 32:**
Current: `postgres_password: "{{ vault_authentik_postgres_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `admin_password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `automation_admin_password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 64:**
Current: `password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 100:**
Current: `admin_password: "{{ vault_pihole_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 32:**
Current: `postgres_password: "{{ vault_authentik_postgres_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `admin_password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `automation_admin_password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 64:**
Current: `password: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 100:**
Current: `admin_password: "{{ vault_pihole_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 37:**
Current: `automation_admin_user: "admin"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/security/authentication/tasks/automation_integration.yml

### Password Issues

**Line 105:**
Current: `password: "{{ security_authentik.automation_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 105:**
Current: `password: "{{ security_authentik.automation_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/security/authentication/tasks/deploy.yml

### Password Issues

**Line 423:**
Current: `AUTHENTIK_ADMIN_PASSWORD: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 423:**
Current: `AUTHENTIK_ADMIN_PASSWORD: "{{ vault_authentik_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 294:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/immich/tasks/homepage.yml

### Default_Credentials Issues

**Line 40:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 78:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/immich/tasks/security.yml

### Default_Credentials Issues

**Line 64:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 112:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/immich/tasks/deploy.yml

### Password Issues

**Line 92:**
Current: `password: "{{ vault_immich_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 92:**
Current: `password: "{{ vault_immich_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/immich/tasks/monitoring.yml

### Default_Credentials Issues

**Line 61:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 87:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/immich/tasks/backup.yml

### Default_Credentials Issues

**Line 43:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 77:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 95:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 112:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/immich/tasks/alerts.yml

### Default_Credentials Issues

**Line 40:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 78:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 149:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/fing/tasks/security.yml

### Default_Credentials Issues

**Line 112:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 120:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 128:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 136:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 144:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 152:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/fing/tasks/validate_deployment.yml

### Localhost Issues

**Line 278:**
Current: `host: "localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## roles/fing/tasks/deploy.yml

### Localhost Issues

**Line 190:**
Current: `host: "localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### 192.168 Issues

**Line 57:**
Current: `- subnet: "172.20.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## roles/fing/tasks/monitoring.yml

### Default_Credentials Issues

**Line 138:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 146:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 154:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 162:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 170:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 178:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/fing/tasks/backup.yml

### Default_Credentials Issues

**Line 54:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 65:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 74:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 81:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/fing/tasks/alerts.yml

### Default_Credentials Issues

**Line 74:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 82:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 90:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 98:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 105:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/fing/tasks/prerequisites.yml

### Password Issues

**Line 274:**
Current: `admin_password: "{{ fing_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 275:**
Current: `database_password: "{{ fing_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 274:**
Current: `admin_password: "{{ fing_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 275:**
Current: `database_password: "{{ fing_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 250:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 262:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/fing/defaults/main.yml

### Password Issues

**Line 27:**
Current: `fing_admin_password: "{{ vault_fing_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 35:**
Current: `fing_database_password: "{{ vault_fing_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 186:**
Current: `fing_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 27:**
Current: `fing_admin_password: "{{ vault_fing_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 35:**
Current: `fing_database_password: "{{ vault_fing_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 186:**
Current: `fing_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 44:**
Current: `- "10.0.0.0/8"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 224:**
Current: `fing_debug_host: "0.0.0.0"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 26:**
Current: `fing_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### 192.168 Issues

**Line 43:**
Current: `- "192.168.1.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 44:**
Current: `- "10.0.0.0/8"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 45:**
Current: `- "172.16.0.0/12"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 34:**
Current: `fing_database_user: "fing"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/dumbassets/deploy.sh

### Localhost Issues

**Line 186:**
Current: `• Local Access: http://localhost:3004`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## roles/dumbassets/tasks/backup.yml

### Default_Credentials Issues

**Line 41:**
Current: `user: "{{ username | default('homelab') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/pezzo/tasks/homepage.yml

### Default_Credentials Issues

**Line 75:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/pezzo/tasks/security.yml

### Default_Credentials Issues

**Line 87:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 97:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/pezzo/tasks/monitoring.yml

### Default_Credentials Issues

**Line 77:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 113:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/pezzo/tasks/backup.yml

### Default_Credentials Issues

**Line 79:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 89:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 117:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 145:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/pezzo/tasks/alerts.yml

### Default_Credentials Issues

**Line 75:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/pezzo/tasks/prerequisites.yml

### 192.168 Issues

**Line 60:**
Current: `- subnet: "{{ pezzo_network_subnet | default('172.20.0.0/16') }}"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## roles/pezzo/defaults/main.yml

### Password Issues

**Line 34:**
Current: `pezzo_database_password: "{{ vault_pezzo_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `pezzo_redis_password: "{{ vault_pezzo_redis_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `pezzo_database_password: "{{ vault_pezzo_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 39:**
Current: `pezzo_redis_password: "{{ vault_pezzo_redis_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 46:**
Current: `pezzo_clickhouse_password: "{{ vault_pezzo_clickhouse_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 26:**
Current: `pezzo_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 33:**
Current: `pezzo_database_user: "postgres"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 45:**
Current: `pezzo_clickhouse_user: "default"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/deploy-dashboards.yml

### Password Issues

**Line 164:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 175:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 186:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 164:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 175:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 186:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 163:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 174:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 185:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 259:**
Current: `user: "{{ grafana_user | default('grafana') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/validation.yml

### Password Issues

**Line 25:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 37:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 73:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 85:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 97:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 109:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 25:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 37:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 73:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 85:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 97:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 109:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 24:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 36:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 48:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 60:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 72:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 84:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 96:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 108:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/users.yml

### Password Issues

**Line 10:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 63:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 10:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 63:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 9:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 50:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 62:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/automation_integration.yml

### Password Issues

**Line 106:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 106:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/grafana/tasks/dashboards.yml

### Password Issues

**Line 104:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 135:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 104:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 135:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 103:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 134:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 160:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/monitoring.yml

### Default_Credentials Issues

**Line 37:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 45:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 53:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/backup.yml

### Default_Credentials Issues

**Line 38:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/alerts.yml

### Password Issues

**Line 10:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 63:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 10:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 63:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 9:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 50:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 62:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/tasks/datasources.yml

### Password Issues

**Line 41:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 56:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 70:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 56:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 70:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 40:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 55:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 69:**
Current: `user: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/defaults/main.yml

### Password Issues

**Line 15:**
Current: `grafana_admin_password: "{{ vault_grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `grafana_database_password: "{{ vault_grafana_db_password | default('grafana') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 83:**
Current: `password: "{{ grafana_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 184:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 189:**
Current: `password: "{{ vault_grafana_viewer_password | default('viewer') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 194:**
Current: `password: "{{ vault_grafana_editor_password | default('editor') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 393:**
Current: `GF_SECURITY_ADMIN_PASSWORD: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 15:**
Current: `grafana_admin_password: "{{ vault_grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `grafana_database_password: "{{ vault_grafana_db_password | default('grafana') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 83:**
Current: `password: "{{ grafana_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 184:**
Current: `password: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 189:**
Current: `password: "{{ vault_grafana_viewer_password | default('viewer') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 194:**
Current: `password: "{{ vault_grafana_editor_password | default('editor') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 393:**
Current: `GF_SECURITY_ADMIN_PASSWORD: "{{ grafana_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 183:**
Current: `email: "admin@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 188:**
Current: `email: "viewer@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 193:**
Current: `email: "editor@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 202:**
Current: `email: "admins@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 206:**
Current: `email: "viewers@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 210:**
Current: `email: "editors@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 231:**
Current: `addresses: "admin@{{ domain | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 183:**
Current: `email: "admin@{{ domain | default('localhost') }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 231:**
Current: `addresses: "admin@{{ domain | default('localhost') }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 14:**
Current: `grafana_admin_user: "{{ vault_grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 23:**
Current: `grafana_database_user: "grafana"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 392:**
Current: `GF_SECURITY_ADMIN_USER: "{{ grafana_admin_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/grafana/scripts/grafana_automation.py

### Localhost Issues

**Line 946:**
Current: `url=args.url or "http://localhost:3000",`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 840:**
Current: `"email": "admin@example.com",`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 862:**
Current: `"addresses": "admin@example.com"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Admin123 Issues

**Line 841:**
Current: `"password": "admin123",`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 841:**
Current: `"password": "admin123",`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/grafana/scripts/config/notification_channels.json

### Admin Issues

**Line 9:**
Current: `"addresses": "admin@homelab.local"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## roles/radarr/defaults/main.yml

### Password Issues

**Line 34:**
Current: `radarr_admin_password: "{{ vault_radarr_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `radarr_database_password: "{{ vault_radarr_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 67:**
Current: `radarr_redis_password: "{{ vault_radarr_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 125:**
Current: `radarr_smtp_password: "{{ vault_radarr_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `password: "{{ vault_qbittorrent_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `radarr_admin_password: "{{ vault_radarr_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `radarr_database_password: "{{ vault_radarr_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 67:**
Current: `radarr_redis_password: "{{ vault_radarr_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 125:**
Current: `radarr_smtp_password: "{{ vault_radarr_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `password: "{{ vault_qbittorrent_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 49:**
Current: `radarr_ssl_email: "{{ vault_ssl_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 126:**
Current: `radarr_smtp_from: "{{ radarr_admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 127:**
Current: `radarr_smtp_to: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 270:**
Current: `radarr_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## roles/ersatztv/tasks/security.yml

### Default_Credentials Issues

**Line 458:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 467:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/ersatztv/tasks/monitoring.yml

### Default_Credentials Issues

**Line 349:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 358:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 367:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/ersatztv/tasks/backup.yml

### Default_Credentials Issues

**Line 59:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 69:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/ersatztv/tasks/alerts.yml

### Default_Credentials Issues

**Line 67:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/ersatztv/tasks/prerequisites.yml

### 192.168 Issues

**Line 72:**
Current: `- subnet: "172.23.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 73:**
Current: `gateway: "172.23.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## roles/ersatztv/defaults/main.yml

### Password Issues

**Line 58:**
Current: `ersatztv_database_password: "{{ vault_ersatztv_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 58:**
Current: `ersatztv_database_password: "{{ vault_ersatztv_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 50:**
Current: `ersatztv_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 57:**
Current: `ersatztv_database_user: "ersatztv"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/storage/vars/main.yml

### Password Issues

**Line 5:**
Current: `vault_nextcloud_admin_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 6:**
Current: `vault_nextcloud_db_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_nextcloud_db_root_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 5:**
Current: `vault_nextcloud_admin_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 6:**
Current: `vault_nextcloud_db_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 7:**
Current: `vault_nextcloud_db_root_password: ""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/storage/defaults/main.yml

### Password Issues

**Line 48:**
Current: `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 50:**
Current: `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 48:**
Current: `nextcloud_admin_password: "{{ vault_nextcloud_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `nextcloud_db_password: "{{ vault_nextcloud_db_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 50:**
Current: `nextcloud_db_root_password: "{{ vault_nextcloud_db_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 15:**
Current: `docker_data_root: "{{ docker_data_root | default('/srv/docker') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 16:**
Current: `backup_root: "{{ backup_dir | default('/srv/backup') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/utilities/tasks/security.yml

### Default_Credentials Issues

**Line 62:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/utilities/tasks/monitoring.yml

### Default_Credentials Issues

**Line 53:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/utilities/tasks/backup.yml

### Default_Credentials Issues

**Line 42:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 50:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 58:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/utilities/container_management/tasks/main.yml

### Default_Credentials Issues

**Line 46:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 54:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/utilities/media_processing/tasks/main.yml

### Default_Credentials Issues

**Line 55:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 63:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/utilities/dashboards/tasks/main.yml

### Default_Credentials Issues

**Line 35:**
Current: `become_user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/n8n/tasks/monitoring.yml

### Default_Credentials Issues

**Line 60:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/n8n/tasks/backup.yml

### Default_Credentials Issues

**Line 34:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 54:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/n8n/defaults/main.yml

### Password Issues

**Line 32:**
Current: `n8n_database_password: "{{ vault_n8n_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `- N8N_BASIC_AUTH_password: "{{ vault_n8n_admin_password | password_hash("bcrypt") }}"true' if n8n_auth_method == 'authentik' else 'false' }}`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 32:**
Current: `n8n_database_password: "{{ vault_n8n_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 53:**
Current: `- N8N_BASIC_AUTH_password: "{{ vault_n8n_admin_password | password_hash("bcrypt") }}"true' if n8n_auth_method == 'authentik' else 'false' }}`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 24:**
Current: `n8n_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 31:**
Current: `n8n_database_user: "{{ n8n_database_user | default('postgres') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 226:**
Current: `n8n_smtp_user: "{{ vault_n8n_smtp_user | default('') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/reconya/tasks/validate.yml

### 192.168 Issues

**Line 20:**
Current: `fail_msg: "Invalid network range format. Expected format: 192.168.1.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## roles/reconya/tasks/monitoring.yml

### Default_Credentials Issues

**Line 60:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/reconya/tasks/backup.yml

### Default_Credentials Issues

**Line 52:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 61:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 104:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/reconya/tasks/alerts.yml

### Default_Credentials Issues

**Line 102:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/reconya/defaults/main.yml

### Password Issues

**Line 25:**
Current: `reconya_admin_password: "{{ vault_reconya_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 25:**
Current: `reconya_admin_password: "{{ vault_reconya_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### 192.168 Issues

**Line 33:**
Current: `reconya_network_range: "192.168.1.0/24"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 38:**
Current: `reconya_network_ranges: ["192.168.1.0/24"]`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## roles/romm/tasks/deploy.yml

### Password Issues

**Line 63:**
Current: `password: "{{ vault_romm_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 63:**
Current: `password: "{{ vault_romm_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/romm/defaults/main.yml

### Password Issues

**Line 34:**
Current: `romm_admin_password: "{{ vault_romm_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 47:**
Current: `romm_database_password: "{{ vault_romm_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 138:**
Current: `ROMM_ADMIN_PASSWORD: "{{ vault_romm_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 145:**
Current: `ROMM_DATABASE_PASSWORD: "{{ vault_romm_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 218:**
Current: `romm_email_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `romm_admin_password: "{{ vault_romm_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 47:**
Current: `romm_database_password: "{{ vault_romm_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 138:**
Current: `ROMM_ADMIN_PASSWORD: "{{ vault_romm_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 145:**
Current: `ROMM_DATABASE_PASSWORD: "{{ vault_romm_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 218:**
Current: `romm_email_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 33:**
Current: `romm_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 46:**
Current: `romm_database_user: "romm"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 144:**
Current: `ROMM_DATABASE_USER: "{{ romm_database_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/vaultwarden/tasks/configure.yml

### Password Issues

**Line 17:**
Current: `vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 18:**
Current: `when: vaultwarden_database_type == 'postgresql' and (vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vault_vaultwarden_postgres_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 19:**
Current: `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_smtp_host is defined and vaultwarden_smtp_host != '' }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 29:**
Current: `vaultwarden_smtp_password: "{{ vaultwarden_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 40:**
Current: `vaultwarden_database_url: "{{ 'postgresql://' + vaultwarden_database_user + ':' + vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_backup_include_attachments | default(true) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 159:**
Current: `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_config_dir }}/secrets/homepage_api_key.txt"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 17:**
Current: `vaultwarden_postgres_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 18:**
Current: `when: vaultwarden_database_type == 'postgresql' and (vault_vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vault_vaultwarden_postgres_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 19:**
Current: `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_smtp_host is defined and vaultwarden_smtp_host != '' }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 29:**
Current: `vaultwarden_smtp_password: "{{ vaultwarden_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 40:**
Current: `vaultwarden_database_url: "{{ 'postgresql://' + vaultwarden_database_user + ':' + vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_backup_include_attachments | default(true) }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 159:**
Current: `when: vaultwarden_database_type == 'postgresql' and vaultwarden_postgres_password: "{{ vault_vaultwarden_admin_password | password_hash("bcrypt") }}"{{ vaultwarden_config_dir }}/secrets/homepage_api_key.txt"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/vaultwarden/tasks/backup.yml

### Default_Credentials Issues

**Line 37:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/vaultwarden/defaults/main.yml

### Password Issues

**Line 32:**
Current: `vaultwarden_database_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 32:**
Current: `vaultwarden_database_password: "{{ vault_vaultwarden_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 49:**
Current: `- WEBSOCKET_ADDRESS=0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 58:**
Current: `- ROCKET_ADDRESS=0.0.0.0`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 24:**
Current: `vaultwarden_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 31:**
Current: `vaultwarden_database_user: "postgres"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/automation/tasks/security.yml

### Default_Credentials Issues

**Line 35:**
Current: `user: "{{ automation_username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/automation/tasks/monitoring.yml

### Default_Credentials Issues

**Line 53:**
Current: `user: "{{ automation_username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/automation/tasks/backup.yml

### Default_Credentials Issues

**Line 29:**
Current: `user: "{{ automation_username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/automation/home_automation/tasks/main.yml

### Password Issues

**Line 95:**
Current: `password: "{{ zigbee2mqtt_mqtt_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 95:**
Current: `password: "{{ zigbee2mqtt_mqtt_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## roles/automation/container_management/tasks/main.yml

### Default_Credentials Issues

**Line 33:**
Current: `user: "{{ automation_username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 77:**
Current: `user: "{{ puid }}:{{ pgid }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/linkwarden/defaults/main.yml

### Password Issues

**Line 32:**
Current: `linkwarden_database_password: "{{ vault_linkwarden_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 32:**
Current: `linkwarden_database_password: "{{ vault_linkwarden_postgres_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 24:**
Current: `linkwarden_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 31:**
Current: `linkwarden_database_user: "postgres"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/sonarr/tasks/deploy.yml

### Password Issues

**Line 137:**
Current: `password: "{{ sonarr_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 137:**
Current: `password: "{{ sonarr_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 186:**
Current: `user: "{{ ansible_user }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/sonarr/defaults/main.yml

### Password Issues

**Line 34:**
Current: `sonarr_admin_password: "{{ vault_sonarr_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `sonarr_database_password: "{{ vault_sonarr_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 67:**
Current: `sonarr_redis_password: "{{ vault_sonarr_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 125:**
Current: `sonarr_smtp_password: "{{ vault_sonarr_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `password: "{{ vault_qbittorrent_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `sonarr_admin_password: "{{ vault_sonarr_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 61:**
Current: `sonarr_database_password: "{{ vault_sonarr_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 67:**
Current: `sonarr_redis_password: "{{ vault_sonarr_redis_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 125:**
Current: `sonarr_smtp_password: "{{ vault_sonarr_smtp_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `password: "{{ vault_qbittorrent_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 49:**
Current: `sonarr_ssl_email: "{{ vault_ssl_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 126:**
Current: `sonarr_smtp_from: "{{ sonarr_admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 127:**
Current: `sonarr_smtp_to: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 270:**
Current: `sonarr_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## roles/paperless_ngx/tasks/security.yml

### Default_Credentials Issues

**Line 217:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/paperless_ngx/tasks/validate.yml

### Localhost Issues

**Line 134:**
Current: `- { host: "{{ loki_host | default('localhost') }}", port: "{{ loki_port | default(3100) }}" }`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## roles/paperless_ngx/tasks/deploy.yml

### Password Issues

**Line 97:**
Current: `password: "{{ paperless_ngx_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 110:**
Current: `- paperless_ngx_admin_password: "{{ vault_paperless_ngx_admin_password | password_hash("bcrypt") }}"http://{{ ansible_default_ipv4.address }}:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 97:**
Current: `password: "{{ paperless_ngx_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 110:**
Current: `- paperless_ngx_admin_password: "{{ vault_paperless_ngx_admin_password | password_hash("bcrypt") }}"http://{{ ansible_default_ipv4.address }}:{{ paperless_ngx_web_port }}/api/admin/paperless/settings/"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 205:**
Current: `host: "localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## roles/paperless_ngx/tasks/monitoring.yml

### Default_Credentials Issues

**Line 167:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 176:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/paperless_ngx/tasks/backup.yml

### Default_Credentials Issues

**Line 41:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 51:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 61:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 70:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 91:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 112:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 134:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 156:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 176:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/paperless_ngx/tasks/alerts.yml

### Default_Credentials Issues

**Line 140:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/paperless_ngx/tasks/prerequisites.yml

### Password Issues

**Line 107:**
Current: `login_password: "{{ postgresql_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 116:**
Current: `password: "{{ paperless_ngx_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 120:**
Current: `login_password: "{{ postgresql_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 107:**
Current: `login_password: "{{ postgresql_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 116:**
Current: `password: "{{ paperless_ngx_database_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 120:**
Current: `login_password: "{{ postgresql_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Default_Credentials Issues

**Line 106:**
Current: `login_user: "{{ postgresql_admin_user | default('postgres') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 119:**
Current: `login_user: "{{ postgresql_admin_user | default('postgres') }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/paperless_ngx/defaults/main.yml

### Password Issues

**Line 27:**
Current: `paperless_ngx_admin_password: "{{ vault_paperless_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 36:**
Current: `paperless_ngx_database_password: "{{ vault_paperless_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `paperless_ngx_redis_password: "{{ vault_redis_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 208:**
Current: `paperless_ngx_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 27:**
Current: `paperless_ngx_admin_password: "{{ vault_paperless_admin_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 36:**
Current: `paperless_ngx_database_password: "{{ vault_paperless_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `paperless_ngx_redis_password: "{{ vault_redis_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 208:**
Current: `paperless_ngx_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 246:**
Current: `paperless_ngx_debug_host: "0.0.0.0"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 26:**
Current: `paperless_ngx_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 35:**
Current: `paperless_ngx_database_user: "paperless"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/media/tasks/monitoring.yml

### Default_Credentials Issues

**Line 97:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 104:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 184:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/media/tasks/backup.yml

### Default_Credentials Issues

**Line 33:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/media/tasks/prerequisites.yml

### Default_Credentials Issues

**Line 172:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 180:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/media/defaults/main.yml

### Password Issues

**Line 66:**
Current: `media_database_password: "{{ vault_media_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 71:**
Current: `media_redis_password: "{{ vault_redis_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 570:**
Current: `media_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 704:**
Current: `media_lidarr_password: "{{ vault_lidarr_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 707:**
Current: `media_qbittorrent_password: "{{ vault_qbittorrent_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 66:**
Current: `media_database_password: "{{ vault_media_database_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 71:**
Current: `media_redis_password: "{{ vault_redis_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 570:**
Current: `media_smtp_password: "{{ vault_smtp_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 704:**
Current: `media_lidarr_password: "{{ vault_lidarr_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 707:**
Current: `media_qbittorrent_password: "{{ vault_qbittorrent_password | default('') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 567:**
Current: `media_smtp_host: "{{ smtp_host | default('localhost') }}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 608:**
Current: `media_debug_host: "0.0.0.0"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 58:**
Current: `media_admin_email: "{{ admin_email | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 65:**
Current: `media_database_user: "media"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/nginx_proxy_manager/tasks/automation.yml

### Default_Credentials Issues

**Line 215:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 228:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 240:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 253:**
Current: `user: "{{ username }}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## roles/nginx_proxy_manager/defaults/main.yml

### Password Issues

**Line 41:**
Current: `MYSQL_ROOT_PASSWORD: "{{ vault_npm_db_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `MYSQL_PASSWORD: "{{ vault_npm_db_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 62:**
Current: `nginx_proxy_manager_api_password: "{{ vault_npm_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 41:**
Current: `MYSQL_ROOT_PASSWORD: "{{ vault_npm_db_root_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 44:**
Current: `MYSQL_PASSWORD: "{{ vault_npm_db_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 62:**
Current: `nginx_proxy_manager_api_password: "{{ vault_npm_admin_password }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 61:**
Current: `nginx_proxy_manager_api_username: "{{ vault_npm_admin_username | default('admin@' + domain) }}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 43:**
Current: `MYSQL_USER: "npm"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## scripts/setup.sh

### Password Issues

**Line 95:**
Current: `read -sp "Enter Proxmox password: " proxmox_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 110:**
Current: `proxmox_password: "$proxmox_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 95:**
Current: `read -sp "Enter Proxmox password: " proxmox_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 110:**
Current: `proxmox_password: "$proxmox_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### 192.168 Issues

**Line 100:**
Current: `network_subnet=${network_subnet:-192.168.40.0/24}`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 101:**
Current: `gateway_ip=${gateway_ip:-192.168.40.1}`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 109:**
Current: `proxmox_user: "$proxmox_user"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 143:**
Current: `proxmox_user: "$proxmox_user"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## scripts/setup_vault_env.sh

### Password Issues

**Line 153:**
Current: `export VAULT_POSTGRESQL_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 154:**
Current: `export VAULT_MEDIA_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 155:**
Current: `export VAULT_PAPERLESS_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 156:**
Current: `export VAULT_FING_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 157:**
Current: `export VAULT_ROMM_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 158:**
Current: `export VAULT_REDIS_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 159:**
Current: `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 160:**
Current: `export VAULT_INFLUXDB_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `export VAULT_IMMICH_DB_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 162:**
Current: `export VAULT_IMMICH_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 163:**
Current: `export VAULT_NEXTCLOUD_DB_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 164:**
Current: `export VAULT_NEXTCLOUD_DB_ROOT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 165:**
Current: `export VAULT_LINKWARDEN_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 166:**
Current: `export VAULT_N8N_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 167:**
Current: `export VAULT_PEZZO_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 168:**
Current: `export VAULT_AUTHENTIK_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 169:**
Current: `export VAULT_VAULTWARDEN_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 172:**
Current: `export VAULT_AUTHENTIK_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 173:**
Current: `export VAULT_GRAFANA_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 174:**
Current: `export VAULT_PAPERLESS_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 175:**
Current: `export VAULT_FING_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 176:**
Current: `export VAULT_ROMM_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 177:**
Current: `export VAULT_HOMEASSISTANT_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 178:**
Current: `export VAULT_MOSQUITTO_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 179:**
Current: `export VAULT_NEXTCLOUD_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 180:**
Current: `export VAULT_SYNCTHING_GUI_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 181:**
Current: `export VAULT_PIHOLE_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 182:**
Current: `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 183:**
Current: `export VAULT_PROXMOX_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 186:**
Current: `export VAULT_JELLYFIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 187:**
Current: `export VAULT_CALIBRE_WEB_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 188:**
Current: `export VAULT_AUDIOBOOKSHELF_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 189:**
Current: `export VAULT_SABNZBD_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 190:**
Current: `export VAULT_TDARR_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 191:**
Current: `export VAULT_QBITTORRENT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 283:**
Current: `export VAULT_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 289:**
Current: `export VAULT_IMMICH_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 290:**
Current: `export VAULT_VAULTWARDEN_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 291:**
Current: `export VAULT_FING_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 294:**
Current: `export VAULT_AUTHENTIK_LDAP_PASSWORD=""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 297:**
Current: `export VAULT_ZIGBEE2MQTT_MQTT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 118:**
Current: `read -s -p "SMTP Password: " smtp_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 153:**
Current: `export VAULT_POSTGRESQL_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 154:**
Current: `export VAULT_MEDIA_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 155:**
Current: `export VAULT_PAPERLESS_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 156:**
Current: `export VAULT_FING_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 157:**
Current: `export VAULT_ROMM_DATABASE_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 158:**
Current: `export VAULT_REDIS_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 159:**
Current: `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 160:**
Current: `export VAULT_INFLUXDB_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 161:**
Current: `export VAULT_IMMICH_DB_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 162:**
Current: `export VAULT_IMMICH_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 163:**
Current: `export VAULT_NEXTCLOUD_DB_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 164:**
Current: `export VAULT_NEXTCLOUD_DB_ROOT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 165:**
Current: `export VAULT_LINKWARDEN_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 166:**
Current: `export VAULT_N8N_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 167:**
Current: `export VAULT_PEZZO_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 168:**
Current: `export VAULT_AUTHENTIK_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 169:**
Current: `export VAULT_VAULTWARDEN_POSTGRES_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 172:**
Current: `export VAULT_AUTHENTIK_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 173:**
Current: `export VAULT_GRAFANA_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 174:**
Current: `export VAULT_PAPERLESS_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 175:**
Current: `export VAULT_FING_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 176:**
Current: `export VAULT_ROMM_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 177:**
Current: `export VAULT_HOMEASSISTANT_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 178:**
Current: `export VAULT_MOSQUITTO_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 179:**
Current: `export VAULT_NEXTCLOUD_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 180:**
Current: `export VAULT_SYNCTHING_GUI_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 181:**
Current: `export VAULT_PIHOLE_ADMIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 182:**
Current: `export VAULT_MARIADB_ROOT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 183:**
Current: `export VAULT_PROXMOX_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 186:**
Current: `export VAULT_JELLYFIN_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 187:**
Current: `export VAULT_CALIBRE_WEB_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 188:**
Current: `export VAULT_AUDIOBOOKSHELF_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 189:**
Current: `export VAULT_SABNZBD_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 190:**
Current: `export VAULT_TDARR_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 191:**
Current: `export VAULT_QBITTORRENT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 283:**
Current: `export VAULT_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 289:**
Current: `export VAULT_IMMICH_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 290:**
Current: `export VAULT_VAULTWARDEN_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 291:**
Current: `export VAULT_FING_SMTP_PASSWORD="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 294:**
Current: `export VAULT_AUTHENTIK_LDAP_PASSWORD=""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 297:**
Current: `export VAULT_ZIGBEE2MQTT_MQTT_PASSWORD="$(generate_password)"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 118:**
Current: `read -s -p "SMTP Password: " smtp_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 100:**
Current: `read -p "Enter admin email address (default: admin@zorg.media): " admin_email`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 101:**
Current: `admin_email=${admin_email:-admin@zorg.media}`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## scripts/comprehensive_automation.py

### Localhost Issues

**Line 138:**
Current: `discovery = {service_name.title()}Discovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/jellyfin_discovery.py

### Localhost Issues

**Line 72:**
Current: `discovery = JellyfinDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/test_automation_improvements.py

### Localhost Issues

**Line 27:**
Current: `self.assertTrue(InputValidator.validate_url("http://localhost:3000"))`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/security_hardening.py

### Localhost Issues

**Line 32:**
Current: `'localhost': [`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 33:**
Current: `r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 220:**
Current: `elif category == 'localhost':`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 38:**
Current: `r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 225:**
Current: `suggestions.append("Example: `admin: \"{{ admin_email | default('admin@' + domain) }}\"`")`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Changeme Issues

**Line 42:**
Current: `'changeme': [`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 43:**
Current: `r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 44:**
Current: `r'CHANGEME',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 226:**
Current: `elif category == 'changeme':`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 42:**
Current: `'changeme': [`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 43:**
Current: `r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 44:**
Current: `r'CHANGEME',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 226:**
Current: `elif category == 'changeme':`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 45:**
Current: `r'change_me',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 46:**
Current: `r'CHANGE_ME',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 45:**
Current: `r'change_me',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 46:**
Current: `r'CHANGE_ME',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

### Admin123 Issues

**Line 48:**
Current: `'admin123': [`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 50:**
Current: `r'ADMIN123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 229:**
Current: `elif category == 'admin123':`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 48:**
Current: `'admin123': [`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 49:**
Current: `r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 50:**
Current: `r'ADMIN123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 229:**
Current: `elif category == 'admin123':`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `r'password123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 52:**
Current: `r'PASSWORD123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 51:**
Current: `r'password123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 52:**
Current: `r'PASSWORD123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Your_Secure_Password Issues

**Line 54:**
Current: `'your_secure_password': [`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 55:**
Current: `r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 56:**
Current: `r'YOUR_SECURE_PASSWORD',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 232:**
Current: `elif category == 'your_secure_password':`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 54:**
Current: `'your_secure_password': [`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 55:**
Current: `r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 56:**
Current: `r'YOUR_SECURE_PASSWORD',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 232:**
Current: `elif category == 'your_secure_password':`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 57:**
Current: `r'your_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 58:**
Current: `r'YOUR_PASSWORD',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 57:**
Current: `r'your_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 58:**
Current: `r'YOUR_PASSWORD',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## scripts/service_wizard.py

### Password Issues

**Line 960:**
Current: `{service_info.name}_admin_password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 973:**
Current: `{service_info.name}_database_password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1068:**
Current: `{service_info.name.upper()}_ADMIN_PASSWORD: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1078:**
Current: `{service_info.name.upper()}_DATABASE_PASSWORD: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1166:**
Current: `{service_info.name}_email_password: "{{{{ vault_smtp_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1317:**
Current: `password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1366:**
Current: `password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 960:**
Current: `{service_info.name}_admin_password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 973:**
Current: `{service_info.name}_database_password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1068:**
Current: `{service_info.name.upper()}_ADMIN_PASSWORD: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1078:**
Current: `{service_info.name.upper()}_DATABASE_PASSWORD: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1166:**
Current: `{service_info.name}_email_password: "{{{{ vault_smtp_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1317:**
Current: `password: "{{{{ vault_{service_info.name}_admin_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1366:**
Current: `password: "{{{{ vault_{service_info.name}_database_password | default('') }}}}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 427:**
Current: `database_host = input(f"Database host [localhost]: ") or "localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 427:**
Current: `database_host = input(f"Database host [localhost]: ") or "localhost"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 950:**
Current: `{service_info.name}_domain: "{service_info.name}.{{{{ domain | default('localhost') }}}}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 969:**
Current: `{service_info.name}_database_host: "{{{{ postgresql_host | default('localhost') }}}}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1266:**
Current: `url: "http://localhost:{{{{ {service_info.name}_external_port }}}}"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1548:**
Current: `url: "http://localhost:{{{{ homepage_port | default(3000) }}}}/api/reload"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1612:**
Current: `test: ["CMD-SHELL", "curl -f http://localhost:{{{{ {service_name}_internal_port }}}}/ || exit 1"]`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 1674:**
Current: `- targets: ['localhost:{{{{ {service_info.name}_external_port }}}}']`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2223:**
Current: `return common_config.get('domain', 'localhost')`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 2225:**
Current: `return 'localhost'`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 411:**
Current: `admin_email = input(f"Admin email for {display_name} [admin@{domain}]: ") or f"admin@{domain}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 411:**
Current: `admin_email = input(f"Admin email for {display_name} [admin@{domain}]: ") or f"admin@{domain}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 959:**
Current: `{service_info.name}_admin_email: "{{{{ admin_email | default('admin@' + domain) }}}}"`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Default_Credentials Issues

**Line 972:**
Current: `{service_info.name}_database_user: "{service_info.database_user}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 1077:**
Current: `{service_info.name.upper()}_DATABASE_USER: "{{{{ {service_info.name}_database_user }}}}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 1365:**
Current: `user: "{{{{ {service_info.name}_database_user }}}}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 1490:**
Current: `user: "{{{{ ansible_user }}}}"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## scripts/enhanced_validate_hardcoded.py

### Localhost Issues

**Line 19:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 19:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 20:**
Current: `'127.0.0.1': r'127\.0\.0\.1',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 21:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 21:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Changeme Issues

**Line 22:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 22:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 22:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 22:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

### Admin123 Issues

**Line 23:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Your_Secure_Password Issues

**Line 24:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 24:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## scripts/enhanced_health_check.sh

### Localhost Issues

**Line 272:**
Current: `["traefik"]="http://localhost:8080/api/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 273:**
Current: `["authentik"]="http://localhost:9000/if/user/"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 274:**
Current: `["grafana"]="http://localhost:3000/api/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 275:**
Current: `["prometheus"]="http://localhost:9090/-/healthy"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 276:**
Current: `["influxdb"]="http://localhost:8086/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 277:**
Current: `["loki"]="http://localhost:3100/ready"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 278:**
Current: `["alertmanager"]="http://localhost:9093/-/healthy"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 279:**
Current: `["postgresql"]="localhost:5432"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 280:**
Current: `["redis"]="localhost:6379"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 281:**
Current: `["sonarr"]="http://localhost:8989/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 282:**
Current: `["radarr"]="http://localhost:7878/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 283:**
Current: `["jellyfin"]="http://localhost:8096/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 284:**
Current: `["nextcloud"]="http://localhost:8080/status.php"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 285:**
Current: `["paperless"]="http://localhost:8010/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 286:**
Current: `["fing"]="http://localhost:8080/health"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### 192.168 Issues

**Line 233:**
Current: `if ! ping -c 3 192.168.1.1 >/dev/null 2>&1; then`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## scripts/prometheus_discovery.py

### Localhost Issues

**Line 72:**
Current: `discovery = PrometheusDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/setup_monitoring_env.sh

### Admin Issues

**Line 21:**
Current: `ADMIN_EMAIL=$(prompt_with_default "ADMIN_EMAIL" "admin@zorg.media" "Enter admin email address")`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## scripts/targeted_replacement.py

### Localhost Issues

**Line 20:**
Current: `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 27:**
Current: `# localhost in health checks - make configurable`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 28:**
Current: `r'localhost:(\d+)': '{{ ansible_default_ipv4.address }}:\1',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 31:**
Current: `r'http://localhost:': 'http://{{ ansible_default_ipv4.address }}:',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 32:**
Current: `r'https://localhost:': 'https://{{ ansible_default_ipv4.address }}:',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 150:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 150:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 24:**
Current: `# 127.0.0.1 references - replace with dynamic IP`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 151:**
Current: `'127.0.0.1': r'127\.0\.0\.1',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 20:**
Current: `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 21:**
Current: `r'admin@127\.0\.0\.1': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 22:**
Current: `r'admin@yourdomain\.com': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 152:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 152:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Changeme Issues

**Line 153:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 153:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 153:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 153:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

### Admin123 Issues

**Line 154:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 154:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 154:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 154:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Your_Secure_Password Issues

**Line 155:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 155:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 155:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 155:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## scripts/plex_discovery.py

### Localhost Issues

**Line 72:**
Current: `discovery = PlexDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/test_logging_infrastructure.py

### Localhost Issues

**Line 288:**
Current: `response = requests.get('http://localhost:3100/ready', timeout=5)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 298:**
Current: `'http://localhost:3100/loki/api/v1/query_range',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/setup_environment_variables.sh

### 192.168 Issues

**Line 89:**
Current: `prompt_with_default "HOMELAB_SUBNET" "192.168.1.0/24" "Enter your network subnet:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 90:**
Current: `prompt_with_default "HOMELAB_GATEWAY" "192.168.1.1" "Enter your gateway IP:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 91:**
Current: `prompt_with_default "HOMELAB_IP_1" "192.168.1.100" "Enter IP for core1:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 92:**
Current: `prompt_with_default "HOMELAB_IP_2" "192.168.1.101" "Enter IP for core2:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 93:**
Current: `prompt_with_default "HOMELAB_IP_3" "192.168.1.102" "Enter IP for core3:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 94:**
Current: `prompt_with_default "HOMELAB_IP_4" "192.168.1.103" "Enter IP for core4:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 95:**
Current: `prompt_with_default "ANSIBLE_SERVER_IP" "192.168.1.99" "Enter Ansible control server IP:"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 96:**
Current: `prompt_with_default "PLEX_SERVER_IP" "192.168.1.41" "Enter your Plex server IP (if different):"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 83:**
Current: `prompt_with_default "HOMELAB_USERNAME" "homelab" "Enter the username for the homelab user:"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## scripts/radarr_discovery.py

### Localhost Issues

**Line 72:**
Current: `discovery = RadarrDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/test_deployment.sh

### Localhost Issues

**Line 231:**
Current: `if timeout 10 bash -c "</dev/tcp/localhost/5432" 2>/dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 242:**
Current: `if timeout 10 bash -c "</dev/tcp/localhost/6379" 2>/dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 253:**
Current: `if timeout 10 bash -c "</dev/tcp/localhost/3306" 2>/dev/null; then`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 273:**
Current: `test_http_endpoint "Prometheus" "http://localhost:9090/-/healthy" "200"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 278:**
Current: `test_http_endpoint "Grafana" "http://localhost:3000/api/health" "200"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 283:**
Current: `test_http_endpoint "Loki" "http://localhost:3100/ready" "200"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 288:**
Current: `test_http_endpoint "AlertManager" "http://localhost:9093/-/healthy" "200"`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/validate_hardcoded.py

### Localhost Issues

**Line 18:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 18:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 19:**
Current: `'127.0.0.1': r'127\.0\.0\.1',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 20:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 20:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Changeme Issues

**Line 21:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 21:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 21:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 21:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

### Admin123 Issues

**Line 22:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 22:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 22:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 22:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Your_Secure_Password Issues

**Line 23:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 23:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## scripts/validate_infrastructure.py

### Localhost Issues

**Line 254:**
Current: `with urllib.request.urlopen("http://localhost:8080/api/health", timeout=10) as response:`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 266:**
Current: `with urllib.request.urlopen("http://localhost:8080/api/http/certresolvers", timeout=10) as response:`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/grafana_discovery.py

### Localhost Issues

**Line 72:**
Current: `discovery = GrafanaDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/fix_vault_variables.sh

### Password Issues

**Line 276:**
Current: `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 277:**
Current: `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 276:**
Current: `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 277:**
Current: `"nextcloud_admin_password: '{{ vault_nextcloud_admin_password }}'" \`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 289:**
Current: `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 290:**
Current: `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 289:**
Current: `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 290:**
Current: `"time curl -s \"http://localhost:3000/api/dashboards\" -H \"Authorization: Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 295:**
Current: `"Authorization: \"Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 296:**
Current: `"Authorization: \"Basic {{ ('admin:' + vault_grafana_admin_password) | b64encode }}\"" \`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## scripts/setup_environment.sh

### Password Issues

**Line 203:**
Current: `SMTP_PASSWORD=""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 363:**
Current: `vault_postgresql_password: "{{ lookup('env', 'POSTGRESQL_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 364:**
Current: `vault_redis_password: "{{ lookup('env', 'REDIS_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 367:**
Current: `vault_grafana_admin_password: "{{ lookup('env', 'GRAFANA_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 368:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'AUTHENTIK_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 383:**
Current: `vault_smtp_password: "{{ lookup('env', 'SMTP_PASSWORD', default='') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 203:**
Current: `SMTP_PASSWORD=""`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 363:**
Current: `vault_postgresql_password: "{{ lookup('env', 'POSTGRESQL_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 364:**
Current: `vault_redis_password: "{{ lookup('env', 'REDIS_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 367:**
Current: `vault_grafana_admin_password: "{{ lookup('env', 'GRAFANA_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 368:**
Current: `vault_authentik_admin_password: "{{ lookup('env', 'AUTHENTIK_ADMIN_PASSWORD') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 383:**
Current: `vault_smtp_password: "{{ lookup('env', 'SMTP_PASSWORD', default='') }}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### 192.168 Issues

**Line 146:**
Current: `GATEWAY_IP=$(get_user_input "Enter your gateway IP address" "validate_ip" "192.168.1.1")`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 152:**
Current: `INTERNAL_SUBNET=$(get_user_input "Enter internal subnet (e.g., 192.168.1.0/24)" "" "192.168.1.0/24")`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 152:**
Current: `INTERNAL_SUBNET=$(get_user_input "Enter internal subnet (e.g., 192.168.1.0/24)" "" "192.168.1.0/24")`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

## scripts/sonarr_discovery.py

### Localhost Issues

**Line 72:**
Current: `discovery = SonarrDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/systematic_replacement.py

### Password Issues

**Line 34:**
Current: `r'password.*=.*["\']([^"\']+)["\']': 'password: "{{ vault_{{ service }}_admin_password | password_hash("bcrypt") }}"',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 34:**
Current: `r'password.*=.*["\']([^"\']+)["\']': 'password: "{{ vault_{{ service }}_admin_password | password_hash("bcrypt") }}"',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Localhost Issues

**Line 20:**
Current: `r'localhost': '{{ ansible_default_ipv4.address }}',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 24:**
Current: `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 167:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 167:**
Current: `'localhost': r'localhost',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 168:**
Current: `'127.0.0.1': r'127\.0\.0\.1',`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

### Admin Issues

**Line 24:**
Current: `r'admin@localhost': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 25:**
Current: `r'admin@127\.0\.0\.1': '{{ admin_email | default("admin@" + domain) }}',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 169:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 169:**
Current: `'admin@': r'admin@[^"\s]+',`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### Changeme Issues

**Line 28:**
Current: `r'changeme': '{{ vault_admin_password | password_hash("bcrypt") }}',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 170:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 170:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 28:**
Current: `r'changeme': '{{ vault_admin_password | password_hash("bcrypt") }}',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 170:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

**Line 170:**
Current: `'changeme': r'changeme',`
Suggested: Use vault variable
Example: `secret: "{{ vault_service_secret }}"`

### Admin123 Issues

**Line 29:**
Current: `r'admin123': '{{ vault_admin_password | password_hash("bcrypt") }}',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 171:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 171:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 29:**
Current: `r'admin123': '{{ vault_admin_password | password_hash("bcrypt") }}',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 171:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 171:**
Current: `'admin123': r'admin123',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Your_Secure_Password Issues

**Line 30:**
Current: `r'your_secure_password': '{{ vault_admin_password | password_hash("bcrypt") }}',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 172:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 172:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 30:**
Current: `r'your_secure_password': '{{ vault_admin_password | password_hash("bcrypt") }}',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 172:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 172:**
Current: `'your_secure_password': r'your_secure_password',`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

## scripts/setup_notifications.sh

### Admin Issues

**Line 73:**
Current: `admin_email=$(prompt_with_default "Admin Email" "admin@$(hostname -d)" "admin_email")`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

## scripts/homepage_automation.py

### Localhost Issues

**Line 438:**
Current: `def __init__(self, config_path: str = "config", domain: str = "localhost"):`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

**Line 878:**
Current: `parser.add_argument('--domain', default='localhost', help='Domain name for service URLs')`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/seamless_setup.sh

### Password Issues

**Line 602:**
Current: `local vaultwarden_smtp_password="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 668:**
Current: `local backup_smtp_password="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 687:**
Current: `local immich_smtp_password="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 332:**
Current: `read -sp "SMTP Password: " smtp_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 712:**
Current: `vault_postgresql_password: "$postgresql_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 713:**
Current: `vault_media_database_password: "$media_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 714:**
Current: `vault_paperless_database_password: "$paperless_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 715:**
Current: `vault_fing_database_password: "$fing_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 716:**
Current: `vault_redis_password: "$redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 717:**
Current: `vault_mariadb_root_password: "$mariadb_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 720:**
Current: `vault_influxdb_admin_password: "$influxdb_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 724:**
Current: `vault_paperless_admin_password: "$paperless_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 726:**
Current: `vault_fing_admin_password: "$fing_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 746:**
Current: `vault_lidarr_password: "$lidarr_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 748:**
Current: `vault_qbittorrent_password: "$qbittorrent_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 751:**
Current: `vault_homeassistant_admin_password: "$homeassistant_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 752:**
Current: `vault_mosquitto_admin_password: "$(generate_secure_password 32 'alphanumeric')"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 753:**
Current: `vault_zigbee2mqtt_mqtt_password: "$(generate_secure_password 32 'alphanumeric')"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 756:**
Current: `vault_nextcloud_admin_password: "$nextcloud_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 757:**
Current: `vault_nextcloud_db_password: "$nextcloud_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 758:**
Current: `vault_nextcloud_db_root_password: "$nextcloud_db_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 759:**
Current: `vault_syncthing_gui_password: "$(generate_secure_password 32 'full')"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 766:**
Current: `vault_grafana_admin_password: "$grafana_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 771:**
Current: `vault_authentik_postgres_password: "$authentik_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 773:**
Current: `vault_authentik_admin_password: "$authentik_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 774:**
Current: `vault_authentik_redis_password: "$authentik_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 780:**
Current: `vault_immich_db_password: "$immich_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 781:**
Current: `vault_immich_redis_password: "$immich_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 783:**
Current: `vault_immich_postgres_password: "$immich_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 786:**
Current: `vault_linkwarden_postgres_password: "$linkwarden_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 791:**
Current: `vault_smtp_password: "${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 803:**
Current: `vault_pihole_admin_password: "$pihole_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 806:**
Current: `vault_reconya_admin_password: "$reconya_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 810:**
Current: `vault_n8n_admin_password: "$n8n_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 812:**
Current: `vault_n8n_postgres_password: "$n8n_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 815:**
Current: `vault_pezzo_postgres_password: "$pezzo_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 816:**
Current: `vault_pezzo_redis_password: "$pezzo_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 817:**
Current: `vault_pezzo_clickhouse_password: "$pezzo_clickhouse_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 842:**
Current: `vault_gitlab_root_password: "$gitlab_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 843:**
Current: `vault_portainer_admin_password: "$portainer_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 844:**
Current: `vault_vaultwarden_admin_password: "$vaultwarden_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 845:**
Current: `vault_homepage_admin_password: "$homepage_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 848:**
Current: `vault_wireguard_password: "$wireguard_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 849:**
Current: `vault_codeserver_password: "$codeserver_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 865:**
Current: `vault_vaultwarden_postgres_password: "$vaultwarden_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 870:**
Current: `vault_vaultwarden_smtp_password: "$vaultwarden_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 902:**
Current: `vault_lidarr_password: "$lidarr_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 904:**
Current: `vault_plex_password: "$plex_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 906:**
Current: `vault_jellyfin_password: "$jellyfin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 921:**
Current: `vault_elasticsearch_password: "$elasticsearch_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 923:**
Current: `vault_kibana_password: "$kibana_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 929:**
Current: `vault_ersatztv_database_password: "$ersatztv_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 932:**
Current: `vault_grafana_db_password: "$grafana_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 933:**
Current: `vault_grafana_viewer_password: "$grafana_viewer_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 934:**
Current: `vault_grafana_editor_password: "$grafana_editor_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 948:**
Current: `vault_postgresql_admin_password: "$postgresql_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 949:**
Current: `vault_elasticsearch_elastic_password: "$elasticsearch_elastic_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 952:**
Current: `vault_backup_smtp_password: "$backup_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 955:**
Current: `vault_immich_admin_password: "$immich_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 957:**
Current: `vault_immich_smtp_password: "$immich_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 966:**
Current: `vault_pihole_database_password: "$pihole_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 977:**
Current: `vault_samba_password: "$samba_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 978:**
Current: `vault_pihole_web_password: "$pihole_web_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 979:**
Current: `vault_admin_password: "$admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 980:**
Current: `vault_db_password: "$db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 981:**
Current: `vault_paperless_ngx_admin_password: "$paperless_ngx_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 982:**
Current: `vault_homepage_user_password: "$homepage_user_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 987:**
Current: `vault_calibre_web_password: "$calibre_web_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 988:**
Current: `vault_jellyfin_password: "$jellyfin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 989:**
Current: `vault_sabnzbd_password: "$sabnzbd_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 990:**
Current: `vault_audiobookshelf_password: "$audiobookshelf_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 991:**
Current: `vault_authentik_postgres_password: "$authentik_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1332:**
Current: `password: "$smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1518:**
Current: `smtp_password: "${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 602:**
Current: `local vaultwarden_smtp_password="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 668:**
Current: `local backup_smtp_password="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 687:**
Current: `local immich_smtp_password="${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 332:**
Current: `read -sp "SMTP Password: " smtp_password`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 712:**
Current: `vault_postgresql_password: "$postgresql_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 713:**
Current: `vault_media_database_password: "$media_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 714:**
Current: `vault_paperless_database_password: "$paperless_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 715:**
Current: `vault_fing_database_password: "$fing_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 716:**
Current: `vault_redis_password: "$redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 717:**
Current: `vault_mariadb_root_password: "$mariadb_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 720:**
Current: `vault_influxdb_admin_password: "$influxdb_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 724:**
Current: `vault_paperless_admin_password: "$paperless_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 726:**
Current: `vault_fing_admin_password: "$fing_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 746:**
Current: `vault_lidarr_password: "$lidarr_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 748:**
Current: `vault_qbittorrent_password: "$qbittorrent_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 751:**
Current: `vault_homeassistant_admin_password: "$homeassistant_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 752:**
Current: `vault_mosquitto_admin_password: "$(generate_secure_password 32 'alphanumeric')"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 753:**
Current: `vault_zigbee2mqtt_mqtt_password: "$(generate_secure_password 32 'alphanumeric')"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 756:**
Current: `vault_nextcloud_admin_password: "$nextcloud_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 757:**
Current: `vault_nextcloud_db_password: "$nextcloud_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 758:**
Current: `vault_nextcloud_db_root_password: "$nextcloud_db_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 759:**
Current: `vault_syncthing_gui_password: "$(generate_secure_password 32 'full')"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 766:**
Current: `vault_grafana_admin_password: "$grafana_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 771:**
Current: `vault_authentik_postgres_password: "$authentik_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 773:**
Current: `vault_authentik_admin_password: "$authentik_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 774:**
Current: `vault_authentik_redis_password: "$authentik_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 780:**
Current: `vault_immich_db_password: "$immich_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 781:**
Current: `vault_immich_redis_password: "$immich_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 783:**
Current: `vault_immich_postgres_password: "$immich_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 786:**
Current: `vault_linkwarden_postgres_password: "$linkwarden_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 791:**
Current: `vault_smtp_password: "${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 803:**
Current: `vault_pihole_admin_password: "$pihole_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 806:**
Current: `vault_reconya_admin_password: "$reconya_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 810:**
Current: `vault_n8n_admin_password: "$n8n_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 812:**
Current: `vault_n8n_postgres_password: "$n8n_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 815:**
Current: `vault_pezzo_postgres_password: "$pezzo_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 816:**
Current: `vault_pezzo_redis_password: "$pezzo_redis_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 817:**
Current: `vault_pezzo_clickhouse_password: "$pezzo_clickhouse_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 842:**
Current: `vault_gitlab_root_password: "$gitlab_root_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 843:**
Current: `vault_portainer_admin_password: "$portainer_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 844:**
Current: `vault_vaultwarden_admin_password: "$vaultwarden_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 845:**
Current: `vault_homepage_admin_password: "$homepage_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 848:**
Current: `vault_wireguard_password: "$wireguard_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 849:**
Current: `vault_codeserver_password: "$codeserver_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 865:**
Current: `vault_vaultwarden_postgres_password: "$vaultwarden_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 870:**
Current: `vault_vaultwarden_smtp_password: "$vaultwarden_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 902:**
Current: `vault_lidarr_password: "$lidarr_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 904:**
Current: `vault_plex_password: "$plex_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 906:**
Current: `vault_jellyfin_password: "$jellyfin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 921:**
Current: `vault_elasticsearch_password: "$elasticsearch_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 923:**
Current: `vault_kibana_password: "$kibana_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 929:**
Current: `vault_ersatztv_database_password: "$ersatztv_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 932:**
Current: `vault_grafana_db_password: "$grafana_db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 933:**
Current: `vault_grafana_viewer_password: "$grafana_viewer_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 934:**
Current: `vault_grafana_editor_password: "$grafana_editor_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 948:**
Current: `vault_postgresql_admin_password: "$postgresql_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 949:**
Current: `vault_elasticsearch_elastic_password: "$elasticsearch_elastic_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 952:**
Current: `vault_backup_smtp_password: "$backup_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 955:**
Current: `vault_immich_admin_password: "$immich_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 957:**
Current: `vault_immich_smtp_password: "$immich_smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 966:**
Current: `vault_pihole_database_password: "$pihole_database_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 977:**
Current: `vault_samba_password: "$samba_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 978:**
Current: `vault_pihole_web_password: "$pihole_web_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 979:**
Current: `vault_admin_password: "$admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 980:**
Current: `vault_db_password: "$db_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 981:**
Current: `vault_paperless_ngx_admin_password: "$paperless_ngx_admin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 982:**
Current: `vault_homepage_user_password: "$homepage_user_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 987:**
Current: `vault_calibre_web_password: "$calibre_web_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 988:**
Current: `vault_jellyfin_password: "$jellyfin_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 989:**
Current: `vault_sabnzbd_password: "$sabnzbd_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 990:**
Current: `vault_audiobookshelf_password: "$audiobookshelf_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 991:**
Current: `vault_authentik_postgres_password: "$authentik_postgres_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1332:**
Current: `password: "$smtp_password"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

**Line 1518:**
Current: `smtp_password: "${smtp_password:-}"`
Suggested: Use vault variable
Example: `password: "{{ vault_service_password }}"`

### Admin Issues

**Line 239:**
Current: `read -p "Enter admin email address (default: admin@$domain): " admin_email`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 240:**
Current: `admin_email=${admin_email:-admin@$domain}`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

**Line 2044:**
Current: `- Nginx Proxy Manager: admin@$domain / (see credentials backup)`
Suggested: Use dynamic admin
Example: `admin: "{{ admin_email | default('admin@' + domain) }}"`

### 192.168 Issues

**Line 373:**
Current: `read -p "Internal subnet (default: 192.168.1.0/24): " internal_subnet`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 374:**
Current: `internal_subnet=${internal_subnet:-192.168.1.0/24}`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 1606:**
Current: `- subnet: "172.20.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 1607:**
Current: `gateway: "172.20.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 1612:**
Current: `- subnet: "172.21.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 1613:**
Current: `gateway: "172.21.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 1617:**
Current: `- subnet: "172.22.0.0/16"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

**Line 1618:**
Current: `gateway: "172.22.0.1"`
Suggested: Use dynamic IP
Example: `ip: "{{ ansible_default_ipv4.address }}"`

### Default_Credentials Issues

**Line 1532:**
Current: `docker_root: "$docker_root"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 914:**
Current: `vault_grafana_admin_user: "$grafana_admin_user"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 915:**
Current: `vault_influxdb_admin_user: "$influxdb_admin_user"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 919:**
Current: `vault_postgresql_user: "$postgresql_user"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

**Line 2127:**
Current: `echo "Please run the deployment as the homelab user:"`
Suggested: Use vault variables
Example: `user: "{{ vault_service_user }}"`

## scripts/service_discovery/harbor_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = HarborDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/code_server_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = Code_ServerDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/crowdsec_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = CrowdsecDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/immich_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = ImmichDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/jellyfin_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = JellyfinDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/vault_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = VaultDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/blackbox_exporter_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = Blackbox_ExporterDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/prometheus_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = PrometheusDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/plex_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = PlexDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/portainer_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = PortainerDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/promtail_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = PromtailDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/radarr_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = RadarrDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/emby_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = EmbyDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/pihole_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = PiholeDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/alertmanager_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = AlertmanagerDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/loki_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = LokiDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/telegraf_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = TelegrafDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/komga_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = KomgaDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/fail2ban_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = Fail2BanDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/calibre_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = CalibreDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/nextcloud_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = NextcloudDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/sonarr_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = SonarrDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/audiobookshelf_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = AudiobookshelfDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/gitlab_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = GitlabDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/wireguard_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = WireguardDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`

## scripts/service_discovery/influxdb_discovery.py

### Localhost Issues

**Line 71:**
Current: `discovery = InfluxdbDiscovery("localhost", 8080)`
Suggested: Use dynamic host
Example: `host: "{{ ansible_default_ipv4.address }}"`


==================================================
Vault Variables
==================================================
# Generated Vault Variables
# Add these to group_vars/all/vault.yml

# Automation Variables
vault_automation_admin_password: "{ vault_automation_admin_password | password_hash('bcrypt') }"
vault_automation_database_password: "{ vault_automation_database_password | password_hash('bcrypt') }"
vault_automation_api_token: "{ vault_automation_api_token | default('') }"
vault_automation_secret_key: "{ vault_automation_secret_key | default('') }"
vault_automation_encryption_key: "{ vault_automation_encryption_key | default('') }"
vault_automation_jwt_secret: "{ vault_automation_jwt_secret | default('') }"
vault_automation_redis_password: "{ vault_automation_redis_password | password_hash('bcrypt') }"
vault_automation_smtp_password: "{ vault_automation_smtp_password | default('') }"

# Certificate_Management Variables
vault_certificate_management_admin_password: "{ vault_certificate_management_admin_password | password_hash('bcrypt') }"
vault_certificate_management_database_password: "{ vault_certificate_management_database_password | password_hash('bcrypt') }"
vault_certificate_management_api_token: "{ vault_certificate_management_api_token | default('') }"
vault_certificate_management_secret_key: "{ vault_certificate_management_secret_key | default('') }"
vault_certificate_management_encryption_key: "{ vault_certificate_management_encryption_key | default('') }"
vault_certificate_management_jwt_secret: "{ vault_certificate_management_jwt_secret | default('') }"
vault_certificate_management_redis_password: "{ vault_certificate_management_redis_password | password_hash('bcrypt') }"
vault_certificate_management_smtp_password: "{ vault_certificate_management_smtp_password | default('') }"

# Databases Variables
vault_databases_admin_password: "{ vault_databases_admin_password | password_hash('bcrypt') }"
vault_databases_database_password: "{ vault_databases_database_password | password_hash('bcrypt') }"
vault_databases_api_token: "{ vault_databases_api_token | default('') }"
vault_databases_secret_key: "{ vault_databases_secret_key | default('') }"
vault_databases_encryption_key: "{ vault_databases_encryption_key | default('') }"
vault_databases_jwt_secret: "{ vault_databases_jwt_secret | default('') }"
vault_databases_redis_password: "{ vault_databases_redis_password | password_hash('bcrypt') }"
vault_databases_smtp_password: "{ vault_databases_smtp_password | default('') }"

# Dumbassets Variables
vault_dumbassets_admin_password: "{ vault_dumbassets_admin_password | password_hash('bcrypt') }"
vault_dumbassets_database_password: "{ vault_dumbassets_database_password | password_hash('bcrypt') }"
vault_dumbassets_api_token: "{ vault_dumbassets_api_token | default('') }"
vault_dumbassets_secret_key: "{ vault_dumbassets_secret_key | default('') }"
vault_dumbassets_encryption_key: "{ vault_dumbassets_encryption_key | default('') }"
vault_dumbassets_jwt_secret: "{ vault_dumbassets_jwt_secret | default('') }"
vault_dumbassets_redis_password: "{ vault_dumbassets_redis_password | password_hash('bcrypt') }"
vault_dumbassets_smtp_password: "{ vault_dumbassets_smtp_password | default('') }"

# Ersatztv Variables
vault_ersatztv_admin_password: "{ vault_ersatztv_admin_password | password_hash('bcrypt') }"
vault_ersatztv_database_password: "{ vault_ersatztv_database_password | password_hash('bcrypt') }"
vault_ersatztv_api_token: "{ vault_ersatztv_api_token | default('') }"
vault_ersatztv_secret_key: "{ vault_ersatztv_secret_key | default('') }"
vault_ersatztv_encryption_key: "{ vault_ersatztv_encryption_key | default('') }"
vault_ersatztv_jwt_secret: "{ vault_ersatztv_jwt_secret | default('') }"
vault_ersatztv_redis_password: "{ vault_ersatztv_redis_password | password_hash('bcrypt') }"
vault_ersatztv_smtp_password: "{ vault_ersatztv_smtp_password | default('') }"

# Fing Variables
vault_fing_admin_password: "{ vault_fing_admin_password | password_hash('bcrypt') }"
vault_fing_database_password: "{ vault_fing_database_password | password_hash('bcrypt') }"
vault_fing_api_token: "{ vault_fing_api_token | default('') }"
vault_fing_secret_key: "{ vault_fing_secret_key | default('') }"
vault_fing_encryption_key: "{ vault_fing_encryption_key | default('') }"
vault_fing_jwt_secret: "{ vault_fing_jwt_secret | default('') }"
vault_fing_redis_password: "{ vault_fing_redis_password | password_hash('bcrypt') }"
vault_fing_smtp_password: "{ vault_fing_smtp_password | default('') }"

# Grafana Variables
vault_grafana_admin_password: "{ vault_grafana_admin_password | password_hash('bcrypt') }"
vault_grafana_database_password: "{ vault_grafana_database_password | password_hash('bcrypt') }"
vault_grafana_api_token: "{ vault_grafana_api_token | default('') }"
vault_grafana_secret_key: "{ vault_grafana_secret_key | default('') }"
vault_grafana_encryption_key: "{ vault_grafana_encryption_key | default('') }"
vault_grafana_jwt_secret: "{ vault_grafana_jwt_secret | default('') }"
vault_grafana_redis_password: "{ vault_grafana_redis_password | password_hash('bcrypt') }"
vault_grafana_smtp_password: "{ vault_grafana_smtp_password | default('') }"

# Homepage Variables
vault_homepage_admin_password: "{ vault_homepage_admin_password | password_hash('bcrypt') }"
vault_homepage_database_password: "{ vault_homepage_database_password | password_hash('bcrypt') }"
vault_homepage_api_token: "{ vault_homepage_api_token | default('') }"
vault_homepage_secret_key: "{ vault_homepage_secret_key | default('') }"
vault_homepage_encryption_key: "{ vault_homepage_encryption_key | default('') }"
vault_homepage_jwt_secret: "{ vault_homepage_jwt_secret | default('') }"
vault_homepage_redis_password: "{ vault_homepage_redis_password | password_hash('bcrypt') }"
vault_homepage_smtp_password: "{ vault_homepage_smtp_password | default('') }"

# Immich Variables
vault_immich_admin_password: "{ vault_immich_admin_password | password_hash('bcrypt') }"
vault_immich_database_password: "{ vault_immich_database_password | password_hash('bcrypt') }"
vault_immich_api_token: "{ vault_immich_api_token | default('') }"
vault_immich_secret_key: "{ vault_immich_secret_key | default('') }"
vault_immich_encryption_key: "{ vault_immich_encryption_key | default('') }"
vault_immich_jwt_secret: "{ vault_immich_jwt_secret | default('') }"
vault_immich_redis_password: "{ vault_immich_redis_password | password_hash('bcrypt') }"
vault_immich_smtp_password: "{ vault_immich_smtp_password | default('') }"

# Linkwarden Variables
vault_linkwarden_admin_password: "{ vault_linkwarden_admin_password | password_hash('bcrypt') }"
vault_linkwarden_database_password: "{ vault_linkwarden_database_password | password_hash('bcrypt') }"
vault_linkwarden_api_token: "{ vault_linkwarden_api_token | default('') }"
vault_linkwarden_secret_key: "{ vault_linkwarden_secret_key | default('') }"
vault_linkwarden_encryption_key: "{ vault_linkwarden_encryption_key | default('') }"
vault_linkwarden_jwt_secret: "{ vault_linkwarden_jwt_secret | default('') }"
vault_linkwarden_redis_password: "{ vault_linkwarden_redis_password | password_hash('bcrypt') }"
vault_linkwarden_smtp_password: "{ vault_linkwarden_smtp_password | default('') }"

# Media Variables
vault_media_admin_password: "{ vault_media_admin_password | password_hash('bcrypt') }"
vault_media_database_password: "{ vault_media_database_password | password_hash('bcrypt') }"
vault_media_api_token: "{ vault_media_api_token | default('') }"
vault_media_secret_key: "{ vault_media_secret_key | default('') }"
vault_media_encryption_key: "{ vault_media_encryption_key | default('') }"
vault_media_jwt_secret: "{ vault_media_jwt_secret | default('') }"
vault_media_redis_password: "{ vault_media_redis_password | password_hash('bcrypt') }"
vault_media_smtp_password: "{ vault_media_smtp_password | default('') }"

# N8N Variables
vault_n8n_admin_password: "{ vault_n8n_admin_password | password_hash('bcrypt') }"
vault_n8n_database_password: "{ vault_n8n_database_password | password_hash('bcrypt') }"
vault_n8n_api_token: "{ vault_n8n_api_token | default('') }"
vault_n8n_secret_key: "{ vault_n8n_secret_key | default('') }"
vault_n8n_encryption_key: "{ vault_n8n_encryption_key | default('') }"
vault_n8n_jwt_secret: "{ vault_n8n_jwt_secret | default('') }"
vault_n8n_redis_password: "{ vault_n8n_redis_password | password_hash('bcrypt') }"
vault_n8n_smtp_password: "{ vault_n8n_smtp_password | default('') }"

# Nginx_Proxy_Manager Variables
vault_nginx_proxy_manager_admin_password: "{ vault_nginx_proxy_manager_admin_password | password_hash('bcrypt') }"
vault_nginx_proxy_manager_database_password: "{ vault_nginx_proxy_manager_database_password | password_hash('bcrypt') }"
vault_nginx_proxy_manager_api_token: "{ vault_nginx_proxy_manager_api_token | default('') }"
vault_nginx_proxy_manager_secret_key: "{ vault_nginx_proxy_manager_secret_key | default('') }"
vault_nginx_proxy_manager_encryption_key: "{ vault_nginx_proxy_manager_encryption_key | default('') }"
vault_nginx_proxy_manager_jwt_secret: "{ vault_nginx_proxy_manager_jwt_secret | default('') }"
vault_nginx_proxy_manager_redis_password: "{ vault_nginx_proxy_manager_redis_password | password_hash('bcrypt') }"
vault_nginx_proxy_manager_smtp_password: "{ vault_nginx_proxy_manager_smtp_password | default('') }"

# Paperless_Ngx Variables
vault_paperless_ngx_admin_password: "{ vault_paperless_ngx_admin_password | password_hash('bcrypt') }"
vault_paperless_ngx_database_password: "{ vault_paperless_ngx_database_password | password_hash('bcrypt') }"
vault_paperless_ngx_api_token: "{ vault_paperless_ngx_api_token | default('') }"
vault_paperless_ngx_secret_key: "{ vault_paperless_ngx_secret_key | default('') }"
vault_paperless_ngx_encryption_key: "{ vault_paperless_ngx_encryption_key | default('') }"
vault_paperless_ngx_jwt_secret: "{ vault_paperless_ngx_jwt_secret | default('') }"
vault_paperless_ngx_redis_password: "{ vault_paperless_ngx_redis_password | password_hash('bcrypt') }"
vault_paperless_ngx_smtp_password: "{ vault_paperless_ngx_smtp_password | default('') }"

# Pezzo Variables
vault_pezzo_admin_password: "{ vault_pezzo_admin_password | password_hash('bcrypt') }"
vault_pezzo_database_password: "{ vault_pezzo_database_password | password_hash('bcrypt') }"
vault_pezzo_api_token: "{ vault_pezzo_api_token | default('') }"
vault_pezzo_secret_key: "{ vault_pezzo_secret_key | default('') }"
vault_pezzo_encryption_key: "{ vault_pezzo_encryption_key | default('') }"
vault_pezzo_jwt_secret: "{ vault_pezzo_jwt_secret | default('') }"
vault_pezzo_redis_password: "{ vault_pezzo_redis_password | password_hash('bcrypt') }"
vault_pezzo_smtp_password: "{ vault_pezzo_smtp_password | default('') }"

# Radarr Variables
vault_radarr_admin_password: "{ vault_radarr_admin_password | password_hash('bcrypt') }"
vault_radarr_database_password: "{ vault_radarr_database_password | password_hash('bcrypt') }"
vault_radarr_api_token: "{ vault_radarr_api_token | default('') }"
vault_radarr_secret_key: "{ vault_radarr_secret_key | default('') }"
vault_radarr_encryption_key: "{ vault_radarr_encryption_key | default('') }"
vault_radarr_jwt_secret: "{ vault_radarr_jwt_secret | default('') }"
vault_radarr_redis_password: "{ vault_radarr_redis_password | password_hash('bcrypt') }"
vault_radarr_smtp_password: "{ vault_radarr_smtp_password | default('') }"

# Reconya Variables
vault_reconya_admin_password: "{ vault_reconya_admin_password | password_hash('bcrypt') }"
vault_reconya_database_password: "{ vault_reconya_database_password | password_hash('bcrypt') }"
vault_reconya_api_token: "{ vault_reconya_api_token | default('') }"
vault_reconya_secret_key: "{ vault_reconya_secret_key | default('') }"
vault_reconya_encryption_key: "{ vault_reconya_encryption_key | default('') }"
vault_reconya_jwt_secret: "{ vault_reconya_jwt_secret | default('') }"
vault_reconya_redis_password: "{ vault_reconya_redis_password | password_hash('bcrypt') }"
vault_reconya_smtp_password: "{ vault_reconya_smtp_password | default('') }"

# Romm Variables
vault_romm_admin_password: "{ vault_romm_admin_password | password_hash('bcrypt') }"
vault_romm_database_password: "{ vault_romm_database_password | password_hash('bcrypt') }"
vault_romm_api_token: "{ vault_romm_api_token | default('') }"
vault_romm_secret_key: "{ vault_romm_secret_key | default('') }"
vault_romm_encryption_key: "{ vault_romm_encryption_key | default('') }"
vault_romm_jwt_secret: "{ vault_romm_jwt_secret | default('') }"
vault_romm_redis_password: "{ vault_romm_redis_password | password_hash('bcrypt') }"
vault_romm_smtp_password: "{ vault_romm_smtp_password | default('') }"

# Security Variables
vault_security_admin_password: "{ vault_security_admin_password | password_hash('bcrypt') }"
vault_security_database_password: "{ vault_security_database_password | password_hash('bcrypt') }"
vault_security_api_token: "{ vault_security_api_token | default('') }"
vault_security_secret_key: "{ vault_security_secret_key | default('') }"
vault_security_encryption_key: "{ vault_security_encryption_key | default('') }"
vault_security_jwt_secret: "{ vault_security_jwt_secret | default('') }"
vault_security_redis_password: "{ vault_security_redis_password | password_hash('bcrypt') }"
vault_security_smtp_password: "{ vault_security_smtp_password | default('') }"

# Sonarr Variables
vault_sonarr_admin_password: "{ vault_sonarr_admin_password | password_hash('bcrypt') }"
vault_sonarr_database_password: "{ vault_sonarr_database_password | password_hash('bcrypt') }"
vault_sonarr_api_token: "{ vault_sonarr_api_token | default('') }"
vault_sonarr_secret_key: "{ vault_sonarr_secret_key | default('') }"
vault_sonarr_encryption_key: "{ vault_sonarr_encryption_key | default('') }"
vault_sonarr_jwt_secret: "{ vault_sonarr_jwt_secret | default('') }"
vault_sonarr_redis_password: "{ vault_sonarr_redis_password | password_hash('bcrypt') }"
vault_sonarr_smtp_password: "{ vault_sonarr_smtp_password | default('') }"

# Storage Variables
vault_storage_admin_password: "{ vault_storage_admin_password | password_hash('bcrypt') }"
vault_storage_database_password: "{ vault_storage_database_password | password_hash('bcrypt') }"
vault_storage_api_token: "{ vault_storage_api_token | default('') }"
vault_storage_secret_key: "{ vault_storage_secret_key | default('') }"
vault_storage_encryption_key: "{ vault_storage_encryption_key | default('') }"
vault_storage_jwt_secret: "{ vault_storage_jwt_secret | default('') }"
vault_storage_redis_password: "{ vault_storage_redis_password | password_hash('bcrypt') }"
vault_storage_smtp_password: "{ vault_storage_smtp_password | default('') }"

# Utilities Variables
vault_utilities_admin_password: "{ vault_utilities_admin_password | password_hash('bcrypt') }"
vault_utilities_database_password: "{ vault_utilities_database_password | password_hash('bcrypt') }"
vault_utilities_api_token: "{ vault_utilities_api_token | default('') }"
vault_utilities_secret_key: "{ vault_utilities_secret_key | default('') }"
vault_utilities_encryption_key: "{ vault_utilities_encryption_key | default('') }"
vault_utilities_jwt_secret: "{ vault_utilities_jwt_secret | default('') }"
vault_utilities_redis_password: "{ vault_utilities_redis_password | password_hash('bcrypt') }"
vault_utilities_smtp_password: "{ vault_utilities_smtp_password | default('') }"

# Vaultwarden Variables
vault_vaultwarden_admin_password: "{ vault_vaultwarden_admin_password | password_hash('bcrypt') }"
vault_vaultwarden_database_password: "{ vault_vaultwarden_database_password | password_hash('bcrypt') }"
vault_vaultwarden_api_token: "{ vault_vaultwarden_api_token | default('') }"
vault_vaultwarden_secret_key: "{ vault_vaultwarden_secret_key | default('') }"
vault_vaultwarden_encryption_key: "{ vault_vaultwarden_encryption_key | default('') }"
vault_vaultwarden_jwt_secret: "{ vault_vaultwarden_jwt_secret | default('') }"
vault_vaultwarden_redis_password: "{ vault_vaultwarden_redis_password | password_hash('bcrypt') }"
vault_vaultwarden_smtp_password: "{ vault_vaultwarden_smtp_password | default('') }"

