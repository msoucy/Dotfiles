"The basic settings
if &shell =~# 'fish$'
	set shell=/bin/bash
endif

set nocompatible
set laststatus=2
set tabstop=4
set shiftwidth=4
set number
set ignorecase
set modeline
set nobackup
set noswapfile
set wrap
set hidden
set hlsearch
set cc=80,120

"Syntax highlighting
syntax on

let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:clang_format#auto_format = 0
let g:clang_format#code_style = 'llvm'
let g:clang_format#style_options = {
			\ 'IndentWidth': 4,
			\ 'TabWidth': 4,
			\ 'UseTab': "Always",
			\ 'AlwaysBreakTemplateDeclarations': "true",
			\ 'ColumnLimit': 80
			\}
let g:clang_format#auto_formatexpr = 1
let g:syntastic_cpp_config_file = ".syntastic"
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:table_mode_corner = '|'

if has("nvim")
	call plug#begin('~/.nvim/bundle')
else
	call plug#begin('~/.vim/bundle')
endif
Plug 'tpope/vim-sensible' " Reasonable defaults
Plug 'sjl/badwolf' " Theme
" Syntax formatting and verification
Plug 'scrooloose/syntastic'
Plug 'Chiel92/vim-autoformat'
Plug 'editorconfig/editorconfig-vim'
Plug 'rhysd/vim-clang-format', { 'for': 'cpp' }
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
" Language syntaxes
Plug 'lepture/vim-jinja'
Plug 'dag/vim-fish'
Plug 'dpwright/vim-tup'
Plug 'othree/html5.vim'
Plug 'idanarye/vim-dutyl'
Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell', 'do': 'cabal install ghc-mod' }
Plug 'vim-jp/cpp-vim'
Plug 'SWIG-syntax', { 'for': 'swig' }
Plug 'syntaxhaskell.vim', { 'for': 'haskell' }
Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
" Show more info
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'kshenoy/vim-signature'
Plug 'majutsushi/tagbar'
" Misc Plugs
Plug 'kien/ctrlp.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'jmcantrell/vim-virtualenv'
Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
call plug#end()

"Set a nice Omnifunc - <CTRL>X <CTRL>O
set ofu=syntaxcomplete#Complete

"Mapped some FUNCTION keys to be more useful
map <F9> :make<Return>:copen<Return><Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

" paste mode toggle (needed when using autoindent/smartindent)
map <F7> :set paste<CR>
map <F8> :set nopaste<CR>
imap <F7> <C-O>:set paste<CR>
imap <F8> <nop>
set pastetoggle=<F12>

"This is a nice buffer switcher
nnoremap <F5> :buffers<CR>:buffer<Space>

set background=dark
colorscheme desert " Use desert if badwolf isn't installed yet
silent! colorscheme badwolf

"Set the color for the popup menu
highlight Pmenu ctermbg=blue ctermfg=white
highlight PmenuSel ctermbg=blue ctermfg=red
highlight PmenuSbar ctermbg=cyan ctermfg=green
highlight PmenuThumb ctermbg=white ctermfg=red

" Make vim popup behave more like an IDE POPUP
set completeopt=longest,menuone

" Make enter finish the completion popup menu
inoremap <expr> <CR> pumvisible()? "\<C-y>" : "\<C-g>r\<CR>"

imap jj <ESC>
nmap <silent> <Leader>/ :nohlsearch<CR>
nmap <silent> <Leader>t :TagbarToggle<CR>
nmap <silent> <Leader>l :lclose<CR>
nmap <silent> <Leader>r :so $MYVIMRC<CR>

" Don't show the intro message
set shortmess+=I

" Move by row, not line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

let g:vim_markdown_folding_disabled=1
au BufNewFile,BufReadPost *.md set ft=markdown
au BufNewFile,BufReadPost *.md :TableModeEnable
au BufNewFile,BufReadPost *.html,*.htm,*.shtml,*.stm set ft=jinja
au BufNewFile,BufReadPost *.yaml,*.yml set ts=2 sw=2
au BufNewFile,BufReadPost *.hs set expandtab
au BufNewFile,BufReadPost *.fish set ft=fish

" Highlight line and column
set cursorline cursorcolumn
nnoremap H :set cursorline! cursorcolumn!<CR>

" Use <leader>p to paste-and-preserve (instead of shift-insert)
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

" Language-specific custom commands
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction
command! -complete=shellcmd -nargs=+ Hoogle call s:RunShellCommand('hoogle "'.<q-args>.'"')
command! -complete=file -nargs=* Git call s:RunShellCommand('git '.<q-args>)

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

