
print_line:
    ; A = length, X = pointer, DBR = data bank
    !zone print_line
    +fenter 2, ~.args
    .length = .args             ; word
    .pointer = .args + 2        ; word
    .pointer_bank = .args + 4   ; byte
    .n = 1                      ; word

    ; switch to basic stack for kernel call
    lda basic_stack
    tcs
    ; set data bank
    +a8
    lda .pointer_bank
    pha
    plb
    +a16
    ; load up the pointer
    ldx .pointer
    ; set remaining
    lda .length
    sta .n
.loop:
    ; stow away X since chrout mucks with it
    +a8
    lda $0000, x
    +a16
    ; print it out using kernel call
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
    dec .n
    bne .loop
    ; fexit will put our stack back
    +fexit .args
    rts
