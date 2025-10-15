int leds[10] = {2,3,4,5,6,7,8,9,10,11};

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < 10; i++) {
    pinMode(leds[i], OUTPUT);
  }
  Serial.println("Arduino Ready");
}

void loop() {
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n');
    command.trim();  // remove any extra spaces or line breaks

    if (command == "LOAD") {
      Serial.println("Loading...");
      for (int i = 0; i < 10; i++) {
        digitalWrite(leds[i], HIGH);
        delay(150);
      }
    } 
    else if (command == "UNLOAD") {
      Serial.println("Unloading...");
      for (int i = 9; i >= 0; i--) {
        digitalWrite(leds[i], LOW);
        delay(150);
      }
    }
  }
}
