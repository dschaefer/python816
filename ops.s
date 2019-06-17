    .include "python.h.s"
    .export ops_table

; ops table, must match list of ops in OpCode enum
ops_table:
    .addr op_load_const
    .addr op_load_name
    .addr op_load_none
    .addr op_call_function
    .addr op_pop_top
    .addr op_return_value

op_load_const:
    rts

op_load_name:
    rts

op_load_none:
    rts

op_call_function:
    rts

op_pop_top:
    rts

op_return_value:
    rts
