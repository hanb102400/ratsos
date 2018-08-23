#!/bin/bash

NASM=/D/opt/nasm/nasm.exe
mkdir build
$NASM -f bin -o build/icyos.img boot/boot.asm

