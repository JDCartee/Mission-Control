from time import sleep
import sys
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
GPIO.setup(13, GPIO.OUT)
GPIO.setup(15, GPIO.OUT)
GPIO.setup(16, GPIO.OUT)
cycles = str(sys.argv[1])
i=0
while i<int(cycles):
     GPIO.output(13, False)
     sleep(0.1)
     GPIO.output(13, True)
     sleep(0.1)

     GPIO.output(15, False)
     sleep(0.1)
     GPIO.output(15, True)
     sleep(0.1)

     GPIO.output(16, False)
     sleep(0.1)
     GPIO.output(16, True)
     sleep(0.1)
     i+=1

	 
