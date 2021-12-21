#antigen
eval "$(pyenv init --path)"
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

export TERM=xterm-256color

# Neovim aliases
alias vim="nvim"
alias vi="nvim"
# alias python="python3"
alias dash-mfa="bash /home/avm/repos/tools/mfa-credentials/get_session_token.sh"
alias kubectl="kubecolor"
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

alias dps="docker ps"
alias dsa="docker ps -q | awk '{print $1}' | xargs -o docker stop"
alias dcp="docker ps -q | awk '{print $1}' | xargs -o docker container prune"
alias dip="docker ps -q | awk '{print $1}' | xargs -o docker image prune -a"


# Go path stuff
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# ZSH_THEME="powerlevel10k/powerlevel10k"
 export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# User configuration

eval "$(starship init zsh)"

export PATH="$HOME/.poetry/bin:$PATH"
export SSH_PRV_KEY="$(cat ~/.ssh/id_ed25519)"
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS
