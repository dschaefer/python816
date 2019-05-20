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

a8x8 .macro
    sep #$30
    .endm

a16x16 .macro
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
