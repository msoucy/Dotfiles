Plug 'tpope/vim-sensible' " Reasonable defaults
" Syntax formatting and verification
Plug 'benekastah/neomake'
Plug 'Chiel92/vim-autoformat'
Plug 'editorconfig/editorconfig-vim'
" Help viewer
if !has('win32')
	" Seems to have some issues in Windows (gvim)
	Plug 'powerman/vim-plugin-viewdoc'
endif
" Misc Plugs
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'