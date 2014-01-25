function fish_right_prompt --description 'Print out useful information on the side'
	
	# Colors
	set -l normal (set_color normal)
	set -l pbase $normal(set_color cyan)
	set -l red (set_color -o red)
	set -l yellow (set_color -o yellow)
	set -l green $normal(set_color green)
	set -l white (set_color -o white)
	set -l brown $normal(set_color brown)

	set PR_venv ""
	if set -q VIRTUAL_ENV
		set PR_venv $pbase"[$green"(basename "$VIRTUAL_ENV")"$pbase]─"
	end
	
	set -l __git_cb_hash ""
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1
		set __git_cb_hash (git rev-parse --short=6 HEAD)
	end
	set PR_git (__fish_git_prompt $green"[git|%s$green|$__git_cb_hash]")$pbase"-"

	set PR_time $white(date "+%H:%M:%S")$pbase
	echo -n "$PR_venv$PR_git$pbase""[$PR_time$pbase]"
	set_color normal

end
