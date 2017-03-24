# HoKiPi
Installation scripts to create HomeKit enabled home automation system using Homebridge on a RaspberryPi 1/Zero.

The scripts setup GPIO pins on a RaspberryPi to control an attached four channel relay that can control various electrical equipment.

## Installation

Run as normal user and make sure your user can sudo without prompting for password.

    git clone https://github.com/ThisIsQasim/HoKiPi
    sh HoKiPi/setup.sh

Enter name for the device and pin numbers according to your setup. Pins should be according to BCM numbers. You can leave the entries blank to set name as Zero and pins as 6,13,19,26 which are the last four pins on the right side of the Pi headers.

Make sure you are connected to same network as your Pi. From your iOS device add the accesory. Use password 031-45-154. And your good to go.

## Credits

homebridge-gpio-wpi plugin: https://github.com/rsg98/homebridge-gpio-wpi
homebridge: https://github.com/nfarina/homebridge
HAP-NodeJS: https://github.com/KhaosT/HAP-NodeJS
