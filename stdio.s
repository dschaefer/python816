
; print_line(A = length, X = pointer, DBR = data bank)
print_line:
    sta     +
    phd
    lda     #0
    tcd
-
    +a8
    lda+2   0, x
    phx
    +cpu_emu
    jsr     k_chrout
    +cpu_native
    +ai16
    plx
    inx
    dec     +
    bne     -
    pld
    rts
+   ; length
    !skip   2
