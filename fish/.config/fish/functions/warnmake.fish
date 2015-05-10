function warnmake -d 'Make clean and then make target, print only warnings/errors'
	if make clean
		make $argv | grep "warning|error"
	end
end
