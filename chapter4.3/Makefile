


NASM=D:/opt/nasm/nasm.exe
QEMU=D:/opt/qemu/qemu-system-x86_64.exe
QEMU-IMG=D:/opt/qemu/qemu-img.exe
BOCHS=D:/opt/Bochs/bochsdbg.exe
BXIMAGE=D:/opt/Bochs/bximage.exe


boot=boot
build=build
	

target: prepare $(build)/ratsos.img
	$(BOCHS) -f bochsrc.me


$(build)/ratsos.img: $(build)/boot.bin $(build)/loader.bin
	$(BXIMAGE) -hd mode=flat -size=32 -q $(build)/ratsos.img 
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=1 seek=1 conv=notrunc

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$*.bin $(boot)/$*.asm	

prepare:
	#@echo "prepare dir $(build)"
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
