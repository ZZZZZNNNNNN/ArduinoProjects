import serial
import time

# ⚠️ Change COM port to your Arduino’s actual port
# Example: COM4 on Windows, or '/dev/ttyACM0' on Linux/Mac
arduino_port = 'COM5'
baud = 9600

try:
    arduino = serial.Serial(arduino_port, baud, timeout=1)
    time.sleep(2)  # wait for connection
    print("Connected to Arduino on", arduino_port)
except Exception as e:
    print("Error connecting to Arduino:", e)
    exit()

def send_command(cmd):
    arduino.write((cmd + "\n").encode())
    print(f"Sent command: {cmd}")

while True:
    print("\n=== Load/Unload System ===")
    print("1. Load")
    print("2. Unload")
    print("3. Exit")
    choice = input("Enter choice: ")

    if choice == '1':
        send_command("LOAD")
    elif choice == '2':
        send_command("UNLOAD")
    elif choice == '3':
        print("Exiting system...")
        break
    else:
        print("Invalid input")

arduino.close()
