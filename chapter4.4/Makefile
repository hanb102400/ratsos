
# tools
NASM=nasm
QEMU=qemu-system-x86_64
QEMU-IMG=qemu-img
BOCHS=bochs
BXIMAGE=bximage


# args
boot=boot
kernel=kernel
build=build
	

target: prepare image
	$(BOCHS) -f bochsrc.me


image: $(build)/boot.bin $(build)/loader.bin $(build)/kernel.bin
	$(BXIMAGE) -hd -mode=flat -size=32m -q $(build)/ratsos.img 
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=4 seek=1 conv=notrunc
	dd if=$(build)/kernel.bin of=$(build)/ratsos.img bs=512 count=25 seek=5 conv=notrunc


$(build)/kernel.bin: $(kernel)/main.asm
	$(NASM) -f bin -o $(build)/kernel.bin $(kernel)/main.asm	

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
