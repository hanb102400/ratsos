; RatsOS
[bits 16]

    org     0x7c00      ; 指明程序的偏移的基地址

    ; 引导扇区代码
    jmp     Entry
    db      0x90
    db      "RATSBOOT"

; 程序核心内容
Entry:
    jmp $               ; 让CPU挂起，等待指令。

                        ; 扇区格式
Fill0:
    resb    510-($-$$)  ; 处理当前行$至结束(1FE)填充0
    db      0x55, 0xaa
