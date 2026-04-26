# OpenCode Config Generator

`config-generator.py` generates the OpenCode files that change often from a small TOML meta config.

Generated files:

- `opencode.jsonc`
- `oh-my-opencode-slim.jsonc`

Manually maintained files:

- `tui.jsonc`
- `plugins/notification.js`
- `oh-my-opencode-slim/fixer_append.md`
- `oh-my-opencode-slim/oracle_append.md`
- `oh-my-opencode-slim/orchestrator_append.md`

## Meta Config

Edit `config-generator.toml` to switch the frequently changed options:

```toml
active_preset = "default"
chrome_devtools_mcp = false

[opencode.models]
build = "openai/gpt-5.5"
plan = "openai/gpt-5.5-fast"

[presets.default.models]
orchestrator = "openai/gpt-5.5"
oracle = "openai/gpt-5.5"
designer = "openai/gpt-5.4"
fixer = "openai/gpt-5.4"
explorer = "xai/grok-4-1-fast-non-reasoning"
librarian = "xai/grok-4-1-fast"

[presets.default.variants]
oracle = "high"
designer = "high"
fixer = "low"

[presets.fast.models]
orchestrator = "openai/gpt-5.5-fast"
oracle = "openai/gpt-5.5-fast"
designer = "openai/gpt-5.5-fast"
fixer = "openai/gpt-5.5-fast"
explorer = "xai/grok-4-1-fast-non-reasoning"
librarian = "xai/grok-4-1-fast"

[presets.fast.variants]
oracle = "medium"
designer = "medium"
fixer = "low"
```

Supported fields:

- `active_preset`: selects the generated `preset` in `oh-my-opencode-slim.jsonc`.
- `chrome_devtools_mcp`: enables or disables the `chrome-devtools` MCP in both generated files.
- `[opencode.models]`: OpenCode built-in Plan/Build agent model names generated into `opencode.jsonc`.
- `[presets.default.models]`: baseline model names. This preset must define every agent.
- `[presets.<name>.models]`: model overrides for a preset.
- `[presets.<name>.variants]`: optional variant overrides for a preset.

Current agents:

OpenCode built-in primary agents:

- `build`
- `plan`

OMO Slim agents:

- `orchestrator`
- `oracle`
- `librarian`
- `explorer`
- `designer`
- `fixer`

`default` is the baseline preset. Other presets inherit from `default`, so they only need to list the values they change.

`fast` switches the GPT agents to `openai/gpt-5.5-fast`. OpenCode exposes this as `GPT-5.5 Fast`; internally it uses the `gpt-5.5` API model with priority service tier.

## Workflow

Run the generator directly when you only want to refresh generated files:

```sh
python3 config/opencode/config-generator.py
```

Run the normal install target to generate first and then refresh symlinks:

```sh
make opencode
```

`make opencode` runs the generator before linking files into `~/.config/opencode`.

To switch the generated default preset, update `active_preset` and rerun `make opencode`.

To override the preset only for one OpenCode launch, use OMO Slim's environment variable:

```sh
OH_MY_OPENCODE_SLIM_PRESET=fast opencode
```

## Design

The generator keeps the stable OpenCode structure in Python and moves only the frequently switched values into TOML. This keeps preset switching small and explicit while preserving the existing symlink-based management flow.
