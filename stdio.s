
    ; print_line(string: pointer): void
print_line:
    !zone print_line
    +fenter 2, ~.args
    .pointer = .args + 2        ; word

    ; switch to basic stack for kernel call
    lda+3 basic_stack
    tcs
    ; set data bank
    +a8
    lda .pointer + 2
    pha
    plb
    +a16
    ; load up the pointer
    ldx .pointer
.loop:
    ; load up the character
    +a8
    lda $0000, x
    +a16
    beq .done
    ; prepare for the jump to the kernel
    phx
    phd
    tay
    lda #0
    tcd
    tya
    +cpu_emu
    jsr k_chrout
    +cpu_native
    +ai16
    pld
    plx
    inx
    bra .loop
.done:
    ; fexit will switch back to python stack
    +fexit .args
    rts
