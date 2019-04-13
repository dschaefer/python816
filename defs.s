    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>
    !source <cbm/c64/petscii.a>

; enter function
!macro fenter .locals, ~.args {
    pha
    phx
    phy
    phd
    !if .locals = 2 {
        pha
        tsc
    } else {
        !if .locals = 4 {
            pha
            pha
            tsc
        } else {
            !if .locals > 0 {
                tsc
                sec
                sbc #.locals
            }
        }
    }
    tcd
    ; 8 saved regs + 2 return address + 1
    .args = 11 + .locals
}

!macro fexit {
    tdc
    tcs
    pld
    ply
    plx
    pla
}

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
