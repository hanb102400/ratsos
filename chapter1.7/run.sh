#!/bin/bash

NASM=/D/opt/nasm/nasm.exe
mkdir build
$NASM -f bin -o build/ratsos.img boot/boot.asm

