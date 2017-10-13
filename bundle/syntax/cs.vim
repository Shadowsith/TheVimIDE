"Mathematics
syntax match csConditional '[\+\*/\-%]'

"Logical
syntax match csConditional '[=<>!&|]'

"Other
syntax match csConditional '[.,:;]'

" itterators (using simple regex):
syntax match csConditional "[ijkl][=]"
syntax match csConditional "[ijkl][+][+]"
syntax match csConditional "[ijkl][-][-]"
syntax match csConditional "[+][+][ijkl]"
syntax match csConditional "[-][-][ijkl]" 

" keywords (must be activated)


