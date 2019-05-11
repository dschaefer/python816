

;   op codes
opcode_table:
    !set opcode_enum = 0
    +enum ~opcode_enum, ~opcode_load
    !word opcode_impl_load
    +enum ~opcode_enum, ~opcode_call_function
    !word opcode_impl_call_function

    ; lower 7 bits are the object op
    opcode_op = %10000000
