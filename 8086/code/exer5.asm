name "exer5" 

        PRINT macro message    
        push ax             ;print a message on screen    
        push dx             
        mov dx, offset message
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm
        

        
        PRINT startornot
user_decision:
        mov ah, 1            ;get (y) to start or (n) to terminate
        int 21h              
        cmp al,78            ;this is N
        je end1 
        cmp al,110           ;this is n
        je end1
        cmp al,89            ;this is Y
        je start1 
        cmp al,121           ;this is y
        je start1
        call erasechar
        jmp user_decision
        
       
start1:
        PRINT newline 
        
restart:
        mov ch,0 
        mov dx,0
        PRINT input 
        call readhex        ;3 hexadecimal digits=> call read_hex 3 times
        mov bl,al           
        call readhex
        mov bh,al       
        call readhex
        mov cl,al
          
        mov dh,bl           ;place all digits from bl,bh 
        mov ax,10h          ;cl to dx as hexadecimal 
        mul bh
        add dx,ax
        add dx,cx           
        
        cmp dx,0BB8h
        jnc greaterthan3
        mov ax,5            ;input x , output,  y=5/3*x from 0 to 3 volts 
        mul dx              
        mov bx,3           
        div bx               
        jmp printres
        
greaterthan3:
        mov ax,5            ;input x , output,  y=5*x-1000 from 3 to 4 volts
        mul dx              
        sub ax,10000        

printres:
        cmp ax,270Fh        ;temperature 999.9d
        jnc error
        PRINT newline       ;integral part is printed
        mov bx,10
        mov dx,0
        div bx
        cmp ax,0
        je zero                              
        call printdex
        jmp decml
        
zero:
        mov ah,0eh
        mov al,'0' 
        int 10h


decml:        
        mov ah,0eh              
        mov al,'.' 
        int 10h
        
        mov ax,dx           ;print decimal part
        cmp ax,0
        je zeronew
        call printdex
        jmp restartnew 
        
zeronew:   
        mov ah,0eh
        mov al,'0' 
        int 10h
                            
restartnew: 
        PRINT newline      ;restart          
        jmp restart
                             
end1:
        hlt
        
        
error:  
        PRINT newline
        PRINT errormsg
        jmp restart 
               
        errormsg db "ERROR"
        newline db 0Dh,0Ah, "$" 
        startornot db "START (Y, N):",0Dh,0Ah, "$"
        input db "insert input: $"
 
 
 
 
        erasechar proc    ;erase the last character pressed
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
      
      
                  
                  
        readhex proc       ;read a valid hexadecimal digit
readagain:                 ;if is not valid we read it again
        mov ah, 1               
        int 21h
        cmp al,'n'
        je end1
        cmp al,'N'
        je end1               
        cmp al,48
        jc wronginpt
        cmp al,58
        jnc  wrongnew
        jmp correctinpt
              
wronginpt:
        call erasechar     ;erase the invalid character
        jmp readagain

wrongnewt:
        cmp al,65
        jc wronginpt
        cmp al,103
        jnc wronginpt
        cmp al,71
        jnc wrongnew
        sub al,7
        jmp correctinpt
        
wrongnew:
        cmp al,97
        jc wronginpt
        sub al,39 
        
correctinpt:
        sub al,30h          ;in al have the number pressed in hexadecimal
        ret                 
                           
   
        
        
       printdex proc
        push dx             ;show result on screen
        push cx             
        mov dx,0            
        cmp ax,0h           ;the result is decimal because the base is 10
        je end2
        mov cx,10           
        div cx
        push dx
        call printdex
        pop dx
        mov ax,dx
        cmp ax,0ah
        jnc nonumber
        add ax,48
        jmp yesnumber
        
nonumber:
        add ax,55

yesnumber:
        mov ah,0eh      
        int 10h  

end2: 
        pop cx
        pop dx
        ret  
        
        endp                          
         