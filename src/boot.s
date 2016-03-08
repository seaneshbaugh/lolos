        .set ALIGN,    1<<0
        .set MEMINFO,  1<<1
        .set FLAGS,    ALIGN | MEMINFO
        .set MAGIC,    0x1BADB002
        .set CHECKSUM, -(MAGIC + FLAGS)

        .section .multiboot
        .align 4
        .long MAGIC
        .long FLAGS
        .long CHECKSUM

        .section .bootstrap_stack, "aw", @nobits
stack_bottom:
        .skip 16384
stack_top:

        .section .text

        .globl   real_rand
        .align  4, 0x90
real_rand:
        pushl   %ebp

        movl    $-1, %esi
        subl    %edi, %esi
reroll:
        rdrand  %ecx

        cmp     %esi, %ecx
        jge     reroll
        cmp     %edi, %ecx
        jge     reroll

        xorl    %edx, %edx
        movl    %ecx, %eax
        movl    $16, %edi
        divl    %edi
        movl    %edx, %eax

        popl    %ebp
        retl

        .global _start
        .type _start, @function
_start:
        movl    $stack_top, %esp

        call    kernel_main

        cli
        hlt

.Lhang:
        jmp .Lhang

        .size _start, . - _start
