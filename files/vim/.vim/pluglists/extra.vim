" Syntax formatting and verification {{{1
Plug 'benekastah/neomake', { 'on': 'Neomake' }
let g:neomake_open_list=2
Plug 'Chiel92/vim-autoformat', { 'for': 'cpp' }

" UI {{{1
Plug 'edkolev/tmuxline.vim'
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
            \'a'    : '#S',
            \'b'    : '#W',
            \'c'    : '#H',
            \'win'  : '#I | #W',
            \'cwin' : '#I | #W',
            \'y'    : '%a',
            \'z'    : '%R'}

" Language syntaxes {{{1
Plug 'sheerun/vim-polyglot'
Plug 'trapd00r/vim-syntax-vidir-ls'
Plug 'tmux-plugins/vim-tmux'
Plug 'jceb/vim-orgmode'
Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
let g:table_mode_corner = '|'
let g:vim_markdown_folding_disabled=1

" C++ related {{{1
Plug 'dpwright/vim-tup'
Plug 'vim-scripts/SWIG-syntax', { 'for': 'swig' }
Plug 'rhysd/vim-clang-format'
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

" Pandoc {{{1
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc#syntax#codeblocks#embeds#langs = [
			\ 'java', 'python', 'sh',
			\ 'dot', 'cpp', 'd', 'cs']
