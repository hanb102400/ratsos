
#include "../include/console.h"
#include "../include/io.h"

#define VGA_BASE 0xB8000;

int getCursor()
{
    io_outb(0x3d4, 0x0e);
    int cursorHigh = io_inb(0x3d5);
    io_outb(0x3d4, 0x0f);
    int cursorLow = io_inb(0x3d5);
    return (cursorHigh << 8) + (cursorLow & 0xff);
}

void setCursor(int pos)
{
    int cursorHigh = pos >> 8;
    int cursorLow = pos & 0xff;
    io_outb(0x3d4, 0x0e);
    io_outb(0x3d5, cursorHigh);
    io_outb(0x3d4, 0x0f);
    io_outb(0x3d5, cursorLow);
}

int putchar(char ch)
{

    int pos = getCursor();
    char *pvga = (char *)VGA_BASE;

    //zifu
    switch (ch)
    {
    case 0x0d: //\r
        pos = (pos / 80) * 80;
        break;
    case 0x0a: //\n
        pos = pos + 80;
        break;
    default:
        *(pvga + pos * 2) = ch;
        pos++;
    }
    //roll_screen
    if (pos > 1999)
    {   
        pos = pos - 80;
        //io_movsd( *(pvga + 0xa0 ),*(pvga + 0x00 ),1920);
        for (int i = 0; i < 1920; i++)
        {
            *(pvga + 0x00 + i * 2) = *(pvga + 0xa0 + i * 2) ;
        }
        //cls with space
        for (int i = 0; i < 80; i++)
        {
            *(pvga + 1920 * 2 + i * 2) = 0x0;
        }
    }
    setCursor(pos);
    return pos;
}