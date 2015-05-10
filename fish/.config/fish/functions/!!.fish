function !! -d "Run previous command again"
	set cmd $history[1]
	if test (count $argv) -eq 1
		set cmd $history[$argv[1]]
	end
	eval $cmd
end
