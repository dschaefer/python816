    .include "python.h.s"

    .import doug
    .import run_code

start:
    cpunat
    ai16
    swapStacks basic_stack, python_stack
    phd

    ; call the doug test code with no args
    ldbx doug
    lda #0
    jsr run_code

    pld
    swapStacks python_stack, basic_stack
    cpuemu
    rts

basic_stack:
    .word 0

python_stack:
    .word $7fff
