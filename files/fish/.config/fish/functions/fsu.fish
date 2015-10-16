function fsu -d "Run fish as root"
	/bin/su --shell=/usr/bin/fish $argv
end
