
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
    lda basic_stack
    tcs
    +cpu_emu
    rts

basic_stack:
    !skip 2

python_main:
    ; print welcome message
    +a8
    lda #0
    pha
    +a16
    lda #welcome
    pha
    lda #(welcome_end - welcome)
    pha
    jsr print_line
    +pop 5
    rts

welcome:
    !pet    petscii_LOWERCASE, "Welcome to Python!", $d, $0
welcome_end:
