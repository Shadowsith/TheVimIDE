set nocompatible
filetype off 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'luochen1990/rainbow'
Plugin 'Shadowsith/vim-syntax'
Plugin 'vim-scripts/SingleCompile'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'lifepillar/pgsql.vim'
Plugin 'lifepillar/vim-cheat40'
call vundle#end()
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

"Rainbow brakets
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

"Syntatisc
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

"Various Hotkeys
nmap <F1> :set nu
nmap <F2> :set nonu
nmap <F2> :set ai
nmap <F3> :set noai

"µComplete
set completeopt+=menuone
inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
set completeopt+=noselect
"set completeopt+=noinsert (only one to choose)
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

"pgsql Plugin
"let g:sql_type_default = 'pgsql' "If you want use this plugin for all sql files

