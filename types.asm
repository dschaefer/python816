; Object types for Python

types       .struct
free        .byte ?
int16       .byte ?
string      .byte ?
            .ends

obj_header  .struct type
type        .byte \type
refcount    .byte 0
            .ends

obj_int16   .struct value
            .dstruct obj_header, types.int16
value       .word \value
            .ends

obj_string  .struct value
            .dstruct obj_header, types.string
sz          .word size(value)
value       .null \value
            .ends
