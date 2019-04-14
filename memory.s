
    start_bank  = $00d27d
    end_bank    = $00d27f
    min_size    = 6

objects_init:
    ; initialize free lists for each bank
    +a8
    lda start_bank
    tax
.loop:
    phx
    plb
    +a16
    ; pointer of first free block
    lda #2
    sta $0000
    ; size
    lda #$fffa  ; 64k - header starting at $2
    sta $0002
    ; pointer to next block = null
    stz $0004
    +a8
    inx
    txa
    cmp end_bank
    bne .loop
    ; done
    +a16
    rts

malloc:
    !zone malloc
    +fenter 2, ~.args
    .size = .args
    .pointer = .args + 2
    .pointer_bank = .args + 4
    .block = 1

    ; try each bank
    +a8
    lda start_bank
    tax
.bank_loop:
    phx
    plb
    ; try each block
    +a16
    lda $0000
    cmp #0
    beq .bank_next
.block_loop:
    sta .block
    lda (.block)
    bit #1      ; on if in use
    bne .block_next
    cmp .size
    +bge .found_block   ; big enough
.block_next:
    ; block += 2 to point at the next free
    inc .block
    inc .block
    lda (.block)
    bne .block_loop
.bank_next:
    +a8
    inx
    txa
    cmp end_bank
    bne .bank_loop
    ; not found, return null
    stz .pointer_bank
    +a16
    stz .pointer
    bra .done
.found_block:
    ; store away the the bank
    +a8
    stx .pointer_bank
    +a16
    ; A has size of block, we can use X now
    ; if extra space larger than min size, split it
    tax     ; save away the size
    sec
    sbc .size
    cmp #min_size
    +ble .return_block
    ; split the block
    ;--> TODO
.return_block:
    ;--> set the size bit 1 to mark used
    sta .pointer
.done:
    +fexit .args
    rts
