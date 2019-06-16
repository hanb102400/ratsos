
#ifndef __LIB_CONSOLE_H
#define __LIB_CONSOLE_H

#include "stdint.h"

uint32 getCursor();

void setCursor(uint32 pos);

uint32 putchar(char ch);

void putstring(char* chs);

void putpointer(uint32 addr);

#endif
