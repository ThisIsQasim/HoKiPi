#!/usr/bin/env python
import socket

s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
s.sendto('\xff'*6+'\x64\x31\x50\x10\x7C\x15'*16, ("255.255.255.255",9))
