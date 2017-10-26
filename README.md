# vim-plugin-collection

This collection several useful tools to make your programming with vim easier.
It is in a very early phase, so the installation or plugin-compatiblities could be buggy

* vim-plug, add plugins in a easy way and perevents on autocompletion conflicts
* rainbow bracklets to show which paranthesis are which block 
* Syntastic to for test-compiling and show syntax errors during programming
* SimpleCompile to run fast test compilings without closing vim
* Nerdtree to have a integrated file manager 
* Small Syntax Highlights by myself
* Advanced Syntax Highlighting for: C++

![Demo](https://asciinema.org/a/5c5heWdCvueximdH5wBd3Yz4G)

## Third Party Requirements:
* __Clang__ for C-Familiy autocompletion
* __Jedi__ for Python autocompletion
* __npm__ for JavaScript autocompletion 
* __maven__ to build Java autocompletion at your own

## Working autocompletion

* C/C++ 
* Java 
* HTML
* CSS
* PHP
* JavaScript 
* Lua

# Upcoming autocompleton

* Python (Completor+Jedi)
* JavaScript (Completor+npm+tern)
* Rust (Completor+racer)

# Future autocompletions

* C# (if i can get a smart solution)


## FAQ:

Why I use different autocompletion plugins?
* I have tested several plugins and each has pros and cons.
  * µComplete is very good for most filetypes (e.g html,php,css), but it needs extra plugins for using C/C++ autocompletion and it was very slow. It also is very compatible with vim ommicompletions
  * Completor on the other hand is very good for C/C++ (much faster than µComplete with clang-complete), Pyhton (Jedi) and Javascript

Why I don't use YouCompleteMe?
* YouCompleteMe is great but it is awful to install and I want to make a collection in mind of the KISS principle.



