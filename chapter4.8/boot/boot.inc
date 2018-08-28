;---------------------------------------------------------
; 描述符
; usage: Gdt_Descriptor Base, Limit, Attr ：  段基址(32位),段界限(20位),段描述符(12位)
;        Base:  dd
;        Limit: dd (low 20 bits available)
;        Attr:  dw (lower 4 bits of higher byte are always 0)
;---------------------------------------------------------
%macro Gdt_Descriptor  3
dw %2 & 0xFFFF
dw %1 & 0xFFFF
db (%1 >> 16) & 0xFF
db %3 & 0xFF
db ((%3 >> 4 ) & 0xF0 ) | ((%2 >> 16) & 0x0F )
db (%1 >> 24) & 0xFF
%endmacro



;--------------   gdt描述符属性  -------------
DESC_G_4K   equ	  1000_0000_0000b   
DESC_D_32   equ	  0100_0000_0000b
DESC_L	    equ	  0000_0000_0000b	;  64位代码标记，此处标记为0便可。
DESC_AVL    equ	  0000_0000_0000b	;  cpu不用此位，暂置为0  
DESC_P	    equ	  0000_1000_0000b
DESC_DPL_0  equ	        000_0000b
DESC_DPL_1  equ	        010_0000b
DESC_DPL_2  equ	        100_0000b
DESC_DPL_3  equ	        110_0000b
DESC_S_CODE equ	          1_0000b
DESC_S_DATA equ	          1_0000b
DESC_S_SYS  equ		      0_0000b
DESC_TYPE_CODE  equ	        1010b	;x=1可执行代码段,c=0普通,r=1可读,a=0已访问位a清0  
DESC_TYPE_DATA  equ	        0010b	;x=0数据段,e=0向高位扩展,w=1可写,a=0已访问位a清0.


;--------------   选择子属性  ---------------
RPL0    equ   00b
RPL1    equ   01b
RPL2    equ   10b
RPL3    equ   11b
TI_GDT	equ   000b
TI_LDT	equ   100b

DESC_CODE equ  DESC_G_4K + DESC_D_32 + DESC_L + DESC_AVL + DESC_P + DESC_DPL_0 + DESC_S_CODE + DESC_TYPE_CODE 
DESC_DATA equ  DESC_G_4K + DESC_D_32 + DESC_L + DESC_AVL + DESC_P + DESC_DPL_0 + DESC_S_DATA + DESC_TYPE_DATA 

;----------- loader const ------------------
LOADER_SECTOR_LBA  		equ 0x1		;第2个逻辑扇区开始
LOADER_SECTOR_COUNT		equ 9		;读取9个扇区
LOADER_BASE_ADDR 		equ 0x9000  ;内存地址0x9000
LOADER1_BASE_ADDR 		equ 0x9800  ;内存地址0x9800
;-------------------------------------------


