;RatsOS
;TAB=4

%include "boot/boot.inc"

[bits 32]

    org LOADER1_BASE_ADDR

    jmp Entry

;程序核心内容
Entry:
	;显存段地址
	mov byte [gs:0x00],'h'      ;输出字符
	mov byte [gs:0x01],0x17     ;设置颜色(背景色蓝，前景色白)
	mov byte [gs:0x02],'e'
	mov byte [gs:0x03],0x17
	mov byte [gs:0x04],'l'
	mov byte [gs:0x05],0x17
	mov byte [gs:0x06],'l'
	mov byte [gs:0x07],0x17
	mov byte [gs:0x08],'o'
	mov byte [gs:0x09],0x17
	mov byte [gs:0x0a],','
	mov byte [gs:0x0b],0x17
	mov byte [gs:0x0c],'l'
	mov byte [gs:0x0d],0x17
	mov byte [gs:0x0e],'o'
	mov byte [gs:0x0f],0x17
	mov byte [gs:0x10],'a'
	mov byte [gs:0x11],0x17
	mov byte [gs:0x12],'d'
	mov byte [gs:0x13],0x17
	mov byte [gs:0x14],'e'
	mov byte [gs:0x15],0x17
	mov byte [gs:0x16],'r'
	mov byte [gs:0x17],0x17
	mov byte [gs:0x18],'1'
	mov byte [gs:0x19],0x17


	jmp $                     	;让CPU挂起，等待指令。
