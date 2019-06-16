#!/bin/bash


NASM=nasm

$NASM -f bin -o ../boot.bin boot/boot.asm
dd if=/dev/zero of=../ratsos.ima bs=512 count=2880
dd if=../boot.bin  of=../ratsos.ima bs=512 count=1  conv=notrunc
