;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Camisbored's Simple OS                                                  ;
;6/2/22                                                                  ;
;A BIOs based x86 system with read/write and graphics functionality      ;
;                                                                        ;
;bootloader.asm                                                          ;
;Contains a MBR (boot record, declare valid format and makes compatable  ;
;on more devices), loads kernel into memory, then jumps to kernel        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;tell assembler to start addressing at 0x7c00 and generate 16 bit code
org 0x7c00
bits 16

boot:
    jmp main
    TIMES 3-($-$$) DB 0x90  

    ; Define floppy size and format
    OEMname:           db    "mkfs.fat"
    bytesPerSector:    dw    512
    sectPerCluster:    db    1
    reservedSectors:   dw    257
    numFAT:            db    2
    numRootDirEntries: dw    224
    numSectors:        dw    2880
    mediaType:         db    0xf0
    numFATsectors:     dw    9
    sectorsPerTrack:   dw    18
    numHeads:          dw    2
    numHiddenSectors:  dd    0
    numSectorsHuge:    dd    0
    driveNum:          db    0
    reserved:          db    0
    signature:         db    0x29
    volumeID:          dd    0x2d7e5a1a
    volumeLabel:       db    "NO NAME    "
    fileSysType:       db    "FAT12   "
main:
    cli

    xor ax, ax     ; zero out ds and es to make compatable on more machines
    mov ds, ax
    mov es, ax   

    ;clear screen and set color
    push dx
    mov ah, 0x06
    xor al, al  
    xor cx, cx  
    mov dx, 0x184f
    mov bh, 0x1E
    int 0x10
    pop dx     

    ;;LOAD KERNEL;;
    mov bx, 0x0100
    mov es, bx 
    xor bx, bx  
    mov cx, 0x0004  ;cl contains location of kernel sector
    mov ax, 0x0209  ;al contains how many sectors to load for kernel
    xor dh, dh
    int 13h 

    ;; load GUI Launcher ;;
    mov bx, 0x0300
    mov es, bx 
    xor bx, bx  
    mov cx, 0x0002  ;cl contains location of kernel sector
    mov ax, 0x0202  ;al contains how many sectors to load for kernel
    xor dh, dh
    int 13h 
    
    ;; set up seg registers for ram
    mov ax, 100h
    mov ds, ax              ; data segment
    mov es, ax              ; extra segment
    mov fs, ax              ; ""
    mov gs, ax              ; ""

    ;jmp to 100h, where we just loaded the kernel to
    jmp 100h:0000h
   
times 510-($-$$) db 0 
dw 0AA55h