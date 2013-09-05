function sshcs --description 'SSH into a CS machine'
	ssh (findhost -u mas5997 -t 0.2 ~/.ssh/cshosts)
end
