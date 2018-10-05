









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