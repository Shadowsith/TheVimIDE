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
"autocmd BufRead,BufNewFile ^[^.]*$ set filetype=unknown
call plug#begin('~/.vim/bundle')
Plug 'VundleVim/Vundle.vim'
Plug 'vim-syntastic/syntastic'
Plug 'luochen1990/rainbow'
Plug 'Shadowsith/vim-syntax'
Plug 'vim-scripts/SingleCompile'
Plug 'lifepillar/vim-mucomplete', { 'for': ['css', 'html', 'php', 'vim', 'markdown', 'dict', 'text', 'xml', 'sh', 'java', 'csv', 'lua', 'make', 'unknown'] }
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
call settingloader#Syntastic()

"SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

"Various Hotkeys
nmap <F1> :set nu
nmap <F2> :set nonu
nmap <F3> :set ai
nmap <F4> :set noai

"µComplete for various filetypes
call settingloader#MuComplete()

"completor for C-Familiy, JavaScript, Python
call settingloader#Completor()

"vim-javacomplete2 for Java-Autocompletion
call settingloader#Javacomplete2()

"vim-lua-ftplugin for Lua-Autocompletion
call settingloader#LuaComplete()

"pgsql Plugin
"let g:sql_type_default = 'pgsql' "If you want use this plugin for all sql files

"vim-cpp-enhanced-highlight
call settingloader#CppEnhancedHighlight()

"Vim buildin omnicompletion"
call settingloader#VimOmniCompletion()

