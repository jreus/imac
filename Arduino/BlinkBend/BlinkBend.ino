/********************************
iMac Arduino Patch

Uses potentiometers to control switching speed of grounded 
BS170 LL transistors. These transistors should route one of the
pins of the RAM chips to ground for strobing effects.

Simultaneously there are blinking LEDs (Adafruit APA102 5050)
which give feedback on the step speed.

21 Aug 2016
Jonathan Reus-Brodsky

***************************/

#include <TimerOne.h>
//#include <Adafruit_DotStar.h>
//#include <SPI.h>

// DotStar LED control (use Pin 11 for data, Pin 13 for clock to use Hardware SPI)
//const int LED_DATAPIN = 11;
//const int LED_CLOCKPIN = 13;
//const int NUM_LEDS = 2;
//Adafruit_DotStar leds = Adafruit_DotStar(NUM_LEDS, DOTSTAR_MONO);

const int POTPIN1 = A0;
const int POTPIN2 = A1;

const int SWITCHPIN1 = 5;
const int SWITCHPIN2 = 6;

const int LEDPIN1 = 7;
const int LEDPIN2 = 8;

// Metronome / Step Sequencer
const long counter_speed_us = 1000;  // period of the root step  - this is the counter speed in microseconds

// Patterns
const int pat1[] = {0, 1, 0, 1};
const int pat3[] = {0, 1, 1, 1};
const int pat2[] = {0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0,0,0,0,0,1, 1, 0, 0, 0, 1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1};
volatile int pat1_mod = 4;
volatile int pat2_mod = 4;
volatile int pat3_mod = 4;
volatile int pat1size;
volatile int pat2size;
volatile int pat3size;
int speed = 10;

volatile unsigned long counter = 0; // use volatile for shared variables used in interrupts
volatile unsigned long counter1 = 0; // use volatile for shared variables
volatile unsigned long counter2 = 0; // use volatile for shared variables
volatile unsigned long counter3 = 0; // use volatile for shared variables
volatile int switch1 = 0;
volatile int switch2 = 0;
//volatile uint32_t led1 = 0x000000;
//volatile uint32_t led2 = 0x000000;


// Done for each metronome step
void sequenceStep(void)
{  
  counter += 1;
  if(counter % pat1_mod == 0) {
     counter1 += 1;
  }
  if(counter % pat2_mod == 0) {
     counter2 += 1;
  }
  if(counter % pat3_mod == 0) {
     counter3 += 1;
  }
  if(pat1_mod == 0) { // if pat3_mod is 0, keep the gate open
    switch1 = 1;
  } else if(pat1_mod == 9999) { // 9999 means keep the gate closed
    switch1 = 0;   
  } else {
    switch1 = pat1[counter1 % pat1size];
  }
  if(pat2_mod == 0) { // if pat3_mod is 0, keep the gate open
    switch2 = 1;
  } else if(pat2_mod == 9999) { // 9999 means keep the gate closed
    switch2 = 0;   
  } else {
    switch2 = pat2[counter2 % pat2size];
  }

  // LED Pixels
  //led1 = (uint32_t)0xFFFFFF * (uint32_t)switch1;
  //led2 = (uint32_t)0xFFFFFF * (uint32_t)switch2;
  //leds.setPixelColor(0, 0); // pixel 0
  //leds.setPixelColor(1, led1); // pixel 1
  //leds.show();                    // Refresh leds
  digitalWrite(LEDPIN1, switch1);
  digitalWrite(LEDPIN2, switch2);

  // Switching Pins
  digitalWrite(SWITCHPIN1, switch1);
  digitalWrite(SWITCHPIN2, switch2);

}



void setup() {
 Serial.begin(9600);

 // Switches
 pinMode(SWITCHPIN1, OUTPUT);
 pinMode(SWITCHPIN2, OUTPUT);
 
 // LEDS
 pinMode(LEDPIN1, OUTPUT);
 pinMode(LEDPIN2, OUTPUT);
 //leds.begin(); // Initialize pins for output
 //leds.show();  // Turn all LEDs off ASAP

 pat1size = sizeof(pat1) / sizeof(int);
 pat2size = sizeof(pat2) / sizeof(int);
 pat3size = sizeof(pat3) / sizeof(int);
 Timer1.initialize(100000);
 Timer1.attachInterrupt(sequenceStep); // blinkLED to run every 0.1 seconds
 Timer1.setPeriod(counter_speed_us);
}



void loop() {
  int pot1, pot2, localout3;
  int pot1_map, pot2_map, pot3_map;
  unsigned long localcounter;
  
  // Read pot values & clean up the data (won't go straight to 0)
  pot1 = analogRead(POTPIN1);
  pot2 = analogRead(POTPIN2);
  if(pot1 < 10) {
    pot1 = 0;
  } else if(pot1 > 990) {
    pot1 = 1023;
  }
  if(pot2 < 10) {
    pot2 = 0;
  } else if(pot2 > 990) {
    pot2 = 1023;
  }

  // Map the values to pattern speeds... ?
  pot1_map = map(pot1, 0, 1023, 0, 300);
  if(pot1_map == 300) {
    pot1_map = 9999; // keep gate open
  };
  pot2_map = map(pot2, 0, 1023, 0, 300);
  if(pot2_map == 300) {
    pot2_map = 9999; // keep gate open
  };
  
  Serial.print("POT1 Mapped: ");
  Serial.print(pot1_map);
  Serial.print("   POT2 Mapped: ");
  Serial.print(pot2_map);
  Serial.print("   COUNT: ");
  noInterrupts();
  pat1_mod = pot1_map;
  pat2_mod = pot2_map;
  localcounter = counter;
  interrupts();
  Serial.println(localcounter);
  delay(100);
}
