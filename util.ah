
;   mult3(value: A): A
;       A = A * 3
;       mainly used to index into an array of pointers
mult3:
    !zone mult3
    phx
    pha
    asl
    clc
    adc 1, s
    plx
    plx
    rts

;   mult6(value: A): A
;       A = A * 6
;       used to index into dict element array
mult6:
    !zone mult6
    asl
    phx
    pha
    asl
    clc
    adc 1, s
    plx
    plx
    rts
