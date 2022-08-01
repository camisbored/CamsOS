CamsOS-
A BIOS 16-bit interrupt based x86 operating system with read/write and graphics 
functionality. This OS contains the following features:

  1. Scan Disk for "files" (sectors with data).

  ![image](https://user-images.githubusercontent.com/81730723/182150936-7c29dfa5-f9bf-47c5-9bec-1f97df3bc233.png)

  2. Write and encrypt "file" (data to single sector) and date/time stamps end of sector
  
  ![image](https://user-images.githubusercontent.com/81730723/182149985-ff005a30-dd8d-47f4-8279-bbb663a3b035.png)

  3. Read and decrypt "file" (data from selected sector)
  
  ![image](https://user-images.githubusercontent.com/81730723/182150103-27c8f979-6b9a-406e-aefc-77abbcc063bf.png)

  4. Delete "file"
  
  ![image](https://user-images.githubusercontent.com/81730723/182151093-e9045fed-740e-4cc3-9c37-4161e18b28e4.png)

  5. Edit "file" 
  
  ![image](https://user-images.githubusercontent.com/81730723/182150282-ed48b8df-936d-4cbe-be93-23f55524326e.png)

  6. Print help menu for navigation help
  
  ![image](https://user-images.githubusercontent.com/81730723/182150385-a7719147-d0b7-40e2-a994-3782b7176163.png)

  7. Write and store raw machine code to sector to be executed.
  
  ![image](https://user-images.githubusercontent.com/81730723/182150645-34ae68f8-6de9-49bb-af96-bb5c27872afb.png)

  8. Dynamically execute stored code
  
  ![image](https://user-images.githubusercontent.com/81730723/182150764-2f66e0db-ad9c-434f-bb52-21bbff30f976.png)

  9. Switch to graphics mode and allow user to draw on screen using keys and colors
  
  ![image](https://user-images.githubusercontent.com/81730723/182151531-2342ce9b-8295-4adc-bda5-29dcbe3bcf98.png)

  10. Print register values.
  
  ![image](https://user-images.githubusercontent.com/81730723/182151678-400c3b09-7b3c-4d47-9b7b-91b32fd6dbe0.png)

  11. Image rendering- will display an image of my cat on the screen.
  
  ![image](https://user-images.githubusercontent.com/81730723/182151905-04679220-c143-4ed6-a26c-afb820bca83c.png)

  12. A mouse demo feature that will turn the mouse on and change screen based on clicks (currently no way to return from this)
  
  ![image](https://user-images.githubusercontent.com/81730723/182152859-4fc4d724-29bb-4f56-9756-c1949a3c7996.png)

  13. A start of a calculator
  
  ![image](https://user-images.githubusercontent.com/81730723/182152509-99a30f2d-a960-4ef0-beff-87949b0eb485.png)

  14. A print date/time feature
  
  ![image](https://user-images.githubusercontent.com/81730723/182152153-5b7783b5-8d3e-433d-af81-dc807cda503b.png)

  15. A start and mostly functioning pong game
  
  ![image](https://user-images.githubusercontent.com/81730723/182152318-aff780b0-50a2-488e-8c21-d8a5dbba7638.png)

  16. Will play audio sequence through speaker.
  
  ![image](https://user-images.githubusercontent.com/81730723/182152076-cdc6f718-ecfb-4e98-9bb8-0474f86ab18b.png)

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
