#include "../include/keyboard.h"
#include "../include/interrupt.h"
#include "../include/console.h"
#include "../include/io.h"
#include "../include/stdint.h"
#include "../include/global.h"

#define PORT_KBD_BUF 0x60

void keybord_handler_callback()
{
    //读取键盘缓冲器
    uint8 ch = io_inb(PORT_KBD_BUF);
    putchar(ch);

     //EOI结束中断,以便准备下次中断
    io_outb(PIC0_ICW1,0x20);

    putstring("do keybord_handler_callback!\n");
}

void init_keyboard()
{
    putstring("init_keyboard!\n");
    register_handler(0x21, io_keybord_handler);
}