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
    ; B, X = pointer to string
    pha
    phy
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
    ; put things back and return
    .a16
    ply
    pla
    rts
    .pend
