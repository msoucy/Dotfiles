function fish_right_prompt --description 'Print out useful information on the side'
	
	set last_status $status

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
	
	set PR_git ""
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1
		set -l __git_cb_branch (git branch ^/dev/null | grep \* | sed 's/* //')
		set -l __git_cb_hash (git rev-parse --short=6 HEAD)
		# TODO: Convert staging status
		set PR_git $pbase"["$green"git|$__git_cb_branch|$__git_cb_hash$pbase]─"
	end

	set PR_time $white(date "+%H:%M:%S")$pbase
	echo -n "$PR_venv$PR_git$pbase""[$PR_time$pbase]"
	set_color normal

end
