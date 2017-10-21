function compa#Check()
    let proof = expand('%:e')
    if proof != "c" || proof != "cpp" || proof != "php"
        call muInit#Vimrc()
    else 
        call completorInit#Vimrc() 
    endif
endfunction 
