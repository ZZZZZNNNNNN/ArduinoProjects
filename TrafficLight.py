import serial
import time

# Change "COM5" to your Arduino port"
arduino = serial.Serial(port="COM5", baudrate=9600, timeout=1)
time.sleep(2)  # wait for connection

while True:
    # RED
    arduino.write(b'R')
    print("🔴 RED ON")
    time.sleep(10)

    # GREEN
    arduino.write(b'G')
    print("🟢 GREEN ON")
    time.sleep(10)

    # YELLOW
    arduino.write(b'Y')
    print("🟡 YELLOW ON")
    time.sleep(10)
