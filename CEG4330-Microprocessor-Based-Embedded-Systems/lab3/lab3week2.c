// Andrew Berger, Nouf Bosalha
// CEG 4330
// Lab 3 Week 2
// 2016-03-08

#include <hidef.h> /* common defines and macros */
#include "derivative.h" /* derivative-specific definitions */

#pragma MESSAGE DISABLE C4000
/* disable the compiler warning message when a condition is always true */

void MCU_init(void); /* Device initialization function declaration */
unsigned char char2LCD(unsigned char);
void initLCDSPI(void);

// Globals
unsigned int T1 = 0;
unsigned int T2 = 0;

// Timer Channel 6 Interrupt Service Routine
// Records the time between rising edges seen on Timer Channel 6.
__interrupt void tc6_isr(void)
{
  T1 = T2;
  T2 = TC6;
}

// returns an ASCII character representing the hexadecimal
// value of the lower 4 bits of ch
unsigned char low4toASCIIhex(unsigned int ch) {
  ch &= 0x0F; // clear the higher 4 bits
  if (ch < 10) {
    // 0-9
    return ch + '0';
  } else {
    // A-F
    return (ch - 10) + 'A'; 
  }
}

void main(void) {
  unsigned int count = 0;
  unsigned int T = 0;
  unsigned int period = 0;
  
  MCU_init(); // register interrupts, etc
  
  initLCDSPI(); // initialize the LCD using SPI
  
  TIOS = 0x00; // use timer input capture
  TSCR1 = 0x90; // enable timer and allow fast flag clear
  TCTL3 = 0x10; // enable input capture on rising edge for TC6
  
  DDRT = 0x00; // use port T for input
  
  EnableInterrupts;
  TIE = 0x40; // locally enable TC6 interrupt
  
  while(1) {
    // Calculate the period of a square wave expected to be between
    // 500 Hz and 2 KHz. The timing is such that we don't can expect
    // at most 1 overflow of the 16-bit timer.
    if (T2 > T1) {
      T = T2 - T1;
    } else {
      T = 0xffff - T1 + T2 + 1;
    }
    
    period = 8000000 / T;
    
    // display the period on the LCD every 64K cycles so we can
    // actually see something
    if (count++ == 0xFFFF) {
      clearScreen();
      char2LCD('0');
      char2LCD('x');
      char2LCD(low4toASCIIhex(period >> 12));
      char2LCD(low4toASCIIhex(period >> 8));
      char2LCD(low4toASCIIhex(period >> 4));
      char2LCD(low4toASCIIhex(period));
      char2LCD('H');
      char2LCD('z');
    }
  }
}
