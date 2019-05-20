    .cpu "65816"

*   = $0801
    .word (+), 10
    .byte $9e
    .null format("%d", start)
+   .word 0

start:
    rts
