#!/bin/bash


nasm seven.asm -fmacho -w+all --prefix _ -l delete_me.txt
clang -c -arch i386 util.c
ld -o seven -arch i386 seven.o util.o -macosx_version_min 10.7 -lc -e _start -no_pie