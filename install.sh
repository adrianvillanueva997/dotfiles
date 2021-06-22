#!/bin/sh
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.tmux.conf
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.antigenrc
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.alacritty.yml
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.zshrc
wget https://raw.githubusercontent.com/adrianvillanueva997/Dotfiles/master/.vimrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -L git.io/antigen > antigen.zsh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir .config/nvim
mv .vimrc ./config/nvim/init.vim
nvm install node
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
pacman -S zsh starship docker docker-compose go
chsh -s $(which zsh)
source .zshrc
