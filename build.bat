nasm bootloader.asm -o bootloader.bin
nasm GUILauncher.asm -o GUILauncher.bin
nasm george.asm -o george.bin
nasm kernel.asm -o kernel.bin
COPY /b bootloader.bin+GUILauncher.bin+george.bin+kernel.bin fullOS.bin