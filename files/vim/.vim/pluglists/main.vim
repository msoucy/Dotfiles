Plug 'tpope/vim-sensible' " Reasonable defaults
if !has('nvim')
  Plug 'noahfrederick/vim-neovim-defaults'
endif
" Syntax formatting and verification
Plug 'benekastah/neomake', { 'on': 'Neomake' }
Plug 'Chiel92/vim-autoformat', { 'for': 'cpp' }
Plug 'editorconfig/editorconfig-vim'
" Help viewer
if !(has('win32') || has('win64'))
	" Seems to have some issues in Windows (gvim)
	Plug 'powerman/vim-plugin-viewdoc'
endif
" Misc Plugs
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
