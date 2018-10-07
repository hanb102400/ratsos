
#include "console.h"
#include "io.h"
#include "../include/stdint.h"

#define VGA_BASE 0xB8000;

uint32 getCursor()
{
    io_outb(0x3d4, 0x0e);
    uint32 cursorHigh = io_inb(0x3d5);
    io_outb(0x3d4, 0x0f);
    uint32 cursorLow = io_inb(0x3d5);
    return (cursorHigh << 8) + (cursorLow & 0xff);
}

void setCursor(uint32 pos)
{
    uint32 cursorHigh = pos >> 8;
    uint32 cursorLow = pos & 0xff;
    io_outb(0x3d4, 0x0e);
    io_outb(0x3d5, cursorHigh);
    io_outb(0x3d4, 0x0f);
    io_outb(0x3d5, cursorLow);
}

uint32 putchar(uint8 ch)
{

    uint32 pos = getCursor();
    uint8 *pvga = (uint8 *)VGA_BASE;
    *(pvga + pos * 2) = ch;
    setCursor(pos + 1);
    return pos;
}