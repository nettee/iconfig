#!/usr/bin/env python3
import tomllib
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
CONFIG_FILE = BASE_DIR / "prompt-generator.toml"
SEPARATOR = "\n\n---\n\n"


def fail(message):
    raise SystemExit(message)


def resolve_inside_base(path_text):
    path = (BASE_DIR / path_text).resolve()
    try:
        path.relative_to(BASE_DIR.parent)
    except ValueError:
        fail(f"path escapes config directory: {path_text}")
    return path


def read_part(name, path_text):
    path = resolve_inside_base(path_text)
    if not path.is_file():
        fail(f"missing prompt part {name}: {path}")

    content = path.read_text(encoding="utf-8").strip()
    if not content:
        fail(f"empty prompt part {name}: {path}")
    if not content.startswith("## "):
        fail(f"prompt part must start with H2 heading: {name} ({path})")
    return content


def render_target(target, parts, disabled_parts):
    target_parts = target.get("parts")
    if not isinstance(target_parts, list) or not target_parts:
        fail(f"target parts must be a non-empty list: {target.get('path')}")

    rendered_parts = []
    for part_name in target_parts:
        if part_name in disabled_parts:
            continue
        if part_name not in parts:
            fail(f"unknown prompt part in target {target.get('path')}: {part_name}")
        rendered_parts.append(parts[part_name])

    if not rendered_parts:
        fail(f"target has no enabled prompt parts: {target.get('path')}")

    return SEPARATOR.join(rendered_parts) + "\n"


def load_config():
    if not CONFIG_FILE.is_file():
        fail(f"missing config file: {CONFIG_FILE}")

    config = tomllib.loads(CONFIG_FILE.read_text(encoding="utf-8"))
    features = config.get("features", {})
    part_paths = config.get("parts", {})
    targets = config.get("targets", [])

    if features is None:
        features = {}
    if not isinstance(features, dict):
        fail("[features] config must be a table")
    if not isinstance(part_paths, dict) or not part_paths:
        fail("missing [parts] config")
    if not isinstance(targets, list) or not targets:
        fail("missing [[targets]] config")

    parts = {
        name: read_part(name, path_text)
        for name, path_text in part_paths.items()
    }
    disabled_parts = {
        name
        for name, enabled in features.items()
        if enabled is False
    }
    unknown_features = sorted(disabled_parts - parts.keys())
    if unknown_features:
        fail(f"unknown feature prompt part: {', '.join(unknown_features)}")

    return parts, targets, disabled_parts


def main():
    parts, targets, disabled_parts = load_config()

    for target in targets:
        path_text = target.get("path")
        if not path_text:
            fail("target missing path")

        path = resolve_inside_base(path_text)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(render_target(target, parts, disabled_parts), encoding="utf-8")


if __name__ == "__main__":
    main()
