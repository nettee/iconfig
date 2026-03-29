ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

GHOSTTY_SRC := $(ROOT)/config/ghostty/config
GHOSTTY_DEST := $(HOME)/.config/ghostty/config
P10K_SRC := $(ROOT)/config/p10k.zsh
P10K_DEST := $(HOME)/.p10k.zsh
OPENCODE_CONFIG_SRC := $(ROOT)/config/opencode/opencode.jsonc
OPENCODE_CONFIG_DEST := $(HOME)/.config/opencode/opencode.jsonc
OPENCODE_PLUGIN_SRC := $(ROOT)/config/opencode/oh-my-opencode-slim.jsonc
OPENCODE_PLUGIN_DEST := $(HOME)/.config/opencode/oh-my-opencode-slim.jsonc

.PHONY: all ghostty p10k opencode

all: ghostty p10k opencode

ghostty:
	@mkdir -p "$(dir $(GHOSTTY_DEST))"
	@ln -sfn "$(GHOSTTY_SRC)" "$(GHOSTTY_DEST)"
	@echo "linked $(GHOSTTY_DEST) -> $(GHOSTTY_SRC)"

p10k:
	@ln -sfn "$(P10K_SRC)" "$(P10K_DEST)"
	@echo "linked $(P10K_DEST) -> $(P10K_SRC)"

opencode:
	@mkdir -p "$(dir $(OPENCODE_CONFIG_DEST))"
	@ln -sfn "$(OPENCODE_CONFIG_SRC)" "$(OPENCODE_CONFIG_DEST)"
	@echo "linked $(OPENCODE_CONFIG_DEST) -> $(OPENCODE_CONFIG_SRC)"
	@ln -sfn "$(OPENCODE_PLUGIN_SRC)" "$(OPENCODE_PLUGIN_DEST)"
	@echo "linked $(OPENCODE_PLUGIN_DEST) -> $(OPENCODE_PLUGIN_SRC)"
