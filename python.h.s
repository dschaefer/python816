    ; types and ops headers

.enum Types
    free
    int16
    string
    dict
    code
    builtin
.endenum

; Represents a free object
; Size is also put in the last word of the block so we can merge on free
; Minimum block size is 6 which is why size is last here.
; Also blocks can't be size 7 since we need room for the size at the end
.struct FreeObject
    type     .byte
    refcount .byte
    next     .word
    size     .word
.endstruct

; Root of all allocated objects
; All objects start with type, refcount and size
; If we don't care about the type of the object, we can use this struct
; since all objects start with these fields
.struct Object
    type     .byte
    refcount .byte
    size     .word
.endstruct

; 16-bit int
.struct Int16
    header   .tag Object
    value    .word
.endstruct

; constructor for 16-bit intse
.macro newInt16 value
    .byte Types::int16, 0
    .word 6
    .word value
.endmacro

; null terminated string
; as mentioned above, minimize size of this block is 6
.struct String
    header  .tag Object
    value   .byte
.endstruct

; constructor for string
.macro newString value
    .byte Types::string, 0
    .word .max(.strlen(value) + 1 + 4, 6)
    .asciiz value
    .if .strlen(value) = 0
        .byte 0
    .endif
.endmacro

; code object
; includes space for far pointers to constants and after that, the byte code
; also a field for the number of locals to allocate on the stack
.struct Code
    header      .tag Object
    consts_size .word
    locals_size .word
    consts      .byte
.endstruct

.macro newCode consts_size, locals_size, code_size
    .byte Types::code, 0
    .word code_size + consts_size + 8
    .word consts_size
    .word locals_size
.endmacro

; opcodes
.enum OpCodes
    load_const
    load_none
    call_function
    pop_top
    return_value
.endenum
