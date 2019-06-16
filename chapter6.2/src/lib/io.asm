;RatsOS

[bits 32]

global io_hlt, io_cli, io_sti
global io_in8, io_out8
global io_in16, io_out16
global io_in32, io_out32

[section .text]

io_hlt:     ;void io_hlt
    hlt
    ret

io_cli:     ;void io_cli
    cli
    ret

io_sti:     ;void io_sti
    sti
    ret

io_in8:     ;int io_in8(uint16 port)
    mov dx,[esp+4]
    mov al,0
    in  al ,dx
    ret

io_out8:    ;void io_out8(uint16 port,uint32 data)
    mov dx,[esp+4]
    mov al,[esp+8]
    out dx, al
    ret

io_in16:     ;int io_in16(uint16 port)
    mov dx,[esp+4]
    mov ax,0
    in  ax,dx
    ret

io_out16:    ;void io_out16(uint16 port,uint32 data)
    mov dx,[esp+4]
    mov ax,[esp+8]
    out dx,ax
    ret

io_in32:     ;int io_in32(uint16 port)
    mov dx,[esp+4]
    mov eax,0
    in  eax,dx
    ret

io_out32:    ;void io_out32(uint16 port,uint32 data)
    mov dx,[esp+4]
    mov eax,[esp+8]
    out dx,eax
    ret

