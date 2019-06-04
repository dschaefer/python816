    .include "macros.asm"
    .include "types.asm"

*   = $0801
    .word (+)                   ; pointer to next line
    .word 10                    ; line number
    .byte $9e                   ; sys token
    .null format("%d", start)   ; start address
+   .word 0                     ; end of basic

hello
    .null "hello world!", $d

basic_stack
    .word 0
python_stack
    .word end_python_stack - 1

start
    ; enter native mode
    .cpunat
    .ax16
    .swapStacks basic_stack, python_stack
    phd
    tsc
    tcd

    ; print hello world
    ldx #hello
    jsr print

    ; back to emulation mode
    pld
    .swapStacks python_stack, basic_stack
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

    .include "ops.asm"
    .include "tests/doug.asm"

    .align $1000
start_python_stack
    .fill $1000
end_python_stack
