echo Installing ctags to see Methods of file

if [ $1 == "vim" ]; 
    then
        cd ~/.vim/ctags/ 
    else
        cd ~/.nvim/ctags/
fi
./autogen.sh 
./configure 
make 
sudo make install 
