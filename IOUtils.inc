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

appendKernelJump:
    	xor bx, bx
checkNext:
    	cmp byte es:[bx], 0x00
    	je lastByteFound
    	inc bx
    	jmp checkNext
lastByteFound:
	mov byte es:[bx], 0xBB
	mov byte es:[bx+1], 0x00
	mov byte es:[bx+2], 0x01
	mov byte es:[bx+3], 0x8E
	mov byte es:[bx+4], 0xC3
	mov byte es:[bx+5], 0xEA
	mov byte es:[bx+6], 0x00
	mov byte es:[bx+7], 0x00
	mov byte es:[bx+8], 0x00
	mov byte es:[bx+9], 0x01
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

clearString:
	mov byte [string], 0x00
	ret

;;;printReg;;;
;;; prints register values;
printRegisters:
	mov byte [string], 'A'
    	mov byte [string+1], 'X'
	mov byte [string+2], ':'
    	mov byte [string+3], ' '
    	mov byte [string+4], '0'
    	mov byte [string+5], 'x'
    	call printAX
    	mov ax, bx
	mov byte [string], 'B'
	call printAX
    	mov ax, cx
	mov byte [string], 'C'
	call printAX
	mov ax, dx
	mov byte [string], 'D'
	call printAX

	mov ax, si
	mov byte [string], 'S'
	mov byte [string+1], 'I'
	call printAX

	mov ax, di
	mov byte [string], 'D'
	call printAX

	mov ax, cs
	mov byte [string], 'C'
	mov byte [string+1], 'S'
	call printAX

	mov ax, ds
	mov byte [string], 'D'
	call printAX

	mov ax, es
	mov byte [string], 'E'
	call printAX

	mov ax, ss
	mov byte [string], 'S'
	call printAX

	call clearString
	ret

printAX:
	mov dx, ax
    	xchg al, ah
    	call hexToAscii
    	mov byte [string+6], ah
    	mov byte [string+7], al
	mov ax, dx
    	call hexToAscii
    	mov byte [string+8], ah
    	mov byte [string+9], al
	mov byte [string+10], 0x00
	mov si, string
	call printString
	ret