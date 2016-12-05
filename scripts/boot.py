#!/usr/bin/env python

import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


channel = [6,13,19,26]

GPIO.setup(channel, GPIO.OUT, initial=GPIO.HIGH)



