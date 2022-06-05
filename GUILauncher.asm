HW_EQUIP_PS2     equ 4          
MOUSE_PKT_BYTES  equ 3          
MOUSE_RESOLUTION equ 3       

    mov [bootDriveNum], dl
    mov ax, 0x0013
    int 0x10                    
    call mouse_initialize
    call drawBackground
    sti

;; continue to write to screen ;;
.main_loop:
    hlt                         
    call poll_mouse             
    jmp .main_loop              

;; activate mouse and start reading;
mouse_initialize:
    push es
    push bx
    int 0x11                    
    mov ax, 0xC205              
    mov bh, MOUSE_PKT_BYTES     
    int 0x15                    
    mov ax, 0xC203              
    mov bh, MOUSE_RESOLUTION    
    int 0x15                    
    push cs
    pop es                      
    mov bx, mouse_callback_dummy
    mov ax, 0xC207             
    int 0x15                   
    pop bx
    pop es
    push es
    push bx
    push cs
    pop es
    mov bx, mouse_callback
    mov ax, 0xC207             
    int 0x15                    
    mov ax, 0xC200              
    mov bh, 1                   
    int 0x15                    
    pop bx
    pop es
    ret

ARG_OFFSETS      equ 6          
mouse_callback:
    push bp                     
    mov bp, sp
    push ds                     
    push ax
    push bx
    push cx
    push dx
    push cs
    pop ds                      
    mov al,[bp+ARG_OFFSETS+6]
    mov bl, al                  ; BX = copy of status byte
    mov cl, 3                   ; Shift signY (bit 5) left 3 bits
    shl al, cl                  ; CF = signY
    sbb dh, dh                  ; CH = SignY value set in all bits
    cbw                         ; AH = SignX value set in all bits
    mov dl, [bp+ARG_OFFSETS+2]  ; CX = movementY
    mov al, [bp+ARG_OFFSETS+4]  ; AX = movementX
    neg dx
    mov cx, [mouseY]
    add dx, cx                  ; get y
    mov cx, [mouseX]
    add ax, cx                  ; get x
    mov [curStatus], bl         ; get status (clicked, unclicked)
    mov [mouseX], ax            ; update x
    mov [mouseY], dx            ; update y
    call drawBox
    call printCursor
    mov [lastX], ax
    mov [lastY], dx
    pop dx                     
    pop cx
    pop bx
    pop ax
    pop ds
    pop bp                      
mouse_callback_dummy:
    retf                        

poll_mouse:
    push ax
    push bx
    push cx
    push dx


    mov si, string
    call print_string
 
    pop dx
    pop cx
    pop bx
    pop ax
    ret

drawBackground:
    push ax
    push bx
    push cx
    push dx
    mov cx, 0  ;col
    mov dx, 0  ;row
    mov ah, 0ch ; put pixel
    mov al, 0x0B

    bcolcount:
    inc cx
    int 10h
    cmp cx, 320
    JNE bcolcount

    mov cx, 0  ; reset to start of col
    inc dx      ;next row
    cmp dx, 200
    JNE bcolcount
    pop dx
    pop cx
    pop bx
    pop ax
    ret

drawBox:
    push ax
    push bx
    push cx
    push dx
    mov cx, 50  ;col
    mov dx, 50  ;row
    mov ah, 0ch ; put pixel
    mov al, 0x04

    colcount:
    inc cx
    int 10h
    cmp cx, 70
    JNE colcount

    mov cx, 50  ; reset to start of col
    inc dx      ;next row
    cmp dx, 70
    JNE colcount
    pop dx
    pop cx
    pop bx
    pop ax
    ret

drawWin:
    push ax
    push bx
    push cx
    push dx
    mov cx, 100  ;col
    mov dx, 100  ;row
    mov ah, 0ch ; put pixel
    mov al, 0x05

    wcolcount:
    inc cx
    int 10h
    cmp cx, 150
    JNE wcolcount

    mov cx, 100  ; reset to start of col
    inc dx      ;next row
    cmp dx, 150
    JNE wcolcount
    mov ah, 0x02
    mov bh, 0x00
    mov dl, 125
    mov dh, 125
    mov bx, 0x0002              
    mov ah, 0x0e                
    int 10h
    pop dx
    pop cx
    pop bx
    pop ax
    jmp retFromCheck


printCursor:
        push ax
	push cx
	push dx
	mov cx, [lastX]
	mov dx, [lastY]
        mov ah, 0x0C
	mov al, 0x0B
        int 10h
	add cx, 0x01
        int 10h
	add cx, 0x01
        int 10h
	sub cx, 0x03
        int 10h
	sub cx, 0x01
        int 10h
	add cx, 0x02
	sub dx, 0x01
        int 10h
	sub dx, 0x01
        int 10h
	add dx, 0x03
        int 10h
	add dx, 0x01
        int 10h
	mov cx, [mouseX]
	mov dx, [mouseY]
        mov ah, 0x0C
	mov al, 0x01
        int 10h
	add cx, 0x01
        int 10h
	sub cx, 0x02
        int 10h
	add cx, 0x01
	sub dx, 0x01
        int 10h
	add dx, 0x02
        int 10h
	cmp byte [curStatus], 0x09
	je clickedIn
returnFromClickedIn:
	pop dx
	pop cx
        pop ax
	ret
clickedIn:
	mov al, 0x02
	add dx, 0x01
	int 10h
	sub dx, 0x04
	int 10h
	add dx, 0x02
	sub cx, 0x02
	int 10h
	add cx, 0x04
	int 10h
        cmp byte [mouseX], 50
	jg secondCheck
retFromCheck:
	jmp returnFromClickedIn

secondCheck:
	cmp byte [mouseX], 70
	jl thirdCheck
	jmp retFromCheck

thirdCheck:
	cmp byte [mouseY], 50
	jg fourCheck
	jmp retFromCheck

fourCheck:
	cmp byte [mouseY], 70
	jl drawWin
	jmp retFromCheck

print_string:
    push ax
    push bx
    mov bh, 0x00             
    mov byte bl, [color]
    inc bl
    mov byte [color], bl
    mov ah, 0x0e                
    jmp .getch
.repeat:
    int 0x10                    
.getch:
    lodsb                       
    test al,al                  
    jnz .repeat                
.end:
    pop bx
    pop ax
    ret

align 2
mouseX:       dw 100              ; Current mouse X coordinate
mouseY:       dw 100              ; Current mouse Y coordinate
lastX:       dw 0              ; Current mouse X coordinate
lastY:       dw 0              ; Current mouse Y coordinate
curStatus:    db 0              ; Current mouse status
color:          db 0
bootDriveNum:       db 0
string:  db "       Welcome! Click button!",0x0d,0


TIMES 1024-($-$$) db  0
