#!/bin/bash
echo Checking if npm is installed
ruby="$(command -v ruby)"
path="/usr/bin/ruby"
if [ "$ruby" == "$path" ]
    then
        echo Found ruby
        echo Install solargraph and requirements
        gem install solargraph rdoc rubocop rufo irb yarn
        exit 0
    else
        echo Ruby is not installed!
        echo Please install Ruby to use Ruby autocompletion.
        exit 1
fi
