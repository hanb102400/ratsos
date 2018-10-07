
#ifndef __LIB_CONSOLE_H
#define __LIB_CONSOLE_H

#include "stdint.h"

uint32 getCursor();

void setCursor(uint32 pos);

uint32 putchar(uint8 ch);

#endif