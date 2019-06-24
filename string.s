; methods for the string type
    .include "python.h.s"

    .export string_hash_word
    ; produce a hash of the string, return just the word
    ; - string far pointer
.proc string_hash_word
    phd
    tsa
    tad

    result = 4
    string = result

    lda #0
    pha ; the hash (1, s)
    ldy #String::value
loop:
    a8
    lda [string], y
    a16
    beq done
    adc 1, s
    sta 1, s
    iny
    bra loop
done:
    ; grab the hash and return
    pla
    sta result
    pld
    rts
.endproc