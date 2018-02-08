#!/bin/bash
echo Checking if npm is installed
npm="$(command -v npm)"
path="/usr/bin/npm"
if [ "$npm" = "$path" ]
    then
        echo Found npm
        echo Build tern
        cd ~/.vim/bundle/tern_for_vim/
        npm install
        exit 0
    else
        echo npm is not installed!
        echo Please install npm and node.js to use better JS completion.
        exit 1
fi
