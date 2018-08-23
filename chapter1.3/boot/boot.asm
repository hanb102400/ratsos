;Rats OS
;TAB=4
[BITs 16]
	ORG     0x7c00 			;指明程序的偏移的基地址

;引导扇区代码  
	JMP     Entry
	DB      0x90
	DB      "RATSBOOT"         

;程序核心内容
Entry:
	JMP Fin

;程序挂起
Fin:
	HLT                     ;让CPU重复挂起，等待指令。
	JMP Fin

FillSector:
	RESB    510-($-$$)      ;处理当前行$至结束(1FE)的填充
	DB      0x55, 0xaa