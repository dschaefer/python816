    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>

    * = $0800

basic:
    !byte   0
    !word   end_of_basic
    !word   10
    !byte   token_SYS, ' '
    !pet    "2062"
end_of_basic
    !byte   0, 0, 0

main:
    +cpu_native
    +ai8

; reset to stdio
    jsr     k_clrchn

; read in the string
    ldy     #$00
-
    jsr     k_chrin
    cmp     #$0d
    beq     +
    sta     data,y
    iny
    jmp     -
+
    sty     datalen
    ; force the newline
    jsr     k_chrout

; spit it out
    ldy     #$00
-
    cpy     datalen
    beq     +
    lda     data,y
    iny
    jsr     k_chrout
    jmp     -

+
    +cpu_emu
    rts

data:
    !skip   80
datalen:
    !byte 0
