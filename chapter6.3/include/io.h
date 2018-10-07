
#ifndef __LIB_IO_H
#define __LIB_IO_H

int io_inb(int port);

int io_inw(int port);

int io_ind(int port);

void io_outb(int port,int data);

void io_outw(int port,int data);

void io_outd(int port,int data);


int io_movsb(int src,int dest, int num);

int io_movsw(int src,int dest, int num);

int io_movsd(int src,int dest, int num);


void io_hlt();

#endif