    .p816
    .smart
    .include "macros.h.s"

    .import doug
    .import ops_table

start:
    cpunat
    ai16
    swapStacks basic_stack, python_stack
    phd

    ; TODO stuff
    lda #ops_table
    ldx #doug

    pld
    swapStacks python_stack, basic_stack
    cpuemu
    rts

basic_stack:
    .word 0

python_stack:
    .word $7fff
