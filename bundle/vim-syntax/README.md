# vim_syntax_and_dictonary_collection

This git repository includes individual syntax highlightings and dictionaries for serveral languages. 

## content and function

This is not a plugin rather than a collection of several syntax highlighting files.

Vim includes automatically the right 'syntax.vim' by using the right file extensions. Only they need to be 'syntax on' in the .vimrc 

Following will be highlighted standardly:

- Brackets: "(), [], {}", --> seeing rainbow plugin, because this is the better solution, thanks to luochen1990
- Mathematics: "+ - ** % / < > =",
- Logical: "! | &"
- Others ". , : ; ",
- Classical Iterator variables "i,j,k,l"

## motivation

I like it to highlight key-characters in a language to see errors in a more convinient way and will give anyone a simple entry in lot used languages.

## support

I will support following languages firstly:
- C/C++
- C#
- Java
- Lua
- Python

## install

I recommend to install vim-pathogen and adding this to .vim/bundle/vim-syntax
Other way you can install it to ./vim/syntax, but i don't recommend this

## future

If I have time i would add key words for standard library functions like C's prinf or C++'s cout 
