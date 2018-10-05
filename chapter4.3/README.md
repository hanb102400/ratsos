## 刷新流水线



```
[bits 16]
	;------------------
	;打开A20
    in al,0x92
    or al,0000_0010B        ;设置第1位为1
    out 0x92,al
	
	;-----------------------------------------------
	;加载GDT
	lgdt [gdt_addr]
	
	;------------------
    ;进入保护模式
    mov eax,CR0
    or  eax,0x00000001      ; 设置第0位为1
    mov CR0,eax
	
	
	jmp	 dword   1000B:Pipeflush  

[bits 32]
;------------------    
;清空流水线
Pipeflush:
		mov		ax,1*8			;  可读写的32bit
		mov		ds,ax
		mov		es,ax
		mov		fs,ax
		mov		gs,ax

```

### 文件位置

boot.bin  扇区0
loader.bin 扇区1-4

### 内存信息

0x7c00 boot.bin
0x9000 loader.bin
0x9800 loader1.bin


### GDT信息
GDT[0x00]=Data segment, base=0x00000000, limit=0xffffffff, Read/Write
GDT[0x01]=Code segment, base=0x00280000, limit=0x0007ffff, Execute/Read, Non-Con