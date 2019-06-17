    .include "../python.h.s"

    .export doug

print_name:
    newString "print"

hello_world_string:
    newString "hello world!"

    ; test code object
    ; print("hello world!")
doug:
    newCode :++ - :+, 0, :+++ - :++
:   ; consts
    .faraddr print_name
    .faraddr hello_world_string
:   ; code
    .byte OpCodes::load_name, 0     ; look up named function and push
    .byte OpCodes::load_const, 1    ; push const parameter
    .byte OpCodes::call_function, 1 ; call func with one parameter
    .byte OpCodes::pop_top          ; pop the result of the func
    .byte OpCodes::load_none        ; push none object
    .byte OpCodes::return_value     ; return it
:   ; end of code
