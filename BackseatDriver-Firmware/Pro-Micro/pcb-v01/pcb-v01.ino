/* Backseat Driver v01 firmware
 *  Firmware designed for Arduino Pro Micro or compatible board.
 *  https://www.sparkfun.com/products/12640
 *  
 *  TimerOne Library Webpage
 *  http://playground.arduino.cc/Code/Timer1
 *  
 *  Uses an Arduino Pro Micro (ATmega32U4)
 *  
 *  Inputs: 
 *    A0 (user pluggable on patchbay)
 *    A1 (potentiometer ANA1 - usually footpedal)
 *    A2 (potentiometer ANA2)
 *  
 *  Outputs: 
 *    D3 (user pluggable on patchbay)
 *    D6 (user pluggable on patchbay)
 *  
 *  TODO:
 *  Equip A0 with an interrupt that responds with some kind of pattern on D3/D6
 *  Work on keyboard outputs to control things on the iMac from signal inputs.
 *  Something is wonky with multimap...
 *  
 *  Summary:
 *  A1: continuously selects flicker rate of D3 and D6  
 *  A2: selects different patterns and modes
 *  
 *  D3: Outputs a pulse wave / Rhythmic Pattern
 *  D6: Outputs a pulse Wave / Rhythmic Pattern (alternate) / Fast PWM
*/

#include "TimerOne.h"

// Uncomment to enable debugging
//#define DEBUG_ENABLE

const byte OUT1_PIN = 3;
const byte OUT2_PIN = 6;
const byte INTERRUPT1_PIN = A0;
const byte ANA1_PIN = A1;
const byte ANA2_PIN = A2;

int ana1 = 0; // usually footpedal
int ana2 = 0;

volatile unsigned long counter = 0;   // global counter
volatile unsigned long p_counter = 0;  // pattern-specific counter
volatile char out1 = 1;

int mod1 = 0;
volatile int last_mod1 = 0;

// Patterns
const byte pattern01[] = {0, 1, 0, 1};
const byte pattern02[] = {
  0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1,
  0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
};
const byte pattern03[] = {0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0,0,0,0,0,1, 1, 0, 0, 0, 1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,1};

byte * pat1;
int pat1_size;

byte modeswitch = 0;
byte last_mode = 0;

int modthresh_low = 20; // threshhold for holding the signal high
int modthresh_hi = 9999; // threshhold for holding the signal low

int sizevals = 6;


void setup()
{
  pinMode(OUT1_PIN, OUTPUT);
  pinMode(OUT2_PIN, OUTPUT);

  pat1 = pattern01;
  pat1_size = sizeof(pattern01) / sizeof(byte);
  modeswitch = 0;
  last_mode = 0;
  
  Timer1.initialize(2); // 1us period, breaks analogWrite for pin D9, D10
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
  if(mod1 < modthresh_low) { // Keep the output high
      if(out1 != 1) {
        out1 = 1;
        digitalWrite(OUT1_PIN, out1);
        digitalWrite(OUT2_PIN, out1);
      }
  } else if(mod1 > modthresh_hi) { // Keep the output low
      if(out1 != 0) {
        out1 = 0;
        digitalWrite(OUT1_PIN, out1);
        digitalWrite(OUT2_PIN, out1);
      }
  } else { // follow the current active pattern
    if((counter % mod1) == 0) {
      p_counter++;
      // Follow the pattern
      out1 = pat1[p_counter % pat1_size]; 
      digitalWrite(OUT1_PIN, out1);
      digitalWrite(OUT2_PIN, out1);
    }
  }
  counter++;

/*
  if(abs(mod1 - last_mod1) > 100) { // If the mod value has changed by a certain threshhold, reset the pattern so it does not become stuck
    last_mod1 = mod1;
    counter=0;
    counter1=0;
  }
  */
}

int invals[] =  {20, 208, 412, 616, 820, 1022}; // linear input distribution


// output mappings for different patterns, expands the interesting ranges and contracts others
int outvals[][6] = {
  {10000, 5600, 2200, 1000, 400, 10}, // pattern01 output mappings
  {10000, 3200, 1600, 800, 100, 10}, // pattern02 output mappings
  {10000, 3200, 1600, 800, 100, 10}  // pattern03 output mappings
};

void loop()
{
  // Read Inputs
  ana1 = analogRead(ANA1_PIN); // used as a clock speed control
  //mod1 = map(constrain(ana1, 45, 1023), 45, 1020, 9999, 0); // footpedal (approx 45 to 1024)
  mod1 = multiMap(ana1, invals, outvals[modeswitch], sizevals);
  ana2 = analogRead(ANA2_PIN); // used as a mode switch
  modeswitch = constrain(map(ana2, 0, 1023, 0, 3), 0, 2); // pot, not used? could be used to cycle through rhythms?

  // If the mode switch has changed, change the pattern
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
  delay(20); // for analog read stability

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

