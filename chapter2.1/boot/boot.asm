;Rats OS
;TAB=4
[BITs 16]
    org     0x7c00 			;指明程序的偏移的基地址

;引导扇区代码  
    jmp     Entry
    db      0x90
    db      "RATSBOOT"         

;程序核心内容
Entry:
    
    jmp $				;进入死循环，不再往下执行。


FillSector:
    resb    510-($-$$)      ;处理当前行$至结束(1FE)的填充
    db      0x55, 0xaa
