

# tools
NASM=nasm
QEMU=qemu-system-x86_64

# args
boot=boot
build=build

target: prepare image
	$(QEMU) -m 128  -localtime -fda $(build)/ratsos.img

image:  $(build)/ratsos.img
	

$(build)/ratsos.img:
	$(NASM) -f bin -o  $(build)/ratsos.img $(boot)/boot.asm

prepare:
    ifeq ($(build), $(wildcard $(build)))
		@echo "build directory exist..."
    else
		mkdir -p $(build)
    endif

clean:
	rm -rf $(build)/*


