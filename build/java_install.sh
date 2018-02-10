#!/bin/bash
echo Checking if npm is installed
npm="$(command -v mvn)"
path="/usr/bin/mvn"
if [ "$npm" = "$path" ]
    then
        echo Found maven
        echo Build vim-javacomplete2
        cd ~/.vim/bundle/vim-javacomplete2/libs/javavi/
        mvn compile 
        exit 0
    else
        echo maven is not installed!
        echo Please install maven to use java autocompletion.
        exit 1
fi
