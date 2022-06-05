nasm bootloader.asm -o bootloader.bin
nasm GUILauncher.asm -o GUILauncher.bin
nasm kernel.asm -o kernel.bin
COPY /b bootloader.bin+GUILauncher.bin+kernel.bin fullOS.bin