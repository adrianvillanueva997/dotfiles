. ~/.config/fish/theme.fish
. ~/.config/fish/alias/git.fish
. ~/.config/fish/alias/cli.fish
. ~/.config/fish/alias/cargo.fish
set fish_greeting ""

export TERMINFO=/usr/share/terminfo
set -x GOPATH /users/avm/go
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin
# source $HOME/.asdf/asdf.fish

alias python="python3"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source
scheme set dracula
# status is-login; and pyenv init --path | source
# status is-interactive; and pyenv init - | source


source /opt/homebrew/opt/asdf/libexec/asdf.fish
