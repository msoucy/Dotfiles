# .bashrc
# shellcheck shell=bash

test -f "${HOME}/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")"
test -f ~/.fzf.bash && source ~/.fzf.bash

: # Just so that the shell starts with a non-error code

# vim: et fdm=marker
