      *=$0801             ; basic start
      !WORD +
      !WORD 10
      !BYTE $9E
      !TEXT "2061"
      !BYTE 0
+     !WORD 0

	lda #$93
	jsr $ffd2

l3  bit $d011
	bpl l3
l4	bit $d011
	bmi l4
	
	lda $d011
	and #%11101111
	sta $d011	; disable screen
	
l5	bit $d011
	bpl l5
l6	bit $d011
	bmi l6

	ldx #10		; 10 times
loop
	sei

	; setup ICR and CRx
	lda #%0111111
	sta $dd0d	; disable interrupts

	lda $dd0e
	and #%10000000
	sta $dd0e	; stop TA (keep 50Hz flag)
	
	lda #%00000000	
	sta $dd0f	; stop TB

	lda #<50
	sta $dd04	; TA low
	lda #>50
	sta $dd05	; TA hi

	lda #<65530
	sta $dd06	; TB low
	lda #>65530
	sta $dd07	; TB hi
	
		; start TB
	lda $dd0f
	ora #%00010001	; force load and start TB
	sta $dd0f

	; setup SDR
	lda #%01010001	; TA started, force load, SDR output
	sta $dd0e

	lda #$55
	sta $dd0c	; send 

	; wait for SDR empty
	lda #%00001000
l1	bit $dd0d
	beq l1

	; save TB value
	lda $dd06
	pha
	lda $dd07
	jsr hexout
	pla
	jsr hexout

	lda #13
	jsr $ffd2

	cli

	dex
	bne loop

	lda $d011
	ora #%00010000
	sta $d011	; enable screen

	ldx #(5*40)
clp
	lda checkscreen-1,x
	and #$3f
	cmp $0400+(5*40)-1,x
	bne failed
	dex
	bne clp
	
	ldy #$00   ; pass
    sty $d7ff
    lda #13
    sta $d020
	jmp *
	
failed:
	ldy #$ff   ; fail
    sty $d7ff
    lda #10
    sta $d020
	jmp *

hexout	pha
	lsr
	lsr
	lsr
	lsr
	jsr nibout
	pla
	and #$0f
nibout	clc
	adc #246	; 0-9 -> 246-255,C=0; 10-15 -> 256-261=0-5,C=1
	bcc n1
	adc #$41-$3a-1
n1	sbc #246-$30-1
	jmp $ffd2

checkscreen
          ;1234567890123456789012345678901234567890
    !TEXT "FCEA                                    "
    !TEXT "FCEA                                    "
    !TEXT "FCEA                                    "
    !TEXT "FCEA                                    "
    !TEXT "FCEA                                    "
