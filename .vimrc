set nocompatible
filetype off 
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

"Handle autocompletion problems by loading plugins conditionally
let $ac = expand('%:e') "read file extensions

call plug#begin('~/.vim/bundle')
"Plug 'VundleVim/Vundle.vim'
Plug 'vim-syntastic/syntastic'
Plug 'luochen1990/rainbow'
Plug 'Shadowsith/vim-syntax'
Plug 'vim-scripts/SingleCompile'

"Mucomplete crashes with completor and javacomplete, so only plugs for other
"filetypes
if $ac != "c" || $ac != "cpp" || $ac != "c++" || $ac != "h" || $ac != "hpp"
    Plug 'lifepillar/vim-mucomplete' ", { 'for': ['css', 'html', 'php', 'vim', 'markdown', 'dict', 'text', 'xml', 'sh', 'java', 'csv', 'lua', 'make', 'unknown'] }
endif
Plug 'lifepillar/pgsql.vim'
Plug 'lifepillar/vim-cheat40'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'maralla/completor.vim', { 'for': ['cpp', 'c'] }
Plug 'scrooloose/nerdtree'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' } "lua autocompletion
Plug 'xolox/vim-misc' "needed for lua-autocompletion
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'
Plug 'jason0x43/vim-js-indent'
Plug 'Townk/vim-autoclose'
Plug 'elmar-hinz/vim.typoscript' 
Plug 'nanotech/jellybeans.vim'
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
nmap <S> :w

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

"Vim snippets for many languages
call settingloader#Snippets()

"SearchTasks
call settingloader#SearchTasks()
