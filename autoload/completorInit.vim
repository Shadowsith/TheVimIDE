function completorInit#Vimrc()
        call vundle#begin()
        Plugin 'VundleVim/Vundle.vim'
        Plugin 'vim-syntastic/syntastic'
        Plugin 'luochen1990/rainbow'
        Plugin 'Shadowsith/vim-syntax'
        Plugin 'vim-scripts/SingleCompile'
        "Plugin 'lifepillar/vim-mucomplete'
        Plugin 'lifepillar/pgsql.vim'
        Plugin 'lifepillar/vim-cheat40'
        Plugin 'octol/vim-cpp-enhanced-highlight'
        Plugin 'maralla/completor.vim'
        Plugin 'scrooloose/nerdtree'
        call vundle#end()

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

        "pgsql Plugin
        "let g:sql_type_default = 'pgsql' "If you want use this plugin for all sql files

        "vim-cpp-enhanced-highlight
        let g:cpp_class_scope_highlight = 1
        let g:cpp_member_variable_highlight = 1
        let g:cpp_class_decl_highlight = 1
        let g:cpp_experimental_template_highlight = 1
        let g:cpp_concepts_highlight = 1

        "completor
        let g:completor_clang_binary='/usr/bin/clang'
        inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
        set completeopt-=longest
        set completeopt+=menuone
        set completeopt-=menu
        if &completeopt !~# 'noinsert\|noselect'
            set completeopt+=noselect
        endif
endfunction

