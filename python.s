
    * = $0800

basic:
    !byte   0
    !word   end_of_basic
    !word   10
    !byte   token_SYS
    !pet    "2061"
end_of_basic:
    !byte   0, 0, 0

main:
    ; enter native mode
    +cpu_native
    +ai16
    ; set up our direct page saving the old one
    phd
    lda     #direct_page
    tcd

    jsr     memory_init
    jsr     python_main

    ; pop back the old direct page, back to emu, and return
    pld
    +cpu_emu
    rts

python_main:
    ; go to mix case and print message
    ldx     #welcome
    lda     #welcome_end - welcome
    jsr     print_line
    rts

direct_page:
    !skip   256

welcome:
    !pet    petscii_LOWERCASE, "Welcome to Python!", $d
welcome_end:
