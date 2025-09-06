#!/bin/bash
set -euo pipefail

# Portable fixer for tr character classes in scripts/seamless_setup.sh
# - Use temporary file and atomic move instead of sed -i (BSD/GNU differences)
# - Match by patterns rather than line numbers
# - Ensure '-' is treated literally inside character classes

script_path="scripts/seamless_setup.sh"

if [[ ! -f "${script_path}" ]]; then
  echo "ERROR: ${script_path} not found" >&2
  exit 1
fi

# Create secure temp file in same directory and preserve metadata
script_dir="$(dirname "${script_path}")"
script_base="$(basename "${script_path}")"
tmp_file=$(mktemp "${script_dir}/${script_base}.tmp.XXXXXX")
cp -p "${script_path}" "${tmp_file}"
# Ensure temp cleanup on exit/error
trap 'rm -f "${tmp_file}"' EXIT

changed=0

# 1) In full complexity set, move '-' to the end: 'A-Za-z0-9!@%_+=-.' -> 'A-Za-z0-9!@%_+=.-'
# Handle both single and double quotes using backreferences
tmp_new=$(mktemp "${script_dir}/${script_base}.new.XXXXXX")
sed "s/\(['\"]\)A-Za-z0-9!@%_+=-\.\1/\1A-Za-z0-9!@%_+=.-\1/g" "${tmp_file}" > "${tmp_new}"
if ! cmp -s "${tmp_new}" "${tmp_file}"; then
  mv "${tmp_new}" "${tmp_file}"
  echo "Updated: moved '-' to end in full complexity character class"
  changed=1
else
  rm -f "${tmp_new}"
fi

# 2) Fix alnum class ordering if hyphen is before underscore: 'a-zA-Z0-9-_' -> 'a-zA-Z0-9_-'
# Handle both single and double quotes using backreferences
tmp_new=$(mktemp "${script_dir}/${script_base}.new.XXXXXX")
sed "s/\(['\"]\)a-zA-Z0-9-_\\1/\1a-zA-Z0-9_-\1/g" "${tmp_file}" > "${tmp_new}"
if ! cmp -s "${tmp_new}" "${tmp_file}"; then
  mv "${tmp_new}" "${tmp_file}"
  echo "Updated: reordered '-' to end in alphanumeric class"
  changed=1
else
  rm -f "${tmp_new}"
fi

# Removed unsafe generic fallback that could corrupt valid ranges

if [[ ${changed} -eq 0 ]]; then
  echo "No changes were necessary."
  rm -f "${tmp_file}"
  trap - EXIT
  exit 0
fi

mv "${tmp_file}" "${script_path}"
trap - EXIT
echo "All fixes applied successfully to ${script_path}."
