#!/usr/bin/env python3
import json
import tomllib
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
CONFIG_FILE = BASE_DIR / "config-generator.toml"

AGENT_ORDER = (
    "orchestrator",
    "oracle",
    "librarian",
    "explorer",
    "designer",
    "fixer",
    "council",
)

OPENCODE_AGENT_ORDER = (
    "build",
    "plan",
)

TMP_PERMISSION_PATHS = (
    "/tmp/**",
    "/private/tmp/**",
)

READ_ONLY_PERMISSION_PATHS = (
    "~/Downloads/**",
)


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def chrome_devtools_mcp():
    return {
        "type": "local",
        "command": ["npx", "-y", "chrome-devtools-mcp@latest"],
    }


def allow_paths(paths):
    return {path: "allow" for path in paths}


def agent_config(meta, skills, mcps, include_chrome=False):
    config = {"model": meta["model"]}

    if "variant" in meta:
        config["variant"] = meta["variant"]

    config["skills"] = skills
    config["mcps"] = mcps + (["chrome-devtools"] if include_chrome else [])
    return config


def build_opencode_config(enable_chrome, opencode_models):
    mcp = {}
    if enable_chrome:
        mcp["chrome-devtools"] = chrome_devtools_mcp()

    return {
        "plugin": ["oh-my-opencode-slim"],
        "$schema": "https://opencode.ai/config.json",
        "experimental": {
            "disable_paste_summary": True,
        },
        "lsp": False,
        "mcp": mcp,
        "tools": {
            "auto_continue": False,
        },
        "permission": {
            "bash": {
                "terraform * apply*": "deny",
                "terraform * init*": "allow",
                "terraform * fmt*": "allow",
                "terraform * plan*": "allow",
                "terraform * validate*": "allow",
            },
            "external_directory": allow_paths(
                TMP_PERMISSION_PATHS + READ_ONLY_PERMISSION_PATHS
            ),
            "read": allow_paths(TMP_PERMISSION_PATHS + READ_ONLY_PERMISSION_PATHS),
            "edit": allow_paths(TMP_PERMISSION_PATHS),
        },
        "provider": {
            "kimi-for-coding": {
                "name": "Kimi For Coding",
                "npm": "@ai-sdk/anthropic",
                "options": {
                    "baseURL": "https://api.kimi.com/coding/v1",
                },
                "models": {
                    "k2p5": {
                        "name": "Kimi K2.5",
                        "reasoning": True,
                        "attachment": False,
                        "limit": {
                            "context": 262144,
                            "output": 32768,
                        },
                        "modalities": {
                            "input": ["text", "image", "video"],
                            "output": ["text"],
                        },
                        "options": {
                            "interleaved": {
                                "field": "reasoning_content",
                            },
                        },
                    },
                },
            },
        },
        "agent": {
            "build": {
                "mode": "primary",
                "model": opencode_models["build"],
            },
            "plan": {
                "mode": "primary",
                "model": opencode_models["plan"],
            },
            "explore": {
                "disable": True,
            },
            "general": {
                "disable": True,
            },
        },
    }


def build_preset_config(agents, enable_chrome):
    return {
        "orchestrator": agent_config(
            agents["orchestrator"],
            skills=["*", "!worktrees"],
            mcps=["websearch"],
            include_chrome=enable_chrome,
        ),
        "oracle": agent_config(
            agents["oracle"],
            skills=[],
            mcps=[],
        ),
        "librarian": agent_config(
            agents["librarian"],
            skills=[],
            mcps=["websearch", "context7", "grep_app"],
        ),
        "explorer": agent_config(
            agents["explorer"],
            skills=[],
            mcps=[],
        ),
        "designer": agent_config(
            agents["designer"],
            skills=["agent-browser"],
            mcps=[],
            include_chrome=enable_chrome,
        ),
        "fixer": agent_config(
            agents["fixer"],
            skills=[],
            mcps=[],
            include_chrome=enable_chrome,
        ),
        "council": agent_config(
            agents["council"],
            skills=[],
            mcps=[],
        ),
    }


def build_plugin_config(active_preset, presets, council, enable_chrome):
    config = {
        "preset": active_preset,
        "todoContinuation": {
            "autoEnable": False,
            "maxContinuations": 1,
            "cooldownMs": 3000,
        },
        "presets": {
            name: build_preset_config(agents, enable_chrome)
            for name, agents in presets.items()
        },
    }

    if council:
        config["council"] = council

    return config


def build_agent_meta(models, variants):
    return {
        name: {
            "model": models[name],
            **({"variant": variants[name]} if name in variants else {}),
        }
        for name in AGENT_ORDER
    }


def merge_preset(base_preset, preset):
    models = dict(base_preset.get("models", {}))
    models.update(preset.get("models", {}))

    variants = dict(base_preset.get("variants", {}))
    variants.update(preset.get("variants", {}))
    return build_agent_meta(models, variants)


def load_meta():
    meta = tomllib.loads(CONFIG_FILE.read_text(encoding="utf-8"))
    presets = meta.get("presets", {})
    base_preset = presets.get("normal")

    if not base_preset:
        raise SystemExit("missing required preset: normal")

    base_models = base_preset.get("models", {})
    missing_agents = [name for name in AGENT_ORDER if name not in base_models]
    if missing_agents:
        raise SystemExit(f"missing normal preset model: {', '.join(missing_agents)}")

    opencode_models = meta.get("opencode", {}).get("models", {})
    missing_opencode_agents = [
        name for name in OPENCODE_AGENT_ORDER if name not in opencode_models
    ]
    if missing_opencode_agents:
        raise SystemExit(
            f"missing opencode model: {', '.join(missing_opencode_agents)}"
        )

    active_preset = meta.get("active_preset", "normal")
    if active_preset not in presets:
        raise SystemExit(f"active preset not found: {active_preset}")

    resolved_presets = {
        name: merge_preset(base_preset, preset)
        for name, preset in presets.items()
    }

    return meta, active_preset, resolved_presets, opencode_models, meta.get("council")


def main():
    meta, active_preset, presets, opencode_models, council = load_meta()
    enable_chrome = bool(meta.get("chrome_devtools_mcp", False))

    write_json(
        BASE_DIR / "opencode.jsonc",
        build_opencode_config(enable_chrome, opencode_models),
    )
    write_json(
        BASE_DIR / "oh-my-opencode-slim.jsonc",
        build_plugin_config(active_preset, presets, council, enable_chrome),
    )


if __name__ == "__main__":
    main()
