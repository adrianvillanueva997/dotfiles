autoload -Uz compinit
compinit
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit light romkatv/zsh-defer
zinit light "Aloxaf/fzf-tab"
zinit light "lukechilds/zsh-nvm"
# oh-my-zsh plugins
zinit load "ohmyzsh/ohmyzsh"
zinit snippet OMZP::git
zinit snippet OMZP::brew
zinit snippet OMZP::fzf
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::npm
zinit snippet OMZP::nvm
zinit snippet OMZP::pip
zinit snippet OMZP::golang
zinit snippet OMZP::node
zinit snippet OMZP::kubectl
zinit snippet OMZP::aws
zinit snippet OMZP::gcloud
zinit snippet OMZP::terraform
zinit snippet OMZP::aliases
zinit snippet OMZP::asdf
zinit snippet OMZP::python
zinit snippet OMZP::copyfile
zinit snippet OMZP::gitignore
zinit snippet OMZP::virtualenv
zinit snippet OMZP::git-auto-fetch
zinit snippet OMZP::flutter
zinit snippet OMZP::web-search
zinit snippet OMZP::vscode

# # External plugins
zsh-defer zinit light "mafredri/zsh-async"
zsh-defer zinit light "unixorn/fzf-zsh-plugin"
zsh-defer zinit light "zsh-users/zsh-autosuggestions"
zsh-defer zinit light "zdharma-continuum/fast-syntax-highlighting"
zsh-defer zinit light "zpm-zsh/clipboard"
zsh-defer zinit light "zpm-zsh/material-colors"
zsh-defer zinit light "MichaelAquilina/zsh-autoswitch-virtualenv"
zsh-defer zinit light "MichaelAquilina/zsh-you-should-use"
zinit load "paulmelnikow/zsh-startup-timer"
zsh-defer zinit light "RobertAudi/tsm"
zsh-defer zinit light "MenkeTechnologies/zsh-cargo-completion"
zsh-defer zinit light "lukechilds/zsh-better-npm-completion"
zsh-defer zinit light "spwhitt/nix-zsh-completions"
zsh-defer zinit light "wfxr/forgit"
zinit load "mroth/evalcache"


export TERM=xterm-256color

# Neovim aliases
alias vim="nvim"
alias vi="nvim"
# alias python="python3"
alias cat="ccat"
alias ls="lsd"

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
_evalcache zoxide init zsh

export PATH="$HOME/.poetry/bin:$PATH"
export SPARK_HOME="/opt/homebrew/Cellar/apache-spark/3.3.0/libexec/"
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/avm/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/avm/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

source <(kubectl completion zsh)
enable-fzf-tab

export PATH="/opt/homebrew/opt/libiconv/bin:$PATH"
