SimpleOS- 6/2/22
A BIOS 16 bit interrupt based x86 system with read/write and graphics 
functionality. This OS contains the following features:

-Scan Disk for "files" (sectors with data).

-Write "file" (data to single sector)

-Read "file" (data from selected sector)

-Delete "file"

-Edit "file" 

-Print help menu for navigation help

-Write and store raw machine code to sector to be executed.

-Dynamically execute stored code

-Switch to graphics mode and allow user to draw on screen using keys and colors

-Print register values.

There is a build script in here. You will need NASM to assemble. If you plan on editing this, 
I recommend Visual Studio Code, as you should be able to open this folder up there and be good 
to go, using the build.bat and run.bat scripts to launch.

To run, you may want to download an x86-64 emulator like qemu and launch there. I have 
included run script, you can use that to launch the program assuming you have qemu 
configured correctly.

This product is in a working state, but is not bug free or complete. I may or may not
continue to work on this when I have time. Feel free to take it and use it however
you like. Questions and more information can be sent to-
camerongrande95@gmail.com
