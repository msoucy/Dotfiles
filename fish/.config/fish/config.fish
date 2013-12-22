#!/usr/bin/fish

set fish_greeting ""

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'


set VIRTUALFISH_HOME "$HOME/.virtualenv"
set VIRTUALFISH_COMPAT_ALIASES 'yes'
. ~/.config/fish/virtualfish/virtual.fish
. ~/.config/fish/virtualfish/global_requirements.fish
complete -f -c workon -a "(vf ls)"

set -g LESS "-FR"

