# Prompt configuration {{{
set -g fish_prompt_git_status_added '→'
set -g fish_prompt_git_status_modified '⚡'
set -g fish_prompt_git_status_renamed '➜'
set -g fish_prompt_git_status_copied '⇒'
set -g fish_prompt_git_status_deleted '✖'
set -g fish_prompt_git_status_untracked '…'
set -g fish_prompt_git_status_unmerged '!'

for vcs in hg git
	eval set -g "fish_color_"$vcs"_dirty" blue
	eval set -g "fish_color_"$vcs"_staged" yellow
	eval set -g "fish_color_"$vcs"_invalid" red
	eval set -g "fish_color_"$vcs"_stash" -o red
	eval set -g "fish_color_"$vcs"_untrackedfiles" $fish_color_normal
	eval set -g "fish_color_"$vcs"_clean" -o green
end
# }}}

function fish_right_prompt -d 'Print out useful information on the side'

	# Colors
	set -l pbase (set_color normal)(set_color cyan)
	set -l green (set_color normal)(set_color green)

	set PR_venv ""
	if set -q VIRTUAL_ENV
		set PR_venv "$green""env|"(basename "$VIRTUAL_ENV")
	end
	set PR_git $green"git"(__terlar_git_prompt)
	set PR_hg $green"hg"(__fish_hg_prompt)
	set PR_time (set_color -o white)(date "+%H:%M:%S")
	echo -n "$pbase$__msoucy_cap_right"(_msoucy_prompt_box right "$PR_venv" "$PR_git" "$PR_hg" "$PR_time")

end

# vim: ft=fish fdm=marker
