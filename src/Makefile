PREFIX=$(HOME)/opt/gcc-5.2.0

TARGET=i686-elf

AS=$(TARGET)-as

CC=$(TARGET)-gcc

CXX=$(TARGEG)-g++

CPP=$(TARGET)-cpp

LD=$(TARGET)-ld

all: clean boot kernel link copy

boot:
	export PATH=$(PREFIX)/bin:$$PATH; $(AS) boot.s -o boot.o

kernel:
	export PATH=$(PREFIX)/bin:$$PATH; $(CC) -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

link:
	export PATH=$(PREFIX)/bin:$$PATH; $(CC) -T linker.ld -o os.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

copy:
	cp os.bin iso/boot

clean:
	rm boot.o kernel.o os.bin
