#!/usr/bin/env bash
set -euo pipefail

# Purpose: Fail if templates set environment variables that look like secrets
#          without using the *_FILE indirection (list or mapping forms).
# Scope: roles/**/templates/*.j2 and templates/**/*.j2

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

EXIT_CODE=0
offenders_file="$(mktemp)"
trap 'rm -f "$offenders_file"' EXIT

# Pattern for secret-like keys (avoid generic API; accept API_KEY only)
secret_key_re='(PASSWORD|SECRET|TOKEN|API)'

scan_path() {
  local base="$1"
  find "$base" -type f -name "*.j2" -print 2>/dev/null | while IFS= read -r f; do
    rel="${f#$ROOT_DIR/}"
    # List form: - KEY=VALUE
    grep -nE "^[[:space:]]*-[[:space:]]*[A-Za-z0-9_]*${secret_key_re}[A-Za-z0-9_]*=" "$f" 2>/dev/null \
      | grep -v "_FILE" \
      | grep -vE "(_API_URL=|_API_ENABLED=|_API_PORT=|_API_VERSION=|_API_RATE_LIMIT=|_API_RATE_LIMIT_WINDOW=|VAAPI_DEVICE=)" \
      | sed -e "s|^|${rel}: |" \
      >> "$offenders_file" || true
    # Mapping form: KEY: VALUE
    grep -nE "^[[:space:]]*[A-Za-z0-9_]*${secret_key_re}[A-Za-z0-9_]*:[[:space:]]" "$f" 2>/dev/null \
      | grep -v "_FILE[[:space:]]*:" \
      | grep -vE "(_API_URL:|_API_ENABLED:|_API_PORT:|_API_VERSION:|_API_RATE_LIMIT:|_API_RATE_LIMIT_WINDOW:|VAAPI_DEVICE:)" \
      | sed -e "s|^|${rel}: |" \
      >> "$offenders_file" || true
  done
}

scan_path "$ROOT_DIR/templates"
scan_path "$ROOT_DIR/roles"

if [[ -s "$offenders_file" ]]; then
  echo "ERROR: Found secret-like environment variables without *_FILE in templates:" >&2
  sort -u "$offenders_file" >&2
  cat <<'NOTE' >&2
Guidance: Use file-based secrets. For any env key containing PASSWORD, SECRET, TOKEN, or API_KEY, set:
  - KEY_FILE=/run/secrets/KEY
and mount the secret file under /run/secrets/KEY.
NOTE
  EXIT_CODE=1
fi

exit "$EXIT_CODE"


