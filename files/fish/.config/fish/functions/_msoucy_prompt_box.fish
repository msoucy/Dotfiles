# Prompt configuration {{{
function _msoucy_prompt_set
	if test -z "$__msoucy_simple"
		set -g "__msoucy_$argv[1]" $argv[2]
	else
		set -g "__msoucy_$argv[1]" $argv[3]
	end
end
_msoucy_prompt_set box_left  "╣" "["
_msoucy_prompt_set box_right "╠" "]"
_msoucy_prompt_set box_sep   "═" "─"
_msoucy_prompt_set ul        "╔" "┌"
_msoucy_prompt_set ll        "╚" "└"
_msoucy_prompt_set cap_left  "╾" ""
_msoucy_prompt_set cap_right "╼" ""
_msoucy_prompt_set prompt    "╾" ">"
# }}}
#
function _msoucy_prompt_box -d 'Print out a box for a prompt'
	set -l pbase (set_color normal)(set_color cyan)
	set -l pref ""
	set -l suff ""
	switch $argv[1]
		case 'left';  set pref "$__msoucy_box_sep"
		case 'right'; set suff "$__msoucy_box_sep"
	end
	for mod in $argv[2..-1]
		if test -n "$mod"
			echo -n "$pbase$pref$__msoucy_box_left$mod$pbase$__msoucy_box_right$suff"
		end
	end
end
