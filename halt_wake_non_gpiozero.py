import RPi.GPIO as GPIO
import os
import time
from multiprocessing import Process

#initialize pins
powerPin = 3 #pin 5
ledPin = 14 #TXD
resetPin = 27 #pin 13

#initialize GPIO settings
def init():
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(powerPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	GPIO.setup(resetPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	GPIO.setup(ledPin, GPIO.OUT)
	GPIO.setwarnings(False)

#waits for user to hold button up to 1 second before issuing poweroff command
def poweroff():
	while True:
		GPIO.wait_for_edge(powerPin, GPIO.FALLING)
		start = time.time()
		while GPIO.input(powerPin) == GPIO.LOW:
			hold = time.time() - start
			if hold >= 1:
				os.system("shutdown -h now")

#blinks the LED to signal button being pushed
def ledBlink():
	while True:
		GPIO.output(ledPin, GPIO.HIGH)
		GPIO.wait_for_edge(powerPin, GPIO.FALLING)
		start = time.time()
		while GPIO.input(powerPin) == GPIO.LOW:
			GPIO.output(ledPin, GPIO.LOW)
			time.sleep(0.33)
			GPIO.output(ledPin, GPIO.HIGH)
			time.sleep(0.33)

#resets the pi
def reset():
	while True:
		GPIO.wait_for_edge(resetPin, GPIO.FALLING)
		os.system("shutdown -r now")


if __name__ == "__main__":
	#initialize GPIO settings
	init()
	#create a multiprocessing.Process instance for each function to enable parallelism 
	powerProcess = Process(target = poweroff)
	powerProcess.start()
	ledProcess = Process(target = ledBlink)
	ledProcess.start()
	resetProcess = Process(target = reset)
	resetProcess.start()

	powerProcess.join()
	ledProcess.join()
	resetProcess.join()

	GPIO.cleanup()
