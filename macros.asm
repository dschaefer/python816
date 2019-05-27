    .cpu "65816"
    .autsiz
    .enc "screen"

a8 .macro
    sep #$20
    .endm

a16 .macro
    rep #$20
    .endm

x8 .macro
    sep #$10
    .endm

x16 .macro
    rep #$10
    .endm

ax8 .macro
    sep #$30
    .endm

ax16 .macro
    rep #$30
    .endm

cpunat .macro
    clc
    xce
    .endm

cpuemu .macro
    sec
    xce
    .endm

swapStacks .macro from, to
    tsc
    sta \from
    lda \to
    tcs
    .endm
