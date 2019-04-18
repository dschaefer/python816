;   Object management
;
;   Object header
;       5 bits type - list in defs.h
;       3 bits size - number of bytes (up to 6)
;       8 bits ref count
;       16 bits extended size if size == $7, number of bytes (> 6)

;   xscpu registers for identifying available banks
    start_bank  = $00d27d
    end_bank    = $00d27f
    min_size    = 6

;   objects_init
;       initialize free lists for each bank
objects_init:
    +a8
    lda start_bank
    tax
.loop:
    ; set data bank
    phx
    plb
    +a16
    ; pointer of first free block
    lda #2
    sta $0000
    ; first/only block - type_none, extended size, ref count zero
    lda #(((type_free | extended_size) << 8) | 0)
    sta $0002
    ; extended size - rest of the bank
    lda #($10000 - 6)
    sta $0004
    ; next bank
    +a8
    inx
    txa
    cmp end_bank
    bne .loop
    ; done
    +a16
    rts

;   object_alloc(type: byte, size: word): pointer
;       search bank by bank looking for first fit
;       split if necessary and set up object header
;       TODO free will need to order the free blocks smallest to largest
;       TODO might want to optimize using buckets for common sizes
object_alloc:
    !zone object_alloc
    +fenter 2, ~.args
    .type = .args
    .size = .args + 1
    .result = .args + 3
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
    stz .result + 2
    +a16
    stz .result
    bra .done
.found_block:
    ; store away the the bank
    +a8
    stx .result + 2
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
    sta .result
.done:
    +fexit .args
    rts
