
memory_init
    ; initialize free lists for each bank 2 - # available
    ; get the last bank and put it on the stack
    +a8
    lda     $d27f
    pha
    ; start at bank 2
    lda     #2
-
    pha
    plb
    +a16
    ; pointer of first free block
    lda     #2
    sta+2   $0
    ; size - header takes two words
    lda     #$fffc
    sta+2   $2
    ; pointer to next block
    lda     #0
    sta+2   $4
    +a8
    phb
    pla
    inc
    cmp     1, S
    bne     -
    ; set the bank back to zero
    lda     #0
    pha
    plb
    ; pop off our last block number and return
    pla
    +a16
    rts
