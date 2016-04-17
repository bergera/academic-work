/*
Andrew Berger
CEG 4330 HW2
2016-04-01

Based on code from:
http://www.hobbytronics.co.uk/arduino-timer-interrupts
http://www.benripley.com/diy/arduino/three-ways-to-read-a-pwm-signal-with-arduino/
*/

#define ledPin 13
#define startPin 2
#define signalPin 3

int timer1_counter = 0;
int timer2_counter = 0;
volatile int pwm_value = 0;
volatile int prev_time = 0;
 
// LED flashing interrupt
ISR(TIMER1_OVF_vect)
{
  // toggle the LED 2 times a second
  TCNT1 = timer1_counter;
  digitalWrite(ledPin, digitalRead(ledPin) ^ 1);
}

// START sending interrupt
ISR(TIMER2_OVF_vect)
{
  // send a 2ms START signal to sensor
  digitalWrite(startPin, HIGH);
  delay(2);
  digitalWrite(startPin, LOW);
}

// SIGNAL rising edge ISR
void rising()
{
  // set up ISR for falling edge
  attachInterrupt(1, falling, FALLING);
  // record T1
  prev_time = micros();
}
 
// SIGNAL falling edge ISR
void falling()
{
  // set up ISR for rising edge
  attachInterrupt(1, rising, RISING);
  // calculate pulse width in microseconds
  pwm_value = micros()-prev_time;
}

void setup()
{
  pinMode(ledPin, OUTPUT);
  pinMode(startPin, OUTPUT);
  pinMode(signalPin, INPUT);

  // initialize timers
  noInterrupts();           // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;

  timer1_counter = 34286;   // preload timer 65536-16MHz/256/2Hz (toggle twice a second)
  timer2_counter = 12107;   // 5 Hz (send START five times a second)
  
  TCNT1 = timer1_counter;   // preload timer
  TCCR1B |= (1 << CS12);    // 256 prescaler 
  TIMSK1 |= (1 << TOIE2);   // enable START-sending timer ISR

  // set up ISR for SIGNAL rising edge
  attachInterrupt(1, rising, RISING);

  interrupts();             // enable all interrupts
}

void loop()
{
  // pwm_value represents the round-trip time for the sound pulse in microseconds
  // distance_in_feet = pwm_value / 2000

  if (pwm_value < 6000)
  {
    // less than 3 ft
    TIMSK1 &= ~(1 << TOIE1); // disable LED toggle timer
    digitalWrite(ledPin, LOW); // turn off LED
  }
  else if (pwm_value < 12000)
  {
    // between 3 and 6 ft
    TIMSK1 |= (1 << TOIE1)// enable LED timer
  }
  else
  {
    // greater than 6 ft
    TIMSK1 &= ~(1 << TOIE1); // disable LED toggle timer
    digitalWrite(ledPin, HIGH); // turn on LED
  }
}