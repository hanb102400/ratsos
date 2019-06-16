# tools
PLATFORM=Linux
NASM=nasm
BOCHS=bochs
BXIMAGE=bximage


# dirs
boot=boot
lib=lib
include=include
kernel=kernel
build=../build

# args
ENTRY_POINT =  0x70000
CFLAGS = -m32 -c  # --Wall -W  fno-builtin -Wstrict-prototypes -Wmissing-prototypes 
LDFLAGS = -m elf_i386 -e _start -Ttext $(ENTRY_POINT) 


target: prepare image
	@echo "start bochs"
	cd .. && $(BOCHS) -f bochsrc.me

image:$(build)/ratsos.img
	@echo "complete build image"

$(build)/ratsos.img: $(build)/$(boot)/boot.bin $(build)/$(boot)/loader.bin $(build)/$(kernel)/kernel.bin
	$(BXIMAGE) -mode=create  -hd=32M  -imgmode=flat  -q $(build)/ratsos.img 
	sleep 2
	dd if=$(build)/$(boot)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/$(boot)/loader.bin of=$(build)/ratsos.img bs=512 count=4 seek=1 conv=notrunc
	dd if=$(build)/$(kernel)/kernel.bin of=$(build)/ratsos.img bs=512 count=25 seek=5 conv=notrunc

$(build)/$(kernel)/kernel.bin: $(build)/$(kernel)/main.o  $(build)/$(lib)/io.o
	$(LD) -o $@  $^  $(LDFLAGS) 

$(build)/$(kernel)/%.o: $(kernel)/%.c
	$(CC) -o $(build)/$(kernel)/$*.o  $(kernel)/$*.c -I include $(CFLAGS) 

$(build)/$(lib)/io.o: $(lib)/io.asm	
	$(NASM) -f elf -o $(build)/lib/io.o $(lib)/io.asm

$(build)/$(boot)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$(boot)/$*.bin $(boot)/$*.asm	


prepare: 
	-mkdir -p $(build)
	-mkdir -p $(build)/$(boot)
	-mkdir -p $(build)/$(lib)
	-mkdir -p $(build)/$(kernel)


clean:
	@echo "clean dir $(build)"
	rm -rf $(build)/*
