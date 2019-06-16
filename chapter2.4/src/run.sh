#!/bin/bash

NASM=nasm
QEMU=qemu-system-x86_64

$NASM -f bin -o ../ratsos.ima boot/boot.asm
cd .. && $QEMU -m 128 -rtc base=localtime -fda ratsos.ima