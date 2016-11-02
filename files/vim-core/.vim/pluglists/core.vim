Plug 'tpope/vim-sensible' " Reasonable defaults
if !has('nvim')
  Plug 'noahfrederick/vim-neovim-defaults'
endif
" Help viewer
if !(has('win32') || has('win64'))
	" Seems to have some issues in Windows (gvim)
	Plug 'powerman/vim-plugin-viewdoc'
endif
" Themes
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug '844196/lightline-badwolf.vim'
" UI
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'kshenoy/vim-signature'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jreybert/vimagit', { 'on': 'Magit' }
" Misc Plugs
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
