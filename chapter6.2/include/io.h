
#ifndef __LIB_IO_H
#define __LIB_IO_H

#include "stdint.h"

uint32 io_inb(uint32 port);

uint32 io_inw(uint32 port);

void io_outb(uint32 port,uint32 data);

void io_outw(uint32 port,uint32 data);

void io_hlt();

#endif