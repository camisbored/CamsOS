;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;kernel.asm                                                       ;
;Contains our main logic and interacts with Drive/IO utilities    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bits 16
;mov driveNum to variable since it is stored in dl on boot
mov [driveNum], dl

;call welcome message one time
call newLineReturn
mov si, welcomeMessage
call printString

;;continually print info message and take input- call function based on input
mainLoop:
    mov word [axAtStart], ax

    mov si, mainMessage
    call printString

    call getKeyAndPrint

    cmp al, 's'
    je scan

    cmp al, 'g'
    je graphics

    cmp al, 'w'
    je write

    cmp al, 'r'
    je read

    cmp al, 'd'
    je delete

    cmp al, 'h'
    je help

    cmp al, 'x'
    je execute

    cmp al, 'e'
    je edit

    cmp al, 'i'
    je printReg

    cmp al, 'm'
    je mouseTest

    cmp al, 't'
    je printTime

    cmp al, 'p'
    je pong

    cmp al, 'c'
    je calc

    cmp al, 'a'
    je image

    cmp al, 'b'
    je beep

    mov si, notFound
    call printString
    jmp mainLoop

;;; functions called from main loop ;;;

graphics:
    call goToVideoMode
    mov al, 0x01
    mov cx, 0x0025
    mov dx, 0x0025
    mov bx, 0x0001
addPixel:
    mov al, bl
    mov ah, 0x0C
    int 10h
    mov ah, 0x00
    int 16h
    cmp ah, 0x48
    je decDX
    cmp ah, 0x4B
    je decCX
    cmp ah, 0x50
    je incDX
    cmp ah, 0x4D
    je incCX
    cmp al, 'c'
    je incBl
    cmp al, 'b'
    je xorBl
    cmp ah, 0x01
    je exitGraphics
    jmp addPixel
incCX:
    inc cx
    jmp addPixel
decDX:
    dec dx
    jmp addPixel
decCX:
    dec cx
    jmp addPixel
incDX:
    inc dx
    jmp addPixel
incBl:
    inc bl
    jmp addPixel
xorBl:
    xor bl, bl
    jmp addPixel
exitGraphics:
    call goToTextMode
    jmp mainLoop

scan:
    mov si, scanStr
    call printString
    call moveTo200
    call scanDisk
    mov si, string
    call printString
    call clearString
    call moveTo100
    jmp mainLoop

read:    
    call askSectorToAccess
    call moveTo200
    call readDisk
    call moveMemoryToString
    mov si, string
    call printString
    call clearMemory
    call clearString
    call moveTo100
    jmp mainLoop

write:
    call askSectorToAccess
    call moveTo200
    mov si, textOrHex
    call printString
    call getKeyAndPrint
    cmp al, 't'
    je writeText
    cmp al, 'c'
    je writeCode
    mov si, tOrCNotFound
    call printString
    jmp mainLoop

writeText:
    mov si, writeStr
    call printString
    call getInput
    call moveStringToMemory
    call addTimeStampToMemory
    call writeDisk
    mov si, savedStr
    call printString
    call clearMemory
    call moveTo100
    jmp mainLoop

writeCode:
    mov si, codeStr
    call printString
    call clearMemory
    call clearString
    call getInput
    call moveHexToMemory
    call appendKernelJump
    call writeDisk
    mov si, codeSavedStr
    call printString
    call clearMemory
    call moveTo100
    jmp mainLoop

    call askSectorToAccess
    call moveTo200
    mov si, writeStr
    call printString
    call getInput
    call moveStringToMemory
    call addTimeStampToMemory
    call writeDisk
    mov si, savedStr
    call printString
    call clearMemory
    call moveTo100
    jmp mainLoop

delete:
    call askSectorToAccess
    call moveTo200
    call clearMemory
    call writeDisk
    mov si, clearedStr
    call printString
    call moveTo100
    jmp mainLoop

edit:
    call askSectorToAccess
    call moveTo200
    call readDisk
    call moveMemoryToString
    mov si, string
    call printStringEdit
    call getCursorIndex
    xor bx, bx
nextIndex:
    mov ah, 0x00
    int 16h
    cmp al, 0x0d
    je doneEdit
    cmp ah, 0x0e
    je backspace
    cmp ah, 0x4B
    je moveback
    cmp ah, 0x4D
    je moveforward
    mov ah, 0x0e
    int 10h
    mov bl, dl
    add al, [encryptionFactor]
    mov byte es:[bx], al
    inc dl
    jmp nextIndex
backspace:
    call backSpace
    jmp nextIndex
moveback:
    call moveLeft
    jmp nextIndex
moveforward:
    call moveRight
    jmp nextIndex
