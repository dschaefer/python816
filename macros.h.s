.macro a8
    sep #$20
.endmacro

.macro a16
    rep #$20
.endmacro

.macro i8
    sep #$10
.endmacro

.macro i16
    rep #$10
.endmacro

.macro ai8
    sep #$30
.endmacro

.macro ai16
    rep #$30
.endmacro

.macro cpuemu
    sec
    xce
.endmacro

.macro cpunat
    clc
    xce
.endmacro

.macro swapStacks from, to
    tsa
    sta from
    lda to
    tas
.endmacro

.macro pushFar addr
    lda #.loword(addr)
    pha
    a8
    lda #.bankbyte(addr)
    pha
    a16
.endmacro

; ldbx - load data bank and X register
.macro ldbx addr
    a8
    ldx #.bankbyte(addr)
    phx
    plb
    a16
    ldx #.loword(addr)
.endmacro
