function ccat -d "Colored cat using pygments"
	pygmentize -O style=monokai -f console256 -g $argv
end
