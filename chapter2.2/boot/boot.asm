;Ratsos
;Tab=4
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
    
;程序挂起
Fin:
    hlt                     	;让CPU挂起，等待指令。
    jmp Fin
    
;扇区格式
Fill0:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)填充0
    db      0x55, 0xaa