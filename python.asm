    .cpu "65816"
    ; use petscii
    .enc "screen"
    ; explicitly set bank and dp mode
    .databank ?
    .dpage ?
    ; follow sep and rep's
    .autsiz

    .include "macros.asm"
    .include "types.asm"

*   = $000801
    .word (+)                   ; pointer to next line
    .word 10                    ; line number
    .byte $9e                   ; sys token
    .null format("%d", start)   ; start address
+   .word 0                     ; end of basic

basic_stack
    .word 0
python_stack
    .word (<>end_python_stack) - 1
curr_code
    .word 0
curr_ip
    .word 0

start
    ; enter native mode
    .cpunat
    .ax16
    phd
    .swapStacks basic_stack, python_stack

    ; set start up code object
    ; load the data bank register
    .a8
    lda #`doug
    pha
    plb
    .a16
    ; save the offset into the bank
    lda #<>doug
    sta curr_code
    ; find the first instruction
    ; curr_ip = curr_code + #obj_code.consts + curr_code->consts_size
    tay
    clc
    adc #obj_code.consts
    adc obj_code.consts_size, b, y
    sta curr_ip

    ; back to emulation mode
    .swapStacks python_stack, basic_stack
    pld
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
