#zplug 
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/b4b4r07/zplug ~/.zplug
fi
source ~/.zplug/init.zsh
# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "Aloxaf/fzf-tab"
# oh-my-zsh plugins
zplug "ohmyzsh/ohmyzsh"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/brew",   from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/golang", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/gcloud", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "plugins/aliases", from:oh-my-zsh
# zplug "plugins/asdf", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/copyfile", from:oh-my-zsh
zplug "plugins/gitignore", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/git-auto-fetch", from:oh-my-zsh

# External plugins
zplug "unixorn/fzf-zsh-plugin"
zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "zpm-zsh/clipboard"
zplug "zpm-zsh/material-colors"
zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
zplug "MichaelAquilina/zsh-you-should-use"
zplug "TamCore/autoupdate-oh-my-zsh-plugins"
zplug "paulmelnikow/zsh-startup-timer"
zplug "mbenford/zsh-tmux-auto-title"
zplug "RobertAudi/tsm"
zplug "MenkeTechnologies/zsh-cargo-completion"
zplug "lukechilds/zsh-better-npm-completion"
zplug "redxtech/zsh-kitty"
zplug "spwhitt/nix-zsh-completions"
zplug "wfxr/forgit"
zplug "mroth/evalcache"
zplug "spwhitt/nix-zsh-completions"
zplug "zpm-zsh/ls"
zplug "cowboyd/zsh-rust"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

eval "$(pyenv init --path)"
# source <(antibody init)
# antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
export TERM=xterm-256color

# Neovim aliases
alias vim="nvim"
alias vi="nvim"
# alias python="python3"
alias cat="ccat"

# Cargo aliases
alias co=cargo
alias cr='cargo run'
alias cl='cargo clean'
alias ccy='cargo clippy'
alias cb='cargo build --release'
alias ct='cargo test'
alias ca='cargo add'
alias ci='cargo install'
alias cfi='cargo fix'
alias cf='cargo fmt'
alias cfe='cargo fetch'
alias cpa='cargo package'
alias cs='cargo search'

# docker-compose aliases
alias dcu="docker-compose up -d"
alias dcub="docker-compose up -d --build"
alias dcs="docker-compose stop"
alias dcd="docker-compose down"
alias dcr="docker-compose restart"
alias dcl="docker-compose logs"
alias dex="docker exec -it"

alias dps="docker ps -a"
alias dsa="docker ps -q | awk '{print $1}' | xargs -o docker stop"
alias dcp="docker ps -q | awk '{print $1}' | xargs -o docker container prune"
alias dip="docker ps -q | awk '{print $1}' | xargs -o docker image prune -a"

# Go path stuff
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

 export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# User configuration

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export PATH="$HOME/.poetry/bin:$PATH"
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/avm/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/avm/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/avm/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/avm/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Nix
 if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
 fi
 # End Nix
enable-fzf-tab
