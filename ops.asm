; 
op .segment code
    ops_i :?= 0
    op_\code = ops_i
    ops_i += 1
    ops_list :?= []
    ops_list := ops_list .. [imp_\code]
    .endm

    .op load_const

ops_table .word ops_list

next_instr
    ; load next bytecode
    ; i = mult by 2
    ; jmp ops_table[i]
    rts

imp_load_const
    ; load const number
    ; figure out const address
    ; push address
    jmp next_instr
