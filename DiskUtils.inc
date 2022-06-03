;;;               readDisk                   ;;;
;;; Will read a single sector into memory at ;;;
;;; whatever location es is set to. make sure;;;
;;; requestedSector is properly setup        ;;;
readDisk:
    push bx
    xor cx, cx
    xor bx, bx
    mov cl, [requestedSector]
    mov ax, 0x0201
    xor dh, dh
    mov dl, [driveNum]	
    int 13h
    pop bx
    ret

;;;                 writeDisk                ;;;
;;; Will write a single sector into memory at;;;
;;; whatever location es is set to. make sure;;;
;;; requestedSector is properly setup and    ;;;
;;; es:bx contains wanted data               ;;;
writeDisk:
    xor cx, cx
    xor bx, bx
    mov cl, [requestedSector]
    mov ax, 0x0301
    xor dh, dh
    mov dl, [driveNum]	
    int 13h
    ret

scanDisk:
    mov cx, 0x0007
    xor bx, bx
scanNextSector:
    cmp cl, 0xFF
    je exitScan
    mov [requestedSector], cl
    call readDisk
    cmp byte es:[0], 0x00
    jne appendSectorToString
retFromAppendSector:
    inc cx
    jmp scanNextSector
appendSectorToString:
    mov byte al, [requestedSector]
    call hexToAscii
    mov byte [string+bx], ah
    inc bx
    mov byte [string+bx], al
    inc bx
    mov byte [string+bx], ','
    inc bx
    mov byte [string+bx], ' '
    inc bx
    jmp retFromAppendSector
exitScan:
    ret


clearMemory:
    xor cx, cx
    xor bx, bx
clearByte:
    mov byte es:[bx], 0x00
    cmp cx, 0x0200
    je exitClearMemory
    inc bx
    inc cx
    jmp clearByte
exitClearMemory:
    ret

moveTo200:
    mov bx, 0x0200         
    mov es, bx
    xor bx, bx
    ret

moveTo100:
    mov bx, 0x0100         
    mov es, bx
    xor bx, bx
    ret
