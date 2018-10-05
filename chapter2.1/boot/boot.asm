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
    mov ax,0xb800
    mov es,ax	                ;显存段地址
    mov byte [es:0x00],'r'      ;输出字符
    mov byte [es:0x01],0x17     ;设置颜色(背景色蓝，前景色白)
    mov byte [es:0x02],'a'
    mov byte [es:0x03],0x17
    mov byte [es:0x04],'t'
    mov byte [es:0x05],0x17
    mov byte [es:0x06],'s'
    mov byte [es:0x07],0x17
    mov byte [es:0x08],'o'
    mov byte [es:0x09],0x17
    mov byte [es:0x0a],'s'
    mov byte [es:0x0b],0x17
  

;程序挂起
Fin:
    hlt                     	;让CPU挂起，等待指令。
    jmp Fin
    
;扇区格式
Fill0:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)填充0
    db      0x55, 0xaa