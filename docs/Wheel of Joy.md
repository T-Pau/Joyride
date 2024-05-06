The following is taken from the [official Github repsoitory](https://github.com/SukkoPera/WheelOfJoy):

## Programming
The board uses 5 8-to-1 multiplexers, one per direction plus one for the fire button. Channel selection happens in parallel on all multiplexers and is done with the 3 high bits of the User Port:

1. Write a value N at the User Port register depending on the port you want to read. General formula for port P ∈ [1,8] is the following:

   ```N = ((P - 1) << 5) | 0x1F```

   Or just pick your value from the following table:

   | # | Binary    | Hex| Dec | Notes                        |
      |---|-----------|----|-----|------------------------------|
   | 1 | 000 11111 | 1F |  31 |                              |
   | 2 | 001 11111 | 3F |  63 |                              |
   | 3 | 010 11111 | 5F |  95 |                              |
   | 4 | 011 11111 | 7F | 127 | Port 6 in Solder's numbering |
   | 5 | 100 11111 | 9F | 159 |                              |
   | 6 | 101 11111 | BF | 191 | Port 5 in Solder's numbering |
   | 7 | 110 11111 | DF | 223 | Port 4 in Solder's numbering |
   | 8 | 111 11111 | FF | 255 |                              |

2. Read the value of the User Port register, the lower 5 bits will report direction/button status:

   | Bit 7 | Bit 6 | Bit 5 | Bit 4 | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
      |-------|-------|-------|-------|-------|-------|-------|-------|
   |   X   |   X   |   X   | Fire  | Left  | Right | Down  | Up    |

   Every bit will be 0 if the corresponding direction/button is pressed, 1 otherwise.

This means that the board works exactly like the one from Solder but the selection value is not restricted to those having exactly one zero. All values will select the corresponding port, software compatible with Solder adapter will select ports 7, 6 and 4 as 4, 5 and 6 respectively (Solder's numbering counts joystick 3 as the one available on [SID cards](https://github.com/SukkoPera/ReSeed)).

The multiplexers used on the board are analog, so the adapter is bidirectional and the ports can also be independently used as 5-bit output ports.
