"Mathematics
syntax match cOperator '[\+\*/\-%]'

"Logical
syntax match cOperator '[=<>!&|]'

"Other
syntax match cOperator '[.,:;]'

" itterators (using simple regex):
syntax match cOperator "[ijkl][=]"
syntax match cOperator "[ijkl][+][+]"
syntax match cOperator "[ijkl][-][-]"
syntax match cOperator "[+][+][ijkl]"
syntax match cOperator "[-][-][ijkl]" 

" keywords (must be activated)
"syntax match cOperator "printf"
"syntax match cOperator "scanf"


"Test

