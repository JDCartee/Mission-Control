Mission Control
===============

Project for initiating GPIO control scripts on a Raspberry Pi through an Apache web service

This project is set up to allow dynamic REST calls to your web service specifically 
to control GPIO pins on your Raspberry Pi.

The REST call is made up of three main components for this initial version

1. URL
2. parameter name
3. parameter value (int)

example: http://192.168.0.10/index_param.php?key=50

where...

URL = http://192.168.0.10/index_param.php
parameter name = key
parameter value = 50

The PHP script reflected in this example is charged with initiating the defined Python
script (within the PHP page) and passing it the key/value pair. The python script can be
modified to interpret the key/value pair as needed. In the current example it is simply a 
counter to determine how many times to run through a loop turning GPIO pins on and off to 
flash LEDs.

Look in Mission Control/Server for the PHP page (index_param.php) and 
Python script example (blink_param.py) for example GPIO control. 

Look in Mission Control/Raspberry Pi for pinout diagrams and schematics that will help you
build the GPIO example circuit referenced in this project. The following instructional 
video was the inspiration for this project...

https://www.youtube.com/watch?v=IP-szuon2Bk
