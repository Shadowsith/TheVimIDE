"Mathematics
syntax match cppOperator '[\+\*/\-%]'

"Logical
syntax match cppOperator '[=<>!&|]'

"Other
syntax match cppOperator '[.,:;]'

" itterators (using simple regex):
syntax match cppOperator "[ijkl][=]"
syntax match cppOperator "[ijkl][+][+]"
syntax match cppOperator "[ijkl][-][-]"
syntax match cppOperator "[+][+][ijkl]"
syntax match cppOperator "[-][-][ijkl]" 

" keywords (must be activated)

"Test


