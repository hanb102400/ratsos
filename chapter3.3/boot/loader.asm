;ratsos
;TAB=4
[BITs 16]
;----------- loader const ------------------
LOADER_BASE_ADDR 		equ 0x9000  ;内存地址0x9000
;---------------------------------------	
section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址
	
	;程序核心内容
Entry:
	
	;------------------
	; 设置显示模式
	MOV		ah,0x0			; 参数：设置VGA显示器模式
	MOV		al,0x13			; 参数: 640×480(256色)
	INT		0x10			; 调用BIOS中断,设置显示模式
			
	;------------------
	;显示hello
	MOV DI,HelloMessage			;将Message1段的地址放入SI
	mov DH,0				;设置显示行
	CALL PutString				;调用函数
	
	;------------------
	;打开A20
	CLI					;禁止CPU级别的中断

	in al,0x92
	or al,0000_0010B        		;设置第1位为1
	
	;------------------
	;进入保护模式
	mov eax,CR0
	or eax,0x00000001            		;设置第0位为1
	mov CR0,eax

	;-----------------------------------------------
	;加载GDT
	lgdt [gdt_addr]	



;程序挂起		
	JMP $			;让CPU挂起，等待指令?

; ------------------------------------------------------------------------
;定义GDT全局描述符表
gdt_addr :
	DW		8*2-1					;指定段上限(GDT全局描述符表的大小)
	DD		gdt_table_addr				;GDT全局描述符表的地址
gdt_table_addr:
	DW		0xffff,0x0000,0x9200,0x00cf		;可以读写的段(segment)32bit内存大小
	DW		0xffff,0x0000,0x9a28,0x0047		;可以执行的段GDT2,280000地址开始
	DW		0	

		
; ------------------------------------------------------------------------
; 显示字符串函数:PutString
; 参数:
; SI = 字符串开始地址, 
; DH = 屏幕第N行，0开始
; ------------------------------------------------------------------------	
PutString:
		MOV CX,0			;BIOS中断参数：显示字符串长度
		MOV BX,DI
	.s1:;获取字符串长度
		MOV AL,[BX]			;读取1个字节。这里必须为AL
		ADD BX,1			;读取下个字节
		CMP AL,0			;是否以0结束
		JE .s2
		ADD	CX,1			;计数器
		JMP .s1
	.s2:;显示字符串
		MOV BX,DI
		MOV BP,BX
		MOV AX,DS
		MOV ES,AX			;BIOS中断参数：计算[ES:BP]为显示字符串开始地址

		MOV AH,0x13			;BIOS中断参数：显示文字串
		MOV AL,0x01			;BIOS中断参数：文本输出方式(40×25 16色 文本)
		MOV BH,0x0			;BIOS中断参数：指定分页为0
		MOV BL,0x1F			;BIOS中断参数：指定白色文字			
		MOV DL,0			;列号为0
		INT 0x10			;调用BIOS中断操作显卡。输出字符串
		RET

;准备显示字符串
	HelloMessage: DB "hello,ratsos!",0

	times	512-($-$$) db  0 ; 处理当前行$至结束(1FE)的填充	