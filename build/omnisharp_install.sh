#!/bin/bash 
echo Checking if mono is installed..
mono="$(command -v mono)"
path="/usr/bin/mono"
if [ "$mono" = "$path" ] 
    then
        echo Found mono 
        echo Installing OmniSharp autocompletion...
        if [ \($1 == "vim" \) -o \( $1 == "" \) ]: 
            then
                echo Build vimproc.vim 
                cd ~/.vim/bundle/vimproc.vim/
                make 
                echo Build OmniSharp Server
                cd ~/.vim/bundle/omnisharp-vim/server/
                xbuild 
            else
                echo Build vimproc.vim 
                cd ~/.config/nvim/bundle/vimproc.vim/ 
                make
                echo Build OmniSharp Server
                cd ~/.config/nvim/bundle/omnisharp-vim/server/ 
                xbuild 
        fi
        exit 0
    else 
        echo Mono is not installed!
        echo Please install mono to use C# autocompletion.
        exit 1
fi

