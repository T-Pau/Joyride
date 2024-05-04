# Building Anykey from Source

## Required Tools

You will need the following programs installed:

- [Accelerate](https://github.com/T-Pau/Accelerate)
- `c1541` utility from [Vice](http://vice-emu.sourceforge.net)
- [fast-ninja](https://github.com/T-Pau/fast-ninja/)
- [gfx-converter](https://github.com/T-Pau/gfx-converter)
- [ninja](https://ninja-build.org/)
- [Python](https://www.python.org/)

Graphics are drawn in [Affinity Photo](https://affinity.serif.com/en-gb/photo/).

## Building 

To build Joyride:

```shell
mkdir build
cd build
fast-ninja ..
ninja
```

To create a binary distribution:

```shell
ninja dist
```
