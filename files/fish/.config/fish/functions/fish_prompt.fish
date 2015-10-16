function fish_prompt -d 'Print out the main prompt'

	set -l last_status $status

	# Colors
	set -l normal (set_color normal)
	set -l pbase $normal(set_color cyan)
	set -l red (set_color -o red)
	set -l yellow (set_color -o yellow)
	set -l green $normal(set_color green)

	set -l PR_user_host $red(whoami)$yellow@(hostname)
	set -l PR_pwd (set_color yellow)(prompt_pwd)
	set -l PR_status "$green^_^"
	if not test $last_status = 0
		set PR_status $red"O_O [$last_status]"
	end

	echo "$pbase$__msoucy_ul"(_msoucy_prompt_box left "$PR_user_host" "$PR_pwd")"$__msoucy_cap_left"
	echo -n "$__msoucy_ll"(_msoucy_prompt_box left "$PR_status")"$__msoucy_prompt$normal "

end
