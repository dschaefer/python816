    .p816
    .smart
    .include "python.h.s"

    .import doug
    .import run_code

start:
    cpunat
    ai16
    swapStacks basic_stack, python_stack
    phd

    ; call the doug test code
    ldbx doug
    jsr run_code

    pld
    swapStacks python_stack, basic_stack
    cpuemu
    rts

basic_stack:
    .word 0

python_stack:
    .word $7fff
