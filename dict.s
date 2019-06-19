    .include "python.h.s"

    .export dict_add

; dict_add
;    - dict far pointer (dp + 11)
;    - key far pointer (dp + 8)
;    - value far pointer (dp + 5)
; TODO assuming key is a string for now
.proc dict_add
    argstart = 4 + 1
    dict = argstart + 6
    key = argstart + 3
    value = argstart
    phd
    tsa
    tad
    phb

    ; step 1 - calculate hash
    ; change bank to key's bank
    a8
    lda key + 2
    pha
    plb
    a16
    ; walk through the string using stack space for a second accumulator
    lda #0
    pha
    ldy #String::value
hash_loop:
    a8
    lda [key], y
    a16
    beq hash_done
    adc 1, s
    sta 1, s
    iny
    bra hash_loop
hash_done:
    pla
    ldy #Dict::mask
    ora [dict], y
    mult6

    ; step 2 - find a free element


    plb
    pld
    rts
.endproc