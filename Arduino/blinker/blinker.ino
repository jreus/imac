int o_infoled = 3;
int pwm_speak = 5;
int i_pedal = A5;
int pedalval = 0;
int pwmval = 0;

// NOTE TODO: 
// Good to make a calibration mode for the footpedal min and max
int maxpedal = 1023;
int minpedal = 82;




void setup ()
{
 Serial.begin(9600);
 pinMode(o_infoled, OUTPUT); 
  
}


void loop ()
{
  pedalval = analogRead(i_pedal);
  pedalval = constrain(pedalval, minpedal, maxpedal);
  
  // Analog write 0-255
  //pwmval = map(pedalval, minpedal, maxpedal, 0, 255);
  
  //analogWrite(pwm_speak, pwmval);
  
  Serial.println(pedalval, DEC);
  
  digitalWrite(o_infoled, HIGH);
  delay(pedalval);
  digitalWrite(o_infoled, LOW);
  delay(pedalval);
 
  delay(1); // delay between analog reads for stability. 1ms 
  
}
