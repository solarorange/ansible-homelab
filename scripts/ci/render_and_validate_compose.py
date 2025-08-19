#!/usr/bin/env python3
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, Any

import yaml
from jinja2 import Environment, FileSystemLoader, StrictUndefined, Undefined


REPO_ROOT = Path(__file__).resolve().parents[2]
TEMPLATE_GLOBS = [
    "templates/**/docker-compose.yml.j2",
    "roles/**/templates/docker-compose.yml.j2",
]


def find_templates(repo_root: Path) -> list[Path]:
    templates: list[Path] = []
    for pattern in TEMPLATE_GLOBS:
        templates.extend(repo_root.glob(pattern))
    return sorted(set(templates))


def load_yaml(path: Path) -> Dict[str, Any]:
    try:
        with path.open("r", encoding="utf-8") as f:
            return yaml.safe_load(f) or {}
    except FileNotFoundError:
        return {}


def deep_merge(a: Dict[str, Any], b: Dict[str, Any]) -> Dict[str, Any]:
    result = dict(a)
    for k, v in (b or {}).items():
        if k in result and isinstance(result[k], dict) and isinstance(v, dict):
            result[k] = deep_merge(result[k], v)
        else:
            result[k] = v
    return result


def collect_sample_vars(repo_root: Path) -> Dict[str, Any]:
    # Base globals
    sample: Dict[str, Any] = {
        "domain": "example.local",
        "timezone": "UTC",
        "docker_dir": "/opt/homelab/docker",
        "docker_data_root": "/opt/homelab/data",
        "logs_dir": "/opt/homelab/logs",
        "puid": 1000,
        "pgid": 1000,
        "PUID": 1000,
        "PGID": 1000,
        "user_id": 1000,
        "group_id": 1000,
        "data_dir": "/opt/homelab/data",
        "watchtower_schedule": "0 0 * * *",
        "ansible_default_ipv4": {"address": "127.0.0.1"},
        # Common flags used in templates to avoid secret mounts during CI
        "grafana_manage_secret_files": False,
        "immich_manage_secret_files": False,
        "vaultwarden_manage_secret_files": False,
    }

    # Merge in group vars
    group_vars_all = repo_root / "group_vars" / "all"
    if group_vars_all.is_dir():
        for yml in sorted(group_vars_all.glob("*.yml")):
            if "vault" in yml.name:
                # Never load vault in CI
                continue
            sample = deep_merge(sample, load_yaml(yml))

    return sample


def collect_role_defaults(template_path: Path) -> Dict[str, Any]:
    # Try to infer role directory and defaults/main.yml if template is under roles/*/templates
    parts = template_path.parts
    try:
        idx = parts.index("roles")
        role_dir = Path(*parts[: idx + 2])  # roles/<role>
        defaults = role_dir / "defaults" / "main.yml"
        return load_yaml(defaults)
    except ValueError:
        # Not under roles
        return {}


class PlaceholderUndefined(Undefined):
    """Jinja2 Undefined that renders to a safe placeholder for YAML/Compose validation."""

    def _as_str(self) -> str:
        # Compose generally accepts strings for most fields during 'config' validation
        return "PLACEHOLDER"

    def __str__(self) -> str:  # type: ignore[override]
        return self._as_str()

    def __iter__(self):  # type: ignore[override]
        # Allow iteration without crashing
        return iter(())

    def __bool__(self) -> bool:  # type: ignore[override]
        return False


def create_jinja_env(repo_root: Path) -> Environment:
    loader = FileSystemLoader(str(repo_root))
    env = Environment(loader=loader, undefined=PlaceholderUndefined, trim_blocks=True, lstrip_blocks=True)

    # Provide a minimal 'match' test used in some templates
    def jinja_test_match(value: str, pattern: str) -> bool:
        try:
            return re.search(pattern, str(value)) is not None
        except re.error:
            return False

    env.tests["match"] = jinja_test_match
    return env


def render_template(env: Environment, template_path: Path, variables: Dict[str, Any]) -> str:
    rel_path = template_path.relative_to(REPO_ROOT)
    template = env.get_template(str(rel_path))
    return template.render(**variables)


def run_compose_config(rendered_content: str, label: str) -> None:
    tmp_dir = Path(os.getenv("RUNNER_TEMP", "/tmp"))
    tmp_file = tmp_dir / f"compose_{label}.yml"
    tmp_file.write_text(rendered_content, encoding="utf-8")

    cmd = ["docker", "compose", "-f", str(tmp_file), "config"]
    try:
        subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print(f"OK: {label}")
        return
    except subprocess.CalledProcessError as e:
        stderr = e.stderr or ""
        # Fallback to docker-compose if Compose v2 subcommand is unavailable
        if "compose is not a docker command" in stderr.lower() or "unknown command \"compose\"" in stderr.lower():
            fallback_cmd = ["docker-compose", "-f", str(tmp_file), "config"]
            subprocess.run(fallback_cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            print(f"OK (docker-compose): {label}")
            return
        sys.stderr.write(f"ERROR: docker compose config failed for {label}\n")
        sys.stderr.write(stderr)
        raise
    except FileNotFoundError:
        # Docker not found on the runner
        raise RuntimeError("Docker is not available on the runner; cannot validate docker-compose files.")


def main() -> int:
    repo_root = REPO_ROOT
    env = create_jinja_env(repo_root)
    base_vars = collect_sample_vars(repo_root)

    failures = 0
    templates = find_templates(repo_root)
    if not templates:
        print("No docker-compose.yml.j2 templates found")
        return 0

    # Add placeholder values for any 'vault_*' tokens found in templates to avoid undefineds
    vault_keys: set[str] = set()
    for t in templates:
        try:
            content = t.read_text(encoding="utf-8")
        except Exception:
            continue
        for m in re.findall(r"vault_[A-Za-z0-9_]+", content):
            vault_keys.add(m)
    for k in vault_keys:
        base_vars.setdefault(k, "PLACEHOLDER_SECRET")

    for tpath in templates:
        role_defaults = collect_role_defaults(tpath)
        variables = deep_merge(base_vars, role_defaults)

        label = tpath.relative_to(repo_root).as_posix().replace("/", "_")
        try:
            rendered = render_template(env, tpath, variables)
            run_compose_config(rendered, label)
        except Exception as exc:
            failures += 1
            sys.stderr.write(f"Failed to validate {tpath}: {exc}\n")

    if failures:
        sys.stderr.write(f"Validation failures: {failures}\n")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())


