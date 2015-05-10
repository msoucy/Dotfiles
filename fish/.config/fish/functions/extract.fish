function extract -d 'Automatically determine the command to extract a file'
	if test (count $argv) -ne 1
		echo "usage: extract < filename >"
		echo "	   Extract the file specified based on the extension"
	else if test -f $argv[1]
		set arg $argv[1]
		switch $arg
			case '*.tar.bz2' '*.tbz2'
				tar -jxvf $arg
			case '*.tar.gz' '*.tgz'
				tar -zxvf $arg
			case '*.bz2'
				bunzip2 $arg
			case '*.gz'
				gunzip $arg
			case '*.jar' '*.zip'
				unzip $arg
			case '*.rar'
				unrar x $arg
			case '*.tar'
				tar -xvf $arg
			case '*.Z'
				uncompress $arg
			case '*.tar.xz'
				tar -xvJf $arg
			case '*'
				echo "Unable to extract '$arg' :: Unknown extension"
		end
   else
	  echo "File ('$arg') does not exist!"
   end
end
