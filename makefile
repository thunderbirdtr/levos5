OBJS := main.o start.o

ARCH=x86

CC=i586-elf-gcc
AS=i586-elf-as
CFLAGS=-D_ARCH__$(ARCH)__ -Iinclude -std=gnu99 -ffreestanding -O2 -Wall -Wextra

.PHONY: start all

all: start

start.o: start.s
	@$(AS) -c $< -o $@
	@echo AS $@

include mm/makefile
include tty/makefile
include lib/makefile
include display/makefile
include drivers/makefile
include arch/$(ARCH)/makefile

kernel.img: $(OBJS)
	@i586-elf-gcc -T linker.ld -o kernel.img -ffreestanding -O2 -nostdlib $(OBJS)  -lgcc
	@echo LD $@

start: kernel.img
	qemu-system-i386 -kernel kernel.img

%.o: %.c
	@$(CC) -c $(CFLAGS) $< -o $@
	@echo CC $@

clean:
	rm $(OBJS)
