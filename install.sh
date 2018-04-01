echo Installing TheVimIDE
echo Firstly pull all submodules:
git submodule update --init --recursive
git submodule update --recursive
echo "Do you want to delete old vim-files? [y/n]"
ask="a"
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            rm -f ~/.vimrc
            rm -rf ~/.vim/
            mkdir ~/.vim/
            echo The old vim files have been deleted!
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            echo nothing has deleted, installtion aborted
            exit 1
        else
            echo Input was not correct
            echo "Do you want to delete old vim-files? [y/n]"
    fi
done
echo Initialize vim-plug pluginmanager
cp -f ./vim-plug/plug.vim ./autoload/
echo Copy/Rename TheVimIDE to ~/.vim/
cp -a ./* ~/.vim/
echo Copy .vimrc to ~/.vimrc 
cp ./.vimrc ~/.vimrc
rm -f ~/.vim/.vimrc 
echo Copy .tern-config to ~/.tern-config
cp ./.tern-config ~/.tern-config
rm -f ~/.vim/.tern-config 
echo "Do you want to install Java autocompletion? [y/n]" 
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            ./build/java_install.sh 
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            break 
        else
            echo Input was not correct
            echo "Do you want to install Java autocompletion? [y/n]"
    fi
done
echo "Do you want to install JavaScript autocompletion? [y/n]"
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            ./build/javascript_tern_install.sh  
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            break 
        else
            echo Input was not correct
            echo "Do you want to install JavaScript autocompletion? [y/n]"
    fi
done
echo "Do you want to install C# autocompletion? [y/n]"
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            ./build/omnisharp_install.sh  
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            break 
        else
            echo Input was not correct
            echo "Do you want to install C# autocompletion? [y/n]"
    fi
done
echo "Do you want to install Vim-Tagbar (shows a function bar at the left side)? [y/n]"
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            ./build/tagbar_ctags_install.sh  
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            break 
        else
            echo Input was not correct
            echo "Do you want to install Vim-Tagbar (shows a function bar at the left side)? [y/n]"
    fi
done
echo Finished!
exit 0
