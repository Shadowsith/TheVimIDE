#!/bin/bash 
echo Checking if mono is installed..
mono="$(command -v mono)"
path="/usr/bin/mono"
if [ "$mono" = "$path" ] 
    then
        echo Found mono 
        echo Installing OmniSharp autocompletion...
        echo Build vimproc.vim 
        make -C ~/.vim/bundle/vimproc.vim/
        echo Build OmniSharp Server
        cd ~/.vim/bundle/omnisharp-vim/server/
        xbuild 
        exit 0
    else 
        echo Mono is not installed!
        echo Please install mono to use C# autocompletion.
        exit 1
fi

