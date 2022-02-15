        !convtab pet
        !cpu 6510

        !src "mflpt.inc"

;TESTTRACK = 1
;TRACKSECTORS = 21
        
TESTTRACK = 30
TRACKSECTORS = 18

;-------------------------------------------------------------------------------

rpmline = $0400 + (0 * 40)

drivecode_start = $0300
drivecode_exec = drvstart

factmp = $340
timerlo = $c000
timerhi = $c001

        !src "../framework.asm"

start:
!if DOPLOT = 0 {
        jsr clrscr
} else {
        jsr initplot
}
        inc $d021

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        dec $d021

!if DOPLOT = 0 {
        lda #$01
        sta $286
        lda #$93
        jsr $ffd2
}
        sei
        jsr waitframe
        jsr rcv_init
lp:
        sei
        jsr waitframe
        jsr rcv_wait

        ; get time stamp
        jsr rcv_1byte
        sta timerlo     ; lo
        jsr rcv_1byte
        sta timerhi     ; hi

!if DOPLOT = 0 {
        lda timerhi
        jsr mkhex
        sta $0400+(2*40)+15
        sty $0400+(2*40)+16
        lda timerlo
        jsr mkhex
        sta $0400+(2*40)+17
        sty $0400+(2*40)+18

        lda #19
        jsr $ffd2
        lda #$0d
        jsr $ffd2
        lda #$0d
        jsr $ffd2

        ; print number of clocks per revolution
        lda timerhi       ; lo
        ldy timerlo       ; hi
        jsr $b395       ; to FAC
        jsr $bc0c       ; ARG = FAC

        lda #<c2000000
        ldy #>c2000000
        jsr $bba2       ; in FAC

        lda $61
        jsr $b853       ; FAC = FAC - ARG
        lda $66
        eor #$ff
        sta $66
        jsr $aabc       ; print FAC

        ; calculate total time for one revolution (no rounding)

        lda timerhi     ; lo
        ldy timerlo     ; hi
        jsr $b395     ; to FAC
        jsr $bc0c       ; ARG = FAC

        lda #<c2000000
        ldy #>c2000000
        jsr $bba2       ; in FAC

        lda $61
        jsr $b853       ; FAC = FAC - ARG

        ; calculate RPM

        ; expected ideal:
        ; 300 rounds per minute 
        ; = 5 rounds per second
        ; = 200 milliseconds per round
        ; at 1MHz (0,001 milliseconds per clock)
        ; = 200000 cycles per round

        ; to calculate RPM from cycles per round:
        ; RPM = (200000 * 300) / cycles

        lda #<c6000000
        ldy #>c6000000
        jsr $ba8c       ; in ARG

        lda $61
        jsr $bb12       ; FAC = ARG / FAC

        lda #'0'
        ldx #6
-
        sta rpmline+5,x
;        sta rpmline+45,x
        dex
        bpl -
        lda #'.'
        sta rpmline+4
 
        lda #19
        jsr $ffd2

        jsr $aabc       ; print FAC
        
        ; calculate RPM again, this time rounding to two decimals

        lda timerhi     ; lo
        ldy timerlo     ; hi
        jsr $b395       ; to FAC
        jsr $bc0c       ; ARG = FAC

        lda #<c2000000
        ldy #>c2000000
        jsr $bba2       ; in FAC

        lda $61
        jsr $b853       ; FAC = FAC - ARG

        lda #<c600000000
        ldy #>c600000000
        jsr $ba8c       ; in ARG

        lda $61
        jsr $bb12       ; FAC = ARG / FAC

        jsr $B849       ; Add 0.5 to FAC
        jsr $BDDD       ; Convert FAC#1 to ASCII String at $100
 
        lda $101+0
        sta rpmline+25
        lda $101+1
        sta rpmline+26
        lda $101+2
        sta rpmline+27
        lda #'.'
        sta rpmline+28
        lda $101+3
        sta rpmline+29
        lda $101+4
        sta rpmline+30

;         lda #'0'
;         ldx #6
; -
;         sta rpmline+25,x
;         dex
;         bpl -
;         
;         clc
;         ldx #0
;         ldy #20
;         jsr $fff0
; 
;         jsr $aabc       ; print FAC

;-------------------------------------------------------------

        ; give the test two loops to settle
framecount = * + 1
        lda #2
        beq +
        dec framecount
        jmp lp
+
        ; compare, we consider 299,300,301 as acceptable
        ldy #10

        lda rpmline+1
        cmp #$32    ; 2
        bne cmp300
        lda rpmline+2
        cmp #$39    ; 9
        bne cmp300
        lda rpmline+3
        cmp #$39    ; 9
        bne cmp300
        ; is 299
        ldy #5
cmp300:        
        lda rpmline+1
        cmp #$33    ; 3
        bne cmp301
        lda rpmline+2
        cmp #$30    ; 0
        bne cmp301
        lda rpmline+3
        cmp #$30    ; 0
        bne cmp301
        ; is 301
        ldy #5
cmp301:        
        lda rpmline+1
        cmp #$33    ; 3
        bne cmpfail
        lda rpmline+2
        cmp #$30    ; 0
        bne cmpfail
        lda rpmline+3
        cmp #$31    ; 1
        bne cmpfail
        ; is 301
        ldy #5
cmpfail:       
        
        sty rpmline+$d401
        sty rpmline+$d402 
        sty rpmline+$d403 
        sty $d020
        
        lda #$ff
        cpy #5
        bne +
        lda #0
+        
        sta $d7ff

        lda $0400+(24*40)+39
        eor #$80
        sta $0400+(24*40)+39
} else {
        jsr doplot
        lda $d020
        eor #$0f
        sta $d020
}

        jmp lp

