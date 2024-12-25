# Define directories for each set of dotfiles
DOTFILES_DIR := $(PWD)
CONFIG_DIR := $(DOTFILES_DIR)/config
GIT_DIR := $(DOTFILES_DIR)/git
ZSH_DIR := $(DOTFILES_DIR)/zsh
TMUX_DIR := $(DOTFILES_DIR)/tmux
WEZTERM_DIR := $(DOTFILES_DIR)/wezterm

# Define the target directory for the symlinks
TARGET_DIR := $(HOME)

# The default target will stow everything
all: stow-config stow-git stow-zsh stow-tmux stow-wezterm

# Stow .config files
stow-config:
	stow --dir=$(CONFIG_DIR) --target=$(TARGET_DIR)/.config config

# Stow git dotfiles
stow-git:
	stow --dir=$(GIT_DIR) --target=$(TARGET_DIR) git

# Stow zsh dotfiles
stow-zsh:
	stow --dir=$(ZSH_DIR) --target=$(TARGET_DIR) zsh

# Stow tmux dotfiles
stow-tmux:
	stow --dir=$(TMUX_DIR) --target=$(TARGET_DIR) tmux

# Stow wezterm dotfiles
stow-wezterm:
	stow --dir=$(WEZTERM_DIR) --target=$(TARGET_DIR) wezterm

# Clean up symlinks (unstow)
clean:
	stow -D --dir=$(CONFIG_DIR) --target=$(TARGET_DIR)/.config config
	stow -D --dir=$(GIT_DIR) --target=$(TARGET_DIR) git
	stow -D --dir=$(ZSH_DIR) --target=$(TARGET_DIR) zsh
	stow -D --dir=$(TMUX_DIR) --target=$(TARGET_DIR) tmux
	stow -D --dir=$(WEZTERM_DIR) --target=$(TARGET_DIR) wezterm

