#!/bin/bash
echo Checking if npm is installed
py="$(command -v python)"
path="/usr/bin/python"
if [ "$py" == "$path" ]
    then
        echo Found python
        echo Install jedi
        sudo pip install jedi
        exit 0
    else
        echo python is not installed!
        echo Please install python to use python autocompletion.
        exit 1
fi
