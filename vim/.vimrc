" Author: Matt Soucy

" vim settings {{{
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
set cursorline cursorcolumn
set shortmess+=I " Don't show the intro message
syntax on "Syntax highlighting
" }}}

" Plugins {{{
" Load plugins {{{
if !empty(globpath(&rtp, "autoload/plug.vim"))
	call plug#begin()
	" Plugins {{{
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
	Plug 'vim-jp/cpp-vim'
	Plug 'SWIG-syntax', { 'for': 'swig' }
	Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell', 'do': 'cabal install ghc-mod' }
	Plug 'syntaxhaskell.vim', { 'for': 'haskell' }
	Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
	" Show more info
	Plug 'airblade/vim-gitgutter'
	Plug 'itchyny/lightline.vim'
	Plug 'kshenoy/vim-signature'
	Plug 'majutsushi/tagbar'
	" Misc Plugs
	Plug 'kien/ctrlp.vim'
	Plug 'ntpeters/vim-better-whitespace'
	Plug 'scrooloose/nerdcommenter'
	Plug 'jmcantrell/vim-virtualenv'
	Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
	Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
	Plug 'tpope/vim-fugitive'
	" }}}
	call plug#end()
endif
" }}}

" Plugin settings {{{
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
let g:syntastic_d_checkers = ['dub']
let g:table_mode_corner = '|'
let g:vim_markdown_folding_disabled=1
" }}}

" }}} Plugins

" Color {{{
set background=dark
colorscheme desert " Use desert if badwolf isn't installed yet
silent! colorscheme badwolf
" }}}

" Keybindings {{{
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

imap jj <ESC>
nmap <silent> <Leader>/ :nohlsearch<CR>
nmap <silent> <Leader>l :lclose<CR>
nmap <silent> <Leader>r :so $MYVIMRC<CR>

" Move by row, not line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Highlight line and column
nnoremap H :set cursorline! cursorcolumn!<CR>

if exists(":TagbarToggle")
	nmap <silent> <Leader>t :TagbarToggle<CR>
endif
" }}}

" Completion {{{
"Set a nice Omnifunc - <CTRL>X <CTRL>O
set ofu=syntaxcomplete#Complete

" Make vim popup behave more like an IDE POPUP
set completeopt=longest,menuone

" Make enter finish the completion popup menu
inoremap <expr> <CR> pumvisible()? "\<C-y>" : "\<C-g>r\<CR>"
" }}}

" Lightline controls {{{
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'fugitive#head',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ }

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction
" }}}

" Custom term behavior {{{
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
" }}}

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" vim: foldmethod=marker
