    .include "../macros.h.s"
    .include "../python.h.s"

:   newString "print"
:   newString "hello world!"

doug:
    newCode :++ - :+, 0, :+++ - :++
:   ; consts
    .faraddr :---
    .faraddr :--
:   ; code
    .byte OpCodes::load_const, 0
    .byte OpCodes::load_const, 1
    .byte OpCodes::call_function, 1
    .byte OpCodes::pop_top
    .byte OpCodes::load_none
    .byte OpCodes::return_value
:   ; end of code
