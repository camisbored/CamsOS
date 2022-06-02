
;;;            asciiToHex             ;;;
;;;input high nibble in ah, low nibble;;;
;;;in al and returns hex value in al  ;;;
asciiToHex:
    sub ah, 0x30
    sub al, 0x30
    cmp ah, 0x09
    jg sub7ah
retSub7ah:
    cmp al, 0x09
    jg sub7al
retSub7al:
    shl ah, 4
    add al, ah
    ret
sub7ah:
    sub ah, 0x07
    jmp retSub7ah
sub7al:
    sub al, 0x07
    jmp retSub7al

;;;            hexToAscii                ;;;    
;;;input hex value in al and returns high;;;
;;;nibble in ah and low nibble in al     ;;;
hexToAscii:
    mov ah, al
    shr ah, 4
    shl al, 4
    shr al, 4
    add ah, 0x30
    add al, 0x30
    cmp ah, 0x39
    jg add7ah
retAdd7ah:
    cmp al, 0x39
    jg add7al
retAdd7al:
    ret
add7ah:
    add ah, 7
    jmp retAdd7ah
add7al:
    add al, 7
    jmp retAdd7al

;;; will read single byte and leave value in al ;;;
readSingleByte:
    mov ah, 0x00
    int 16h
    mov ah, 0x0e
    int 10h
    mov [byteVar], al
    mov ah, 0x00
    int 16h
    mov ah, 0x0e
    int 10h
    mov [byteVar+1], al
    mov ah, [byteVar]
    mov al, [byteVar+1]
    call asciiToHex
    cmp al, 0x07
    jl sectorError
    ret

sectorError:
    mov si, invalidSectorStr
    call printString
    jmp mainLoop