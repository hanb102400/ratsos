;Ratsos

[bits 32]


global io_inb, io_inw, io_ind
global io_outb, io_outw, io_outd
global io_movsb, io_movsw,  io_movsd
global io_hlt, io_cli, io_sti
global io_lgdt,io_lidt
global io_keybord_handler
extern keybord_handler_callback

[section .text]

io_inb:     ;int io_inb(uint32 port)
    mov edx,[esp+4]
    mov eax,0
    in  al ,dx
    ret

io_inw:     ;int io_inw(uint32 port)
    mov edx,[esp+4]
    mov eax,0
    in  ax ,dx
    ret

io_ind:     ;int io_ind(uint32 port)
    mov edx,[esp+4]
    mov eax,0
    in  eax,dx
    ret

io_outb:    ;void io_outb(uint32 port,uint32 data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx, al
    ret

io_outw:    ;void io_outw(uint32 port,uint32 data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx, ax
    ret

io_outd:    ;void io_outd(uint32 port,uint32 data)
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx,eax
    ret

io_movsb: ;uint32 io_movsb(uint32 src,uint32 dest, int num);
    push ecx
    cld
    mov esi,[esp+4]                     
    mov edi,[esp+8]                       
    mov ecx,[esp+12]
    rep movsb
    pop ecx
    ret

io_movsw:  ;uint32 io_movsw(uint32 src,uint32 dest, int num);
    push ecx
    cld
    mov esi,[esp+4]                     
    mov edi,[esp+8]                       
    mov ecx,[esp+12]  
    rep movsw
    pop ecx
    ret

io_movsd:   ;uint32 io_movsd(uint32 src,uint32 dest, int num);
    push ecx
    cld
    mov esi,[esp+4]                     
    mov edi,[esp+8]                       
    mov ecx,[esp+12]
    rep movsd
    pop ecx
    ret

io_hlt:     ;void io_hlt
    hlt
    ret

io_cli:     ;void io_cli
    cli
    ret

io_sti:     ;void io_sti
    sti
    ret

io_lgdt: ;void io_lgdt(uint32* p_gdt)
    mov eax, [esp+4]
    lgdt [eax]
    ret

io_lidt: ;void io_lidt(uint32* p_gdt)
    mov eax, [esp+4]
    lidt [eax]
    ret

io_keybord_handler:  ;void io_keybord_handler(uint* esp)
    PUSH	ES
    PUSH	DS
    PUSHAD
    MOV		EAX,ESP
    PUSH	EAX
    MOV		AX,SS
    MOV		DS,AX
    MOV		ES,AX
    CALL	keybord_handler_callback
    POP		EAX
    POPAD
    POP		DS
    POP		ES
    iret