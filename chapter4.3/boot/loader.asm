;ratsos
;TAB=4

%include "boot/boot.inc"

section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

[bits 16]

    jmp Entry;

;---------------------------------
;定义GDT全局描述符表
;code: 0x0000ffff, 0x00cf9a00   
;data: 0x0000ffff, 0x00cf9200
;vga:
Gdt_Addr:
    dw		8*4-1						;指定段上限为4(GDT全局描述符表的大小)
    dd		Gdt_Table_Addr				;GDT全局描述符表的地址
Gdt_Table_Addr:
    Gdt_Descriptor 0,0,0
    Gdt_Descriptor 0x00000000, 0xfffff, DESC_CODE  ;可以执行的段
    Gdt_Descriptor 0x00000000, 0xfffff, DESC_DATA  ;可以读写的段
    Gdt_Descriptor 0x000b8000, 0x07fff, DESC_DATA  ;vga段
    dw		0	

;程序核心内容
Entry:
    
    ;------------------
    ;禁止CPU级别的中断，进入保护模式时没有建立中断表
    cli	

    ;------------------
    ;打开A20
    in 		al,0x92
    or 		al,0000_0010B       ;设置第1位为1
    out 	0x92,al
    
    ;------------------
    ;加载GDT
    lgdt [Gdt_Addr]

    ;------------------
    ;进入保护模式
    mov 	eax,cr0
    or 		eax,0x1      ;设置第0位为1
    mov 	cr0,eax

;程序挂起
Fin:
    hlt 					;让CPU挂起，等待指令。
    jmp Fin
