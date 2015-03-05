function git
	if which hub 2> /dev/null
		hub $argv
	else
		command git $argv
	end
end
