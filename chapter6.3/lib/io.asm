;Ratsos

[bits 32]


global io_inb, io_inw, io_ind
global io_outb, io_outw, io_outd
global io_movsb, io_movsw,  io_movsd
global io_hlt

[section .text]

io_inb:     ;int io_inb(int port)
    mov edx,[esp+4]
    mov eax,0
    in  al ,dx
    ret

io_inw:     ;int io_inw(int port)
    mov edx,[esp+4]
    mov eax,0
    in  ax ,dx
    ret

io_ind:     ;int io_ind(int port)
    mov edx,[esp+4]
    mov eax,0
    in  eax,dx
    ret

io_outb:    ;void io_outb(int port,int data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx, al
    ret

io_outw:    ;void io_outw(int port,int data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx, ax
    ret

io_outd:    ;void io_outd(int port,int data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx,eax
    ret

io_movsb: ;int io_movsb(int src,int dest, int num);
    push ecx
    cld
    mov esi,[esp+4]                     
    mov edi,[esp+8]                       
    mov ecx,[esp+12]
    rep movsb
    pop ecx
    ret

io_movsw:  ;int io_movsw(int src,int dest, int num);
    push ecx
    cld
    mov esi,[esp+4]                     
    mov edi,[esp+8]                       
    mov ecx,[esp+12]  
    rep movsw
    pop ecx
    ret

io_movsd:   ;int io_movsd(int src,int dest, int num);
    push ecx
    cld
    mov esi,[esp+4]                     
    mov edi,[esp+8]                       
    mov ecx,[esp+12]
    rep movsd
    pop ecx
    ret

io_hlt:     ;void io_hlt
    io_hltret