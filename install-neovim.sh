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
cp -a ./autoload/ ~/.local/share/nvim/site/autoload/
echo Copy/Rename vim-plugin-collection to ~/.vim/
cp -a ./bundle ~/.config/nvim/bundle
echo Copy .vimrc to .vimrc 
cp ./.vimrc ~/.config/nvim/init.vim
echo Finished!
