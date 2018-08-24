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

	;---------------------------
	;输出字符串
	mov di,HelloText		;将HelloText的地址放入di
	mov dh,0				;设置显示行
	call PutString			;调用函数
	
;程序挂起
Fin:
	HLT 					;让CPU挂起，等待指令。
	JMP Fin

; ------------------------------------------------------------------------
;准备显示字符串
HelloText: DB "hello,ratsos!",0

; ------------------------------------------------------------------------
; 显示字串函数:PutString
; 参数:
; di = 字符串开始地址,
; dh = 第N行，0开始
; ------------------------------------------------------------------------
;循环调用BIOS执行显示字符串
PutString:
	.putChar:
		mov al,[di]				;将[di]指向的内存单元的一个字节放入AL。
		add di,1				;di指向下一个字节
		cmp al,0				;判断[di]中的字符值是否==0

		je .putEnd				;为0字符则串结束
		mov ah,0x0e				;BIOS中断参数：显示一个文字
		mov bl,0x03				;BIOS中断参数：指定字符颜色
		int 0x10				;调用BIOS中断操作显卡。输出字符
		jmp .putChar
	.putEnd:
		ret

FillSector:
	RESB    510-($-$$)       	;处理当前行$至结束(1FE)的填充
	DB      0x55, 0xaa