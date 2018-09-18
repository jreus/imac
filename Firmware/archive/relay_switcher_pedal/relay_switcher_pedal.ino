/*  REF: http://arduino.cc/en/Tutorial/SecretsOfArduinoPWM
 *
 */


int relaypin = 2;
int ledpin = 3;
int potpin = A0;

// ontime, offtime, ontime...
int sequence[] = {  
100, 50, 98, 50, 204, 130, 122, 233,
50, 10, 87, 94, 149, 100, 198, 39,
98, 30, 40, 50, 60, 70, 80, 90,
100, 110, 120, 130, 140, 150, 160, 170,
}; 
int seqLength = 4 * 8;


int stepCount = 1;
int currStep = 0;

int sensorVal = 0;
float mult = 1.0;

void setup()
{
 Serial.begin(9600);
 
 pinMode(relaypin, OUTPUT);
 pinMode(ledpin, OUTPUT);
 
 pinMode(potpin, INPUT);
}

void loop()
{
  sensorVal = 1024 - analogRead(potpin);
  mult = ((float)sensorVal / 512.0) + 0.2;
   
  
  if((stepCount % 2) == 1) {
    digitalWrite(relaypin, HIGH);
    digitalWrite(ledpin, HIGH);
  } else {
    digitalWrite(relaypin, LOW); 
    digitalWrite(ledpin, LOW);
  }
   
  delay(sequence[currStep] * mult);
  
  currStep++;
  stepCount++;
  if (currStep >= seqLength)
    currStep = 0;
    
    
  Serial.println(sensorVal, DEC);

}

