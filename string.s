
;   string_new(buffer: pointer): pointer
;       allocates a new object and copies the string from the buffer
string_new:
    !zone string_new
    +fenter 0, ~.args
    .buffer = .args
    .result = .args + 3
    .string_obj+1 = -2
    ; load up the pointer to the buffer to find the size
    +a8
    lda .buffer + 2
    pha
    plb
    +a16
    ldy .buffer
    ldx #0 ; strlen
.loop_strlen
    lda (.buffer), y
    beq .done_strlen
    inx
    bra .loop_strlen
.done_strlen
    +alloca 3 ; the pointer
    phx ; the size
    jsr object_alloc
    ; set the object type
    plb
    ply
    lda type_string << 8
    sta 0, y
    ; copy the string, copy pointer to result
    ; first the banks (self modify mvn instruction)
    +a8
    lda .buffer + 2
    sta .mvn + 2
    lda .string_obj + 2
    sta .result + 2
    sta .mvn + 1
    +a16
    ; now set up the pointers
    ldx .buffer
    ldy .string_obj
    sty .result
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
.loop
    ; load up the character, break if zero
    +a8
    lda $0000, x
    +a16
    beq .done
    ; prepare for kernel call
    phx
    +cpu_emu
    jsr k_chrout
    +cpu_native
    +a16
    plx
    inx
    bra .loop
.done:
    ; restore the direct page register and exit
    pld
    +fexit .args
    rts
