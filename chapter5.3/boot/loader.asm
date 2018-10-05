;ratsos

%include "boot/boot.inc"

section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

[bits 16]

    jmp Entry;

;---------------------------------
;定义GDT全局描述符表
;code: 0x0000ffff, 0x00cf9a00   : 
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

    jmp	 dword   selector_code:FlushPipeline     

 
[bits 32]
;------------------    
;刷新流水线
FlushPipeline:

    mov		ax,selector_data			;  可读写的32bit
    mov		ds,ax
    mov		es,ax
    mov		fs,ax
    mov     ss,ax
    mov     ax, selector_vga
    mov     gs, ax

    ;----------------------
    ;解析并执行ELF文件
    mov     eax, LOADER1_BASE_ADDR 
    call    AnalyzeELF
    jmp     ebx  

;-----------------------------------
; 解析执行ELF文件: AnalyzeELF
; 入参： 
; eax=文件内存位置
; 出参： 
; ebx=入口地址
AnalyzeELF:	


    mov edx, 0
    mov ecx, 0
    mov ebx, [eax + 28]			;program header偏移量
    add ebx, eax				;program header位置
    mov dx,  [eax + 42]			;program header大小
    mov cx,  [eax + 44]			;program header数量
   

    .loopSegment:
        cmp byte [ebx + 0],0	;ptype为0，程序段未使用
        je  .nextSegment

    
        push ecx;
        mov  ecx, 0;
        ;---------------
        ;复制segment
        mov esi, [ebx + 4]		;segment偏移量
        add esi, eax			;src
        mov edi, [ebx + 8]		;dist
        mov cx,  [ebx + 16]		;len
        call MemCopy
        pop ecx;
        
    .nextSegment:
        add ebx, edx
        loop .loopSegment		;继续读取下一个segment
        mov ebx, [eax + 24]     ;返回入口地址
        ret


;------------------    
;内存复制 : 源地址，目标地址，字节数
;输入： 
;esi = 源地址
;edi = 目标地址
;ecx = 字节数
MemCopy:
    rep movsb; 
    ret
