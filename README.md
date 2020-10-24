# Joyride

This program monitors the controllers connected to your C64 and displays relevant information depending on their types. You can use the function keys to select the correct type or to display raw data.

Supported are:

- Joystick
- Mouse
- Paddle
- Koalapad
- Userport Joystick Adapter

For digital inputs, the button or direction is inverted when pressed. Analog inputs are displayed as numbers and by positioning a pointer.


## Joystick

Joysticks contain a stick or d-pad with switches for the 4 cardinal directions and up to 3 buttons.


## Mouse

Supported are 1351 compatible mice. They give the position modulo 64 and support up to 3 buttons and a scroll wheel.


## Paddle

A paddle gives the rotational position of its knob as a value from 0 to 255. It also contains a button.

Two paddles can be connected to one port at the same time.


## Koalapad

This is a touch tablet that gives the position in X and Y as values from ca. 6 to 251. It also contains two buttons.


## Raw Data

This displays the 5 digital input lines and the 2 analog potentiometers as values from 0 to 255.


## Userport Joystick Adapter

These adapters support two aditional joysticks with four directional switches one button each.

Supported are the following variants:

- Protovision / Common Game Adapter
- Digital Excess / Hitmen
- Starbyte
- Kingsoft