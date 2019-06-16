;ratsos
[bits 16]

;----------- loader const ------------------
LOADER_BASE_ADDR 		equ 0x9000  	;内存地址0x9000
;---------------------------------------	

section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

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


	;------------------
	;进入保护模式
	mov 	eax,cr0
	or 		eax,0x00000001      ;设置第0位为1
	mov 	cr0,eax



;程序挂起
Fin:
    hlt 					;让CPU挂起，等待指令。
    jmp Fin



;扇区格式
Fill0:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)填充0
    db      0x55, 0xaa