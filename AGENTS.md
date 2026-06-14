# AGENTS

## 当前维护范围

这个仓库当前主要维护以下配置：

- `zsh/`
- `config/git/config`
- `config/opencode/`
- `config/p10k.zsh`
- `config/ghostty/config`
- `config/cmux/settings.json`
- `config/looper/config.toml`
- `config/codex/AGENTS.md`

其他历史配置统一收敛到仓库根目录下的 `deprecated/`，一律视为 **deprecated**：

- 可以保留作参考
- 默认不继续扩展新能力
- 如需继续使用，优先考虑迁移到上述五类配置的管理方式

当前 `deprecated/` 下主要存放这类历史配置，例如：

- 旧版 shell / editor 配置
- 旧版 bookmarks / hosts / 输入法词库等资料
- 旧版 IDE / VS Code / Chrome 相关备份

## 管理思路

### ghostty

- 仓库内文件：`config/ghostty/config`
- 目标位置：`~/.config/ghostty/config`
- 管理方式：通过 `make ghostty` 创建软链接

### cmux

- 仓库内文件：`config/cmux/settings.json`
- 目标位置：`~/.config/cmux/settings.json`
- 管理方式：通过 `make cmux` 创建软链接

### looper

- 仓库内文件：`config/looper/config.toml`
- 目标位置：`~/.looper/config.toml`
- 管理方式：通过 `make looper` 创建软链接

### codex

- 仓库内文件：`config/codex/AGENTS.md`
- 目标位置：`~/.codex/AGENTS.md`
- 管理方式：通过 `make codex` 创建软链接

### p10k

- 仓库内文件：`config/p10k.zsh`
- 目标位置：`~/.p10k.zsh`
- 管理方式：通过 `make p10k` 创建软链接

### opencode

- 仓库内文件：
- `config/opencode/opencode.jsonc`
- `config/opencode/tui.jsonc`
- `config/opencode/oh-my-opencode-slim.jsonc`
- `config/opencode/plugins/notification.js`
- `config/opencode/oh-my-opencode-slim/fixer_append.md`
- `config/opencode/oh-my-opencode-slim/orchestrator_append.md`
- `config/opencode/oh-my-opencode-slim/oracle_append.md`
- 目标位置：
- `~/.config/opencode/opencode.jsonc`
- `~/.config/opencode/tui.jsonc`
- `~/.config/opencode/oh-my-opencode-slim.jsonc`
- `~/.config/opencode/plugins/notification.js`
- `~/.config/opencode/oh-my-opencode-slim/fixer_append.md`
- `~/.config/opencode/oh-my-opencode-slim/orchestrator_append.md`
- `~/.config/opencode/oh-my-opencode-slim/oracle_append.md`
- 管理方式：通过 `make opencode` 创建软链接

#### 生成器约定

- `config/opencode/opencode.jsonc` 和 `config/opencode/oh-my-opencode-slim.jsonc` 是由 `config/opencode/config-generator.py` 根据 `config/opencode/config-generator.toml` 生成的文件。
  - 修改 active preset、模型映射、agent variant、Chrome DevTools MCP 开关、OpenCode 内置 build/plan agent、OMO Slim agent preset、Council 配置、或 `opencode.jsonc` 中由 generator 固化的稳定结构（例如 provider、permission、mcp、agent）时，必须改 generator 或 TOML，再运行 `make opencode` / `make opencode-generate`。
  - 不要只手改这两个生成文件；如果 `make opencode` 后出现 diff，优先检查是否漏改了 generator / TOML。
- `config/codex/AGENTS.md`、`config/opencode/oh-my-opencode-slim/orchestrator_append.md`、`config/opencode/oh-my-opencode-slim/oracle_append.md`、`config/opencode/oh-my-opencode-slim/fixer_append.md` 是由 `config/prompt/prompt-generator.py` 根据 `config/prompt/prompt-generator.toml` 和 `config/prompt/parts/*.md` 生成的文件。
  - 修改公共提示词片段、Let It Crash / Fast Fail、命令偏好、worktree-kit 规则、Codex subagent 规则、或这些目标文件的片段组合/启停时，必须改 `config/prompt/parts/*.md` 或 `prompt-generator.toml`，再运行 `make opencode` / `make codex` / `make prompt`。
  - 不要只手改这些生成目标；生成目标的内容应由 `parts` 和 TOML 维护。
- 手工维护的 opencode 文件包括：`config/opencode/tui.jsonc`、`config/opencode/plugins/notification.js`。这些不走 generator。

### gitconfig

- 仓库内文件：`config/git/config`
- 目标位置：`~/.gitconfig`
- 管理方式：通过 `make gitconfig` 创建软链接

### zsh

- 仓库内目录：`zsh/`
- 约定：把可复用的 zsh 配置拆成多个 `*.zsh` 文件
- `zsh/__all__.zsh` 负责自动加载同目录下其他 `*.zsh` 文件
- 新增 zsh 配置时，优先放入 `zsh/`，避免继续堆到单个大文件里

## 推荐原则

1. 当前活跃配置优先使用“仓库内保存 + 家目录软链接”的方式管理。
2. 目录约定：`zsh` 保持独立目录；其他活跃配置统一收敛到 `config/` 下。
3. 对 deprecated 配置，除非明确要求，否则不要继续加功能。
4. 新发现的历史遗留配置，默认继续收敛到 `deprecated/` 下，而不是散落在仓库根目录。

## 使用方式

- `make ghostty`
- `make cmux`
- `make looper`
- `make codex`
- `make p10k`
- `make gitconfig`
- `make opencode`
- `make`：一次处理当前 Makefile 中维护的全部活跃配置