doneEdit:
    call writeDisk
    call newLineReturn
    mov si, savedStr
    call printString
    call clearMemory
    call clearString
    call moveTo100
    jmp mainLoop

help:
    mov si, helpStr
    call printString
    jmp mainLoop

execute:
    mov si, sectorRequest
    call printString
    call readSingleByte
    mov [requestedSector], al
    mov si, executeStr
    call printString
    call moveTo200
    call readDisk
    jmp 200h:0000h

pong:
    call pongGame
    jmp mainLoop

calc:
    mov si, calcString
    call printString
    call getInput
    call performCalculation
    jmp mainLoop

beep:
	mov ax, 2280
	mov dx, 0x2500
	call playSound

	mov ax, 2280
	mov dx, 0x500
	call playSound

	mov ax, 2280
	mov dx, 0x500
	call playSound

	mov ax, 2280
	mov dx, 0x5000
	call playSound

	mov ax, 3360
	mov dx, 0x2500
	call playSound

	mov ax, 2280
	mov dx, 0x500
	call playSound

	mov ax, 3360
	mov dx, 0x2500
	call playSound

	mov ax, 2280
	mov dx, 0x500
	call playSound

	jmp mainLoop


printReg:
    call printRegisters
    jmp mainLoop

mouseTest:
    mov ax, 300h
    mov ds, ax              ; data segment
    mov es, ax              ; extra segment
    mov fs, ax              ; ""
    mov gs, ax              ; ""
    ;jmp to 300h, where the mouse GUI was loaded in bootsector
    jmp 300h:0000h

printTime:
    call printTimeString
    jmp mainLoop

image:
    call goToVideoMode
    mov byte dl, [driveNum]
    mov ax, 500h
    mov ds, ax              ; data segment
    mov es, ax              ; extra segment
    mov fs, ax              ; ""
    mov gs, ax              ; ""
    ;jmp to 500h, where the george pic was loaded in bootsector
    jmp 500h:0000h

;;; imports ;;;
%include "IOUtils.inc"
%include "HexAsciiUtils.inc"
%include "DiskUtils.inc"
%include "pong.asm"

;;; data ;;;
welcomeMessage: db "***Welcome to Cam's OS***",0
mainMessage: db "Choose from the following:",0x0a,0x0d,\
                "[s]can, [r]ead, [w]rite, [d]elete, [h]elp, [t]ime, e[x]ecute, [e]dit, [g]fx",0

helpStr: db "----------------------",0x0a,0x0d,\
            "|b- plays song (audio test)|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|s- scan drive for sectors with data (IE- display list of files)|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|r- read and print file located at provided sector|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|w- writes/encrypts/timestamps message or stores executable code|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|a- displays a picture of George the Cat! (ESC to return, color c)|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|p- play pong with arrow keys, leave with ESC, 1 to slow, 2 to speed|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|g- draw using arrows, change color with c, black with b, leave with ESC|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|i- print out register values|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|m- mouse test (no way to return)|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|c- very basic calculator|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,\
            "|x- execute code at provided sector|",0x0a,0x0d,\
            "---------------------",0x0a,0x0d,0
codeStr: db 0x0a, 0x0d, "Enter bytes to save code (B8480ECD10 will print H, ",\
 		    0x0a, 0x0d, "B8410ECD10FEC03C5B75F8EBFE will print alphabet)",0

scanStr: db "The following sectors currently contain data: ",0
sectorRequest: db "Enter sector to access (valid range 10-7F):",0
writeStr: db "Enter message for file",0
textOrHex: db "Are you writing [t]ext or [c]ode?",0
tOrCNotFound: db "Invalid Entry- only [t] or [c] are valid. Try again.",0
savedStr: db "Message saved!", 0
codeSavedStr: db "Code saved!", 0
clearedStr: db "Data has been deleted",0
notFound: db "Command not found! Type [h] or try again",0 
calcString: db "Enter simple single digit math (4+4, 4-2)",0  
syntaxErrorStr: db "!!!SYNTAX ERROR!!! single digit and +/- only",0  
executeStr: db 0x0a, 0x0d, "Running code...",0
invalidSectorStr: db 0x0a, 0x0d, "!!!ERROR, INVALID SECTOR!!!",0

axAtStart: dw 0x0000
encryptionFactor db 64
driveNum: db 0
requestedSector db 0x10
SYSTEM_SECTOR_SIZE:	db 0x10
currentSector db 1
byteVar: db "  "
;this is probably a bad practice- by leaving string as last variable
;we don't have to declare a size. 
string: db ""
;since we designed a soft limit of 255 sectors, pad out to 255 sectors
times 131072-($-$$) db 0 
