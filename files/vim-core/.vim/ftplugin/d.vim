setlocal formatprg=dfmt
" Stolen from the java version
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal include="^\s*import"
setlocal suffixesadd=.d
setlocal path+=src/,include/,import/
autocmd! BufWritePost * Neomake
