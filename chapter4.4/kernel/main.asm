;ratsos
;TAB=4

%include "boot/boot.inc"

section loader vstart=LOADER1_BASE_ADDR ;指明程序的偏移的基地址

[bits 32]

    jmp Entry;   

;程序核心内容
Entry:

    mov byte [gs:0x00],'p'      ;输出字符
    mov byte [gs:0x01],0x17     ;设置颜色(背景色蓝，前景色白)
    mov byte [gs:0x02],'r'
    mov byte [gs:0x03],0x17
    mov byte [gs:0x04],'o'
    mov byte [gs:0x05],0x17
    mov byte [gs:0x06],'t'
    mov byte [gs:0x07],0x17
    mov byte [gs:0x08],'m'
    mov byte [gs:0x09],0x17
    mov byte [gs:0x0a],'o'
    mov byte [gs:0x0b],0x17
    mov byte [gs:0x0c],'d'
    mov byte [gs:0x0d],0x17
    mov byte [gs:0x0e],'e'
    mov byte [gs:0x0f],0x17
  

;程序挂起
Fin:
    hlt                     	;让CPU挂起，等待指令。
    jmp Fin
