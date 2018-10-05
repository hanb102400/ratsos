;Ratsos

[bits 32]


global io_inb, io_inw
global io_outb, io_outw

[section .text]

io_inb:     ;int io_inb(int port)
    mov edx,[esp+4]
    mov eax,0
    in  al ,dx
    ret

io_inw:     ;int io_inw(int port)
    mov edx,[esp+4]
    in  eax ,dx
    ret

io_outb:    ;void io_outb(int port,int data)
    mov edx,[esp+4]
    mov eax.[esp+8]
    out dx,ax
    ret

io_outw:    ;void io_outw(int port,int data)
    mov edx,[esp+4]
    mov eax.[esp+8]
    out dx,eax
    ret


