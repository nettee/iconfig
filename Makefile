ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

GHOSTTY_SRC := $(ROOT)/ghostty/config
GHOSTTY_DEST := $(HOME)/.config/ghostty/config

.PHONY: all ghostty

all: ghostty

ghostty:
	@mkdir -p "$(dir $(GHOSTTY_DEST))"
	@ln -sfn "$(GHOSTTY_SRC)" "$(GHOSTTY_DEST)"
	@echo "linked $(GHOSTTY_DEST) -> $(GHOSTTY_SRC)"
