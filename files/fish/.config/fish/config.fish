#!/usr/bin/fish

set fisher_home ~/Code/fisherman
set fisher_config ~/.config/fisherman
if test -f $fisher_home/config.fish
	source $fisher_home/config.fish
end

set fish_greeting ""

set VIRTUALFISH_HOME "$HOME/.virtualenv"
if python3 -c 'import virtualfish' > /dev/null 2>&1
	eval (python3 -m virtualfish compat_aliases auto_activation)
	complete -f -c workon -a "(vf ls)"
else
	echo "Virtualfish not found, will not be in prompt"
	echo "Install using 'pip install --user virtualfish'"
end

set -gx BROWSER "firefox"
set -gx PAGER "less"
set -gx LESS "-FR"
if command -v nvim >/dev/null ^&1
	set -gx EDITOR "nvim"
else
	set -gx EDITOR "vim"
end
set -gx VIDIR_EDITOR_ARGS '-c :set nolist | :set ft=vidir-ls'
set -gx LD_LIBRARY_PATH /usr/local/lib
set -x extra_paths ~/bin ~/.cabal/bin ~/.local/bin ~/.fzf/bin /usr/sbin ~/Code/esp/xtensa-esp32-elf/bin ~/.luarocks/bin
for p in $extra_paths
	if test -d $p
		set -gx fish_user_paths $fish_user_paths $p
	end
end
if test -f ~/.dircolors
	eval (dircolors -c ~/.dircolors)
end
set -gx POCKETSPRITE_PATH ~/Code/esp/8bkc-sdk
set -gx IDF_PATH ~/Code/esp/esp-idf
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

abbr ll 'ls -lh'
abbr la 'ls -lah'
abbr gman 'man -k'
abbr :e $EDITOR
abbr :q exit
