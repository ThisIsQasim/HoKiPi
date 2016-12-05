#!/bin/bash

apt update

apt -y install wget vim make libavahi-compat-libdnssd-dev build-essential

wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-armv6l.tar.xz

tar -xvf node-v6.9.1-linux-armv6l.tar.xz

sudo cp -R node-v6.9.1-linux-armv6l/* /usr/local/

sudo npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
cd /usr/local/lib/node_modules/homebridge/
sudo npm install --unsafe-perm bignum
cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns
sudo node-gyp BUILDTYPE=Release rebuild

npm install -g forever
npm install -g forever-service
