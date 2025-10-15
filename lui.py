import serial
import time

arduino_port = 'COM5'
baud = 9600

try:
    arduino = serial.Serial(arduino_port, baud, timeout=1)
    time.sleep(2)
    print("Connected to Arduino on", arduino_port)

except Exception as e:
    print("❌ Error connecting to Arduino:", e)
    exit()

def send_command(cmd):
    arduino.write((cmd + "\n").encode())
    print(f"Sent command: {cmd}")

while True:
    print("\n=== Load/Unload System ===")
    print("Presented By Steven Jonathan Din\n")

    print("L. Load ")
    print("U. Unload ")
    print("E. Exit")
    choice = input("Enter choice: ")

    if choice == 'L':
        send_command("LOAD")
    elif choice == 'U':
        send_command("UNLOAD")
    elif choice == 'E':
        print("Exiting system...")
        break
    else:
        print("Invalid input")

arduino.close()
