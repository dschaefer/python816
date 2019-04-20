
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

basic_stack:
    !skip 2

python_main:
    ; push space for new string object
    +alloca 3
    ; push pointer to the string buffer
    +a8
    lda #0
    pha
    +a16
    lda #welcome
    pha
    jsr string_new
    ; pop the buffer
    +pop 3
    ; TODO increase ref count on the string object
    ; print it
    jsr string_print
    ; TODO decrease ref count on the string object
    ; pop the string object
    +pop 3
    rts

welcome:
    !pet    petscii_LOWERCASE, "Welcome to Python!", $d, $0
