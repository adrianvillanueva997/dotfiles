#antigen
source "$HOME/.antigen.zsh"
antigen init "$HOME/.antigenrc"
#tmux
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export TERM=xterm-256color

# Neovim aliases
alias vim="nvim"
alias vi="nvim"
alias python="python3"
alias dash-mfa="bash /home/avm/repos/mfa-credentials/get_session_token.sh"
alias kubectl="kubecolor"
alias cat="ccat"
# Go path stuff
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh
 export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# User configuration

# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(starship init zsh)"

export PATH="$HOME/.poetry/bin:$PATH"
