
;   string_new(buffer: pointer): pointer
;       allocates a new object and copies the string from the buffer
string_new:
    !zone string_new
    .result = -5
    .buffer = -2
    .fp = 0
    +pushall ~.fp

    ; load up the pointer to the buffer to find the size
    +a8
    +ldas .fp, .buffer - 2
    pha
    plb
    +a16
    ldy #0 ; strlen
.loop_strlen
    +a8
    +ldasy .fp, .buffer
    +a16
    beq .done_strlen
    iny
    bra .loop_strlen
.done_strlen
    +alloca ~.fp, 3
    .newobj = .fp
    iny ; make sure we capture the zero terminator
    +pushy ~.fp
    jsr object_alloc
    ; copy the new object to .result
    +a8
    +ldas .fp, .newobj - 2
    +stas .fp, .result - 2
    pha
    plb
    +a16
    +ldas .fp, .newobj
    +stas .fp, .result
    ; set the header
    lda #type_string << 8
    +stasy .fp, .result, 0
    ; copy the string, copy pointer to result
    ; first the banks (self modify mvn instruction)
    +a8
    +ldas .fp, .buffer - 2
    sta+3 .mvn + 2
    +ldas .fp, .result - 2
    sta+3 .mvn + 1
    +a16
    ; now set up the pointers
    +ldas .fp, .buffer
    tax
    +ldas .fp, .result
    clc
    adc #4 ; skip over object header
    tay
    +popa ~.fp
    dec
.mvn
    mvn 1, 2
    +popall ~.fp, 3
    rts

;   string_print(string: pointer): void
string_print:
    !zone string_print
    .string = -2
    .fp = 0
    +pushall ~.fp

    ; set the data bank
    +a8
    +ldas .fp, .string - 2
    pha
    plb
    +a16
    ; load up the pointer and skip over header
    +ldas .fp, .string
    clc
    adc #4
    tax
    ; switch to the basic stack
    tsc
    sta+3 python_stack
    lda+3 basic_stack
    tcs
    ; save away the direct page register and set to zero
    phd
    lda #0
    tcd
    ; char mode to walk the string
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
    ; restore the direct page register, stack, and exit
    +a16
    pld
    lda+3 python_stack
    tcs
    +popall ~.fp, 0
    rts
