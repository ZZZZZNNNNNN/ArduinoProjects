#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

byte degree_symbol[8] = {
  0b00111,
  0b00101,
  0b00111,
  0b00000,
  0b00000,
  0b00000,
  0b00000,
  0b00000
};

int gate = 11;
volatile unsigned long duration = 0;
unsigned char i[5];
unsigned int j[40];
unsigned char value = 0;
unsigned answer = 0;
int z = 0;

void setup() {
  Serial.begin(9600);   // <-- important for Python connection

  lcd.init();
  lcd.backlight();
  lcd.print("Temp = ");
  lcd.setCursor(0, 1);
  lcd.print("Humidity = ");
  lcd.createChar(1, degree_symbol);
  lcd.setCursor(9, 0);
  lcd.write(1);
  lcd.print("C");
  lcd.setCursor(13, 1);
  lcd.print("%");
}

void loop() {
  delay(1000);

  // Start signal
  pinMode(gate, OUTPUT);
  digitalWrite(gate, LOW);
  delay(20);
  digitalWrite(gate, HIGH);
  pinMode(gate, INPUT_PULLUP);

  duration = pulseIn(gate, LOW);

  if (duration <= 84 && duration >= 72) {
    while (z < 40) {
      duration = pulseIn(gate, HIGH);

      if (duration >= 20 && duration <= 26) value = 0;
      else if (duration >= 65 && duration <= 74) value = 1;

      i[z / 8] |= value << (7 - (z % 8));
      j[z] = value;
      z++;
    }
  }

  answer = i[0] + i[1] + i[2] + i[3];

  if (answer == i[4] && answer != 0) {
    int humidity = i[0];
    int temperature = i[2];

    // Print on LCD
    lcd.setCursor(7, 0);
    lcd.print(temperature);
    lcd.setCursor(11, 1);
    lcd.print(humidity);

    // Send to Python via Serial in CSV format
    Serial.print(humidity);
    Serial.print(",");
    Serial.println(temperature);
  }

  // Reset for next reading
  z = 0;
  i[0] = i[1] = i[2] = i[3] = i[4] = 0;
}
