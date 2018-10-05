
#include "io.h"

#define VGA_BASE 0xa0000;

int getCursor(){
    io_outb(0x3d4, 0x0e);
    int cursorHigh = io_inb(0x3d5);
    io_outb(0x3d4, 0x0f);
    int cursorLow = io_inb(0x3d5);
    return cursorHigh << 8 + cursorLow;
}

void setCursor(int pos){
    int cursorHigh = pos >> 8;
    int cursorLow = pos & 0xff;
    io_outb(0x3d4, 0x0e);
    io_outb(0x3d5, 11);
    io_outb(0x3d4, 0x0f);
    io_outb(0x3d5, 21);
}

int putchar(char ch){
    int pos = getCursor() * 2;
    char *pvga = (char *)VGA_BASE;
     *(pvga + pos) = ch;
    setCusor(pos);
    return pos+ 1;

}