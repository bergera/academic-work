#include <hidef.h> /* common defines and macros */
#include "derivative.h" /* derivative-specific definitions */

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
