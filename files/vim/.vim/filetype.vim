if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.md,*.markdown        setfiletype markdown.pandoc
    au! BufRead,BufNewFile *.html,*.htm,*.shtml   setfiletype jinja.html
    au! BufRead,BufNewFile *.fish                 setfiletype fish
augroup END
