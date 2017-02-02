/* Backseat Driver v01 firmware
 *  Firmware designed for Arduino Pro Micro or compatible board.
 *  https://www.sparkfun.com/products/12640
 *  
 *  TimerOne Library Webpage
 *  http://playground.arduino.cc/Code/Timer1
 *  
 *  
 *  
 *  Inputs: A0 (on patchbay), A1 (footpedal), A2 (Ana2)
 *  Outputs: D3 (on patchbay), D6 (on patchbay)
 *  
 *  Equip A0 with an interrupt that responds with some kind of flicker pattern on D3/D6
 *  A1: footpedal
 *  A2: mode selector?
 *  
 *  D3: Pulse Wave / Rhythmic Pattern
 *  D6: Pulse Wave / Rhythmic Pattern (alternate) / Fast PWM
*/

#include "TimerOne.h"

const byte OUT1_PIN = 3;
const byte OUT2_PIN = 6;
const byte INTERRUPT1_PIN = A0;
const byte ANA1_PIN = A1;
const byte ANA2_PIN = A2;

int ana1 = 0; // footpedal
int ana2 = 0;

volatile unsigned long counter = 0;
volatile unsigned long counter1 = 0;
volatile int mod1 = 0;
volatile char out1 = 1;

// Patterns
const byte pattern01[] = {0, 1, 0, 1};
const byte pattern02[] = {0, 1, 1, 1};
const byte pattern03[] = {0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0,0,0,0,0,1, 1, 0, 0, 0, 1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1};

volatile byte * pat1;
volatile int pat1_size;

char modeswitch = 0;
volatile char last_mode = 0;


void setup()
{
  pinMode(OUT1_PIN, OUTPUT);
  pinMode(OUT2_PIN, OUTPUT);

  pat1 = pattern03;
  pat1_size = sizeof(pattern03) / sizeof(byte);
  
  Timer1.initialize(1); // 1us period, breaks analogWrite for pin D9, D10
  //Timer1.pwm(OUT2_PIN, 512); // 50% duty cycle PWM on OUT2_PIN
  Timer1.attachInterrupt(timerCallback); // use callback as timer overflow interrupt

  Serial.begin(9600); //This pipes to the serial monitor
  while(!Serial) ;
  Serial.println("Hello, pat1_size is");
  Serial.println(pat1_size);
  Serial.println("And the second element of pat1 is:");
  Serial.println(pat1[1]);
  //Serial1.begin(9600); //This is the UART, pipes to sensors attached to board
}

void timerCallback() {
  // Output Pin 1
  if(counter % mod1 == 0) {
    counter1++;
    if(mod1 == 0) { // Keep the gate open
      out1 = 1;
    } else if(mod1 == 9999) { // Keep the gate closed
      out1 = 0;
    } else { // Follow the pattern
      out1 = pat1[counter1 % pat1_size];
    }
    digitalWrite(OUT1_PIN, out1);
  }
  counter++;

  if(modeswitch != last_mode) {
    last_mode = modeswitch;
    switch (modeswitch) {
      case 0:
      pat1 = pattern01;
      pat1_size = sizeof(pattern01) / sizeof(byte);
      break;
      case 1:
      pat1 = pattern02;
      pat1_size = sizeof(pattern02) / sizeof(byte);
      break;
      case 2:
      pat1 = pattern03;
      pat1_size = sizeof(pattern03) / sizeof(byte);
      break;
    }
  }

}


void loop()
{
  // Read Inputs
  ana1 = analogRead(ANA1_PIN);
  mod1 = map(constrain(ana1, 45, 1023), 45, 1020, 9999, 0); // footpedal (approx 45 to 1024)
  ana2 = analogRead(ANA2_PIN);
  modeswitch = map(ana2, 0, 1023, 0, 2); // pot, not used? could be used to cycle through rhythms?
    
  delay(10); // for analog read stability

}

