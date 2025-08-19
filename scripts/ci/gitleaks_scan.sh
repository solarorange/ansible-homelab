#!/usr/bin/env bash
set -euo pipefail

# Simple local secret scan using gitleaks. Fails (exit 1) on findings.
# Optional: export GITLEAKS_VERSION to pin a specific version (default below).

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "[gitleaks] Not found. Installing..." >&2
  if [[ "${OSTYPE:-}" == darwin* ]] && command -v brew >/dev/null 2>&1; then
    brew install gitleaks
  else
    tmpdir="$(mktemp -d)"
    version="${GITLEAKS_VERSION:-8.18.2}"
    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    arch_raw="$(uname -m)"
    arch="x64"
    if [[ "$arch_raw" == "arm64" || "$arch_raw" == "aarch64" ]]; then
      arch="arm64"
    fi
    filename="gitleaks_${version}_${os}_${arch}.tar.gz"
    url="https://github.com/gitleaks/gitleaks/releases/download/v${version}/${filename}"
    echo "[gitleaks] Downloading ${url}" >&2
    curl -sSL "$url" -o "$tmpdir/gitleaks.tgz"
    tar -xzf "$tmpdir/gitleaks.tgz" -C "$tmpdir" gitleaks
    echo "[gitleaks] Installing to /usr/local/bin (may prompt for sudo)" >&2
    install -m 0755 "$tmpdir/gitleaks" /usr/local/bin/gitleaks 2>/dev/null || sudo install -m 0755 "$tmpdir/gitleaks" /usr/local/bin/gitleaks
    rm -rf "$tmpdir"
  fi
fi

echo "[gitleaks] Version: $(gitleaks version || true)" >&2

# Scan the repository (git history by default). Redact secrets in output. Fail if findings.
if [[ -f .gitleaks.toml ]]; then
  exec gitleaks detect --config=.gitleaks.toml --source . --redact --exit-code 1
else
  exec gitleaks detect --source . --redact --exit-code 1
fi


