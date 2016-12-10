set formatprg=dfmt
" Stolen from the java version
set includeexpr=substitute(v:fname,'\\.','/','g')
set include="^\s*import"
set suffixesadd=.d
set path+=src/,include/,import/
autocmd! BufWritePost * Neomake
