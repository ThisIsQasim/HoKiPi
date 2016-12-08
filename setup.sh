#!/bin/bash

sudo apt update

sudo apt -y install wget vim make libavahi-compat-libdnssd-dev build-essential wiringPi

wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-armv6l.tar.xz

tar -xvf node-v6.9.1-linux-armv6l.tar.xz

sudo cp -R node-v6.9.1-linux-armv6l/* /usr/local/

sudo bash -c 'npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
cd /usr/local/lib/node_modules/homebridge/
npm install --unsafe-perm bignum
cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns
node-gyp BUILDTYPE=Release rebuild'

sudo npm install -g forever --unsafe-perm
sudo npm install -g forever-service --unsafe-perm
sudo npm install -g wiring-pi --unsafe-perm
sudo npm install -g homebridge-gpio-wpi --unsafe-perm

sudo mkdir /var/homebridge

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

sudo bash -c 'cat > /var/homebridge/config.json' <<EOF
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

HOMEBRIDGE_OPTS=-U /var/homebridge

sudo bash -c 'cat > /etc/systemd/system/homebridge.service' <<EOF
[Unit]
Description=homebridge_service
After=basic.target
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/homebridge $HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

sudo bash -c 'cat > /var/homebridge/boot.py' <<EOF
#!/usr/bin/env python

import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


channel = [$pin1,$pin2,$pin3,$pin4]

GPIO.setup(channel, GPIO.OUT, initial=GPIO.HIGH)
EOF

sudo chmod +x /var/homebridge/boot.py

sudo sed -i -e '$i \python /var/homebridge/boot.py\n' /etc/rc.local


sudo systemctl daemon-reload
sudo systemctl start homebridge
sudo systemctl enable homebridge

echo "We are done here"
