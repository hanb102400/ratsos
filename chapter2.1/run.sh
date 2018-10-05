#!/bin/bash

NASM=nasm
QEMU=qemu-system-x86_64
mkdir build
$NASM -f bin -o build/ratsos.img boot/boot.asm
$QEMU -m 128 -rtc base=localtime -fda build/ratsos.img
