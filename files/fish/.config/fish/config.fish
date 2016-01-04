#!/usr/bin/fish

set fish_greeting ""

set VIRTUALFISH_HOME "$HOME/.virtualenv"
if python -c 'import virtualfish' > /dev/null 2>&1
	eval (python -m virtualfish compat_aliases auto_activation)
	complete -f -c workon -a "(vf ls)"
else
	echo "Virtualfish not found, will not be in prompt"
	echo "Install using 'pip install --user virtualfish'"
end

set -gx BROWSER "firefox"
set -gx PAGER "less"
set -gx LESS "-FR"
set -gx EDITOR "vim"
set -gx VIDIR_EDITOR_ARGS '-c :set nolist | :set ft=vidir-ls'
set -gx LD_LIBRARY_PATH /usr/local/lib
set -Ux fish_user_paths $HOME/bin $HOME/.cabal/bin $HOME/.local/bin $HOME/.fzf/bin
if test -f ~/.dircolors
	eval (dircolors -c ~/.dircolors)
end
abbr ll 'ls -lh'
abbr la 'ls -lah'
abbr gman 'man -k'
abbr :e $EDITOR
