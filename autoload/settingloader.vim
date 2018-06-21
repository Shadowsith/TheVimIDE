function settingloader#Airline()
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
endfunction

function settingloader#UiFeatures()
    "Nerdtree
    map <C-n> :NERDTreeTabsToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    "Tagbar 
    map <C-t> :TagbarToggle<CR>
    let g:tagbar_phpctags_bin='/usr/bin/phpctags'
    let g:tagbar_phpctags_memory_limit = '256M'

    "Rainbow brakets
    let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
endfunction

function settingloader#Jellybeans()
    let g:jellybeans_overrides = {
    \    'Todo': { 'guifg': '303030', 'guibg': 'f0f000',
    \              'ctermfg': 'Black', 'ctermbg': 'Yellow',
    \              'attr': 'bold' },
    \    'Comment': { 'guifg': '99ad6a' },
    \    'Statement': { 'guifg': 'fff187'},
    \    'cOperator': { 'guifg': 'fff187'},
    \    'Function': { 'guifg': '80bfff' },
    \    'Type': { 'guifg': 'b3ffb3' },
    \    'StorageClass': { 'guifg': '99ffd6' },
    \    'Title': { 'guifg': 'f0b3ff' },
    \    'Special': { 'guifg': 'ebccff' },
    \    'String': { 'guifg': 'ff99bb' }, 
    \    'background': { 'guibg': '000000' },
    \}    
    colorscheme jellybeans
    " Enables cursor line position tracking:
    set cursorline
    " Removes the underline causes by enabling cursorline:
    highlight clear CursorLine
    " Sets the line numbering to red background:
highlight CursorLineNR ctermfg=cyan

endfunction

function settingloader#Syntastic() 
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1 
    let g:syntastic_auto_loc_list = 1 
    let g:syntastic_check_on_open = 1 
    let g:syntastic_check_on_wq = 0 

    "syntax checkers
    let g:syntastic_javascript_checkers = ['jshint']
    let g:syntastic_python_checkers = ['flake8']
endfunction

function settingloader#MuComplete()
    set completeopt+=menuone
    set completeopt+=noselect
    set shortmess+=c   " Shut off completion messages
    set belloff+=ctrlg " If Vim beeps during completion
    "Turn off error Messages
    let g:mucomplete#no_popup_mappings = 1
    imap <c-y> <plug>(MUcompletePopupAccept)
    imap <cr> <plug>(MUcompleteCR)
endfunction 

function settingloader#Completor()
    let g:completor_clang_binary='/usr/bin/clang' "on Linux console: $ which clang
    let g:completor_python_binary='/usr/bin/python3' "on Linux console: $ which python3 
    let g:completor_node_binary = '/usr/bin/node' "on Linux console: $ which node
    autocmd FileType c,cpp,py,js inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    autocmd FileType c,cpp,py,js inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    autocmd FileType c,cpp,py,js inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
    set completeopt-=longest
    set completeopt+=menuone
    set completeopt-=menu
    if &completeopt !~# 'noinsert\|noselect'
        set completeopt+=noselect
    endif
    let g:completor_completion_delay=10
endfunction

function settingloader#PHPComplete()
    "Php autoindent has bugs and need to reenabled manually
    autocmd BufEnter *.php set autoindent 
    "Default mapping makes problems 
    let g:phpcomplete_mappings = {
    \ 'jump_to_def': '<C-]>',
    \ 'jump_to_def_split': '<C-D><C-]>',
    \ 'jump_to_def_vsplit': '<C-D><C-\>',
    \ 'jump_to_def_tabnew': '<C-D><C-[>',
    \}
endfunction

function settingloader#Javacomplete2()
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
endfunction

function settingloader#LuaComplete()
    let g:lua_compiler_name = '/usr/bin/luac'
    let g:lua_complete_omni = 1
endfunction

function settingloader#RubyComplete()
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 
    autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
    autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
endfunction

