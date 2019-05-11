    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>
    !source <cbm/c64/petscii.a>
    !source "defs.ah"

    * = $0800

basic:
    !byte 0
    !word end_of_basic
    !word 10
    !byte token_SYS
    !pet "2560" ; address of start $0a00
end_of_basic:
    !byte 0, 0, 0

;   The direct page
;       make sure it's aligned on page boundary for performance
    !align $ff, 0
direct_page:
    !zone direct_page
    ; storage for the BASIC stack while in python
    dp_basic_stack+1 = * - direct_page
    !word 0
    ; storage for the python stack when switching to BASIC
    dp_python_stack+1 = * - direct_page
    !word $9fff
    ; object stack pointer
    dp_sp+1 = * - direct_page
    !word $cfff
    ; object frame pointer
    dp_fp+1 = * - direct_page
    !word $cfff
    ; current function program counter
    dp_pc+1 = * - direct_page
    !24 0
    ; fill out to the end of the direct page
    !align $ff, 0, 0

;   The entry point
start:
    !zone start
    ; enter native mode and switch to python stack
    +cpu_native
    +ai16

    ; set up the direct page
    lda #direct_page
    tcd

    ; switch call stacks
    tsc
    sta dp_basic_stack
    lda dp_python_stack
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

!source "tables.ah"
!source "util.ah"
!source "memory.ah"
!source "string.ah"
!source "code.ah"

python_main:
    !zone python_main
    .fp = 0
    +pushptra ~.fp, 0, _test_main
    jsr code_run
    +popa ~.fp, 3
    +checkfp .fp
    rts

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
