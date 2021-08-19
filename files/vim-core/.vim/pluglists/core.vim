" Reasonable defaults {{{1
" Neovim has them built in
Plug 'tpope/vim-sensible', Cond(!has('nvim'))
Plug 'noahfrederick/vim-neovim-defaults', Cond(!has('nvim'))

" netrw {{{1
" netrw comes with vim by default, but it's still a plugin
let g:netrw_liststyle=3

" Themes {{{1
Plug 'sjl/badwolf'
Plug '844196/lightline-badwolf.vim'
Plug 'NLKNguyen/papercolor-theme'

" UI {{{1
Plug 'airblade/vim-gitgutter'
Plug 'rbong/vim-crystalline'
Plug 'kshenoy/vim-signature'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jreybert/vimagit', { 'on': 'Magit' }

" Status line controls {{{2

function! StatusLine(current, width) abort
    let l:s = ''

    if a:current
        let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
        try
            if &ft !~? 'vimfiler\|tagbar' && exists('*fugitive#head')
                let mark = '⎇'  " edit here for cool mark
                let branch = fugitive#head()
                if branch !=# ''
                    let l:s .= ' '.mark.branch.' |'
                endif
            endif
        catch
        endtry
    else
        let l:s .= '%#CrystallineInactive#'
    endif

    let l:s .= ' %f%h%w'

    if &ft !~? 'help'
        let l:s .= &modified ? '+' : &modifiable ? '' : '-'
        let l:s .= &readonly ? 'RO' : ''
    endif

    let l:s .= ' '

    if a:current
        let l:s .= crystalline#right_sep('', 'Fill')
    endif

    let l:s .= '%='

    if a:width > 80
        if &ft !~? 'help'
            let l:s .= ' %{&ff} | %{&enc} | %{&ft} '
        endif
        try
            let l:s .= pom#uphase() . ' '
        catch /E117/
        endtry
    endif

    if a:current
        let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
        let l:s .= crystalline#left_mode_sep('')
    endif

    if a:width > 80
        let l:s .= crystalline#left_sep('', 'Fill')
        let l:s .= '%3P '
        let l:s .= crystalline#left_mode_sep('')
        let l:s .= '%( %3l:%-2v %)'
    else
        let l:s .= ' '
    endif

    return l:s
endfunction

function! TabLine() abort
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'badwolf'
" }}}

" Editorconfig {{{1
Plug 'editorconfig/editorconfig-vim'

" Misc Plugs {{{1
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'wellle/targets.vim'

" vim: foldmethod=marker
