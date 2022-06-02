nasm bootloader.asm -o bootloader.bin
nasm kernel.asm -o kernel.bin
COPY /b bootloader.bin+kernel.bin fullOS.bin
