" Add ~/.vim to the runtime path
set rtp+=~/.vim
set rtp+=/usr/share/vim/vim80
set rtp+=/usr/share/vim/vim74

" Load the basic vimrc
runtime vimrc

" NeoVim specific settings
"tnoremap <Esc> <C-\><C-n>
if exists(":FZF")
	nnorema <C-p> :FZF<CR>
elseif exists(':Unite')
	nnorema <C-p> :Unite file_rec/neovim<CR>
endif
