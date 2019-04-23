
;   Object management
;
;   Object header
;       8 bits type - list in defs.h
;       8 bits ref count
;       16 bits size
;   Free blocks have another 16 bit pointer to the next free block
;   That makes the min size 6
    min_size    = 6
    first_free  = $0000
    first_block = $0002

;   offsets in block headers
    size_offset = 2
    next_free   = 4

;   xscpu registers for identifying available banks
    start_bank  = $00d27d
    end_bank    = $00d27f

;   objects_init
;       initialize free lists for each bank
objects_init:
    +ai8
    lda start_bank
    tax
.loop:
    ; set data bank
    phx
    plb
    +ai16
    ; pointer of first free block
    lda #first_block
    sta first_free
    ; first/only block - type_none, ref count zero, i.e. 0
    stz first_block
    ; size - rest of the bank
    lda #($10000 - 6)
    sta first_block + size_offset
    ; next bank
    +ai8
    inx
    txa
    cmp end_bank
    bne .loop
    ; done
    +ai16
    rts

;   object_alloc(size: word): pointer
;       caller is responsible for setting the type/ref count
;       search bank by bank looking for first fit
;       split if necessary and set up object header
;       TODO free will need to order the free blocks smallest to largest
;       TODO might want to optimize using buckets for common sizes
object_alloc:
    !zone object_alloc
    .result = -4
    .size = -2
    .fp = 0
    +pushall ~.fp
    +alloca ~.fp, 2
    .current = .fp

    ; try each bank
    +ai8
    lda start_bank
    tax
.bank_loop:
    phx
    plb
    ; try each block
    +ai16
    lda first_free
    beq .bank_next
.block_loop:
    +stas .fp, .result
    ; load header and check if it's free (0)
    +ldasy .fp, .result, 0
    bne .block_next
    ; load up the size
    ldy #size_offset
    +ldasy .fp, .result
.check_size
    +cmps .fp, .size
    +bge .found_block   ; big enough
.block_next:
    ; get the next block pointer and loop
    iny
    iny
    +ldasy .fp, .result
    bne .block_loop
    ; ran out of blocks, next bank
.bank_next:
    +a8
    inx
    txa
    cmp end_bank
    bne .bank_loop
    ; not found, return null pointer, result is already null
    lda #0
    +stas .fp, .result - 2
    +a16
    bra .done
.found_block:
    ; store away the the bank, the rest of the pointer is already there
    +a8
    txa ; X is now available
    +stas .fp, .result - 2
    +a16

    ; remove us from the free list
    ldy #next_free
    lda first_free
    +cmps .fp, .result
    bne .free_loop
    ; we were the first, copy our next to it
    +ldasy .fp, .result
    sta first_free
    bra .free_done
.free_loop
    +stas .fp, .current
    +ldasy .fp, .current ; in theory this should never be null
    +cmps .fp, .result
    bne .free_loop
    ; unlink it
    +ldasy .fp, .result
    +stasy .fp, .current
.free_done

    ; do we need to split the block?
    sec
    +sbcs .fp, .size
    cmp #min_size
    +ble .done ; nope, we'll just use the existing size
    ; yup, set up the new block
    tax ; save away the new size
    ; first set the size of our allocated block
    +ldas .fp, .size
    +stasy .fp, .result, 2
    ; pointer to new block
    clc
    adc #6 ; header + size + .size + header
    tay
    ; push the pointer to add to free list
    +adcs .fp, .result
    pha
    ; set type as free (0)
    lda #0
    +stasy .fp, .result, 0
    ; set new size
    txa ; remember when we saved the new size, good times
    sec
    sbc #4 ; header size
    +stasy .fp, .result, 2
    ; add to the free list
    jsr _object_add_free
    pla
.done:
    +popall ~.fp, 2
    rts

;   object_free(block: pointer): void
object_free:
    !zone object_free
    .block = -2
    .fp = 0
    +pushall ~.fp
    ; simply set the data bank and call add free
    +a8
    +ldas .fp, .block - 2
    phb
    +a16
    +ldas .fp, .block
    pha
    jsr _object_add_free
    +popall ~.fp
    +checkfp .fp
    rts

;   _object_add_free(block: word): void
;   add to the free list after all smaller blocks
_object_add_free:
    !zone _object_add_free
    .block = -2
    .fp = 0
    +pushall ~.fp
    +alloca ~.fp, 2
    .previous = .fp
    +alloca ~.fp, 2
    .current = .fp

    ; load up first block
    lda #0
    +stas .fp, .previous
    lda first_free
    beq .end_loop ; list is empty
.loop
    ; loop through list while smaller sizes
    +stas .fp, .current
    ldy #size_offset
    +ldasy .fp, .current
    +cmpsy .fp, .block
    +blt .end_loop
    ; iterate
    +ldas .fp, .current
    +stas .fp, .previous
    ldy #next_free
    +ldasy .fp, .current
    bne .loop ; fall through at end of list
.end_loop
    ; insert us after .previous
    ldy #next_free
    +ldas .fp, .previous
    bne .insert
    ; .previous was null, make us first
    lda first_free
    +stasy .fp, .block
    +ldas .fp, .block
    sta first_free
    bra .done
.insert
    ; insert us after .previous
    +ldasy .fp, .previous
    +stasy .fp, .block
    +ldas .fp, .block
    +stasy .fp, .previous
.done
    +popa ~.fp, 4
    +popall ~.fp
    +checkfp .fp
    rts
