/********************************
iMac Switch Controller

16 Jan 2016
Jonathan Reus-Brodsky

***************************/

#include <TimerOne.h>

// Pots start counting from the leftmost pot
const int POTPIN1 = A5;
const int POTPIN2 = A4;
const int POTPIN3 = A3;

// Digital outputs start counting from the left
const int OUTPIN1 = 6;
const int OUTPIN2 = 5;
const int OUTPIN3 = 3;

// Patterns
const long counter_speed = 100;  // period of the root step  - this is the counter speed in microseconds
const int pat1[] = {0, 1, 0, 1};
const int pat2[] = {0, 1, 1, 1};
const int pat3[] = {0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0,0,0,0,0,1, 1, 0, 0, 0, 1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1};
volatile int pat1_mod = 4;
volatile int pat2_mod = 4;
volatile int pat3_mod = 4;
volatile int pat1size;
volatile int pat2size;
volatile int pat3size;
int speed = 10;

volatile unsigned long counter = 0; // use volatile for shared variables
volatile unsigned long counter1 = 0; // use volatile for shared variables
volatile unsigned long counter2 = 0; // use volatile for shared variables
volatile unsigned long counter3 = 0; // use volatile for shared variables
volatile int out3state = LOW;


void sequenceStep(void)
{  
  counter += 1;
  if(pat3_mod == 0) {
    out3state = HIGH;  // an option to keep the gate open
  } else if(pat3_mod == 9999) {
    out3state = LOW;   // an option to keep the gate closed
  } else {
    if(counter % pat3_mod == 0) {
    counter3 += 1;
    }
    out3state = pat3[counter3 % pat3size];
  }
  digitalWrite(OUTPIN1, out3state);
  digitalWrite(OUTPIN2, out3state);
  digitalWrite(OUTPIN3, out3state);
}



void setup() {
 Serial.begin(9600); 
 pinMode(OUTPIN1, OUTPUT);
 pinMode(OUTPIN2, OUTPUT);
 pinMode(OUTPIN3, OUTPUT);
 pat1size = sizeof(pat1) / sizeof(int);
 pat2size = sizeof(pat2) / sizeof(int);
 pat3size = sizeof(pat3) / sizeof(int);
 Timer1.initialize(100000);
 Timer1.attachInterrupt(sequenceStep); // blinkLED to run every 0.1 seconds
 Timer1.setPeriod(counter_speed);
}



void loop() {
  int pot1, pot2, pot3, localout3;
  int pot1_map, pot2_map, pot3_map;
  unsigned long localcounter;
  pot1 = analogRead(POTPIN1);
  pot2 = analogRead(POTPIN2);
  pot3 = analogRead(POTPIN3);
  
  pot2_map = map(pot2, 0, 1023, 0, 300);
  if(pot2_map == 300) {
    pot2_map = 9999;
  };
  
  Serial.print("POT1: ");
  Serial.print(pot1);
  Serial.print("   POT2: ");
  Serial.print(pot2);
  Serial.print("   POT3: ");
  Serial.print(pot3);
  Serial.print("   COUNT: ");
  noInterrupts();
  pat3_mod = pot2_map;
  localcounter = counter;
  interrupts();
  Serial.println(localcounter);
  delay(100);
  
  //analogWrite(OUTPIN1, map(pot1, 0, 1024, 0, 255));
  //analogWrite(OUTPIN2, map(pot2, 0, 1024, 0, 255));
  //analogWrite(OUTPIN3, map(pot3, 0, 1024, 0, 255));
  
}
