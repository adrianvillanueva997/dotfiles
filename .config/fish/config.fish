. ~/.config/fish/theme.fish  
. ~/.config/fish/alias/git.fish
. ~/.config/fish/alias/cli.fish
. ~/.config/fish/alias/cargo.fish


if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
scheme set dracula
