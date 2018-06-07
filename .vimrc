set nocompatible
filetype off 
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set nosmd 
set noru
set splitbelow 
set tw=120

"Handle autocompletion problems by loading plugins conditionally
let $ac = expand('%:e') "read file extensions

call plug#begin('~/.vim/bundle')
"User Interface
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nanotech/jellybeans.vim'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'simeji/winresizer'

"Completion Engines
if $ac != "c" || $ac != "cpp" || $ac != "c++" || $ac != "h" || $ac != "hpp" || $ac != "js" || $ac != "py"
    Plug 'lifepillar/vim-mucomplete' 
endif
Plug 'maralla/completor.vim', { 'for': ['cpp', 'c', 'js', 'py'] }
Plug 'shawncplus/phpcomplete.vim'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' } "lua autocompletion
Plug 'xolox/vim-misc' "needed for lua-autocompletion
Plug 'ternjs/tern_for_vim' "javascript, default jQuery support
Plug 'ludovicchabant/vim-gutentags' "auto ctags generation

"Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"Syntax Highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'othree/html5.vim' "also code completion of html5 tags
Plug 'Shadowsith/vim-syntax'
Plug 'elmar-hinz/vim.typoscript' 
Plug 'lifepillar/pgsql.vim'
Plug 'ap/vim-css-color'
Plug 'udalov/kotlin-vim'

"Code Helper
Plug 'luochen1990/rainbow' "different colors for different bracklets
Plug 'tpope/vim-commentary'
Plug 'jason0x43/vim-js-indent'
Plug 'cohama/lexima.vim' "automatic closes paranthesis and strings
Plug 'Shougo/denite.nvim' "search filesystem, tags, buffers
Plug 'maksimr/vim-jsbeautify'
Plug 'alvan/vim-closetag' "closes html tags in html-documents

"Debugging and building
Plug 'vim-syntastic/syntastic'
Plug 'vim-scripts/SingleCompile'
Plug '~/.vim/bundle/Conque-GDB'
Plug 'vim-vdebug/vdebug', {'for' : ['py', 'php'] }

"UI Helper
Plug 'Yggdroot/indentLine'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'inside/vim-search-pulse'
Plug 'terryma/vim-expand-region'
Plug 'EinfachToll/DidYouMean'

"Documentation
Plug 'lervag/vimtex' "LaTeX bundle
Plug 'vimwiki/vimwiki'
Plug 'xolox/vim-notes'

"Various
Plug 'lifepillar/vim-cheat40'


"C# must be checked
Plug 'OmniSharp/omnisharp-vim', {'for': 'cs'}
Plug 'Shougo/vimproc.vim', {'for' : 'cs'}
Plug 'tpope/vim-dispatch', {'for' : 'cs'} 
"Plug '~/.vim/bundle/dbext'
call plug#end()
call plug#helptags() 

"Jellybeans colorscheme
call settingloader#Jellybeans()

"Vim-Airline (Userinterface)
call settingloader#Airline() 

"Rainbow brakets
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

"Vim Notes
let g:notes_directories = ['~/.notesvim']


"Nerdtree
map <C-n> :NERDTreeTabsToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Tagbar 
map <C-t> :TagbarToggle<CR>
let g:tagbar_phpctags_bin='/usr/bin/phpctags'
let g:tagbar_phpctags_memory_limit = '256M'

"Syntatisc
call settingloader#Syntastic()

"SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

"Various Hotkeys
nmap <F2> :call hotkeys#LineNumbers()<cr>
nmap <F3> :call hotkeys#AutoIndent()<cr>
nmap <F4> :call hotkeys#IndentLine()<cr> 
nmap <S-s> :w<cr>
nmap <C-Right> :tabn<cr>
nmap <C-Left> :tabp<cr>

"Aliases
call alias#SetupCommandAlias("GDB","ConqueGdb -q")
call alias#SetupCommandAlias("gdb","ConqueGdb -q")

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

"Php Autoindent 
autocmd BufEnter *.php set autoindent 

"OmniSharp
if $ac == "cs"
    call settingloader#OmniSharp() 
endif
