pongGame:
   call goToVideoMode
   mov bx, 0x0002
   
gameLoop:
    call updateClock
    cmp byte [clockWatch], 0x50
    je updateBall
retFromUpdateBall:
    call checkCollision
    call drawGame
    mov ax, 0x0100
    int 16h
    jz gameLoop
    mov ah, 0x00
    int 16h
    cmp ah, 0x01
    je exitPong
    cmp ah, 0x48
    je decDXPong
    cmp ah, 0x50
    je incDXPong
    jmp gameLoop
decDXPong:
    mov byte ah, [playerCenter]
    dec ah
    mov byte [playerCenter], ah
    jmp gameLoop
incDXPong:
    mov byte ah, [playerCenter]
    inc ah
    mov byte [playerCenter], ah
    jmp gameLoop

updateOpponent:
    cmp byte [oppFlag], 0x01
    je inverseOpp
    mov word ax, [oppCenter]
    inc ax
    mov word [oppCenter], ax
    cmp ax, 180
    je setFlag
retFromSetFlag:
    ret
inverseOpp:
    mov word ax, [oppCenter]
    dec ax
    mov word [oppCenter], ax
    cmp ax, 30
    je clearFlag
retFromClearFlag:
    ret
setFlag:
    mov al, 0x01
    mov byte [oppFlag], al
    jmp retFromSetFlag
clearFlag:
    mov al, 0x00
    mov byte [oppFlag], al
    jmp retFromClearFlag

updateBall:  
    call updateOpponent
    mov al, 0x00
    mov byte [clockWatch], al 
    cmp byte [directionFlag], 0x01
    je inverseDirection
    mov word ax, [ballX]
    dec ax
    mov word [ballX], ax
    mov word ax, [ballY]
    inc ax
    mov word [ballY], ax
    jmp retFromUpdateBall
inverseDirection:
    mov word ax, [ballX]
    inc ax
    mov word [ballX], ax
    mov word ax, [ballY]
    dec ax
    mov word [ballY], ax
    jmp retFromUpdateBall

checkCollision:
    mov word ax, [ballX]
    cmp ax, 20
    je check2
    ret
check2:
    mov word ax, [ballY]
    mov word bx, [playerCenter]
    sub bx, 10
    cmp ax, bx
    jg check3
    ret
check3:
    add bx, 20
    cmp ax, bx
    jl success
    ret
success:
    mov byte [directionFlag], 1
    ret

updateClock:
    mov ah, 0x00
    int 1ah
    mov al, ch
    call hexToAscii
    mov byte [string], ah
    mov byte [string+1], al
    mov al, cl
    call hexToAscii
    mov byte [string+2], ah
    mov byte [string+3], al
    mov al, dh
    call hexToAscii
    mov byte [string+4], ah
    mov byte [string+5], al
    mov al, dl
    call hexToAscii
    mov byte [string+6], ah
    mov byte [string+7], al
    mov byte [string+8], ' '
    
    mov ah, 0x04
	int 0x1a
    mov al, dh
    call hexToAscii
    mov byte [string+9], ah
    mov byte [string+10], al
    mov byte [string+11], '/'
    mov al, dl
    call hexToAscii
    mov byte [string+12], ah
    mov byte [string+13], al
    mov byte [string+14], '/'
    mov al, ch
    call hexToAscii
    mov byte [string+15], ah
    mov byte [string+16], al
    mov al, cl
    call hexToAscii
    mov byte [string+17], ah
    mov byte [string+18], al
    mov byte [string+19], ' '
	mov ah, 0x02
	int 0x1a
    mov al, ch
    call hexToAscii
    mov byte [string+20], ah
    mov byte [string+21], al
    mov byte [string+22], ':'
    mov al, cl
    call hexToAscii
    mov byte [string+23], ah
    mov byte [string+24], al
    mov byte [string+25], ':'
    mov al, dh
    call hexToAscii
    mov byte [string+26], ah
    mov byte [string+27], al
    mov byte [string+28], 0x0d
    mov byte [string+29], 0x00
    mov si, string
    call printStringSameLine
    mov byte al, [clockWatch]
    inc al
    mov byte [clockWatch], al
    ret

drawGame:
    mov ax, 0x0C07
    mov bh, 0x00

    call drawPlayer
    call drawOpp
    call drawBall
    ret

drawPlayer:
    mov word dx, [lastPlayerCenter]
    cmp word dx, [playerCenter]
    je return
    mov al, 0x00
    mov cx, 20
    mov bx, dx
    add bx, 10
    sub dx, 10
clearLoop:
    int 10h
    dec cx 
    int 10h
    add cx, 2
    int 10h
    dec cx
    inc dx
    cmp dx, bx
    jne clearLoop
    mov al, 0x07
    mov cx, 20
    mov word dx, [playerCenter]
    mov bx, dx
    add bx, 10
    sub dx, 10
playerLoop:
    int 10h
    dec cx 
    int 10h
    add cx, 2
    int 10h
    dec cx
    inc dx
    cmp dx, bx
    jne playerLoop
    mov word dx, [playerCenter]
    mov word [lastPlayerCenter], dx
    ret

drawOpp:
    mov word dx, [lastOppCenter]
    cmp word dx, [oppCenter]
    je return
    mov al, 0x00
    mov cx, 200
    mov bx, dx
    add bx, 10
    sub dx, 10
clearOppLoop:
    int 10h
    dec cx 
    int 10h
    add cx, 2
    int 10h
    dec cx
    inc dx
    cmp dx, bx
    jne clearOppLoop
    mov al, 0x07
    mov cx, 200
    mov word dx, [oppCenter]
    mov bx, dx
    add bx, 10
    sub dx, 10
oppLoop:
    int 10h
    dec cx 
    int 10h
    add cx, 2
    int 10h
    dec cx
    inc dx
    cmp dx, bx
    jne oppLoop
    mov word dx, [oppCenter]
    mov word [lastOppCenter], dx
    ret

drawBall:
    mov al, 0x00
    mov word cx, [lastBallX]
    mov word dx, [lastBallY]
    int 10h
    dec cx
    int 10h
    add cx, 2
    int 10h
    inc dx
    int 10h
    dec cx
    int 10h
    dec cx
    int 10h
    sub dx, 2
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    mov al, 0x07
    mov word cx, [ballX]
    mov word dx, [ballY]
    int 10h
    dec cx
    int 10h
    add cx, 2
    int 10h
    inc dx
    int 10h
    dec cx
    int 10h
    dec cx
    int 10h
    sub dx, 2
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    mov word ax, [ballX]
    mov word [lastBallX], ax
    mov word ax, [ballY]
    mov word [lastBallY], ax
    ret

printStringSameLine:
    mov bx, 0x0002
	mov ah, 0x0e
printCharSameLine:
	lodsb
	cmp al, 0x00
	je return
	int 0x10
	jmp printCharSameLine

exitPong:
    call goToTextMode
    jmp mainLoop
    

playerCenter: dw 100
oppCenter: dw 100
ballX: dw 100
ballY: dw 100
lastPlayerCenter: dw 99
lastOppCenter: dw 99
lastBallX: dw 100
lastBallY: dw 100
directionFlag: db 0
oppFlag: db 0
clockWatch db 0

