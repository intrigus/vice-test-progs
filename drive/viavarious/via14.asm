        !to "via14.prg", cbm

TESTID =          14

tmp=$fc
addr=$fd
add2=$f9

TMP=$8000

TESTLEN = $40

NUMTESTS =        16 - 8

DTMP   = $0700          ; measured data on drive side

        !src "common.asm"

        !align 255,0
TESTSLOC

;------------------------------------------
; - output timer A at PB7 and read back PB
; Similar to via13, but sets the control register *before* starting the timer
; rather than after. Both are good to test, but this one should be closer to
; what real code would try to do, and easier to match against the spec.

!macro  TEST .DDRB,.PRB,.CR,.TIMER,.THIFL {
.test
        lda #.DDRB
        sta $1802                       ; port B ddr input
        lda #.PRB
        sta $1800                       ; port B data
        lda #.CR                        ; control reg
        sta $180b+.TIMER
        lda #1
        sta $1804+(.TIMER*4)+.THIFL
        ldx #0
.t1b    lda $1800                       ; port B data
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
}

+TEST $80,$80,$00,0,0
+TEST $80,$80,$00,0,1

+TEST $80,$80,$80,0,0
+TEST $80,$80,$80,0,1

+TEST $80,$80,$40,0,0
+TEST $80,$80,$40,0,1

+TEST $80,$80,$c0,0,0
+TEST $80,$80,$c0,0,1

NEXTNAME ;!pet "via15"
NEXTNAME_END

DATA
        !bin "via14ref.bin", NUMTESTS * $0100, 2
ERRBUF
