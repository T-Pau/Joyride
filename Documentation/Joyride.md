# Joyride

This program monitors the controllers connected to your Commodore 64 and displays relevant information. It supports a wide variety of controllers and adapters.

Joyride currently does not work on NTSC machines.

To test the keyboard, use the companion program [Anykey](https://github.com/T-Pau/Anykey).


## Loading the Program

Load the program from disc with `LOAD"*",8` and start it with `RUN`.

On C128, the program loads automatically if the disk is in the drive when turning the computer on.

On MEGA65, switch to 64 mode before loading.


## Views

There are three views:

- controller and user ports
- multi adapters 
- special controllers

Use `F1`/`F2` to switch between views, `C=-F1` to view the included help pages.

Use `Run/Stop` to exit Joyride.

For binary inputs, the button or direction is inverted when pressed. Analog or positional inputs are displayed as numbers and by positioning a cursor.


## Supported Devices

Controller Port:
- [Joystick](https://www.c64-wiki.com/wiki/Joystick)
- [Mouse](https://www.c64-wiki.com/wiki/Mouse_1351)
- [Paddle](https://www.c64-wiki.com/wiki/Paddle)
- [Koalapad](https://en.wikipedia.org/wiki/KoalaPad)
- [Light Pen](https://www.c64-wiki.com/wiki/Light_pen) (only in port 1)
- [Protovision Protopad](https://www.protovision.games/shop/protopad/protopad.php)
- [Trap Them Controller](https://www.polyplay.xyz/Trap-Them-Controller-Commodore-64)

User Port, Two Joysticks:
- [Protovision / Classic Game Adapter](https://www.protovision.games/hardw/4_player.php)
- [Digital Excess / Hitmen](https://hitmen.c02.at/files/hardware/4player/4player.txt)
- [Kingsoft](https://www.synnes.org/c64/c64_joy_adapter_schematics.html)
- [Starbyte Tie Break Adapter](https://hitmen.c02.at/files/hardware/4player/starbyte_adapter.txt)
- PET Dual Joystick

User Port, One Joystick:
- PET Space Invaders+
- VIC-20 OEM
- C64DTV Hummer
- [PETSCII Robots Adapter](https://texelec.com/product/snes-adapter-commodore/)

Multi Adapters:
- [SuperPAD 64](https://www.polyplay.xyz/SuperPad64-8-Spieler-Interface-Commodore-64)
- [Ninja SNES Pad](https://hitmen.c02.at/files/hardware/4player/ninja_snes_adapter.txt)
- [Luigi Pantarotto's Spaceballs](https://www.synnes.org/c64/c64_joy_adapter_schematics.html)
- [Inception](http://www.c64.cz/index.php?static=inception)
- [MultiJoy](http://www.multijoy.net)
- [Wheel of Joy](https://github.com/SukkoPera/WheelOfJoy)
- [Wheel of Joy Mini](https://github.com/SukkoPera/WheelOfJoyMini)

Extra:
- Joystick Mouse
- NEOS Mouse
- Amiga Mouse
- Atari ST Mouse
- Atari CX-22 Trackball
- [Atari CX-21 / CX-50 Keypad](https://github.com/tebl/A2600-Keyboard)
- [Atari CX-85 Keypad](https://www.atariwiki.org/wiki/Wiki.jsp?page=AtariCX85)
- Cardco Cardkey 1
- [Rushware Keypad](https://www.c64-wiki.com/wiki/Rushware_keypad)
- [Coplin Keypad](http://oldcomputer.info/hacks/numpad64/index.htm)


## Controller Ports

The top windows display the devices connected to the controller ports.

Use the function keys to select the correct controller type or to display raw data.

The C64 has two controller ports. These support five digital lines that can be used as input or output, and two potentiometers that give values from 0 to 255.

Except for light pens and light guns, all devices can be connected to either port.


### Joystick

![](images/Joystick.png)

Joysticks contain a stick or d-pad with switches for the four cardinal directions and up to three buttons.

Buttons 2 and 3 bring an analog potentiometer to a low value by connecting its pin to +5V.

These potentiometers are also used by paddles and the 1351 mouse; if such a device is connected, the buttons may read as pressed.


### Mouse

![](images/Mouse.png)

Supported are 1351 compatible mice. They give the position in x and y modulo 64 and support up to three buttons and a scroll wheel.


### Paddle

![](images/Paddle.png)

A paddle gives the rotational position of its knob as a value from 0 to 255. It also contains a button.

Two paddles can be connected to one port at the same time. They are displayed in two separate pages.


### KoalaPad

![](images/Koalapad.png)

This is a touch tablet that gives the position in x and y as values from ca. 6 to 251. It also contains two buttons.


### Light Pen

![](images/Lightpen.png)

Light pens and light guns only work in controller port 1 and require a CRT monitor.

They point directly at a position on screen. This is indicated by a big cross-hair on screen, even if it's outside the display area of the port. It is also shown on a smaller representation of the screen.

They can have up to two buttons. Some pens require a button to be pressed for the position to register.


### Protovision Protopad

![](images/Protopad.png)

This is a SuperNES style controller that can emulate a regular joystick or all buttons can be read in native mode. 

This view displays the native mode. For emulation mode, use the Joystick view. 

It has these inputs:
- d-pad
- four face buttons (A, B, X, Y)
- two shoulder buttons (L, R)
- Select, Start

Note: Support for this controller has not been tested with real hardware.


### Trap Them Controller

![](images/Trap-Them.png)

This is a SuperNES style controller with these inputs:
- d-pad
- four face buttons (1, 2, 3, 4)
- two shoulder buttons (L, R)
- Select, Start


### Raw

![](images/Raw.png)

This view displays the five digital input lines, and the two analog potentiometers as values from 0 to 255.

For port 1, it also displays the light pen coordinates.


## User Port 

The bottom window displays the device connected to the user port.

Use F7/F8 to select the correct device.

The C64 has a user port that allows it to interface with various hardware attachments.


### 4-Player Adapter

![](images/4-Player.png)

These adapters support two additional joysticks with four directional switches and one button each.

Supported are the following variants:
- Protovision / Classic Game Adapter
- Digital Excess / Hitmen
- Kingsoft
- Starbyte Tie Break Adapter

### PET Dual Joystick Adapter

![](images/4-Player.png)

This adapter from TFW8b is designed for the PET, but also works on the C64.

It supports two joysticks with four directional switches and one button each.

Due to technical limitations, up and down can't be read while fire is pressed.

### PET Space Invaders+

![](images/Userport-Joystick.png)

This adapter is an extension of the Space Invaders adapter designed for the PET, which adds up and down.

It supports one joystick with four directional switches and one button.

### VIC-20 OEM

![](images/Userport-Joystick.png)

This adapter was designed for the VIC-20, but also works on the C64.

It supports one joystick with four directional switches and one button.

Note: Support for this adapter has not been tested with real hardware.

### C64DTV Hummer

![](images/Userport-Joystick.png)

This adapter was designed for the C64DTV, but also works on the regular C64.

It supports one joystick with four directional switches and one button.

Note: Support for this adapter has not been tested with real hardware.

### PETSCII Robots Adapter

![](images/PETSCII-Robots.png)

This adapter is included with the game Attack of the PETSCII Robots and allows connecting one SuperNES controller or mouse to the user port.

The controller has these inputs:
- d-pad
- four face buttons (A, B, X, Y)
- two shoulder buttons (L, R)
- Select, Start

Mice display x/y and two buttons.


## Multi Adapters

These adapters support eight or more input devices. The type of devices depends on the adapter.

They connect to the user port, controller port, or both. 

Four controllers are displayed per page, from left to right, top to bottom. Use `F3`/`F4` to switch pages.


### SuperPAD 64 / Ninja SNES Pad

![](images/SuperPAD-64.png)

These adapters support eight Nintendo SuperNES controllers or mice. The types of connected devices are detected automatically.

SuperPAD 64 connects to the user port, Ninja SNES Pad connects to both controller ports.

Controllers have these inputs:
- d-pad
- four face buttons (A, B, X, Y)
- two shoulder buttons (L, R)
- Select, Start

Mice display x/y coordinates and two buttons.

The third page shows the raw data read from each controller.


### Luigi Pantarotto's Spaceballs

![](images/4-Joysticks.png)

This adapter supports eight joysticks with one button each.

It connects to the user port and either controller port.

Note: Support for this adapter has not been tested with real hardware.


### Inception

![](images/4-Joysticks.png)

This adapter supports eight joysticks with one button each.

It connects to either controller port.

PS/2 mice and auto-detection are not supported yet.

The third page shows the raw data read from the adapter.


### MultiJoy / Protovision MultiJoy

![](images/4-Joysticks.png)

These adapter supports joysticks with one button each, depending on model 8 or 16 joysticks.

They connect to both controller ports. For the original variant, port 1 is used for control, port 2 for joysticks. The Protovision variant has the ports swapped.

Note: Support for the sixteen joystick variant has not been tested.


### Wheel of Joy

![](images/4-Joysticks.png)

This adapter from SukkoPera is designed for the Plus/4, but also works on the C64.

It supports eight joysticks with one button each.

It connects to the user port through an adapter cable.

### Wheel of Joy Mini

![](images/4-2-Button-Joysticks.png)

This adapter from SukkoPera is designed for the Plus/4, but also works on the C64.

It supports four joysticks with two buttons each.

It connects to the user port through an adapter cable.

Note: Support for this adapter has not been tested. 


## Special Controllers

These devices don't fit in the regular controller port window or block parts of the keyboard and are therefore collected in a separate view.

While they work in both controller ports, Joyride only supports them in port 1.

Use `F3`/`F4` to switch controller type. 

For keypads, previously pressed keys are displayed in a lighter gray to help detect dead keys. To reset the state of all keys, press `F5`.


### Joystick Mouse

![](images/Trackball.png)

Some mice support joystick mode, in which the directions are pressed for a duration proportional to their movement speed.

To enable this mode on a 1351 mouse, press the right button while connecting it.

This view displays x/y and two buttons, although some models only have one button.


### NEOS Mouse

![](images/NEOS-Mouse.png)

This mouse give the position in x and y modulo 256 and supports two buttons.

Due to technical limitations, mouse movement can't be read while the left button is pressed.

Note: Support for this mouse has not been tested with real hardware.


### Amiga Mouse

![](images/Amiga-ST-Mouse.png)

This mouse displays x/y and two buttons.

The right mouse button can't be read on a Commodore 64.


### Atari ST Mouse

![](images/Amiga-ST-Mouse.png)

This mouse displays x/y and two buttons.

The right mouse button can't be read on a Commodore 64.


### Atari CX-22 Trackball

![](images/Trackball.png)

This trackball displays x/y and one button.

Some versions of this behave like a joystick mouse and should be tested with that view.

Note: Support for this trackball has not been tested with real hardware.


### Atari CX-21 / CX-50 Keypad

![](images/Atari-CX21.png)

This keypad contains 12 keys.


### Atari CX-85 Keypad

![](images/Atari-CX85.png)

This keypad contains 17 keys.

Due to technical limitations, multiple simultaneous key presses can't be read and might register as a different key.

**Warning**: Connecting this keypad directly may damage the Commodore 64. Using protective diodes is advised.


### Cardco Cardkey 1

![](images/Cardkey-1.png)


This keypad contains 16 keys.

Due to technical limitations, multiple simultaneous key presses can't be read and might register as a different key.

Note: Support for this keypad has not been tested with real hardware.


### Rushware Keypad

![](images/Rushware-Keypad.png)

This keypad contains 16 keys.

Due to technical limitations, multiple simultaneous key presses can't be read and might register as a different key.


### Coplin Keypad

![](images/Coplin-Keypad.png)

This keypad contains 12 keys.

Due to technical limitations, multiple simultaneous presses of keys other than `Enter` can't be read and might register as a different key.

Note: Support for this keypad has not been tested with real hardware.
