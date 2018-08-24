;ratsos
;TAB=4
[BITs 16]

ORG 0x7c00 ;指明程序的偏移的基地址
	
;----------- loader const ------------------
LOADER_SECTOR_LBA  		equ 0x1		;第2个逻辑扇区开始
LOADER_SECTOR_COUNT		equ 1		;读取4个扇区
LOADER_BASE_ADDR 		equ 0x9000  ;内存地址0x9000
;---------------------------------------	

;启动开始内容  

	JMP     Entry
	DB      0x90
	DB      "RATSOS"      	;启动区的名    

;程序核心内容
Entry:

	;------------------
	;初始化寄存器
	MOV AX,0				
	MOV SS,AX
	MOV DS,AX
	MOV ES,AX
	MOV SP,0x7c00
	
	;------------------
	;初始化文本模式屏幕
	MOV AH,0x02				; 光标位置初始化
	MOV DX,0
	INT 0x10
	
	MOV AH,0x06				; 清除屏幕
	MOV BH,0x07					
	MOV AL,0
	mov CX,0   
    MOV DX,0xffff  
    mov BH,0x17				;属性为蓝底白字
	INT 0x10	
	
	;------------------
	;读取硬盘1-4扇区
	mov ebx,LOADER_SECTOR_LBA 	;LBA扇区号
	mov cx,LOADER_SECTOR_COUNT	;读取扇区数
	mov di,LOADER_BASE_ADDR		;写入内存地址
	call ReadDiskLBS16
	
	JMP LOADER_BASE_ADDR
	
; ------------------------------------------------------------------------
; 读取磁盘:ReadDiskLBS16
; 参数:
; ebx 扇区逻辑号
; cx 读入的扇区数,8位
; di 读取后的写入内存地址
; ------------------------------------------------------------------------	
ReadDiskLBS16:
	;设置读取的扇区数
	mov al,cl
	mov dx,0x1F2
	out dx,al
	
	;设置lba地址
	;设置低8位
	mov al,bl
	mov dx,0x1F3
	out dx,al
	
	;设置中8位
	shr ebx,8
	mov al,bl
	mov dx,0x1F4
	out dx,al
	
	;设置高8位
	shr ebx,8
	mov al,bl
	mov dx,0x1F5
	out dx,al
	
	;设置高4位和device
	shr ebx,8
	and bl,0x0F
	or bl,0xE0
	mov al,bl
	mov dx,0x1F6
	out dx,al
		
	;设置commond
	mov al,0x20
	mov dx,0x1F7
	out dx,al

.check_status:;检查磁盘状态
	nop
	in al,dx
	and al,0x88			;第4位为1表示硬盘准备好数据传输，第7位为1表示硬盘忙
	cmp al,0x08
	jnz .check_status   ;磁盘数据没准备好，继续循环检查
	

		
	;设置循环次数到cx
	mov ax,cx 			;乘法ax存放目标操作数
	mov dx,256
	mul dx
	mov cx,ax			;循环次数 = 扇区数 x 512 / 2 
	mov bx,di
	mov dx,0x1F0
	
.read_data: 				
	in ax,dx			;读取数据
	mov [bx],ax			;复制数据到内存
	add bx,2    		;读取完成，内存地址后移2个字节
	
	loop .read_data
	ret

		
	;填满扇区	
	times	510-($-$$) db  0 ; 处理当前行$至结束(1FE)的填充
	DB		0x55, 0xaa