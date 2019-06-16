
#include "../include/io.h"
#include "../include/stdint.h"
#include "../include/console.h"
#include "../include/interrupt.h"

int _start()
{   
    init_idt();
    char *str2 = "init_idt completed\n";
    putstring(str2);

    char *str = "yes, i am a string!";
    putstring(str);
    for(;;){
        io_hlt();
    }
   
}
