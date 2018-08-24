


## linux
ifeq ($(shell uname),Linux)
	PLATFORM="Linux"
	NASM=nasm
	QEMU=qemu-system-x86_64
	QEMU-IMG=qemu-img
	BOCHS=bochs
	BX-IMG=bximage
	CC=gcc
	LD=ld

endif

## windows
ifeq ($(OS),Windows_NT)
	PLATFORM="Windows"
	NASM=D:/opt/nasm/nasm.exe
	QEMU=D:/opt/qemu/qemu-system-x86_64.exe
	QEMU-IMG=D:/opt/qemu/qemu-img.exe
	CC=D:/opt/mingw/bin/gcc.exe
	LD=D:/opt/mingw/bin/ld.exe
	BOCHS=D:/opt/Bochs/bochsdbg.exe
	BX-IMG=D:/opt/Bochs/bximage.exe
endif

boot=boot
build=build
CFLAGS = -Wall -W -c -fno-builtin -Wstrict-prototypes -Wmissing-prototypes
ENTRY_POINT =  0x000010000

target: prepare $(build)/ratsos.img
	$(BOCHS) -f bochsrc.me

$(build)/ratsos.img: $(build)/boot.bin $(build)/loader.bin $(build)/kernel.bin
	$(BX-IMG) -mode=create -imgmode=flat -hd=32 -q $(build)/ratsos.img  &
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1 conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=1 seek=1 conv=notrunc
	dd if=$(build)/kernel.bin of=$(build)/ratsos.img  bs=512 count=24  seek=5 conv=notrunc


$(build)/kernel.bin: $(build)/main.o
	$(LD) -Ttext $(ENTRY_POINT) -e main $^ -o $@

$(build)/main.o: kernel/main.c
	$(CC) $(CFLAGS) kernel/main.c -o $(build)/main.o	

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$*.bin $(boot)/$*.asm	

prepare:
	@echo "prepare dir $(build)"
    ifeq ($(build), $(wildcard $(build)))
		@echo "build directory exist..."
    else
		mkdir -p $(build)
    endif

clean:
	@echo "clean dir $(build)"
	rm -rf $(build)/*

platform:
	@echo $(PLATFORM)
