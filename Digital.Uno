#include <SevSeg.h>
SevSeg sevseg;

// Recommended wiring pins
int pinA = 2;
int pinB = 3;
int pinC = 4;
int pinD = 5;
int pinE = 6;
int pinF = 7;
int pinG = 8;
int pinDP = 9;  // External LED decimal point
int D1 = 10;
int D2 = 11;
int D3 = 12;
int D4 = 13;

String inputString = "";
bool stringComplete = false;
float displayValue = 0.0;

void setup() {
  Serial.begin(9600);

  pinMode(pinDP, OUTPUT);   // external LED DP
  digitalWrite(pinDP, HIGH); // start OFF (common anode logic)

  byte numDigits = 4;
  byte digitPins[] = {D1, D2, D3, D4};
  byte segmentPins[] = {pinA, pinB, pinC, pinD, pinE, pinF, pinG, pinDP};
  bool resistorsOnSegments = true;
  byte hardwareConfig = COMMON_ANODE;

  sevseg.begin(hardwareConfig, numDigits, digitPins, segmentPins, resistorsOnSegments);
  sevseg.setBrightness(90);

  Serial.println("Ready. Send binary arithmetic (e.g., 1010+0101)");
}

void loop() {
  // Continuous display refresh for stability
  for (int i = 0; i < 200; i++) {
    sevseg.setNumberF(displayValue, 2); // 2 decimal places
    sevseg.refreshDisplay();
    delay(1);
  }

  // External LED decimal point ON if we have decimal places
  if ((displayValue - int(displayValue)) != 0) {
    digitalWrite(pinDP, LOW);  // LED ON (common anode)
  } else {
    digitalWrite(pinDP, HIGH); // LED OFF
  }

  if (stringComplete) {
    processInput(inputString);
    inputString = "";
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '\n') stringComplete = true;
    else inputString += inChar;
  }
}

void processInput(String data) {
  data.trim();
  if (data.length() == 0) return;

  char op = ' ';
  int index = -1;

  for (int i = 0; i < data.length(); i++) {
    if (data[i] == '+' || data[i] == '-' || data[i] == '*' || data[i] == '/') {
      op = data[i];
      index = i;
      break;
    }
  }

  if (index == -1) {
    Serial.println("Invalid input");
    return;
  }

  String bin1 = data.substring(0, index);
  String bin2 = data.substring(index + 1);

  int num1 = strtol(bin1.c_str(), NULL, 2);
  int num2 = strtol(bin2.c_str(), NULL, 2);
  float result = 0;

  switch (op) {
    case '+': result = num1 + num2; break;
    case '-': result = num1 - num2; break;
    case '*': result = num1 * num2; break;
    case '/': result = (num2 != 0) ? (float)num1 / num2 : 0; break;
  }

  if (result < 0) result = 0;
  if (result > 9999) result = fmod(result, 10000);

  displayValue = result;
  Serial.print("Result (Decimal): ");
  Serial.println(result, 2);
}
