"MIT License Copyright (c) 2018 Philip Mayer

"Mathematics
syntax match luaOperator '[\+\*/\-%]'

"Logical
syntax match luaOperator '[=<>!&|]'

"Other
syntax match luaOperator '[.,:;]'

" itterators (using simple regex):
syntax match luaOperator "[ijkl][=]"
syntax match luaOperator "[ijkl][+][+]"
syntax match luaOperator "[ijkl][-][-]"
syntax match luaOperator "[+][+][ijkl]"
syntax match luaOperator "[-][-][ijkl]" 

" keywords (must be activated)
"syntax match luaFunc "Index"
"syntax match luaFunc "Values"

"Test
"syntax match luaFunc /This\_.*text/


