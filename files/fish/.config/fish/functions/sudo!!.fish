function sudo!! -d "Run previous command as root"
	set cmd $history[1]
	if test (count $argv) -eq 1
		set cmd $history[$argv[1]]
	end
	eval sudo $cmd
end
