function rot13 -d 'ROT13 stdin or provided arguments'
	if [ (count $argv) -eq 0 ]
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
	else
		echo $argv | tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
	end
end
