    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>
    !source <cbm/c64/petscii.a>

; object size
    extended_size   = 7
    type_shift      = 3

;   types
    type_free       = 0 << type_shift
    type_none       = 1 << type_shift
    type_noimpl     = 2 << type_shift
    type_ellipse    = 3 << type_shift
    type_int        = 4 << type_shift
    type_float      = 5 << type_shift
    type_complex    = 6 << type_shift
    type_string     = 7 << type_shift
    type_tuple      = 8 << type_shift
    type_bytes      = 9 << type_shift
    type_list       = 10 << type_shift
    type_bytearray  = 11 << type_shift
    type_set        = 12 << type_shift
    type_frozenset  = 13 << type_shift
    type_dict       = 14 << type_shift
    ; --> more

;   store/restore stack and call a kernel function
!macro kcall .func {
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
