# Summary #

This repo is a 'proof of concept' in writing macOS apps using NASM.

It is also an example in a guide on how to write such OSX executables. The guide itself is here (RU): http://txti.es/mac-nasm

## Files ##

- **build.sh** - script to build executable
- **seven.asm** - source program, it calulates *log(1+x / 1-x)* with series expansion and compares it with C standard logf(). Also does this whole thing for multiple x's
- **util.c** - little c file which contains some auxiliary functions
- **nasm** - assembler itself

## Usage ##
1. `$ ./build.sh`
2. `$ ./seven`
