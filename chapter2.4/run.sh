#!/bin/bash

NASM=/D/opt/nasm/nasm.exe
QEMU=/D/opt/qemu/qemu-system-x86_64.exe

mkdir build
$NASM -f bin -o build/ratsos.img boot/boot.asm
$QEMU -m 128 -rtc base=localtime -fda build/ratsos.img


	


