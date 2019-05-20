    .include "macros.asm"

*   = $0801
    .word (+)                   ; pointer to next line
    .word 10                    ; line number
    .byte $9e                   ; sys token
    .null format("%d", start)   ; start address
+   .word 0                     ; end of basic

hello
    .null "hello world!", $d

start
    .cpunat
    .a16x16

    ldx #hello
    jsr print

    .a8x8
    .cpuemu
    rts

print .proc
    ; X = pointer to string
    .a8
loop
    lda $0, b, x
    beq done
    ; prepare for kernel call
    phx
    phb
    .x8
    ldy #0
    phy
    plb ; set bank to zero
    .cpuemu
    jsr $FFD2 ; chrout
    .cpunat
    .x16
    plb
    plx
    inx
    bra loop
done
    .a16
    rts
    .pend
