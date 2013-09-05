function prompt_pwd --description 'Print the current working directory, shortened'
	echo $PWD | sed -e "s|^$HOME|~|" #-e 's-\([^/.]\)[^/]*/-\1/-g'
end
