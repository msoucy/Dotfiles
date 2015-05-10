#!/usr/bin/fish

set fish_greeting ""

# Status Chars
if true
	set __fish_git_prompt_char_dirtystate '⚡'
	set __fish_git_prompt_char_stagedstate '→'
	set __fish_git_prompt_char_stashstate '↩'
	set __fish_git_prompt_char_upstream_ahead '↑'
	set __fish_git_prompt_char_upstream_behind '↓'
else
	set -g __fish_git_prompt_char_stagedstate "●"
	set -g __fish_git_prompt_char_dirtystate "✚"
	set -g __fish_git_prompt_char_untrackedfiles "…"
	set -g __fish_git_prompt_char_conflictedstate "✖"
	set -g __fish_git_prompt_char_cleanstate "✔"
end

set -g __fish_git_prompt_char_stateseparator "|"
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_showstashstate 'yes'
set -g __fish_git_prompt_showcolorhints

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_stashstate red bold
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green bold

set VIRTUALFISH_HOME "$HOME/.virtualenv"
if python -c 'exit("virtualfish" not in (name for l, name, p in __import__("pkgutil").iter_modules()))'
	eval (python -m virtualfish compat_aliases auto_activation)
	complete -f -c workon -a "(vf ls)"
else
	echo "Virtualfish not found, will not be in prompt"
	echo "Install using 'pip install --user virtualfish'"
end

set -gx PAGER "less"
set -gx LESS "-FR"
