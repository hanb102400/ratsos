



NASM=nasm
BOCHS=bochs
BXIMAGE=bximage

boot=boot
kernel=kernel
build=../build

target: prepare image
	cd .. && $(BOCHS) -f bochsrc.me

image: $(build)/ratsos.img

$(build)/ratsos.img: $(build)/boot.bin $(build)/loader.bin $(build)/kernel.bin
	$(BXIMAGE) -mode=create  -hd=32M  -imgmode=flat  -q $(build)/ratsos.img 
	sleep 2
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc
	dd if=$(build)/loader.bin of=$(build)/ratsos.img bs=512 count=1 seek=1 conv=notrunc
	dd if=$(build)/kernel.bin of=$(build)/ratsos.img bs=512 count=25 seek=5 conv=notrunc

$(build)/kernel.bin: $(kernel)/main.asm
	$(NASM) -f bin -o $(build)/kernel.bin $(kernel)/main.asm

$(build)/%.bin: $(boot)/%.asm
	$(NASM) -f bin -o $(build)/$*.bin $(boot)/$*.asm	

prepare:
	-mkdir -p $(build)

clean:
	@echo "clean dir $(build)"
	rm -rf $(build)/*


	

