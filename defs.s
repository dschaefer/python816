    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>
    !source <cbm/c64/petscii.a>

;   types
    type_free       = 0
    type_none       = 1
    type_noimpl     = 2
    type_ellipse    = 3
    type_true       = 4
    type_false      = 5
    type_int        = 6
    type_float      = 7
    type_complex    = 8
    type_string     = 9
    type_tuple      = 10
    type_bytes      = 11
    type_list       = 12
    type_bytearray  = 13
    type_set        = 14
    type_frozenset  = 15
    type_dict       = 16
    ; --> more

;   ops
    op_print        = 1

!macro pushall ~.fp {
    pha
    phx
    phy
    phb
    !set .fp = .fp + 7
}

!macro popall ~.fp {
    plb
    ply
    plx
    pla
    !set .fp = .fp - 7
}

!macro alloca ~.fp, .size {
    !if .size = 2 {
        pha
    } else {
        !if .size = 4 {
            pha
            pha
        } else {
            tsc
            sec
            sbc #.size
            tcs
        }
    }
    !set .fp = .fp + .size
}

!macro popa ~.fp, .size {
    !if .size = 2 {
        pla
    } else {
        !if .size = 4 {
            pla
            pla
        } else {
            tsc
            clc
            adc #.size
            tcs
        }
    }
    !set .fp = .fp - .size
}

!macro pusha ~.fp {
    pha
    !set .fp = .fp + 2
}

!macro popa ~.fp {
    pla
    !set .fp = .fp - 2
}

!macro pushx ~.fp {
    phx
    !set .fp = .fp + 2
}

!macro popx ~.fp {
    plx
    !set .fp = .fp + 2
}

!macro pushy ~.fp {
    phy
    !set .fp = .fp + 2
}

!macro popy ~.fp {
    ply
    !set .fp = .fp + 2
}

!macro checkfp .fp {
    !if .fp != 0 {
        !error "stack not cleared"
    }
}

!macro popall ~.fp, .locals {
    +popa ~.fp, .locals
    +popall ~.fp
    +checkfp .fp
}

!macro ldas .fp, .var {
    lda .fp - .var + 1, s
}

!macro ldasy .fp, .var {
    lda (.fp - .var + 1, s), y
}

!macro ldasy .fp, .var, .y {
    ldy #.y
    lda (.fp - .var + 1, s), y
}

!macro cmps .fp, .var {
    cmp .fp - .var + 1, s
}

!macro cmpsy .fp, .var {
    cmp (.fp - .var + 1, s), y
}

!macro sbcs .fp, .var {
    sbc .fp - .var + 1, s
}

!macro sbcsy .fp, .var {
    sbc (.fp - .var + 1, s), y
}

!macro adcs .fp, .var {
    adc .fp - .var + 1, s
}

!macro adcsy .fp, .var {
    adc (.fp - .var + 1, s), y
}

!macro stas .fp, .var {
    sta .fp - .var + 1, s
}

!macro stasy .fp, .var {
    sta (.fp - .var + 1, s), y
}

!macro stasy .fp, .var, .y {
    ldy #.y
    sta (.fp - .var + 1, s), y
}

; missing 6502 memonics

!macro bge .t {
    bcs .t
}

!macro blt .t {
    bcc .t
}

!macro ble .t {
    +blt .t
    beq .t
}

!macro popa .size {
    !if .size = 2 {
        pla
    } else {
        !if .size = 4 {
            pla
            pla
        } else {
            tsc
            clc
            adc #.size
            tcs
        }
    }
}
