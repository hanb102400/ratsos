
#include "../include/io.h"
#include "../include/stdint.h"
#include "../include/console.h"
#include "../include/interrupt.h"

int _start()
{   

    init_idt();

    char *str = "yes, i am a string!";
    putstring(str);
    io_hlt();
}
