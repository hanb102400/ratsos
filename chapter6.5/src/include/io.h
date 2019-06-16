
#ifndef __LIB_IO_H
#define __LIB_IO_H

void io_hlt();

uint32 io_inb(uint32 port);

void io_outb(uint32 port, uint32 data);

uint32 io_inw(uint32 port);

void io_outw(uint32 port, uint32 data);

uint32 io_ind(uint32 port);

void io_outd(uint32 port, uint32 data);

int io_movsb(uint32 src, uint32 dest, int num);

int io_movsw(uint32 src, uint32 dest, int num);

int io_movsd(uint32 src, uint32 dest, int num);

void io_interrupt(int index);

void io_lgdt(uint64* p_gdt);

void io_lidt(uint64* p_gdt);

#endif
