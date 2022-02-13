# Phantom Controller Mobile Application

## What's this about?

This is the flutter-based mobile application used to control
the [Phantom Controller device](https://github.com/adrian-dobre/Phantom-Controller). It can perform
all the functions that the standard remote, shipped with NovingAir Phantom (Wireless or Active), can
perform plus monitoring temperature, relative humidity, ambient light, pressure and CO2 levels.

![App Demo](./resources/demo/app-demo.gif?raw=true)
![Config Screen](./resources/demo/config-screen.png?raw=true)

## Why do it?

Well, due to a few of reasons:

1. NovingAir Phantom HRV system does not have a connected solution, just
   a [standard IR remote control](https://ventilatie-recuperare.ro/produs/telecomanda-tc-phantom-active/)
2. It makes sense to combine the "controller" with a Weather Station - this can allow creating
   automations without having to purchase separate sensors
3. I like controlling my devices from my phone. I used a general purpose, programmable RC (Broadlink
   RM4 mini) for this in the past, but I didn't quite like how everything looked/worked.