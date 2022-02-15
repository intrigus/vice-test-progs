; pc64-cmpiy.asm: specialized opcode test - Public Domain
; converted for the 1541-Testsuite by Wolfram Sang (Ninja/The Dreams)
; original PC64-Testsuite by Wolfgang Lorenz

		#include "1541-tests.inc"

		* = $0300

		.start_test
		ldx #$40
		stx $1c0e

		lda #%00011011
		sta db
		lda #%11000110
		sta ab
		lda #%10110001
		sta xb
		lda #%01101100
		sta yb
		lda #0
		sta pb
		tsx
		stx sb

		lda #0
		sta db
		sta ab
		sta yb
		lda #<da
tmp_zp1		= $2c
		sta tmp_zp1
		lda #>da
		sta tmp_zp1+1

next		lda db
		sta da
		sta dr

		lda ab
		sta ar
		sec
		sbc db
		php
		pla
		and #%10000011
		sta flags+1
		lda pb
		ora #%00110000
		and #%01111100
flags		ora #0
		sta pr

		lda xb
		sta xr

		lda yb
		sta yr

		lda sb
		sta sr

		ldx sb
		txs
		lda pb
		pha
		lda ab
		ldx xb
		ldy yb
		plp

cmd		cmp (tmp_zp1),y

		php
		cld
		sta aa
		stx xa
		sty ya
		pla
		sta pa
		tsx
		stx sa
		jsr check

		inc tmp_zp1
		bne noinc
		inc tmp_zp1+1
noinc		lda yb
		bne nodec
		dec tmp_zp1+1
nodec		dec yb

		clc
		lda db
		adc #17
		sta db
		bcc jmpnext
		lda #0
		sta db
		clc
		lda ab
		adc #17
		sta ab
		bcc jmpnext
		lda #0
		sta ab
		inc pb
		beq nonext
jmpnext		jmp next
nonext

		lda #0
test_exit
		sta test_result
		ldx #$c0
		stx $1c0e
		cli
		.end_test

db		.byte 0
ab		.byte 0
xb		.byte 0
yb		.byte 0
pb		.byte 0
sb		.byte 0
da		.byte 0
aa		.byte 0
xa		.byte 0
ya		.byte 0
pa		.byte 0
sa		.byte 0
dr		.byte 0
ar		.byte 0
xr		.byte 0
yr		.byte 0
pr		.byte 0
sr		.byte 0


check
		lda da
		cmp dr
		bne error
		lda aa
		cmp ar
		bne error
		lda xa
		cmp xr
		bne error
		lda ya
		cmp yr
		bne error
		lda pa
		cmp pr
		bne error
		lda sa
		cmp sr
		bne error
		rts

error
		pla
		pla
error_nopla
		lda pb
		sta test_errcode
errcode		lda #$ff
		jmp test_exit
