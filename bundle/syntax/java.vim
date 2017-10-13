"Mathematics
syntax match javaOperator '[\+\*/\-%]'

"Logical
syntax match javaOperator '[=<>!&|]'

"Other
syntax match javaOperator '[.,:;]'

" itterators (using simple regex):
syntax match javaOperator "[ijkl][=]"
syntax match javaOperator "[ijkl][+][+]"
syntax match javaOperator "[ijkl][-][-]"
syntax match javaOperator "[+][+][ijkl]"
syntax match javaOperator "[-][-][ijkl]" 

" keywords (must be activated)


