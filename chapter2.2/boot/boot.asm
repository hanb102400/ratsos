;RatsOS
;TAB=4
[bits 16]
	org     0x7c00 				;指明程序的偏移的基地址

;boot程序
	jmp     Entry
	db      0x90
	db      "RATSBOOT"     		;启动区的名称可以是任意的字符串（8字节）    

;程序核心内容
Entry:
	mov ax,0xb800
	mov gs,ax                   ;显存段地址
	mov byte [gs:0x00],'h'      ;输出字符
	mov byte [gs:0x01],0x74     ;设置颜色(背景色蓝，前景色白)
	mov byte [gs:0x02],'e'
	mov byte [gs:0x03],0x74
	mov byte [gs:0x04],'l'
	mov byte [gs:0x05],0x74
	mov byte [gs:0x06],'l'
	mov byte [gs:0x07],0x74
	mov byte [gs:0x08],'o'
	mov byte [gs:0x09],0x74
	mov byte [gs:0x0a],','
	mov byte [gs:0x0b],0x74
	mov byte [gs:0x0c],'r'
	mov byte [gs:0x0d],0x74
	mov byte [gs:0x0e],'a'
	mov byte [gs:0x0f],0x74
	mov byte [gs:0x10],'t'
	mov byte [gs:0x11],0x74
	mov byte [gs:0x12],'s'
	mov byte [gs:0x13],0x74
	mov byte [gs:0x14],'o'
	mov byte [gs:0x15],0x74
	mov byte [gs:0x16],'s'
	mov byte [gs:0x17],0x74
	mov byte [gs:0x18],'!'
	mov byte [gs:0x19],0x74

                 	
	jmp $				;进入死循环，不再往下执行。

FillSector:
	resb    510-($-$$)       	;处理当前行$至结束(1FE)的填充
	db      0x55, 0xaa
	
