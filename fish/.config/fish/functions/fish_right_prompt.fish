function fish_right_prompt -d 'Print out useful information on the side'

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
		set PR_venv $pbase"["$green"v|"(basename "$VIRTUAL_ENV")"$pbase]─"
	end

	set -l __git_cb_hash ""
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1
		set __git_cb_hash (git rev-parse --short=6 HEAD 2> /dev/null)
	end
	set PR_git (__fish_git_prompt $pbase"["$green"git|%s$green|$__git_cb_hash")$pbase"]─"

	set -l PR_hg ""
	if command -v hg > /dev/null 2>&1
		if hg root > /dev/null 2>&1
			set -l hgid (hg id)
			set -l __hg_diffs (hg summary | grep 'commit:' | sed -r -e 's!commit: !!g' | grep -Eo '[0-9]+\s*\w' | grep -v 'u$' | sed -e 's! !!g')
			set PR_hg $pbase"["$green"hg|"(echo $hgid | sed -r -e 's!(^.{7}).*!\1!')"|$__hg_diffs$green|"(hg branch)$pbase"]─"
		end
	end

	set PR_time $white(date "+%H:%M:%S")$pbase
	echo -n "$PR_venv$PR_git$PR_hg$pbase""[$PR_time$pbase]"
	set_color normal

end
