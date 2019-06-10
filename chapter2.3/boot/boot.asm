; RatsOS
[bits 16]

    org     0x7c00          ; 指明程序的偏移的基地址

     ; boot程序
    jmp     Entry

; 程序核心内容
Entry:
    mov ax,0xb800
    mov gs,ax               				  ; 显存段地址
    mov byte [gs:0x00],'r'  		; 输出字符
    mov byte [gs:0x01],0x74    ; 设置颜色(背景色蓝，前景色白)
    mov byte [gs:0x02],'a'
    mov byte [gs:0x03],0x74
    mov byte [gs:0x04],'t'
    mov byte [gs:0x05],0x74
    mov byte [gs:0x06],'s'
    mov byte [gs:0x07],0x74
    mov byte [gs:0x08],'o'
    mov byte [gs:0x09],0x74
    mov byte [gs:0x0a],'s'
    mov byte [gs:0x0b],0x74

    jmp $                   ; 进入死循环，不再往下执行。

Fill_Sector:
    resb    510-($-$$)      ; 处理当前行$至结束(1FE)的填充
    db      0x55, 0xaa

