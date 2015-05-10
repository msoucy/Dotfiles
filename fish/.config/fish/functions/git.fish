function git -d "Call hub if it exists, or git otherwise"
	if which hub 2> /dev/null 1>&2
		hub $argv
	else
		command git $argv
	end
end
