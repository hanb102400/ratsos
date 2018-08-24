;Rats OS
;TAB=4
[BITs 16]
    org     0x7c00 			;指明程序的偏移的基地址

;引导扇区代码  
    jmp     Entry
    db      0x90
    db      "RATSBOOT"    	        ;启动区的名称可以是任意的字符串（8字节）       

;程序核心内容
Entry:
    mov ax,0xb800
    mov es,ax	                ;显存段地址
    mov byte [es:0x00],'h'      ;输出字符
    mov byte [es:0x01],0x17     ;设置颜色(背景色蓝，前景色白)
    mov byte [es:0x02],'e'
    mov byte [es:0x03],0x17
    mov byte [es:0x04],'l'
    mov byte [es:0x05],0x17
    mov byte [es:0x06],'l'
    mov byte [es:0x07],0x17
    mov byte [es:0x08],'o'
    mov byte [es:0x09],0x17
    mov byte [es:0x0a],','
    mov byte [es:0x0b],0x17
    mov byte [es:0x0c],'r'
    mov byte [es:0x0d],0x17
    mov byte [es:0x0e],'a'
    mov byte [es:0x0f],0x17
    mov byte [es:0x10],'t'
    mov byte [es:0x11],0x17
    mov byte [es:0x12],'s'
    mov byte [es:0x13],0x17
    mov byte [es:0x14],'o'
    mov byte [es:0x15],0x17
    mov byte [es:0x16],'s'
    mov byte [es:0x17],0x17
    mov byte [es:0x18],'!'
    mov byte [es:0x19],0x17

;程序挂起
Fin:
    hlt                     	;让CPU挂起，等待指令。
    jmp Fin

FillSector:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)的填充
    db      0x55, 0xaa