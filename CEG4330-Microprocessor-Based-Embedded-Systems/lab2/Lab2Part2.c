// Nouf Bosalha, Andrew Berger 

#include <hidef.h> /* common defines and macros */

#include "derivative.h" /* derivative-specific definitions */

#pragma MESSAGE DISABLE C4000

/* disable the compiler warning message when a condition is always true */

void MCU_init(void); /* Device initialization function declaration */

void main(void) {
  unsigned int count  = 0;  // general-purpose counter
  unsigned int row    = 0;  // row counter
  unsigned int col    = 0;  // column counter
  char key_pressed    = 0;  // if a key is pressed, its value will be stored here
  char PTT_value      = 0;  // stores a copy of the contents of PTT for comparison
  char keypad_values[3][3]; // the values of the keys on the keypad
  char row_values[3];       // used to set the contents of PORTAD0 to isolate a keypad row
  char column_values[3];    // used to examine the value of a specific bit of PTT to isolate a keypad column

  // for Lab 2 Part 3
  // unsigned int timer_offset = 0; // stores an offset value used to set up a timer output compare to play a musical tone

  keypad_values[0][0] = '1';
  keypad_values[0][1] = '2';
  keypad_values[0][2] = '3';
  keypad_values[1][0] = '4';
  keypad_values[1][1] = '5';
  keypad_values[1][2] = '6';
  keypad_values[2][0] = '7';
  keypad_values[2][1] = '8';
  keypad_values[2][2] = '9';

  // for Lab 2 part 3
  // Calculated using formula (clock speed frequency)/(2*desired frequency), with clock speed equal to 8MHz
  // keypad_values[0][0] = 15291; // 1 => C
  // keypad_values[0][1] = 13624; // 2 => D
  // keypad_values[0][2] = 12136; // 3 => E
  // keypad_values[1][0] = 11455; // 4 => F
  // keypad_values[1][1] = 10204;// 5 => G
  // keypad_values[1][2] = 9090; // 6 => A
  // keypad_values[2][0] = 8100; // 7 => B
  // keypad_values[2][1] = 7645; // 8 => C
  // keypad_values[2][2] = 0; // 9 is reserved

  row_values[O] = 0x18; // bits 3 and 4 high
  row_values[1] = 0x14; // bits 2 and 4 high
  row_values[2] = 0x0C; // bits 2 and 3

  column_values[0] = 0x04; // bit 2
  column_values[1] = 0x08; // bit 3
  column_values[2] = 0x10; // bit 4

  //MCU_init();  
/*
  The above line is commented out so that the timer clock speed runs at 8MHz instead of 24MHz. At 24MHz, the offsets
  needed to use the output compare feature to generate musical tones are too large.
*/

  TIOS|=0x02; // use channel 1 for output compare (changed to 0x02 from 0x01 to use channel 1 instead of channel 0)
  TSCR1=0x90; // enable timer and allow fast flag clear
  TCTL2=0x04; // select toggle as the action for output compare (changed from 0x01 to 0x04 to use channel 1 instead of CH 0)
  TC1=TCNT+15291; // set up TC1 and clear C0F flag, changed from TC0=TCNT+3000
  
  DDRA = 0xff; // set port A as output pins (for LED1)
  DDRT = 0x02; // set port T bit 1 as output (bits 2,3,4 as input pins)
  DDRAD = 0x1C; // sets port AD bits 2,3,4 as output pins
  
  while(1)
  {
    // 
    // Scan the keypad to determine if a key is pressed.
    //
    key_pressed = 0;
    // timer_offset = 0; // for Lab 2 Part 3
    row = 0;
    while (row++ < 3)
    {
      // set value of PORTAD0 for the current row
      // (the current row is set LOW while others are set HIGH)
      PORTAD0 = row_values[row];

      // debounce a few clock cycles
      count = 0;
      while (count++ != 4);

      PTT_value = PTT; // store the value of PTT

      col = 0;
      while (col++ < 3)
      {
        // check the value of PTT for the current column to determine if a key is pressed
        // (a LOW value indicates the key is pressed)
        if (!(PTT_value & column_values[col]))
        {
          key_pressed = keypad_values[row][col];
          // timer_offset = keypad_values[row][col]; // for Lab 2 Part 3
        }
      }
    }

    //
    // Play a tone if a key was pressed.
    //
    // for Lab 2 Part 3
/* 
    if (timer_offset)
    {
      // if a key is pressed, set up the timer to play its tone
      TC1 = TCNT + timer_offset;
      while(!(TFLG1&0x02)); 

      // there is no need to do anything special when no key is pressed
    }
*/
  }
}

// void MCU_init(void) {
//   /* these statements set the E clock at 24 MHz */
//   /* they are needed when no monitor is used */
//   PUCR &= ~0x10; // restore reset state
//   CLKSEL &= ~0x80; // disengage PLL to system
//   PLLCTL |= 0x40; // turn on PLL
//   SYNR = 0x02; // set PLL multiplier
//   REFDV = 0x01; // set PLL divider
//   asm(" NOP");
//   asm(" NOP");
//   while(!(CRGFLG & 0x08)); // while (!(crg.crgflg.bit.lock==1))
//   CLKSEL |= 0x80; // engage PLL to system
// } 
