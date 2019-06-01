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

; an enum
;   \1 enum name
;   \2 enum item
enum .segment
    \1 :?= 0
    \2 = \1
    \1 += 1
    .endm

; table entry indexed by an enum
;   \1 enum name
;   \2 enum item
;   \3 item value
entry .segment
    .enum \1, \2
    \1_table :?= []
    \1_table := \1_table .. [\3]
    .endm

min .function a, b
    .endf a < b ? a : b
