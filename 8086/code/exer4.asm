name "exer4" 

        PRINT macro message    
        push ax             ;print a message on screen   
        push dx             
        mov dx, offset message
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm
        
        
begin:  mov cl,20
        mov dl,20
        mov bx,0800h  
        
read:                       ;read all the valid inputs, store on memory
        call readchar      
        mov [bx],al         
        inc bx
        loop read
          
        PRINT newline
        mov cl,dl
        mov bx,0800h
               
write:                      ;print the numbers from the memory
        mov al,[bx]         ;change letters before we print them
        inc bl                
        cmp al,97           
        jc nmbr
        cmp al,123
        jnc nmbr
        sub al,32   
        
nmbr:
        mov ah,0eh      
        int 10h  
        loop write
        
        PRINT newline
        jmp begin   
        
end1:
        hlt               

        newline db 0Dh,0Ah, "$" 
                  
        
        
        erase_char proc     ;erase the last printed char
        push ax             
        mov ah,0eh
        mov al,8           
        int 10h
        mov al,32           
        int 10h
        mov al,8           
        int 10h
        pop ax 
        ret 
        
        
                  
        readchar proc        ;read one char and store it at al if it's valid 
readagain:                  
        mov ah, 1            ;if it's not valid read again
        int 21h
        cmp al,61            ;if input is =   terminate program
        je end1 
        cmp al,13            ;if input is ENTER =>  stop reading
        jne enternot         ;make cl=1 and store at dl the number of chars that we read 
        mov dl,20            
        sub dl,cl
        mov cl,1 
        cmp dl,0             ;check if enter pressed 
        jne norestart      
        PRINT newline
        jmp begin 
        
norestart:       
        jmp correctinpt 
        
enternot:
        cmp al,48
        jc wronginpt
        cmp al,58
        jnc wrongnew
        jmp correctinpt 
        
wrongnew:
        cmp al,97
        jc wronginpt
        cmp al,123
        jnc wronginpt
        jmp correctinpt
        
wronginpt:
        call erase_char     ;erase invalid char
        jmp readagain  
        
correctinpt:
        ret
                      
        endp