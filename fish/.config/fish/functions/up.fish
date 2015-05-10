function up -d 'Move up N directories'
	if test (count $argv) -ne 1
				cd ..
		else
				set upstr "."
				for i in (seq $argv[1])
						set upstr "$upstr/.."
				end
				cd $upstr
		end
end
