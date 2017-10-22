set nocompatible
filetype off 
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
call plug#begin('~/.vim/bundle')
Plug 'VundleVim/Vundle.vim'
Plug 'vim-syntastic/syntastic'
Plug 'luochen1990/rainbow'
Plug 'Shadowsith/vim-syntax'
Plug 'vim-scripts/SingleCompile'
Plug 'lifepillar/vim-mucomplete', { 'for': ['css', 'html', 'php', 'vim'] }
Plug 'lifepillar/pgsql.vim'
Plug 'lifepillar/vim-cheat40'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'maralla/completor.vim', { 'for': ['cpp', 'c'] }
Plug 'scrooloose/nerdtree'
call plug#end()

"Rainbow brakets
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

"Nerdtree
map <C-n> :NERDTreeToggle<CR>

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
autocmd FileType vim,css,html,php inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
autocmd FileType vim,css,html,php inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
autocmd FileType vim,css,html,php inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
set completeopt+=noselect
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

"completor
let g:completor_clang_binary='/usr/bin/clang'
autocmd FileType c,cpp  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
autocmd FileType c,cpp  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd FileType c,cpp  inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
set completeopt-=longest
set completeopt+=menuone
set completeopt-=menu
if &completeopt !~# 'noinsert\|noselect'
    set completeopt+=noselect
endif


"pgsql Plugin

"let g:sql_type_default = 'pgsql' "If you want use this plugin for all sql files

"vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1 
let g:cpp_member_variable_highlight = 1 
let g:cpp_class_decl_highlight = 1 
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1


"Vim buildin omnicompletion"
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

