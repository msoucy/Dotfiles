" Add ~/.vim to the runtime path
set rtp+=~/.vim

" Load the basic vimrc
runtime vimrc

" NeoVim specific settings
"tnoremap <Esc> <C-\><C-n>
if exists(':Unite')
	nnorema <C-p> :Unite file_rec/neovim<CR>
endif
