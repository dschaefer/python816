    .include "python.h.s"
    .import string_hash_word

; dict_add
;    - dict far pointer
;    - key far pointer
;    - value far pointer
; TODO assuming key is a string for now
    .export dict_add
.proc dict_add
    phd
    tsa
    tad

    argstart = 4 ; rts, phd
    dict = argstart + 6
    key = argstart + 3
    value = argstart

    ; push the string pointer for the key and hash
    phfara key
    jsr string_hash_word
    pla
    ply8 ; to get the bank of the pointer off

    ; cut down with mask
    ldy #Dict::mask
    ora [dict], y
    ; calculate pointer to key
    mult6
    adc #Dict::elements

    ; save the offset so we know when we've wrapped
    pha

    ; check if string equal

    pla

    pld
    rts
.endproc