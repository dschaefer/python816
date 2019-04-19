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

!macro alloca .n {
    tsc
    sec
    sbc #.n
    tcs
}

;   pop off temporaries
!macro pop .n {
    tsc
    clc
    adc #.n
    tcs
}

;   enter frame
!macro fenter .locals, ~.args {
    pha
    phx
    phy
    phd
    tsc
    !if .locals > 0 {
        sec
        sbc #.locals
    }
    tcd
    ; 8 saved regs + 2 return address + 1
    .args = 11 + .locals
}

; exit frame
!macro fexit .args {
    .locals = .args - 11
    tdc
    !if .locals > 0 {
        clc
        adc #.locals
    }
    tcs
    pld
    ply
    plx
    pla
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
