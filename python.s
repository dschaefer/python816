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
    tsc
    sta basic_stack
    lda #$7fff
    tcs

    ; initialize the object store
    jsr objects_init
    ; run python
    jsr python_main

    ; restore stack, back to emu, and return to basic
    +a8
    lda #0
    pha
    plb
    +a16
    lda basic_stack
    tcs
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

; todo move these to direct page
basic_stack:
    !skip 2
python_stack:
    !skip 2

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
