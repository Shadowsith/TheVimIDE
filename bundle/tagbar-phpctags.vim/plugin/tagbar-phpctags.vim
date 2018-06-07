if !exists('g:tagbar_phpctags_bin')
    if executable(expand("<sfile>:p:h").'/../phpctags/phpctags')
        let g:tagbar_phpctags_bin = expand("<sfile>:p:h").'/../phpctags/phpctags'
    elseif executable(expand("<sfile>:p:h").'/../bin/phpctags')
        let g:tagbar_phpctags_bin = expand("<sfile>:p:h").'/../bin/phpctags'
    elseif executable(expand("<sfile>:p:h").'/../phpctags')
        let g:tagbar_phpctags_bin = expand("<sfile>:p:h").'/../phpctags'
    else
        let g:tagbar_phpctags_bin = 'phpctags'
    endif
endif

if !exists('g:tagbar_phpctags_memory_limit')
    let g:tagbar_phpctags_memory_limit = '128M'
endif

let g:tagbar_type_php = {
    \ 'ctagsbin'  : tagbar_phpctags_bin,
    \ 'ctagsargs' : '--memory="' . tagbar_phpctags_memory_limit . '" -f -',
    \ 'kinds'     : [
        \ 'd:Constants:0:0',
        \ 'v:Variables:0:0',
        \ 'f:Functions:1',
        \ 'i:Interfaces:0',
        \ 'c:Classes:0',
        \ 'p:Properties:0:0',
        \ 'm:Methods:1',
        \ 'n:Namespaces:0',
        \ 't:Traits:0',
    \ ],
    \ 'sro'        : '::',
    \ 'kind2scope' : {
        \ 'c' : 'class',
        \ 'm' : 'method',
        \ 'f' : 'function',
        \ 'i' : 'interface',
        \ 'n' : 'namespace',
        \ 't' : 'trait',
    \ },
    \ 'scope2kind' : {
        \ 'class'     : 'c',
        \ 'method'    : 'm',
        \ 'function'  : 'f',
        \ 'interface' : 'i',
        \ 'namespace' : 'n',
        \ 'trait'     : 't',
    \ }
\ }
