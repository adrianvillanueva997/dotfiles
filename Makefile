# Dotfiles management using GNU Stow
DOTFILES := $(HOME)/proyectos/personal/dotfiles
BACKUP_DIR := $(HOME)/.dotfiles.bak
STOW_FLAGS := --verbose --target=$(HOME) --dir=$(DOTFILES) --adopt --no-folding

.PHONY: stow unstow restow backup restore help

# Default target
.DEFAULT_GOAL := stow

backup:
	@echo "Backing up existing dotfiles..."
	@mkdir -p $(BACKUP_DIR)
	@for file in $(HOME)/.* ; do \
		if [ -f "$$file" ] && [ "$$file" != "$(HOME)/." ] && [ "$$file" != "$(HOME)/.." ]; then \
			cp -rf "$$file" "$(BACKUP_DIR)/" 2>/dev/null || true ; \
		fi \
	done

restore:
	@echo "Restoring dotfiles from backup..."
	@cp -rf $(BACKUP_DIR)/.* $(HOME)/ 2>/dev/null || true

stow: backup
	@echo "Stowing dotfiles..."
	@stow $(STOW_FLAGS) */ || (echo "Error: Stow failed"; exit 1)

unstow:
	@echo "Removing dotfiles..."
	@stow --delete $(STOW_FLAGS) */ || (echo "Error: Unstow failed"; exit 1)

restow: unstow stow
	@echo "Restowing dotfiles completed"
