let g:numbers = 0
function hotkeys#LineNumbers()
    if g:numbers == 0
        set nonu
        let g:numbers = 1
        echo "Line numbers off"
    else
        set nu
        let g:numbers = 0
        echo "Line numbers on"
    endif
endfunction

let g:autoIndent = 0
function hotkeys#AutoIndent()
    if g:autoIndent == 0
        set noai
        let g:autoIndent = 1
        echo "Autoindent off"
    else
        set ai
        let g:autoIndent = 0
        echo "Autoindent on"
    endif
endfunction

