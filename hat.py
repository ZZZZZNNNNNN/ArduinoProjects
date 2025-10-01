import serial
import time
import sys

arduino = serial.Serial(port="COM5", baudrate=9600, timeout=1)

time.sleep(2)  # wait for Arduino reset

print("Reading data...\n")

while True:
    if arduino.in_waiting > 0:
        line = arduino.readline().decode('utf-8').strip()
        if line:
            try:
                humidity, temperature = line.split(",")
                sys.stdout.write(f"\rHumidity: {humidity}%  |  Temperature: {temperature}°C   ")
                sys.stdout.flush()
            except:
                sys.stdout.write(f"\rInvalid data: {line}   ")
                sys.stdout.flush()
