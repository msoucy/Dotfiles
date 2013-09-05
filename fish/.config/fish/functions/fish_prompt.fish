function fish_prompt --description 'Print out the main prompt'
	
	set last_status $status
	
	# Colors
	set -l normal (set_color normal)
	set -l pbase $normal(set_color cyan)
	set -l red (set_color -o red)
	set -l yellow (set_color -o yellow)
	set -l green $normal(set_color green)

	set -l PR_user_host $red(whoami)$yellow@(hostname)$pbase
	set -l PR_pwd $yellow(prompt_pwd)$pbase
	set -l PR_status "$green^_^$pbase"
	if not test $last_status = 0
		set PR_status $red"O_O [$last_status]"$pbase
	end

	printf "%s┌[%s]-[%s]\n└[%s]>%s " $pbase $PR_user_host $PR_pwd $PR_status $normal

end
