// Nouf Bosalha, Andrew Berger 


#include <hidef.h> /* common defines and macros */

#include "derivative.h" /* derivative-specific definitions */

#pragma MESSAGE DISABLE C4000

/* disable the compiler warning message when a condition is always true */

void MCU_init(void); /* Device initialization function declaration */

void main(void) {
  unsigned int count=0;

  //MCU_init();  Commented this out so that the number that TCNT is trying to reach is not so large and cause lause of data.
  //		 This is because the bus clock of the EVB runs at 24MHz when MCU_init() is called. When it is commented out
  //		 the bus clock for the EVB will run at 8MHz. So the number for TCNT to reach for output compare will in turn
  //		 be much smaller. The math for this is calculated at the bottom.
  
  // Formula for constant value: (clock speed)/(2*desired frequency)
  // 8MHz / 261.6 = 30582 / 2 = 15291 (Does not get a compiler warning for possible loss of data with accomplishing the same results)

  TIOS|=0x02; // use channel 1 for output compare (changed to 0x02 from 0x01 to use channel 1 instead of channel 0)
  TSCR1=0x90; // enable timer and allow fast flag clear
  TCTL2=0x04; // select toggle as the action for output compare (changed from 0x01 to 0x04 to use channel 1 instead of CH 0)
  TC1=TCNT+15291; // set up TC1 and clear C0F flag, changed from TC0=TCNT+3000
  DDRA = 0xff; // set port A as output pins (for LED1)
  while(1)
  {
    while(!(TFLG1&0x02)); // wait until C0F flag is set, changed from 0x01 to 0x02 to use channel 1 instead of channel 0

    TC1=TCNT+15291; // set up TC0 and clear C0F flag, changed from TC0=TCNT+3000

    if(count++ == 8000)
    {
      PORTA ^= 0x01; // toggle PA0 (for LED1)
      count = 0;
    }
  }
}

void MCU_init(void) {
  /* these statements set the E clock at 24 MHz */
  /* they are needed when no monitor is used */
  PUCR &= ~0x10; // restore reset state
  CLKSEL &= ~0x80; // disengage PLL to system
  PLLCTL |= 0x40; // turn on PLL
  SYNR = 0x02; // set PLL multiplier
  REFDV = 0x01; // set PLL divider
  asm(" NOP");
  asm(" NOP");
  while(!(CRGFLG & 0x08)); // while (!(crg.crgflg.bit.lock==1))
  CLKSEL |= 0x80; // engage PLL to system
} 
