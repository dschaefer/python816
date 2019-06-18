    .include "python.h.s"
    .export run_code

; ops table, must match list of ops in OpCode enum
ops_table:
    .addr op_load_const
    .addr op_load_name
    .addr op_load_none
    .addr op_call_function
    .addr op_pop_top
    .addr op_return_value

.struct Frame
    ; address in current bank of next instruction
    ip      .addr
    ; address in current bank of consts
    consts  .addr
    ; offset in dp of the result
    result  .word
    ; scratch area
    scratch .word
    ; size of locals area
    locals  .word
.endstruct

; space used by saved registers
.struct SavedRegs
    _rts .word
    _phd .word
.endstruct

; run_code - data bank, X has address of code object, A has num args
run_code:
    ; save num args in Y
    tay
    ; set up stack
    phd
    ; allocate space for locals
    sec
    tsa
    sbc a:Code::locals_size, x
    tas
    ; save the size of the locals area
    lda a:Code::locals_size, x
    pha
    ; scratch area, store num args there
    phy
    ; push dp offset of arg space, will be incr'ed later for return value
    clc
    lda #.sizeof(Frame) + .sizeof(SavedRegs)
    adc a:Code::locals_size, x
    pha
    ; pointer to consts (near)
    clc
    txa
    adc #Code::consts
    pha
    ; instruction pointer, first byte after consts
    adc a:Code::consts_size, x
    pha
    ; set dp to current stack plus one
    tsa
    inc a
    tad
    ; no go back and add args space to result pointer
    mult3 Frame::scratch
    adc Frame::result
    sta Frame::result
    ; and off we go
next_instr:
    ; run next instruction
    a8
    lda (Frame::ip)
    inc Frame::ip
    a16

    ; jump into the jump table
    asl
    tax
    jmp (ops_table, x)

; the return_value op will do the rts
op_return_value:
    ; pop off the frame
    tsa
    clc
    adc #.sizeof(Frame)
    adc Frame::locals
    tas
    pld
    rts

op_load_const:
    inc Frame::ip
    jmp next_instr

op_load_name:
    inc Frame::ip
    jmp next_instr

op_load_none:
    jmp next_instr

op_call_function:
    inc Frame::ip
    jmp next_instr

op_pop_top:
    jmp next_instr
