; 
op .segment code
    ops_i :?= 0
    op_\code = ops_i
    ops_i += 1
    ops_list :?= []
    ops_list := ops_list .. [imp_\code]
    .endm

    .op load_const
    .op load_none
    .op call_function
    .op pop_top
    .op return_value

ops_table .word ops_list

imp_load_const
    ; load const number
    ; figure out const address
    ; push address
    jmp next_instr

imp_load_none
    jmp next_instr

imp_call_function
    jmp next_instr

imp_pop_top
    jmp next_instr

imp_return_value
    jmp next_instr
