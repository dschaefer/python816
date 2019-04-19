;   Object management
;
;   Object header
;       8 bits type - list in defs.h
;       8 bits ref count
;       16 bits size
;   Free blocks have another 16 bit pointer to the next free block
;   That makes the min size 6
    min_size    = 6

;   xscpu registers for identifying available banks
    start_bank  = $00d27d
    end_bank    = $00d27f

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
    ; first/only block - type_none, ref count zero, i.e. 0
    stz $0002
    ; size - rest of the bank
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

;   object_alloc(size: word): pointer
;       caller is responsible for setting the type/ref count
;       search bank by bank looking for first fit
;       split if necessary and set up object header
;       TODO free will need to order the free blocks smallest to largest
;       TODO might want to optimize using buckets for common sizes
object_alloc:
    !zone object_alloc
    +fenter 2, ~.args
    .size = .args
    .result = .args + 2

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
    beq .bank_next
.block_loop:
    sta .result
    ; load header and check if it's free (0)
    lda (.result)
    bne .block_next
    ; load up the size
    ldy #2
    lda (.result), y
.check_size
    cmp (.size)
    +bge .found_block   ; big enough
.block_next:
    ; get the next block pointer and loop
    iny
    iny
    lda (.result), y
    bne .block_loop
    ; ran out of blocks, next bank
.bank_next:
    +a8
    inx
    txa
    cmp end_bank
    bne .bank_loop
    ; not found, return null pointer, result is already null
    stz .result + 2
    +a16
    bra .done
.found_block:
    ; store away the the bank, the rest of the pointer is already there
    +a8
    stx .result + 2
    +a16
    ; do we need to split the block?
    sec
    sbc .size
    cmp #min_size
    +ble .done ; nope, we'll just use the existing size
    ; yup, set up the new block
    tax ; save away the new size
    ; first set the size of our allocated block
    ldy #2
    lda .size
    sta (.result), y
    ; pointer to new block
    clc
    adc #6 ; header + size + .size + header
    tay
    ; push the pointer to add to free list
    adc .result
    pha
    ; set type as free (0)
    lda #0
    sta (.result), y
    ; set new size
    txa ; remember when we saved the new size, good times
    sec
    sbc #4 ; header size
    iny
    iny
    sta (.result), y
    ; add to the free list
    jsr _object_add_free
    pla
.done:
    +fexit .args
    rts

;   _object_add_free(block: word): void
;   add to the free list after all smaller blocks
_object_add_free:
    !zone _object_add_free
    +fenter 0, ~.args
    .block = .args
    ; --> TODO
    +fexit .args
    rts
