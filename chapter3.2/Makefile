

NASM=nasm
BOCHS=bochs
BXIMAGE=bximage


boot=boot
build=build
	

target: prepare image
	$(BOCHS) -f bochsrc.me


image: $(build)/boot.bin 
	$(BXIMAGE) -mode=create -imgmode=flat -hd=32 -q $(build)/ratsos.img  &
	sleep 1
	dd if=$(build)/boot.bin of=$(build)/ratsos.img bs=512 count=1  conv=notrunc

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
