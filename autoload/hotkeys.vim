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

let g:indentLine = 0
function hotkeys#IndentLine()
    if g:indentLine == 0
        exec IndentLinesDisable  
        let g:indentLine = 1
        echo "IndentLines off"
    else
        exec IndentLinesEnable 
        let g:indentLine = 0
        echo "IndentLines on"
    endif
endfunction 

"you can change this to colorschmes of your choice
"you can also add more conditions to switch through more 
"themes
let g:schemeChanger = 0
function hotkeys#ColorSchemeChanger()
    if g:schemeChanger == 0
        colorscheme flattened_light 
        let g:schemeChanger = 1
        echo "Colorscheme changed"
    else
        colorscheme flattened_dark 
        let g:schemeChanger = 0
        echo "Colorscheme changed"
    endif
endfunction
