#!/usr/bin/env python

import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


inpin=17
outpin=26
channel=inpin
state=0
GPIO.setup(channel, GPIO.IN)
GPIO.setup(outpin, GPIO.OUT)

loop=1


while loop==1:
	channel = GPIO.wait_for_edge(channel, GPIO.BOTH, timeout=60000)
	if channel is None:
		print('Timeout occurred')
	else:
		state=not GPIO.input(channel)
		GPIO.output(outpin, state)
		print('Edge detected on channel', channel)

print state
