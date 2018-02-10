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
* Snippets for many languages 
* Autoclose brackets and quotation marks
* Settingloader in autoload to prefend a to big .vimrc


## Third Party Requirements:
* __Clang__ for C-Familiy autocompletion
* __Jedi__ for Python autocompletion
* __npm, nodejs__ for (good) JavaScript autocompletion, default needs nothings
* __maven__ to build Java autocompletion at your own
* [__phpctags__](https://github.com/vim-php/phpctags) for better PHP autocompletion experience


## Installing thrird party Requirements:

### Clang, npm, nodejs, lua, maven:
* Debian/Ubuntu: `sudo apt-get install clang nodejs npm lua5.3 liblua5.3 maven`
* Arch Linux: `sudo pacman -S clang nodejs npm lua maven`

The named OS above are tested

## Plugins you need compile at your own:
After execution of the install.sh script you can use the 
other install scripts for plugins that you need to build. 
* omnisharp__install.sh for C# autocompletion 
* java_install.sh for Java
* javascript_install.sh for Javascript

## Working autocompletion

* C/C++ (Completor+clang) 
* Java (JavaComplete2)
* HTML5 (MuComplete)
* CSS (MuComplete)
* PHP (Completor+phpctags)
* JavaScript (Competor+tern)
* Lua (Lua ftp plugin)
* C# (MuComplete+OmniSharp-vim) 

## Upcoming autocompleton

* Python (Completor+Jedi)
* Rust (Completor+racer)

## Knowing issuses 
### C# omnicompletion does not work
If C# completion does not work after executing the omnisharp_install script 
you have to add a empty .sln (Visual Studio Solution) file to your C# projecti or working folder. 
I don't know why but then is works. 

## Examples (ttyrecord) coming soon

### C/C++

### Java

### Lua

### HTML

### CSS

### PHP

### JavaScript

## FAQ:

Why I use different autocompletion plugins?
* I have tested several plugins and each has pros and cons.
  * µComplete is very good for most filetypes (e.g html,css), but it needs extra plugins for using C/C++ autocompletion and it was very slow. It also is very compatible with vim ommicompletions. The harmony between mucomplete and the OmniSharp-Server is also great.
  * Completor on the other hand is very good for C/C++ (much faster than µComplete with clang-complete), PHP, Pyhton (Jedi) and Javascript

Why I don't use YouCompleteMe?
* YCM is a good solution if you are lazy to configurate vim like my vim-plugin-collection and on the other hand it works very well, but:
* I and others users has sometimes build problems with YCM
* The omnicomplete server ycmd can also make problems if it crashes (no autocompletion then) 
* Basic install is much bigger then vim-plugin-collection (and it is only autocompletion) 
    * I don't want to blow out the collection to hundrets of megabyte 
* C# completion is not as smart then my solution 
* Web programming is not supported

## The future of the vim-plugin-collection
The VPC is a all in one solution but some people need only a part of it.
When I have more time I will make a series of VIM-IDEs for webprogramming,
compiler based programming and script based programming. 
I will also rename the VPC to a name that fits better to a all in one IDE.
