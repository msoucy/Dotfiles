function remake -d 'Make clean, and then make provided target'
	if make clean
		make $argv
	end

end
