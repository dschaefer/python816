    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>
    !source "defs.s"

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

    jsr     python_main

    ; pop back the old direct page, back to emu, and return
    pld
    +cpu_emu
    rts

python_main:
    jsr     stdio_init
    lda     #welcome
    sta     dp_string
    +a8
    lda     #welcome_end - welcome
    sta     dp_stringlen
    +a16
    jsr     print_line
    rts

direct_page:
    !skip   256

welcome:
    !pet    "Welcome to Python", $d
welcome_end:

