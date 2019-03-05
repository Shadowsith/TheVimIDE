function pluginloader#getFileTypes() 
    let l:ft = ['c', 'cpp', 'c++', 'h', 'hpp', 'js', 'py', 'rb', 'html', 'xml']
    call add(l:ft, 'css')
    call add(l:ft, 'java')
    call add(l:ft, 'php')
    return l:ft
endfunction


function pluginloader#UI()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'majutsushi/tagbar'
    Plug 'simeji/winresizer'
    Plug 'EinfachToll/DidYouMean'
endfunction

function pluginloader#Colorschemes()
    Plug 'rafi/awesome-vim-colorschemes' 
    Plug 'altercation/vim-colors-solarized'
endfunction

function pluginloader#Completion() 
    let $ac = expand('%:e') "read file extensionns
    "Completion Engines
    for l:ft in pluginloader#getFileTypes() 
        if l:ft != $ac
            Plug 'lifepillar/vim-mucomplete' 
            break
        endif
    endfor
    Plug 'maralla/completor.vim', { 'for': ['cpp', 'c', 'javascript', 'python', 'php', 'ruby', 'html', 'css', 'xml', 'java'] }
    Plug 'shawncplus/phpcomplete.vim' { 'for': 'php' }
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    Plug 'xolox/vim-lua-ftplugin', { 'for': 'lua' } "lua autocompletion
    Plug 'xolox/vim-misc' "needed for lua-autocompletion
    Plug 'ternjs/tern_for_vim' "javascript, default jQuery support
    Plug 'ludovicchabant/vim-gutentags' "auto ctags generation
    Plug 'vim-ruby/vim-ruby' "default ruby
    Plug 'tpope/vim-rails' "ruby on rails
    Plug 'Quramy/tsuquyomi' "typescript autocompletion
    Plug 'autozimu/LanguageClient-neovim' 
    Plug 'Shadowsith/vim-ruby-autocomplete'
endfunction

function pluginloader#Snipptes()
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endfunction

function pluginloader#Syntax()
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'othree/html5.vim' "also code completion of html5 tags
    Plug 'Shadowsith/vim-syntax'
    Plug 'lifepillar/pgsql.vim'
    Plug 'ap/vim-css-color'
    Plug 'udalov/kotlin-vim'
    Plug 'leafgarland/typescript-vim'
endfunction

function pluginloader#CodeHelper()
    Plug 'Yggdroot/indentLine'
    Plug 'luochen1990/rainbow' "different colors for different bracklets
    Plug 'tpope/vim-commentary'
    Plug 'jason0x43/vim-js-indent'
    Plug 'cohama/lexima.vim' "automatic closes paranthesis and strings
    Plug 'Shougo/denite.nvim' "search filesystem, tags, buffers
    Plug 'maksimr/vim-jsbeautify'
    Plug 'alvan/vim-closetag' "closes html tags in html-documents
    Plug 'MattesGroeger/vim-bookmarks'
    Plug 'inside/vim-search-pulse'
    Plug 'terryma/vim-expand-region'
    Plug 'tpope/vim-fugitive' "Git plugin
    Plug 'airblade/vim-gitgutter' 
    Plug 'NLKNguyen/copy-cut-paste.vim' "only works on vim with gvim support
endfunction

function pluginloader#Debug()
    Plug 'vim-syntastic/syntastic'
    Plug 'vim-scripts/SingleCompile'
    Plug '~/.vim/bundle/Conque-GDB'
    Plug 'vim-vdebug/vdebug', {'for' : ['py', 'php'] }
endfunction

function pluginloader#Documentation()
    Plug 'lervag/vimtex' "LaTeX bundle
    Plug 'vimwiki/vimwiki'
    Plug 'xolox/vim-notes'
endfunction
