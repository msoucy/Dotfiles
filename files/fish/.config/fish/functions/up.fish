function up -d 'Move up N directories'
	set upstr "."
	for i in (seq 1 $argv[1])
			set upstr "$upstr/.."
	end
	cd $upstr
end
