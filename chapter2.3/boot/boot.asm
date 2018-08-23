;ratsos
;TAB=4
	
	ORG 0x7c00 				;指明程序的偏移的基地址

;启动开始内容  

	JMP     Entry
	DB      0x90
	DB      "RATSOS"      	;启动区的名    

;程序核心内容
Entry:

	MOV AH,0x02				;光标位置初始化
	MOV DX,0
	INT 0x10
	
	MOV AH,0x06				;清除屏幕
	MOV BH,0x07					
	MOV AL,0
	MOV CX,0   
    MOV DX,0xffff  
    MOV BH,0x17				;属性为蓝底白字
	INT 0x10
	

	
;程序挂起
Fin:
	HLT 					;让CPU挂起，等待指令。
	JMP Fin

	RESB	510-($-$$)		;处理当前行$至结束(1FE)的填充
	DB		0x55, 0xaa