;Ratsos

[bits 32]


global io_inb, io_inw
global io_outb, io_outw
global io_hlt

[section .text]

io_inb:     ;uint32 io_inb(uint32 port)
    mov edx,[esp+4]
    mov eax,0
    in  al ,dx
    ret

io_outb:    ;void io_outb(uint32 port,uint32 data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx, al
    ret

io_inw:     ;uint32 io_inw(uint32 port)
    mov edx,[esp+4]
    mov eax,0
    in  ax ,dx
    ret

io_outw:    ;void io_outw(uint32 port,uint32 data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx, ax
    ret


io_hlt:     ;void io_hlt
    io_hltret