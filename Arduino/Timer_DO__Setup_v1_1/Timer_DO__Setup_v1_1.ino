/*
Arduino timer CTC interrupt example
 
 Version 1.1 produces output on 7 digital lines
 These lines are necessary to drive the TLC5951 chip
 The goal here is to produce a single, 50% duty cycle, blinking LED at Red 0
 
 
 */

// avr-libc library includes
#include <avr/io.h>
#include <avr/interrupt.h>


// Let's setup 5 digital pins for output for the following output purposes:
// XBLNK, GSLAT, GSCKR(B\G), GS, DS, DCSIN, DCSCK
// NDOPins = 7;
char counterFlag = 0;

char message1[] = {1,1,1,0,1,0,0};
char message2[] = {0,0,0,1,0,1,1};
int i = 0;

void setup()
{
  for (int thisPin = 2; thisPin <= 8; thisPin++)  {
    pinMode(thisPin, OUTPUT);      
  }

  // initialize Timer1
  cli();          // disable global interrupts
  TCCR1A = 0;     // set entire TCCR1A register to 0
  TCCR1B = 0;     // same for TCCR1B

  // set compare match register to desired timer count:
  OCR1A = 999;
  // turn on CTC mode:
  TCCR1B |= (1 << WGM12);
  // Set CS11 bits for 8 prescaler. This will generate 0.5 us clock period:
  TCCR1B |= (1 << CS11);
  // enable timer compare interrupt:
  TIMSK1 |= (1 << OCIE1A);
  sei();          // enable global interrupts

}


void loop()
{
  // do stuff while digital output is produced
}

ISR(TIMER1_COMPA_vect) {
  PORTB = message1[i] << 0;

  PORTD = message2[i] << 4;

  i+=1;
  i = (i % 7);

  /*if(counterFlag) {
   PORTB = 1<<0; //set PD2 ON
   counterFlag = 0; //set Flag OF
   
   
   // PORTD = ~(1<<2) //set PD2 OFF
   
   //PORTD = 4 //set 3rd pin on
   //PORTD = 0 //set 3rd pin off
   }
   else {     
   PORTB &= ~(1<<0);
   counterFlag = 1; //set Flag ON
   }*/

  //}
}




