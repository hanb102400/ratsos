


## linux
ifeq ($(shell uname),Linux)
	PLATFORM="Linux"
	NASM=nasm
	QEMU=qemu-system-x86_64
	QEMU-IMG=qemu-img
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
endif

boot=boot
build=build

target: prepare $(build)/ratsos.raw
	$(QEMU) -m 128  -localtime -hda $(build)/ratsos.raw

$(build)/ratsos.raw: $(build)/boot.bin $(build)/loader.bin $(build)/kernel.bin
	$(QEMU-IMG) create -f raw $(build)/ratsos.raw 128M
	dd bs=512 count=1 if=$(build)/boot.bin of=$(build)/ratsos.raw
	dd bs=512 count=1 if=$(build)/loader.bin of=$(build)/ratsos.raw seek=1
	dd bs=512 count=24 if=$(build)/kernel.bin of=$(build)/ratsos.raw seek=5


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
