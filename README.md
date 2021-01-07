# My dotfiles

# Vim stuff
You need vim plug: 

`curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
    
Node for Coc, or just install nvm which is already configured in my .zshrc file

`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash` 

Add this to your :CocConfig in case you want to use ALE

`{"diagnostic.displayByAle": true}`

# Zsh
I use oh my zsh and powerline 10k, you need nerdfonts:

https://github.com/ryanoasis/nerd-fonts

# Tmux
Install tmux plugin manager, the theme is the one provided by oh my tmux

https://github.com/tmux-plugins/tpm

# Alacritty
It's almost the default config, just with a one dark pro theme
