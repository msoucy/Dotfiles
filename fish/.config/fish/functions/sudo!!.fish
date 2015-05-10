function sudo!! -d "Run previous command as root"
	sudo su -c "$history[1]"
end
