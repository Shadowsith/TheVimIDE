echo Installing Shadowsith/vim-plugin-collection
echo Firstly pull all submodules:
git submodule update --init --recursive
git submodule update --recursive
echo "Do you want to delete old neovim-files? [y/n]"
ask="a"
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            rm -f ~/.config/nvim/init.vim
            rm -rf ~/.config/nvim/plugged
            rm -rf ~/.config/nvim/bundle
            rm -rf ~/.local/share/nvim/site/autoload/
            mkdir -p ~/.config/nvim
            mkdir -p ~/.local/share/nvim/site
            echo The old neovim files have been deleted!
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            echo Nothing has been deleted, installtion aborted!
            exit 1
        else
            echo Input was not correct
            echo "Do you want to delete old vim-files? [y/n]"
    fi
done
echo Initialize vim-plug pluginmanager
cp ./vim-plug/plug.vim ./autoload/
cp -a ./autoload/ ~/.local/share/nvim/site/autoload/
echo Copy/Rename vim-plugin-collection to ~/.config/nvim/
cp -a ./bundle/* ~/.config/nvim/bundle
echo Copy .vimrc to .vimrc 
cp ./.vimrc ~/.config/nvim/init.vim
echo Copy .tern-config to ~/.tern-config
cp ./.tern-config ~/.tern-config
echo "Do you want to install Java autocompletion? [y/n]" 
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            ./build/java_install.sh nvim 
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
            ./build/javascript_tern_install.sh nvim
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
            ./build/omnisharp_install.sh nvim
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
            ./build/tagbar_ctags_install.sh nvim
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