function settingloader#CppEnhancedHighlight()
    let g:cpp_class_scope_highlight = 1 
    let g:cpp_member_variable_highlight = 1 
    let g:cpp_class_decl_highlight = 1 
    let g:cpp_experimental_template_highlight = 1
    let g:cpp_concepts_highlight = 1
endfunction

function settingloader#VimOmniCompletion()
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    "autocm FileType javascript set omnifunc=tern#Complete
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
endfunction

function settingloader#Snippets()
    let g:UltiSnipsExpandTrigger="<c-k>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
endfunction

function settingloader#SearchTasks()
    let g:searchtasks_list=["TODO", "FIXME", "XXX"]
endfunction

function settingloader#OmniSharp()
    " OmniSharp won't work without this setting
    filetype plugin on

    "This is the default value, setting it isn't actually necessary
    let g:OmniSharp_host = "http://localhost:2000"

    "Set the type lookup function to use the preview window instead of the status line
    "let g:OmniSharp_typeLookupInPreview = 1

    "Timeout in seconds to wait for a response from the server
    let g:OmniSharp_timeout = 1

    "Showmatch significantly slows down omnicomplete
    "when the first match contains parentheses.
    set noshowmatch

    "don't autoselect first item in omnicomplete, show if only one item (for preview)
    "remove preview if you don't want to see any documentation whatsoever.
    set completeopt=longest,menuone,preview
    " Fetch full documentation during omnicomplete requests.
    " There is a performance penalty with this (especially on Mono)
    " By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
    " you need it with the :OmniSharpDocumentation command.
    " let g:omnicomplete_fetch_full_documentation=1

    "Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
    "You might also want to look at the echodoc plugin
    set splitbelow

    " Get Code Issues and syntax errors
    let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
    " If you are using the omnisharp-roslyn backend, use the following
    " let g:syntastic_cs_checkers = ['code_checker']
    augroup omnisharp_commands
        autocmd!

        "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
        autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

        " Synchronous build (blocks Vim)
        "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
        " Builds can also run asynchronously with vim-dispatch installed
        autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
        " automatic syntax check on events (TextChanged requires Vim 7.4)
        autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

        " Automatically add new cs files to the nearest project on save
        autocmd BufWritePost *.cs call OmniSharp#AddToProject()

        "show type information automatically when the cursor stops moving
        autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

        "The following commands are contextual, based on the current cursor position.

        autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
        autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
        autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
        autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
        autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
        "finds members in the current buffer
        autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
        " cursor can be anywhere on the line containing an issue
        autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
        autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
        autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
        autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
        "navigate up by method/property/field
        autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
        "navigate down by method/property/field
        autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

    augroup END


    " this setting controls how long to wait (in ms) before fetching type / symbol information.
    set updatetime=500
    " Remove 'Press Enter to continue' message when type information is longer than one line.
    set cmdheight=2

    " Contextual code actions (requires CtrlP or unite.vim)
    nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
    " Run code actions with text selected in visual mode to extract method
    vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

    " rename with dialog
    nnoremap <leader>nm :OmniSharpRename<cr>
    nnoremap <F2> :OmniSharpRename<cr>
    " rename without dialog - with cursor on the symbol to rename... ':Rename newname'
    command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    " Force OmniSharp to reload the solution. Useful when switching branches etc.
    nnoremap <leader>rl :OmniSharpReloadSolution<cr>
    nnoremap <leader>cf :OmniSharpCodeFormat<cr>
    " Load the current .cs file to the nearest project
    nnoremap <leader>tp :OmniSharpAddToProject<cr>

    " Start the omnisharp server for the current solution
    nnoremap <leader>ss :OmniSharpStartServer<cr>
    nnoremap <leader>sp :OmniSharpStopServer<cr>

    " Add syntax highlighting for types and interfaces
    nnoremap <leader>th :OmniSharpHighlightTypes<cr>
    "Don't ask to save when changing buffers (i.e. when jumping to a type definition)
    set hidden

    " Enable snippet completion, requires completeopt-=preview
    let g:OmniSharp_want_snippet=1

endfunction 
