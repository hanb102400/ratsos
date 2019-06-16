

#include "../include/io.h"
#include "../include/stdint.h"
#include "../include/console.h"

int _start()
{
    putchar('h');
    putchar('e');
    putchar('l');
    putchar('l');
    putchar('o');
    putchar('r');
    putchar('a');
    putchar('t');
    putchar('s');
    putchar('!');
    putchar('\r');
    putchar('\n');
    io_hlt();
}
