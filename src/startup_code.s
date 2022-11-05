    .cpu cortex-m3
    .fpu softvfp
    .syntax unified
    .thumb
    .extern _stack_pointer
    .extern main
    .extern ivh_default
    .extern ivh_reset
    .section .vector_table, "a"
    .word _stack_pointer
    .word ivh_reset
    .rept 83
        .word ivh_default
    .endr
    .end

