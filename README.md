------
![](img/vimidelogo.png)
-------------------------------------------------------------------------------------------------------------
![](img/intro.png)
!Warning: This project is under active development!
----
1. [Introduction](#introduction) 
2. [Features](#features)
    1. [Autocompletion](#autocomp)  
    2. [Interface](#interface)
    3. [Syntax](#syntax)
    4. [Code Helper](#code_helper)
    5. [Debugging](#debugging)
    6. [Documentation](#documentation)
3. [Installation](#installation) 
    1. [Requirements](#requirements)  
    2. [Compileable Plugins](#compile) 
4. [Syntax Linter](#syntaxlinter)
5. [Debugger](#debugger) 
6. [Knowing issues](#issues) 
7. [Examples](#examples) 
8. [FAQ](#faq) 
9. [Project future](#future)
-----------------------------------------
<a name="introduction"></a>

## 1\. Introduction
TheVimIDE has the target to be a fully functional integrated development enviroment for the [Vim](www.vim.org) and [NeoVim](https://neovim.io/) editors. 
The offspring of TheVimIDE was a small plugin collection to make my daily work with Vim more comfortable. Over time and other IDEs as inspirations I 
had the idea to make Vim step by step to an IDE with all the features like autocompletion, syntax checking and many other features that makes programming
easier and faster. 

TheVimIDE has five major targets: 
* Combine fastness of a texteditor with comfort of IDE features
* Support as many popular languages as possible
* To be easy to configure
* To be fully functional out of the box 
* To be expandable and forkable 

<a name="features"></a> 

## 2\. Features 
Below you can the the most considerable features.

<a name="autocomp"></a> 
### 2.1\. Autocompletion
| Language      | Used Plugins                                                                            | Thirparty Tools |
| ------------- | ------------------------------------------------------------------------------------    | --------------- |
| C/C++         | [Completor](https://github.com/maralla/completor.vim)                                   | clang           |
| Java          | Completor, [JavaComplete2](https://github.com/artur-shaik/vim-javacomplete2)            |                 |
| Python        | Completor                                                                               | Jedi            |
| Ruby          | Completor, [vim-ruby-autocomplete](https://github.com/Shadowsith/vim-ruby-autocomplete) | Solargraph      |
| PHP           | Completor, [phpcomplete](https://github.com/shawncplus/phpcomplete.vim)                 | phpctags        |
| HTML          | Completor, [HTML5](https://github.com/othree/html5.vim)                                 |                 |
| CSS           | Completor                                                                               |                 |
| Lua           | [MUComplete](https://github.com/lifepillar/vim-mucomplete)                              |                 |
| All other     | MUComplete, [Gutentags](https://github.com/ludovicchabant/vim-gutentags)                |                 |

<a name="interface"></a>
### 2.2\. Interface
| Plugin | Description |
| ------ | ----------- |
| [vim-plug](https://github.com/junegunn/vim-plug)| plugin manager |
| [vim-airline](https://github.com/vim-airline/vim-airline) | modern vim user interface |
| [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | themes for vim airline |
| [NERDTree](https://github.com/scrooloose/nerdtree) | project explorer to navigate easy through your file tree |
| [NERDTree-Tabs](https://github.com/jistr/vim-nerdtree-tabs) | to use same NERDTree on each tab |
| [Tagbar](https://github.com/majutsushi/tagbar) | show all classes, functions and global variables in a side bar |
| [identLine](https://github.com/Yggdroot/indentLine) | Highlights line indentation |
| [Bookmarks](https://github.com/MattesGroeger/vim-bookmarks) | add line-bookmarks in your file |
| [DidYouMean](https://github.com/EinfachToll/DidYouMean) | asks for the right file to open when similiar files exists |

<a name="syntax"></a>
### 2.3\. Syntax
| Plugin | Description |
| ------ | ----------- |
| [Advances C++ Highlight](https://github.com/octol/vim-cpp-enhanced-highlight) | 
| [rainbow bracklets](https://github.com/luochen1990/rainbow) | better highlights brackets/blocks |
| [CSS Colors](https://github.com/ap/vim-css-color) | shows the color for html colors in code |
| [jellybeans](https://github.com/nanotech/jellybeans.vim) | color scheme |
| [Search Tasks](https://github.com/gilsondev/searchtasks.vim) | searching TODO, FIXME or other tags in your project |
| [PGSQL](https://github.com/lifepillar/pgsql.vim) | better highlights (Postgre) SQL files |

<a name="code_helper"></a>
### 2.4\. Code Helper
| Plugin | Description |
| ------ | ----------- |
| [auto-pair](https://github.com/jiangmiao/auto-pairs) | autocloses brackets and quotation marks |
| [closetag](https://github.com/alvan/vim-closetag) | autocloses (x)html/xml tags |
| [Commentary](https://github.com/tpope/vim-commentary.git) | fast comment/uncomment lines |
| [UtilSnips](https://github.com/SirVer/ultisnips) | snippet handler for vim |
| [vim-snippets](https://github.com/honza/vim-snippets) | snippets for many languages |

<a name="debugging"></a>
### 2.5\. Debugging
| Plugin | Description |
| ------ | ----------- |
| [Syntastic](https://github.com/vim-syntastic/syntastic) | shows syntax errors during programming |
| [SingleCompile](https://github.com/vim-scripts/SingleCompile) | compiling single files without closing vim |
| [ConqueGdb](https://github.com/vim-scripts/Conque-GDB) | Integrated gdb C/C++ debugger for vim |
| [Vdebug](https://github.com/vim-vdebug/vdebug.git) | Debugger for PHP, Python, Ruby, Perl, Tcl and NodeJS |

<a name="documentation"></a>
### 2.6\. Documentation
| Plugin | Description |
| ------ | ----------- |
| [VimWiki](https://github.com/vimwiki/vimwiki) | wiki system for vim |
| [vim-notes](https://github.com/xolox/vim-notes) | note system for vim |


<a name="installation"></a> 

## 3\. Installation
All you need to do is to run the ./install.sh for Vim or ./install-neovim.sh for NeoVim. 
You will be asked if you want to build/install a view features to get the whole functionality. 

<a name="requirements"></a> 

### 3.1\. Requirements
First of all make sure that your Vim / Neovim editor is compiled with python2 and python3 support. 
* For Arch Linux (and derivates) Vim is by default compiled with python support. 
* For Ubuntu/Debian install vim-nox

Upgrade Neovim (all Linux plattforms): 
* sudo pip2 install --upgrade neovim
* sudo pip3 install --upgrade neovim

You need to install these third party programs for the mentioned features: 
* __Clang__ for C-Familiy autocompletion
* __Jedi__ for Python autocompletion
* __npm, nodejs__ for (good) JavaScript autocompletion, default needs nothings
* __maven__ to build Java autocompletion at your own
* **ctags** for Vim-Gutentags support
* [__phpctags__](https://github.com/vim-php/phpctags) for better PHP autocompletion experience

#### Installing third party Requirements:
* Debian/Ubuntu: `sudo apt-get install clang nodejs python3 npm lua5.3 liblua5.3 maven`, for jedi: `sudo pip3 install jedi`
* Arch Linux: `sudo pacman -S clang nodejs python npm lua maven`, for jedi: `sudo pip3 install jedi`

The named OS above are tested

<a name="compile"></a> 

### Plugins you need compile at your own:

After execution of the install.sh script you can use the 
other install scripts in ./build for plugins that you need to build. 
* omnisharp__install.sh for C# autocompletion (not working now)
* java_install.sh for Java
* javascript_install.sh for Javascript

<a name="syntaxlinter"></a> 

## 4\. Syntax Linter
The default linter for following languages are:
* JavaScript: eslint, install it with `sudo npm install -g eslint`
* Python: flake8, install it with `sudo pip install flake8` 

If you want to change the checker of a language:
Edit Settingloader#Syntastic() at ~/.vim/autoload/settingloader.vim 
Change: `let g:syntastic_yourlanguage_checkers = ['yourchecker']` 

<a name="debugger"></a> 

## 5\. Debugger
Following debugger engines are installed by default: 
* ConqueGdb for C/C++ (gdb must be installed)
  * Call it with :ConqueGdb binaryfile -q 
* Vdbug, Debugger for Python, PHP, Ruby and Pearl (JavaScript is not working at this time)

For ConqueGdb I will write shorter command aliases.

Vdbug has a very good frontend but needs thrid party requirements for every single language. 
I will write serveral install scripts to make the installation of them very easy.
Until then you need to read the help under: :help VdbugSetUp 

<a name="issues"></a> 

## 6\. Knowing issuses

<a name="examples"></a> 

## 7\. Examples:

### C/C++

### Java

### Lua
![](gifs/lua_demo.gif)

### HTML
![](gifs/html_demo.gif)

### CSS

### PHP

### JavaScript

<a name="faq"></a> 

## 8\. FAQ

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

<a name="future"></a> 

## 9\. Project future
The project will be updated in irregular intervals.<br>
For feature request open a new issue with Topic: Request - your feature request.

The project documentation comes if time permits it.
