;ratsos
;TAB=4

%include "boot/boot.inc"
section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

[bits 16]

    jmp Entry;

; ------------------------------------------------------------------------
;定义GDT全局描述符表
gdt_addr:
    dw		8*4-1						;指定段上限为4(GDT全局描述符表的大小)
    dd		gdt_table_addr				;GDT全局描述符表的地址
gdt_table_addr:
                Gdt_Descriptor 0,0,0
label_sel_code:	Gdt_Descriptor 0x00000000, 0xfffff, DESC_CODE  ;dw		0xffff,0x0000,0x9a00,0x00cf		;可以执行的段
label_sel_data:	Gdt_Descriptor 0x00000000, 0xfffff, DESC_DATA  ;dw		0xffff,0x0000,0x9200,0x00cf		;可以读写的段
label_sel_vga:	Gdt_Descriptor 0x000b8000, 0x07fff, DESC_DATA
    dw		0	

; dd 0x0000ffff, 0x00cf9a00   
; dd 0x0000ffff, 0x00cf9200

selector_code equ	 label_sel_code - gdt_table_addr
selector_data equ	 label_sel_data - gdt_table_addr
selector_vga  equ	 label_sel_vga - gdt_table_addr

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
    
    ;-------------------
    ;加载GDT
    lgdt [gdt_addr]	

    ;------------------
    ;进入保护模式
    mov 	eax,cr0
    or 		eax,0x1      ;设置第0位为1
    mov 	cr0,eax

    jmp	 dword   selector_code:FlushPipeline       


[bits 32]
;------------------    
;刷新流水线
FlushPipeline:

    mov		ax,selector_code			;  可读写的32bit
    mov		ds,ax
    mov		es,ax
    mov		ss,ax
    mov		fs,ax
    mov     ax, selector_vga
    mov     gs, ax

    jmp LOADER1_BASE_ADDR


;准备显示字符串
HelloMsg: DB "hello,ratsos!",0	

; ------------------------------------------------------------------------
; 显示字符串函数:PutString
; 字符串必须以0为结尾，自动计算长度
; 参数:
; SI = 字符串开始地址, 
; DH = 屏幕第N行，0开始
; ------------------------------------------------------------------------	
PutString:
        mov cx,0			;BIOS中断参数：显示字符串长度
        mov bx,si
    .Loop_getLen:;获取字符串长度
        mov al,[bx]			;读取1个字节。这里必须为AL
        add bx,1			;读取下个字节
        cmp al,0			;是否以0结束
        je .Display_Str
        add	cx,1			;计数器
        jmp .Loop_getLen
    .Display_Str:;显示字符串
        mov bx,si
        mov bp,bx
        mov ax,ds
        mov es,ax			;BIOS中断参数：计算[ES:BP]为显示字符串开始地址

        mov ah,0x13			;BIOS中断参数：显示文字串
        mov al,0x01			;BIOS中断参数：文本输出方式(40×25 16色 文本)
        mov bh,0x0			;BIOS中断参数：指定分页为0
        mov bl,0x1F			;BIOS中断参数：指定白色文字			
        mov dl,0			;列号为0
        int 0x10			;调用BIOS中断操作显卡。输出字符串
        ret


    times	2048-($-$$) db  0 ; 处理当前行$至结束(1FE)的填充	