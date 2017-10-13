echo Installing shadows vim-plugin-collection
echo "Do you want to delete old vim-files? [y/n]"
ask="a"
while [ \( "$ask" != "y" \) -o \( "$ask" != "n" \) -o \( "$ask" != "Y" \) -o \( "$ask" != "N" \) ]
do
    read -r ask
    if [ \( $ask == "y" \) -o \( $ask == "Y" \)  ];
        then
            #rm -f ~/.vimrc
            #rm -rf ~/.vim/
            echo this would be done!
            break
    fi 
    if [ \( $ask == "n" \) -o \( $ask == "N" \)  ];
        then
            echo nothing has deleted, installtion aborted
            exit 1
        else
            echo input was not correct
            echo "Do you want to delete old vim-files? [y/n]"
    fi
done
echo Adding pathogen to autoload:
cp ./vim-pathogen/autoload/pathogen.vim ./autoload
echo Copy/Rename vim-plugin-collection to ~/.vim/
cp ../vim-plugin-collection ~/.vim/
echo Copy .vimrc to .vimrc 
cp ./.vimrc ~/.vimrc
echo Finished!
