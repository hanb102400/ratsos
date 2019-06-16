#include "../include/global.h"
#include "../include/stdint.h"
#include "../include/io.h"
#include "../include/keyboard.h"


/** KEYBORD */
#define PORT_KBD_BUF 0x60

void keyboard_handler_callback()
{

     //读取键盘缓冲器
    uint8 ch = io_in8(PORT_KBD_BUF);
    putchar(ch);

    //EOI结束中断,以便开始下次中断
    io_out8(PIC0_ICW1,0x20);

    putstring(" do keyboard_handler_callback!\n");
}

void init_keyboard() {
    register_handler(0x21, io_keyboard_handler);
    putstring("init_keyboard!\n");
}