#!/bin/bash

apt update

apt -y install wget vim make libavahi-compat-libdnssd-dev build-essential

wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-armv6l.tar.xz

tar -xvf node-v6.9.1-linux-armv6l.tar.xz

cp -R node-v6.9.1-linux-armv6l/* /usr/local/

npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
cd /usr/local/lib/node_modules/homebridge/
npm install --unsafe-perm bignum
cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns
node-gyp BUILDTYPE=Release rebuild

npm install -g forever
npm install -g forever-service
npm install -u wiring-pi
npm install -u homebridge-gpio-wpi

mkdir /var/homebridge
cat <<EOT >> /var/homebridge/config.json
{
    "bridge": {
        "name": "Zero",
        "username": "00:9E:0E:01:81:DD",
        "port": 51826,
        "pin": "031-45-154"
    },

    "accessories": [
        {
                "accessory": "GPIO",
                "name": "Pin1",
                "pin": 6
        },
        {
                "accessory": "GPIO",
                "name": "Pin2",
                "pin": 13
        },
        {
                "accessory": "GPIO",
                "name": "Pin3",
                "pin": 19
        },
        {
                "accessory": "GPIO",
                "name": "Pin4",
                "pin": 26
        }
        ],

    "platforms": [
        ]
}
EOT

cat <<EOT >> /etc/systemd/system/homebridge.service
HOMEBRIDGE_OPTS=-U /var/homebridge

[Unit]
Description=homebridge_service
After=basic.target
[Service]
Type=simple
User=root
EnvironmentFile=/etc/default/homebridge
ExecStart=/usr/local/bin/homebridge $HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process
[Install]
WantedBy=multi-user.target
EOT
