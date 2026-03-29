# AGENTS

## 当前维护范围

这个仓库当前主要维护以下配置：

- `zsh/`
- `config/opencode/`
- `config/p10k.zsh`
- `config/ghostty/config`

其他历史配置一律视为 **deprecated**：

- 可以保留作参考
- 默认不继续扩展新能力
- 如需继续使用，优先考虑迁移到上述四类配置的管理方式

## 管理思路

### ghostty

- 仓库内文件：`config/ghostty/config`
- 目标位置：`~/.config/ghostty/config`
- 管理方式：通过 `make ghostty` 创建软链接

### p10k

- 仓库内文件：`config/p10k.zsh`
- 目标位置：`~/.p10k.zsh`
- 管理方式：通过 `make p10k` 创建软链接

### opencode

- 仓库内文件：
  - `config/opencode/opencode.jsonc`
  - `config/opencode/oh-my-opencode-slim.jsonc`
- 目标位置：
  - `~/.config/opencode/opencode.jsonc`
  - `~/.config/opencode/oh-my-opencode-slim.jsonc`
- 管理方式：通过 `make opencode` 创建软链接

### zsh

- 仓库内目录：`zsh/`
- 约定：把可复用的 zsh 配置拆成多个 `*.zsh` 文件
- `zsh/__all__.zsh` 负责自动加载同目录下其他 `*.zsh` 文件
- 新增 zsh 配置时，优先放入 `zsh/`，避免继续堆到单个大文件里

## 推荐原则

1. 当前活跃配置优先使用“仓库内保存 + 家目录软链接”的方式管理。
2. 目录约定：`zsh` 保持独立目录；其他活跃配置统一收敛到 `config/` 下。
3. 对 deprecated 配置，除非明确要求，否则不要继续加功能。

## 使用方式

- `make ghostty`
- `make p10k`
- `make opencode`
- `make`：一次处理当前 Makefile 中维护的全部活跃配置
