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

	MOV AH,0x06				;清除屏幕					
	MOV AL,0
	MOV CX,0   
    MOV DX,0xffff  
    MOV BH,0x17				;属性为蓝底白字
	INT 0x10
	

	MOV AH,0x02				;光标位置初始化
	MOV DX,0
	MOV BH,0
	MOV DH,0x0
	MOV DL,0x0
	INT 0x10
	
;程序挂起
Fin:
	HLT 					;让CPU挂起，等待指令。
	JMP Fin

FillSector:
	RESB    510-($-$$)       	;处理当前行$至结束(1FE)的填充
	DB      0x55, 0xaa