"MIT License Copyright (c) 2018 Philip Mayer

"Mathematics
syntax match phpOperator '[\+\*/\-%]'

"Logical
syntax match phpOperator '[=<>!&|]'

"Other
syntax match phpOperator '[.,:;]'

"jQuery vary
syntax match phpOperator '\$'

" itterators (using simple regex):
syntax match phpOperator "[ijkl][=]"
syntax match phpOperator "[ijkl][+][+]"
syntax match phpOperator "[ijkl][-][-]"
syntax match phpOperator "[+][+][ijkl]"
syntax match phpOperator "[-][-][ijkl]" 

