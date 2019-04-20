
;   string_new(buffer: pointer): pointer
;       allocates a new object and copies the string from the buffer
string_new:
    !zone string_new
    +fenter 0, ~.args
    .buffer = .args
    .result = .args + 3

    ; load up the pointer to the buffer to find the size
    +a8
    lda .buffer + 2
    pha
    plb
    +a16
    ldy #0 ; strlen
.loop_strlen
    +a8
    lda (.buffer), y
    +a16
    beq .done_strlen
    iny
    bra .loop_strlen
.done_strlen
    +alloca 3 ; the returned pointer
    iny ; make sure we capture the zero terminator
    phy
    jsr object_alloc
    ; copy the new object to .result
    +a8
    lda 5, s
    sta .result + 2
    pha
    plb
    +a16
    lda 3, s
    sta .result
    ; set the header
    lda #type_string << 8
    sta (.result)
    ; copy the string, copy pointer to result
    ; first the banks (self modify mvn instruction)
    +a8
    lda .buffer + 2
    sta+3 .mvn + 2
    lda .result + 2
    sta+3 .mvn + 1
    +a16
    ; now set up the pointers
    ldx .buffer
    lda .result
    clc
    adc #4 ; skip over object header
    tay
    lda 1, s ; the size we left on the stack
    dec
.mvn
    mvn 1, 2
    +fexit .args
    rts

;   string_print(string: pointer): void
string_print:
    !zone string_print
    +fenter 0, ~.args
    .string = .args

    ; switch to the basic stack for the kernel call
    lda+3 basic_stack
    tcs
    ; set the data bank
    +a8
    lda .string + 2
    pha
    plb
    +a16
    ; load up the pointer and skip over header
    lda .string
    clc
    adc #4
    tax
    ; save away the direct page register and set to zero
    phd
    lda #0
    tcd
    ; char mode
    +a8
.loop
    ; load up the character, break if zero
    lda $0000, x
    beq .done
    ; prepare for kernel call
    phx
    phb
    +i8
    ldy #0 ; need to set the data bank to zero
    phy
    plb
    +cpu_emu
    jsr k_chrout
    +cpu_native
    +i16
    plb
    plx
    inx
    bra .loop
.done:
    ; restore the direct page register and exit
    +a16
    pld
    +fexit .args
    rts
