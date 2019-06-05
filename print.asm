print .proc
    ; B, X = pointer to string
    pha
    phy
    ; save and set dp to 0
    phd
    lda #0
    tcd
    ; need to use basic stack for kernel call
    .swapStacks python_stack, basic_stack
    .a8
loop
    lda $0, b, x
    beq done
    ; prepare for kernel call
    phx
    phb
    .x8
    ; set bank to zero
    ldy #0
    phy
    plb
    ; call the kernel
    .cpuemu
    jsr $FFD2 ; chrout
    .cpunat
    ; put the bank back
    .x16
    plb
    plx
    ; next character
    inx
    bra loop
done
    .a16
    .swapStacks basic_stack, python_stack
    pld
    ply
    pla
    rts
    .pend
