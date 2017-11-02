function settingloader#Syntastic() 
"Syntatisc
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1 
    let g:syntastic_auto_loc_list = 1 
    let g:syntastic_check_on_open = 1 
    let g:syntastic_check_on_wq = 0 
endfunction

function settingloader#MuComplete()
    set completeopt+=menuone
    autocmd FileType vim,css,html,php,markdown,dict,text,xml,sh,java,csv,lua,make,unkown inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
    autocmd FileType vim,css,html,php,markdown,dict,text,xml,sh,java,csv,lua,make,unkown inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
    autocmd FileType vim,css,html,php,markdown,dict,text,xml,sh,java,csv.lua,make,unkown inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
    set completeopt+=noselect
    set shortmess+=c   " Shut off completion messages
    set belloff+=ctrlg " If Vim beeps during completion
endfunction 

function settingloader#Completor()
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
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
endfunction

