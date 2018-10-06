
#ifndef __LIB_IO_H
#define __LIB_IO_H

int io_inb(int port);

int io_inw(int port);

void io_outb(int port,int data);

void io_outw(int port,int data);

void io_hlt();

#endif