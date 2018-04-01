#!/bin/bash

# Supportet Distros: 
# Debian, Ubuntu, Linux Mint, Fedora, CentOS, openSUSE, Arch Linux
# If something goes wrong on your OS please write an github issue or an email 

# Shows if the program exists
programExists () {
    if [[ $(command -v $1) ]]; then
        echo "$1 is installed"
    else
        $2
    fi 
}

# Shows if a package is installed
packageExists () {
    if [[ $1 ]]; then
        echo "$3 is installed"
    else
        $2
    fi
}

# Search through pip python package manager
pythonPackageExists () {
    if [[ $(pip3 list --format=legacy | grep $1) ]]; then
        echo "$1 is installed" 
    else
        $2
    fi
}

# Search through npm nodejs package manager
nodePackageExists () {
    if [[ $(npm list -g $1 | grep $1) ]]; then
        echo "$1 is installed"
    else
        $2
    fi
}

# For Debian based systems 
if [[ $(command -v apt) ]]; then
    if [[ $(lsb_release -is)=="Debian" ]]; then
        echo Debian detected
        programExists "vim" "sudo apt-get install vim-nox" 
        programExists "gcc" "sudo apt-get install gcc"
        programExists "gdb" "sudo apt-get install gdb" 
        programExists "clang" "sudo apt-get install clang"
        programExists "python3" "sudo apt-get install python3" 
        programExists "pip" "sudo apt-get install python-pip"
        programExists "node" "sudo apt-get install nodejs"
        # In Debian 9 npm is integrated in nodejs..
        programExists "npm" "sudo apt-get install npm"
        programExists "ctags" "sudo apt-get install exuberant-ctags" 
        programExists "php" "sudo apt-get install php" 
        programExists "lua" "sudo apt-get install lua5.3 liblua5.3" 
        pythonPackageExists "flake8" "sudo pip3 install flake8"
        nodePackageExists "jshint" "sudo npm install -g jshint" 
        echo Installation finished!  
        exit 0 
    fi
    if [[ $(lsb_release -is)=="Ubuntu" ]]; then
        echo Ubuntu detected
        programExists "vim" "sudo apt-get install vim" 
        programExists "gcc" "sudo apt-get install gcc"
        programExists "gdb" "sudo apt-get install gdb" 
        programExists "clang" "sudo apt-get install clang"
        programExists "python3" "sudo apt-get install python3" 
        programExists "pip" "sudo apt-get install python3-pip"
        programExists "node" "sudo apt-get install nodejs"
        programExists "npm" "sudo apt-get install npm"
        programExists "ctags" "sudo apt-get install exuberant-ctags" 
        programExists "php" "sudo apt-get install php" 
        programExists "lua" "sudo apt-get install lua5.3 liblua5.3" 
        pythonPackageExists "flake8" "sudo pip3 install flake8"
        nodePackageExists "jshint" "sudo npm install -g jshint" 
        echo Installation finished!  
        exit 0
    fi 
    if [[ $(lsb_release -is)=="LinuxMint" ]]; then 
        echo Linux Mint detected
        programExists "vim" "sudo apt-get install vim" 
        programExists "gcc" "sudo apt-get install gcc"
        programExists "gdb" "sudo apt-get install gdb" 
        programExists "clang" "sudo apt-get install clang"
        programExists "python3" "sudo apt-get install python3" 
        programExists "pip" "sudo apt-get install python3-pip"
        programExists "node" "sudo apt-get install nodejs"
        programExists "npm" "sudo apt-get install npm"
        programExists "ctags" "sudo apt-get install exuberant-ctags" 
        programExists "php" "sudo apt-get install php" 
        programExists "lua" "sudo apt-get install lua5.3 liblua5.3" 
        pythonPackageExists "flake8" "sudo pip3 install flake8"
        nodePackageExists "jshint" "sudo npm install -g jshint" 
        echo Installation finished!  
        exit 0
    fi
fi 

# For Fedora 
if [[ $(command -v dnf) ]]; then
    programExists "vim" "sudo dnf install vim" 
    programExists "gcc" "sudo dnf install gcc"
    programExists "gdb" "sudo dnf install gdb"
    programExists "clang" "sudo dnf install clang"
    programExists "python3" "sudo dnf install clang" 
    programExists "pip" "sudo dnf install python3-pip"
    programExists "node" "sudo dnf install nodejs"
    programExists "npm" "sudo dnf install npm" 
    programExists "ctags" "sudo dnf install ctags"
    programExists "php" "sudo dnf install php"
    programExists "lua" "sudo dnf install lua lua-libs"
    pythonPackageExists "flake8" "sudo pip3 install flake8"
    nodePackageExists "jshint" "sudo npm install -g jshint" 
    echo Installation finished!  
    exit 0
fi


# For other RedHat based systems
if [[ $(command -v yum) ]]; then
    if [[ -f /etc/centos-release ]]; then
        echo CentOS
        programExists "vim" "sudo yum install vim-enhanced" 
        programExists "gcc" "sudo yum install gcc"
        programExists "gdb" "sudo yum install gdb" 
        programExists "clang" "sudo yum install clang"
        programExists "python3" "sudo yum install python36u"
        programExists "pip" "sudo yum install python36u-pip"
        programExists "node" "sudo yum install nodejs"
        programExists "ctags" "sudo yum install ctags"
        programExists "php" "sudo yum install php" 
        programExists "lua" "sudo yum install lua5.3 liblua5.3"
        pythonPackageExists "flake8" "sudo pip3 install flake8"
        nodePackageExists "jshint" "sudo npm install -g jshint" 
        exit 0
    fi
fi

# For Open Suse
if [[ $(command -v zypper) ]]; then
    echo Open Suse detected
    programExists "vim" "sudo zypper install vim-enhanced"
    programExists "clang" "sudo zypper install llvm-clang"
    programExists "node" "sudo zypper install nodejs"
    programExists "python3" "sudo zypper install python3"
    programExists "gdb" "sudo zypper install gdb" 
    programExists "ctags" "sudo zypper install ctags"
    programExists "php" "sudo zypper install php" 
    programExists "lua" "sudo zypper install lua"
    pythonPackageExists "flake8" "sudo pip3 install flake8"
    nodePackageExists "jshint" "sudo npm install -g jshint" 
    echo Installation finished!  
    exit 0
fi

# For Arch Linux and derivates
if [[ $(command -v pacman) ]]; then
    echo Arch Linux detected
    programExists "yaourt" "sudo pcmann -S yaourt"
    programExists "vim" "sudo pacman -S vim"
    programExists "clang" "sudo pacman -S clang" 
    programExists "node" "sudo pacman -S nodejs"
    programExists "npm" "sudo pacmman -S npm" 
    programExists "gdb" "sudo pacman -S gdb" 
    programExists "python" "sudo pacman -S pyhton" 
    programExists "pip" "sudo pacman -S python-pip" 
    programExists "php" "sudo pacman -S php"
    programExists "lua" "sudo pacman -S lua"
    programExists "ctags" "sudo pacman -S ctags" 
    programExists "phpctags" "yaourt -S phpctags"
    packageExists "pacman -Q | grep universal-ctags" "yaourt -S universal-ctags" "universial-ctags" 
    pythonPackageExists "flake8" "sudo pip install flake8"
    nodePackageExists "jshint" "sudo npm install -g jshint" 
    echo Installation finished!  
    exit 0
fi

