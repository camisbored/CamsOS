;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;kernel.asm                                                       ;
;Contains our main logic and interacts with Drive/IO utilities    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bits 16
mov byte [driveNum], dl

mov word bx, [PIC_HEIGHT]
dec bx
mov word [PIC_HEIGHT], bx

drawImage:
	xor bx, bx
	xor cx, cx
	xor dx, dx
drawPixel:
	mov byte al, [GEORGE_IMG+bx]
	push bx
	xor bx, bx
	mov byte ah, [colorAdd]
	add al, ah 
	mov ah, 0x0C
	add cx, 120
	add dx, 80
	int 10h 
	sub cx, 120
	sub dx, 80
	pop bx
	cmp word cx, [PIC_WIDTH]
	je incAndClear
retFromIncAndClear: 
	inc bx
	inc cx
	jmp drawPixel
exit:
    mov ah, 0x00
	int 16h
	cmp ah, 0x01
	je leave
    mov byte al, [colorAdd]
	inc al
	mov byte [colorAdd], al
	jmp drawImage

incAndClear:
    cmp word dx, [PIC_HEIGHT]
	je exit
	inc dx
	xor cx, cx
	jmp retFromIncAndClear

leave: 
    mov ax, 0x0003
    int 0x10
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 0x184f
    mov bx, 0x1E00
    int 0x10
    mov byte dl, [driveNum]
    mov ax, 100h
    mov ds, ax              ; data segment
    mov es, ax              ; extra segment
    mov fs, ax              ; ""
    mov gs, ax              ; ""
	jmp 100h:0000h

%include "george.inc"

colorAdd: db 0
driveNum: db 0

times 2048-($-$$) db 0 