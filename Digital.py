import serial
import time


arduino = serial.Serial('COM5', 9600, timeout=1)
time.sleep(2)  

def send(expr):
   
    arduino.write((expr + '\n').encode())
    time.sleep(0.5)

   
    while True:
        line = arduino.readline().decode(errors='ignore').strip()
        if line:
            if "Result (Decimal):" in line:
                result_str = line.split(":")[1].strip()
                result_float = float(result_str)
                
                print(f"Output: {result_float:05.2f}")
               
            else:
                print(line)
        else:
            break

print("Binary Arithmetic")
print("Presented by: Cordero, Din, Brufal, Guevarra, Tomes, Grifaldia, Garcia")
print("Type 'q' to quit\n")

while True:
    expr = input("Enter binary expression: ")
    if expr.lower() == 'q':
        break
    send(expr)
