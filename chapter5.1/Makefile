
## linux
ifeq ($(shell uname),Linux)
	PLATFORM="Linux"
	NASM=nasm
	BOCHS=bochs
	BX-IMG=bximage
	CC=gcc
	LD=ld
endif

## windows
ifeq ($(OS),Windows_NT)
	PLATFORM="Windows"
	NASM=D:/opt/nasm/nasm.exe
	BOCHS=D:/opt/Bochs/bochsdbg.exe
	BX-IMG=D:/opt/Bochs/bximage.exe
	CC=D:/opt/mingw/bin/gcc.exe
	LD=D:/opt/mingw/bin/ld.exe
endif

CFLAGS = -Wall -W -c -fno-builtin -Wstrict-prototypes -Wmissing-prototypes
ENTRY_POINT =  0x00009800
boot=boot
build=build

target: prepare $(build)/ratsos.img
	$(BOCHS) -f bochsrc.me

$(build)/ratsos.img: $(build)/boot.bin $(build)/loader.bin $(build)/loader1.bin
	$(BX-IMG) -mode=create -imgmode=flat -hd=32 -q $(build)/ratsos.img  &
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=4 seek=1 conv=notrunc
	dd if=$(build)/loader1.bin of=$(build)/ratsos.img  bs=512 count=5 seek=5  conv=notrunc

#$(build)/loader1.bin: $(build)/loader1.o
#	$(LD) -Ttext $(ENTRY_POINT) -e $(build)/loader1 $^ -o $@

#$(build)/loader1.o: $(boot)/loader1.c
#	$(CC) $(CFLAGS) $(boot)/loader1.c -o $(build)/loader1.o    

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin $(boot)/$*.asm -o $(build)/$*.bin   

prepare:
	- mkdir -p $(build)
	#ifeq ($(build), $(wildcard $(build)))
	#	@echo "build directory exist..."
	#else
	#	mkdir -p $(build)
	#endif

clean:
	@echo "clean dir $(build)"
	rm -rf $(build)/*

platform:
	@echo $(PLATFORM)
