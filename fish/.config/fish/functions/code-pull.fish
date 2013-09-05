function code-pull
	if test -d ".git"
		git pull
	else if test -d ".svn"
		svn update
	else if test -d ".hg"
		hg pull -u
	else
		print -P "No known repository"
	end
end
