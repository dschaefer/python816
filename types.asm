; Object types for Python

; enum of types (funny as a struct but it works)
types       .struct
free        .byte ?
int16       .byte ?
string      .byte ?
dict        .byte ?
code        .byte ?
builtin     .byte ?
            .ends

; standard object header
obj_header  .struct type, size = 6
type        .byte \type
refcount    .byte 0
size        .word \size
            .ends

; free object
; minimum size is 6 (which also makes min object size 6)
; the size is also put in the last word for reclaimation
; which also means the size needs to be the last field in
; the min size object so we can't use the header
; TODO which also means we can't have free size of 7...
obj_free    .struct next, size = 6
type        .byte types.free
refcount    .byte 0
next        .word \next
size        .word \size
            .ends

; 16-bit integers
obj_int16   .struct value
            .dstruct obj_header, types.int16
value       .word \value
            .ends

; null terminated strings
obj_string  .struct value = ""
-
            .dstruct obj_header, types.string, (+) - (-)
value       .null \value
            .align 2
+
            .ends

; dictionary as array of key, value far pointers
obj_dict    .struct elements = 4
            .dstruct obj_header, types.dict, \elements * 6
value       .fill \elements * 6, 0
            .ends

obj_builtin .struct label
            .dstruct obj_header, types.builtin
value       .word \label
            .ends

obj_code    .struct size, num_consts = 0, num_locals = 0
            .dstruct obj_header, types.code, \size
consts_size .byte \num_consts * 3
locals_size .byte \num_locals * 3
consts
            .ends
