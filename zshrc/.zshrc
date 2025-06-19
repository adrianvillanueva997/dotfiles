# Load compinit for autocompletion
autoload -Uz compinit
compinit
#export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"
# Add Go binaries to PATH
# export PATH=$PATH:$(go env GOPATH)/bin

# Zinit installation and setup
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

# Zinit plugins
zi light zdharma-continuum/zinit-annex-rust
zinit load atuinsh/atuin
zinit light Aloxaf/fzf-tab
zinit load zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::brew
zinit snippet OMZP::argocd
zinit snippet OMZP::archlinux
zinit snippet OMZP::npm
zinit snippet OMZP::pip
zinit snippet OMZP::node
zinit snippet OMZP::kubectl
zinit snippet OMZP::aws
zinit snippet OMZP::gcloud
zinit snippet OMZP::terraform
zinit snippet OMZP::aliases
zinit snippet OMZP::python
zinit snippet OMZP::gitignore
zinit snippet OMZP::virtualenv
zinit snippet OMZP::git-auto-fetch
zinit snippet OMZP::web-search
zinit snippet OMZP::vscode

# External plugins
zinit light "MichaelAquilina/zsh-you-should-use"
zinit load "mroth/evalcache"
zinit load wfxr/forgit

# Exports
export EDITOR=nvim
export TERM=xterm-256color
export PATH=/opt/homebrew/bin:$PATH

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize other tools
_evalcache direnv hook zsh
_evalcache zoxide init zsh
_evalcache mise activate zsh
_evalcache atuin init zsh

# Aliases
alias vim="nvim"
alias vi="nvim"
alias cat="bat"
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

# Docker-compose aliases
alias dcu="docker-compose up -d"
alias dcub="docker-compose up -d --build"
alias dcs="docker-compose stop"
alias dcd="docker-compose down"
alias dcr="docker-compose restart"
alias dcl="docker-compose logs"
alias dex="docker exec -it"

# Docker aliases
alias dps="docker ps -a"
alias dsa="docker ps -q | awk '{print $1}' | xargs -o docker stop"
alias dcp="docker ps -q | awk '{print $1}' | xargs -o docker container prune"
alias dip="docker ps -q | awk '{print $1}' | xargs -o docker image prune -a"

# Function to set window title
set-window-title() {
  window_title="\e]0;${${PWD/#"$HOME"/~}/projects/p}\a"
  echo -ne "$window_title"
}
# Function to set the terminal window title to the current directory path
set-window-title() {
  # Replace home directory with ~ and remove /projects/p prefix
  window_title="\e]0;${${PWD/#"$HOME"/~}/projects/p}\a"
  echo -ne "$window_title"
}

# Initialize the title bar variable (if needed)
PR_TITLEBAR=''

# Set the window title initially
set-window-title

# Update the window title before each command prompt
add-zsh-hook precmd set-window-title

# pnpm setup
export PNPM_HOME="/home/avm/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export FORGIT_DIFF_PAGER='delta --side-by-side --line-numbers --navigate'
export FORGIT_LOG_FORMAT="%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"
export FORGIT_FZF_DEFAULT_OPTS='--height 90% --border --preview-window=right:70%'
export GIT_PAGER="delta --side-by-side --line-numbers --navigate"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
