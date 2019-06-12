    .cpu "65816"
    ; use petscii
    .enc "screen"
    ; explicitly set bank and dp mode
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

start
    ; enter native mode
    .cpunat
    .ax16
    phd
    .swapStacks basic_stack, python_stack

    ; run our example code
    ; data bank
    .a8
    lda #`doug
    pha
    plb
    .a16
    ; code address in X
    ldx #<>doug
    ; and go
    jsr run_code

    ; back to emulation mode
    .swapStacks python_stack, basic_stack
    pld
    .ax8
    .cpuemu
    rts
    ; tell the assember to go back to 16-bit
    .al
    .xl

frame_code .struct
ip      .word ?
code    .word ?
locals
        .ends

    ; run_code - X, b = address of code
run_code
    ; save current SP in Y
    tsc
    tay
    ; space for args
    tsc
    sec
    sbc obj_code.locals_size, x
    tcs
    ; save the code address
    phx
    ; set up IP = code + &code->consts + code->consts_size
    clc
    adc #obj_code.consts
    .a8
    adc obj_code.consts_size, x
    .a16
    pha
    ; set up frame pointer (DP) and save stack (in Y)
    tsc
    phy
    phd
    inc a
    tcd

foo
next_instr
    ldx frame_code.ip, d
    cpx #op_return_value
    beq +
    jmp (foo, x)

+
    ; pop off the stack
    pld
    pla
    tcs
    rts

    .include "ops.asm"
    .include "print.asm"
    .include "tests/doug.asm"

    .align $1000
start_python_stack
    .fill $1000
end_python_stack
