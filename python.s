!source "defs.ah"

    * = $0800

basic:
    !byte 0
    !word end_of_basic
    !word 10
    !byte token_SYS
    !pet "2061"
end_of_basic:
    !byte 0, 0, 0

main:
    ; enter native mode and switch to python stack
    +cpu_native
    +ai16

    ; set up the direct page
    lda #$7000
    tcd

    ; set up the call stack
    tsc
    sta dp_basic_stack
    lda #$7fff
    tcs

    ; initialize the object store
    jsr objects_init

    ; run python
    jsr python_main

    ; restore call stack    
    lda dp_basic_stack
    tcs

    ; restore direct page
    lda #0
    tcd

    ; restore data bank
    +a8
    pha
    plb

    ; back to basic
    +cpu_emu
    rts

python_main:
    !zone python_main
    .fp = 0
    +pushptra ~.fp, 0, _test_main
    jsr code_run
    +popa ~.fp, 3
    +checkfp .fp
    rts

!source "util.s"
!source "memory.s"
!source "string.s"
!source "code.s"

_test_welcome:
    !word type_string << 8 | 1
    !word ++ - +
+
    !pet petscii_LOWERCASE, "Welcome to Python!", $d, $0
++

_test_print:
    !word type_string << 8 | 1
    !word ++ - +
+
    !pet "print", 0
++

_test_main:
    !word type_code << 8 | 1
    !word ++ - +
+
    !word ++++ - +++
+++
    !byte opcode_load, 0
    !byte opcode_load, 1
    !byte opcode_call_function, 1
++++
    !24 _test_welcome
    !24 _test_print
++
