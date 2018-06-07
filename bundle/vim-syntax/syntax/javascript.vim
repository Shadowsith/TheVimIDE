"MIT License Copyright (c) 2018 Philip Mayer

"Mathematics
syntax match javaScriptOperator '[\+\*/\-%]'

"Logical
syntax match javaScriptOperator '[=<>!&|]'

"Other
syntax match javaScriptOperator '[.,:;]'

"jQuery vary
syntax match javaScriptOperator '\$'

" itterators (using simple regex):
syntax match javaScriptOperator "[ijkl][=]"
syntax match javaScriptOperator "[ijkl][+][+]"
syntax match javaScriptOperator "[ijkl][-][-]"
syntax match javaScriptOperator "[+][+][ijkl]"
syntax match javaScriptOperator "[-][-][ijkl]" 

" keywords (must be activated)
syntax match javaScriptFunction "ready"

"Test


