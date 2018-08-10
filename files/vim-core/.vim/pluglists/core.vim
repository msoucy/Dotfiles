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

" Lightline controls {{{2
let g:lightline = {
            \ 'colorscheme': 'badwolf',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'readonly', 'modified', 'fugitive', 'filename' ]],
            \   'right': [ [ 'neomake', 'lineinfo' ],
            \              ['percent'],
            \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightlineFugitive',
            \   'modified': 'LightlineModified',
            \   'readonly': 'LightlineReadonly',
            \   'fileformat': 'LightlineFileformat',
            \   'filetype': 'LightlineFiletype',
            \   'fileencoding': 'LightlineFileencoding',
            \ },
            \ 'component_expand': {
            \   'neomake': 'neomake#statusline#LoclistStatus',
            \ },
            \ 'component_type': {
            \   'neomake': 'error',
            \ },
            \ }

function! LightlineModified() abort
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly() abort
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFileformat() abort
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype() abort
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding() abort
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineFugitive() abort
  try
    if &ft !~? 'vimfiler\|tagbar' && exists('*fugitive#head')
      let mark = '⎇'  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction
" }}}

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
