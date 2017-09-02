# stm32f4xx-dac
USB Sound Card - DAC - Based on ST stm32f4xx Discovery Board (CIRRUS CS43l22 DAC)


# Overview
Based on SMT Cube Demo, and works of www.tjaekel.com/DiscoveryUSB/index.html


# Installation
Pre compiled binary can be flashed by downloading latest release from releases section. 
https://github.com/aniljava/stm32f4xx-dac/releases/download/1.0/stm32f4xx-dac.bin

and flashing as : `st-flash write stm32f4xx-dac.bin 0x8000000`

# Source modification and installation

    make clean    
    make flash

# Notes on power
Needs to be powered using miniUSB (CN1), or connecting pin PA9 to 5V like picture below.

<img src ="https://github.com/aniljava/stm32f4xx-dac/blob/master/res/front.jpg">

<img src ="https://github.com/aniljava/stm32f4xx-dac/blob/master/res/rear.jpg">
PIN PA9 -> PIN 5V
