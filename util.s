
;   mult3(value: A): A
;       multiply value * 3 and leave it in A
;       mainly used to index into an array of pointers
mult3:
    !zone mult3
    sta .tmp
    asl
    clc
    adc .tmp
    rts
.tmp
    !word 0
