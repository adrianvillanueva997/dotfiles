# Define directories for each set of dotfiles
DOTFILES_DIR := $(PWD)
CONFIG_DIR := $(DOTFILES_DIR)/config
GIT_DIR := $(DOTFILES_DIR)/git
ZSH_DIR := $(DOTFILES_DIR)/zsh
TMUX_DIR := $(DOTFILES_DIR)/tmux

# Define the target directory for the symlinks
TARGET_DIR := $(HOME)
FONTS_TARGET := $(TARGET_DIR)/.local/share/fonts

.PHONY: all clean stow-config stow-git stow-zsh stow-tmux stow-fonts

# The default target will stow everything
all: stow-config stow-git stow-zsh stow-tmux stow-fonts

# Stow config files
stow-config:
    stow --dir=$(CONFIG_DIR)/bat --target=$(TARGET_DIR)/.config bat
    stow --dir=$(CONFIG_DIR)/direnv --target=$(TARGET_DIR)/.config direnv
    stow --dir=$(CONFIG_DIR)/nvim --target=$(TARGET_DIR)/.config nvim
    stow --dir=$(CONFIG_DIR)/starship --target=$(TARGET_DIR)/.config starship

# Stow git dotfiles
stow-git:
    ln -sf $(GIT_DIR)/.gitconfig $(TARGET_DIR)/.gitconfig

# Stow zsh dotfiles
stow-zsh:
    stow --dir=$(ZSH_DIR) --target=$(TARGET_DIR) zsh

# Stow tmux dotfiles
stow-tmux:
    stow --dir=$(TMUX_DIR) --target=$(TARGET_DIR) tmux

# Stow fonts
stow-fonts: $(FONTS_TARGET)
    stow --dir=$(FONTS_DIR) --target=$(FONTS_TARGET) fonts

$(FONTS_TARGET):
    mkdir -p $(FONTS_TARGET)

# Clean up symlinks (unstow)
clean:
    stow -D --dir=$(CONFIG_DIR)/bat --target=$(TARGET_DIR)/.config bat
    stow -D --dir=$(CONFIG_DIR)/direnv --target=$(TARGET_DIR)/.config direnv
    stow -D --dir=$(CONFIG_DIR)/nvim --target=$(TARGET_DIR)/.config nvim
    stow -D --dir=$(CONFIG_DIR)/starship --target=$(TARGET_DIR)/.config starship
    rm -f $(TARGET_DIR)/.gitconfig
    stow -D --dir=$(ZSH_DIR) --target=$(TARGET_DIR) zsh
    stow -D --dir=$(TMUX_DIR) --target=$(TARGET_DIR) tmux
    stow -D --dir=$(FONTS_DIR) --target=$(FONTS_TARGET) fonts
