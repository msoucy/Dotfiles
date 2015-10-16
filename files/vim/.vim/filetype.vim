if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
	au! BufRead,BufNewFile *.md		setfiletype markdown
	if !empty(globpath(&rtp, "syntax/jinja.vim"))
		au! BufRead,BufNewFile *.html,*.htm,*.shtml,*.stm     setfiletype jinja
	endif
	if !empty(globpath(&rtp, "syntax/fish.vim"))
		au! BufRead,BufNewFile *.fish     setfiletype fish
	endif
augroup END
