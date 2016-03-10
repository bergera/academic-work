// Andrew Berger, Nouf Bosalha
// CEG 4330 Lab 3 Week 1
// Based on LCD_SPI.c and ADC_scan.c

#include <hidef.h>      /* common defines and macros */
#include "derivative.h"      /* derivative-specific definitions */

/* disable the compiler warning message when a condition is always true */
#pragma MESSAGE DISABLE C4000 

void MCU_init_24MHz(void);
void initLCDSPI(void);
void char2LCD(unsigned char);

void ATD_init(void)
{
  int i;
  
  ATDCTL2 = 0xe0; // enable ADT and use fast flag clear
  for(i=0; i<50; i++) asm("nop"); // a delay of at least 5 micro-sec
  ATDCTL3 = 0x02; // conversion length : 8 samples
  ATDCTL4 = 0xA5; // 8-bit resolution;
                  // 14 (=2+4+8) ATD clock cycles/sample for conversion 
                  // 2 (=24/12) MHz ATD clock
				          // (Modify this register to get faster conversion.)
}

// returns an ASCII character representing the hexadecimal
// value of the lower 4 bits of ch
unsigned char low4toASCIIhex(unsigned char ch) {
  ch &= 0x0F; // clear the higher 4 bits
  if (ch < 10) {
    // 0-9
    return ch + '0';
  } else {
    // A-F
    return (ch - 10) + 'A'; 
  }
}


// sends a string of characters representing the hexadecimal
// value of ch to the LCD
void displayHexValue(unsigned char ch) {
  char2LCD('0');
  char2LCD('x');
  char2LCD(low4toASCIIhex(ch >> 4));
  char2LCD(low4toASCIIhex(ch));
}

void main()
{
  int i;
  unsigned char buf[80];
  unsigned int voltage = 0;
  MCU_init_24MHz();
  initLCDSPI();
  // To display normal text, just enter its ASCII number. A number from 0x00 to 0x07 displays the user defined
  // custom character, 0x20 to 0x7F displays the standard set of characters, 0xA0 to 0xFD display characters and
  // symbols that are factory-masked on the ST7066U controller. 0xFE is reserved.
  // Refer to manual for full character table
  
  ATD_init();
  ATDCTL5 = 0x26; // start an A/D conversion, scan, single channel (6)
    
	while(1)
	{
	  voltage = 0;
		for(i=0; i<80; i+=8) {
      while(!(ATDSTAT0 & 0x80)); // wait until conversion is complete	
	    buf[i]   = ATDDR0H; // ignore ATDDR0L since the conversion is 8-bit only
      buf[i+1] = ATDDR1H;
    	buf[i+2] = ATDDR2H;
  	  buf[i+3] = ATDDR3H;
    	buf[i+4] = ATDDR4H;
    	buf[i+5] = ATDDR5H;
    	buf[i+6] = ATDDR6H;
  	  buf[i+7] = ATDDR7H;
    }
    
    // take the average of the sampled values
    for (i=0; i<80; i++) {
      voltage += buf[i]; 
    }
    voltage = voltage / 80;
    
    clearScreen();    
    displayHexValue((unsigned char)voltage);
	}
}

void MCU_init_24MHz(void) {
  /* these statements set the E clock at 24 MHz */
  /* they are needed when no monitor is used */
  PUCR &= ~0x10;
  // restore reset state
  CLKSEL &= ~0x80;
  // disengage PLL to system
  PLLCTL |= 0x40;
  // turn on PLL
  SYNR = 0x02;
  // set PLL multiplier
  REFDV = 0x01;
  // set PLL divider
  asm(" NOP");
  asm(" NOP");
  while(!(CRGFLG & 0x08)); // while (!(crg.crgflg.bit.lock==1))
  CLKSEL |= 0x80;
  // engage PLL to system
}


