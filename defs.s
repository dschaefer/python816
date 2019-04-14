    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>
    !source <cbm/c64/petscii.a>

; store/restore stack and call a kernel function
!macro kcall .func {
}

; pop off temporaries
!macro pop .n {
    tsc
    clc
    adc #.n
    tcs
}

; enter frame
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
