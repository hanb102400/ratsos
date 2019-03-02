# tools
PLATFORM=Linux
NASM=nasm
BOCHS=bochs
BXIMAGE=bximage


# args
boot=boot
kernel=kernel
build=build
lib=lib
inc=inc

ENTRY_POINT =  0x70000
CFLAGS = -m32 -c  -fno-builtin -fno-stack-protector  # --Wall -W  fno-builtin -Wstrict-prototypes -Wmissing-prototypes 
LDFLAGS = -m elf_i386 -e _start  -Ttext $(ENTRY_POINT)  


target: prepare image  
	$(BOCHS) -f bochsrc.me

image:$(build)/ratsos.img
	@echo "complete build ratsos.img"

$(build)/ratsos.img: $(build)/boot.bin $(build)/loader.bin $(build)/kernel.bin
	$(BXIMAGE) -hd -mode=flat -size=32 -q $(build)/ratsos.img 
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=4 seek=1 conv=notrunc
	dd if=$(build)/kernel.bin of=$(build)/ratsos.img bs=512 count=25 seek=5 conv=notrunc

$(build)/kernel.bin: $(build)/main.o $(build)/lib/console.o  $(build)/lib/io.o $(build)/lib/interrupt.o $(build)/lib/keyboard.o
	$(LD) -o $(build)/kernel.bin  $(build)/main.o  $(build)/lib/console.o  $(build)/lib/io.o  $(build)/lib/interrupt.o  $(build)/lib/keyboard.o $(LDFLAGS) 
		
$(build)/main.o: $(kernel)/main.c
	$(CC) -o  $(build)/main.o  $(kernel)/main.c  $(CFLAGS) 

$(build)/lib/io.o: $(lib)/io.asm	
	$(NASM) -f elf -o $(build)/lib/io.o $(lib)/io.asm	

$(build)/lib/%.o: $(lib)/%.c 
	$(CC) -o  $(build)/lib/$*.o  $(lib)/$*.c $(CFLAGS) 

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$*.bin $(boot)/$*.asm	


prepare: 
	-mkdir -p $(build)
	-mkdir -p $(build)/lib
    

clean:
	@echo "clean dir $(build)"
	rm -rf $(build)/*
