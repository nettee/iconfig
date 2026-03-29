ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

GHOSTTY_SRC := $(ROOT)/ghostty/config
GHOSTTY_DEST := $(HOME)/.config/ghostty/config
P10K_SRC := $(ROOT)/p10k.zsh
P10K_DEST := $(HOME)/.p10k.zsh

.PHONY: all ghostty p10k

all: ghostty p10k

ghostty:
	@mkdir -p "$(dir $(GHOSTTY_DEST))"
	@ln -sfn "$(GHOSTTY_SRC)" "$(GHOSTTY_DEST)"
	@echo "linked $(GHOSTTY_DEST) -> $(GHOSTTY_SRC)"

p10k:
	@ln -sfn "$(P10K_SRC)" "$(P10K_DEST)"
	@echo "linked $(P10K_DEST) -> $(P10K_SRC)"
