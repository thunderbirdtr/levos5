levos5
======

LevOS5 - A UNIX-like kernel aiming for POSIX compliance.

Compilation
===========

You need:
* i586-elf GCC and binutils for x86 build.
* arm-elf GCC and binutils for ARM build.

Run 'make' to build the kernel for the x86 (default) architecture.

You can specify the architecture with 'make ARCH={arm,x86}'

Features
========

* Portability support
* TTY layer
* PS/2 keyboard driver
* Interrupt processing
* x86 support
* ARM support
* Liballoc
* Display abstraction


Portability support
===================

This layer allows LevOS5 to not actually depend on the architecture for various things. This is done by the makefile defining a $ARCH variable, on which the makefile will decide which object to link in. The 'include/hal.h' file has the methods that must be implemented by the specific $ARCH.

Each $ARCH has two hooks into the system initialization. arch_early_init() and arch_late_init().
arch_early_init() has to set the system in a state that memory can be used and the tty layer can be fired up. No output is available during this stage.
arch_late_init() has to set the system to a state where tasking can be started with the $ARCH specific timer.

TTY layer
=========

Buffered tty. TTYs are the top layer of LevOS5. Each tty can be connected to one display and only one tty can be active (accepting input, flushing output to underlying display) at a time. 

PS/2 keyboard driver
====================

A very simple buffered keyboard driver. Handles the IRQ and pushes the ASCII code to a FIFO buffer.

Interrupt processing
====================

Each $ARCH implements its own interrupt_ctl(int enable) method which allows for interrupt(or the alike) to be switched on and off. For example, on x86 this is done by the sti and cli instructions.

Each $ARCH must also implement its own register_interrupt(int intno, void(*f)()) which will register an interrupt handler. On X86, this is done by adding the field to the IDT.

x86 support
===========

This is the original architecture of LevOS5. Currently supports the GDT, IDT, and paging.
mm_{alloc, free}_pages are implemented with paging and bitmap handling.

ARM support
===========

This is a simple test that shows how easily LevOS5 can be ported. :-)

Check out arch/arm/* for details.

Liballoc
========

LevOS5 uses the public domain code of LibAlloc for malloc, realloc, calloc and free. These function are very accurate and extremely fast.

Display abstraction
===================

LevOS5 uses alot of layers for abstraction. First there is the display layer which will copy from the tty buffer and display the data stored in that tty buffer. The actual output is based on how the display handles the buffer of the tty. This way LevOS5 doesn't need to care about the actual display stuff, but rather write to the tty buffer and flush that if the display needs to be updated.
