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

    ; push b and increment reference count
    ldx     #a
    phx
    +a8
    inc     1, x
    +a16

    ; push a
    ldx     #b
    phx
    +a8
    inc     1, x
    +a16

    ; op +
    plx
    phx
    +i8
    ldy     1, x
    +i16
    ldx     ops_table, y
    jsr     (op_plus, x)

    ; op toString
    plx
    phx
    +i8
    ldy     1, x
    +i16
    ldx     ops_table, y
    jsr     (op_toString, x)

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

; object layout
;   !byte   type
;   !byte   reference count
;   and the rest is the data

a:
    !byte   t_int16
    !byte   1
    !word   4

b:
    !byte   t_int16
    !byte   1
    !word   5

c:  !skip   4
