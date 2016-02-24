// Andrew Berger, Nouf Bosalha
// CEG 4330 Lab 3 Week 1
// Based on LCD_SPI.c and ADC_scan.c

#include <hidef.h>      /* common defines and macros */
#include "derivative.h"      /* derivative-specific definitions */
/* disable the compiler warning message when a condition is always true */
#pragma MESSAGE DISABLE C4000 

void MCU_init_24MHz(void);
void char2LCD(unsigned char);

// waits for x micro seconds, uses output compare channel 0
void waitus(unsigned long int microSeconds)
{
    while(microSeconds > 2500)
    {
        // overflow, need to break up
        TC0 = TCNT + (unsigned int)(60000);
        microSeconds -= 2500;
        while(!(TFLG1&0x01));
    }
    TC0 = TCNT + (unsigned int)(24 * microSeconds);
    while(!(TFLG1&0x01));
}

// Output 8-bit value to LCD over SPI
void char2LCD(unsigned char ch)
{
    volatile unsigned char dummy = (ch&0x01);
    
    SPIDR = ch;  // it clears SPTEF as a side effect
    while(!SPISR_SPIF); // wait until data shifted out
    dummy = SPISR;  // (not sure if this line is necessary)
    dummy = SPIDR;  // clear SPIF
}

// Output string to LCD
void str2LCD(unsigned char *str) 
{
    int i = 0;
    while(str[i]) {
        char2LCD(str[i]);
        i++;
    }  
}

// turns on the LCD display. Default: LCD screen is on
void turnLCDOn()
{
    char2LCD(0xFE);
    char2LCD(0x41);
    // 100 micro second execution time
    waitus(101);
}

void turnBlinkingCursorOn() 
{
    char2LCD(0xFE);
    char2LCD(0x4B);
    // 100 micro second execution time
    waitus(101);      
}

void turnBlinkingCursorOff() 
{
    char2LCD(0xFE);
    char2LCD(0x4C);
    // 100 micro second execution time
    waitus(101);      
}

void turnUnderlineCursorOn() 
{
    char2LCD(0xFE);
    char2LCD(0x47);
    // 1.5ms micro second execution time
    waitus(1700);      
}

void turnUnderlineCursorOff() 
{
    char2LCD(0xFE);
    char2LCD(0x48);
    // 1.5ms micro second execution time
    waitus(1700);      
}

// move cursor to line 1 column 1
void cursorHome()
{
    char2LCD(0xFE);
    char2LCD(0x46);
    // 1.5 ms execution time
    waitus(1700);
}

// clear LCD and move cursor to line 1 column 1
void clearScreen()
{
    char2LCD(0xFE);
    char2LCD(0x51);
    // 1.5 ms execution time
    waitus(2000);
}

// Put cursor at location position
// Values 0x00-0x0F for row 1, 0x40-0x4F for row 2
void setCursor(unsigned char position) 
{
    char2LCD(0xFE);
    char2LCD(0x45);
    char2LCD(position);
    // 100 us execution time
    waitus(110);  
}

// Move cursor position left 1 space, whether the cursor is turned on or not
void cursorLeftOne()
{
    char2LCD(0xFE);
    char2LCD(0x49);
    // 100 micro second execution time
    waitus(101);   
}

// Move cursor position right 1 space, whether the cursor is turned on or not
void cursorRightOne()
{
    char2LCD(0xFE);
    char2LCD(0x4A);
    // 100 micro second execution time
    waitus(101);   
}

void printFirmwareVersion()
{
    char2LCD(0xFE);
    char2LCD(0x70);
    // 4 ms execution time
    waitus(4500);
}

// Move cursor back one space, delete last character
void backspace() 
{
    char2LCD(0xFE);
    char2LCD(0x4E);
    // 100 us execution time
    waitus(101);    
}

// Set the display contrast, value between 1 and 50. Default: 40
void setContrast(unsigned char value) 
{
    if(value < 1 || value > 50) 
    {
        return;  
    }    
    char2LCD(0xFE);
    char2LCD(0x52);
    char2LCD(value);
    // 500 us execution time
    waitus(510);       
}


// set the backlight brightness level, value between 1 and 8. Default: 8
void setBacklightBrightness(unsigned char value) 
{
    if(value < 1 || value > 8) 
    {
        return;  
    }

    char2LCD(0xFE);
    char2LCD(0x53);
    char2LCD(value);
    // 100 us execution time
    waitus(110);       
}


void initLCDSPI()
{

    volatile unsigned char temp = 0;
    // enable output compare channel 0
    TIOS |= 0x01;
    TSCR1 = 0x90; // enable timer and allow fast flag clear
    TCTL2 &= ~0x03; // Select do nothing as output compare action for channel 0
    
    // Wait 100 mS for LCD to initialize display controller
    waitus(100000);
    
    

    SPICR1 = 0x5E; // 0(SPIE) 1(SPE) 0(SPTIE) 1(MSTR) 1(CPOL) 1(CPHA) 1(SSOE) 0(LSBFE)
    SPICR2 = 0x12; // N(N/A) N(N/A) N(N/A) 1(MODFEN) 0(BIDIROE) N(N/A) 1(SPISWAI) 0(SPC0)

    SPIBR = 0x57; // baud rate is close to 12 KHz; could have been set higher for LCD
    // Tried 75kHz and LCD seems to miss one character every few(~6-8) characters at that baud rate
    
     
    waitus(3);
    clearScreen();
    turnBlinkingCursorOn();
    //printFirmwareVersion();
}

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
	    //ATDCTL5 = 0x07; // start the next A/D conversion (NO NEED in scan mode)
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


