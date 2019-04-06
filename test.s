    !cpu    65816
    !source <65816/std.a>
    !source <cbm/kernal.a>
    !source <cbm/basic2.a>

    * = $0800

basic:
    !byte   0
    !word   end_of_basic
    !word   10
    !byte   token_SYS, ' '
    !pet    "2062"
end_of_basic
    !byte   0, 0, 0

main:
    +cpu_native
    +ai16

    jsr     test

    +cpu_emu
    rts

test:
    ; a + b

    ; push b
    lda     #a
    pha

    ; push a
    lda     #b
    pha

    ; op +
    plx
    phx
    +a8
    lda     1, x
    +a16
    tax
    lda     ops_table, x
    clc
    adc+1   #op_plus
    tax
    jsr     (0, x)

    ; op toString
    lda     0, s
    tax
    lda     ops_table, x
    clc
    adc+1   #op_toString
    tax
    jsr     (0, x)

    ; call print
    jsr     string_print
    rts

t_int16     = 0
t_string    = 2

op_plus     = 0
op_toString = 2

-   !skip   2
--  !skip   2
int16_plus:
    plx
    lda     1, x
    sta     -
    plx
    lda     1, x
    sta     --
    ldx     #c
    phx
    clc
    lda     -
    adc     --
    sta     1, x
    +a8
    lda   #t_int16
    sta   0, x
    +a16
    rts

int16_toString:
    rts

int16_ops:
    !word   int16_plus
    !word   int16_toString

string_plus:
    rts

string_toString:
    rts

string_ops:
    !word   string_plus
    !word   string_toString

string_print:
    rts

ops_table:
    !word   int16_ops
    !word   string_ops

a:
    !byte   t_int16
    !word   4

b:
    !byte   t_int16
    !word   5

c:  !skip   3
