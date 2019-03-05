set nocompatible
filetype plugin indent on
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
set tw=85
inoremap <C-@> <C-X><C-O>

"Add thevimide help file
execute 'helptags' '~/.vim/doc'

"Indent format for some programming languages
call settingloader#FileIndent()

"Handle autocompletion problems by loading plugins conditionally
let $ac = expand('%:e') "read file extensions

call plug#begin('~/.vim/bundle')
"vimreg Default VimIDE Pluginloader
    call pluginloader#Completion()
    call pluginloader#Snipptes()
    call pluginloader#Syntax()
    call pluginloader#UI()
    call pluginloader#Colorschemes()
    call pluginloader#CodeHelper()
    call pluginloader#Debug()
    call pluginloader#Documentation()

    "Various
    Plug 'lifepillar/vim-cheat40'
"vimendreg

"put your own plugins here: 


call plug#end()
call plug#helptags() 

colorscheme flattened_dark

call settingloader#UiFeatures()

"Vim Notes
let g:notes_directories = ['~/.notesvim']

"Syntatisc
call settingloader#Syntastic()

"Hotkeys
call settingloader#Hotkeys()

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

"ruby autocompletion
call settingloader#Ruby()

"pgsql Plugin
"let g:sql_type_default = 'pgsql' "If you want use this plugin for all sql files

"vim-cpp-enhanced-highlight
call settingloader#CppEnhancedHighlight()

"Vim buildin omnicompletion"
call settingloader#VimOmniCompletion()

"PhpComplete settings
call settingloader#PHPComplete()

"Vim snippets for many languages
call settingloader#Snippets()

"SearchTasks
call settingloader#SearchTasks()

"OmniSharp
if $ac == "cs"
    call settingloader#OmniSharp() 
endif
