echo Installing Shadowsith/vim-plugin-collection
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
            echo This is be done!
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
cp ./vim-plug/plug.vim ./autoload/
echo Copy/Rename vim-plugin-collection to ~/.vim/
cp -a ../vim-plugin-collection ~/.vim/
echo Copy .vimrc to ~/.vimrc 
cp ./.vimrc ~/.vimrc
echo Copy .tern-config to ~/.tern-config
cp ./.tern-config ~/.tern-config
echo Finished!
