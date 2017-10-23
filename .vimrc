set nocompatible
filetype off 
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
autocmd BufRead,BufNewFile *.xhtml set filetype=html
autocmd BufRead,BufNewFile *.xmlx set filetype=xml
autocmd BufRead,BufNewFile *.dict set filetype=dict
call plug#begin('~/.vim/bundle')
Plug 'VundleVim/Vundle.vim'
Plug 'vim-syntastic/syntastic'
Plug 'luochen1990/rainbow'
Plug 'Shadowsith/vim-syntax'
Plug 'vim-scripts/SingleCompile'
Plug 'lifepillar/vim-mucomplete', { 'for': ['css', 'html', 'php', 'vim', 'markdown', 'dict', 'text', 'xml', 'sh', 'java', 'csv'] }
Plug 'lifepillar/pgsql.vim'
Plug 'lifepillar/vim-cheat40'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'maralla/completor.vim', { 'for': ['cpp', 'c'] }
Plug 'scrooloose/nerdtree'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' }
Plug 'xolox/vim-misc'
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

"µComplete for various filetypes
set completeopt+=menuone
autocmd FileType vim,css,html,php,markdown,dict,text,xml,sh,java,csv inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
autocmd FileType vim,css,html,php,markdown,dict,text,xml,sh,java,csv inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
autocmd FileType vim,css,html,php,markdown,dict,text,xml,sh,java,csv inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
set completeopt+=noselect
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

"completor for C-Familiy, JavaScript, Python
let g:completor_clang_binary='/usr/bin/clang' "on Linux-Console: $ which clang
autocmd FileType c,cpp  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
autocmd FileType c,cpp  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd FileType c,cpp  inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
set completeopt-=longest
set completeopt+=menuone
set completeopt-=menu
if &completeopt !~# 'noinsert\|noselect'
    set completeopt+=noselect
endif

"vim-javacomplete2 for Java-Autocompletion
autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
nmap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
nmap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
nmap <leader>jii <Plug>(JavaComplete-Imports-Add)
imap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
imap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
imap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
imap <C-j>ii <Plug>(JavaComplete-Imports-Add)
nmap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)
imap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)
nmap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
nmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
nmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
nmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
nmap <leader>jts <Plug>(JavaComplete-Generate-ToString)
nmap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
nmap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
nmap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)
imap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
imap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
imap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
vmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
vmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
vmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
nmap <silent> <buffer> <leader>jn <Plug>(JavaComplete-Generate-NewClass)
nmap <silent> <buffer> <leader>jN <Plug>(JavaComplete-Generate-ClassInFile)

"vim-lua-ftplugin for Lua-Autocompletion
let g:lua_compiler_name = '/usr/bin/luac'
let g:lua_check_syntax = 0
let g:lua_ceck_gloabals = 0
let g:lua_complete_omni = 1
let g:lua_safe_omni_modules = 1
let g:lua_safe_omni_modules = 1
let g:lua_define_omnifunc = 0

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

