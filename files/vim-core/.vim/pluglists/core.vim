" Reasonable defaults
" Neovim has them built in
Plug 'tpope/vim-sensible', Cond(!has('nvim'))
Plug 'noahfrederick/vim-neovim-defaults', Cond(!has('nvim'))

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
Plug 'tpope/vim-fugitive'
