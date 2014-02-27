function tssh
	ssh -t $argv[1] tmux a -t $argv[2]
end
