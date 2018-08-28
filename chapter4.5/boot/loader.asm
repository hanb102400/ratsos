;Rats OS
;Tab=4
[bits 16]

section loader vstart=LOADER_BASE_ADDR ;指明程序的偏移的基地址

;----------- loader const ------------------
LOADER_BASE_ADDR 		equ 0x9000  ;内存地址0x9000
;---------------------------------------	
	jmp Entry
	
	
;程序核心内容
Entry:
	

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
	jmp $			;让CPU挂起，等待指令?

