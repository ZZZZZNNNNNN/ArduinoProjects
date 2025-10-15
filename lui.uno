#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // Change to 0x3F if needed

int leds[10] = {2,3,4,5,6,7,8,9,10,11};
int currentBar = 0; // current LED count (0 to 10)

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();

  for (int i = 0; i < 10; i++) {
    pinMode(leds[i], OUTPUT);
  }

  lcd.setCursor(0, 0);
  lcd.print("System Ready");
  lcd.setCursor(0, 1);
  lcd.print("Bar: 0/10");
  Serial.println("Arduino Ready");
}

void loop() {
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    command.trim();

    if (command == "LOAD") {
      if (currentBar < 10) {
        digitalWrite(leds[currentBar], HIGH);
        currentBar++;
        updateLCD("Loading...");
      } else {
        updateLCD("Already Full");
      }
    }

    else if (command == "UNLOAD") {
      if (currentBar > 0) {
        currentBar--;
        digitalWrite(leds[currentBar], LOW);
        updateLCD("Unloading...");
      } else {
        updateLCD("Already Empty");
      }
    }
  }
}

void updateLCD(String action) {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(action);
  lcd.setCursor(0, 1);
  lcd.print("Bar: ");
  lcd.print(currentBar);
  lcd.print("/10");
  Serial.print("Current Bar: ");
  Serial.println(currentBar);
}
