; RatsOS
[bits 16]



org     0x7c00                      ; 指明程序的偏移的基地址

; ----------- loader const ------------------
CONST_SECTOR_NUM		equ 18            ; 读取18个扇区
LOADER_SECTOR_CHS 		equ 0x1         ; 第2个逻辑扇区开始
LOADER_CYLINDER_NUM		equ 10         ; 读取10个柱面
LOADER_BASE_ADDR 		equ 0x9000       ; 内存地址0x9000
; -------------------------------------------

                                    ; 启动程序
jmp     Entry
db      0x90
db      "RATSBOOT"                  ; 启动区的名称可以是任意的字符串（8字节）

                                    ; 程序核心内容
Entry:

    ; ------------------
    ; 初始化寄存器
    mov ax,0
    mov ss,AX
    mov ds,AX
    mov es,AX
    mov sp,0x7c00

    ; ---------------------------
    ; 清除屏幕
    mov ah,0x06
    mov al,0
    mov cx,0
    mov dx,0xffff
    mov bh,0x17                     ; 属性为蓝底白字
    int 0x10

    ; ---------------------------
    ; 光标位置初始化
    mov ah,0x02
    mov dx,0
    mov bh,0
    mov dh,0x0
    mov dl,0x0
    int 0x10

    ; ---------------------------
    ; 输出字符串
    mov  di,BootMsg                 ; 将BootMsg的地址放入di
    mov  dh,0                       ; 设置显示行
    call PutString                  ; 调用函数


                                    ; ---------------------------
                                    ; 读取磁盘
    mov	ax,LOADER_BASE_ADDR/0x10    ; 设置磁盘读取的缓冲区基本地址为ES=0x820。[ES:BX]=ES*0x10+BX
    mov	es,ax                       ; BIOS中断参数：ES:BX＝缓冲区的地址

    mov	ch,0                        ; 设置柱面为0
    mov	dh,0                        ; 设置磁头为0
    mov	cl,1                        ; 设置扇区为2

ReadSectorLoop:
    call ReadDiskSector             ; ;读取一个扇区

                                    ; 准备下一个扇区
    .readNext:
        mov	ax,es
        add	ax,0x0020
        mov	es,ax                   ; 内存单元基址后移0x20(512字节)。[ES+0x20:]
        add	cl,1                    ; 读取扇区数递增+1
        cmp	cl,CONST_SECTOR_NUM     ; 判断是否读取到18扇区
        jbe	ReadSectorLoop          ; 上面cmp判断(<=)结果为true则跳转到DisplayError

                                    ; 读取另一面磁头。循环读取柱面
        mov	cl,1                    ; 设置柱面为0
        add	dh,1                    ; 设置磁头递增+1:读取下一个磁头
        cmp	dh,2                    ; 判断磁头是否读取完毕
        jb	ReadSectorLoop           ; 上面cmp判断(<)结果为true则跳转到DisplayError

        mov	dh,0                    ; 设置磁头为0
        add	ch,1                    ; 设置柱面递增+1;读取下一柱面
        cmp	ch,LOADER_CYLINDER_NUM  ; 判断是否已经读取10个柱面
        jb	.readFin                 ; 上面cmp判断(<)结果为true则跳转到DisplayError
        jmp .readNext

        ; 读取错误
    .readFin:
            mov di,SuccessMsg
            mov dh,3
            call PutString          ; 如果加载失败显示加载错误
            ret


            ; ------------------------------------------------------------------------
            ; 读取一个扇区函数:ReadDiskSector
            ; 参数:
            ; es:bx = 缓冲区地址，
            ; ch = 柱面
            ; dh = 磁头
            ; cl = 扇区
            ; ------------------------------------------------------------------------
ReadDiskSector:
    mov	si,0                        ; 初始化读取失败次数，用于循环计数

                                    ; 为了防止读取错误，循环读取5次
                                    ; 调用BIOS读取一个扇区
    .readFiveLoop:
            mov	ah,0x02             ; BIOS中断参数：读扇区
            mov	al,1                ; BIOS中断参数：读取扇区数
            mov	bx,0
            mov	dl,0x00             ; BIOS中断参数：设置读取驱动器为软盘
            int	0x13                ; 调用BIOS中断操作磁盘：读取扇区
            jnc	.readEnd            ; 条件跳转，操作成功进位标志=0。则跳转执行ReadNextSector

            add	si,1                ; 循环读取次数递增+1
            cmp	si,5                ; 判断是否已经读取超过5次
            jae	.readError          ; 上面cmp判断(>=)结果为true则跳转到readError

            mov	ah,0x00             ; BIOS中断参数：磁盘系统复位
            mov	dl,0x00             ; BIOS中断参数：设置读取驱动器为软盘
            int	0x13                ; 调用BIOS中断操作磁盘：磁盘系统复位
            jmp	.readFiveLoop

            ; 读取错误
    .readEnd:
            ret

            ; 读取错误
    .readError:
            mov di,ErrorMsg
            mov dh,3
            call PutString          ; 如果加载失败显示加载错误
            ret

            ; ------------------------------------------------------------------------
            ; 显示字符串函数:PutString
            ; 参数:
            ; si = 字符串开始地址,
            ; dh = 第N行，0开始
            ; dl = 第N列，0开始
            ; ------------------------------------------------------------------------
PutString:
            mov cx,0                ; BIOS中断参数：显示字符串长度
            mov bx,si
    .s1:                            ; 获取字符串长度
            mov al,[bx]             ; 读取1个字节到al
            add bx,1                ; 读取下个字节
            cmp al,0                ; 是否以0结束
            je .s2
            add	cx,1                ; 计数器
            jmp .s1
    .s2:                            ; 显示字符串
            mov bx,si
            mov bp,bx
            mov ax,ds
            mov es,ax               ; BIOS中断参数：计算[ES:BP]为显示字符串开始地址

            mov ah,0x13             ; BIOS中断参数：显示文字串
            mov al,0x01             ; BIOS中断参数：文本输出方式(40×25 16色 文本)
            mov bh,0x0              ; BIOS中断参数：指定分页为0
            mov bl,0x1F             ; BIOS中断参数：指定白色文字
            mov dl,0                ; 列号为0
            int 0x10                ; 调用BIOS中断操作显卡。输出字符串
            ret
            ; ------------------------------------------------------------------------
            ; 准备显示字符串
BootMsg: 	db 	"ratsos is booting!",0
SuccessMsg: db	"load disk Sector success",0
ErrorMsg: 	db  "load disk Sector error",0

; 扇区格式
Fill0:
    resb    510-($-$$)              ; 处理当前行$至结束(1FE)填充0
    db      0x55, 0xaa
