;Rats OS
;Tab=4
[bits 16]

%include "boot/boot.inc"

    org     0x7c00 				;指明程序的偏移的基地址

;引导扇区代码 
    jmp     Entry
    db      0x90
    db      "RATSBOOT"     		;启动区的名称可以是任意的字符串（8字节）    

;程序核心内容
Entry:

    ;------------------
    ;初始化寄存器
    mov ax,0				
    mov ss,ax
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov fs,ax
    mov gs,ax
    mov sp,0x7c00

    ;------------------
    ;清屏
    mov ah,0x06				;清除屏幕					
    mov al,0
    mov cx,0   
    mov dx,0xffff  
    mov bh,0x17				;属性为蓝底白字
    int 0x10
    

    mov ah,0x02				;光标位置初始化
    mov dx,0
    mov bh,0
    mov dh,0x0
    mov dl,0x0
    int 0x10

    ;------------------
    ;读取硬盘1-10扇区
    mov ebx,LOADER_SECTOR_LBA 		;LBA扇区号
    mov cx,LOADER_SECTOR_COUNT		;读取扇区数
    mov di,LOADER_BASE_ADDR			;写入内存地址
    call Func_ReadLBA16
    
    jmp LOADER_BASE_ADDR

; ------------------------------------------------------------------------
; 读取磁盘:Func_ReadLBA16
; 参数:
; ebx 扇区逻辑号
; cx 读入的扇区数,8位
; di 读取后的写入内存地址
; ------------------------------------------------------------------------	
Func_ReadLBA16:
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


FillSector:
    resb    510-($-$$)       	;处理当前行$至结束(1FE)的填充
    db      0x55, 0xaa