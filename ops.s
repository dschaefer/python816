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

; run_code - data bank, X has address of code object
run_code:
    ; set up stack
next_instr:
    ; run next instruction
    ; the return_value op will do the rts

op_load_const:
    jmp next_instr

op_load_name:
    jmp next_instr

op_load_none:
    jmp next_instr

op_call_function:
    jmp next_instr

op_pop_top:
    jmp next_instr

op_return_value:
    rts
