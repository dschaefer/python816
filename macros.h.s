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

.macro phfara addr
    a8
    lda addr + 2
    pha
    a16
    lda addr
    pha
.endmacro

.macro pla8
    a8
    pla
    a16
.endmacro

.macro ply8
    i8
    ply
    i16
.endmacro

.macro pl3a
    a8
    pla
    a16
    pla
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

.macro mult3
    pha
    asl
    clc
    adc 1, s
    sta 1, s
    pla
.endmacro

.macro mult6
    asl
    pha
    asl
    clc
    adc 1, s
    sta 1, s
    pla
.endmacro
