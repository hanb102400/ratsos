
#include "../include/io.h"
#include "../include/global.h"
#include "../include/console.h"
#include "../include/interrupt.h"

int _start()
{

    init_idt();

    char *str = "yes, i am a string!\n";
    putstring(str);
    for (;;)
    {
        io_hlt();
    }
}
