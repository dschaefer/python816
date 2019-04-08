stdio_init:
    jsr     k_clrchn
    rts

read_line:
    ldy     #$00
-
    jsr     k_chrin
    cmp     #$0d
    beq     +
    sta     dp_string, y
    iny
    jmp     -
+
    sty     dp_stringlen
    ; force the newline
    jsr     k_chrout

; spit it out
print_line:
    +a8
    ldy     #$00
-
    cpy     dp_stringlen
    beq     +
    lda     (dp_string), y
    iny
    jsr     k_chrout
    jmp     -
+
    +a16
    rts
