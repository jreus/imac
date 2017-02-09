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

// Uncomment to enable debugging
//#define DEBUG_ENABLE

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
const byte pattern02[] = {
  0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1,
  0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
};
const byte pattern03[] = {0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0,0,0,0,0,1, 1, 0, 0, 0, 1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1};

volatile byte * pat1;
volatile int pat1_size;

byte modeswitch = 0;
volatile byte last_mode = 0;


void setup()
{
  pinMode(OUT1_PIN, OUTPUT);
  pinMode(OUT2_PIN, OUTPUT);

  pat1 = pattern01;
  pat1_size = sizeof(pattern01) / sizeof(byte);
  modeswitch = 0;
  last_mode = 0;
  
  Timer1.initialize(1); // 1us period, breaks analogWrite for pin D9, D10
  //Timer1.pwm(OUT2_PIN, 512); // 50% duty cycle PWM on OUT2_PIN
  Timer1.attachInterrupt(timerCallback); // use callback as timer overflow interrupt

#ifdef DEBUG_ENABLE
  Serial.begin(9600); //This pipes to the serial monitor
  while(!Serial) ;
  Serial.println("Hello, pat1_size is");
  Serial.println(pat1_size);
  Serial.println("And the second element of pat1 is:");
  Serial.println(pat1[1]);
  //Serial1.begin(9600); //This is the UART, pipes to sensors attached to board
#endif
}

void timerCallback() {
  // Output Pin 1
  //if(mod1 == 0) { // Keep the gate open
    //  out1 = 1;
      //digitalWrite(OUT1_PIN, out1);
  if(mod1 > 9999) { // Keep the gate closed
      out1 = 0;
      digitalWrite(OUT1_PIN, out1);
  } else {
    if((counter % mod1) == 0) {
      counter1++;
      // Follow the pattern
      out1 = pat1[counter1 % pat1_size];
      digitalWrite(OUT1_PIN, out1);
    }
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

int invals[] =  {50,    60,   200,  500,  700, 1022};
int outvals[] = {10000, 3200, 1600, 1000, 300, 8};
int sizevals = 6;

void loop()
{
  // Read Inputs
  ana1 = analogRead(ANA1_PIN);
  //mod1 = map(constrain(ana1, 45, 1023), 45, 1020, 9999, 0); // footpedal (approx 45 to 1024)
  mod1 = multiMap(ana1, invals, outvals, sizevals);
  ana2 = analogRead(ANA2_PIN);
  modeswitch = constrain(map(ana2, 0, 1023, 0, 3), 0, 2); // pot, not used? could be used to cycle through rhythms?
#ifdef DEBUG_ENABLE
  Serial.print("Raw Ana1: ");
  Serial.print(ana1);
  Serial.print(" Raw Ana2: ");
  Serial.print(ana2);
  Serial.print(" mod1: ");
  Serial.print(mod1);
  Serial.print(" Modeswitch: ");
  Serial.println(modeswitch);
#endif
  delay(10); // for analog read stability

}


// Take an array of input values, array of output values
// And provides segment-wise linear mapping of the input. 
// note: the _in array should have increasing values
int multiMap(int val, int* _in, int* _out, uint8_t size)
{
  // take care the value is within range
  // val = constrain(val, _in[0], _in[size-1]);
  if (val <= _in[0]) return _out[0];
  if (val >= _in[size-1]) return _out[size-1];

  // search right interval
  uint8_t pos = 1;  // _in[0] allready tested
  while(val > _in[pos]) pos++;

  // this will handle all exact "points" in the _in array
  if (val == _in[pos]) return _out[pos];

  // interpolate in the right segment for the rest
  return (val - _in[pos-1]) * (_out[pos] - _out[pos-1]) / (_in[pos] - _in[pos-1]) + _out[pos-1];
}

