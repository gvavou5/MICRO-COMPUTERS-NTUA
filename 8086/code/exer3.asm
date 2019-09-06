name "exer3" 

        PRINT macro message    
        push ax             ;prints a message on screen    
        push dx             
        mov dx, offset message
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm
         
         
read:         
        PRINT input         

readagain:                  ;all routines are called here
        call readdec       
        cmp al,0            ;if first digit is zero
        je readagain        ;if is xero we have to read it again 
        mov cl,al           
        call readdec
        mov dl,10 
        mov bl,al
        mov al,cl
        mul dl
        add bl,al
        
        PRINT newline      
        call printdec
        PRINT equal
        call printhex
        PRINT equal
        call printoct
        PRINT equal
        call printbin
        PRINT newline
        jmp read:
        hlt

         
        newline db 0Dh,0Ah, "$"        
        equal db " = $"
        input db "Insert a valid input: $"
        
         
        erase proc      ;erase the last printed char
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
           
        
        printdec proc
        push dx         ;shows a number on screen
        push cx      
        push bx         
        push ax         ;the result is decimal  because the base is 10
        mov bh,0        
        mov dx,0        
        cmp bl,0h
        je  enddec
        mov cx,10      
        mov ax,bx
        div cx      
        mov bx,ax       
        push dx
        call printdec
        pop dx
        mov bl,dl
        cmp bl,0ah
        jnc notdecnumber
        add bl,48
        jmp decnumber  
        
notdecnumber:
        add bl,55   
        
decnumber:      
        mov al,bl
        mov ah,0eh      
        int 10h  
        
enddec:      
        pop ax
        pop bx 
        pop cx
        pop dx
        ret 
        
        
        printhex proc
        push dx         ;shows a number on screen
        push cx         
        push bx         
        push ax         ;the result is hexadecimal  because the base is 16
        mov bh,0       
        mov dx,0        
        cmp bl,0h
        je  endhex
        mov cx,10h      
        mov ax,bx
        div cx
        mov bx,ax
        push dx
        call printhex
        pop dx
        mov bl,dl
        cmp bl,0ah
        jnc nothexnumber
        add bl,48
        jmp hexnumber  
        
nothexnumber:
        add bl,55     
        
hexnumber:      
        mov al,bl
        mov ah,0eh      
        int 10h       
        
endhex:
        pop ax
        pop bx 
        pop cx
        pop dx
        ret 
        
        
        
        printoct proc
        push dx         ;shows a number on screen
        push cx         
        push bx         
        push ax         ;the result is octal because the base is 8 
        mov bh,0        
        mov dx,0        
        cmp bl,0h
        je endoct
        mov cx,8        
        mov ax,bx
        div cx
        mov bx,ax
        push dx
        call printoct
        pop dx
        mov bl,dl
        cmp bl,0ah
        jnc notoctnumber
        add bl,48
        jmp octnumber 
        
notoctnumber:
        add bl,55    
        
octnumber:           
        mov al,bl
        mov ah,0eh      
        int 10h  
endoct:         

        pop ax
        pop bx 
        pop cx
        pop dx
        ret   
        

        
        printbin proc
        push dx         ;shows a number on screen
        push cx         
        push bx         
        push ax         ;the result is binary because the base is 2
        mov bh,0        
        mov dx,0        
        cmp bl,0h
        je  end_bin
        mov cx,2        
        mov ax,bx
        div cx
        mov bx,ax
        push dx
        call printbin
        pop dx
        mov bl,dl
        cmp bl,0ah
        jnc notbinnumber
        add bl,48
        jmp binnumber  
        
notbinnumber:
        add bl,55      
        
binnumber:      
        mov al,bl
        mov ah,0eh      
        int 10h      
        
end_bin:
        pop ax
        pop bx 
        pop cx
        pop dx
        ret  
         
         
        readdec proc     ;read a valid decimal 

readagain1:              ;if input is not valid we read again  until we find a valid input
        mov ah, 1          
        int 21h
                
        cmp al,48
        jc wronginput
        cmp al,58
        jnc  wronginput
        jmp correctinput       
        
wronginput:
        call erase      
        jmp readagain1     
        
correctinput:
        sub al,30h
        ret            
    
        endp