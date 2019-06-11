#!/bin/bash

NASM=nasm
CC=cc
LD=ld

ENTRY_POINT=0x70000
CFLAGS="-m32 -c"
LDFLAGS="-m elf_i386 -e _start -Ttext $ENTRY_POINT"

$CC main.c -o main.o $CFLAGS
$LD main.o -o kernel.bin $LDFLAGS


	