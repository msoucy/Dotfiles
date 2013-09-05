function up --description 'Move up N directories'
	if test (count $argv) -ne 1
				cd ..
		else
				set upstr "."
				for i in {1..$argv[1]}
						set upstr "$upstr/.."
				end
				cd $upstr
		end
end
