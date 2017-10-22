function pluginhandler#Load() 
    let proof = expand('%:e')
    if proof != "c" || proof != "cpp" || proof != "php"
        mucompleteInit#Vimrc()        
    else 
        completorInit#Vimrc()
    endif
endfunction 