;------------------------------------------------------------------------------
        
c6000000:
        +mflpt (-200000 * 300)
c600000000:
        +mflpt (-20000000 * 300)
c2000000:
;        +mflpt ((65536 * 3) + 7 + 6)
        +mflpt ((65536 * 3) + 20 + 6)

wait2frame:
        jsr waitframe
waitframe:
-       lda $d011
        bmi -
-       lda $d011
        bpl -
        rts

mkhex:
        pha
        and #$0f
        tax
        lda hextab,x
        tay             ; lo in Y
        pla
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x    ; hi in A
        rts

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {

        !src "../framework-drive.asm"

drvstart
        sei
        lda $180b
        and #%11011111  ; start timer B
        sta $180b
        jsr snd_init

        lda #TESTTRACK  ; track nr
        sta $08
        ldx #$00        ; sector nr
        stx $09
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli

        jmp *

htime:  !byte 0
ltime:  !byte 0

        ;* = $0400
        !align $ff, 0, 0

measureirq:

-
        sei
        jsr domeasure
        
        sei
        jsr snd_start

        lda ltime+0
        jsr snd_1byte
        lda htime+0
        jsr snd_1byte

        jmp -
        
domeasure:
        ; wait for sektor 0 header
-
        jsr dretry

        lda $19         ; 2
        bne -           ; 2
 
        ; load timer with $ffff
        ; lo first, writing hi reloads latch when timer is running
        lda #$ff        ; 2
        sta $1808       ; 4
        sta $1809       ; 4

        ; timer was started 14 cycles after sector 0 detect

        ; wait for sector 0 header
-
        jsr dretry

        lda $19         ; 2
        bne -           ; 2

        ; get timer value
        lda $1808       ; 4 lo
        ldx $1809       ; 4 hi
        cmp #4
        bcs +
        inx             ; compensate hi-byte decrease
+
        ; we got the timer 8 cycles after sector 0 detect
        stx htime + 0
        sta ltime + 0

        rts

dretry:
        LDX #$00

        ; wait for sync
-       bit $1c00
        bmi -
        lda $1c01       ; this is needed on real drive, works in VICE without!
        clv

        ; read byte after sync
        BVC *           ; wait byte ready
        CLV             ; clear byte ready flag

        ; check if it's a header
        LDA $1C01
        cmp #$52
        bne -

        ; read rest of header
-
        BVC *           ; wait byte ready
        CLV             ; clear byte ready flag

        LDA $1C01
        STA $25,x

        INX
        CPX #$07
        BNE -

        jmp $F497       ; decode GCR $24- to $16-

} 
drivecode_end:

!if DOPLOT=1 {
    !src "plotter.asm"
}
