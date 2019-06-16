#ifndef __LIB_IO_H
#define __LIB_IO_H

#include "stdint.h"

void io_hlt();

uint8 io_in8(uint8 port);

void io_out8(uint16 port, uint8 data);

uint16 io_in16(uint16 port);

void io_out16(uint16 port, uint16 data);

uint32 io_in32(uint16 port);

void io_out32(uint16 port, uint32 data);

#endif