;;; printString ;;;
;;;input string in si, prints to screen;;;
printString:
	mov ah, 0x0e
printChar:
	lodsb
	cmp al, 0x00
	je newLineReturn
	int 0x10
	jmp printChar

;;; getKeyAndPrint ;;;
;;; scans single key and prints to screen;;;
;;; takes no input, returns key value in al ;;;
getKeyAndPrint:
    mov ah, 0x00
    int 0x16
    mov ah, 0x0e
    int 0x10
    call newLineReturn
	ret

;;; getInput ;;;
;;;gets user input and moves into string variable;;;
getInput:
	mov bx, string
nextInput:
	mov ah, 0x00
	int 0x16
	cmp al, 0x0d
	je nullTermNewLineReturn
	mov ah, 0x0e
	int 0x10
	mov [bx], al
	inc bx
	jmp nextInput

nullTermNewLineReturn:
	inc bx
	mov byte [bx], 0x00
	jmp newLineReturn

newLineReturn:
	push ax
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	pop ax
	jmp return

return:
	ret

debug:
    push ax
    mov ax, 0x0e65
    int 10h 
    pop ax
    ret

moveStringToMemory:
	xor bx, bx
readNextSTMChar:
    mov al, [string+bx]
    cmp al, 0x00
    je exitStringToMemoryLoop
	add al, [encryptionFactor]
    mov byte es:[bx], al
    inc bx
    jmp readNextSTMChar
exitStringToMemoryLoop:
	ret

moveHexToMemory:
	xor cx, cx
	xor bx, bx
readNextHTMChar:
    mov byte ah, [string+bx]
    cmp ah, 0x00
    je exitHexToMemoryLoop
	inc bx
	mov byte al, [string+bx]
	call asciiToHex
	xchg cx, bx
    mov byte es:[bx], al
	xchg cx, bx
    inc bx
	inc cx
    jmp readNextHTMChar
exitHexToMemoryLoop:
	ret

moveMemoryToString:
	xor bx, bx
readNextMTSChar:
	mov byte al, es:[bx]
    cmp al, 0x00
    je exitMemoryToStringLoop
	sub al, [encryptionFactor]
    mov [string+bx], al
    inc bx
    jmp readNextMTSChar
exitMemoryToStringLoop:
	inc bx
	mov byte [string+bx], 0x00
	ret

goToVideoMode:
    mov ax, 0x0013
    int 10h
	ret

goToTextMode:
    mov ax, 0x0003
    int 0x10
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 0x184f
    mov bx, 0x1E00
    int 0x10

printStringEdit:
	mov ah, 0x0e
printCharEdit:
	lodsb
	cmp al, 0x00
	je return
	int 0x10
	jmp printCharEdit

getCursorIndex:
    mov ah, 0x03
    mov bh, 0x00
    int 10h
	ret

backSpace:
	call moveLeft
	mov ah, 0x0e
	mov al, ' '
	int 10h
	ret

moveLeft:
	dec dl
    mov ah, 0x02
    int 10h
	ret

moveRight:
	inc dl
    mov ah, 0x02
    int 10h
	ret