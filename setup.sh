#!/bin/bash

sudo apt update

sudo apt -y install wget vim make avahi-daemon libavahi-compat-libdnssd-dev build-essential wiringPi

wget https://nodejs.org/dist/v6.9.2/node-v6.9.2-linux-armv6l.tar.xz

tar -xvf node-v6.9.2-linux-armv6l.tar.xz

sudo cp -R node-v6.9.2-linux-armv6l/* /usr/local/

sudo bash -c 'npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
cd /usr/local/lib/node_modules/homebridge/
npm install --unsafe-perm bignum
cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns
node-gyp BUILDTYPE=Release rebuild
npm install -g --unsafe-perm forever
npm install -g --unsafe-perm forever-service
cd /usr/local/lib/
npm install --unsafe-perm homebridge-gpio-wpi'

mkdir ~/.homebridge

echo "Enter a name for your bridge:"
read bridgename
echo "Enter a pin number for first accessory:"
read pin1
echo "Enter a pin number for second accessory:"
read pin2
echo "Enter a pin number for third accessory:"
read pin3
echo "Enter a pin number for fourth accessory:"
read pin4

if [ -z "${bridgename}" ]; then 
    FOO=${bridgename:=Zero}
else 
    FOO=${bridgename}
fi


if [ -z "${pin1}" ]; then 
    FOO=${pin1:=6}
else 
    FOO=${pin1}
fi


if [ -z "${pin2}" ]; then 
    FOO=${pin2:=13}
else 
    FOO=${pin2}
fi


if [ -z "${pin3}" ]; then 
    FOO=${pin3:=19}
else 
    FOO=${pin3}
fi


if [ -z "${pin4}" ]; then 
    FOO=${pin4:=26}
else 
    FOO=${pin4}
fi

cat > ~/.homebridge/config.json <<EOF
{
    "bridge": {
        "name": "$bridgename",
        "username": "00:9E:0E:01:81:DD",
        "port": 51826,
        "pin": "031-45-154"
    },

    "accessories": [
        {
                "accessory": "GPIO",
                "name": "Pin1",
                "pin": $pin1,
                "inverted": "true"
        },
        {
                "accessory": "GPIO",
                "name": "Pin2",
                "pin": $pin2,
                "inverted": "true"
        },
        {
                "accessory": "GPIO",
                "name": "Pin3",
                "pin": $pin3,
                "inverted": "true"
        },
        {
                "accessory": "GPIO",
                "name": "Pin4",
                "pin": $pin4,
                "inverted": "true"
        }
        ],

    "platforms": [
        ]
}
EOF


sudo bash -c 'cat > /etc/systemd/system/homebridge.service' <<EOF
[Unit]
Description=Node.js HomeKit Server
After=syslog.target network-online.target

[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/homebridge
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

cat > ~/.homebridge/boot.py <<EOF
#!/usr/bin/env python

import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


channel = [$pin1,$pin2,$pin3,$pin4]

GPIO.setup(channel, GPIO.OUT, initial=GPIO.HIGH)
EOF

chmod +x ~/.homebridge/boot.py

sudo sed -i -e '$i \python /home/$USER/.homebridge/boot.py\n' /etc/rc.local

~/.homebridge/boot.py

sudo systemctl daemon-reload
sudo systemctl restart homebridge
sudo systemctl enable homebridge

echo "We are done here"
