# Joyride

![Screenshot](screenshot.png)

This program monitors the controllers connected to your Commodore 64 and displays relevant information depending on their types. You can use the function keys to select the correct type or to display raw data.

Adapters that support more than two controllers don't fit in the main screen. `F7` switches to a layout that supports four controllers per page.

For digital inputs, the button or direction is inverted when pressed. Analog inputs are displayed as numbers and by positioning a cursor.

To test the keyboard, please use the companion program [Anykey](https://github.com/T-Pau/Anykey).

Joyride currently does not work on NTSC machines.

## Supported Devices

The following devices are supported:

Controller Port:
- Joystick
- Mouse
- Paddle
- Koalapad
- Light Pen (only in port 1)
- Protovision Protopad
- Trap Them Controller

User Port:
- Protovision / Classic Game Adapter
- Digital Excess / Hitmen
- Kingsoft
- Starbyte Tie Break Adapter
- PETSCII Robots Adapter

Multi Adapters:
- SuperPAD 64
- Ninja SNED Pad
- Luigi Pantarotto's Spaceballs
- Inception
- MultiJoy


## Using Joyride

For detailed usage instructions, see the documentation page:

- [Joyride](Documentation/Joyride.md)


## Building Joyride

See [BUILDING.md](BUILDING.md)
