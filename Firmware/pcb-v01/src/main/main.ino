/*
iMac PCB
LED Fade Test & Exploration of the ATMEGA32u4

# Reference material for Arduino Leonardo
http://provideyourown.com/2012/arduino-leonardo-versus-uno-whats-new/

https://www.arduino.cc/en/Guide/ArduinoLeonardoMicro
Board reference https://www.arduino.cc/en/Main/arduinoBoardLeonardo
Leonardo vs Uno http://www.doctormonk.com/2012/10/arduino-leonardo-vs-arduino-uno.html


*/
const byte LED1_PIN = 3;
const byte LED2_PIN = 6;
byte led1val = 0;
byte led2val = 0;
byte led1inc = 5;
byte led2inc = 5;
int ana0 = 0;
int footpedal = 0;
int ana2 = 0;

void setup() {
  pinMode(LED1_PIN, OUTPUT);
  pinMode(LED2_PIN, OUTPUT);
  Serial.begin(9600);
  //while (!Serial) ; // In case you want to wait for a serial connection to be established before starting
  Serial.println("Hello World");
}

void loop() {
  ana0 = analogRead(A0);
  footpedal = map(constrain(analogRead(A1), 45, 1023), 45, 1023, 5, 100); // footpedal (approx 45 to 1024)
  ana2 = map(analogRead(A2), 0, 1023, 0, 255); // pot, not used
  led1val += led1inc;
  if(led1val > 255 || led1val < 0) {
    led1val = constrain(led1val, 0, 255);
    led1inc *= -1;
  }
  led2val = 255-led2val;

  analogWrite(LED1_PIN, led1val);
  analogWrite(LED2_PIN, led2val);
  Serial.print("A0:");
  Serial.print(ana0);
  Serial.print("  PEDAL:");
  Serial.print(footpedal);
  Serial.print("  A2:");
  Serial.println(ana2);
  delay(footpedal);
}
