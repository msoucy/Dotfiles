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
Plug 'itchyny/lightline.vim'
Plug 'kshenoy/vim-signature'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jreybert/vimagit', { 'on': 'Magit' }

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
