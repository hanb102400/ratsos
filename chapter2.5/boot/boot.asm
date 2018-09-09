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

    ;---------------------------
    ;清除屏幕	
    mov ah,0x06							
    mov al,0
    mov cx,0   
    mov dx,0xffff  
    mov bh,0x17				;属性为蓝底白字
    int 0x10
    
    ;---------------------------
    ;光标位置初始化
    mov ah,0x02				
    mov dx,0
    mov bh,0
    mov dh,0x0
    mov dl,0x0
    int 0x10

    ;---------------------------
    ;输出字符串
    mov  si, BootMsg		;将BootMsg的地址放入si
    mov  dh, 0				;设置显示行
    call PutString			;调用函数
    
;程序挂起
Fin:
    hlt 					;让CPU挂起，等待指令。
    jmp Fin


; ------------------------------------------------------------------------
; 显示字串函数:PutString
; 参数:
; si = 字符串文本地址
; ------------------------------------------------------------------------
PutString:
	;------------------
	;显示一个字符，si = 字符串文本地址
    .putChar:
        mov al,[si]				;将[di]指向的内存单元的一个字节放入AL。
        inc si					;di指向下一个字节
        cmp al,0				;判断[di]中的字符值是否==0

        je .putEnd			;为0字符则串结束
        mov ah,0x0e				;BIOS中断参数：中断模式
        mov bl,0x03				;BIOS中断参数：指定字符颜色
        int 0x10				;调用BIOS中断操作显卡。输出字符
        jmp .putChar
   .putEnd:
        ret

; ------------------------------------------------------------------------
;准备显示字符串
BootMsg: db "ratsos is booting!",0

;扇区格式
Fill0:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)填充0
    db      0x55, 0xaa