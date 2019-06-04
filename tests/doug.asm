-   .obj_string "print"
-   .obj_string "hello world!"

doug .obj_code (+) - doug, 2, 0
    ; consts
    .long --
    .long -
    ; code
    .byte op_load_const, 0
    .byte op_load_const, 1
    .byte op_call_function, 1
    .byte op_pop_top
    .byte op_load_none
    .byte op_return_value
+
