;ratsos
;TAB=4
	
	ORG 0x7c00 				;指明程序的偏移的基地址

;启动开始内容  

	jmp     Entry
	DB      0x90
	DB      "RATSOS"      	;启动区的名    

;程序核心内容
Entry:
	
	mov ah,0x02				; 光标位置初始化
	mov dx,0
	int 0x10
	
	mov ah,0x06				; 清除屏幕
	mov bh,0x07					
	mov al,0
	mov cx,0   
    mov dx,0xffff  
    mov bh,0x17				;属性为蓝底白字
	int 0x10
	
	mov ax,0				;初始化寄存器
	mov ss,ax
	mov sp,0x7c00
	mov ds,ax
	mov es,ax

	mov di,HelloMessage		;将Message1段的地址放入SI
	mov dh,0				;设置显示行
	call PutString			;调用函数
	

;程序挂起
Fin:
	hlt 					;让CPU挂起，等待指令。
	jmp Fin

; ------------------------------------------------------------------------
; 显示字符串函数:PutString
; 参数:
; si = 字符串开始地址, 
; dh = 第N行，0开始
; ------------------------------------------------------------------------	
PutString:
		mov cx,0			;BIOS中断参数：显示字符串长度
		mov bx,di
	.s1:;获取字符串长度
		mov al,[bx]			;读取1个字节。这里必须为AL
		add bx,1			;读取下个字节
		cmp al,0			;是否以0结束
		je .s2
		add	cx,1			;计数器
		jmp .s1
	.s2:;显示字符串
		mov bx,di
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

;准备显示字符串
	HelloMessage: DB "hello,ratsos!",0
	

	RESB	510-($-$$)		; 处理当前行$至结束(1FE)的填充
	DB		0x55, 0xaa