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

let restricted = 0
try
	call system("")
catch /E145/
	let restricted = 1
catch /E484/
endtry

let g:airline#extensions#whitespace#mixed_indent_algo = 1

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'sjl/badwolf'
Plugin 'dag/vim-fish'
Plugin 'othree/html5.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Chiel92/vim-autoformat'
if restricted == 0
	Plugin 'scrooloose/syntastic'
endif
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-sensible'
Plugin 'editorconfig/editorconfig-vim'
call vundle#end()
filetype plugin indent on

"Set a nice Omnifunc - <CTRL>X <CTRL>O
set ofu=syntaxcomplete#Complete

"Mapped some FUNCTION keys to be more useful
map <F9> :make<Return>:copen<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

" paste mode toggle (needed when using autoindent/smartindent)
map <F7> :set paste<CR>
map <F8> :set nopaste<CR>
imap <F7> <C-O>:set paste<CR>
imap <F8> <nop>
set pastetoggle=<F6>

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

"TAGLIST setup
nnoremap <F3> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth = 50

imap jj <ESC>
nmap <silent> <Leader>/ :nohlsearch<CR>

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
