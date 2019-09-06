name "exer2"         
        

        PRINT macro message    
        push ax             ;print a message on screen    
        push dx             
        mov dx, offset message
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm

        
begin:  mov dl,0
        PRINT firstmessage
        
        
        mov ah, 1           ; read 1st number
        int 21h
                                      
        cmp al,49           ;input have to be 4 digits
        jc wronginput1      ;read 4 times from keyboard
        cmp al,58           ;check if input is a digit
        jnc  wronginput1    ;if it's not change dl to 1 to show that there is an error
        jmp correctinput1   ;is there are no errors dl stays at 0

wronginput1:               
        mov dl,1
        
correctinput1:
        sub al,30h
        mov bh,10
        mul bh
        mov bh,al
         
         
        mov ah, 1 
        int 21h 
               
        cmp al,48
        jc wronginput2
        cmp al,58
        jnc  wronginput2
        jmp correctinput2
        
wronginput2:
        mov dl,1    
        
correctinput2: 
        sub al,30h
        add bh,al
                   
        PRINT newline                
        PRINT secondmessage

        
       
        mov ah, 1 ;read 2nd number
        int 21h
                
        cmp al,49
        jc wronginput3
        cmp al,58
        jnc  wronginput3
        jmp correctinput3 
        
wronginput3:
        mov dl,1 
        
correctinput3:

        sub al,30h
        mov bl,10
        mul bl
        mov bl,al
        
        
        
        mov ah, 1 
        int 21h
        
        cmp al,48
        jc wronginput4
        cmp al,58
        jnc  wronginput4
        jmp correctinput4  
        
wronginput4:
        mov dl,1   
        
correctinput4:
        sub al,30h
        add bl,al
        
       
        PRINT newline
                            ;first number on bh   
        PRINT x             ;second number on bl
      
        cmp dl,1            ;print the numbers we read
        je wronginput5
        mov al,bh
        call printdec
        jmp correctinput5
        
wronginput5:
        PRINT dash   
        
correctinput5:
        
       
        PRINT y
    
        cmp dl,1        
        je wronginput6 
        mov al,bl
        call printdec
        jmp correctinput6 
        
wronginput6:
        PRINT dash 
        
correctinput6:      


         
enternot:                   ;wait till enter       
        mov ah,00h
        int 16h 
        cmp al,0dh        
        jne enternot

        cmp dl,1            ;check if input was correct
        je error            ;else display error message
                            ;and start again 
        PRINT newline            
          
        push bx
        mov bl,bh
        mov bh,0
        mov cx,bx
        pop bx
        push bx
        mov bh,0
        add cx,bx
        mov ax,cx
        pop bx
        
        PRINT xaddy
  
        mov ax,cx           
        call printhex   ;Sum print
        
        
        PRINT xsuby 
        
             
        push bx
        mov bl,bh
        mov bh,0
        mov cx,bx
        pop bx
        mov bh,0
        sub cx,bx 
        mov ax,cx
        test ax,ax          ;AND for ax,ax
        jns posit           ;don't save the result.
        push ax             ;check the difference
        mov al, '-'         
        mov ah,0eh      
        int 10h
        pop ax  
        neg ax
        
posit: 
        cmp ax,0
        je zero             ;if difference is 0
        call printhex   ;print it
        jmp zero_not

zero:           
        mov al,'0'          ;if difference is zero => print '0' 
        mov ah,0eh      
        int 10h 

zero_not:
        PRINT newline  
        jmp begin
         
        hlt


error:  PRINT errormsg      ;error message and start again
        jmp begin
                
                
        firstmessage db "enter first number:  $" 
        secondmessage db "enter second number:  $"
        newline db 0Dh,0Ah, "$"                  
        x db "x=$"
        y db "  y=$"
        xaddy db "x+y=$"
        xsuby db "  x-y=$"
        errormsg db 0Dh,0Ah,"WRONG INPUT",0Dh,0Ah,"$"
        dash db "-$"
        
          
             
        
       printhex proc
        push dx         ;show result on screen
        push cx         
        mov dx,0        
        cmp ax,0h       ;the result is hexadecimal
        je end1
        mov cx,10h
        div cx
        push dx
        call printhex
        pop dx
        mov ax,dx
        cmp ax,0ah
        jnc notnumber
        add ax,48
        jmp number
        
notnumber:
        add ax,55  
        
number:
        mov ah,0eh      
        int 10h   
        
end1: 
        pop cx
        pop dx
        ret  
        
        
        
        printdec proc
        push dx         ;show result on screen
        push cx         
        push ax         
        mov ah,0        ;the result is decimal
        mov dx,0        
        cmp al,0h
        je procdec1
        mov cx,10
        div cx
        push dx
        call printdec
        pop dx
        mov al,dl
        cmp al,0ah
        jnc notdecnumber
        add al,48
        jmp decnumber 
        
notdecnumber:
        add al,55  
        
decnumber:
        mov ah,0eh      
        int 10h   
        
procdec1:
        pop ax 
        pop cx
        pop dx
        ret 
              
        endp