" Add ~/.vim to the runtime path
set rtp+=~/.vim

" Load the basic vimrc
runtime vimrc

" NeoVim specific settings
if exists(":FZF")
	nnorema <C-p> :FZF<CR>
elseif exists(':Unite')
	nnorema <C-p> :Unite file_rec/neovim<CR>
endif
