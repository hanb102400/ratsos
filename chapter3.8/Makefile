


# tools
PLATFORM=Linux
NASM=nasm
QEMU=qemu-system-x86_64
QEMU-IMG=qemu-img
BOCHS=bochs
BX-IMG=bximage


# args
boot=boot
build=build
	

target: prepare img  
	$(BOCHS) -f bochsrc.me


img: $(build)/ratsos.img	
	@echo "build img completed"

$(build)/ratsos.img:$(build)/boot.bin $(build)/loader.bin 
	$(BX-IMG) -hd -mode=flat -size=32 -q $(build)/ratsos.img
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=1 seek=1 conv=notrunc

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$*.bin $(boot)/$*.asm	

prepare: $(build)
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
