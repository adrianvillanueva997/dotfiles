#!/bin/sh
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.tmux.conf
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.zshrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir .config/nvim
mv .vimrc ./config/nvim/init.vim
nvm install node
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
pacman -S yay zsh starship docker docker-compose go
chsh -s $(which zsh)
source .zshrc
