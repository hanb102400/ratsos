;ratsos
;TAB=4
[BITs 16]

section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

;----------- loader const ------------------
LOADER_BASE_ADDR 		equ 0x9000  ;内存地址0x9000
;---------------------------------------	
	
;程序核心内容
Entry:
	
	;------------------
	; 设置显示模式
	;mov		ah, 0x0			;显示模式：VGA显示器
	;mov		al, 0x12		;640×480(256色)

	mov 	ax, 0x4F02			;显示模式：超级VGA显示器
	mov 	bx, 0x108			;80×60 文本模式
	int		0x10				;调用BIOS中断,设置显示模式
	
	;------------------
	;禁止CPU级别的中断
	cli						    

	;------------------
	;打开A20
	in 		al,0x92
	or 		al,0000_0010B       ;设置第1位为1
	out 	0x92,al
	
	;-------------------
	;加载GDT
	lgdt [gdt_addr]	


	;------------------
	;进入保护模式
	mov 	eax,cr0
	or 		eax,0x00000001      ;设置第0位为1
	mov 	cr0,eax

	;------------------
	;恢复中断
	sti


;程序挂起		
	jmp $			;让CPU挂起，等待指令?

		
; ------------------------------------------------------------------------
; 显示字符串函数:PutString
; 参数:
; SI = 字符串开始地址, 
; DH = 屏幕第N行，0开始
; ------------------------------------------------------------------------	
PutString:
		mov cx,0			;BIOS中断参数：显示字符串长度
		mov bx,si
	.s1:;获取字符串长度
		mov al,[bx]			;读取1个字节。这里必须为AL
		add bx,1			;读取下个字节
		cmp al,0			;是否以0结束
		je .s2
		add	cx,1			;计数器
		jmp .s1
	.s2:;显示字符串
		mov bx,si
		mov bp,bx
		mov ax,ds
		mov es,ax			;BIOS中断参数：计算[ES:BP]为显示字符串开始地址

		mov ah,0x13			;BIOS中断参数：显示文字串
		mov al,0x01			;BIOS中断参数：文本输出方式(40×25 16色 文本)
		mov bh,0x0			;BIOS中断参数：指定分页为0
		mov bl,0x1F			;BIOS中断参数：指定白色文字			
		mov dl,0			;列号为0
		int 0x10			;调用BIOS中断操作显卡。输出字符串
		ret


	times	512-($-$$) db  0 ; 处理当前行$至结束(1FE)的填充	