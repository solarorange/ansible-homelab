#!/usr/bin/env bash
set -euo pipefail

# Purpose: Fail if any Compose templates contain a 'deploy:' with 'resources:' stanza.
# Scope: templates/**/*.j2 and roles/**/templates/*.j2

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

offenders_file="$(mktemp)"
trap 'rm -f "$offenders_file"' EXIT

find "$ROOT_DIR" \
  \( -path "$ROOT_DIR/templates/*" -o -path "$ROOT_DIR/roles/*/templates/*" \) \
  -type f -name "*.j2" -print 2>/dev/null | while IFS= read -r f; do
  if grep -InE "^[[:space:]]*deploy:[[:space:]]*$" "$f" >/dev/null 2>&1; then
    if grep -InE "^[[:space:]]*resources:[[:space:]]*$" "$f" >/dev/null 2>&1; then
      rel="${f#$ROOT_DIR/}"
      echo "$rel" >> "$offenders_file"
    fi
  fi
done

if [[ -s "$offenders_file" ]]; then
  echo "ERROR: Found Compose templates using 'deploy: resources' (Swarm-only) which we avoid in non-Swarm Compose:" >&2
  sort -u "$offenders_file" >&2
  echo >&2
  cat <<'HINT' >&2
Guidance: Remove 'deploy: { resources: ... }' from Compose Jinja templates. Prefer host-level limits
or document desired constraints in defaults without adding unsupported Swarm fields to Compose.
HINT
  exit 1
fi

exit 0


