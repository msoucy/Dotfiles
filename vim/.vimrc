""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc default setup file for Terminal IDE "
"                                            "
" Creator : Spartacus Rex                    "
" Version : 1.0                              "
" Date    : 9 Nov 2011                       "
""""""""""""""""""""""""""""""""""""""""""""""

"The basic settings
if &shell =~# 'fish$'
	set shell=sh
endif

set nocp
set ls=2
set tabstop=4
set shiftwidth=4
set number
set ignorecase
set modeline
set nobackup
set wrap
set hidden

"Syntax highlighting
syntax on

try
	call system("")
	let restricted = 0
catch /E\(145\|484\)/
	let restricted = 1
endtry

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'sjl/badwolf'
Plugin 'dag/vim-fish'
Plugin 'othree/html5.vim'
Plugin 'scrooloose/nerdcommenter'
if restricted == 0
	Plugin 'scrooloose/syntastic'
	Plugin 'bling/vim-airline'
endif
Plugin 'tpope/vim-sensible'
call vundle#end()
filetype plugin indent on

"Set a nice Omnifunc - <CTRL>X <CTRL>O
set ofu=syntaxcomplete#Complete

"Mapped some FUNCTION keys to be more useful
map <F7> :make<Return>:copen<Return>
map <F8> :cprevious<Return>
map <F9> :cnext<Return>

"This is a nice buffer switcher
:nnoremap <F5> :buffers<CR>:buffer<Space>

set background=dark
colorscheme desert " Use desert if badwolf isn't installed yet
silent! colorscheme badwolf

"Set the color for the popup menu
:highlight Pmenu ctermbg=blue ctermfg=white
:highlight PmenuSel ctermbg=blue ctermfg=red
:highlight PmenuSbar ctermbg=cyan ctermfg=green
:highlight PmenuThumb ctermbg=white ctermfg=red

" Make vim popup behave more like an IDE POPUP
set completeopt=longest,menuone

" Make enter finish the completion popup menu
inoremap <expr> <CR> pumvisible()? "\<C-y>" : "\<C-g>r\<CR>"

"TAGLIST setup
nnoremap <F3> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1 
let Tlist_WinWidth = 50

imap jj <ESC>
command C let @/=""

set shortmess+=I

" Move by row, not line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:vim_markdown_folding_disabled=1

" Highlight line and column
set cursorline cursorcolumn
hi CursorLine     cterm=NONE ctermbg=black
hi CursorColumn   cterm=NONE ctermbg=black
nnoremap H :set cursorline! cursorcolumn!<CR>
