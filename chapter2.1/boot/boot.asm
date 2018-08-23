;RatsOS
;TAB=4
[BITs 16]
	ORG     0x7c00 				;指明程序的偏移的基地址

;启动程序
	JMP     Entry
	DB      0x90
	DB      "RATSBOOT"     		;启动区的名称可以是任意的字符串（8字节）    

;程序核心内容
Entry:
	MOV AX,0xb800
	MOV ES,AX                   ;显存段地址
	MOV byte [ES:0x00],'h'      ;输出字符
	MOV byte [ES:0x01],0x17     ;设置颜色(背景色蓝，前景色白)
	MOV byte [ES:0x02],'e'
	MOV byte [ES:0x03],0x17
	MOV byte [ES:0x04],'l'
	MOV byte [ES:0x05],0x17
	MOV byte [ES:0x06],'l'
	MOV byte [ES:0x07],0x17
	MOV byte [ES:0x08],'o'
	MOV byte [ES:0x09],0x17
	MOV byte [ES:0x0a],','
	MOV byte [ES:0x0b],0x17
	MOV byte [ES:0x0c],'r'
	MOV byte [ES:0x0d],0x17
	MOV byte [ES:0x0e],'a'
	MOV byte [ES:0x0f],0x17
	MOV byte [ES:0x10],'t'
	MOV byte [ES:0x11],0x17
	MOV byte [ES:0x12],'s'
	MOV byte [ES:0x13],0x17
	MOV byte [ES:0x14],'o'
	MOV byte [ES:0x15],0x17
	MOV byte [ES:0x16],'s'
	MOV byte [ES:0x17],0x17
	MOV byte [ES:0x18],'!'
	MOV byte [ES:0x19],0x17

;程序挂起
Fin:
	HLT                     	;让CPU挂起，等待指令。
	JMP Fin

FillSector:
	RESB    510-($-$$)       	;处理当前行$至结束(1FE)的填充
	DB      0x55, 0xaa