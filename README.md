CamsOS-
A BIOS 16-bit interrupt based x86 operating system with read/write and graphics 
functionality. This OS contains the following features:

-Scan Disk for "files" (sectors with data).

-Write and encrypt "file" (data to single sector) and date/time stamps end of sector

-Read and decrypt "file" (data from selected sector)

-Delete "file"

-Edit "file" 

-Print help menu for navigation help

-Write and store raw machine code to sector to be executed.

-Dynamically execute stored code

-Switch to graphics mode and allow user to draw on screen using keys and colors

-Print register values.

-Image rendering- will display an image of my cat on the screen.

-A mouse demo feature that will turn the mouse on and change screen based on clicks (currently no way to return from this)

-A start of a calculator

-A print date/time feature

-A start and mostly functioning pong game

-Will play audio sequence through speaker.

There is a build script in here. You will need NASM to assemble. If you plan on editing this, 
I recommend Visual Studio Code, as you should be able to open this folder up there and be good 
to go, using the build.bat and run.bat scripts to launch.

This will run on hardware, I tested this on two x86 machines and I believe it should work on most.
To boot, you must write the fullOS.bin file to a USB using a utility like DD or manually copy the
bytes over using a HexEditor like HXD. You only need to copy up until the last not null byte to the
beginning of your flash drive. Note that this will make the files on your usb effectively useless
so only write to a empty drive.

To run, you may want to download an x86-64 emulator like qemu and launch there. I have 
included run script, you can use that to launch the program assuming you have qemu 
configured correctly.

This product is in a working state, but is not bug free or complete. I may or may not
continue to work on this when I have time. Feel free to take it and use it however
you like. Inquiries and requests can be sent to-
camerongrande95@gmail.com
