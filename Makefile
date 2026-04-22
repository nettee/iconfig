ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

GHOSTTY_SRC := $(ROOT)/config/ghostty/config
GHOSTTY_DEST := $(HOME)/.config/ghostty/config
CMUX_SRC := $(ROOT)/config/cmux/settings.json
CMUX_DEST := $(HOME)/.config/cmux/settings.json
CODEX_AGENTS_SRC := $(ROOT)/config/codex/AGENTS.md
CODEX_AGENTS_DEST := $(HOME)/.codex/AGENTS.md
P10K_SRC := $(ROOT)/config/p10k.zsh
P10K_DEST := $(HOME)/.p10k.zsh
GITCONFIG_SRC := $(ROOT)/config/git/config
GITCONFIG_DEST := $(HOME)/.gitconfig
OPENCODE_CONFIG_SRC := $(ROOT)/config/opencode/opencode.jsonc
OPENCODE_CONFIG_DEST := $(HOME)/.config/opencode/opencode.jsonc
OPENCODE_TUI_SRC := $(ROOT)/config/opencode/tui.jsonc
OPENCODE_TUI_DEST := $(HOME)/.config/opencode/tui.jsonc
OPENCODE_PLUGIN_SRC := $(ROOT)/config/opencode/oh-my-opencode-slim.jsonc
OPENCODE_PLUGIN_DEST := $(HOME)/.config/opencode/oh-my-opencode-slim.jsonc
OPENCODE_PLUGIN_DIR_SRC := $(ROOT)/config/opencode/oh-my-opencode-slim
OPENCODE_PLUGIN_DIR_DEST := $(HOME)/.config/opencode/oh-my-opencode-slim
OPENCODE_LOCAL_PLUGINS_SRC := $(ROOT)/config/opencode/plugins
OPENCODE_LOCAL_PLUGINS_DEST := $(HOME)/.config/opencode/plugins

.PHONY: all ghostty cmux codex p10k gitconfig opencode

all: ghostty cmux codex p10k gitconfig opencode

ghostty:
	@mkdir -p "$(dir $(GHOSTTY_DEST))"
	@ln -sfn "$(GHOSTTY_SRC)" "$(GHOSTTY_DEST)"
	@echo "linked $(GHOSTTY_DEST) -> $(GHOSTTY_SRC)"

cmux:
	@mkdir -p "$(dir $(CMUX_DEST))"
	@ln -sfn "$(CMUX_SRC)" "$(CMUX_DEST)"
	@echo "linked $(CMUX_DEST) -> $(CMUX_SRC)"

codex:
	@mkdir -p "$(dir $(CODEX_AGENTS_DEST))"
	@ln -sfn "$(CODEX_AGENTS_SRC)" "$(CODEX_AGENTS_DEST)"
	@echo "linked $(CODEX_AGENTS_DEST) -> $(CODEX_AGENTS_SRC)"

p10k:
	@ln -sfn "$(P10K_SRC)" "$(P10K_DEST)"
	@echo "linked $(P10K_DEST) -> $(P10K_SRC)"

gitconfig:
	@ln -sfn "$(GITCONFIG_SRC)" "$(GITCONFIG_DEST)"
	@echo "linked $(GITCONFIG_DEST) -> $(GITCONFIG_SRC)"

opencode:
	@mkdir -p "$(dir $(OPENCODE_CONFIG_DEST))"
	@mkdir -p "$(OPENCODE_PLUGIN_DIR_DEST)"
	@mkdir -p "$(dir $(OPENCODE_LOCAL_PLUGINS_DEST))"
	@ln -sfn "$(OPENCODE_CONFIG_SRC)" "$(OPENCODE_CONFIG_DEST)"
	@echo "linked $(OPENCODE_CONFIG_DEST) -> $(OPENCODE_CONFIG_SRC)"
	@ln -sfn "$(OPENCODE_TUI_SRC)" "$(OPENCODE_TUI_DEST)"
	@echo "linked $(OPENCODE_TUI_DEST) -> $(OPENCODE_TUI_SRC)"
	@ln -sfn "$(OPENCODE_PLUGIN_SRC)" "$(OPENCODE_PLUGIN_DEST)"
	@echo "linked $(OPENCODE_PLUGIN_DEST) -> $(OPENCODE_PLUGIN_SRC)"
	@ln -sfn "$(OPENCODE_LOCAL_PLUGINS_SRC)" "$(OPENCODE_LOCAL_PLUGINS_DEST)"
	@echo "linked $(OPENCODE_LOCAL_PLUGINS_DEST) -> $(OPENCODE_LOCAL_PLUGINS_SRC)"
	@ln -sfn "$(OPENCODE_PLUGIN_DIR_SRC)/fixer_append.md" "$(OPENCODE_PLUGIN_DIR_DEST)/fixer_append.md"
	@echo "linked $(OPENCODE_PLUGIN_DIR_DEST)/fixer_append.md -> $(OPENCODE_PLUGIN_DIR_SRC)/fixer_append.md"
	@ln -sfn "$(OPENCODE_PLUGIN_DIR_SRC)/orchestrator_append.md" "$(OPENCODE_PLUGIN_DIR_DEST)/orchestrator_append.md"
	@echo "linked $(OPENCODE_PLUGIN_DIR_DEST)/orchestrator_append.md -> $(OPENCODE_PLUGIN_DIR_SRC)/orchestrator_append.md"
	@ln -sfn "$(OPENCODE_PLUGIN_DIR_SRC)/oracle_append.md" "$(OPENCODE_PLUGIN_DIR_DEST)/oracle_append.md"
	@echo "linked $(OPENCODE_PLUGIN_DIR_DEST)/oracle_append.md -> $(OPENCODE_PLUGIN_DIR_SRC)/oracle_append.md"
