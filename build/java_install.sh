#!/bin/bash
echo Checking if npm is installed
npm="$(command -v mvn)"
path="/usr/bin/mvn"
if [ "$npm" = "$path" ]
    then
        echo Found maven
        echo Build vim-javacomplete2
        if [ \($1 == "vim" \) -o \( $1 == "" \) ]; 
            then
                cd ~/.vim/bundle/vim-javacomplete2/libs/javavi/
                mvn compile 
            else
                cd ~/.config/nvim/bundle/vim-javacomplete2/libs/javavi/
                mvn compile 
        fi
        exit 0
    else
        echo maven is not installed!
        echo Please install maven to use java autocompletion.
        exit 1
fi
