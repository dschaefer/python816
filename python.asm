    .include "macros.asm"

*   = $0801
    .word (+)                   ; pointer to next line
    .word 10                    ; line number
    .byte $9e                   ; sys token
    .null format("%d", start)   ; start address
+   .word 0                     ; end of basic

hello
    .null "hello world!", $d

basicStack
    .word 0
pythonStack
    .word $7fff

start
    ; enter native mode
    .cpunat
    .ax16
    .swapStacks basicStack, pythonStack
    phd
    lda #directPage
    tcd

    ; print hello world
    ldx #hello
    jsr print

    ; back to emulation mode
    pld
    .swapStacks pythonStack, basicStack
    .ax8
    .cpuemu
    rts
    ; tell the assember to go back to 16-bit
    .al
    .xl

print .proc
    ; B, X = pointer to string
    pha
    phy
    ; save and set dp to 0
    phd
    lda #0
    tcd
    ; need to use basic stack for kernel call
    .swapStacks pythonStack, basicStack
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
    .swapStacks basicStack, pythonStack
    pld
    ply
    pla
    rts
    .pend

    .align $100
directPage

entry .segment
    \1_i :?= 0
    \1 :?= []
    \2 = \1_i
    \1_i += 1
    \1 := \1 .. [\3]
    .endm

    .entry ops, op_a1, a1
    .entry ops, op_b1, b1
    .entry ops, op_c1, c1

table: .word ops

a1:
    lda #op_a1
    rts

b1:
    lda #op_b1
    rts

c1:
    lda #op_c1
    rts
