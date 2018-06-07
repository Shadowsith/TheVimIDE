if exists("b:current_syntax")
	finish
endif

" Setup
setlocal isident=@,48-57,-,.,_,192-255

" Top level elements
syntax region tsComment keepend start="^\s*\/\*" end="^\s*\*\/.*$"
syntax region tsComment keepend start="^\s*#" end="$"
syntax region tsComment keepend start="\v^\s*\/\/" end="$"
syntax region tsInclude keepend start="\v^\s*\<" end="\v\>\s*$"
syntax region tsCondition keepend start="\v^\s*\[" end="\]\s*$"
syntax match tsSingleline "\v^\s*\i+\s*[=<>{].*$"
syntax region tsMultiline keepend start="\v^\s*\i+\s*\(\s*$"  end="\v^\s*\)\s*$"
syntax match tsDelimiter "\v^\s*\}\s*$"

" Resolving tsSingleline and Multiline
syntax region tsValue keepend matchgroup=tsLineOperator start="\v\=" end="\v$" contained containedin=tsSingleline
syntax region tsValue keepend matchgroup=tsDelimiter start="\v\(" end="\v^\s*\)\s*$" contained containedin=tsMultiline
syntax match tsIdentifier "\v^\s*\i+" contained containedin=tsSingleline,tsMultiline
syntax match tsLineOperator "\v[=<]" contained containedin=tsSymlink
syntax match tsSymlink "\v(\<|\=\s*\<)\s*\i+\s*$" contained containedin=tsSingleline
syntax match tsDelimiter "\v\{\s*$" contained containedin=tsSingleline
syntax match tsLineOperator "\v\>\s*$" contained containedin=tsSingleline
syntax match tsIdentifier "\v\i+\s*$" contained containedin=tsSymlink

" Sub level elements
syntax match tsDelimiter "\v[\[\]]" contained containedin=tsCondition
" This is one sign each hit, to give it a minimum priority.
syntax match tsValueString "\v\S" contained containedin=tsValue
syntax match tsValuePipe "\v\|" contained containedin=tsValue
" Detect numbers, but not those that are part of words.
syntax match tsNumber "\v(\a\d*)@<!\d(\d*\a)@!" contained containedin=tsValue
syntax region tsEval oneline keepend matchgroup=tsDelimiter start="\v\{" end="\v\}" contained containedin=tsValue,tsCondition,tsTagAttrValue
syntax match tsIdentifier "\v\$\i+" contained containedin=tsEval

syntax match tsTagMatch  "\v\<\/?\a+[^>]+\/?\>" contained containedin=tsValue
syntax region tsTag keepend matchgroup=tsDelimiter start="\v\<\/?" end="\v\/?\>" contained containedin=tsTagMatch
syntax match tsTagOperator "\v\=" contained containedin=tsTag
syntax region tsTagAttrValue matchgroup=tsDelimiter start="\v\"" end="\v\"" contained containedin=tsTag

" Keywords
syntax case ignore | syntax keyword tsTodo contained containedin=tsComment TODO
syntax case ignore | syntax keyword tsTodo contained containedin=tsComment xxx
syntax case match | syntax keyword tsObjectType contained containedin=tsValue CASE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue COA
syntax case match | syntax keyword tsObjectType contained containedin=tsValue COA_INT
syntax case match | syntax keyword tsObjectType contained containedin=tsValue CONTENT
syntax case match | syntax keyword tsObjectType contained containedin=tsValue EDITPANEL
syntax case match | syntax keyword tsObjectType contained containedin=tsValue FILE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue FILES
syntax case match | syntax keyword tsObjectType contained containedin=tsValue FLUIDTEMPLATE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue FORM
syntax case match | syntax keyword tsObjectType contained containedin=tsValue HMENU
syntax case match | syntax keyword tsObjectType contained containedin=tsValue HTML
syntax case match | syntax keyword tsObjectType contained containedin=tsValue IMAGE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue IMG_RESOURCE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue LOAD_REGISTER
syntax case match | syntax keyword tsObjectType contained containedin=tsValue PAGE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue RECORDS
syntax case match | syntax keyword tsObjectType contained containedin=tsValue RESTORE_REGISTER
syntax case match | syntax keyword tsObjectType contained containedin=tsValue SVG
syntax case match | syntax keyword tsObjectType contained containedin=tsValue TEMPLATE
syntax case match | syntax keyword tsObjectType contained containedin=tsValue TEXT
syntax case match | syntax keyword tsObjectType contained containedin=tsValue USER
syntax case match | syntax keyword tsObjectType contained containedin=tsValue USER_INT

" Link groups
highlight link tsComment Comment
highlight link tsCondition Conditional
highlight link tsDelimiter Delimiter
highlight link tsIdentifier Identifier
highlight link tsInclude Include
highlight link tsNumber NONE
highlight link tsLineOperator Operator
highlight link tsTodo Todo
highlight link tsValuePipe Delimiter
highlight link tsValueString String
highlight link tsTag Identifier
highlight link tsTagOperator Operator
highlight link tsTagAttrValue String
highlight link tsObjectType Type

let b:current_syntax = "typoscript"

