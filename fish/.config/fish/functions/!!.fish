function !! -d "Run previous command again"
	if begin; test (count argv) -eq 1; and test -d $argv[1]; end
		eval $history[$argv[1]]
	else
		eval $history[1]
	end
end
