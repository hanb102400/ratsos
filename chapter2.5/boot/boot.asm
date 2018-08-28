;Rats OS
;TAB=4
[bits 16]
    org     0x7c00 			;指明程序的偏移的基地址

;引导扇区代码  
    jmp     Entry
    db      0x90
    db      "RATSBOOT"    	        ;启动区的名称可以是任意的字符串（8字节）       

;程序核心内容
Entry:

    mov ah,0x06				;清除屏幕					
    mov al,0
    mov cx,0   
    mov dx,0xffff  
    mov bh,0x17				;属性为蓝底白字
    int 0x10
    

    mov ah,0x02				;光标位置初始化
    mov dx,0
    mov bh,0
    mov dh,0x0
    mov dl,0x0
    int 0x10

    ;---------------------------
    ;输出字符串
    mov si,HelloMsg		    ;将HelloMsg的地址放入si
    call Func_Sprint		;调用函数
    
    jmp $				;进入死循环，不再往下执行。

; ------------------------------------------------------------------------
; 显示字串函数:Func_Sprint
; 参数:
; si = 字符串开始地址,
; ------------------------------------------------------------------------
Func_Sprint:
   .cprint:
        mov al,[si]				;将[di]指向的内存单元的一个字节放入AL。
        inc si					;di指向下一个字节
        cmp al,0				;判断[di]中的字符值是否==0

        je .printEnd			;为0字符则串结束
        mov ah,0x0e				;BIOS中断参数：中断模式
        mov bl,0x03				;BIOS中断参数：指定字符颜色
        int 0x10				;调用BIOS中断操作显卡。输出字符
        jmp .cprint
   .printEnd:
        ret

; ------------------------------------------------------------------------
;准备显示字符串
HelloMsg: db "hello,ratsos!",0



FillSector:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)的填充
    db      0x55, 0xaa