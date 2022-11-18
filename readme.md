# Blueberry Bagel

A device for instant checks of air temperature and quality.

# A note on licensing

This repository makes use of a few external libraries. Their licenses can be
found at the following links:

- [Adafruit CCS811](https://github.com/adafruit/Adafruit_CCS811)
- [Adafruit Bus IO](https://github.com/adafruit/Adafruit_BusIO)

In addition, several schematics and datasheets are included for quick reference.
These documents are covered by the licenses specified by their respective
owners. All other code and artifacts in this repository are covered by the
[license](license.txt) file in this directory.

# How to use

Place the device anywhere next to a power source and plug it in. The button on
the device can be pressed at any time to activate the light emitting diodes
(LEDs).

- four read LEDs for air quality?
- rgb LED for temperature?

## Power source

This repository does not bother with what sort of power source is used; only
that it supplies 5 volts worth of power through the USB port or the J2-1 pin.
Refer to the [board schematic](doc/arduino-nano-schematic.pdf) for pin
locations. If power is supplied as anticipated the blue LED by the micro USB
port will glow.

# Build commands

Run `make` without any arguments to see an up to date list of commands along
with their description.

## Upload considerations

The device will need to be connected to your development system through the
micro USB port. Your `/dev` directory (and your `/proc/devices` file) should
have a new ttyUSB entry for the device. Ensure this device has read / write
permissions for your user using `chmod`.

# Specifications

## Software

- Platform: Ubuntu 22.04.1 x86_64
- Arduino IDE: 2.0.1 Linux 64 bit
- `make`: v4.3
- `avrdude`: v6.0.3-arduino17
- `gcc`: 7.3.0-atmel3.6.1-arduino7
- Adafruit CCS811 library: 1.1.1
- Adafruit BusIO library: 1.14.1

